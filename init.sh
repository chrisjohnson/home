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

if [[ ! -a "$HOME/.config/herdr/config.toml" && ! -h "$HOME/.config/herdr/config.toml" ]]; then
	mkdir -p ~/.config/herdr
	ln -s ~/.home/herdr/config.toml ~/.config/herdr/config.toml
fi

if [[ ! -a "$HOME/.config/nvim/init.vim" && ! -h "$HOME/.config/nvim/init.vim" ]]; then
	mkdir -p ~/.config/nvim/
	ln -s ~/.home/nvim/init.vim ~/.config/nvim/init.vim
fi

if [[ ! -a "$HOME/Library/Application Support/com.mitchellh.ghostty/config" && ! -h "$HOME/Library/Application Support/com.mitchellh.ghostty/config" ]]; then
	mkdir -p ~/Library/Application\ Support/com.mitchellh.ghostty
	ln -s ~/.home/ghostty/config ~/Library/Application\ Support/com.mitchellh.ghostty/config
fi

setopt EXTENDED_GLOB
for rcfile in "${ZDOTDIR:-$HOME}"/.home/zsh/prezto/runcoms/^(README.md|zshenv)(.N); do
	if [ ! -s "${ZDOTDIR:-$HOME}/.${rcfile:t}" ]; then
		ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
	fi
done

if type asdf &>/dev/null; then
	if ! type tmux &>/dev/null; then
		asdf plugin add tmux
		brew install libevent ncurses pkg-config utf8proc
		asdf install tmux latest
		asdf set -u tmux latest
	fi

	if ! type go &>/dev/null; then
		asdf plugin add golang https://github.com/asdf-community/asdf-golang.git
		asdf install golang latest
		asdf set -u golang latest
	fi

	if ! type rg &>/dev/null; then
		asdf plugin add ripgrep
		asdf install ripgrep latest
		asdf set -u ripgrep latest
	fi

	if ! type fd &>/dev/null; then
		asdf plugin add fd
		asdf install fd latest
		asdf set -u fd latest
	fi

	if ! type fzf &>/dev/null; then
		asdf plugin add fzf
		asdf install fzf latest
		asdf set -u fzf latest
	fi

	if ! type stern &>/dev/null; then
		asdf plugin add stern
		asdf install stern latest
		asdf set -u stern latest
	fi

	if ! type herdr &>/dev/null; then
		asdf plugin add herdr https://github.com/chrisjohnson/asdf-herdr.git
		asdf install herdr latest
		asdf set -u herdr latest
		# Reshim immediately so the herdr binary is visible in this subshell
		asdf reshim herdr
	fi


	# Safely handle herdr plugin management
	if type herdr &>/dev/null; then
		# Capture JSON output to a variable to prevent jq from waiting on stdin
		local plugins_json
		plugins_json=$(herdr plugin list --json 2>/dev/null)

		if [[ -n "$plugins_json" ]]; then
			if ! echo "$plugins_json" | jq -e '.result.plugins[]? | select(.plugin_id == "attention.jump")' &>/dev/null; then
				herdr plugin add milkyskies/herdr-attention
			fi

			if ! echo "$plugins_json" | jq -e '.result.plugins[]? | select(.plugin_id == "dantehemerson.last-tab")' &>/dev/null; then
				herdr plugin add dantehemerson/herdr-last-tab
			fi

			if ! echo "$plugins_json" | jq -e '.result.plugins[]? | select(.plugin_id == "herdr-focus-notify")' &>/dev/null; then
				herdr plugin add yankewei/herdr-focus-notify
			fi
		else
			# Fallback if herdr JSON is blank/fails: try installing them directly
			herdr plugin add milkyskies/herdr-attention 2>/dev/null || true
			herdr plugin add dantehemerson/herdr-last-tab 2>/dev/null || true
			herdr plugin add yankewei/herdr-focus-notify 2>/dev/null || true
		fi
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
