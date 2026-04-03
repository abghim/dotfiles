#!/bin/bash

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

command -v gum >/dev/null 2>&1 || { echo "gum is required"; exit 1; }
command -v stow >/dev/null 2>&1 || { echo "stow is required"; exit 1; }

OPTIONS=(
	"shared/core"
	"shared/misc"
	"macos"
)

mapfile -t selections < <(gum choose --no-limit "${OPTIONS[@]}")

run_stow() {
	local mode="$1"
	local selection package_dir package_name

	for selection in "${selections[@]}"; do
		package_dir="$(dirname "$selection")"
		package_name="$(basename "$selection")"
		echo "$mode $selection -> $HOME"
		(
			cd "$REPO_ROOT/$package_dir"
			stow $mode -t "$HOME" "$package_name"
		)
	done
}

if [ "${#selections[@]}" -gt 0 ]; then
	gum confirm "Install these packages?" && run_stow ""
fi

if gum confirm "Install fonts to ~/.local/share/fonts?"; then
	font_dir="$HOME/.local/share/fonts"
	mkdir -p "$font_dir"
	echo "-n fonts -> $font_dir"
	gum confirm "Install fonts?" && stow -d "$REPO_ROOT" -t "$font_dir" fonts
fi

if gum confirm "Install HallaVim setup?" --default="No"; then
	curl https://gist.githubusercontent.com/abghim/e0fe0f7f5b97f807f6fb2890abbd4a60/raw/.hallavim-install.sh | bash
fi
