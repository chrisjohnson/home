# Setup fzf (handle various environments)
if [[ -a "/usr/local/opt/fzf" ]]; then
	# OS X
	FZF_SHELL_PATH="/usr/local/opt/fzf/shell"
	FZF_BIN_PATH="/usr/local/opt/fzf/bin"
elif [[ -a "/usr/share/fzf" ]]; then
	# Linux
	FZF_SHELL_PATH="/usr/share/fzf"
else
	# Could not locate fzf install, nothing to do here
	return
fi

# $PATH
# If fzf is not already found in $PATH, check to see if it's because $FZF_BIN_PATH is missing from $PATH, and add it if so
type fzf &>/dev/null || { "$PATH" != *"$FZF_BIN_PATH"* && export PATH="$PATH:$FZF_BIN_PATH" ; }

# Auto-completion
[[ $- == *i* ]] && source "$FZF_SHELL_PATH/completion.zsh" 2> /dev/null

# Key bindings
source "$FZF_SHELL_PATH/key-bindings.zsh"

# Use rg wherever possible
type rg &>/dev/null || return

export FZF_DEFAULT_COMMAND='rg --files --hidden --follow'
_fzf_compgen_path() {
	rg --hidden --files --follow "$1" 2>/dev/null
}
if [[ $(uname) == "Darwin" ]]; then
	# dirname on OS X behaves funky, get gdirname via
	# brew install coreutils
	export dirname_command="gdirname"
else
	export dirname_command="dirname"
fi
_fzf_compgen_dir() {
	rg --hidden --files --null "$1" 2>/dev/null | xargs -0 "$dirname_command" | sort | uniq
}
