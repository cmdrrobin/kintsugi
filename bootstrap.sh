#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OS_NAME="$(uname -s)"

# Install Omarchy add-ons first
for omarchy in "${SCRIPT_DIR}/installer/omarchy-*.sh"; do
    $omarchy
done

# Install the rest
for script in $(find $SCRIPT_DIR/installer -type f ! -name "omarchy-*.sh"); do
    $script
done
