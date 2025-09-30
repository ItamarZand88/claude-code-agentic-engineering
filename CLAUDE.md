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

The framework uses a **2-step workflow** for starting new work, with all artifacts organized in the `Circle/` directory:

1. **`/1_task_from_scratch <user_prompt>`** - Lightweight task ticket creation
   - Quick reconnaissance of codebase (no deep analysis)
   - Clarification questions for unclear requirements
   - **Creates task folder**: `Circle/{task-name}/`
   - **Saves ticket**: `Circle/{task-name}/ticket.md`
   - **Fast execution**: < 2 minutes
   - **Focus**: WHAT needs to be done, not HOW

2. **`/2_plan_from_task Circle/{task-name}`** - Research-driven comprehensive planning
   - Reads `Circle/{task-name}/ticket.md`
   - Web research for best practices
   - **Proactive codebase-analyst agent** launch for pattern discovery
   - Multi-agent coordination (parallel when possible)
   - Architecture and design decisions with rationale
   - Detailed phase-based implementation breakdown
   - **Saves plan**: `Circle/{task-name}/plan.md`
   - **Focus**: HOW to implement with research-backed decisions

3. **`/3_implement_plan Circle/{task-name}`** - Execute the implementation plan
   - Reads `Circle/{task-name}/plan.md`
   - Step-by-step execution with validation
   - Testing at each phase
   - Reports progress in real-time

4. **`/4_review_implementation Circle/{task-name}`** - Quality assurance
   - Reads artifacts (ticket, plan) + git diff
   - Automated code review against requirements
   - Security and performance analysis
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
1. Start with `/1_task_from_scratch "your requirement"` to create a task folder
2. Then run `/2_plan_from_task Circle/{task-name}` for comprehensive planning
3. The planning phase will automatically launch specialized agents for analysis
4. All artifacts are organized in `Circle/{task-name}/` for easy tracking

### Agent Coordination (Used During Planning)
- **codebase-analyst**: Primary agent for pattern discovery, conventions, architecture (launched proactively in `/2_plan_from_task`)
- **file-analysis-agent**: Deep file analysis, dependencies, relationships
- **git-history-agent**: Historical context, decision rationale, evolution patterns
- **documentation-extractor-agent**: Documentation parsing and knowledge synthesis
- **dependency-scanner-agent**: External dependencies, security analysis, package management

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
- **2-step start**: Task creation → Planning (instead of 3-step with context)
- **Fast task tickets**: Quick requirement capture without heavy analysis
- **Research-driven planning**: Web search + agent coordination for comprehensive plans

### Agent Orchestration
- **Proactive agents**: codebase-analyst automatically launched during planning
- **Parallel execution**: Multiple agents run concurrently for speed
- **Specialized expertise**: Each agent focuses on specific analysis domains

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
- **Fast task creation**: `/1_task_from_scratch` completes in < 2 minutes
- **Parallel agents**: Launch multiple agents concurrently during planning
- **Batch tool calls**: Use multiple tool invocations in single message
- **Selective research**: Only research what's needed for the specific task
- **Context on demand**: Optional `/5_update_context` after implementation

## Security Considerations
- Never commit sensitive information to context files
- Use defensive security practices only
- Validate inputs and sanitize outputs
- Maintain audit trails for significant changes