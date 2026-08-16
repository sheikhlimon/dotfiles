# History file and limits
HISTFILE="${XDG_STATE_HOME:-$HOME/.local/state}/zsh/history"
HISTSIZE=50000
SAVEHIST=50000
[[ -d "${XDG_STATE_HOME:-$HOME/.local/state}/zsh" ]] || mkdir -p "${XDG_STATE_HOME:-$HOME/.local/state}/zsh"

# Disable terminal beeping
setopt NO_BEEP NO_LIST_BEEP NO_HIST_BEEP

# History options
setopt HIST_VERIFY
setopt HIST_SAVE_NO_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_SPACE
setopt EXTENDED_HISTORY
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_ALL_DUPS

# Navigation and completion options
setopt AUTO_CD
setopt EXTENDED_GLOB
setopt COMPLETE_IN_WORD
setopt ALWAYS_TO_END
setopt AUTO_MENU
unsetopt MENU_COMPLETE
export LISTMAX=10000

# Disable autocorrect prompts
unsetopt AUTO_NAME_DIRS CORRECT CORRECT_ALL

zle_highlight+=(paste:none)
