#!/usr/bin/env bash
#
# Helper functions for Crisp scripts.

# Function to retrieve the output directory from config.yaml
get_output_dir() {
  local config_file="${CRISP_DIR}/config.yaml"
  if [[ -f "$config_file" ]]; then
    yq e '.crisp.output_directory' "$config_file"
  else
    echo "docs"  # Default output directory
  fi
}

