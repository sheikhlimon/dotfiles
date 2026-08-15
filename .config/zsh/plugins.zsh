# Bootstrap Antidote plugin manager
ANTIDOTE_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/antidote"

if [[ ! -d "$ANTIDOTE_DIR" ]]; then
  git clone --depth=1 https://github.com/mattmc3/antidote.git "$ANTIDOTE_DIR"
fi
source "$ANTIDOTE_DIR/antidote.zsh"

# Static bundle caching
ZSH_PLUGINS_TXT="${XDG_CONFIG_HOME:-$HOME/.config}/zsh/.zsh_plugins.txt"
ZSH_PLUGINS_ZSH="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/plugins.zsh"
[[ -d "${XDG_CACHE_HOME:-$HOME/.cache}/zsh" ]] || mkdir -p "${XDG_CACHE_HOME:-$HOME/.cache}/zsh"

if [[ ! -f "$ZSH_PLUGINS_ZSH" || "$ZSH_PLUGINS_TXT" -nt "$ZSH_PLUGINS_ZSH" ]]; then
  antidote bundle < "$ZSH_PLUGINS_TXT" > "$ZSH_PLUGINS_ZSH"
fi
source "$ZSH_PLUGINS_ZSH"
