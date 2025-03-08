# Contributing to Crisp

Thanks for your interest in contributing!

## Getting Started
1. Fork the repository.
2. Clone the fork locally.
3. Install dependencies (e.g., Bats if you plan to run tests).

## Adding Features or Fixes
- Create a new branch for your changes.
- Add or update tests in `crisp/test/crisp_test.bats`.
- Ensure tests pass (`make test` or `bats crisp/test/crisp_test.bats`).
- Open a Pull Request against `main`.

## Code Style
- Keep scripts POSIX-compliant where possible.
- Use `shellcheck` to lint your scripts.

## Submitting Pull Requests
- Describe the changes you’ve made.
- Reference any related issue (e.g. “Closes #1”).
- Include relevant test output if possible.

## Testing with Bats

Usage

    Install Bats (optional):
    If you want to run the tests, install bats-core.

    Initialize Crisp in your project:
    Copy the .crisp folder into the root of your repository.

    Activate Crisp in your shell:

source .crisp/scripts/activate.sh

Use Crisp:

    crisp status
    crisp add backlog
    crisp add sprint
    crisp add session
    crisp index all or crisp index backlog/sprint/session

Deactivate Crisp when done:

source .crisp/scripts/deactivate.sh

Run tests in test/crisp_tests.bats (from your test directory):

    bats crisp_tests.bats

This layout and code give you a minimal, functional Crisp framework to build upon, along with automated tests to ensure your Crisp commands work as expected. Adjust the scripts, Makefile, and test logic as your project grows and requires additional functionality!

