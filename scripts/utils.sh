#!/bin/bash
# Shared utilities for all installation scripts
# Provides common functions, colors, and OS detection

set -euo pipefail

# Color codes
export RED='\033[0;31m'
export GREEN='\033[0;32m'
export YELLOW='\033[1;33m'
export BLUE='\033[0;34m'
export BOLD='\033[1m'
export NC='\033[0m' # No Color

# Logging functions
log() {
    echo -e "${GREEN}✓${NC} $1"
}

log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

warn() {
    echo -e "${YELLOW}⚠${NC} $1"
}

error() {
    echo -e "${RED}✗${NC} $1" >&2
}

error_info() {
    echo -e "${RED}[ERROR]${NC} $1" >&2
}

header() {
    echo -e "\n${BOLD}$1${NC}"
    echo -e "${BLUE}$(printf '=%.0s' {1..60})${NC}"
}

# OS detection
detect_os() {
    if [[ -f /etc/fedora-release ]]; then
        echo "fedora"
    elif [[ -f /etc/arch-release ]]; then
        echo "arch"
    elif [[ -f /etc/debian_version ]]; then
        echo "debian"
    elif [[ -f /etc/ubuntu-release ]]; then
        echo "ubuntu"
    else
        echo "unknown"
    fi
}

# Check if package is installed (cross-distro)
is_pkg_installed() {
    local pkg="$1"
    case "$(detect_os)" in
        fedora)
            rpm -q "$pkg" >/dev/null 2>&1
            ;;
        arch)
            pacman -Qi "$pkg" >/dev/null 2>&1 || yay -Qi "$pkg" >/dev/null 2>&1
            ;;
        debian|ubuntu)
            dpkg -l "$pkg" >/dev/null 2>&1
            ;;
        *)
            command -v "$pkg" >/dev/null 2>&1
            ;;
    esac
}

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check if package is installed (Arch)
is_arch_pkg_installed() {
    pacman -Qi "$1" >/dev/null 2>&1 || yay -Qi "$1" >/dev/null 2>&1
}

# Check if package is installed (Fedora)
is_fedora_pkg_installed() {
    rpm -q "$1" >/dev/null 2>&1
}


# Check if service exists and is enabled
is_service_enabled() {
    systemctl is-enabled "$1" >/dev/null 2>&1
}

# Check if service is running
is_service_running() {
    systemctl is-active "$1" >/dev/null 2>&1
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
        log_info "Installing Arch packages: ${to_install[*]}"
        sudo pacman -S --needed "${to_install[@]}"
    fi
}

# Install Fedora packages
install_fedora_packages() {
    local pkgs=("$@")
    local to_install=()

    for pkg in "${pkgs[@]}"; do
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
}

# Install AUR packages with yay (Arch only)
install_aur_packages() {
    if ! command_exists yay; then
        warn "yay not installed, skipping AUR packages"
        return 0
    fi

    local pkgs=("$@")

    for pkg in "${pkgs[@]}"; do
        if ! is_arch_pkg_installed "$pkg"; then
            log_info "Installing AUR package: $pkg"
            yay -S --needed "$pkg"
        else
            log "AUR package $pkg already installed"
        fi
    done
}

# Install COPR packages (Fedora)
install_copr_packages() {
    if ! command_exists dnf; then
        warn "dnf not available, skipping COPR packages"
        return 0
    fi

    local pkgs=("$@")

    for pkg in "${pkgs[@]}"; do
        if ! is_fedora_pkg_installed "$pkg"; then
            log_info "Installing COPR/package: $pkg"
            sudo dnf install -y "$pkg"
        else
            log "$pkg already installed"
        fi
    done
}


# Check dependencies
check_dependencies() {
    local missing=()

    for cmd in git curl; do
        if ! command_exists "$cmd"; then
            missing+=("$cmd")
        fi
    done

    if [[ ${#missing[@]} -gt 0 ]]; then
        error "Missing required dependencies: ${missing[*]}"
        error "Install them first and try again."
        exit 1
    fi
}

# Setup Tmux Plugin Manager
install_tpm() {
    local tpm_dir="$HOME/.tmux/plugins/tpm"

    if [[ ! -d "$tpm_dir" ]]; then
        log "Installing Tmux Plugin Manager (TPM)..."
        git clone https://github.com/tmux-plugins/tpm "$tpm_dir"
        log "TPM installed!"
        echo "In tmux, press 'prefix + I' to install plugins"
    else
        log "TPM already installed at $tpm_dir"
    fi
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

# Ask user and run script
ask_and_run() {
    local description="$1"
    local script_name="$2"
    local script_path="$(dirname "${BASH_SOURCE[1]}")/$script_name"

    echo -e "\n${YELLOW}🔧 $description [y/N]:${NC} " >&2
    read answer
    if [[ "$answer" =~ ^[Yy]$ ]]; then
        if [[ -f "$script_path" ]]; then
            log "Running $script_name..."
            bash "$script_path"
        else
            error "Script not found: $script_path"
            return 1
        fi
    else
        warn "Skipped: $description"
    fi
}