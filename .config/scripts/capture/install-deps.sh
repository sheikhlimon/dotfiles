#!/bin/bash
# Install Hyprland capture tools on Fedora
# These mirror omarchy's capture scripts

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../utils.sh
source "$SCRIPT_DIR/../utils.sh"

install_fedora_capture_deps() {
    log_info "Installing capture dependencies on Fedora..."

    # DNF packages from standard + RPM Fusion
    local pkgs=(
        grim
        slurp
        wl-clipboard
        jq
        ffmpeg
        v4l2-utils
        libnotify
        mpv
    )

    install_fedora_packages "${pkgs[@]}"

    # Enable COPR for Hyprland ecosystem tools
    if ! command_exists hyprpicker; then
        log_info "Enabling solopasha/hyprland COPR for hyprpicker..."
        sudo dnf copr enable -y solopasha/hyprland || warn "COPR enable failed (may already be enabled)"
    fi

    # Hyprland ecosystem tools (COPR)
    local copr_pkgs=(
        hyprpicker
        satty
        gpu-screen-recorder
    )

    for pkg in "${copr_pkgs[@]}"; do
        if ! command_exists "${pkg%% *}"; then
            log_info "Installing: $pkg"
            sudo dnf install -y "$pkg" || warn "Failed to install $pkg, skipping"
        else
            log "$pkg already installed"
        fi
    done
}

install_arch_capture_deps() {
    log_info "Installing capture dependencies on Arch..."

    local pkgs=(
        grim
        slurp
        wl-clipboard
        jq
        ffmpeg
        v4l2-utils
        libnotify
        mpv
        hyprpicker
        satty
        gpu-screen-recorder
    )

    install_arch_packages "${pkgs[@]}"
}

main() {
    header "📸 Capture Tools Installation"

    OS_TYPE=$(detect_os)

    case "$OS_TYPE" in
        fedora)
            install_fedora_capture_deps
            ;;
        arch)
            install_arch_capture_deps
            ;;
        *)
            error "Unsupported OS: $OS_TYPE"
            exit 1
            ;;
    esac

    # Offer to symlink scripts to ~/.local/bin
    echo ""
    if [[ ! -d "$HOME/.local/bin" ]]; then
        mkdir -p "$HOME/.local/bin"
    fi

    echo -e "${YELLOW}🔧 Symlink capture scripts to ~/.local/bin? [y/N]:${NC} "
    read answer
    if [[ "$answer" =~ ^[Yy]$ ]]; then
        ln -sf "$SCRIPT_DIR/screenshot.sh" "$HOME/.local/bin/screenshot"
        ln -sf "$SCRIPT_DIR/screenrecord.sh" "$HOME/.local/bin/screenrecord"
        log "Linked: screenshot, screenrecord"
        log "Make sure ~/.local/bin is in your PATH"
    fi

    log_info "Done!"
}

main "$@"
