## Crisp Principles

- use the same tools for working with code and documentation 
- charter the project
- organize project tasks in a backlog
- develop users stories and tests for each backlog item
- use sprints to communicate progress to the outside world
- use sessions to monitor progress and to review efforts

## Crisp Tool

### Characteristics

#### Uses Dev Tools

- Operates solely via command-line interface and text editors (e.g., Vim-aware templates with navigable elements like Ctrl + G, F).

#### Automated

- Facilitates navigation and review of Agile artifacts with autogenerated indexes.
- Generates Agile artifacts (backlogs, sprints, sessions) from customizable templates.

### Belongs to Project

- Encapsulated within the parent project’s `.crisp` folder and installed per-project.
- Minimized reliance on external scripts, tools, or files (except `make`, `bash`, `yq`).
- Supports flexible project customization through templates, configurations, and automated testing.


### Usage

To start using Crisp with any project:

- Copy Crisp’s repository into a `.crisp` folder in the project.
- The project is set up with default templates and configurations.
- Run `source ./.crisp/scripts/activate.sh` at the start of a session to enable Crisp commands for this project.
- Run `source ./.crisp/scripts/deactivate.sh` to stop using Crisp or before switching to a new project in the current shell.

After activating Crisp:

- Use `crisp add <backlog/sprint/session>` to generate a new Agile artifact.
- After adding or modifying entries, run `crisp index` to generate index files in your project’s directory.

Customize:

- the tool lives in the project's repository. Its scripts and templates can be customized for each project

## Commands

### `crisp status`

Displays the current Crisp project location (.crisp folder) and high-level project information.

### `crisp add <backlog/sprint/session>`

Generates a new artifact file (backlog, sprint, or session) based on templates and user-defined parameters.

### `crisp index <backlog/sprint/session/all> [--hard]`

Updates index files. The `--hard` flag regenerates indexes from scratch by scanning all artifacts.

## Crisp Artifacts

Crisp incorporates three Agile-inspired concepts.

### Backlog

A prioritized collection of features, tasks, or user stories for implementation. Each backlog item tracks:

- **Priority**: Must Have, Should Have, Could Have, or Won’t Have.
- **Status**: Open, Closed, or Deferred.
- **Sprint**: The sprint the backlog belongs to.

```yaml
title: "Descriptive Title of Backlog Item"
priority: <priority>
status: <status>
sprint: [[path/to/sprint.md]]
time: "Estimated time to complete"
```

### Sprint

A grouping of backlog items planned for execution within a defined timeframe. Each sprint includes:

- Defined goals, start and end dates, and stakeholders.
- A list of associated backlog items.
- Sprint review and retrospective.

```yaml
sprint: <incremented sprint number>
start_date: <date>
end_date: <date>
goal: "Descriptive goal of sprint"
stakeholders: "List of stakeholder emails"
```

### Session

An individual development effort, similar to a daily Agile meeting. Sessions record:

- Immediate goals and ongoing tasks.
- Status updates relevant to the current sprint.

```yaml
session: <incremented session number>
date: <date>
description: "Short description of this session"
```

### Artifact Structure

Each concept is represented by a markdown-based artifact file with metadata in frontmatter.
Artifacts are linked through index files:

- **Backlog Index**: Lists all backlog items.
- **Sprint Index**: Summarizes all sprints.
- **Session Index**: Tracks all sessions.

Indexes are ephemeral and autogenerated. They include:

- Artifact paths.
- Parsed frontmatter (e.g., status, descriptions).
- Summaries of artifacts.

Artifact files, initialized from templates, remain editable by developers but unmodified by Crisp after creation.

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

