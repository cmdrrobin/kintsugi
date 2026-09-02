#!/usr/bin/env bash

set -e

if test ! -e cargo; then
    echo "Make sure RUST is installed"
    exit 1
else
    cargo install jj-starship
fi
