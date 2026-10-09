#!/usr/bin/env bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPT_ROOT_DIR="$(basename $SCRIPT_DIR)"
CONFIGS="${SCRIPT_ROOT_DIR}/configs"

STOW_CONFIGS="bat ghostty git herdr hunk hypr jj opencode pi pipewire sesh starship tmux zsh"

if test ! -e stow; then
    omarchy pkg add stow
fi

for folder in $STOW_CONFIGS; do
    mkdir -p "$HOME/.config/$folder"
    stow -v -d "$CONFIGS" -t ~ "$folder"
done
