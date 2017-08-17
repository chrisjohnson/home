# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.home/.prezto/init.zsh" ]]; then
	source "${ZDOTDIR:-$HOME}/.home/.prezto/init.zsh"
fi

PATH="$HOME/bin:$HOME/.home/bin:$HOME/.home/bin/git:$PATH"
# Note: git's git-completion.zsh file conflicts with zsh's _git file, you may have to rm/mv `/usr/local/share/zsh/site-functions/_git -> ../../../Cellar/git/2.14.1/share/zsh/site-functions/_git`
# TODO: Maybe brew install order matters here?
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

mvln(){
	# Get an absolute path for the target
	tp="`dirname $2`/`basename $2`/"
	tp="$tp:A"

	# If the target doesn't include a new filename, use the same filename as the source
	if [ -d "$2" ]; then
		t="$tp/`basename $1`"
	else
		t="$tp"
	fi

	# Full path to source, even if it was specified as relative
	s="$1:A"

	mv "$s" "$t" && ln -s "$t" "$s"
}
alias rsync.exact="rsync -rtpogxv -P -l -H"
alias rsync.loose="rsync -zvru -P"

if [ -s ~/.zshrc_local ]; then
	. ~/.zshrc_local
fi
