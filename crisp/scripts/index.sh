#!/usr/bin/env bash
#
# Generate index files for backlog, sprint, and session artifacts.

# Source helper functions
source "$(dirname "${BASH_SOURCE[0]}")/helpers.sh"

function crisp_index() {
  local mode="${1:-}"
  local hard_flag="false"
  shift || true

  # Check for --hard
  if [[ "${1:-}" == "--hard" ]]; then
    hard_flag="true"
  fi

  # Get output directory from config.yaml
  local output_dir
  output_dir="$(get_output_dir)"

  function index_artifacts() {
    local type="$1"
    local index_file="${output_dir}/${type}_index.md"

    if [[ "$hard_flag" == "true" && -f "$index_file" ]]; then
      rm -f "$index_file"
    fi

    echo "# ${type^} Index" >> "$index_file"
    echo >> "$index_file"

    for artifact in "${output_dir}/${type}"/*.md; do
      [[ -f "$artifact" ]] || continue

      # Example: just listing file paths. You could enhance this with yq to parse frontmatter.
      local relative_path
      relative_path="$(realpath --relative-to="$(pwd)" "$artifact")"
      echo "- [$(basename "$artifact")](${relative_path})" >> "$index_file"
    done
  }

  case "$mode" in
    backlog|sprint|session)
      index_artifacts "$mode"
      ;;
    all)
      index_artifacts "backlog"
      index_artifacts "sprint"
      index_artifacts "session"
      ;;
    *)
      echo "Usage: crisp index <backlog|sprint|session|all> [--hard]"
      exit 1
      ;;
  esac
}

