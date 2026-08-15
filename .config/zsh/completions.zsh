# Zsh completion system
ZSH_PLUGIN_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/zsh/plugins"
[[ -d "$ZSH_PLUGIN_DIR/zsh-completions/src" ]] && fpath=("$ZSH_PLUGIN_DIR/zsh-completions/src" $fpath)

zmodload zsh/complist
autoload -Uz compinit

zcompdump="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/.zcompdump"
[[ -d "${XDG_CACHE_HOME:-$HOME/.cache}/zsh" ]] || mkdir -p "${XDG_CACHE_HOME:-$HOME/.cache}/zsh"

# Cache compinit once per day
if [[ -f "$zcompdump" && "$(date +'%j')" == "$(date -r "$zcompdump" +'%j' 2>/dev/null)" ]]; then
  compinit -C -d "$zcompdump"
else
  compinit -d "$zcompdump"
fi

# Completion matching and caching
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' menu no
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/completion-cache"
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# Clean compact process completion for kill
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;34'
zstyle ':completion:*:*:kill:*:processes' command 'ps -u $USER -o pid,stat,time,command'

# fzf-tab styling and natural keybindings
zstyle ':fzf-tab:*' fzf-bindings 'tab:down' 'btab:up' 'enter:accept' 'ctrl-/:toggle-preview'
zstyle ':fzf-tab:*' continuous-trigger '/'
zstyle ':fzf-tab:*' switch-group '<' '>'
zstyle ':fzf-tab:*' fzf-flags '--color=16' '--preview-window=right:55%:wrap'

# File and directory previews
zstyle ':fzf-tab:complete:*:*' fzf-preview '
  if [ -d "$realpath" ]; then
    eza --tree --level=2 --color=always --icons=auto --group-directories-first "$realpath" 2>/dev/null || ls -la "$realpath"
  elif [ -f "$realpath" ]; then
    bat --color=always --style=numbers --line-range=:80 "$realpath" 2>/dev/null || cat "$realpath"
  fi'

# Git previews
zstyle ':fzf-tab:complete:git-(add|diff|restore):*' fzf-preview 'git diff --color=always $word 2>/dev/null'
zstyle ':fzf-tab:complete:git-(checkout|switch):*' fzf-preview 'git log --oneline --graph --color=always -n 12 $word 2>/dev/null'
zstyle ':fzf-tab:complete:git-show:*' fzf-preview 'git show --stat --patch --color=always $word 2>/dev/null'
zstyle ':fzf-tab:complete:git-log:*' fzf-preview 'git log --oneline --graph --color=always -n 15 $word 2>/dev/null'

# Formatted, compact process preview for kill
zstyle ':fzf-tab:complete:kill:argument-rest' fzf-preview '
  ps -p $word -o user,pid,%cpu,%mem,stat,time,command 2>/dev/null'

# Systemctl service preview
zstyle ':fzf-tab:complete:systemctl-*:*' fzf-preview 'SYSTEMD_COLORS=1 systemctl status $word 2>/dev/null'

# Environment variables and binaries
zstyle ':fzf-tab:complete:(-command-|-parameter-|-brace-parameter-|export|unset|expand):*' fzf-preview 'echo ${(P)word}'
zstyle ':fzf-tab:complete:which:*' fzf-preview 'which $word 2>/dev/null'

# Autosuggestion styling (uses terminal color 8 / muted gray)
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=8"
export ZSH_AUTOSUGGEST_STRATEGY=(history completion)
export ZSH_AUTOSUGGEST_USE_ASYNC=true
