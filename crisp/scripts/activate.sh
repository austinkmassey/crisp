#!/usr/bin/env bash
#
# Activate Crisp environment in the current shell.

CRISP_SCRIPTS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CRISP_DIR="$(cd "${CRISP_SCRIPTS_DIR}/.." && pwd)"

# Add Crisp to the PATH
if [[ ":$PATH:" != *":$CRISP_DIR:"* ]]; then
  export PATH="${CRISP_DIR}:$PATH"
fi

export CRISP_ACTIVE="true"

echo "Crisp activated in this shell."
echo "Crisp directory: $CRISP_DIR"

