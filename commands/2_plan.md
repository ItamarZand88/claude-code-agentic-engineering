---
description: Creates comprehensive implementation plan from task file through research and codebase analysis
argument-hint: <task_folder_path>
model: inherit
allowed-tools: [Read, Write, Glob, Grep, Bash, Task, WebSearch, WebFetch, SlashCommand]
---

# Implementation Plan Generator with Research & Agent Coordination

## Instructions

<instructions>
**Purpose**: Create a comprehensive, research-backed implementation plan that answers "HOW to implement" the task.

**Core Principles**:
- Focus on HOW, not WHAT (requirements are in ticket)
- Conduct parallel research (web + codebase + documentation)
- Use ultrathink mode for complex architectural decisions
- Break down into actionable, testable phases
- Document all design decisions with rationale

**Key Expectations**:
- Research-driven best practices
- Detailed task breakdown with validation steps
- Clear architecture and integration strategy
- Specific file paths and code examples
</instructions>

## Variables

### Dynamic Variables (User Input)
- **task_folder_path**: `$ARGUMENTS` - Path to task folder (e.g., `Circle/oauth-authentication`)

### Static Variables (Configuration)
- **TICKET_FILENAME**: `ticket.md` - Standard ticket filename
- **PLAN_FILENAME**: `plan.md` - Standard plan filename

### Derived Variables (Computed During Execution)
- **ticket_path**: `{task_folder_path}/ticket.md` - Full path to ticket
- **plan_path**: `{task_folder_path}/plan.md` - Full path to plan output

## Workflow

### Step 1: Load Task Requirements

<step>
**Objective**: Load and understand task requirements from ticket

**Process**:
1. Parse `$ARGUMENTS` to get task folder path
2. Verify ticket exists: `{task_folder_path}/ticket.md`
3. Read ticket file
4. Extract key elements:
   - Task title and description
   - Requirements (functional, non-functional, integration)
   - Affected files and areas
   - Dependencies and constraints
   - Acceptance criteria
   - Key findings from ticket analysis

**Validation**:
- ✅ Task folder path is valid
- ✅ Ticket file exists and is readable
- ✅ All key requirements extracted
- ✅ Dependencies and constraints documented

**Early Return**: If ticket file missing → STOP and inform user to run `/1_ticket` first
</step>

### Step 2: Parallel Research & Analysis Phase

<step>
**Objective**: Gather comprehensive research to inform implementation strategy

**Process** - Launch ALL tracks in PARALLEL (single message with multiple tool calls):

**Track 1: Web Research** (conditional - if new technologies/patterns)
- WebSearch: `{technology} best practices 2025`
- WebSearch: `{pattern} implementation guide`
- WebFetch: Specific documentation URLs if known

**Track 2: Codebase Analysis Agents** (always run in parallel)
- Launch feature-finder: Find similar implementations
- Launch dependency-mapper: Map all dependencies
- Launch codebase-analyst: Extract project patterns

**Track 3: Library Documentation** (conditional - if new dependencies)
- Use mcp__context7__resolve-library-id for each library
- Use mcp__context7__get-library-docs for resolved IDs
- Extract integration patterns

**Track 4: Project Documentation** (optional)
- Task agent to scan: CLAUDE.md, .cursorrules, README.md, docs/
- Extract: Guidelines, patterns, conventions

**Synthesis After All Tracks Complete**:
1. Consolidate web research findings
2. Integrate codebase patterns
3. Merge library documentation
4. Reconcile conflicts
5. Build unified implementation strategy

**Validation**:
- ✅ All research tracks completed
- ✅ Best practices identified
- ✅ Codebase patterns documented
- ✅ No conflicting recommendations

**Conditional**: If research reveals blockers → Document clearly and ask user for guidance
</step>

### Step 3: Architecture Design with implementation-strategist

<step>
**Objective**: Design optimal architecture for implementation

**Condition**: Use implementation-strategist agent for complex architectural decisions

**Process**:

**For Complex Tasks** (multiple approaches, significant trade-offs):
- Launch implementation-strategist agent with task context
- Agent applies ultrathink mode:
  - Evaluates 2-3 solution alternatives
  - Analyzes trade-offs (scalability, maintainability, complexity)
  - Provides detailed rationale for recommendation
  - Documents implementation considerations

**For Simpler Tasks** (clear path forward):
- Design architecture based on research findings
- Document approach and rationale
- Identify key components and data flow

**Output**:
- Chosen architectural approach with justification
- Component structure
- Data flow design
- Integration strategy

**Validation**:
- ✅ Architecture aligns with requirements
- ✅ Design follows codebase patterns
- ✅ Trade-offs documented
- ✅ Implementation path is clear
</step>

### Step 4: Implementation Planning & Task Breakdown

<step>
**Objective**: Break implementation into logical, testable phases

**Process**:

**Phase Structure** (standard breakdown):
1. **Foundation** - Setup, configuration, dependencies
2. **Core Implementation** - Main features and logic
3. **Integration** - Connect to existing systems
4. **Validation** - Quality checks and validation
5. **Documentation** - Code docs and guides

