function _load_zsh_plugins {
    unset -f _load_zsh_plugins

    # Locate oh-my-zsh
    local zsh_paths=(
        "$HOME/.oh-my-zsh"
        "/usr/local/share/oh-my-zsh"
        "/usr/share/oh-my-zsh"
    )

    for zsh_path in "${zsh_paths[@]}"; do
        if [[ -d $zsh_path ]]; then
            export ZSH=$zsh_path
            break
        fi
    done

    # Only proceed if oh-my-zsh is found
    if [[ -z $ZSH ]]; then
        echo "Warning: oh-my-zsh not found in any of the expected locations"
        return 1
    fi

    # Set up plugins array
    typeset -ga plugins
    plugins+=(git zsh-256color zsh-autosuggestions zsh-syntax-highlighting)

    # Deduplicate plugins
    plugins=($(printf "%s\n" "${plugins[@]}" | sort -u))

    # Defer loading until interactive shell prompt
    typeset -g DEFER_OMZ_LOAD=1
}

function no_such_file_or_directory_handler {
    local red='\e[1;31m' reset='\e[0m'
    printf "${red}zsh: no such file or directory: %s${reset}\n" "$1" >&2
    return 127
}

function _load_persistent_aliases {
    # Persistent aliases are loaded after the plugin is loaded
    # This way omz will not override them
    unset -f _load_persistent_aliases

    if command -v eza &>/dev/null; then
        alias l='eza -lh --icons=auto' \
            ll='eza -lha --icons=auto --sort=name --group-directories-first' \
            ls='eza -a --grid --icons=auto --sort=name --group-directories-first' \
            lt='eza --icons=auto --tree'
    fi
}

function _load_omz_on_init() {
    # Load oh-my-zsh when line editor initializes // before user input
    if [[ -n $DEFER_OMZ_LOAD ]]; then
        unset DEFER_OMZ_LOAD
        
        # Only load if ZSH is set and oh-my-zsh.sh exists
        if [[ -n $ZSH && -r $ZSH/oh-my-zsh.sh ]]; then
            source $ZSH/oh-my-zsh.sh
        else
            echo "Warning: Cannot load oh-my-zsh - ZSH not set or oh-my-zsh.sh not found"
        fi
        
        # Restore original ZDOTDIR
        ZDOTDIR="${__ZDOTDIR:-$HOME}"
        _load_post_init
    fi
}

function _load_post_init() {
    #! Never load time consuming functions here
    _load_persistent_aliases
    autoload -U compinit && compinit
    
    # Load complist module for menuselect keymap
    zmodload zsh/complist

    # Initiate fzf
    if command -v fzf &>/dev/null; then
        eval "$(fzf --zsh)"
    fi

    # zsh-autosuggestions won't work on first prompt when deferred
    if typeset -f _zsh_autosuggest_start >/dev/null; then
        _zsh_autosuggest_start
    fi

    # User rc file always overrides - but only if it exists
    [[ -f $HOME/.zshrc ]] && source $HOME/.zshrc
}

function _safe_xdg_dir() {
    local dir_type="$1"
    local fallback="$2"
    
    if command -v xdg-user-dir &>/dev/null; then
        local result
        result=$(xdg-user-dir "$dir_type" 2>/dev/null)
        if [[ -n $result && -d $result ]]; then
            echo "$result"
        else
            echo "$fallback"
        fi
    else
        echo "$fallback"
    fi
}

