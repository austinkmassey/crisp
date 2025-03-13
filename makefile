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
	@echo "  install DESTDIR=path     Install Crisp into a new project directory"
	@echo "  clean                    Remove test environment directory"
	@echo ""
	@echo "Examples:"
	@echo "  make test"
	@echo "  make clean"
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