**For Each Task, Document**:
- Clear, actionable description
- Files to create/modify with specific changes
- Dependencies on other tasks
- Validation commands to verify completion
- Estimated effort (time/complexity)

**Task Granularity**:
- Each task should be independently testable
- Break large tasks into sub-tasks (max 2-3 hours per task)
- Ensure clear success criteria for each task

**Validation**:
- ✅ All phases have specific tasks
- ✅ Each task has validation commands
- ✅ Dependencies clearly mapped
- ✅ No task is too large or vague
</step>


### Step 5: Plan Document Generation

<step>
**Objective**: Generate comprehensive plan document

**Process**:
1. Compile all research findings
2. Document architectural decisions
3. Structure task breakdown by phases
4. Include validation commands for each task
5. Add risk assessment
6. Save to `{task_folder_path}/plan.md`

**Validation**:
- ✅ All sections complete (overview, research, architecture, tasks, risks)
- ✅ Plan follows standard template structure
- ✅ File saved successfully
- ✅ Plan is actionable and detailed
</step>

## Output Format

<output>
Save to `{task_folder_path}/plan.md` with:

**Header**: Title, date, status
**Overview**: 2-3 paragraph approach summary
**Research**: Best practices, patterns, references, tech decisions
**Phases**: Foundation → Core → Integration → Validation → Docs
  - Each task: description, files, dependencies, validation, effort
**Architecture**: Components, data flow, API design (if applicable)
**Files**: To modify/create with specific changes
**Dependencies**: New libs with install commands
**Risks**: With impact + mitigation
**Success Criteria**: From ticket + code review/docs

Next step reference: `/3_implement {task_folder_path}`
</output>

## Guidelines

**Focus**: HOW to implement (based on research + patterns)
**DO**: Parallel research, ultrathink decisions, specific tasks with validation
**DON'T**: Skip research, make assumptions, create vague tasks


## Control Flow

<control_flow>
**Execution Pattern**: Sequential with Parallel Research

**Flow Logic**:

1. **Load task requirements**
   - Parse `$ARGUMENTS` to get task folder path
   - IF ticket missing → STOP and inform user to run `/1_ticket`
   - ELSE → Read ticket and extract requirements

2. **Launch parallel research** (single message with multiple tool calls)
   - IF task involves new tech → Launch WebSearch queries
   - ALWAYS launch codebase analysis agents (feature-finder, dependency-mapper, codebase-analyst)
   - IF new libraries needed → Launch library documentation lookups
   - IF project has rules → Scan project documentation
   - Wait for ALL research to complete

3. **Synthesize research findings**
   - Consolidate all research outputs
   - IF blockers found → Document and ask user for guidance
   - ELSE → Build unified strategy

4. **Design architecture**
   - IF complex decision → Use implementation-strategist agent
   - ELSE → Design based on research
   - Document approach and rationale

5. **Break down into tasks**
   - Structure into phases (Foundation → Core → Integration → Validation → Docs)
   - For each task: description, files, dependencies, validation
   - Ensure tasks are independently testable

6. **Generate and save plan**
   - Compile plan.md with all sections
   - Save to `{task_folder_path}/plan.md`

7. **Report completion**
   - Display research summary
   - Show plan structure
   - Ask user if ready to proceed to implementation

**Critical Decision Points**:
- ✅ Before research: Does ticket exist?
- ✅ Before synthesis: Did all research complete?
- ✅ Before architecture: Are there blockers?
- ✅ Before save: Is plan comprehensive?
- ✅ After completion: Proceed to /3_implement?
</control_flow>

## Report

<report>
**Format**: Structured completion summary

**Required Elements**:
1. **Plan File Path**: Display created plan path
2. **Research Summary**:
   - Web research findings (if applicable)
   - Codebase analysis results
   - Agent findings summary
3. **Plan Contents**: Phases count, tasks count, key sections
4. **Task Folder Status**: Show folder structure with completed files
5. **Next Step**: Ask user confirmation

**Example Output**:
```
✅ Implementation plan created: Circle/oauth-authentication/plan.md

Research Summary:
- Web research: OAuth2 best practices, security considerations
- Codebase analysis: Found similar auth pattern in auth/session.py
- Agent findings: Mapped dependencies and integration points

Plan Includes:
- 4 implementation phases with 12 detailed tasks
- Architecture design with component breakdown
- Risk assessment and mitigation strategies

Task Folder Structure:
Circle/oauth-authentication/
├── ticket.md (task requirements) ✅
├── plan.md (implementation plan) ✅
└── review.md (will be created after implementation)

Next Step:
Ready to execute the implementation plan?
```

**After displaying the report above:**

1. Ask user: "Would you like me to proceed with executing the implementation plan?"
2. IF user confirms (yes/proceed/continue) → Use SlashCommand tool to run: `/3_implement @Circle/{task-folder-name}`
3. ELSE → Stop and wait for user instructions
</report>
