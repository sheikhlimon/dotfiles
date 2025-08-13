if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# XDG Base Directory Specification
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_DATA_DIRS="${XDG_DATA_DIRS:-/usr/local/share:/usr/share:$XDG_DATA_HOME}"

# XDG compliance for tools
export CUDA_CACHE_PATH="$XDG_CACHE_HOME/nv"
export DOCKER_CONFIG="$XDG_CONFIG_HOME/docker"

# Oh My Zsh setup
export ZSH="$HOME/.oh-my-zsh"
export ZSH_CUSTOM="$ZSH/custom"

# Path & personal configurations
export PATH="$HOME/.local/bin:$PATH"
export EDITOR=nvim
PROMPT_EOL_MARK=''  # Don't show % at end of lines

# Only auto-start tmux if NOT inside VS Code terminal
if [[ ! $VSCODE_PID && $(ps -o comm= -p $PPID) != code* ]]; then
  if command -v tmux >/dev/null 2>&1 && [[ -z $TMUX ]]; then
    tmux attach -t main 2>/dev/null || tmux new -s main
    exit
  fi
fi

# Oh My Zsh configuration
ZSH_THEME="powerlevel10k/powerlevel10k"

# Oh My Zsh plugins (minimal set for speed)
plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
)

# Load Oh My Zsh
source "$ZSH/oh-my-zsh.sh"

# Completion & autosuggestions (load before Oh My Zsh)
autoload -Uz compinit
# Only rebuild completion cache once per day
if [[ -n ${ZDOTDIR}/.zcompdump(#qN.mh+24) ]]; then
  compinit
else
  compinit -C
fi
zstyle ':completion:*' rehash true
zmodload zsh/complist
# Configure autosuggestions (load after Oh My Zsh)
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20

# History configuration
HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000
setopt EXTENDED_HISTORY INC_APPEND_HISTORY SHARE_HISTORY HIST_EXPIRE_DUPS_FIRST HIST_IGNORE_DUPS HIST_IGNORE_ALL_DUPS

# fnm (Node.js version manager)
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

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
