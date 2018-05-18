# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.home/zsh/prezto/init.zsh" ]]; then
	source "${ZDOTDIR:-$HOME}/.home/zsh/prezto/init.zsh"
fi

# Source z
if [[ -s "/usr/local/etc/profile.d/z.sh" ]]; then
	. /usr/local/etc/profile.d/z.sh
fi

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

source $HOME/.home/zsh/.zshrc_common

# Key bindings
bindkey "\e[1;9C" forward-word
bindkey "\e[1;9D" backward-word
