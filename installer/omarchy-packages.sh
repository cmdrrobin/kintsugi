#!/usr/bin/env bash

set -e

PKG_PACKAGES="jujutsu tailscale"
# install required packages
omarchy pkg add "$PKG_PACKAGES"

AUR_PACKAGES="sesh-bin"
# install optional AUR packages
omarchy pkg aur add "$AUR_PACKAGES"
