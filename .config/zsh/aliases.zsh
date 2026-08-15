# Aliases and custom functions

# Editor
alias vim='nvim'
alias py='python'

# File system (eza)
alias cd='z'
alias l='eza -lh --icons=auto --group-directories-first'
alias ll='eza -lhag --icons=auto --sort=name --group-directories-first'
alias ls='eza -a --grid --icons=auto --sort=name --group-directories-first'
alias lsa='eza -lha --icons=auto --sort=name --group-directories-first'
alias lt='eza -l --tree --level=2 --group-directories-first --icons=auto --git --git-ignore'
alias lta='lt -a'

# Git, YADM and container shortcuts
alias g='git'
alias d='docker'
alias lg='lazygit'
alias ylg='yadm enter lazygit'
alias screenrec='gpu-screen-recorder -w screen -c mp4 -f 30 -s 1280x720 -o ~/Videos/recording-$(date +%Y%m%d-%H%M%S).mp4'
alias gcm='git commit'
alias gcam='git commit -a'
alias gcd='git commit --amend'
alias gcad='git commit -a --amend'

# YADM helper: allow `yadm lazygit` and `yadm lg` directly
yadm() {
  if [[ "$1" == "lazygit" || "$1" == "lg" ]]; then
    command yadm enter lazygit
  else
    command yadm "$@"
  fi
}

# Search history
alias h="history | grep "

# Disk usage
alias diskspace="du -S | sort -n -r |more"
alias folders='du -h --max-depth=1'
alias countfiles="find . -type f | wc -l && echo 'files'; find . -type l | wc -l && echo 'links'; find . -type d | wc -l && echo 'directories'"

# Utilities
alias c='clear'
alias q='exit'
alias grep='grep --color=auto'
alias cat='bat --paging=never'
alias less='bat'
alias multitail='multitail --no-repeat -c'
alias mkdir='mkdir -p'
alias mv='mv -i'
alias rm='trash -v'
alias wget="wget -c"
alias killp='killprocess'
alias zupdate='for d in ~/.local/share/zsh/plugins/*; do echo "==> Updating $(basename $d)..."; git -C "$d" pull --ff-only; done'
alias help="bat ~/.config/zsh/aliases.zsh"

# Podman helpers
alias podman-kill='pkill -f electron && pkill -f "watch.mjs" && pkill -f "pnpm.*watch" && pkill -f "vite.*build"'
alias podman-ps='ps aux | grep -E "(electron.*podman|watch.mjs|vite.*podman)" | grep -v grep'

# Custom helper functions

# Attach to existing tmux session or create new one
t() {
  [[ -n $TMUX ]] && echo "Already in tmux" && return
  tmux list-sessions &>/dev/null && tmux attach || tmux new -s main
}

