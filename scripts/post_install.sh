#!/bin/bash
# Post-Install Setup - Cross-distro

set -euo pipefail

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source utilities
source "$SCRIPT_DIR/utils.sh"

# Detect OS
OS_TYPE=$(detect_os)

show_next_steps() {
    header "🚀 Next Steps"

    echo -e "1. ${BOLD}Set Zsh as default shell:${NC}"
    echo -e "   ${BLUE}chsh -s \$(which zsh)${NC}"

    echo -e "\n2. ${BOLD}Restart your shell${NC} or run:"
    echo -e "   ${BLUE}source ~/.zshrc${NC}"

    echo -e "\n3. ${BOLD}In tmux, install plugins:${NC}"
    echo -e "   ${BLUE}prefix + I${NC}"

    echo -e "\n4. ${BOLD}Stow your dotfiles:${NC}"
    echo -e "   ${BLUE}cd ~/.dotfiles && stow */${NC}"

    echo -e "\n5. ${BOLD}Customize for your workflow:${NC}"
    echo -e "   ${BLUE}Edit configs to match your workflow${NC}"

    echo -e "\n${GREEN}🎉 Setup complete! Make it your own.${NC}"
}

main() {
    header "🏠 Post-Install Setup"
    echo -e "${BLUE}Detected OS: $OS_TYPE${NC}\n"

    # Check we have basic tools
    check_dependencies

    # Show what's available
    echo -e "${BLUE}ℹ Available setup modules:${NC}"
    echo "  📦 Development apps (VS Code, browsers, tools)"
    echo "  🗄️  Databases (MongoDB + PostgreSQL)"
    echo "  🐚 Shell setup (Oh My Zsh + plugins)"
    echo "  🔧 Optional desktop entries"

    # Run setup modules
    ask_and_run "Install development apps?" "install_apps.sh"
    ask_and_run "Setup MongoDB and PostgreSQL databases?" "setup_databases.sh"

    # Install Oh My Zsh and plugins
    ask_and_run "Install Oh My Zsh and plugins?" bash -c "source '$SCRIPT_DIR/utils.sh' && install_oh_my_zsh || { echo 'OMZ install failed'; exit 1; }"
    ask_and_run "Install Tmux Plugin Manager?" bash -c "source '$SCRIPT_DIR/utils.sh' && install_tpm || { echo 'TPM install failed'; exit 1; }"

    # Setup MongoDB Compass desktop entry if installed
    if command_exists mongodb-compass || command_exists mongodb-compass-wrapper.sh; then
        echo -e "\n${YELLOW}🔧 Setup MongoDB Compass desktop entry? [y/N]:${NC}"
        read answer
        if [[ "$answer" =~ ^[Yy]$ ]]; then
            log_info "Setting up MongoDB Compass desktop entry..."

            local desktop_file="/usr/share/applications/mongodb-compass.desktop"
            local wrapper_script="/usr/local/bin/mongodb-compass-wrapper.sh"

            # Determine actual binary path
            local compass_bin=""
            if command_exists mongodb-compass; then
                compass_bin="/usr/bin/mongodb-compass"
            elif [[ -f "/usr/bin/mongodb-compass" ]]; then
                compass_bin="/usr/bin/mongodb-compass"
            fi

            if [[ -z "$compass_bin" ]]; then
                warn "MongoDB Compass binary not found, skipping desktop entry"
            else
                # Create wrapper script
                sudo tee "$wrapper_script" > /dev/null << 'WRAPPER'
#!/bin/bash
export XDG_CURRENT_DESKTOP=GNOME
export XDG_SESSION_DESKTOP=gnome
export GNOME_KEYRING_CONTROL="/run/user/$(id -u)/keyring"
export ELECTRON_OZONE_PLATFORM_HINT=wayland
export ELECTRON_IS_DEV=0
export NODE_ENV=production
exec /usr/bin/mongodb-compass "$@"
WRAPPER

                sudo chmod +x "$wrapper_script"

                # Create desktop entry
                sudo tee "$desktop_file" > /dev/null << EOF
[Desktop Entry]
Name=MongoDB Compass
Comment=The MongoDB GUI
Exec=$wrapper_script %U
Icon=mongodb-compass
Type=Application
StartupNotify=true
Categories=Office;Database;
MimeType=x-scheme-handler/mongodb;x-scheme-handler/mongodb+srv;
EOF

                if command_exists update-desktop-database; then
                    sudo update-desktop-database /usr/share/applications/
                fi

                log "MongoDB Compass desktop entry created successfully!"
            fi
        else
            warn "Skipped: MongoDB Compass desktop entry"
        fi
    fi

    # Show next steps
    show_next_steps
}

# Run the script
main "$@"