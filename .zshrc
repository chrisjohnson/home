# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.home/.prezto/init.zsh" ]]; then
	source "${ZDOTDIR:-$HOME}/.home/.prezto/init.zsh"
fi

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow --glob "!.git/*"'

source $HOME/.home/.zshrc_common

# Key bindings
bindkey "\e[1;9C" forward-word
bindkey "\e[1;9D" backward-word
