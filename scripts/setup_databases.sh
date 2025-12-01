#!/bin/bash
# Database setup script for MongoDB and PostgreSQL
# Arch Linux only

set -euo pipefail

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source utilities
source "$SCRIPT_DIR/utils.sh"

# Setup MongoDB on Arch Linux
setup_mongodb() {
    log_info "Setting up MongoDB on Arch Linux..."

    # Install MongoDB if not installed
    if ! is_arch_pkg_installed mongodb-bin; then
        log_info "Installing MongoDB..."
        yay -S --needed mongodb-bin
    else
        log "MongoDB already installed"
    fi

    # Detect MongoDB service name
    local mongo_service="mongodb"  # Default for Arch Linux mongodb-bin

    # Verify service exists (check file directly, no sudo needed)
    if [[ ! -f "/usr/lib/systemd/system/mongodb.service" ]]; then
        error "MongoDB service file not found. mongodb-bin package may not be properly installed."
        return 1
    fi

    if [[ -n "$mongo_service" ]]; then
        if ! is_service_running "$mongo_service"; then
            log_info "Enabling and starting MongoDB service ($mongo_service)..."
            sudo systemctl enable --now "$mongo_service"

            # Wait for service to start
            sleep 3

            if is_service_running "$mongo_service"; then
                log "MongoDB service started successfully"
            else
                error "Failed to start MongoDB service"
                return 1
            fi
        else
            log "MongoDB service already running"
        fi
    else
        error "MongoDB service not found. Installation may have failed."
        return 1
    fi
}

# Setup PostgreSQL on Arch Linux
setup_postgresql() {
    log_info "Setting up PostgreSQL on Arch Linux..."

    # Install PostgreSQL if not installed
    if ! is_arch_pkg_installed postgresql; then
        log_info "Installing PostgreSQL..."
        sudo pacman -S --needed postgresql
    else
        log "PostgreSQL already installed"
    fi

    # Initialize database if not already initialized
    # Check for PostgreSQL version file to detect initialized database
    if [[ ! -f /var/lib/postgres/data/PG_VERSION ]]; then
        log_info "Initializing PostgreSQL database..."
        if sudo -u postgres initdb -D /var/lib/postgres/data; then
            log "PostgreSQL database initialized successfully"
        else
            warn "PostgreSQL database initialization failed - checking if service can still start"
        fi
    else
        log "PostgreSQL database already initialized"

        # Check if the data version matches current PostgreSQL version
        local current_version=$(psql --version | awk '{print $3}' | cut -d. -f1,2)
        local data_version=$(cat /var/lib/postgres/data/PG_VERSION 2>/dev/null || echo "unknown")

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
                sudo cp -r /var/lib/postgres/data "/tmp/postgres_backup_$(date +%s)" 2>/dev/null || true

                log_info "Removing old PostgreSQL data..."
                sudo rm -rf /var/lib/postgres/data

                log_info "Initializing new PostgreSQL database..."
                if sudo -u postgres initdb -D /var/lib/postgres/data; then
                    log "✓ PostgreSQL database reset and reinitialized successfully"
                else
                    error "Failed to initialize PostgreSQL database"
                    return 1
                fi
            else
                warn "Skipping PostgreSQL data reset - service may not start"
                log_info "You can manually upgrade using: pg_upgradecluster"
                log_info "Or reset later with: sudo rm -rf /var/lib/postgres/data && sudo -u postgres initdb -D /var/lib/postgres/data"
            fi
        fi
    fi

    # Start and enable PostgreSQL service (standard system service)
    if ! is_service_running postgresql; then
        log_info "Enabling and starting PostgreSQL system service..."

        # Try to start the service
        if sudo systemctl start postgresql; then
            sudo systemctl enable postgresql
            sleep 2
            if is_service_running postgresql; then
                log "PostgreSQL system service started successfully"
            else
                error "PostgreSQL service started but not responding"
                return 1
            fi
        else
            # Check if it's a version mismatch issue
            log_info "Checking PostgreSQL service failure..."
            if journalctl -u postgresql.service --no-pager -n 5 2>/dev/null | grep -q "old version of database format"; then
                warn "⚠ PostgreSQL database format upgrade needed!"
                log_info "Run: sudo -u postgres pg_upgradecluster $(ls /usr/bin/postgres*-bin | head -1 | sed 's/.*postgres\([0-9]*\).*/\1/') old"
                log_info "Or follow: https://wiki.archlinux.org/index.php/PostgreSQL#Upgrading_PostgreSQL"
                log_info "For now, you can use MongoDB which is working properly"
            else
                error "Failed to start PostgreSQL service - run 'sudo journalctl -xeu postgresql.service' for details"
            fi
            return 1
        fi
    else
        log "PostgreSQL system service already running"
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
    echo ""
    log_info "=== Database Information ==="
    echo ""
    log_info "MongoDB:"
    log_info "  - Configuration file: /etc/mongod.conf"
    log_info "  - Data directory: /var/lib/mongodb"
    log_info "  - Log file: /var/log/mongodb/mongod.log"
    log_info "  - Default port: 27017"
    log_info "  - Shell command: mongosh"
    echo ""
    log_info "PostgreSQL (system service):"
    log_info "  - Configuration file: /var/lib/postgres/data/postgresql.conf"
    log_info "  - Data directory: /var/lib/postgres/data"
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
    echo -e "${BLUE}Setting up MongoDB and PostgreSQL${NC}\n"

    # Check we have basic tools
    check_dependencies

    log_info "Setting up databases on Arch Linux..."
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