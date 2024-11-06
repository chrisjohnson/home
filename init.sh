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

if type asdf &>/dev/null; then
	if ! type rg &>/dev/null; then
		asdf plugin-add ripgrep
		asdf install ripgrep latest
		asdf global ripgrep latest
	fi

	if ! type fd &>/dev/null; then
		asdf plugin-add fd
		asdf install fd latest
		asdf global fd latest
	fi

	if ! type fzf &>/dev/null; then
		asdf plugin-add fzf
		asdf install fzf latest
		asdf global fzf latest
	fi

	if ! type stern &>/dev/null; then
		asdf plugin-add stern
		asdf install stern latest
		asdf global stern latest
	fi
fi

type rg &>/dev/null || { echo 'rg not installed!' ; }
type ctags &>/dev/null || { echo 'ctags not installed!' ; }
ctags --version | grep -qi exuberant || { echo 'exuberant-ctags not installed! brew install ctags' ; }
type fd &>/dev/null || { echo 'fd not installed!' ; }
type fzf &>/dev/null || { echo 'fzf not installed!' ; }
type mosh &>/dev/null || { echo 'mosh not installed!' ; }
brew --prefix kube-ps1 &>/dev/null || { echo 'kube-ps1 not installed!' ; }
type tmux &>/dev/null || { echo 'tmux not installed!' ; }
type tmuxinator &>/dev/null || { echo 'tmuxinator not installed!' ; }
type pip &>/dev/null || { echo 'pip not installed!' ; }
type stern &>/dev/null || { echo 'stern not installed!' ; }
brew --prefix switch &>/dev/null || { echo 'switch not installed!' ; }
type reattach-to-user-namespace &>/dev/null || { echo 'reattach-to-user-namespace not installed!' ; }
type pydf &>/dev/null || { echo 'pydf not installed!' ; }
