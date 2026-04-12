#!/usr/bin/env bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPT_ROOT_DIR="$(basename $SCRIPT_DIR)"
INSTALL_SCRIPT="${SCRIPT_ROOT_DIR}/scripts/check-lid-open.sh"
DEST_SCRIPT="/usr/local/bin/check-lid-open"

# Installing check-lid-open script
if [ ! -e $DEST_SCRIPT ]; then
    sudo cp $INSTALL_SCRIPT $DEST_SCRIPT
    sudo chmod +x $DEST_SCRIPT
fi

# Add the script to PAM sudo
if ! grep -q check-lid-open /etc/pam.d/sudo; then
    echo "auth    [success=ok default=1] pam_exec.so quiet $DEST_SCRIPT" | cat - /etc/pam.d/sudo | sudo tee /etc/pam.d/sudo
fi
