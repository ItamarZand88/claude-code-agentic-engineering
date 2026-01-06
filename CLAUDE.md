# Project Context for Claude

## Architecture Overview
This is an agentic engineering framework designed to leverage Claude Code's capabilities through specialized agents and structured commands. The system follows a modular architecture where:

- **Specialized Agents**: Each agent has expertise in specific domains (pattern recognition, git analysis, file analysis, etc.)
- **Command-Based Workflows**: Complex tasks are broken down into reusable command templates
- **Context-Aware Operations**: The system maintains project knowledge to inform decision-making
- **XML-Structured Prompts**: All prompts use XML tags for optimal Claude performance

## Project Structure
```
./commands/     - Slash command definitions for common workflows
./agents/       - Specialized agent prompt templates
./skills/       - Advanced skill modules (e.g., code-standards)
./.claude/      - Installed components and task workspaces
  ├── commands/         - Installed slash commands
  ├── agents/           - Installed agent templates
  ├── skills/           - Installed skill modules
  ├── tasks/            - Organized task workspaces (generated)
  │   └── {task-name}/  - Individual task folder
  │       ├── ticket.md - Task requirements
  │       ├── plan.md   - Implementation plan
  │       └── review.md - Code review results
  └── best-practices/   - Project coding best practices
      └── README.md     - Generated best practices document
```

## Core Philosophy
1. **Task First**: Start with clear task requirements before deep analysis
2. **Research-Driven Planning**: Use web research and specialized agents during planning
3. **Agent Specialization**: Leverage codebase-analyst and specialized agents proactively
4. **Structured Thinking**: Use XML tags and chain-of-thought reasoning
5. **Incremental Progress**: Break complex tasks into manageable steps
6. **Knowledge Preservation**: Capture decisions and patterns for reuse

## Development Guidelines

### Command Workflow (Streamlined with Organized Storage)

The framework uses a **5-command workflow** with all artifacts organized in the `.claude/` directory:

**Core Workflow (4 steps)**:

1. **`/1_ticket <user_prompt>`** - Comprehensive task ticket creation
   - Deep parallel codebase analysis with specialized agents
   - Clarification questions for unclear requirements
   - **Creates task folder**: `.claude/tasks/{task-name}/`
   - **Saves ticket**: `.claude/tasks/{task-name}/ticket.md`
   - **Focus**: WHAT needs to be done with full context

2. **`/2_plan .claude/tasks/{task-name}`** - Research-driven comprehensive planning
   - Reads `.claude/tasks/{task-name}/ticket.md`
   - Web research for best practices
   - **Parallel agent coordination** for pattern discovery
   - Architecture and design decisions with rationale
   - Detailed phase-based implementation breakdown
   - **Saves plan**: `.claude/tasks/{task-name}/plan.md`
   - **Focus**: HOW to implement with research-backed decisions

3. **`/3_implement .claude/tasks/{task-name}`** - Execute the implementation plan
   - Reads `.claude/tasks/{task-name}/plan.md`
   - Step-by-step execution with validation
   - Direct implementation (no subagent delegation)
   - Git status checks and branch management
   - Testing at each phase
   - Reports progress in real-time

4. **`/4_review .claude/tasks/{task-name}`** - Quality assurance
   - Reads artifacts (ticket, plan) + git diff
   - Automated code review against requirements
   - Security and performance analysis
   - **Checks .claude/best-practices/ for compliance**
   - **Saves review**: `.claude/tasks/{task-name}/review.md`

### Task Folder Structure

Each task gets its own organized workspace:
```
.claude/tasks/{task-name}/
├── ticket.md  - Task requirements and acceptance criteria
├── plan.md    - Implementation plan with research
└── review.md  - Code review and quality assessment
```

### Before Starting Any Major Task
1. **(Optional, once per project)**: Use the `best-practices-extractor` skill to generate project coding best practices
2. Start with `/1_ticket "your requirement"` to create a comprehensive task ticket
3. Then run `/2_plan .claude/tasks/{task-name}` for comprehensive planning
4. Execute with `/3_implement .claude/tasks/{task-name}`
5. Validate with `/4_review .claude/tasks/{task-name}` (checks against .claude/best-practices/ if exists)
6. All artifacts are organized in `.claude/tasks/{task-name}/` for easy tracking

### Command Chaining (Auto-Continue)

Run multiple steps automatically without manual confirmation using the `--continue` flag:

**From Ticket**:
- `/1_ticket "description" --continue=plan` - Auto-run planning after ticket
- `/1_ticket "description" --continue=implement` - Auto-run plan + implement
- `/1_ticket "description" --continue=review` - Run full workflow through review
- `/1_ticket "description" --continue=all` - Same as `--continue=review`

