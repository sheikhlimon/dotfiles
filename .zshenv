#!/usr/bin/env zsh

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
    printf "${red}zsh: no such file or directory: %s${reset}\n" "$1"
    return 127
}

function _load_persistent_aliases {
    # Persistent aliases are loaded after the plugin is loaded
    # This way omz will not override them
    unset -f _load_persistent_aliases

    if [[ -x "$(command -v eza)" ]]; then
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
        [[ -r $ZSH/oh-my-zsh.sh ]] && source $ZSH/oh-my-zsh.sh
        ZDOTDIR="${__ZDOTDIR:-$HOME}"
        _load_post_init
    fi
}

function _load_post_init() {
    #! Never load time consuming functions here
    _load_persistent_aliases
    autoload -U compinit && compinit

    # Initiate fzf
    if command -v fzf &>/dev/null; then
        eval "$(fzf --zsh)"
    fi

    # zsh-autosuggestions won't work on first prompt when deferred
    if typeset -f _zsh_autosuggest_start >/dev/null; then
        _zsh_autosuggest_start
    fi

    # User rc file always overrides
    [[ -f $HOME/.zshrc ]] && source $HOME/.zshrc

}

function _load_if_terminal {
    if [ -t 1 ]; then

        unset -f _load_if_terminal

        # Currently We are loading Starship and p10k prompts on start so users can see the prompt immediately

        if command -v starship &>/dev/null; then
            # ===== START Initialize Starship prompt =====
            eval "$(starship init zsh)"
            export STARSHIP_CACHE=$XDG_CACHE_HOME/starship
            export STARSHIP_CONFIG=$XDG_CONFIG_HOME/starship/starship.toml
        # ===== END Initialize Starship prompt =====
        elif [ -r $HOME/.p10k.zsh ]; then
            # ===== START Initialize Powerlevel10k theme =====
            POWERLEVEL10K_TRANSIENT_PROMPT=same-dir
            P10k_THEME=${P10k_THEME:-/usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme}
            [[ -r $P10k_THEME ]] && source $P10k_THEME
            # To customize prompt, run `p10k configure` or edit $HOME/.p10k.zsh
            [[ ! -f $HOME/.p10k.zsh ]] || source $HOME/.p10k.zsh
        # ===== END Initialize Powerlevel10k theme =====
        fi

        # Load plugins
        _load_zsh_plugins

        # Load zsh hooks module once

        #? Methods to load oh-my-zsh lazily
        __ZDOTDIR="${ZDOTDIR:-$HOME}"
        ZDOTDIR=/tmp
        zle -N zle-line-init _load_omz_on_init # Loads when the line editor initializes // The best option

        #  Below this line are the commands that are executed after the prompt appears

        autoload -Uz add-zsh-hook
        # add-zsh-hook zshaddhistory load_omz_deferred # loads after the first command is added to history
        # add-zsh-hook precmd load_omz_deferred # Loads when shell is ready to accept commands
        # add-zsh-hook preexec load_omz_deferred # Loads before the first command executes


        bindkey '\e[H' beginning-of-line
        bindkey '\e[F' end-of-line

    fi

}

#? Override this environment variable in ~/.zshrc

# cleaning up home folder
PATH="$HOME/.local/bin:$PATH"
XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
XDG_DATA_DIRS="${XDG_DATA_DIRS:-$XDG_DATA_HOME:/usr/local/share:/usr/share}"
XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"
XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"

# XDG User Directories
XDG_DESKTOP_DIR="${XDG_DESKTOP_DIR:-"$(xdg-user-dir DESKTOP)"}"
XDG_DOWNLOAD_DIR="${XDG_DOWNLOAD_DIR:-"$(xdg-user-dir DOWNLOAD)"}"
XDG_TEMPLATES_DIR="${XDG_TEMPLATES_DIR:-"$(xdg-user-dir TEMPLATES)"}"
XDG_PUBLICSHARE_DIR="${XDG_PUBLICSHARE_DIR:-"$(xdg-user-dir PUBLICSHARE)"}"
XDG_DOCUMENTS_DIR="${XDG_DOCUMENTS_DIR:-"$(xdg-user-dir DOCUMENTS)"}"
XDG_MUSIC_DIR="${XDG_MUSIC_DIR:-"$(xdg-user-dir MUSIC)"}"
XDG_PICTURES_DIR="${XDG_PICTURES_DIR:-"$(xdg-user-dir PICTURES)"}"
XDG_VIDEOS_DIR="${XDG_VIDEOS_DIR:-"$(xdg-user-dir VIDEOS)"}"

LESSHISTFILE=${LESSHISTFILE:-/tmp/less-hist}
PARALLEL_HOME="$XDG_CONFIG_HOME/parallel"
SCREENRC="$XDG_CONFIG_HOME"/screen/screenrc

ZSH_AUTOSUGGEST_STRATEGY=(history completion)

# History configuration // explicit to not nuke history
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

export XDG_CONFIG_HOME XDG_DATA_HOME XDG_STATE_HOME \
    XDG_CACHE_HOME XDG_DESKTOP_DIR XDG_DOWNLOAD_DIR \
    XDG_TEMPLATES_DIR XDG_PUBLICSHARE_DIR XDG_DOCUMENTS_DIR \
    XDG_MUSIC_DIR XDG_PICTURES_DIR XDG_VIDEOS_DIR \
    SCREENRC ZSH_AUTOSUGGEST_STRATEGY HISTFILE

_load_if_terminal
