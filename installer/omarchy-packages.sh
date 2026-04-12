#!/usr/bin/env bash

set -e

PACKAGES="sesh-bin helium-bin jujutsu tailscale"
# install required packages
yay -Sy "$PACKAGES"
