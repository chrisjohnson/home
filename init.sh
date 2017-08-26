#!/bin/zsh

git pull || { echo 'Failed to pull, stopping here' && exit 1 ; }
git submodule update --init --recursive

for file in .zshrc .zpreztorc .tmux.conf .tmux .gitconfig .vim .vimrc .fzf.zsh; do
	if [[ ! -a "$HOME/$file" ]]; then
		ln -s ~/.home/$file ~/$file
	fi
done

setopt EXTENDED_GLOB
for rcfile in "${ZDOTDIR:-$HOME}"/.home/.prezto/runcoms/^README.md(.N); do
	if [ ! -s "${ZDOTDIR:-$HOME}/.${rcfile:t}" ]; then
		ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
	fi
done

type rg &>/dev/null || { echo 'rg not installed!' ; }
type fzf &>/dev/null || { echo 'fzf not installed!' ; }
type tmux &>/dev/null || { echo 'tmux not installed!' ; }
