#!/usr/bin/env bash
# Activate Crisp environment in the current shell.

if [[ -z "$1" ]]; then
  echo "Config file does not exist"
  return 1
fi
crisp=$(yq -r ".crisp.crisp_dir" $1)
source "$crisp/scripts/environment.sh"
activate $crisp
