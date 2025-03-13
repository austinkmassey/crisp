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
