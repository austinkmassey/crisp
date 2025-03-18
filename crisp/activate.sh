#!/usr/bin/env bash
# Activate Crisp environment in the current shell.

crisp=$(yq -r ".crisp.crisp_dir" $1) 
source "$crisp/scripts/environment.sh"
activate $crisp
