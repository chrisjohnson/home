# Setup fzf (handle a
if [[ -a "/usr/local/opt/fzf" ]]; then
	FZF_SHELL_PATH="/usr/local/opt/fzf/shell"
	FZF_BIN_PATH="/usr/local/opt/fzf/bin"
elif [[ -a "/usr/share/fzf" ]]; then
	FZF_SHELL_PATH="/usr/share/fzf"
else
	# Could not locate fzf install, nothing to do here
	return
fi

# $PATH
# If fzf is not already found in $PATH, check to see if it's because $FZF_BASE_PATH/bin is missing from $PATH, and add it if so
type fzf &>/dev/null || { "$PATH" != *"$FZF_BIN_PATH"* && export PATH="$PATH:$FZF_BIN_PATH" ; }

# Auto-completion
[[ $- == *i* ]] && source "$FZF_SHELL_PATH/completion.zsh" 2> /dev/null

# Key bindings
source "$FZF_SHELL_PATH/key-bindings.zsh"

