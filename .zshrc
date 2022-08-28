if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

#PATH
if [ -d "$HOME/.bin" ] ;
  then PATH="$HOME/.bin:$PATH"
fi

if [ -d "$HOME/.local/bin" ] ;
  then PATH="$HOME/.local/bin:$PATH"
fi

#exports
ZSH_THEME="powerlevel10k/powerlevel10k"
export ZSH="$HOME/.srcs/.oh-my-zsh"
export EDITOR=/usr/bin/nvim
export VISUAL=/usr/bin/nvim
export MANPAGER="sh -c 'col -bx | bat -l man -p'"

#for loading prompt themes in zsh and colors
autoload -U promptinit; promptinit
autoload -U colors && colors

setopt autocd  #Automatically cd into typed directory

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

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
