# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
# if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
#   source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
# fi

# we added 2 files to the project structure:
# 2. ~/.zshenv - for updating the zsh environment variables handled by HyDE // this will be modified across updates

#  Plugins 
plugins=(
    vi-mode
)
#  Aliases 
[[ -f ~/.zshrc-personal ]] && . ~/.zshrc-personal

# Add your configurations here
export EDITOR=nvim
export TERM=tmux-256color

#unset -f command_not_found_handler # Uncomment to prevent searching for commands not found in package manager

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# fnm
FNM_PATH="/home/limon/.local/share/fnm"
if [ -d "$FNM_PATH" ]; then
  export PATH="/home/limon/.local/share/fnm:$PATH"
  eval "`fnm env`"
fi

eval "$(zoxide init zsh)"

