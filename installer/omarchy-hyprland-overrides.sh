#!/usr/bin/env bash

set -e

HYPRLAND_CONFIG="$HOME/.config/hypr/hyprland.conf"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPT_ROOT_DIR="$(basename $SCRIPT_DIR)"
SOURCE_LINE="source = ~/.config/hypr/hyprland-overrides.conf"

# Check if hyprland config exists
if [ ! -f "$HYPRLAND_CONFIG" ]; then
    echo "Hyprland config not found at $HYPRLAND_CONFIG"
    echo "Please install hyprland first"
    exit 1
fi

# Check if source line already exists in hyprland.conf
if grep -Fxq "$SOURCE_LINE" "$HYPRLAND_CONFIG"; then
    echo "Source line already exists in $HYPRLAND_CONFIG"
else
    echo "Adding source line to $HYPRLAND_CONFIG"
    echo -e "\n# Custom overrides" >> "$HYPRLAND_CONFIG"
    echo "$SOURCE_LINE" >> "$HYPRLAND_CONFIG"
    echo "Source line added successfully"
fi

echo "Hyprland overrides setup complete!"
