#  Plugins 
plugins=(
    vi-mode
)
#  Aliases 
[[ -f ~/.zshrc-personal ]] && . ~/.zshrc-personal

# Add your configurations here
export EDITOR=nvim
export TERM=kitty

#vi-mode
export KEYTIMEOUT=1

#for not showing % at the end of cpp run files
PROMPT_EOL_MARK=''

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# fnm
FNM_PATH="/home/limon/.local/share/fnm"
if [ -d "$FNM_PATH" ]; then
  export PATH="/home/limon/.local/share/fnm:$PATH"
  eval "`fnm env`"
fi

eval "$(zoxide init zsh)"
