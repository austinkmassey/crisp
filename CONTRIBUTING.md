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

Happy contributing!