# Smart cd with z
zd() {
  if [ $# -eq 0 ]; then
    builtin cd ~ && return
  elif [ -d "$1" ]; then
    builtin cd "$1"
  else
    z "$@" && printf " \U000F17A9 " && pwd || echo "Error: Directory not found"
  fi
}

# Open anything in their respective desktop application
open() {
  xdg-open "$@" >/dev/null 2>&1 &
}

# ripgrep -> fzf -> nvim [QUERY]
rgf() (
  RELOAD='reload:rg --column --color=always --smart-case {q} || :'
  OPENER='if [[ $FZF_SELECT_COUNT -eq 0 ]]; then
            nvim {1} +{2}
          else
            nvim +cw -q {+f}
          fi'

  fzf --disabled --ansi --multi \
      --bind "start:$RELOAD" --bind "change:$RELOAD" \
      --bind "enter:become:$OPENER" \
      --bind "ctrl-o:execute:$OPENER" \
      --bind 'alt-a:select-all,alt-d:deselect-all,ctrl-/:toggle-preview' \
      --delimiter : \
      --preview 'bat --style=full --color=always --highlight-line {2} {1}' \
      --preview-window '~4,+{2}+4/3,<80(up)' \
      --query "$*"
)

# Yazi file manager wrapper (changes directory on exit)
function y() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
  yazi "$@" --cwd-file="$tmp"
  IFS= read -r -d '' cwd < "$tmp"
  [ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
  rm -f -- "$tmp"
}

# Compile and run C++ files
function cpp() {
  filename=$1
  re="^\#include \""
  while read line
  do
    if [[ $line =~ $re ]]; then
      temp=${line:9}
      temp1=${temp#\"}
      temp2=${temp1%\.*\"}
      g++ -std=c++17 -c $temp2.cpp
    fi
  done < $filename.cpp
  g++ -std=c++17 -c $filename.cpp
  g++ -o $filename *.o
  ./$filename
  rm -f *.o
}

# Directory helpers
cpg() { [ -d "$2" ] && cp "$1" "$2" && cd "$2" || cp "$1" "$2"; }
mvg() { [ -d "$2" ] && mv "$1" "$2" && cd "$2" || mv "$1" "$2"; }
mkdirg() { mkdir -p "$1" && cd "$1"; }

# ISO to SD Card
iso2sd() {
  if [ $# -ne 2 ]; then
    echo "Usage: iso2sd <input_file> <output_device>"
    echo "Example: iso2sd ~/Downloads/ubuntu.iso /dev/sdb"
    echo -e "\nAvailable SD cards:"
    lsblk -d -o NAME | grep -E '^sd[a-z]' | awk '{print "/dev/"$1}'
  else
    sudo dd bs=4M status=progress oflag=sync if="$1" of="$2"
    sudo eject $2
  fi
}

# Image conversions
img2jpg() { magick "$1" -quality 95 -strip "${1%.*}.jpg"; }
img2jpg-small() { magick "$1" -resize 1080x\> -quality 95 -strip "${1%.*}.jpg"; }
img2png() {
  magick "$1" -strip -define png:compression-filter=5 \
    -define png:compression-level=9 \
    -define png:compression-strategy=1 \
    -define png:exclude-chunk=all "${1%.*}.png"
}

# Video transcoding (1080p, 720p, 480p)
transcode-video-1080p() {
  ffmpeg -i "$1" -vf "scale=-2:1080" -c:v libx264 -preset fast -crf 23 -c:a copy "${1%.*}-1080p.mp4"
}
transcode-video-720p() {
  ffmpeg -i "$1" -vf "scale=-2:720" -c:v libx264 -preset fast -crf 23 -c:a copy "${1%.*}-720p.mp4"
}
transcode-video-480p() {
  ffmpeg -i "$1" -vf "scale=-2:480" -c:v libx264 -preset fast -crf 23 -c:a copy "${1%.*}-480p.mp4"
}

# Speed up video
speedup-video() {
  local speed="${2:-2}"
  local input="$1"
  local vfilter="setpts=PTS/${speed}"
  local atempo
  if (( $(echo "$speed <= 2.0" | bc -l) )); then
    atempo="atempo=${speed}"
  else
    local remaining="$speed"
    atempo=""
    while (( $(echo "$remaining > 2.0" | bc -l) )); do
      atempo="${atempo}atempo=2.0,"
      remaining=$(echo "$remaining / 2.0" | bc -l)
    done
    atempo="${atempo}atempo=${remaining}"
  fi
  if ffmpeg -i "$input" 2>&1 | grep -q "Audio:"; then
    ffmpeg -i "$input" -filter_complex "[0:v]${vfilter}[v];[0:a]${atempo}[a]" \
      -map "[v]" -map "[a]" -c:v libx264 -preset fast -crf 23 "${input%.*}-${speed}x.mp4"
  else
    ffmpeg -i "$input" -filter_complex "[0:v]${vfilter}[v]" \
      -map "[v]" -c:v libx264 -preset fast -crf 23 "${input%.*}-${speed}x.mp4"
  fi
}

# Vi mode configuration
bindkey -v
export KEYTIMEOUT=15

# Cursor shape: block in normal mode, beam in insert mode
function zle-keymap-select {
  case $KEYMAP in
    vicmd) echo -ne '\e[2 q' ;;
    viins|main|'') echo -ne '\e[6 q' ;;
  esac
}
zle -N zle-keymap-select

function zle-line-init {
  zle -K viins
  echo -ne '\e[6 q'
}
zle -N zle-line-init

preexec() { echo -ne '\e[6 q'; }

# Native instantaneous escape with 'jj' or 'jk'
bindkey -M viins 'jj' vi-cmd-mode
bindkey -M viins 'jk' vi-cmd-mode

# Standard editing keys in insert mode
bindkey -M viins '^?' backward-delete-char
bindkey -M viins '^H' backward-delete-char
bindkey -M viins '^W' backward-kill-word
bindkey -M viins '^U' backward-kill-line
bindkey -M viins '^A' beginning-of-line
bindkey -M viins '^E' end-of-line

# Normal mode navigation & undo
bindkey -M vicmd 'k' up-line-or-history
bindkey -M vicmd 'j' down-line-or-history
bindkey -M vicmd 'H' beginning-of-line
bindkey -M vicmd 'L' end-of-line
bindkey -M vicmd 'u' undo
bindkey -M vicmd '^R' redo

# Select quoted text objects
autoload -U select-quoted select-bracketed
zle -N select-quoted

for m in visual viopp; do
  for c in 'a"' 'i"' "a'" "i'" 'a`' 'i`'; do
    bindkey -M $m $c select-quoted
  done
done


