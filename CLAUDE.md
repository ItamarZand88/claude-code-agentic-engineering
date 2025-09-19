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
./context/      - Project knowledge storage (generated)
./tasks/        - Task requirements documentation (generated)
./plans/        - Implementation plans (generated)
./templates/    - Reusable templates for consistency
```

## Core Philosophy
1. **Context First**: Always load project context before analysis
2. **Agent Specialization**: Use the right agent for each task type
3. **Structured Thinking**: Use XML tags and chain-of-thought reasoning
4. **Incremental Progress**: Break complex tasks into manageable steps
5. **Knowledge Preservation**: Capture decisions and patterns for reuse

## Development Guidelines

### Before Starting Any Major Task
1. Use `/get-context --summary` to understand current project state
2. If no context exists, run `/update-context --full` first
3. Choose appropriate specialized agents for the task type

### Command Usage Patterns
- **Planning**: `/task-from-scratch` → `/plan-from-task` → `/implement-plan`
- **Context Management**: `/get-context` for reading, `/update-context` for writing
- **Analysis**: Use specialized agents (pattern-recognition, git-history, file-analysis, etc.)

### Agent Coordination
- **pattern-recognition-agent**: Architecture and design patterns, conventions, anti-patterns
- **git-history-agent**: Historical context, decision rationale, evolution patterns
- **file-analysis-agent**: Code structure, relationships, dependencies
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

## Key Commands to Run
- **Context Management**: Use the context system before any major operations
- **Agent Coordination**: Leverage specialized agents for domain-specific tasks
- **Incremental Updates**: Keep context fresh with regular updates

## Integration Points
- **Git Integration**: All commands should work with git repositories
- **IDE Integration**: Designed for Claude Code IDE environment
- **Team Collaboration**: Commands and agents can be shared across team members

## Performance Guidelines
- Use `/get-context` for fast read-only context access
- Use `/update-context --incremental` for regular updates
- Avoid heavy analysis during task creation - use context instead
- Batch multiple tool calls for optimal performance

## Security Considerations
- Never commit sensitive information to context files
- Use defensive security practices only
- Validate inputs and sanitize outputs
- Maintain audit trails for significant changes