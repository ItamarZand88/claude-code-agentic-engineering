# AGI - Agentic Engineering Plugin for Claude Code

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

After installation, use commands with the `agi:` prefix:

| Command | Description |
|---------|-------------|
| `/agi:1_ticket <description>` | Create task ticket with codebase analysis |
| `/agi:2_plan <task-folder>` | Research-driven implementation planning |
| `/agi:3_implement <task-folder>` | Execute the implementation plan |
| `/agi:4_review <task-folder>` | Quality assurance and code review |
| `/agi:all <description>` | Run full workflow (ticket → plan → implement → review) |
| `/agi:best-practices` | Generate project best practices |
| `/agi:checks` | Run quality checks |
| `/agi:fix-pr-comments` | Fix PR review comments |

## Workflow

### 4-Step Workflow

```bash
# 1. Create ticket
/agi:1_ticket "Add OAuth authentication"

# 2. Plan implementation
/agi:2_plan .claude/tasks/oauth-authentication

# 3. Implement
/agi:3_implement .claude/tasks/oauth-authentication

# 4. Review
/agi:4_review .claude/tasks/oauth-authentication
```

### Quick Start (Full Workflow)

```bash
/agi:all "Add OAuth authentication"
```

### Command Chaining

Use `--continue` flag to auto-continue through steps:

```bash
# Create ticket and auto-continue to planning
/agi:1_ticket "Add feature" --continue=plan

# Create ticket and run full workflow
/agi:1_ticket "Add feature" --continue=all
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
