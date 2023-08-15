#!/bin/zsh

git pull || { echo 'Failed to pull, stopping here' && exit 1 ; }
git submodule update --init --recursive

for file in .zshrc .zpreztorc; do
	if [[ ! -a "$HOME/$file" && ! -h "$HOME/$file" ]]; then
		ln -s ~/.home/zsh/$file ~/$file
	fi
done

for file in .gitconfig .vim .vimrc .ignore; do
	if [[ ! -a "$HOME/$file" && ! -h "$HOME/$file" ]]; then
		ln -s ~/.home/$file ~/$file
	fi
done

if [[ ! -a "$HOME/.zshenv" && ! -h "$HOME/.zshenv" ]]; then
	ln -s ~/.home/zsh/.zshenv ~/.zshenv
fi

if [[ ! -a "$HOME/.tmux.conf" && ! -h "$HOME/.tmux.conf" ]]; then
	ln -s ~/.home/tmux/oh-my-tmux/.tmux.conf ~/.tmux.conf
fi

if [[ ! -a "$HOME/.tmux.conf.local" && ! -h "$HOME/tmux/.tmux.conf.local" ]]; then
	ln -s ~/.home/tmux/oh-my-tmux.conf.local ~/.tmux.conf.local
fi

if [[ ! -a "$HOME/.config/nvim/init.vim" && ! -h "$HOME/.config/nvim/init.vim" ]]; then
	mkdir -p ~/.config/nvim/
	ln -s ~/.home/nvim/init.vim ~/.config/nvim/init.vim
fi

setopt EXTENDED_GLOB
for rcfile in "${ZDOTDIR:-$HOME}"/.home/zsh/prezto/runcoms/^(README.md|zshenv)(.N); do
	if [ ! -s "${ZDOTDIR:-$HOME}/.${rcfile:t}" ]; then
		ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
	fi
done

type rg &>/dev/null || { echo 'rg not installed!' ; }
type ctags &>/dev/null || { echo 'ctags not installed!' ; }
type fd &>/dev/null || { echo 'fd not installed!' ; }
type fzf &>/dev/null || { echo 'fzf not installed!' ; }
type mosh &>/dev/null || { echo 'mosh not installed!' ; }
type tmux &>/dev/null || { echo 'tmux not installed!' ; }
type tmuxinator &>/dev/null || { echo 'tmuxinator not installed!' ; }
type pip &>/dev/null || { echo 'pip not installed!' ; }
type stern &>/dev/null || { echo 'stern not installed!' ; }
type switch &>/dev/null || { echo 'switch not installed!' ; }
type reattach-to-user-namespace &>/dev/null || { echo 'reattach-to-user-namespace not installed!' ; }
type pydf &>/dev/null || { echo 'pydf not installed!' ; }
