#!/bin/bash

set -e

trap 'exit 1' 1 2 3 6

# PAM script to check if laptop lid is open
# Returns 0 (success) if lid is open, allowing fingerprint authentication
# Returns 1 (failure) if lid is closed, skipping fingerprint authentication

LID_STATE_FILE="/proc/acpi/button/lid/LID0/state"
FALLBACK_LID_STATE_FILE="/proc/acpi/button/lid/LID/state"

# Check if lid state file exists
if [ -f "$LID_STATE_FILE" ]; then
    STATE_FILE="$LID_STATE_FILE"
elif [ -f "$FALLBACK_LID_STATE_FILE" ]; then
    STATE_FILE="$FALLBACK_LID_STATE_FILE"
else
    # If no lid state file exists, assume desktop/docked, allow fingerprint
    exit 0
fi

# Read lid state
LID_STATE=$(cat "$STATE_FILE" | grep -oP 'state:\s+\K\w+')

# Allow fingerprint only if lid is open
if [ "$LID_STATE" = "open" ]; then
    exit 0  # PAM_SUCCESS - continue to fingerprint auth
else
    exit 1  # PAM_AUTH_ERR - skip fingerprint, fall through to password
fi
