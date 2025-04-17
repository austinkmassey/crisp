#!/usr/bin/env bash
#
# Add a new Crisp artifact (backlog, sprint, or session).

function crisp_add() {

  # Get type parameter and validate
  local type="${1:-}"
  if [[ -z "$type" ]]; then
    echo "Usage: crisp add <backlog|sprint|session>"
    exit 1
  fi
  if [[ ! "$type" =~ ^(backlog|sprint|session)$ ]]; then
    echo "Error: Unknown artifact type '$type'"
    echo "Usage: crisp add <backlog|sprint|session>"
    exit 1
  fi

  # Directory Variables
  local artifact_dir
  artifact_dir="${CRISP_DOC}/${type}"

  # Get and validate template file
  local template_file
  template_file="${CRISP_ROOT}/template/${type}.template"
  if [[ ! -f "$template_file" ]]; then
    echo "Error: Template file not found: $template_file"
    exit 1
  fi

  # Use output_directory for artifact storage
  mkdir -p "$artifact_dir"

  # Determine next artifact ID
  local last_file
  last_file="$(ls -1v "$artifact_dir" | grep -E '^[0-9]+\.md$' | tail -n 1 || true)"
  local next_num="001"

  if [[ -n "$last_file" ]]; then
    local last_num="${last_file%.md}"
    local next_int=$((10#$last_num + 1))
    # pad with zeros up to 3 digits
    printf -v next_num "%03d" "$next_int"
  fi

  local new_artifact="${artifact_dir}/${next_num}.md"

  cp "$template_file" "$new_artifact"

  echo "Created new $type artifact: $new_artifact"
}
