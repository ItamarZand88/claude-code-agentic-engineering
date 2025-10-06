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
./Circle/       - Organized task workspaces (generated)
  ├── {task-name}/  - Individual task folder
  │   ├── ticket.md           - Task requirements
  │   ├── plan.md             - Implementation plan
  │   └── review.md           - Code review results
./context/      - Optional project knowledge storage
./templates/    - Reusable templates for consistency
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

The framework uses a **4-step workflow** with all artifacts organized in the `Circle/` directory:

1. **`/1_ticket <user_prompt>`** - Comprehensive task ticket creation
   - Deep parallel codebase analysis with specialized agents
   - Clarification questions for unclear requirements
   - **Creates task folder**: `Circle/{task-name}/`
   - **Saves ticket**: `Circle/{task-name}/ticket.md`
   - **Focus**: WHAT needs to be done with full context

2. **`/2_plan Circle/{task-name}`** - Research-driven comprehensive planning
   - Reads `Circle/{task-name}/ticket.md`
   - Web research for best practices
   - **Parallel agent coordination** for pattern discovery
   - Architecture and design decisions with rationale
   - Detailed phase-based implementation breakdown
   - **Saves plan**: `Circle/{task-name}/plan.md`
   - **Focus**: HOW to implement with research-backed decisions

3. **`/3_implement Circle/{task-name}`** - Execute the implementation plan
   - Reads `Circle/{task-name}/plan.md`
   - Step-by-step execution with validation
   - Git status checks and branch management
   - Testing at each phase
   - Reports progress in real-time

4. **`/4_review Circle/{task-name}`** - Quality assurance
   - Reads artifacts (ticket, plan) + git diff
   - Automated code review against requirements
   - Security and performance analysis
   - **Parallel QA and compliance checks**
   - **Saves review**: `Circle/{task-name}/review.md`

### Task Folder Structure

Each task gets its own organized workspace:
```
Circle/{task-name}/
├── ticket.md  - Task requirements and acceptance criteria
├── plan.md    - Implementation plan with research
└── review.md  - Code review and quality assessment
```

### Before Starting Any Major Task
1. Start with `/1_ticket "your requirement"` to create a comprehensive task ticket
2. Then run `/2_plan Circle/{task-name}` for comprehensive planning
3. Execute with `/3_implement Circle/{task-name}`
4. Validate with `/4_review Circle/{task-name}`
5. All artifacts are organized in `Circle/{task-name}/` for easy tracking

### Agent Coordination (Specialized Agents)

**Exploration & Analysis Agents** (used in `/1_ticket`):
- **architecture-explorer**: Project structure discovery, tech stack mapping, directory organization
- **feature-finder**: Similar implementation discovery, pattern extraction, integration points
- **dependency-mapper**: Internal/external dependency mapping, API integration points

**Planning & Design Agents** (used in `/2_plan`):
- **codebase-analyst**: Pattern discovery, conventions, architecture understanding
- **implementation-strategist**: Architectural decision-making, trade-off analysis, ultrathink mode

**Implementation Agents** (used in `/3_implement`):
- **code-implementer**: Incremental code implementation, pattern following, quality assurance

**Review & Quality Agents** (used in `/4_review`):
- **code-reviewer**: Code quality analysis, maintainability assessment, recommendations
- **quality-assurance-agent**: Automated linting, type checking, formatting validation
- **standards-compliance-agent**: Coding standards validation, architecture adherence

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
- **4-step workflow**: Ticket → Plan → Implement → Review
- **Comprehensive tickets**: Deep codebase analysis with parallel agent coordination
- **Research-driven planning**: Web search + multi-agent coordination for comprehensive plans
- **Automated quality**: Parallel QA and compliance checks during review

### Agent Orchestration
- **Parallel execution**: Multiple agents run concurrently at each phase for maximum speed
- **Phase-specific agents**: Different specialized agents for each workflow phase
- **Specialized expertise**: Each agent focuses on specific analysis or implementation domains
- **Smart delegation**: code-implementer for implementation, code-reviewer for reviews

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
- **Automated quality**: Parallel QA and compliance checks during review phase

## Security Considerations
- Never commit sensitive information to context files
- Use defensive security practices only
- Validate inputs and sanitize outputs
- Maintain audit trails for significant changes