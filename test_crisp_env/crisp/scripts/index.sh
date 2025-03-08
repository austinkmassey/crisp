#!/usr/bin/env bash

function get_pending_files() {
  # Retrieves files from a directory based on whether they are "pending" defined by their modification time relative to an index file.
  #
  # 1 Parameters:
  #    • artifact_type: Type of artifact to look for (e.g., "backlog", "session", "sprint").
  #    • result_var: Name of the variable to store results.
  #
  # 2 Variables:
  #    • index_file: Path to the index file for a given artifact type.
  #    • artifact_dir: Path to the directory containing artifact files.
  #    • pending_files_ref: Declared as a nameref to dynamically store results in the variable name passed as result_var.
  #
  # 3 Logic:
  #    • Checks if result_var is provided; returns an error if not.
  #    • Checks if index_file exists:
  #       • If not, finds all files in artifact_dir.
  #       • If it exists, finds files in artifact_dir newer than index_file.
  #
  # 4 Example Usage:
  #    export CRISP_DOC="/path/to/crisp_doc"
  #    pending_files=()
  #    get_pending_files "reports" "pending_files"
  #    echo "${pending_files[@]}"
  local artifact_type="$1"
  local result_var="$2"
  
  if [[ -z "$result_var" ]]; then
    echo "Error: result variable name is required for get_pending_files" >&2
    return 1
  fi
  
  local index_file="${CRISP_DOC}/${artifact_type}_index.md"
  local artifact_dir="${CRISP_DOC}/${artifact_type}/"
  
  declare -n pending_files_ref="$result_var"
  
  if [[ ! -f "$index_file" ]]; then
    pending_files_ref=($(find "$artifact_dir" -type f))
  else
    pending_files_ref=($(find "$artifact_dir" -type f -newer "$index_file"))
  fi
}

function parse_current_index() {
  local index_file="$1"
  local result_var="$2"
  
  declare -n index_data_ref=$result_var
  
  local regex='\[(.*)\]\(.*\)$'
  
  if [[ -f "$index_file" ]]; then
    local current_artifact=""
    while IFS= read -r line; do
      if [[ $line =~ $regex ]]; then
        current_artifact="${BASH_REMATCH[1]}"
        index_data_ref["$current_artifact"]=""
      fi
      if [[ -n "$current_artifact" ]]; then
        index_data_ref["$current_artifact"]+="$line"
      fi
    done < "$index_file"
  fi
}


# Update index data with pending file metadata
function update_index_data() {
  local index_var="$1"
  local pending_files_var="$2"
  
  declare -n index_data_ref="$index_var"
  declare -n pending_files_ref="$pending_files_var"
  
  for file in "${pending_files_ref[@]}"; do
    [[ -f "$file" ]] || continue
    local relative_path
    index_data_ref[$(basename "$file")]="- [$(basename "$file")](${CRISP_DOC}/$(basename "$file"))\n"
    echo "${index_data_ref[$(basename "$file")]}"
  done
}

# Write an associative array to an index file
function write_index_file() {
  local index_file="$1"
  local index_var="$2"
  
  declare -n index_data_ref="$index_var"
  
  if [[ -f "$index_file" ]]; then
    rm -f "$index_file"
  fi
  
  echo "# ${index_file##*/} Index" > "$index_file"
  echo >> "$index_file"
  
  for artifact in $(printf "%s\n" "${!index_data_ref[@]}" | sort -n); do
    echo "${index_data_ref[$artifact]}" >> "$index_file"
  done
}

# Process artifacts for a specific type
function process_index_artifacts() {
  local artifact_type="$1"
  
  local index_file="${CRISP_DOC}/${artifact_type}_index.md"
  
  declare -A index_data
  local pending_files
  
  get_pending_files "$artifact_type" pending_files || return 1
  
  if [[ ${#pending_files[@]} -eq 0 ]]; then
    echo "No pending files for $artifact_type."
    return 0
  fi

  if [[ ! -f "$index_file" ]]; then
    echo "# ${artifact_type^} Index" > "$index_file"
    echo >> "$index_file"
  fi
  
  parse_current_index "$index_file" index_data
  update_index_data index_data pending_files
  write_index_file "$index_file" index_data
}

# Remove an index file
function remove_index() {
  local artifact_type="$1"
  local hard_flag="$2"
  
  local index_file="${CRISP_DOC}/${artifact_type}_index.md"
  
  if [[ "$hard_flag" == "true" && -f "$index_file" ]]; then
    rm -f "$index_file"
  fi
}

# Main function to process index commands
function crisp_index() {
  local mode="${1:-}"
  shift || true
  
  local hard_flag="false"
  [[ "${1:-}" == "--hard" ]] && hard_flag="true"
  
  case "$mode" in
    backlog|sprint|session)
      if [[ "$hard_flag" == "true" ]]; then
        remove_index "$mode" "$hard_flag"
      fi
      process_index_artifacts "$mode"
      ;;
    all)
      for artifact_type in backlog sprint session; do
        if [[ "$hard_flag" == "true" ]]; then
          remove_index "$artifact_type" "$hard_flag"
        fi
        process_index_artifacts "$artifact_type"
      done
      ;;
    *)
      echo "Usage: crisp index <backlog|sprint|session|all> [--hard]"
      exit 1
      ;;
  esac
}

