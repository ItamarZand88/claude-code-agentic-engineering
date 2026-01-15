# Agentic Engineering Plugin for Claude Code

Advanced agentic engineering workflow with specialized agents for ticket creation, planning, implementation, and code review.

## Installation

### Option 1: From Git Repository (Recommended)

```bash
claude /plugin install https://github.com/ItamarZand88/claude-code-agentic-engineering
```

### Option 2: Local Development

```bash
claude --plugin-dir /path/to/claude-code-agentic-engineering/plugin
```

## Commands

After installation, use commands with the `agentic-engineering:` prefix:

| Command | Description |
|---------|-------------|
| `/agentic-engineering:1_ticket <description>` | Create task ticket with codebase analysis |
| `/agentic-engineering:2_plan <task-folder>` | Research-driven implementation planning |
| `/agentic-engineering:3_implement <task-folder>` | Execute the implementation plan |
| `/agentic-engineering:4_review <task-folder>` | Quality assurance and code review |
| `/agentic-engineering:all <description>` | Run full workflow (ticket → plan → implement → review) |
| `/agentic-engineering:best-practices` | Generate project best practices |
| `/agentic-engineering:checks` | Run quality checks |
| `/agentic-engineering:fix-pr-comments` | Fix PR review comments |

## Workflow

### 4-Step Workflow

```bash
# 1. Create ticket
/agentic-engineering:1_ticket "Add OAuth authentication"

# 2. Plan implementation
/agentic-engineering:2_plan .claude/tasks/oauth-authentication

# 3. Implement
/agentic-engineering:3_implement .claude/tasks/oauth-authentication

# 4. Review
/agentic-engineering:4_review .claude/tasks/oauth-authentication
```

### Quick Start (Full Workflow)

```bash
/agentic-engineering:all "Add OAuth authentication"
```

### Command Chaining

Use `--continue` flag to auto-continue through steps:

```bash
# Create ticket and auto-continue to planning
/agentic-engineering:1_ticket "Add feature" --continue=plan

# Create ticket and run full workflow
/agentic-engineering:1_ticket "Add feature" --continue=all
```

## Agents

The plugin includes 9 specialized agents:

- **architecture-explorer**: Project structure discovery
- **codebase-analyst**: Pattern discovery and conventions
- **code-reviewer**: Comprehensive code review
- **dependency-mapper**: Dependency mapping
- **feature-finder**: Similar implementation discovery
- **implementation-strategist**: Architectural decision-making
- **best-practices-generator**: Generate coding standards
- **best-practices-compliance-agent**: Validate code compliance
- **quality-assurance-agent**: QA checks

## Skills

The plugin includes 3 skills:

- **best-practices-extractor**: Extract best practices from PR comments
- **code-compliance**: Validate code against best practices
- **code-standards**: Legacy skill (deprecated, use the above two)

## Task Folder Structure

Each task creates an organized workspace:

```
.claude/tasks/{task-name}/
├── ticket.md  - Task requirements and acceptance criteria
├── plan.md    - Implementation plan with research
└── review.md  - Code review and quality assessment
```

## Requirements

- Claude Code v1.0.33 or later
- GitHub CLI (`gh`) for best practices extraction

## License

MIT
