# XDG Base Directory Specification
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_DATA_DIRS="${XDG_DATA_DIRS:-$XDG_DATA_HOME:/usr/local/share:/usr/share}"

# XDG compliance for tools
export CUDA_CACHE_PATH="$XDG_CACHE_HOME/nv"
export DOCKER_CONFIG="$XDG_CONFIG_HOME/docker"

# Add local bin to PATH
export PATH="$HOME/.local/bin:$PATH"

# Personal configurations
export EDITOR=nvim
export TERM=kitty

# Don't show % at the end of cpp run files
PROMPT_EOL_MARK=''

# fzf environment variables
export FZF_DEFAULT_COMMAND='fd --type file'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

export FZF_DEFAULT_OPTS="\
--color=spinner:#f5e0dc,hl:#f38ba8 \
--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
--color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 \
--preview 'bat --style=full --color=always {}'"

export FZF_CTRL_T_OPTS="
--walker-skip .git,node_modules,target
--preview 'bat -n --color=always {}'
--bind 'ctrl-/:change-preview-window(down|hidden|)'"

export FZF_ALT_C_OPTS="
--walker-skip .git,node_modules,target
--preview 'tree -C {}'"

# Find and set oh-my-zsh installation path
if [[ -d "$HOME/.oh-my-zsh" ]]; then
  export ZSH="$HOME/.oh-my-zsh"
elif [[ -d "/usr/local/share/oh-my-zsh" ]]; then
  export ZSH="/usr/local/share/oh-my-zsh"
elif [[ -d "/usr/share/oh-my-zsh" ]]; then
  export ZSH="/usr/share/oh-my-zsh"
else
  echo "Warning: oh-my-zsh not found"
  return 1
fi

# oh-my-zsh plugins
plugins=(
  git
  zsh-256color
  zsh-autosuggestions
  zsh-syntax-highlighting
)

# Load oh-my-zsh
source $ZSH/oh-my-zsh.sh

# Initialize completion system with caching
autoload -Uz compinit && compinit -C

# auto-refresh completions when new tools are installed
zstyle ':completion:*' rehash true

# Load complist module for menu selection (for nicer tab completion UI)
zmodload zsh/complist

# Set autosuggestion strategy: history first, then completion
ZSH_AUTOSUGGEST_STRATEGY=(history completion)

# Prompt setup - Starship first, then Powerlevel10k fallback
if command -v starship &>/dev/null; then
  eval "$(starship init zsh)"
  export STARSHIP_CACHE="$XDG_CACHE_HOME/starship"
  export STARSHIP_CONFIG="$XDG_CONFIG_HOME/starship/starship.toml"
elif [[ -r "$HOME/.p10k.zsh" ]]; then
  # Try common Powerlevel10k locations
  for theme_path in "/usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme" \
    "$HOME/.oh-my-zsh/custom/themes/powerlevel10k/powerlevel10k.zsh-theme" \
    "$ZSH/themes/powerlevel10k.zsh-theme"; do
    if [[ -r "$theme_path" ]]; then
      source "$theme_path"
      [[ -f "$HOME/.p10k.zsh" ]] && source "$HOME/.p10k.zsh"
      break
    fi
  done
fi

# History configuration
HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000
setopt EXTENDED_HISTORY
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS

# Tool initializations
if [[ -d "$HOME/.local/share/fnm" ]]; then
  export PATH="$HOME/.local/share/fnm:$PATH"
  eval "$(fnm env)"
fi

# zoxide (better cd command)
if command -v zoxide &>/dev/null; then
  eval "$(zoxide init zsh)"
fi

# Load personal configurations
[[ -f ~/.zshrc-personal ]] && source ~/.zshrc-personal

# Source fzf keybindings and completion
[[ -f /usr/share/fzf/key-bindings.zsh ]] && source /usr/share/fzf/key-bindings.zsh
[[ -f /usr/share/fzf/completion.zsh ]] && source /usr/share/fzf/completion.zsh
