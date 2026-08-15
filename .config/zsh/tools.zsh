# Starship prompt
command -v starship &>/dev/null && eval "$(starship init zsh)"

# Zoxide directory jumper
command -v zoxide &>/dev/null && eval "$(zoxide init zsh)"

# FZF fuzzy finder (Ctrl+T files, Alt+C directory)
command -v fzf &>/dev/null && eval "$(fzf --zsh)"

# Atuin shell history (Ctrl+R, Up-Arrow, relative time, directory filtering)
command -v atuin &>/dev/null && eval "$(atuin init zsh)"

# Fast Node Manager (fnm)
if [[ -d "${XDG_DATA_HOME:-$HOME/.local/share}/fnm" ]]; then
  path=("${XDG_DATA_HOME:-$HOME/.local/share}/fnm" $path)
  eval "$(fnm env --use-on-cd 2>/dev/null)"
elif [[ -d "$HOME/.fnm" ]]; then
  path=("$HOME/.fnm" $path)
  eval "$(fnm env --use-on-cd 2>/dev/null)"
fi
