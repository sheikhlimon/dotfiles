# XDG Base Directory Specification
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_DATA_DIRS="${XDG_DATA_DIRS:-/usr/local/share:/usr/share:$XDG_DATA_HOME}"

# XDG compliance for tools
export DOCKER_CONFIG="$XDG_CONFIG_HOME/docker"

# Oh My Zsh setup
export ZSH="$HOME/.oh-my-zsh"
export ZSH_CUSTOM="$ZSH/custom"

# Path & personal configurationsj
export PATH="$HOME/.local/bin:$PATH"
export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"
export ZLE_RPROMPT_INDENT=0 # fixes indentation of prompt
export EDITOR=nvim
PROMPT_EOL_MARK=''  # removes % end of prompt

# Oh My Zsh plugins (minimal set for speed)
plugins=(
  zsh-autosuggestions
  zsh-syntax-highlighting
)

# Load Oh My Zsh
source "$ZSH/oh-my-zsh.sh"

# Completion & autosuggestions
autoload -Uz compinit add-zsh-hook

# Defer compinit to improve shell startup speed
precmd() {
  if [[ -z "${zsh_comp_init_done}" ]]; then
    compinit -i -C
    zsh_comp_init_done=1
  fi
}

# Auto-rehash completions when commands change
zstyle ':completion:*' rehash true

# Load menu completion for interactive selection
zmodload zsh/complist
zstyle ':completion:*' menu select=2        # menu triggered when 2+ options
zstyle ':completion:*' list-prompt '%S%M matches%s'

# Configure autosuggestions
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20

# History configuration
HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000
setopt EXTENDED_HISTORY INC_APPEND_HISTORY SHARE_HISTORY HIST_EXPIRE_DUPS_FIRST HIST_IGNORE_DUPS HIST_IGNORE_ALL_DUPS

# fzf environment variables and opts
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
--preview 'tree -C {}'"

# fnm 
if [[ -d "$HOME/.local/share/fnm" ]]; then
  export PATH="$HOME/.local/share/fnm:$PATH"
  eval "$(fnm env)"
fi

# zoxide
if command -v zoxide &>/dev/null; then
  eval "$(zoxide init zsh)"
fi

# starship
eval "$(starship init zsh)"

# Load personal configurations
[[ -f ~/.zshrc-personal ]] && source ~/.zshrc-personal

# Load FZF key bindings and completion
if [[ -f /usr/share/fzf/key-bindings.zsh ]]; then
  source /usr/share/fzf/key-bindings.zsh
fi
