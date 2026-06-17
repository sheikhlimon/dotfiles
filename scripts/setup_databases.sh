#!/bin/bash
# Database setup script for MongoDB and PostgreSQL
# Supports Arch Linux and Fedora

set -euo pipefail

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source utilities
source "$SCRIPT_DIR/utils.sh"

# Detect OS
OS_TYPE=$(detect_os)

# Setup MongoDB
setup_mongodb() {
    log_info "Setting up MongoDB on $OS_TYPE..."

    case "$OS_TYPE" in
        arch)
            local pkg="mongodb-bin"
            local svc="mongodb"
            if ! is_arch_pkg_installed "$pkg"; then
                log_info "Installing MongoDB..."
                yay -S --needed "$pkg"
            else
                log "MongoDB already installed"
            fi
            ;;
        fedora)
            local pkg="mongodb-server"
            local svc="mongod"
            if ! is_fedora_pkg_installed "$pkg"; then
                log_info "Installing MongoDB..."
                sudo dnf install -y "$pkg"
            else
                log "MongoDB already installed"
            fi
            ;;
        *)
            error "Unsupported OS: $OS_TYPE"
            return 1
            ;;
    esac

    # Verify service exists
    if [[ ! -f "/usr/lib/systemd/system/${svc}.service" ]] && [[ ! -f "/etc/systemd/system/${svc}.service" ]]; then
        error "MongoDB service file not found. Package may not be properly installed."
        return 1
    fi

    if ! is_service_running "$svc"; then
        log_info "Enabling and starting MongoDB service ($svc)..."
        sudo systemctl enable --now "$svc"

        sleep 3

        if is_service_running "$svc"; then
            log "MongoDB service started successfully"
        else
            error "Failed to start MongoDB service"
            return 1
        fi
    else
        log "MongoDB service already running"
    fi
}

# Setup PostgreSQL on Arch Linux
setup_postgresql() {
    log_info "Setting up PostgreSQL on $OS_TYPE..."

    local pg_pkg pg_svc pg_data_dir pg_user

    case "$OS_TYPE" in
        arch)
            pg_pkg="postgresql"
            pg_svc="postgresql"
            pg_data_dir="/var/lib/postgres/data"
            pg_user="postgres"
            if ! is_arch_pkg_installed "$pg_pkg"; then
                log_info "Installing PostgreSQL..."
                sudo pacman -S --needed "$pg_pkg"
            else
                log "PostgreSQL already installed"
            fi
            ;;
        fedora)
            pg_pkg="postgresql-server"
            pg_svc="postgresql"
            pg_data_dir="/var/lib/pgsql/data"
            pg_user="postgres"
            if ! is_fedora_pkg_installed "$pg_pkg"; then
                log_info "Installing PostgreSQL..."
                sudo dnf install -y "$pg_pkg"
            else
                log "PostgreSQL already installed"
            fi
            ;;
        *)
            error "Unsupported OS: $OS_TYPE"
            return 1
            ;;
    esac

    # Initialize database if not already initialized
    if [[ ! -f "$pg_data_dir/PG_VERSION" ]]; then
        log_info "Initializing PostgreSQL database..."
        if sudo -u "$pg_user" initdb -D "$pg_data_dir" 2>/dev/null; then
            log "PostgreSQL database initialized successfully"
        else
            warn "PostgreSQL database initialization failed - checking if service can still start"
        fi
    else
        log "PostgreSQL database already initialized"

        # Check if the data version matches current PostgreSQL version
        local current_version=$(psql --version 2>/dev/null | awk '{print $3}' | cut -d. -f1,2 || echo "unknown")
        local data_version=$(cat "$pg_data_dir/PG_VERSION" 2>/dev/null || echo "unknown")

        if [[ "$current_version" != "$data_version" && "$data_version" != "unknown" ]]; then
            warn "⚠ PostgreSQL version mismatch detected!"
            log_info "  - Current PostgreSQL version: $current_version"
            log_info "  - Database data version: $data_version"
            log_info ""
            log_info "This commonly happens after PostgreSQL system updates."
            log_info "Would you like to reset PostgreSQL data (THIS WILL DELETE ALL DATA)?"
            echo -e "${YELLOW}⚠ Reset PostgreSQL data? [y/N]:${NC} "
            read -r reset_answer
            if [[ "$reset_answer" =~ ^[Yy]$ ]]; then
                log_info "Backing up existing data to /tmp/postgres_backup_$(date +%s)..."
                sudo cp -r "$pg_data_dir" "/tmp/postgres_backup_$(date +%s)" 2>/dev/null || true

                log_info "Removing old PostgreSQL data..."
                sudo rm -rf "$pg_data_dir"

                log_info "Initializing new PostgreSQL database..."
                if sudo -u "$pg_user" initdb -D "$pg_data_dir" 2>/dev/null; then
                    log "✓ PostgreSQL database reset and reinitialized successfully"
                else
                    error "Failed to initialize PostgreSQL database"
                    return 1
                fi
            else
                warn "Skipping PostgreSQL data reset - service may not start"
            fi
        fi
    fi

    # Start and enable PostgreSQL service
    if ! is_service_running "$pg_svc"; then
        log_info "Enabling and starting PostgreSQL service..."

        if sudo systemctl start "$pg_svc"; then
            sudo systemctl enable "$pg_svc"
            sleep 2
            if is_service_running "$pg_svc"; then
                log "PostgreSQL service started successfully"
            else
                error "PostgreSQL service started but not responding"
                return 1
            fi
        else
            error "Failed to start PostgreSQL service - run 'sudo journalctl -xeu $pg_svc.service' for details"
            return 1
        fi
    else
        log "PostgreSQL service already running"
    fi
}

