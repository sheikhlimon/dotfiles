# XDG Base Directory Specification
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_DATA_DIRS="${XDG_DATA_DIRS:-/usr/local/share:/usr/share:$XDG_DATA_HOME}"

# Essential exports
export PATH="$HOME/.local/bin:$PATH"
export EDITOR="nvim"
export SUDO_EDITOR="$EDITOR"
export BAT_THEME=ansi
export STARSHIP_CONFIG="$XDG_CONFIG_HOME/starship/starship.toml"
export ZLE_RPROMPT_INDENT=0
export PROMPT_EOL_MARK=''

# History
HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000
setopt EXTENDED_HISTORY INC_APPEND_HISTORY SHARE_HISTORY \
       HIST_EXPIRE_DUPS_FIRST HIST_IGNORE_DUPS HIST_IGNORE_ALL_DUPS

# FZF configuration
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

# Initialize prompt and ZLE
eval "$(starship init zsh)"

# Optimized completions
autoload -Uz compinit
setopt EXTENDED_GLOB
if [[ -n ${HOME}/.zcompdump(#qN.mh+24) ]]; then
    compinit
else
    compinit -C
fi
# Enable completion of hidden files
_comp_options+=(globdots)


# Modern FZF integration (after ZLE is ready)
if command -v fzf &>/dev/null; then
    eval "$(fzf --zsh)"
fi

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

# Oh My Zsh setup for deferred loading
export ZSH="$HOME/.oh-my-zsh"
export ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
plugins=(
  zsh-autosuggestions
  zsh-syntax-highlighting
)

# Deferred loading function - loads heavy stuff after prompt appears
_load_omz_deferred() {
    # Load Oh My Zsh
    [[ -r $ZSH/oh-my-zsh.sh ]] && source "$ZSH/oh-my-zsh.sh"
    
    # Load external tools
    if [[ -d "$XDG_DATA_HOME/fnm" ]]; then
        export PATH="$XDG_DATA_HOME/fnm:$PATH"
        eval "$(fnm env)"
    fi
    
    if command -v zoxide &>/dev/null; then
        eval "$(zoxide init zsh)"
    fi
    
    # Additional zsh settings
    setopt AUTO_MENU COMPLETE_IN_WORD ALWAYS_TO_END
    zmodload zsh/complist
    export ZSH_AUTOSUGGEST_STRATEGY=(history completion match_prev_cmd)
    export ZSH_AUTOSUGGEST_USE_ASYNC=true
    zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' 'r:|[._-]=* r:|=*'
    zstyle ':completion:*' menu select=2
    zle_highlight+=(paste:none)
    
    # Restart autosuggestions if available
    if typeset -f _zsh_autosuggest_start >/dev/null; then
        _zsh_autosuggest_start
    fi
    
    # Load personal config last
    [[ -f "$HOME/.zshrc-personal" ]] && source "$HOME/.zshrc-personal"
    
    # Remove this function to prevent re-loading
    unfunction _load_omz_deferred
}

# Hook deferred loading to line editor initialization
zle -N zle-line-init _load_omz_deferred
