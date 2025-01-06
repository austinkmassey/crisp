#!/usr/bin/env bash
#
# Activate Crisp environment in the current shell.
source "$(dirname "${BASH_SOURCE[0]}")/helpers.sh"

CRISP_DIR="$(get_crisp_root)"
CRISP_SCRIPTS_DIR="$(get_scripts_dir)"

# Add Crisp to the PATH
if [[ ":$PATH:" != *":$CRISP_DIR:"* ]]; then
  export PATH="${CRISP_DIR}:$PATH"
fi

export CRISP_ACTIVE="true"
export CRISP_ROOT="$(get_crisp_root)"
export CRISP_PROJECT="$(get_parent_project)"
export CRISP_SCRIPT="$(get_scripts_dir)"
export CRISP_DOC="$(get_output_dir)"

echo "Crisp activated in this shell."
echo "Crisp directory: $CRISP_DIR"

