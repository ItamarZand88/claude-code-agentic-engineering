# Project Context for Claude

## Architecture Overview
This is an **agentic engineering framework** that combines **advanced agentic engineering** with **sophisticated context engineering** to leverage Claude Code's capabilities through specialized agents and structured commands. The system follows a modular architecture where:

- **Specialized Agents**: 3 focused agents with expertise in specific domains (codebase analysis, architecture design, code review)
- **Command-Based Workflows**: Complex tasks are broken down into reusable command templates
- **Context-Aware Operations**: The system maintains project knowledge to inform decision-making
- **Developer Participation**: Developers review and approve each phase before proceeding to the next
- **Best Practices Foundation**: Built on proven software engineering best practices

## Project Structure
```
# Plugin Repository
./plugin/              - Claude Code plugin package
  ├── .claude-plugin/
  │   └── plugin.json  - Plugin metadata
  ├── commands/        - Slash commands (prefixed with /agi:)
  │   ├── 1_ticket.md
  │   ├── 2_plan.md
  │   ├── 3_implement.md
  │   ├── 4_review.md
  │   ├── all.md
  │   ├── best-practices.md
  │   ├── checks.md
  │   └── fix-pr-comments.md
  ├── agents/          - Specialized AI agents (3 agents)
  │   ├── code-explorer.md       # Codebase analysis & tracing
  │   ├── code-architect.md      # Architecture design & planning
  │   └── code-reviewer.md       # Code review & quality assurance
  └── skills/          - Advanced skill modules
      ├── best-practices-extractor/
      └── code-compliance/

# When installed in user projects
.claude/tasks/         - Organized task workspaces (auto-generated)
  └── {task-name}/
      ├── ticket.md    - Task requirements and acceptance criteria
      ├── plan.md      - Implementation plan with research
      └── review.md    - Code review and quality assessment
```

## Core Philosophy
1. **Task First**: Start with clear task requirements before deep analysis
2. **Developer Participation**: Review and approve each phase (ticket, plan) before proceeding - developers remain in control
3. **Research-Driven Planning**: Use web research and specialized agents during planning
4. **Agent Specialization**: Leverage 3 specialized agents (code-explorer, code-architect, code-reviewer) proactively
5. **Incremental Progress**: Break complex tasks into manageable steps with validation at each phase
6. **Knowledge Preservation**: Capture decisions and patterns for reuse
7. **Best Practices First**: Built on proven software engineering best practices

## Development Guidelines

### Command Workflow (Plugin-Based with Developer Review)

The plugin provides a **4-step core workflow** with all artifacts organized in the `.claude/` directory:

**Core Workflow (4 steps with developer review)**:

1. **`/agi:1_ticket <user_prompt>`** - Comprehensive task ticket creation
   - Deep codebase analysis using **code-explorer** agent
   - Clarification questions for unclear requirements
   - **Creates task folder**: `.claude/tasks/{task-name}/`
   - **Saves ticket**: `.claude/tasks/{task-name}/ticket.md`
   - **Focus**: WHAT needs to be done with full context
   - **⚠️ DEVELOPER ACTION REQUIRED**: Review and approve ticket before proceeding

2. **`/agi:2_plan .claude/tasks/{task-name}`** - Research-driven comprehensive planning
   - **REQUIRES**: Developer approval of ticket first
   - Reads `.claude/tasks/{task-name}/ticket.md`
   - Uses **code-architect** agent for architecture design
   - Web research for best practices
   - Architecture and design decisions with rationale
   - Detailed phase-based implementation breakdown
   - **Saves plan**: `.claude/tasks/{task-name}/plan.md`
   - **Focus**: HOW to implement with research-backed decisions
   - **⚠️ DEVELOPER ACTION REQUIRED**: Review and approve plan before proceeding

3. **`/agi:3_implement .claude/tasks/{task-name}`** - Execute the implementation plan
   - **REQUIRES**: Developer approval of plan first
   - Reads `.claude/tasks/{task-name}/plan.md`
   - Step-by-step execution with validation
   - Direct implementation (no subagent delegation)
   - Git status checks and branch management
   - Testing at each phase
   - Reports progress in real-time

4. **`/agi:4_review .claude/tasks/{task-name}`** - Quality assurance
   - Uses **code-reviewer** agent for comprehensive review
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

### Recommended Workflow (Best Practice)

**For best results, follow this review-and-approve approach:**

1. **(Optional, once per project)**: Use `/agi:best-practices` to generate project coding best practices

2. **Create Ticket**: Run `/agi:1_ticket "your requirement"`
   - Creates comprehensive task ticket in `.claude/tasks/{task-name}/ticket.md`

3. **⚠️ REVIEW TICKET**: Read and approve the ticket before proceeding
   - Open `.claude/tasks/{task-name}/ticket.md`
   - Verify requirements are accurate and complete
   - Update or clarify as needed

4. **Plan Implementation**: Run `/agi:2_plan .claude/tasks/{task-name}`
   - Creates detailed implementation plan in `.claude/tasks/{task-name}/plan.md`

5. **⚠️ REVIEW PLAN**: Read and approve the plan before proceeding
   - Open `.claude/tasks/{task-name}/plan.md`
   - Verify architectural decisions are sound
   - Adjust approach if needed

6. **Execute**: Run `/agi:3_implement .claude/tasks/{task-name}`
   - Implements according to approved plan

7. **Quality Review**: Run `/agi:4_review .claude/tasks/{task-name}`
   - Comprehensive code review and quality checks

