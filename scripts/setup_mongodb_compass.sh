#!/bin/bash
# Setup script for MongoDB Compass desktop entry

set -euo pipefail

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source utilities
source "$SCRIPT_DIR/utils.sh"

# Define file locations
DESKTOP_FILE="/usr/share/applications/mongodb-compass.desktop"
WRAPPER_SCRIPT="/usr/local/bin/mongodb-compass-wrapper.sh"

# Main setup function
main() {
    header "🧭 MongoDB Compass Desktop Entry Setup"
    echo -e "${BLUE}Creating desktop entry for MongoDB Compass${NC}\n"

    # First check if MongoDB Compass is installed
    if ! command_exists mongodb-compass; then
        error "MongoDB Compass is not installed or not in PATH"
        return 1
    fi

    log_info "Setting up MongoDB Compass desktop entry..."

    # Create wrapper script first
    log_info "Creating wrapper script..."
    sudo tee "$WRAPPER_SCRIPT" > /dev/null << 'EOF'
#!/bin/bash
# Wrapper script for MongoDB Compass with Wayland environment variables

export XDG_CURRENT_DESKTOP=GNOME
export XDG_SESSION_DESKTOP=gnome
export GNOME_KEYRING_CONTROL="/run/user/$(id -u)/keyring"
export ELECTRON_OZONE_PLATFORM_HINT=wayland
export ELECTRON_IS_DEV=0
export NODE_ENV=production

exec /usr/bin/mongodb-compass "$@"
EOF

    # Make wrapper script executable
    sudo chmod +x "$WRAPPER_SCRIPT"

    # Create the desktop entry using the wrapper script
    log_info "Creating desktop entry..."
    sudo tee "$DESKTOP_FILE" > /dev/null << EOF
[Desktop Entry]
Name=MongoDB Compass
Comment=The MongoDB GUI
Exec=$WRAPPER_SCRIPT %U
Icon=mongodb-compass
Type=Application
StartupNotify=true
Categories=Office;Database;
MimeType=x-scheme-handler/mongodb;x-scheme-handler/mongodb+srv;
EOF

    # Update desktop database if available
    if command_exists update-desktop-database; then
        log_info "Updating desktop database..."
        sudo update-desktop-database /usr/share/applications/
    fi

    log "Desktop entry created at $DESKTOP_FILE"
    log "Setup complete!"
    log "You can now launch MongoDB Compass from your application launcher."
}

# Run setup
main "$@"