function _load_if_terminal {
    if [[ -t 1 ]]; then
        unset -f _load_if_terminal

        # Load prompt (prioritize Starship over p10k)
        if command -v starship &>/dev/null; then
            # ===== START Initialize Starship prompt =====
            eval "$(starship init zsh)"
            export STARSHIP_CACHE=$XDG_CACHE_HOME/starship
            export STARSHIP_CONFIG=$XDG_CONFIG_HOME/starship/starship.toml
            # ===== END Initialize Starship prompt =====
        elif [[ -r $HOME/.p10k.zsh ]]; then
            # ===== START Initialize Powerlevel10k theme =====
            POWERLEVEL10K_TRANSIENT_PROMPT=same-dir
            P10k_THEME=${P10k_THEME:-/usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme}
            [[ -r $P10k_THEME ]] && source $P10k_THEME
            # To customize prompt, run `p10k configure` or edit $HOME/.p10k.zsh
            [[ -f $HOME/.p10k.zsh ]] && source $HOME/.p10k.zsh
            # ===== END Initialize Powerlevel10k theme =====
        fi

        # Load plugins
        _load_zsh_plugins

        # Load zsh hooks module once
        autoload -Uz add-zsh-hook

        # Set up deferred loading hook
        # Store original ZDOTDIR and temporarily change it
        __ZDOTDIR="${ZDOTDIR:-$HOME}"
        ZDOTDIR=/tmp
        zle -N zle-line-init _load_omz_on_init
    fi
}

# Environment setup
PATH="$HOME/.local/bin:$PATH"
XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
XDG_DATA_DIRS="${XDG_DATA_DIRS:-$XDG_DATA_HOME:/usr/local/share:/usr/share}"
XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"
XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"

# XDG User Directories with safe fallbacks
XDG_DESKTOP_DIR="${XDG_DESKTOP_DIR:-$(_safe_xdg_dir DESKTOP "$HOME/Desktop")}"
XDG_DOWNLOAD_DIR="${XDG_DOWNLOAD_DIR:-$(_safe_xdg_dir DOWNLOAD "$HOME/Downloads")}"
XDG_TEMPLATES_DIR="${XDG_TEMPLATES_DIR:-$(_safe_xdg_dir TEMPLATES "$HOME/Templates")}"
XDG_PUBLICSHARE_DIR="${XDG_PUBLICSHARE_DIR:-$(_safe_xdg_dir PUBLICSHARE "$HOME/Public")}"
XDG_DOCUMENTS_DIR="${XDG_DOCUMENTS_DIR:-$(_safe_xdg_dir DOCUMENTS "$HOME/Documents")}"
XDG_MUSIC_DIR="${XDG_MUSIC_DIR:-$(_safe_xdg_dir MUSIC "$HOME/Music")}"
XDG_PICTURES_DIR="${XDG_PICTURES_DIR:-$(_safe_xdg_dir PICTURES "$HOME/Pictures")}"
XDG_VIDEOS_DIR="${XDG_VIDEOS_DIR:-$(_safe_xdg_dir VIDEOS "$HOME/Videos")}"

# Application-specific configurations
LESSHISTFILE=${LESSHISTFILE:-/tmp/less-hist}
PARALLEL_HOME="$XDG_CONFIG_HOME/parallel"
SCREENRC="$XDG_CONFIG_HOME/screen/screenrc"
ZSH_AUTOSUGGEST_STRATEGY=(history completion)

# History configuration
HISTFILE=${HISTFILE:-$HOME/.zsh_history}
HISTSIZE=50000
SAVEHIST=50000
HIST_STAMPS="dd/mm/yyyy"
setopt EXTENDED_HISTORY       # Write the history file in the ':start:elapsed;command' format
setopt INC_APPEND_HISTORY     # Write to the history file immediately, not when the shell exits
setopt SHARE_HISTORY          # Share history between all sessions
setopt HIST_EXPIRE_DUPS_FIRST # Expire a duplicate event first when trimming history
setopt HIST_IGNORE_DUPS       # Do not record an event that was just recorded again
setopt HIST_IGNORE_ALL_DUPS   # Delete an old recorded event if a new event is a duplicate

# Export variables
export XDG_CONFIG_HOME XDG_DATA_HOME XDG_STATE_HOME \
    XDG_CACHE_HOME XDG_DESKTOP_DIR XDG_DOWNLOAD_DIR \
    XDG_TEMPLATES_DIR XDG_PUBLICSHARE_DIR XDG_DOCUMENTS_DIR \
    XDG_MUSIC_DIR XDG_PICTURES_DIR XDG_VIDEOS_DIR \
    SCREENRC ZSH_AUTOSUGGEST_STRATEGY HISTFILE

# Initialize if in terminal
_load_if_terminal
