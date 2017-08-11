PATH="$PATH:$HOME/bin:$HOME/.home/bin:$HOME/.home/bin/git"

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.home/.prezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.home/.prezto/init.zsh"
fi

source "$HOME/.home/bin/git/.zcompletion"
alias rgrep="grep -r"
alias vimconflicts='vim -p +/"<<<<<<<" $( git diff --name-only --diff-filter=U | xargs )'

bindkey "\e[1;9C" forward-word
bindkey "\e[1;9D" backward-word

# C-b to erase current prompt, run a command, then return the current prompt as it was
bindkey '^B' push-line

EDITOR="vim"
PAGER="less"
VISUAL="vim"

if [ -x ~/.zshrc_local ]; then
	. ~/.zshrc_local
fi
