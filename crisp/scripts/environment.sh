#!/usr/bin/env bash

function crisp_status() {
  if [[ -n "${CRISP_ACTIVE:-}" ]]; then
    echo "Crisp is ACTIVE in this shell."
  else
    echo "Crisp is NOT active in this shell. Run:"
    echo "  source $crisp_dir/scripts/activate.sh"
    echo "to activate Crisp in this terminal session."
  fi

  echo "Activated: ${CRISP_ACTIVE}"
  echo "Parent:    ${CRISP_PROJECT}"
  echo "Docs:      ${CRISP_DOC}"
  echo "Crisp:     ${CRISP_ROOT}"
  echo "Scripts:   ${CRISP_SCRIPT}"
}

function activate() {
  crisp="$1"
  echo $crisp
  scripts="$1/scripts"

  if [[ -z "$crisp" ]]; then
    echo "Crisp directory does not exist"
    return 1
  fi

  if [[ -n "$CRISP_ACTIVE" ]]; then
    echo "A crisp environment, is already active in this shell."
    return 1
  fi

  # Add Crisp to the PATH
  if [[ ":$PATH:" != *":$crisp:"* ]]; then
    export PATH="${crisp}:$PATH"
  fi
  
  export CRISP_ACTIVE="true"
  export CRISP_PROJECT=$(cd "$crisp/.." && pwd)
  export CRISP_DOC=$(cd "$crisp/.." && pwd)/$(yq -r ".crisp.output_directory" "$crisp/config.yaml")
  export CRISP_ROOT="$crisp"
  export CRISP_SCRIPT="$scripts"
  
  echo "Crisp activated in this shell."
  echo "Crisp directory: $CRISP_ROOT"
}

function deactivate() {
  if [[ -n "$CRISP_ACTIVE" ]]; then
    export PATH=$(echo $PATH | sed -e "s;:$CRISP_ROOT;;" -e "s;$CRISP_ROOT:;;") 
    unset CRISP_ACTIVE
    unset CRISP_PROJECT
    unset CRISP_DOC
    unset CRISP_ROOT
    unset CRISP_SCRIPT
    echo "Crisp deactivated."
  else
    echo "Crisp was not active."
  fi
}
