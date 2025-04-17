#!/usr/bin/env bats

# Crisp BATS Test Suite
# Verify artifact functionality

# Ensure CRISP_TEST_DIR is set
@test "TEST_DIR is set" {
  [ -n "$CRISP_TEST_DIR" ]
}

setup() {
  if [ -n "$CRISP_TEST_DIR" ]; then
    cd "$CRISP_TEST_DIR"
    source .crisp/activate.sh .crisp/config.yaml
  else
    echo "CRISP_TEST_DIR not set" >&2
    exit 1
  fi
}

teardown() {
  # Deactivate Crisp after each test
  deactivate
}

@test "add backlog creates new file in backlog directory" {
  run crisp add backlog
  [ "$status" -eq 0 ]
  [ -f "${CRISP_DOC}/backlog/001.md" ]
}

@test "add sprint creates new file in sprints directory" {
  run crisp add sprint
  [ "$status" -eq 0 ]
  [ -f "${CRISP_DOC}/sprint/001.md" ]
}

@test "add session creates new file in session directory" {
  run crisp add session
  [ "$status" -eq 0 ]
  [ -f "${CRISP_DOC}/session/001.md" ]
}
