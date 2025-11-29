#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WRAPPER_SCRIPT="$SCRIPT_DIR/mongodb-compass-wrapper.sh"
DESKTOP_FILE="/usr/share/applications/mongodb-compass.desktop"

# Setup wrapper if not already configured
if ! grep -q "$WRAPPER_SCRIPT" "$DESKTOP_FILE" 2>/dev/null; then
    echo "Setting up MongoDB Compass wrapper..."
    [[ -f "$DESKTOP_FILE" ]] && sudo cp "$DESKTOP_FILE" "${DESKTOP_FILE}.backup"

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

    command -v update-desktop-database >/dev/null 2>&1 && sudo update-desktop-database /usr/share/applications/
    echo "Setup complete!"
fi

# Launch MongoDB Compass with Wayland support
export XDG_CURRENT_DESKTOP=GNOME
export XDG_SESSION_DESKTOP=gnome
export GNOME_KEYRING_CONTROL=/run/user/$(id -u)/keyring
export ELECTRON_OZONE_PLATFORM_HINT=wayland
export ELECTRON_IS_DEV=0
export NODE_ENV=production

exec /usr/bin/mongodb-compass --ignore-additional-command-line-flags "$@"
