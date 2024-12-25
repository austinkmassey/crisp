#!/usr/bin/env bash
#
# Deactivate Crisp environment in the current shell.

if [[ -n "$CRISP_ACTIVE" ]]; then
  unset CRISP_ACTIVE
  echo "Crisp deactivated."
else
  echo "Crisp was not active."
fi

##!/usr/bin/env bash
## deactivate.sh - Deactivates the environment by unsetting variables and removing PATH entry
#
#set -euo pipefail
#
#if [[ -n "${CRISP_ENV:-}" ]]; then
#    # Remove the environment's directory from PATH
#    PATH=$(echo "$PATH" | sed -E "s|:$CRISP_ENV||g;s|$CRISP_ENV:||g;s|$CRISP_ENV||g")
#    export PATH
#
#    # Unset the environment variable
#    unset CRISP_ENV
#
#    echo "Environment deactivated. CRISP_ENV unset and PATH entry removed."
#else
#    echo "No environment is currently active."
#fi


