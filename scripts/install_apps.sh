#!/bin/bash
# Comprehensive app installer script
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

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check if package is installed (Arch)
is_arch_pkg_installed() {
    pacman -Qi "$1" >/dev/null 2>&1 || yay -Qi "$1" >/dev/null 2>&1
}

# Check if package is installed (Debian)
is_debian_pkg_installed() {
    dpkg -s "$1" >/dev/null 2>&1
}

# Install Arch packages
install_arch_packages() {
    local pkgs=("$@")
    local to_install=()

    for pkg in "${pkgs[@]}"; do
        if ! is_arch_pkg_installed "$pkg"; then
            to_install+=("$pkg")
        else
            log "$pkg already installed"
        fi
    done

    if [[ ${#to_install[@]} -gt 0 ]]; then
        log "Installing Arch packages: ${to_install[*]}"
        sudo pacman -S --needed "${to_install[@]}"
    fi
}

# Install AUR packages with yay
install_aur_packages() {
    local pkgs=("$@")

    for pkg in "${pkgs[@]}"; do
        if ! is_arch_pkg_installed "$pkg"; then
            log "Installing AUR package: $pkg"
            yay -S --needed "$pkg"
        else
            log "AUR package $pkg already installed"
        fi
    done
}

# Install Debian packages
install_debian_packages() {
    local pkgs=("$@")
    local to_install=()

    for pkg in "${pkgs[@]}"; do
        if ! is_debian_pkg_installed "$pkg"; then
            to_install+=("$pkg")
        else
            log "$pkg already installed"
        fi
    done

    if [[ ${#to_install[@]} -gt 0 ]]; then
        log "Installing Debian packages: ${to_install[*]}"
        sudo apt update
        sudo apt install -y "${to_install[@]}"
    fi
}

# Install Snap packages
install_snap_packages() {
    local pkgs=("$@")

    if ! command_exists snap; then
        log "Installing snapd..."
        sudo apt install -y snapd
        sudo systemctl enable --now snapd.socket
    fi

    for pkg in "${pkgs[@]}"; do
        if ! snap list | grep -q "^$pkg "; then
            log "Installing snap app: $pkg"
            sudo snap install "$pkg" --classic 2>/dev/null || sudo snap install "$pkg" 2>/dev/null
        else
            log "Snap app $pkg already installed"
        fi
    done
}

# Install Yazi manually for Debian
install_yazi_debian() {
    if command_exists yazi; then
        log "yazi already installed"
        return 0
    fi

    log "Installing yazi from GitHub releases..."
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
            log "Detected Arch Linux"

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

            # Install zsh plugins
            install_zsh_plugins_arch
            ;;

        debian)
            log "Detected Debian/Ubuntu"

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

            # Install zsh plugins
            install_zsh_plugins_debian
            ;;

        *)
            error "Unsupported operating system"
            return 1
            ;;
    esac

    log "Application installation completed successfully!"
}

# Install Oh My Zsh and plugins
install_oh_my_zsh() {
    if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
        log "Installing Oh My Zsh..."
        RUNZSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    else
        log "Oh My Zsh already installed"
    fi

    # Install plugins
    local plugins_dir="$HOME/.oh-my-zsh/custom/plugins"
    mkdir -p "$plugins_dir"

    local plugins=(
        "https://github.com/zsh-users/zsh-autosuggestions"
        "https://github.com/zsh-users/zsh-syntax-highlighting"
    )

    for plugin_url in "${plugins[@]}"; do
        local plugin_name=$(basename "$plugin_url")
        local plugin_path="$plugins_dir/$plugin_name"

        if [[ ! -d "$plugin_path" ]]; then
            log "Installing zsh plugin: $plugin_name"
            git clone "$plugin_url" "$plugin_path"
        else
            log "zsh plugin $plugin_name already installed"
        fi
    done
}

# Install zsh plugins for Arch
install_zsh_plugins_arch() {
    install_oh_my_zsh
}

# Install zsh plugins for Debian
install_zsh_plugins_debian() {
    install_oh_my_zsh
}

# Setup Tmux Plugin Manager
install_tpm() {
    local tpm_dir="$HOME/.tmux/plugins/tpm"

    if [[ ! -d "$tpm_dir" ]]; then
        log "Installing Tmux Plugin Manager (TPM)..."
        git clone https://github.com/tmux-plugins/tpm "$tpm_dir"
        log "TPM installed. Press prefix + I in tmux to install plugins."
    else
        log "TPM already installed"
    fi
}

# Main script execution
main() {
    log "Starting comprehensive application installation..."

    # Install applications
    install_apps

    # Install TPM
    install_tpm

    log "All installations completed successfully!"
    log ""
    log "Next steps:"
    log "1. Set zsh as your default shell: chsh -s $(which zsh)"
    log "2. Restart your shell or run: source ~/.zshrc"
    log "3. In tmux, press prefix + I to install plugins"
    log "4. Configure your dotfiles as needed"
}

# Run the script
main "$@"