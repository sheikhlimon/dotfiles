# XDG Base Directory Specification
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_DATA_DIRS="${XDG_DATA_DIRS:-/usr/local/share:/usr/share}"

# Essential exports
export PATH="$HOME/.local/bin:$PATH"
export STARSHIP_CONFIG="$XDG_CONFIG_HOME/starship/starship.toml"
export EDITOR="nvim"
export SUDO_EDITOR="$EDITOR"
export BAT_THEME=ansi
export ZLE_RPROMPT_INDENT=0
export PROMPT_EOL_MARK=''

# History
HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000
setopt EXTENDED_HISTORY INC_APPEND_HISTORY SHARE_HISTORY \
       HIST_EXPIRE_DUPS_FIRST HIST_IGNORE_DUPS HIST_IGNORE_ALL_DUPS

# Initialize starship
if command -v starship &> /dev/null; then
    eval "$(starship init zsh)"
fi

# Optimized completions
autoload -Uz compinit
setopt EXTENDED_GLOB
if [[ -n ${HOME}/.zcompdump(#qN.mh+24) ]]; then
    compinit
else
    compinit -C
fi

setopt AUTO_MENU COMPLETE_IN_WORD ALWAYS_TO_END
zmodload zsh/complist
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' 'r:|[._-]=* r:|=*'
zstyle ':completion:*' menu select
zle_highlight+=(paste:none)

# Enable completion of hidden files
_comp_options+=(globdots)

# FZF configuration
export FZF_DEFAULT_COMMAND='fd --type file'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

export FZF_CTRL_T_OPTS="
--walker-skip .git,node_modules,target
--preview 'command -v bat >/dev/null && bat -n --color=always {} || cat {}'
--bind 'enter:execute(nvim {})+abort'
--bind 'ctrl-/:change-preview-window(down|hidden|)'
"

export FZF_ALT_C_OPTS="
--walker-skip .git,node_modules,target
--preview 'command -v tree >/dev/null && tree -C {} || ls -la {}'
"

# Oh My Zsh and plugins
export ZSH="$HOME/.oh-my-zsh"
export ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

plugins=(
  zsh-autosuggestions
  zsh-syntax-highlighting
)

# Loads heavy stuff after prompt appears
load_omz_deferred() {
    [[ -r $ZSH/oh-my-zsh.sh ]] && source "$ZSH/oh-my-zsh.sh"

    ZSH_AUTOSUGGEST_STRATEGY=(history completion match_prev_cmd)

    if command -v zoxide &>/dev/null; then
        eval "$(zoxide init zsh)"
    fi

    if command -v fzf &>/dev/null; then
        eval "$(fzf --zsh)"
    fi

    if command -v mise &> /dev/null; then
        eval "$(mise activate zsh)"
    fi
    
    # Restart autosuggestions if available
    if typeset -f _zsh_autosuggest_start >/dev/null; then
        _zsh_autosuggest_start
    fi
    
    [[ -f "$HOME/.zshrc-personal" ]] && source "$HOME/.zshrc-personal"

    # Prevent re-loading
    zle -D zle-line-init   # unbind widget cleanly
    unfunction load_omz_deferred
}

# Hook deferred loading
zle -N zle-line-init load_omz_deferred

