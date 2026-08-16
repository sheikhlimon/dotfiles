# Pure Zsh plugin loader (Zero plugin manager overhead)
ZSH_PLUGIN_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/zsh/plugins"

# Auto-clone fallback if running on a fresh machine without bootstrap
if [[ ! -d "$ZSH_PLUGIN_DIR/fzf-tab" || ! -d "$ZSH_PLUGIN_DIR/fast-syntax-highlighting" || ! -d "$ZSH_PLUGIN_DIR/zsh-vi-mode" ]]; then
  mkdir -p "$ZSH_PLUGIN_DIR"
  [[ ! -d "$ZSH_PLUGIN_DIR/zsh-completions" ]] && git clone --depth=1 https://github.com/zsh-users/zsh-completions.git "$ZSH_PLUGIN_DIR/zsh-completions" 2>/dev/null
  [[ ! -d "$ZSH_PLUGIN_DIR/fzf-tab" ]] && git clone --depth=1 https://github.com/Aloxaf/fzf-tab.git "$ZSH_PLUGIN_DIR/fzf-tab" 2>/dev/null
  [[ ! -d "$ZSH_PLUGIN_DIR/zsh-autosuggestions" ]] && git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions.git "$ZSH_PLUGIN_DIR/zsh-autosuggestions" 2>/dev/null
  [[ ! -d "$ZSH_PLUGIN_DIR/zsh-vi-mode" ]] && git clone --depth=1 https://github.com/jeffreytse/zsh-vi-mode.git "$ZSH_PLUGIN_DIR/zsh-vi-mode" 2>/dev/null
  [[ ! -d "$ZSH_PLUGIN_DIR/fast-syntax-highlighting" ]] && git clone --depth=1 https://github.com/zdharma-continuum/fast-syntax-highlighting.git "$ZSH_PLUGIN_DIR/fast-syntax-highlighting" 2>/dev/null
fi

# 1. Completions (add to fpath before compinit)
[[ -d "$ZSH_PLUGIN_DIR/zsh-completions/src" ]] && fpath=("$ZSH_PLUGIN_DIR/zsh-completions/src" $fpath)

# 2. Interactive tab completion popup
[[ -f "$ZSH_PLUGIN_DIR/fzf-tab/fzf-tab.plugin.zsh" ]] && source "$ZSH_PLUGIN_DIR/fzf-tab/fzf-tab.plugin.zsh"

# 3. Autosuggestions
[[ -f "$ZSH_PLUGIN_DIR/zsh-autosuggestions/zsh-autosuggestions.zsh" ]] && source "$ZSH_PLUGIN_DIR/zsh-autosuggestions/zsh-autosuggestions.zsh"

# 4. Vi mode
function zvm_config() {
  ZVM_READKEY_ENGINE=$ZVM_READKEY_ENGINE_ZLE
  ZVM_KEYTIMEOUT=0.15
}
function zvm_after_init() {
  bindkey -M viins 'jj' vi-cmd-mode
  bindkey -M viins 'jk' vi-cmd-mode
  bindkey -M vicmd 'H' beginning-of-line
  bindkey -M vicmd 'L' end-of-line
}
[[ -f "$ZSH_PLUGIN_DIR/zsh-vi-mode/zsh-vi-mode.plugin.zsh" ]] && source "$ZSH_PLUGIN_DIR/zsh-vi-mode/zsh-vi-mode.plugin.zsh"

# 5. Fast Syntax Highlighting (must be sourced last)
[[ -f "$ZSH_PLUGIN_DIR/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh" ]] && source "$ZSH_PLUGIN_DIR/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh"