**From Plan**:
- `/2_plan .claude/tasks/{task-name} --continue=implement` - Auto-run implementation
- `/2_plan .claude/tasks/{task-name} --continue=review` - Auto-run implement + review
- `/2_plan .claude/tasks/{task-name} --continue=all` - Same as `--continue=review`

**From Implement**:
- `/3_implement .claude/tasks/{task-name} --continue=review` - Auto-run review
- `/3_implement .claude/tasks/{task-name} --continue=all` - Same as `--continue=review`

**Examples**:
```bash
# Create ticket and automatically plan + implement
/1_ticket "Add JWT authentication" --continue=implement

# Plan and automatically implement (but stop before review)
/2_plan .claude/tasks/add-jwt-auth --continue=implement

# Implement and automatically review
/3_implement .claude/tasks/add-jwt-auth --continue=review
```

### Agent Coordination (Specialized Agents)

**Exploration & Analysis Agents** (used in `/1_ticket`):
- **architecture-explorer**: Project structure discovery, tech stack mapping, directory organization
- **feature-finder**: Similar implementation discovery, pattern extraction, integration points
- **dependency-mapper**: Internal/external dependency mapping, API integration points

**Planning & Design Agents** (used in `/2_plan`):
- **codebase-analyst**: Pattern discovery, conventions, architecture understanding
- **implementation-strategist**: Architectural decision-making, trade-off analysis, ultrathink mode

**Review & Quality Agent** (used in `/4_review`):
- **code-reviewer**: Comprehensive code review including quality analysis, automated QA checks (linting, type-check, formatting), best practices compliance validation, security assessment, and performance analysis

**Best Practices Generation Agent** (used in `best-practices-extractor` skill):
- **best-practices-generator**: Analyzes codebase patterns to generate project-specific coding best practices document in .claude/best-practices/README.md

### Quality Standards
- Always use XML tags in prompts: `<instruction>`, `<context>`, `<thinking>`, `<output>`
- Include chain-of-thought reasoning with `<thinking>` tags
- Provide specific file paths and line numbers for code references
- Update context after significant discoveries or changes

## Project Conventions

### Prompt Structure
All prompts should use XML tags for clear organization:
```xml
<instruction>
Clear task description
</instruction>

<context>
Relevant background information
</context>

<thinking>
Step-by-step reasoning process
</thinking>

<output>
Expected output format
</output>
```

### File Naming
- Commands: kebab-case with .md extension (`task-from-scratch.md`)
- Agents: kebab-case with -agent suffix (`pattern-recognition-agent.md`)
- Generated files: descriptive names with timestamps when appropriate

### Error Handling
- Always check for required files/context before proceeding
- Provide clear guidance when dependencies are missing
- Include fallback strategies for common failure scenarios

## Key Features

### Streamlined Workflow
- **4-step core workflow**: Ticket → Plan → Implement → Review
- **Best practices setup**: Optional `best-practices-extractor` skill to generate project coding best practices
- **Comprehensive tickets**: Deep codebase analysis with parallel agent coordination
- **Research-driven planning**: Web search + multi-agent coordination for comprehensive plans
- **Direct implementation**: Claude Code implements directly following project patterns (no subagent delegation)
- **Unified review**: Single code-reviewer agent handles all QA, compliance, security, and performance checks

### Agent Orchestration
- **Parallel execution**: Multiple agents run concurrently at each phase for maximum speed
- **Phase-specific agents**: 7 specialized agents across 4 workflow phases
- **Specialized expertise**: Each agent focuses on specific analysis domains
- **Consolidated review**: code-reviewer handles all quality aspects in single comprehensive review

### Best Practices Integration
- **XML-structured prompts**: Clear separation of instructions and data
- **Chain-of-thought reasoning**: `<thinking>` tags for complex decisions
- **Quote-based grounding**: Citations for accuracy
- **Hierarchical organization**: Structured multi-document handling

## Integration Points
- **Git Integration**: All commands should work with git repositories
- **IDE Integration**: Designed for Claude Code IDE environment
- **Team Collaboration**: Commands and agents can be shared across team members

## Performance Guidelines
- **Parallel agents**: Launch multiple agents concurrently using single message with multiple Task tool calls
- **Phase-optimized**: Each command phase uses specialized agents designed for that stage
- **Batch tool calls**: Use multiple tool invocations in single message
- **Selective research**: Only research what's needed for the specific task
- **Unified review**: Single code-reviewer agent performs all quality checks in one comprehensive review

## Security Considerations
- Never commit sensitive information to context files
- Use defensive security practices only
- Validate inputs and sanitize outputs
- Maintain audit trails for significant changes
