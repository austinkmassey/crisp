#!/usr/bin/env bash
#
# Show Crisp status

# Source helper functions
source "$(dirname "${BASH_SOURCE[0]}")/helpers.sh"

function crisp_status() {
  local crisp_dir
  crisp_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

  # Get output directory from config.yaml
  local output_dir
  output_dir="$(get_output_dir)"

  echo "Crisp project folder: $crisp_dir"
  echo "Output directory: $output_dir"
  
  if [[ -n "${CRISP_ACTIVE:-}" ]]; then
    echo "Crisp is ACTIVE in this shell."
  else
    echo "Crisp is NOT active in this shell. Run:"
    echo "  source $crisp_dir/scripts/activate.sh"
    echo "to activate Crisp in this terminal session."
  fi
}

