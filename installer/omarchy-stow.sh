#!/usr/bin/env bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPT_ROOT_DIR="$(basename $SCRIPT_DIR)"
CONFIGS="${SCRIPT_ROOT_DIR}/configs"

STOW_CONFIGS="ghostty git hypr hyprdynamicmonitors jj mako opencode sesh starship systemd tmux waybar zsh"

yay -Sy stow || exit 1

for folder in $STOW_CONFIGS; do
    stow -v -d "$CONFIGS" -t ~ $folder
done
