#!/usr/bin/env bats

# Crisp BATS Test Suite

# Verify template functionality
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
