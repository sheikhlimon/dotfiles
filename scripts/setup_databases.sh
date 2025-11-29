#!/bin/bash
# Database setup script for MongoDB and PostgreSQL
# Supports Arch Linux and Debian/Ubuntu systems

set -e

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source utilities
source "$SCRIPT_DIR/utils.sh"

# Setup MongoDB on Arch Linux
setup_mongodb_arch() {
    log_info "Setting up MongoDB on Arch Linux..."

    # Install MongoDB if not installed
    if ! is_arch_pkg_installed mongodb-bin; then
        log_info "Installing MongoDB..."
        yay -S --needed mongodb-bin
    else
        log "MongoDB already installed"
    fi

    # Detect MongoDB service name
    local mongo_service=""
    if systemctl list-unit-files | grep -q "^mongod.service"; then
        mongo_service="mongod"
    elif systemctl list-unit-files | grep -q "^mongodb.service"; then
        mongo_service="mongodb"
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
        warn "MongoDB service not found. You may need to start it manually."
    fi
}

# Setup PostgreSQL on Arch Linux
setup_postgresql_arch() {
    log_info "Setting up PostgreSQL on Arch Linux..."

    # Install PostgreSQL if not installed
    if ! is_arch_pkg_installed postgresql; then
        log_info "Installing PostgreSQL..."
        sudo pacman -S --needed postgresql
    else
        log "PostgreSQL already installed"
    fi

    # Check if PostgreSQL data directory is initialized
    if [[ -f /var/lib/postgres/data/PG_VERSION ]]; then
        log "PostgreSQL database already initialized"
    elif [[ ! -d /var/lib/postgres/data ]]; then
        log_info "Initializing PostgreSQL database..."
        sudo -iu postgres initdb --locale=en_US.UTF-8 -E UTF8 -D /var/lib/postgres/data
    else
        warn "PostgreSQL data directory exists but appears uninitialized"
        read -p "Remove and reinitialize PostgreSQL data directory? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            log_info "Removing corrupted data directory..."
            sudo rm -rf /var/lib/postgres/data/*
            log_info "Reinitializing PostgreSQL database..."
            sudo -iu postgres initdb --locale=en_US.UTF-8 -E UTF8 -D /var/lib/postgres/data
        else
            log "Skipping PostgreSQL initialization"
            return 0
        fi
    fi

    # Start and enable PostgreSQL service
    if ! is_service_running postgresql; then
        log_info "Enabling and starting PostgreSQL service..."
        sudo systemctl enable --now postgresql

        # Wait for service to start
        sleep 3

        if is_service_running postgresql; then
            log "PostgreSQL service started successfully"
        else
            error "Failed to start PostgreSQL service"
            return 1
        fi
    else
        log "PostgreSQL service already running"
    fi

    # Create user if needed (optional)
    log_info "PostgreSQL setup completed. You can create users and databases with:"
    log_info "  sudo -iu postgres createuser -s your_username"
    log_info "  sudo -iu postgres createdb -O your_username your_database"
}

# Setup MongoDB on Debian/Ubuntu
setup_mongodb_debian() {
    log_info "Setting up MongoDB on Debian/Ubuntu..."

    # Check if MongoDB repository is already added
    if ! grep -q "mongodb.org" /etc/apt/sources.list.d/mongodb-org-*.list 2>/dev/null; then
        log_info "Adding MongoDB repository..."

        # Import MongoDB public key
        curl -fsSL https://www.mongodb.org/static/pgp/server-7.0.asc | \
            sudo gpg -o /usr/share/keyrings/mongodb-server-7.0.gpg --dearmor

        # Add repository
        echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-7.0.gpg ] \
            https://repo.mongodb.org/apt/ubuntu $(lsb_release -cs)/mongodb-org/7.0 multiverse" | \
            sudo tee /etc/apt/sources.list.d/mongodb-org-7.0.list

        sudo apt update
    fi

    # Install MongoDB if not installed
    if ! is_debian_pkg_installed mongodb-org; then
        log_info "Installing MongoDB..."
        sudo apt install -y mongodb-org
    else
        log "MongoDB already installed"
    fi

    # Start and enable MongoDB service
    if ! is_service_running mongod; then
        log_info "Enabling and starting MongoDB service..."
        sudo systemctl enable --now mongod

        # Wait for service to start
        sleep 5

        if is_service_running mongod; then
            log "MongoDB service started successfully"
        else
            error "Failed to start MongoDB service"
            return 1
        fi
    else
        log "MongoDB service already running"
    fi
}

# Setup PostgreSQL on Debian/Ubuntu
setup_postgresql_debian() {
    log_info "Setting up PostgreSQL on Debian/Ubuntu..."

    # Install PostgreSQL if not installed
    if ! is_debian_pkg_installed postgresql; then
        log_info "Installing PostgreSQL..."
        sudo apt install -y postgresql postgresql-contrib
    else
        log "PostgreSQL already installed"
    fi

    # Start and enable PostgreSQL service
    if ! is_service_running postgresql; then
        log_info "Enabling and starting PostgreSQL service..."
        sudo systemctl enable --now postgresql

        # Wait for service to start
        sleep 3

        if is_service_running postgresql; then
            log "PostgreSQL service started successfully"
        else
            error "Failed to start PostgreSQL service"
            return 1
        fi
    else
        log "PostgreSQL service already running"
    fi

    log_info "PostgreSQL setup completed. You can create users and databases with:"
    log_info "  sudo -u postgres createuser -s your_username"
    log_info "  sudo -u postgres createdb -O your_username your_database"
}

# Test database connections
test_connections() {
    log_info "Testing database connections..."

    # Test MongoDB
    if command_exists mongosh; then
        if mongosh --eval "db.adminCommand('ping')" >/dev/null 2>&1; then
            log "✓ MongoDB connection test passed"
        else
            warn "✗ MongoDB connection test failed"
        fi
    else
        warn "mongosh not available, skipping MongoDB connection test"
    fi

    # Test PostgreSQL
    if command_exists psql; then
        if sudo -u postgres psql -c "SELECT 1;" >/dev/null 2>&1; then
            log "✓ PostgreSQL connection test passed"
        else
            warn "✗ PostgreSQL connection test failed"
        fi
    else
        warn "psql not available, skipping PostgreSQL connection test"
    fi
}

# Main setup function
setup_databases() {
    local os=$(detect_os)

    case $os in
        arch)
            log_info "Setting up databases on Arch Linux..."
            setup_mongodb_arch
            setup_postgresql_arch
            ;;

        debian)
            log_info "Setting up databases on Debian/Ubuntu..."
            setup_mongodb_debian
            setup_postgresql_debian
            ;;

        *)
            error "Unsupported operating system"
            return 1
            ;;
    esac

    # Test connections after setup
    test_connections

    log_info "Database setup completed!"
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
    log_info "  - Connect with: mongosh"
    echo ""
    log_info "PostgreSQL:"
    log_info "  - Configuration file: /etc/postgresql/*/main/postgresql.conf"
    log_info "  - Data directory: /var/lib/postgresql/*/main"
    log_info "  - Log directory: /var/log/postgresql/"
    log_info "  - Default port: 5432"
    log_info "  - Connect with: sudo -u postgres psql"
    echo ""
    log_info "Service Management:"
    log_info "  - Start/Stop: sudo systemctl start/stop [service]"
    log_info "  - Enable/Disable: sudo systemctl enable/disable [service]"
    log_info "  - Status: sudo systemctl status [service]"
    echo ""
}

# Main script execution
main() {
    header "🗄️ Database Setup"
    echo -e "${BLUE}Installing and configuring MongoDB and PostgreSQL${NC}\n"

    # Check we have basic tools
    check_dependencies

    setup_databases
    show_database_info

    log_info "All database setup tasks completed!"
}

# Run the script if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi