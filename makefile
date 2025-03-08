# =============================================================================
# Makefile for Crisp Framework
# =============================================================================
#
# This Makefile provides the following functionalities:
#   - Setup a test environment
#   - Run Bats tests
#   - Run index-specific Bats tests
#   - Teardown test environment
#   - Install Crisp into a new project directory
#   - Clean up test artifacts
#
# Usage:
#   make help                     Show available commands
#   make test                     Setup, run tests, and teardown
#   make run_index_tests          Run index-specific Bats tests
#   make install DESTDIR=path     Install Crisp into the specified directory
#   make clean                    Remove test environment directory
#
# =============================================================================

# =============================================================================
# Variables
# =============================================================================

# Directory names
CRISP_DIR := crisp
TEST_ENV_DIR := test_crisp_env

# Test scripts location
TEST_DIR := test

# Installation directory (to be specified by user)
# Usage: make install DESTDIR=/path/to/project
INSTALL_DIR := $(DESTDIR)

# =============================================================================
# Phony Targets
# =============================================================================

.PHONY: help setup_test run_tests index_tests teardown_test test install clean check_dependencies

# =============================================================================
# Help Target
# =============================================================================

help:
	@echo "========================================="
	@echo "        Crisp Framework Makefile"
	@echo "========================================="
	@echo ""
	@echo "Available Targets:"
	@echo "  help                     Show this help message"
	@echo "  setup_test               Setup test environment"
	@echo "  run_tests                Run all Bats tests"
	@echo "  index_tests              Run index-specific Bats tests"
	@echo "  teardown_test            Teardown test environment"
	@echo "  test                     Setup, run tests, and teardown"
	@echo "  install DESTDIR=path     Install Crisp into a new project directory"
	@echo "  clean                    Remove test environment directory"
	@echo "  check_dependencies       Check for required dependencies"
	@echo ""
	@echo "Examples:"
	@echo "  make test"
	@echo "  make index_tests"
	@echo "  make install DESTDIR=/path/to/my_project"
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

# =============================================================================
# Setup Test Environment
# =============================================================================

setup_test: check_dependencies
	@echo "Setting up test environment..."
	@mkdir -p $(TEST_ENV_DIR)
	@cp -R $(CRISP_DIR) $(TEST_ENV_DIR)/
	@echo "Test environment setup at '$(TEST_ENV_DIR)'"

# =============================================================================
# Run Bats Tests
# =============================================================================

run_tests:
	@echo "Running Bats tests..."
	@CRISP_TEST_DIR=$(TEST_ENV_DIR) bats $(TEST_DIR)/crisp_test.bats
	@echo "Bats tests completed."

# =============================================================================
# Run Index-Specific Tests
# =============================================================================

run_index_tests:
	@echo "Running index-specific Bats tests..."
	@CRISP_TEST_DIR=$(TEST_ENV_DIR) bats $(TEST_DIR)/index_tests.bats
	@echo "Index-specific Bats tests completed."

# =============================================================================
# Teardown Test Environment
# =============================================================================

teardown_test:
	@echo "Tearing down test environment..."
	@rm -rf $(TEST_ENV_DIR)
	@echo "Test environment removed."

# =============================================================================
# Run All Tests
# =============================================================================

test: setup_test run_tests run_index_tests teardown_test
	@echo "All tests executed successfully."

# =============================================================================
# Install Crisp into a New Project Directory
# =============================================================================

install:
	if [ -z "$(DESTDIR)" ]; then \
		echo "Error: DESTDIR not specified."; \
		echo "Usage: make install DESTDIR=/path/to/new_project"; \
		exit 1; \
	fi
	@echo "Installing Crisp into '$(DESTDIR)'..."
	@mkdir -p $(DESTDIR)/.crisp
	@cp -R $(CRISP_DIR)/* $(DESTDIR)/.crisp/
	@echo "Crisp installed successfully in '$(DESTDIR)/.crisp'."
	@echo "To activate Crisp, run:"
	@echo "  source .crisp/scripts/activate.sh"

# =============================================================================
# Clean Up Test Environment
# =============================================================================

clean:
	@echo "Cleaning up test environment..."
	@rm -rf $(TEST_ENV_DIR)
	@echo "Cleaned up '$(TEST_ENV_DIR)'"
