# XDG Base Directory Specification
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_DATA_DIRS="${XDG_DATA_DIRS:-/usr/local/share:/usr/share}"

# Exports
export PATH="$HOME/bin:$HOME/.local/bin:$PATH"
export STARSHIP_CONFIG="$XDG_CONFIG_HOME/starship/starship.toml"
export EDITOR="nvim" SUDO_EDITOR="$EDITOR" BAT_THEME=ansi ZLE_RPROMPT_INDENT=0 PROMPT_EOL_MARK=''

# Core Options
setopt NO_GLOBAL_RCS
setopt NO_BEEP
setopt NO_LIST_BEEP
setopt NO_HIST_BEEP
setopt HIST_VERIFY
setopt HIST_SAVE_NO_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_SPACE
setopt nomatch

# Tools
export CARGO_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/cargo"
export RUSTUP_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/rustup"
export BUN_INSTALL="$HOME/.bun"
export PATH="$PATH:$BUN_INSTALL/bin"

# History Configuration
HISTFILE="$XDG_STATE_HOME/zsh/history"
HISTSIZE=10000
SAVEHIST=50000

setopt EXTENDED_HISTORY
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_ALL_DUPS

[[ -d "$XDG_STATE_HOME/zsh" ]] || mkdir -p "$XDG_STATE_HOME/zsh"

# Starship prompt
command -v starship &> /dev/null && eval "$(starship init zsh)"

# Completion System
autoload -Uz compinit

# Completion options
setopt EXTENDED_GLOB
setopt COMPLETE_IN_WORD
setopt ALWAYS_TO_END
setopt AUTO_MENU
setopt LIST_ROWS_FIRST
setopt HIST_VERIFY

# Optimized completion initialization
local zcompdump_file="$XDG_CACHE_HOME/zsh/.zcompdump"
local last_update_file="${XDG_DATA_HOME}/zsh/.last_update"

# Create required directories
[[ -d "${XDG_DATA_HOME}/zsh" ]] || mkdir -p "${XDG_DATA_HOME}/zsh"
[[ -d "$XDG_CACHE_HOME/zsh" ]] || mkdir -p "$XDG_CACHE_HOME/zsh"

# Only regenerate completions if zcompdump is missing or outdated
if [[ -f "$zcompdump_file" && -f "$last_update_file" && "$zcompdump_file" -nt "$last_update_file" ]]; then
    compinit -d "$zcompdump_file"
else
    compinit -C -d "$zcompdump_file"
    touch "$last_update_file" 2>/dev/null
fi

# Modern completion configuration
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' 'l:|=* r:|=*'
zstyle ':completion:*' menu select interactive use-cache on timeout 1
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh/completion-cache"
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:approximate:*' max-errors 2
zstyle ':completion:*:functions' ignored-patterns '_*'
zstyle ':completion:*:processes' command 'ps -o pid,user,command -w'

# Security and completion
unsetopt AUTO_NAME_DIRS CORRECT CORRECT_ALL
setopt AUTO_CD
zle_highlight+=(paste:none suffix:none)
setopt NO_CLOBBER NO_FLOW_CONTROL LOCAL_OPTIONS LOCAL_TRAPS
typeset -U path
_comp_options+=(globdots)

# FZF
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

# Oh My Zsh
export ZSH="$HOME/.oh-my-zsh"
export ZSH_CUSTOM="${ZSH}/custom"

plugins=(
  zsh-autosuggestions
  zsh-syntax-highlighting
)

# Loads heavy stuff after prompt appears
load_omz_deferred() {
    # Load Oh My Zsh
    [[ -r $ZSH/oh-my-zsh.sh ]] && source "$ZSH/oh-my-zsh.sh"

    # Configure autosuggestions
    ZSH_AUTOSUGGEST_STRATEGY=(history completion match_prev_cmd)
    ZSH_AUTOSUGGEST_MANUAL_REBIND=true
    ZSH_AUTOSUGGEST_USE_ASYNC=true

    # Load tools only if available
    command -v zoxide &>/dev/null && eval "$(zoxide init zsh)"
    command -v fzf &>/dev/null && eval "$(fzf --zsh)"

    # Node.js management
    if [ -d "$XDG_DATA_HOME/fnm" ]; then
        export PATH="$XDG_DATA_HOME/fnm:$PATH"
        eval "$(fnm env --use-on-cd)"
    fi

    # Rust toolchain
    if command -v rustup &>/dev/null; then
        export PATH="$CARGO_HOME/bin:$PATH"
        local rust_comp_dir="$XDG_DATA_HOME/zsh/completions"
        [[ ! -d "$rust_comp_dir" ]] && mkdir -p "$rust_comp_dir"

        # Only regenerate completions if outdated or missing
        local cargo_comp="$rust_comp_dir/_cargo"
        if [[ ! -f "$cargo_comp" || "$cargo_comp" -nt "${XDG_DATA_HOME}/zsh/.rust_update" ]]; then
            rustup completions zsh > "$cargo_comp" 2>/dev/null && touch "${XDG_DATA_HOME}/zsh/.rust_update" 2>/dev/null
        fi
        fpath=("$rust_comp_dir" $fpath)
    fi

    # Start autosuggestions
    typeset -f _zsh_autosuggest_start >/dev/null && _zsh_autosuggest_start

    # Load bun completions if available
    [ -s "$BUN_INSTALL/_bun" ] && source "$BUN_INSTALL/_bun"

    # Load personal config with security check
    if [[ -f "$HOME/.zshrc-personal" && -r "$HOME/.zshrc-personal" ]]; then
        source "$HOME/.zshrc-personal"
    fi

    # Clean up - remove the hook after execution
    unfunction load_omz_deferred
}

# Add hook for deferred loading
zle -N zle-line-init load_omz_deferred
