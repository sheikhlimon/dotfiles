#!/bin/bash
# Database setup script for MongoDB and PostgreSQL
# Supports Arch Linux and Debian/Ubuntu systems

set -e

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

log() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Detect OS
detect_os() {
    if [[ -f /etc/arch-release ]]; then
        echo "arch"
    elif [[ -f /etc/debian_version ]]; then
        echo "debian"
    else
        echo "unknown"
    fi
}

# Check if service exists and is enabled
is_service_enabled() {
    systemctl is-enabled "$1" >/dev/null 2>&1
}

# Check if service is running
is_service_running() {
    systemctl is-active "$1" >/dev/null 2>&1
}

# Setup MongoDB on Arch Linux
setup_mongodb_arch() {
    log "Setting up MongoDB on Arch Linux..."

    # Install MongoDB if not installed
    if ! pacman -Qi mongodb-bin >/dev/null 2>&1 && ! yay -Qi mongodb-bin >/dev/null 2>&1; then
        log "Installing MongoDB..."
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
            log "Enabling and starting MongoDB service ($mongo_service)..."
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
    log "Setting up PostgreSQL on Arch Linux..."

    # Install PostgreSQL if not installed
    if ! pacman -Qi postgresql >/dev/null 2>&1; then
        log "Installing PostgreSQL..."
        sudo pacman -S --needed postgresql
    else
        log "PostgreSQL already installed"
    fi

    # Check if PostgreSQL data directory is initialized
    if [[ -f /var/lib/postgres/data/PG_VERSION ]]; then
        log "PostgreSQL database already initialized"
    elif [[ ! -d /var/lib/postgres/data ]]; then
        log "Initializing PostgreSQL database..."
        sudo -iu postgres initdb --locale=en_US.UTF-8 -E UTF8 -D /var/lib/postgres/data
    else
        warn "PostgreSQL data directory exists but appears uninitialized"
        read -p "Remove and reinitialize PostgreSQL data directory? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            log "Removing corrupted data directory..."
            sudo rm -rf /var/lib/postgres/data/*
            log "Reinitializing PostgreSQL database..."
            sudo -iu postgres initdb --locale=en_US.UTF-8 -E UTF8 -D /var/lib/postgres/data
        else
            log "Skipping PostgreSQL initialization"
            return 0
        fi
    fi

    # Start and enable PostgreSQL service
    if ! is_service_running postgresql; then
        log "Enabling and starting PostgreSQL service..."
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
    log "PostgreSQL setup completed. You can create users and databases with:"
    log "  sudo -iu postgres createuser -s your_username"
    log "  sudo -iu postgres createdb -O your_username your_database"
}

# Setup MongoDB on Debian/Ubuntu
setup_mongodb_debian() {
    log "Setting up MongoDB on Debian/Ubuntu..."

    # Check if MongoDB repository is already added
    if ! grep -q "mongodb.org" /etc/apt/sources.list.d/mongodb-org-*.list 2>/dev/null; then
        log "Adding MongoDB repository..."

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
    if ! dpkg -s mongodb-org >/dev/null 2>&1; then
        log "Installing MongoDB..."
        sudo apt install -y mongodb-org
    else
        log "MongoDB already installed"
    fi

    # Start and enable MongoDB service
    if ! is_service_running mongod; then
        log "Enabling and starting MongoDB service..."
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
    log "Setting up PostgreSQL on Debian/Ubuntu..."

    # Install PostgreSQL if not installed
    if ! dpkg -s postgresql >/dev/null 2>&1; then
        log "Installing PostgreSQL..."
        sudo apt install -y postgresql postgresql-contrib
    else
        log "PostgreSQL already installed"
    fi

    # Start and enable PostgreSQL service
    if ! is_service_running postgresql; then
        log "Enabling and starting PostgreSQL service..."
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

    log "PostgreSQL setup completed. You can create users and databases with:"
    log "  sudo -u postgres createuser -s your_username"
    log "  sudo -u postgres createdb -O your_username your_database"
}

# Test database connections
test_connections() {
    log "Testing database connections..."

    # Test MongoDB
    if command -v mongosh >/dev/null 2>&1; then
        if mongosh --eval "db.adminCommand('ping')" >/dev/null 2>&1; then
            log "✓ MongoDB connection test passed"
        else
            warn "✗ MongoDB connection test failed"
        fi
    else
        warn "mongosh not available, skipping MongoDB connection test"
    fi

    # Test PostgreSQL
    if command -v psql >/dev/null 2>&1; then
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
            log "Setting up databases on Arch Linux..."
            setup_mongodb_arch
            setup_postgresql_arch
            ;;

        debian)
            log "Setting up databases on Debian/Ubuntu..."
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

    log "Database setup completed!"
}

# Show database information
show_database_info() {
    log ""
    log "=== Database Information ==="
    log ""
    log "MongoDB:"
    log "  - Configuration file: /etc/mongod.conf"
    log "  - Data directory: /var/lib/mongodb"
    log "  - Log file: /var/log/mongodb/mongod.log"
    log "  - Default port: 27017"
    log "  - Connect with: mongosh"
    log ""
    log "PostgreSQL:"
    log "  - Configuration file: /etc/postgresql/*/main/postgresql.conf"
    log "  - Data directory: /var/lib/postgresql/*/main"
    log "  - Log directory: /var/log/postgresql/"
    log "  - Default port: 5432"
    log "  - Connect with: sudo -u postgres psql"
    log ""
    log "Service Management:"
    log "  - Start/Stop: sudo systemctl start/stop [service]"
    log "  - Enable/Disable: sudo systemctl enable/disable [service]"
    log "  - Status: sudo systemctl status [service]"
    log ""
}

# Main script execution
main() {
    log "Starting database setup..."

    setup_databases
    show_database_info

    log "All database setup tasks completed!"
}

# Run the script if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi