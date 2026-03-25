#!/bin/zsh

if type asdf &>/dev/null; then
	if ! type kubelogin &>/dev/null; then
		asdf plugin add kubelogin
		asdf install kubelogin latest
		asdf set -u kubelogin latest
	fi

	if ! type az &>/dev/null; then
		asdf plugin add azure-cli
		asdf install azure-cli latest
		asdf set -u azure-cli latest
	fi

	if ! type kubectl &>/dev/null; then
		asdf plugin add kubectl
		asdf install kubectl latest
		asdf set -u kubectl latest
	fi

	if ! type helm &>/dev/null; then
		asdf plugin add helm
		asdf install helm latest
		asdf set -u helm latest
	fi

	if ! type switcher &>/dev/null; then
		asdf plugin add kubeswitch https://github.com/chrisjohnson/asdf-kubeswitch.git
		asdf install kubeswitch latest
		asdf set -u kubeswitch latest
	fi
else
	echo "Missing asdf needed to install other dependencies!"
fi
