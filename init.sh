#!/bin/zsh

git submodule update --init --recursive

if [ ! -s ~/.zshrc ]; then
	ln -s ~/.home/.zshrc ~/.zshrc
fi
if [ ! -s ~/.zpreztorc ]; then
	ln -s ~/.home/.zpreztorc ~/.zpreztorc
fi

setopt EXTENDED_GLOB
for rcfile in "${ZDOTDIR:-$HOME}"/.home/.prezto/runcoms/^README.md(.N); do
	if [ ! -s "${ZDOTDIR:-$HOME}/.${rcfile:t}" ]; then
		ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
	fi
done
