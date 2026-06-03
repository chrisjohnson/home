#!/bin/zsh

if type asdf &>/dev/null; then
	if ! type kubelogin &>/dev/null; then
		asdf plugin add kubelogin
		asdf install kubelogin latest
		asdf set -u kubelogin latest
	fi

	if ! type k9s &>/dev/null; then
		asdf plugin add k9s
		asdf install k9s latest
		asdf set -u k9s latest
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

	if ! type k3d &>/dev/null; then
		asdf plugin add k3d
		asdf install k3d latest
		asdf set -u k3d latest
	fi

	if ! type istioctl &>/dev/null; then
		asdf plugin add istioctl
		asdf install istioctl latest
		asdf set -u istioctl latest
	fi

	if ! type yq &>/dev/null; then
		asdf plugin add yq
		asdf install yq latest
		asdf set -u yq latest
	fi

	if ! type tilt &>/dev/null; then
		asdf plugin add tilt
		asdf install tilt latest
		asdf set -u tilt latest
	fi
else
	echo "Missing asdf needed to install other dependencies!"
fi
