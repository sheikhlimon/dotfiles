#!/bin/bash

set -euo pipefail

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source utilities
source "$SCRIPT_DIR/utils.sh"

# Detect OS
OS_TYPE=$(detect_os)

# Main installation function
install_apps() {
    log_info "Detected OS: $OS_TYPE"

    case "$OS_TYPE" in
        arch)
            install_arch
            ;;
        fedora)
            install_fedora
            ;;
        *)
            error "Unsupported OS: $OS_TYPE"
            exit 1
            ;;
    esac

    log_info "Application installation completed successfully!"
}

install_arch() {
    # Official packages
    local arch_official=(
        kitty
        mpv
        okular
        neovim
        haruna
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
        ffmpeg
        imagemagick
        bc
        gpu-screen-recorder
        httpie
        jetbrains-mono-fonts
    )

    # AUR packages
    local arch_aur=(
        visual-studio-code-bin
        mongodb-compass-bin
        foliate
        ghostty
        zen-browser-bin
        telegram-desktop-bin
        ttf-jetbrains-mono-nerd
        bibata-cursor-theme-bin
    )

    # Update system
    sudo pacman -Syu --needed

    # Install packages
    install_arch_packages "${arch_official[@]}"
    install_aur_packages "${arch_aur[@]}"
}

install_fedora() {
    # DNF packages
    local fedora_pkgs=(
        kitty
        mpv
        neovim
        git
        curl
        wget
        zsh
        tmux
        eza
        fd-find
        bat
        fzf
        zoxide
        trash-cli
        tree
        duf
        multitail
        yazi
        ffmpeg
        ImageMagick
        bc
        httpie
        jetbrains-mono-fonts
        jetbrains-mono-nf-fonts
    )

    # Third-party / COPR packages (best-effort)
    # gpu-screen-recorder may need RPM Fusion / COPR depending on Fedora version
    local copr_pkgs=(
        vivaldi
        telegram-desktop
        gpu-screen-recorder
    )

    # Update system
    sudo dnf check-update || true

    # Install packages
    local to_install=()
    for pkg in "${fedora_pkgs[@]}"; do
        if ! is_fedora_pkg_installed "$pkg"; then
            to_install+=("$pkg")
        else
            log "$pkg already installed"
        fi
    done

    if [[ ${#to_install[@]} -gt 0 ]]; then
        log_info "Installing Fedora packages: ${to_install[*]}"
        sudo dnf install -y "${to_install[@]}"
    fi

    # fd-find provides `fd` as `fd` on Fedora? No - it provides `fd-find`.
    # Create compatibility symlink so `fd` works (used by fzf/zsh).
    if command_exists fd-find && ! command_exists fd; then
        log_info "Creating 'fd' symlink to 'fd-find'..."
        sudo ln -sf "$(which fd-find)" /usr/local/bin/fd
    fi

    # Install RPM Fusion (if not present) - gives access to more packages
    if ! is_fedora_pkg_installed "rpmfusion-free-release"; then
        log_info "Installing RPM Fusion repositories..."
        local fedora_ver
        fedora_ver=$(rpm -E %fedora)
        sudo dnf install -y \
            "https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-${fedora_ver}.noarch.rpm" \
            "https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-${fedora_ver}.noarch.rpm"
    fi

    # Third-party packages (best-effort, skip if unavailable)
    if command_exists dnf; then
        for pkg in "${copr_pkgs[@]}"; do
            if ! is_fedora_pkg_installed "$pkg"; then
                log_info "Installing: $pkg"
                sudo dnf install -y "$pkg" || warn "Failed to install $pkg (may not be available), skipping"
            else
                log "$pkg already installed"
            fi
        done
    fi
}

# Main script execution
main() {
    header "🚀 Application Installation"
    echo -e "${BLUE}Installing development apps and utilities${NC}\n"

    # Check we have basic tools
    check_dependencies

    # Detect OS if not set
    if [[ -z "${OS_TYPE:-}" ]]; then
        OS_TYPE=$(detect_os)
    fi

    # Install applications
    install_apps

    log_info "All applications installed successfully!"
}

# Run the script
main "$@"