**Why this matters**: Each phase builds on the previous one. Reviewing the ticket ensures requirements are clear. Reviewing the plan ensures the architecture is sound before writing code. This **collaborative approach** keeps you in control while leveraging AI agents for deep analysis and implementation.

### Command Chaining (Auto-Continue)

**⚠️ Note**: Auto-continue skips the review-and-approve steps. Use with caution - the recommended workflow includes manual review between phases.

Run multiple steps automatically without manual confirmation using the `--continue` flag:

**From Ticket**:
- `/agi:1_ticket "description" --continue=plan` - Auto-run planning after ticket
- `/agi:1_ticket "description" --continue=implement` - Auto-run plan + implement
- `/agi:1_ticket "description" --continue=review` - Run full workflow through review
- `/agi:1_ticket "description" --continue=all` - Same as `--continue=review`

**From Plan**:
- `/agi:2_plan .claude/tasks/{task-name} --continue=implement` - Auto-run implementation
- `/agi:2_plan .claude/tasks/{task-name} --continue=review` - Auto-run implement + review
- `/agi:2_plan .claude/tasks/{task-name} --continue=all` - Same as `--continue=review`

**From Implement**:
- `/agi:3_implement .claude/tasks/{task-name} --continue=review` - Auto-run review
- `/agi:3_implement .claude/tasks/{task-name} --continue=all` - Same as `--continue=review`

**Alternative: All-in-One Command**:
```bash
# Run complete workflow (skips manual reviews)
/agi:all "Add JWT authentication"
```

**Examples with Auto-Continue**:
```bash
# Create ticket and automatically plan + implement
/agi:1_ticket "Add JWT authentication" --continue=implement

# Plan and automatically implement (but stop before review)
/agi:2_plan .claude/tasks/add-jwt-auth --continue=implement

# Implement and automatically review
/agi:3_implement .claude/tasks/add-jwt-auth --continue=review
```

### Agent Coordination (3 Specialized Agents)

The plugin uses **3 specialized AI agents** that handle the complete development lifecycle:

**1. code-explorer** (used in `/agi:1_ticket` - Analysis Phase):
- Deeply analyzes existing codebase features by tracing execution paths
- Maps architecture layers (presentation → business logic → data)
- Identifies design patterns and architectural decisions
- Documents dependencies and integration points
- Provides file:line references for all findings

**2. code-architect** (used in `/agi:2_plan` - Design Phase):
- Designs feature architectures by analyzing existing codebase patterns
- Makes decisive architectural decisions with clear rationale
- Designs complete component structures and data flows
- Creates phased implementation plans with specific tasks
- Ensures seamless integration with existing code

**3. code-reviewer** (used in `/agi:4_review` - Quality Assurance Phase):
- Reviews code for bugs, logic errors, security vulnerabilities
- Loads and enforces project-specific best practices from `.claude/best-practices/`
- Runs automated checks (linting, type-checking, formatting)
- Confidence scoring (only reports issues ≥80% confidence)
- Provides concrete fixes with code examples

### Quality Standards
- Provide specific file paths and line numbers for code references
- Update context after significant discoveries or changes
- Ensure thorough testing at each phase
- Maintain best practices compliance

## Project Conventions

### File Naming
- Commands: kebab-case with .md extension (e.g., `1_ticket.md`, `2_plan.md`)
- Agents: kebab-case with .md extension (e.g., `code-explorer.md`, `code-architect.md`)
- Generated task files: `ticket.md`, `plan.md`, `review.md` in task folders

### Error Handling
- Always check for required files/context before proceeding
- Provide clear guidance when dependencies are missing
- Include fallback strategies for common failure scenarios

## Key Features

### Streamlined Workflow with Developer Control
- **4-step core workflow**: Ticket → Plan → Implement → Review
- **Developer participation**: Review and approve each phase before proceeding
- **Best practices setup**: Optional `/agi:best-practices` command to generate project coding best practices
- **Comprehensive tickets**: Deep codebase analysis using code-explorer agent
- **Research-driven planning**: Web search + code-architect agent for comprehensive plans
- **Direct implementation**: Claude Code implements directly following project patterns
- **Unified review**: code-reviewer agent handles all QA, compliance, security, and performance checks

### Agent Orchestration (3 Specialized Agents)
- **code-explorer**: Codebase analysis and tracing (used in ticket creation)
- **code-architect**: Architecture design and planning (used in planning phase)
- **code-reviewer**: Comprehensive code review and QA (used in review phase)
- **Focused expertise**: Each agent specializes in one phase of the development lifecycle
- **Developer oversight**: Agents provide analysis while developers make final decisions

### Advanced Engineering
- **Agentic Engineering**: Specialized AI agents handle complex analysis and design
- **Context Engineering**: Sophisticated context management for optimal results
- **Best Practices Foundation**: Built on proven software engineering principles
- **Collaborative Approach**: Keeps developers engaged and in control throughout

## Integration Points
- **Git Integration**: All commands should work with git repositories
- **IDE Integration**: Designed for Claude Code IDE environment
- **Team Collaboration**: Commands and agents can be shared across team members

## Performance Guidelines
- **Specialized agents**: 3 focused agents (code-explorer, code-architect, code-reviewer) optimized for specific phases
- **Phase-optimized**: Each workflow phase uses the optimal agent for that stage
- **Batch tool calls**: Use multiple tool invocations in single message when possible
- **Selective research**: Only research what's needed for the specific task
- **Developer review**: Manual review between phases ensures quality and maintains developer control

## Security Considerations
- Never commit sensitive information to context files
- Use defensive security practices only
- Validate inputs and sanitize outputs
- Maintain audit trails for significant changes
