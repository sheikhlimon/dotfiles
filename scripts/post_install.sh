#!/bin/bash
# OMARCHY Post-Install Setup

set -euo pipefail

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source utilities
source "$SCRIPT_DIR/utils.sh"

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

    echo -e "\n5. ${BOLD}Customize for OMARCHY:${NC}"
    echo -e "   ${BLUE}Edit configs to match your workflow${NC}"

    echo -e "\n${GREEN}🎉 Setup complete! Make it your own.${NC}"
}

main() {
    header "🏠 OMARCHY Post-Install Setup"
    echo -e "${BLUE}Take anything and make it your own${NC}\n"

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
    ask_and_run "Install Oh My Zsh and plugins?" bash -c "source '$SCRIPT_DIR/utils.sh' && install_oh_my_zsh"
    ask_and_run "Install Tmux Plugin Manager?" bash -c "source '$SCRIPT_DIR/utils.sh' && install_tpm"

    # Setup MongoDB Compass desktop entry if installed
    if command_exists mongodb-compass; then
        echo -e "\n${YELLOW}🔧 Setup MongoDB Compass desktop entry? [y/N]:${NC}"
        read answer
        if [[ "$answer" =~ ^[Yy]$ ]]; then
            log_info "Setting up MongoDB Compass desktop entry..."

            local desktop_file="/usr/share/applications/mongodb-compass.desktop"
            local wrapper_script="/usr/local/bin/mongodb-compass-wrapper.sh"

            # Create wrapper script
            sudo tee "$wrapper_script" > /dev/null << 'EOF'
#!/bin/bash
export XDG_CURRENT_DESKTOP=GNOME
export XDG_SESSION_DESKTOP=gnome
export GNOME_KEYRING_CONTROL="/run/user/$(id -u)/keyring"
export ELECTRON_OZONE_PLATFORM_HINT=wayland
export ELECTRON_IS_DEV=0
export NODE_ENV=production
exec /usr/bin/mongodb-compass "$@"
EOF

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
        else
            warn "Skipped: MongoDB Compass desktop entry"
        fi
    fi

    # Show next steps
    show_next_steps
}

# Run the script
main "$@"