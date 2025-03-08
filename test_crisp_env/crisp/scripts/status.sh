#!/usr/bin/env bash
#
# Show Crisp status

# Source helper functions
source "$(dirname "${BASH_SOURCE[0]}")/helpers.sh"

function crisp_status() {
  
  if [[ -n "${CRISP_ACTIVE:-}" ]]; then
    echo "Crisp is ACTIVE in this shell."
  else
    echo "Crisp is NOT active in this shell. Run:"
    echo "  source $crisp_dir/scripts/activate.sh"
    echo "to activate Crisp in this terminal session."
  fi

  echo "Crisp Root:     ${CRISP_ROOT}"
  echo "Parent Project: ${CRISP_PROJECT}"
  echo "Scripts dir:    ${CRISP_SCRIPT}"
  echo "Docs dir:       ${CRISP_DOC}"
}
