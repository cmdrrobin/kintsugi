#!/usr/bin/env bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPT_ROOT_DIR="$(basename $SCRIPT_DIR)"

# Install required packages
if ! command -v hyprdynamicmonitors &> /dev/null; then
    yay -Sy hyprdynamicmonitors-bin
fi

# Make sure upower application is available
if ! command -v upower &> /dev/null; then
    yay -Sy upower
fi

# Make sure required custom folder exists
if [ ! -d $HOME/.config/systemd/user/hyprdynamicmonitors.service.d ]; then
    mkdir -p $HOME/.config/systemd/user/hyprdynamicmonitors.service.d
fi
