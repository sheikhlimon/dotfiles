# XDG Base Directory Specification
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_DATA_DIRS="${XDG_DATA_DIRS:-/usr/local/share:/usr/share:$XDG_DATA_HOME}"

# Path
export PATH="$HOME/.local/bin:$PATH"
export EDITOR="nvim"
export SUDO_EDITOR="$EDITOR"
export BAT_THEME=ansi
export STARSHIP_CONFIG="$XDG_CONFIG_HOME/starship/starship.toml"
export ZLE_RPROMPT_INDENT=0     # fix right-prompt spacing
export PROMPT_EOL_MARK=''       # hide % at end of prompt

# Oh My Zsh
export ZSH="$HOME/.oh-my-zsh"
export ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

plugins=(
  zsh-autosuggestions
  zsh-syntax-highlighting
)

source "$ZSH/oh-my-zsh.sh"

zle_highlight+=(paste:none)

# Completion & Autosuggestions
autoload -Uz compinit && compinit -u
setopt AUTO_MENU COMPLETE_IN_WORD ALWAYS_TO_END

zmodload zsh/complist

ZSH_AUTOSUGGEST_STRATEGY=(history completion match_prev_cmd)
ZSH_AUTOSUGGEST_USE_ASYNC=true

# Better matching
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' 'r:|[._-]=* r:|=*'
zstyle ':completion:*' menu select=2

# Aliases and functions
[[ -f "$HOME/.zshrc-personal" ]] && source "$HOME/.zshrc-personal"

# History
HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000
setopt EXTENDED_HISTORY INC_APPEND_HISTORY SHARE_HISTORY \
       HIST_EXPIRE_DUPS_FIRST HIST_IGNORE_DUPS HIST_IGNORE_ALL_DUPS

# fzf Integration
export FZF_DEFAULT_COMMAND='fd --type file'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

export FZF_CTRL_T_OPTS="
--walker-skip .git,node_modules,target
--preview 'bat -n --color=always {}'
--bind 'enter:execute(nvim {})+abort'
--bind 'ctrl-/:change-preview-window(down|hidden|)'
"

export FZF_ALT_C_OPTS="
--walker-skip .git,node_modules,target
--preview 'tree -C {}'
"

# Simple continuum-aware auto-attach
# if [[ ! $VSCODE_PID && $(ps -o comm= -p $PPID 1>/dev/null) != code* ]]; then
#   if command -v tmux &>/dev/null && [[ -z $TMUX ]]; then
#     # Just start tmux - continuum will auto-restore if configured
#     if tmux list-sessions &>/dev/null; then
#       # Sessions exist, attach to most recent
#       tmux attach
#     else
#       # No sessions, start new one (continuum will restore if data exists)
#       tmux new -s main
#     fi
#   fi
# fi

# Starship Prompt
eval "$(starship init zsh)"

# Node (fnm)
if [[ -d "$XDG_DATA_HOME/fnm" ]]; then
  export PATH="$XDG_DATA_HOME/fnm:$PATH"
  eval "$(fnm env)"
fi

# zoxide
if command -v zoxide &>/dev/null; then
  eval "$(zoxide init zsh)"
fi

# Load FZF key bindings and completion
[[ -f /usr/share/fzf/key-bindings.zsh ]] && source /usr/share/fzf/key-bindings.zsh
