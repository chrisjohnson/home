# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.home/zsh/prezto/init.zsh" ]]; then
	source "${ZDOTDIR:-$HOME}/.home/zsh/prezto/init.zsh"
fi

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

source $HOME/.home/zsh/.zshrc_common

# Key bindings
bindkey "\e[1;9C" forward-word
bindkey "\e[1;9D" backward-word
