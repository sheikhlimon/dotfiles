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

#zsh theme
ZSH_THEME="powerlevel10k/powerlevel10k"

# fnm
FNM_PATH="/home/limon/.local/share/fnm"
if [ -d "$FNM_PATH" ]; then
  export PATH="/home/limon/.local/share/fnm:$PATH"
  eval "`fnm env`"
fi

#exports
export ZSH="$HOME/.oh-my-zsh"
export EDITOR=/usr/bin/nvim
export VISUAL=/usr/bin/nvim
export MANPAGER="sh -c 'col -bx | bat -l man -p'"

#for loading prompt themes in zsh and colors
autoload -U promptinit; promptinit
autoload -U colors && colors

#brew
export BREW_HOME="/home/linuxbrew/.linuxbrew/bin"
export PATH="$PATH:$BREW_HOME"

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
	  zsh-vimode-visual
	  zsh-autosuggestions
	  zsh-syntax-highlighting
    web-search
)

#basic auto/tab complete
zstyle ':completion:*' menu select
autoload -U compinit && compinit
zmodload zsh/complist
_comp_options+=(globdots) # lets you tab complete hidden files by default

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=60' #auto suggest highlight

eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
#oh-my-posh theme setup
#eval "$(oh-my-posh init zsh --config $(brew --prefix oh-my-posh)/themes/powerlevel10k_lean.omp.json)"

#starship 
#eval "$(starship init zsh)"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Load ; should be last
source "$ZSH"/oh-my-zsh.sh
[[ -f ~/.zshrc-personal ]] && . ~/.zshrc-personal
