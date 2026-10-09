#!/usr/bin/env bash

set -e

# Install Jujutsu for Starship
if test ! -e cargo; then
    echo "Missing Rust! Installing Rust..."
     omarchy install dev-env rust
fi

cargo install jj-starship
