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

# Tests for get_pending_files
@test "get_pending_files handles missing index file by including all files" {
  set -x
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

@test "get_pending_files handles empty directories" {
  local type="test_type"
  rm -rf "$CRISP_DOC/$type"
  mkdir -p "$CRISP_DOC/$type"

  touch "$CRISP_DOC/${type}_index.md"

  local pending_files
  get_pending_files "$type" pending_files

  [[ -z "${pending_files[*]}" ]]
}

@test "get_pending_files handles directories with no index file and no files" {
  local type="test_type"
  rm -rf "$CRISP_DOC/$type"
  mkdir -p "$CRISP_DOC/$type"

  local pending_files
  get_pending_files "$type" pending_files

  [[ -z "${pending_files[*]}" ]]
}

# Tests for parse_current_index
@test "parse_current_index populates index_data from existing index file" {
  set -x
  local index_file="$CRISP_DOC/test_index.md"
  cat <<EOF > "$index_file"
[001.md](docs/backlog/001.md)
[002.md](docs/backlog/002.md)
EOF

  declare -A index_data
  parse_current_index "$index_file" index_data

  [[ "${index_data[001.md]}" == "[001.md](docs/backlog/001.md)" ]]
  [[ "${index_data[002.md]}" == "[002.md](docs/backlog/002.md)" ]]
  set +x
}

@test "parse_current_index handles missing index file gracefully" {
  local index_file="$CRISP_DOC/missing_index.md"
  declare -A index_data
  parse_current_index "$index_file" index_data

  [[ ${#index_data[@]} -eq 0 ]]
}

# Tests for update_index_data
@test "update_index_data updates index_data with pending files" {
  declare -A index_data
  declare -a pending_files

  pending_files=("$CRISP_DOC/file1.txt" "$CRISP_DOC/file2.txt")
  touch "${pending_files[@]}"

  update_index_data index_data pending_files

  [[ "${index_data[$CRISP_DOC/file1.txt]}" == "- [file1.txt]($CRISP_DOC/file1.txt)" ]]
  [[ "${index_data[$CRISP_DOC/file2.txt]}" == "- [file2.txt]($CRISP_DOC/file2.txt)" ]]
}

@test "update_index_data skips missing pending files" {
  declare -A index_data
  declare -a pending_files=("$CRISP_DOC/missing_file.txt")

  update_index_data index_data pending_files

  [[ ${#index_data[@]} -eq 0 ]]
}

# Tests for write_index_file
@test "write_index_file creates a new index file from index_data" {
  local index_file="$CRISP_DOC/test_index.md"
  declare -A index_data=(
    ["file1.txt"]="- [file1.txt](docs/file1.txt)"
    ["file2.txt"]="- [file2.txt](docs/file2.txt)"
  )

  write_index_file "$index_file" index_data

  grep "- [file1.txt](docs/file1.txt)" "$index_file"
  grep "- [file2.txt](docs/file2.txt)"
}

@test "write_index_file overwrites existing index file" {
  local index_file="$CRISP_DOC/test_index.md"
  echo "Old content" > "$index_file"

  declare -A index_data=(
    ["file1.txt"]="- [file1.txt](docs/file1.txt)"
  )

  write_index_file "$index_file" index_data

  ! grep "Old content" "$index_file"
  grep "- [file1.txt](docs/file1.txt)" "$index_file"
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
  grep "- [file1.txt]" "$index_file"
  grep "- [file2.txt]" "$index_file"
}