# Test database connections
test_connections() {
    echo ""
    log_info "=== Testing Database Connections ==="

    # Test MongoDB
    if command_exists mongosh; then
        if mongosh --eval "db.adminCommand('ping')" >/dev/null 2>&1; then
            log "✓ MongoDB connection successful"
        else
            warn "⚠ MongoDB connection failed"
        fi
    else
        warn "⚠ mongosh not found"
    fi

    # Test PostgreSQL
    if command_exists psql; then
        if sudo -u postgres psql -c "SELECT 1;" >/dev/null 2>&1; then
            log "✓ PostgreSQL connection successful (system service)"
        else
            warn "⚠ PostgreSQL connection failed"
        fi
    else
        warn "⚠ psql not found"
    fi
}

# Show database information
show_database_info() {
    local pg_data_dir pg_conf_dir pg_svc_name

    case "$OS_TYPE" in
        arch)
            pg_data_dir="/var/lib/postgres/data"
            pg_conf_dir="/var/lib/postgres/data"
            pg_svc_name="postgresql"
            ;;
        fedora)
            pg_data_dir="/var/lib/pgsql/data"
            pg_conf_dir="/var/lib/pgsql/data"
            pg_svc_name="postgresql"
            ;;
        *)
            pg_data_dir="/var/lib/postgres/data"
            pg_conf_dir="/var/lib/postgres/data"
            pg_svc_name="postgresql"
            ;;
    esac

    echo ""
    log_info "=== Database Information ==="
    echo ""
    log_info "MongoDB:"
    log_info "  - Service: mongod"
    log_info "  - Data directory: /var/lib/mongodb"
    log_info "  - Log file: /var/log/mongodb/mongod.log"
    log_info "  - Default port: 27017"
    log_info "  - Shell command: mongosh"
    echo ""
    log_info "PostgreSQL:"
    log_info "  - Service: $pg_svc_name"
    log_info "  - Data directory: $pg_data_dir"
    log_info "  - Configuration: $pg_conf_dir/postgresql.conf"
    log_info "  - Unix socket: /run/postgresql/.s.PGSQL.5432"
    log_info "  - Default port: 5432"
    log_info "  - Shell command: psql"
    log_info "  - Superuser: postgres"
    echo ""
    log_info "To manage PostgreSQL:"
    log_info "  - Status: sudo systemctl status postgresql"
    log_info "  - Connect: sudo -u postgres psql"
    log_info "  - Create user: sudo -u postgres createuser -d -P username"
}

# Main setup function
main() {
    header "🗄️  Database Setup"
    echo -e "${BLUE}Setting up MongoDB and PostgreSQL on $OS_TYPE${NC}\n"

    # Check we have basic tools
    check_dependencies

    # Detect OS if not set
    if [[ -z "${OS_TYPE:-}" ]]; then
        OS_TYPE=$(detect_os)
    fi

    log_info "Setting up databases on $OS_TYPE..."
    setup_mongodb
    setup_postgresql

    # Test connections after setup
    test_connections

    # Show database information
    show_database_info

    log_info "Database setup completed!"
}

# Run the script
main "$@"