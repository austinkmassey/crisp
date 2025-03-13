#!/usr/bin/env bats

# Set up test environment variables
setup() {
  source crisp/scripts/index.sh
  export CRISP_DOC="$(mktemp -d)"
}

# Clean up after tests
teardown() {
  rm -rf "$CRISP_DOC"
}
@test "crisp index all generates index files in output directory" {
  run crisp index all
  [ "$status" -eq 0 ]
  [ -f "${CRISP_DOC}/backlog_index.md" ]
  [ -f "${CRISP_DOC}/sprint_index.md" ]
  [ -f "${CRISP_DOC}/session_index.md" ]
}

@test "crisp index backlog updates backlog_index.md in output directory" {
  run rm ${CRISP_DOC}/backlog/*
  run rm ${CRISP_DOC}/backlog/backlog_index.md
  run crisp add backlog
  [ "$status" -eq 0 ]
  run crisp add backlog
  [ "$status" -eq 0 ]
  run crisp add backlog
  [ "$status" -eq 0 ]
  run crisp index backlog
  [ "$status" -eq 0 ]
  [ -f "${CRISP_DOC}/backlog_index.md" ]

  # Use silent grep to match and exit cleanly
  grep -q "001.md" "${CRISP_DOC}/backlog_index.md"
  grep -q "002.md" "${CRISP_DOC}/backlog_index.md"
  grep -q "003.md" "${CRISP_DOC}/backlog_index.md"
  [ $? -eq 0 ]
}

@test "crisp index --hard regenerates indexes in output directory" {
  run crisp add backlog
  run crisp add sprint
  run crisp index all
  [ -f "${CRISP_DOC}/backlog_index.md" ]
  [ -f "${CRISP_DOC}/sprint_index.md" ]

  # Modify an index to ensure it is refreshed.
  echo "MANUAL EDIT" >>"${CRISP_DOC}/backlog_index.md"

  run crisp index all --hard
  [ "$status" -eq 0 ]

  # The new backlog index should not contain the "MANUAL EDIT" text
  ! grep "MANUAL EDIT" "${CRISP_DOC}/backlog_index.md"
}

# Tests for get_pending_files
# PASS
@test "get_pending_files handles missing index file by including all files" {
  local type="test_type"
  rm -rf "$CRISP_DOC/$type"
  mkdir -p "$CRISP_DOC/$type"

  touch "$CRISP_DOC/$type/file1.txt"
  touch "$CRISP_DOC/$type/file2.txt"

  local pending_files
  get_pending_files "$type" pending_files

  [[ "${pending_files[*]}" == *"$CRISP_DOC/$type/file1.txt"* ]]
  [[ "${pending_files[*]}" == *"$CRISP_DOC/$type/file2.txt"* ]]
}

#PASS
@test "get_pending_files filters files modified after index file" {
  local type="test_type"
  rm -rf "$CRISP_DOC/$type"
  mkdir -p "$CRISP_DOC/$type"

  touch "$CRISP_DOC/$type/file1.txt"
  sleep 1
  touch "$CRISP_DOC/${type}_index.md"
  sleep 1
  touch "$CRISP_DOC/$type/file2.txt"

  local pending_files
  get_pending_files "$type" pending_files

  [[ "${pending_files[*]}" != *"$CRISP_DOC/$type/file1.txt"* ]]
  [[ "${pending_files[*]}" == *"$CRISP_DOC/$type/file2.txt"* ]]
}

#PASS
@test "get_pending_files returns no files if none are newer than index file" {
  local type="test_type"
  rm -rf "$CRISP_DOC/$type"
  mkdir -p "$CRISP_DOC/$type"

  touch "$CRISP_DOC/$type/file1.txt"
  touch "$CRISP_DOC/$type/file2.txt"
  sleep 1
  touch "$CRISP_DOC/${type}_index.md"

  local pending_files
  get_pending_files "$type" pending_files

  [[ -z "${pending_files[*]}" ]]
}

#PASS
@test "get_pending_files handles empty directories" {
  local type="test_type"
  rm -rf "$CRISP_DOC/$type"
  mkdir -p "$CRISP_DOC/$type"

  touch "$CRISP_DOC/${type}_index.md"

  local pending_files
  get_pending_files "$type" pending_files

  [[ -z "${pending_files[*]}" ]]
}

#PASS
@test "get_pending_files handles directories with no index file and no files" {
  local type="test_type"
  rm -rf "$CRISP_DOC/$type"
  mkdir -p "$CRISP_DOC/$type"

  local pending_files
  get_pending_files "$type" pending_files

  [[ -z "${pending_files[*]}" ]]
}

# Tests for parse_current_index
#PASS
@test "parse_current_index populates index_data from existing index file" {
  local index_file="$CRISP_DOC/test_index.md"
  cat <<EOF >"$index_file"
- [001.md](docs/backlog/001.md)
- [002.md](docs/backlog/002.md)
EOF

  declare -A index_data
  parse_current_index "$index_file" index_data
  [[ "${index_data[001.md]}" == "- [001.md](docs/backlog/001.md)\n" ]]
  [[ "${index_data[002.md]}" == "- [002.md](docs/backlog/002.md)\n" ]]
}

#PASS
@test "parse_current_index handles missing index file gracefully" {
  local index_file="$CRISP_DOC/missing_index.md"
  declare -A index_data
  parse_current_index "$index_file" index_data

  [[ ${#index_data[@]} -eq 0 ]]
}

# Tests for update_index_data
#PASS
@test "update_index_data updates index_data with pending files" {
  declare -A index_data
  declare -a pending_files

  pending_files=("$CRISP_DOC/file1.txt" "$CRISP_DOC/file2.txt")
  touch "${pending_files[@]}"

  update_index_data index_data pending_files

  [[ "${index_data[file1.txt]}" == "- [file1.txt]($CRISP_DOC/file1.txt)\n" ]]
  [[ "${index_data[file2.txt]}" == "- [file2.txt]($CRISP_DOC/file2.txt)\n" ]]
}

#PASS
@test "update_index_data skips missing pending files" {
  declare -A index_data
  declare -a pending_files=("$CRISP_DOC/missing_file.txt")

  update_index_data index_data pending_files

  [[ ${#index_data[@]} -eq 0 ]]
}

# Tests for write_index_file
#PASS
@test "write_index_file creates a new index file from index_data" {
  local index_file="$CRISP_DOC/test_index.md"
  declare -A index_data=(
    ["file1.txt"]="- [file1.txt](docs/file1.txt)"
    ["file2.txt"]="- [file2.txt](docs/file2.txt)"
  )

  write_index_file "$index_file" index_data

  # Check that the file contains the expected entries
  run grep -F -- "- [file1.txt](docs/file1.txt)" "$index_file"
  [ "$status" -eq 0 ] # Assert the exit status is 0 (match found)

  run grep -F -- "- [file2.txt](docs/file2.txt)" "$index_file"
  [ "$status" -eq 0 ] # Assert the exit status is 0 (match found)
}

#PASS
@test "write_index_file overwrites existing index file" {
  local index_file="$CRISP_DOC/test_index.md"
  echo "Old content" >"$index_file"

  declare -A index_data=(
    ["file1.txt"]="- [file1.txt](docs/file1.txt)"
  )

  write_index_file "$index_file" index_data

  run grep -F -- "Old content" "$index_file"
  [ ! "$status" -eq 0 ] # Assert the exit status is 0 (match found)

  run grep -F -- "- [file1.txt](docs/file1.txt)" "$index_file"
  [ "$status" -eq 0 ] # Assert the exit status is 0 (match found)
}

# Integration test for process_index_artifacts
@test "process_index_artifacts creates a new index file for artifact type" {
  local type="test_type"
  mkdir -p "$CRISP_DOC/$type"
  touch "$CRISP_DOC/$type/file1.txt"
  touch "$CRISP_DOC/$type/file2.txt"

  process_index_artifacts "$type"

  local index_file="$CRISP_DOC/${type}_index.md"
  [[ -f "$index_file" ]]
  run grep -F -- "- [file1.txt]" "$index_file"
  [ "$status" -eq 0 ] # Assert the exit status is 0 (match found)

  run grep -F -- "- [file2.txt]" "$index_file"
  [ "$status" -eq 0 ] # Assert the exit status is 0 (match found)
}
