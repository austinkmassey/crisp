#!/usr/bin/env bats

# Crisp BATS Environment Tests
# Verify basic Crisp functionality for environment operations

# Ensure CRISP_TEST_DIR is set
@test "TEST_DIR is set" {
  [ -n "$CRISP_TEST_DIR" ]
}

setup() {
  if [ -n "$CRISP_TEST_DIR" ]; then
    cd "$CRISP_TEST_DIR"
    # Source the activate script to enable Crisp commands
    source .crisp/activate.sh .crisp/config.yaml
  else
    echo "CRISP_TEST_DIR not set" >&2
    exit 1
  fi
}

teardown() {
  # Deactivate Crisp after each test
  source .crisp/deactivate.sh
}

@test "crisp status shows labels and paths for key Crisp directories" {
  run crisp status
  [ "$status" -eq 0 ]
  [[ "$output" =~ Activated:[[:space:]]*true ]]
  [[ "$output" =~ Parent:[[:space:]]*/[a-zA-Z0-9._/-]+ ]]
  [[ "$output" =~ Docs:[[:space:]]*/[a-zA-Z0-9._/-]+ ]]
  [[ "$output" =~ Crisp:[[:space:]]*/[a-zA-Z0-9._/-]+ ]]
  [[ "$output" =~ Scripts:[[:space:]]*/[a-zA-Z0-9._/-]+ ]]
}
