#!/bin/zsh

git submodule update --init --recursive

for file in .zshrc .zpreztorc .tmux.conf .tmux .gitconfig .vim .vimrc; do
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
