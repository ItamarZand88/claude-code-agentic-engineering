# AGI - Agentic Engineering Plugin for Claude Code

A Claude Code plugin that provides a structured 4-step workflow for software development: **Ticket → Plan → Implement → Review**.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Claude Code Plugin](https://img.shields.io/badge/Claude%20Code-Plugin-blue)](https://claude.ai/code)

## Install

```bash
# Inside Claude Code
/plugin marketplace add ItamarZand88/claude-code-agentic-engineering
/plugin install agi@claude-code-agentic-engineering
```

## Usage

### Quick Start
```bash
# Run the complete workflow in one command
/agi:all "Add OAuth integration with Google"
```

### Step-by-Step (Recommended)
```bash
# 1. Create task ticket with codebase analysis
/agi:1_ticket "Add OAuth integration with Google"

# 2. Generate implementation plan
/agi:2_plan .claude/tasks/add-oauth-integration

# 3. Execute the plan
/agi:3_implement .claude/tasks/add-oauth-integration

# 4. Code review
/agi:4_review .claude/tasks/add-oauth-integration
```

Review artifacts in `.claude/tasks/{task-name}/` between steps for best results.

### Auto-Continue
```bash
# Chain commands with --continue flag
/agi:1_ticket "Add feature" --continue=plan      # ticket + plan
/agi:1_ticket "Add feature" --continue=implement # ticket + plan + implement
/agi:1_ticket "Add feature" --continue=all       # full workflow
```

## Commands

| Command | Description |
|---------|-------------|
| `/agi:1_ticket <description>` | Create task ticket with codebase analysis |
| `/agi:2_plan <task_folder>` | Generate implementation plan |
| `/agi:3_implement <task_folder>` | Execute the plan |
| `/agi:4_review <task_folder>` | Code review and QA |
| `/agi:all <description>` | Run complete workflow |
| `/agi:checks` | Run linting/type checks |
| `/agi:best-practices` | Generate coding standards from PRs |
| `/agi:fix-pr-comments <pr>` | Fix PR review comments |

## Agents

The plugin uses 3 specialized agents:

- **code-explorer** - Analyzes codebase structure and patterns (used in ticket creation)
- **code-architect** - Designs architecture and implementation plans (used in planning)
- **code-reviewer** - Reviews code quality and compliance (used in review)

## Task Artifacts

All artifacts are organized in `.claude/tasks/`:
```
.claude/tasks/{task-name}/
├── ticket.md   # Requirements
├── plan.md     # Implementation plan
└── review.md   # Code review
```

## Requirements

- Claude Code v1.0.33+
- GitHub CLI (`gh`) for best-practices and fix-pr-comments commands

## Links

- [Issues](https://github.com/ItamarZand88/claude-code-agentic-engineering/issues)
- [CLAUDE.md](CLAUDE.md) - Full documentation
