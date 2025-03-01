#!/usr/bin/env bats

# Crisp BATS Test Suite
# Verify basic Crisp functionality: status, add, and index.

# Ensure CRISP_TEST_DIR is set
@test "TEST_DIR is set" {
  [ -n "$CRISP_TEST_DIR" ]
}

setup() {
  if [ -n "$CRISP_TEST_DIR" ]; then
    cd "$CRISP_TEST_DIR"
    # Source the activate script to enable Crisp commands
    source crisp/scripts/activate.sh
  else
    echo "CRISP_TEST_DIR not set" >&2
    exit 1
  fi
}

teardown() {
  # Deactivate Crisp after each test
  source crisp/scripts/deactivate.sh
}

@test "crisp status shows labels and paths for key Crisp directories" {
  run crisp status
  [ "$status" -eq 0 ]
  [[ "$output" =~ Crisp\ Root:[[:space:]]*/[a-zA-Z0-9._/-]+ ]]
  [[ "$output" =~ Parent\ Project:[[:space:]]*/[a-zA-Z0-9._/-]+ ]]
  [[ "$output" =~ Scripts\ dir:[[:space:]]*/[a-zA-Z0-9._/-]+ ]]
  [[ "$output" =~ Docs\ dir:[[:space:]]*/[a-zA-Z0-9._/-]+ ]]
}

@test "crisp add backlog creates a new backlog artifact in output directory" {
  run crisp add backlog
  [ "$status" -eq 0 ]
  [ -f "${CRISP_DOC}/backlog/001.md" ]
}

@test "crisp add sprint creates a new sprint artifact in output directory" {
  run crisp add sprint
  [ "$status" -eq 0 ]
  [ -f "${CRISP_DOC}/sprint/001.md" ]
}

@test "crisp add session creates a new session artifact in output directory" {
  run crisp add session
  [ "$status" -eq 0 ]
  [ -f "${CRISP_DOC}/session/001.md" ]
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
  echo "MANUAL EDIT" >> "${CRISP_DOC}/backlog_index.md"

  run crisp index all --hard
  [ "$status" -eq 0 ]

  # The new backlog index should not contain the "MANUAL EDIT" text
  ! grep "MANUAL EDIT" "${CRISP_DOC}/backlog_index.md"
}

