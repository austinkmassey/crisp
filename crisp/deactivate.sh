#!/usr/bin/env bash
# Activate Crisp environment in the current shell.

crisp="$(realpath $(dirname "$0"))"
source "$crisp/scripts/environment.sh"

deactivate
