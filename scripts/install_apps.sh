#!/bin/bash
# Comprehensive app installer script
# Supports Arch Linux and Debian/Ubuntu systems

set -e

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source utilities
source "$SCRIPT_DIR/utils.sh"

# Install Yazi manually for Debian
install_yazi_debian() {
    if command_exists yazi; then
        log "yazi already installed"
        return 0
    fi

    log_info "Installing yazi from GitHub releases..."
    local temp_dir=$(mktemp -d)
    cd "$temp_dir"

    local arch=$(uname -m)
    case $arch in
        x86_64) local yazi_file="yazi_amd64.deb" ;;
        aarch64) local yazi_file="yazi_arm64.deb" ;;
        *)
            error "Unsupported architecture: $arch"
            rm -rf "$temp_dir"
            return 1
            ;;
    esac

    if curl -L "https://github.com/sxyazi/yazi/releases/latest/download/$yazi_file" -o "$yazi_file"; then
        sudo dpkg -i "$yazi_file"
        sudo apt install -y -f  # Fix any missing dependencies
        log "yazi installed successfully"
    else
        error "Failed to download yazi"
        rm -rf "$temp_dir"
        return 1
    fi

    rm -rf "$temp_dir"
}


# Main installation function
install_apps() {
    local os=$(detect_os)

    case $os in
        arch)
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
                tumbler
                ffmpegthumbnailer
                poppler
            )

            # Update system
            sudo pacman -Syu --needed

            # Install packages
            install_arch_packages "${arch_official[@]}"
            install_aur_packages "${arch_aur[@]}"
            ;;

        debian)
            log_info "Detected Debian/Ubuntu"

            # Official packages
            local debian_official=(
                kitty
                discord
                telegram-desktop
                mpv
                okular
                neovim
                haruna
                vivaldi
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
                ffmpegthumbnailer
                poppler-utils
            )

            # Snap packages
            local debian_snap=(
                code
                postman
                zoom-client
            )

            # Install packages
            install_debian_packages "${debian_official[@]}"
            install_snap_packages "${debian_snap[@]}"
            install_yazi_debian
            ;;

        *)
            error "Unsupported operating system"
            return 1
            ;;
    esac

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

    # Install Oh My Zsh
    install_oh_my_zsh

    # Install TPM
    install_tpm

    log_info "All installations completed successfully!"
}

# Run the script
main "$@"