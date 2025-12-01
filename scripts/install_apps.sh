#!/bin/bash

set -euo pipefail

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source utilities
source "$SCRIPT_DIR/utils.sh"

# Main installation function
install_apps() {
    log_info "Detected Arch Linux"

    # Official packages
    local arch_official=(
        kitty
        mpv
        okular
        neovim
        haruna
        mise
        git
        curl
        wget
        zsh
        tmux
        eza
        fd
        bat
        fzf
        zoxide
        trash-cli
        tree
        duf
        multitail
        yazi
    )

    # AUR packages
    local arch_aur=(
        visual-studio-code-bin
        mongodb-compass-bin
        postman-bin
        foliate
        ghostty
        zen-browser-bin
        vivaldi
        telegram-desktop-bin
        ttf-victor-mono-nerd
        bibata-cursor-theme-bin
    )

    # Update system
    sudo pacman -Syu --needed

    # Install packages
    install_arch_packages "${arch_official[@]}"
    install_aur_packages "${arch_aur[@]}"

    log_info "Application installation completed successfully!"
}

# Main script execution
main() {
    header "🚀 Application Installation"
    echo -e "${BLUE}Installing development apps and utilities${NC}\n"

    # Check we have basic tools
    check_dependencies

    # Install applications
    install_apps

    log_info "All applications installed successfully!"
}

# Run the script
main "$@"
