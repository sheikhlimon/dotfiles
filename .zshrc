#PATH
if [ -d "$HOME/.bin" ] ;
  then PATH="$HOME/.bin:$PATH"
fi

if [ -d "$HOME/.local/bin" ] ;
  then PATH="$HOME/.local/bin:$PATH"
fi

#exports
#ZSH_THEME="simple"
export ZSH="$HOME/.srcs/.oh-my-zsh"
export EDITOR=/usr/bin/nvim
export VISUAL=/usr/bin/nvim
export MANPAGER="sh -c 'col -bx | bat -l man -p'"

#for loading prompt themes in zsh and colors
autoload -U promptinit; promptinit
autoload -U colors && colors

# Load Version control information
autoload -Uz vcs_info
precmd() { vcs_info }

# Format the vcs_info_msg_0_ variable
zstyle ':vcs_info:git:*' formats "%b"

#git prompt 
ZSH_THEME_GIT_PROMPT_PREFIX=""
ZSH_THEME_GIT_PROMPT_SUFFIX=""
ZSH_THEME_GIT_PROMPT_DIRTY=" ✘"
ZSH_THEME_GIT_PROMPT_CLEAN=" ✔"
ZSH_THEME_GIT_PROMPT_ADDED=" ✚"
ZSH_THEME_GIT_PROMPT_MODIFIED=" ✹"
ZSH_THEME_GIT_PROMPT_DELETED=" ✖"
ZSH_THEME_GIT_PROMPT_RENAMED=" ➜"
ZSH_THEME_GIT_PROMPT_UNMERGED=" ═"
ZSH_THEME_GIT_PROMPT_UNTRACKED=" ✭"

#change prompt
#precmd() {print ""}  #newline for prompt

setopt prompt_subst
PROMPT="%F{011}%~ %F{010}"$'\n'" ❯ %f"
RPROMPT='%F{060}${vcs_info_msg_0_}`git_prompt_status`'
setopt autocd  #Automatically cd into typed directory
local return_code="%(?..%{$fg[red]%}%? ↵%{$reset_color%})"

#for not showing % at the end of cpp run files
PROMPT_EOL_MARK=''

#vi mode 
export KEYTIMEOUT=1

#history in cahce directory
HISTSIZE=50000
SAVEHIST=50000
HISTFILE=~/.cache/.zsh_history
HIST_STAMPS="dd/mm/yyyy"

plugins=(
	vi-mode
	zsh-autosuggestions
	zsh-syntax-highlighting
    z
)

#basic auto/tab complete
zstyle ':completion:*' menu select
autoload -U compinit && compinit
zmodload zsh/complist
_comp_options+=(globdots) # lets you tab complete hidden files by default


# Load ; should be last
source "$ZSH"/oh-my-zsh.sh

[[ -f ~/.zshrc-personal ]] && . ~/.zshrc-personal

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=60' #auto suggest highlight
#colorscript -r
#neofetch
