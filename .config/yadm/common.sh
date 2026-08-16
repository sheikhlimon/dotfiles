#!/usr/bin/env bash
# Common setup for all distros (Zsh plugins, decryption, default shell)
set -euo pipefail

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

log() { echo -e "${GREEN}==>${NC} $1"; }
warn() { echo -e "${YELLOW}⚠${NC} $1"; }
error() { echo -e "${RED}✗${NC} $1" >&2; }

run_common_setup() {
    # Setup Zsh plugins for direct sourcing
    log "Setting up Zsh plugins for direct sourcing..."
    local plugin_dir="$HOME/.local/share/zsh/plugins"
    mkdir -p "$plugin_dir"

    local repos=(
        "https://github.com/zsh-users/zsh-completions.git"
        "https://github.com/Aloxaf/fzf-tab.git"
        "https://github.com/zsh-users/zsh-autosuggestions.git"
        "https://github.com/jeffreytse/zsh-vi-mode.git"
        "https://github.com/zdharma-continuum/fast-syntax-highlighting.git"
    )

    for repo in "${repos[@]}"; do
        local name
        name="$(basename "$repo" .git)"
        if [[ ! -d "$plugin_dir/$name" ]]; then
            log "Cloning $name..."
            git clone --depth=1 "$repo" "$plugin_dir/$name" 2>/dev/null || true
        fi
    done

    # Decrypt encrypted files if archive exists
    if [ -f "$HOME/.local/share/yadm/archive" ]; then
        log "Encrypted vault detected in YADM repo."
        read -rp "Do you want to decrypt private files now? [Y/n] " answer
        if [[ ! "$answer" =~ ^[Nn]$ ]]; then
            yadm decrypt
        fi
    fi

    # Set default shell to zsh
    if [[ "${SHELL:-}" != *"zsh"* ]] && command -v zsh &>/dev/null; then
        log "Changing default shell to Zsh..."
        chsh -s "$(which zsh)" || true
    fi

    log "YADM bootstrap complete! 🎉"
}
