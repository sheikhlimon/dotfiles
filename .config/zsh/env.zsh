# XDG Base Directory specification
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_DATA_DIRS="${XDG_DATA_DIRS:-/usr/local/share:/usr/share}"

# Default editor and terminal settings
export EDITOR="nvim"
export SUDO_EDITOR="$EDITOR"
export BAT_THEME="ansi"
export STARSHIP_CONFIG="$XDG_CONFIG_HOME/starship/starship.toml"
export ZLE_RPROMPT_INDENT=0
export ELECTRON_OZONE_PLATFORM_HINT=x11
export FZF_DEFAULT_OPTS="--color=16 --height 60% --layout=reverse --border=none"

# Language environments
export CARGO_HOME="${XDG_DATA_HOME}/cargo"
export RUSTUP_HOME="${XDG_DATA_HOME}/rustup"
export BUN_INSTALL="$HOME/.bun"

# Deduplicated PATH
path=(
  "$HOME/bin"
  "$HOME/.local/bin"
  "$HOME/.opencode/bin"
  "$HOME/.local/share/flatpak/exports/bin"
  "$BUN_INSTALL/bin"
  "$CARGO_HOME/bin"
  "$HOME/go/bin"
  $path
)
typeset -U path
