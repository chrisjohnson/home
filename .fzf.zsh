# Setup fzf
# ---------
if [[ "$FZF_BASE_PATH" == "" ]]; then
	export FZF_BASE_PATH="/usr/local/opt/fzf"
fi

if [[ ! "$PATH" == *"$FZF_BASE_PATH/bin"* ]]; then
  export PATH="$PATH:$FZF_BASE_PATH/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "$FZF_BASE_PATH/shell/completion.zsh" 2> /dev/null

# Key bindings
# ------------
source "$FZF_BASE_PATH/shell/key-bindings.zsh"

