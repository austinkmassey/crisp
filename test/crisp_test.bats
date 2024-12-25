#!/usr/bin/env bats

# Crisp BATS Test Suite
# Verify basic Crisp functionality: status, add, and index.

# Ensure CRISP_PARENT_DIR is set
@test "CRISP_PARENT_DIR is set" {
  [ -n "$CRISP_PARENT_DIR" ]
}

setup() {
  if [ -n "$CRISP_PARENT_DIR" ]; then
    cd "$CRISP_PARENT_DIR"
    # Source the activate script to enable Crisp commands
    source crisp/scripts/activate.sh
  else
    echo "CRISP_PARENT_DIR not set" >&2
    exit 1
  fi
}

teardown() {
  # Deactivate Crisp after each test
  source crisp/scripts/deactivate.sh
}

@test "crisp status shows Crisp project folder and output directory" {
  run crisp status
  [ "$status" -eq 0 ]
  [[ "$output" =~ "Crisp project folder:" ]]
  [[ "$output" =~ "Output directory:" ]]
}

@test "crisp add backlog creates a new backlog artifact in output directory" {
  run crisp add backlog
  [ "$status" -eq 0 ]
  [ -f "${OUTPUT_DIR}/backlog/001.md" ]
}

@test "crisp add sprint creates a new sprint artifact in output directory" {
  run crisp add sprint
  [ "$status" -eq 0 ]
  [ -f "${OUTPUT_DIR}/sprint/001.md" ]
}

@test "crisp add session creates a new session artifact in output directory" {
  run crisp add session
  [ "$status" -eq 0 ]
  [ -f "${OUTPUT_DIR}/session/001.md" ]
}

@test "crisp index all generates index files in output directory" {
  run crisp index all
  [ "$status" -eq 0 ]
  [ -f "${OUTPUT_DIR}/backlog_index.md" ]
  [ -f "${OUTPUT_DIR}/sprint_index.md" ]
  [ -f "${OUTPUT_DIR}/session_index.md" ]
}

@test "crisp index backlog updates backlog_index.md in output directory" {
  run crisp add backlog
  [ "$status" -eq 0 ]
  run crisp index backlog
  [ "$status" -eq 0 ]
  [ -f "${OUTPUT_DIR}/backlog_index.md" ]
  grep "001.md" "${OUTPUT_DIR}/backlog_index.md"
}

@test "crisp index --hard regenerates indexes in output directory" {
  run crisp add backlog
  run crisp add sprint
  run crisp index all
  [ -f "${OUTPUT_DIR}/backlog_index.md" ]
  [ -f "${OUTPUT_DIR}/sprint_index.md" ]

  # Modify an index to ensure it is refreshed.
  echo "MANUAL EDIT" >> "${OUTPUT_DIR}/backlog_index.md"

  run crisp index all --hard
  [ "$status" -eq 0 ]

  # The new backlog index should not contain the "MANUAL EDIT" text
  ! grep "MANUAL EDIT" "${OUTPUT_DIR}/backlog_index.md"
}

# Load configuration to get output directory
setup_test_environment() {
  # Assuming the output_directory is defined in config.yaml
  OUTPUT_DIR="$(yq e '.crisp.output_directory' "${CRISP_PARENT_DIR}/crisp/config.yaml")"
}

setup_test_environment

