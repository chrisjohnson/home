#!/bin/zsh

git pull || { echo 'Failed to pull, stopping here' && exit 1 ; }
git submodule update --init --recursive

for file in .zshrc .zpreztorc .fzf.zsh; do
	if [[ ! -a "$HOME/$file" && ! -h "$HOME/$file" ]]; then
		ln -s ~/.home/zsh/$file ~/$file
	fi
done

for file in .tmux.conf .tmux .gitconfig .vim .vimrc; do
	if [[ ! -a "$HOME/$file" && ! -h "$HOME/$file" ]]; then
		ln -s ~/.home/$file ~/$file
	fi
done

iterm_settings=".iterm-settings/com.googlecode.iterm2.plist"
if [[ ! -a "$HOME/$iterm_settings" && ! -h "$HOME/$iterm_settings" ]]; then
	mkdir -p ~/.iterm-settings
	ln -s ~/.home/$iterm_settings ~/$iterm_settings
fi

setopt EXTENDED_GLOB
for rcfile in "${ZDOTDIR:-$HOME}"/.home/zsh/prezto/runcoms/^README.md(.N); do
	if [ ! -s "${ZDOTDIR:-$HOME}/.${rcfile:t}" ]; then
		ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
	fi
done

type rg &>/dev/null || { echo 'rg not installed!' ; }
type fzf &>/dev/null || { echo 'fzf not installed!' ; }
type tmux &>/dev/null || { echo 'tmux not installed!' ; }
