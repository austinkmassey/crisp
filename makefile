# =============================================================================
# Makefile for Crisp Framework
# =============================================================================
#
# This Makefile provides the following functionalities:
#   - Setup a test environment
#   - Teardown test environment
#   - Run Bats tests
#   - Install Crisp into a new project directory
#
# Usage:
#     see help rule
#
# =============================================================================

# =============================================================================
# Variables
# =============================================================================

# Directory names
CRISP_DIR := crisp
TEST_ENV_DIR := test_crisp_env
FULL_TEST_ENV_DIR := "$(realpath .)/$(TEST_ENV_DIR)"

# Test scripts location
TEST_DIR := test

# =============================================================================
# Phony Targets
# =============================================================================

.PHONY: help setup_test run_tests index_tests teardown_test test clean check_dependencies

# =============================================================================
# Help Target
# =============================================================================

help:
	@echo "========================================="
	@echo "        Crisp CLI Tool Makefile"
	@echo "========================================="
	@echo ""
	@echo "Available Targets:"
	@echo "  help                     Show this help message"
	@echo "  check_dependencies       Check for required dependencies"
	@echo "  setup_test               Setup test environment"
	@echo "  teardown_test            Teardown test environment"
	@echo "  run_tests                Run all Bats tests"
	@echo "  test                     Setup, run, and teardown_tests"
	@echo "  clean                    Remove test environment directory"
	@echo ""
	@echo "Examples:"
	@echo "  make test"
	@echo "  make clean"
	@echo ""
	@echo "  To run Bats tests with a specific directory:"
	@echo "    make test CRISP_PARENT_DIR=/path/to/test_env"
	@echo ""

# =============================================================================
# Dependency Check
# =============================================================================
check_dependencies:
	@command -v bats >/dev/null 2>&1 || { echo "Error: Bats is not installed. Please install Bats to run tests."; exit 1; }
	@command -v yq >/dev/null 2>&1 || { echo "Error: yq is not installed. Please install yq to parse YAML files."; exit 1; }
	@command -v sed >/dev/null 2>&1 || { echo "Error: sed is not installed. Please install sed to parse files."; exit 1; }

# =============================================================================
# Setup Test Environment
# =============================================================================
setup_test: check_dependencies
	@echo "Test environment setup at '$(TEST_ENV_DIR)'"
	@echo "Setting up test environment..."
	@mkdir -p $(TEST_ENV_DIR)
	@./crisp/install.sh $(CRISP_DIR) $(TEST_ENV_DIR)

# =============================================================================
# Teardown Test Environment
# =============================================================================
teardown_test:
	@echo "Tearing down test environment..."
	@rm -rf $(TEST_ENV_DIR)
	@echo "Test environment removed."

clean: teardown_test

# =============================================================================
# Run Bats Tests
# =============================================================================
test: setup_test run_tests teardown_test
	@echo "All tests executed successfully."

run_tests: run_environment_tests run_artifact_tests run_template_tests run_index_tests
	@echo "Running Bats tests..."

# =============================================================================
# Run Environment Tests
# =============================================================================
run_environment_tests:
	@echo "Running environment Bats tests..."
	@CRISP_TEST_DIR=$(TEST_ENV_DIR) bats $(TEST_DIR)/environment_tests.bats
	@echo "Environment Bats tests completed."

# =============================================================================
# Run Artifact Tests
# =============================================================================
run_artifact_tests:
	@echo "Running artifact Bats tests..."
	@CRISP_TEST_DIR=$(TEST_ENV_DIR) bats $(TEST_DIR)/artifact_tests.bats
	@echo "Artifact Bats tests completed."

# =============================================================================
# Run Template Tests
# =============================================================================
run_template_tests:
	#TODO
	#@echo "Running index-specific Bats tests..."
	#@CRISP_TEST_DIR=$(TEST_ENV_DIR) bats $(TEST_DIR)/index_tests.bats
	#@echo "Index-specific Bats tests completed."

# =============================================================================
# Run Index Tests
# =============================================================================
run_index_tests:
	@echo "Running index Bats tests..."
	@CRISP_TEST_DIR=$(TEST_ENV_DIR) bats $(TEST_DIR)/index_tests.bats
	@echo "Index Bats tests completed."
