# Zsh configuration entrypoint
ZSH_CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/zsh"

# Source modules in dependency order
typeset -a zsh_modules=(
  env
  options
  tools
  completions
  plugins
  aliases
)

for mod in "${zsh_modules[@]}"; do
  [[ -r "$ZSH_CONFIG_DIR/$mod.zsh" ]] && source "$ZSH_CONFIG_DIR/$mod.zsh"
done
unset mod zsh_modules
