---
description: Creates comprehensive task ticket from user prompt with deep codebase analysis
argument-hint: <task_description>
model: inherit
---

# Task Ticket Generator

<instruction>
**IMPORTANT**: Create a comprehensive task ticket from user input. Focus on WHAT needs to be done, not HOW to do it.

**YOU MUST** perform thorough parallel codebase analysis to understand the full context and scope. This is the first step in the workflow.

Think step by step through the requirements before generating the ticket.
</instruction>

## Variables
- **user_prompt**: $ARGUMENTS - The user's description of what they want to accomplish
- **OUTPUT_DIRECTORY**: `./Circle/{task-name}/` - Directory where all task-related files are stored
- **task_folder_name**: `{brief-summary-kebab-case}` - Folder name derived from task description
- **ticket_filename**: `./Circle/{task-folder-name}/ticket.md` - Task ticket file

## Workflow

### 1. Parse User Intent

<thinking>
- Understand the core request from the user prompt
- Identify the type of task (feature, bugfix, refactor, documentation, etc.)
- Extract key requirements and constraints
- Note any technologies or specific approaches mentioned
</thinking>

### 2. Deep Codebase Analysis with Parallel Exploration

<parallel_exploration>
**IMPORTANT**: Launch multiple exploration agents in PARALLEL for maximum speed.

**YOU MUST** use a single message with multiple Task tool calls to run agents concurrently:

<agent_coordination>
Launch 3-4 specialized exploration agents simultaneously:

**Agent 1: architecture-explorer**
```
Task (subagent_type: general-purpose):
"Use the architecture-explorer agent to discover project structure for: {task_description}

The agent will:
- Find root configs, tech stack, build commands
- Map directory organization
- Locate architecture documentation
- Extract development workflows

Wait for comprehensive architecture map."
```

**Agent 2: feature-finder**
```
Task (subagent_type: general-purpose):
"Use the feature-finder agent to find similar implementations for: {task_description}

The agent will:
- Search for similar existing features
- Extract reusable code patterns
- Identify integration points
- Find data model examples

Wait for pattern discovery results."
```

**Agent 3: dependency-mapper**
```
Task (subagent_type: general-purpose):
"Use the dependency-mapper agent to analyze dependencies for: {task_description}

The agent will:
- Map internal dependencies
- Identify external libraries
- Find API/database integration points
- Flag configuration files needing updates

Wait for complete dependency map."
```

**Wait for ALL agents to complete** before proceeding to synthesis.
</agent_coordination>
</parallel_exploration>

<synthesis>
After parallel exploration completes:
1. Consolidate findings from all agents
2. Identify conflicts or gaps
3. Build comprehensive understanding
4. Document all discovered context
</synthesis>


### 3. Clarification Questions

<instruction>
**IMPORTANT**: If requirements are ambiguous or incomplete, STOP and ask clarification questions before proceeding.

Example clarification prompts:
- "Could you clarify the expected behavior when...?"
- "Are there any specific constraints I should know about?"
- "I found existing pattern X - should the new feature follow this pattern?"
</instruction>

### 4. Create Task Folder Structure

<instruction>
Create the Circle folder structure:
1. Generate a descriptive, kebab-case folder name from the task (e.g., "oauth-authentication", "user-profile-update")
2. Create `./Circle/{task-folder-name}/` directory
3. Save the ticket as `./Circle/{task-folder-name}/ticket.md`

This folder will contain all task-related artifacts:
- `ticket.md` - The task ticket (created now)
- `plan.md` - Implementation plan (created by `/2_plan`)
- `review.md` - Review results (created by `/4_review`)
</instruction>

### 5. Generate Comprehensive Task Ticket

## Output Format

<output>
Generate a comprehensive task ticket document with this structure:

# Task: {Brief Descriptive Title}

**Created**: {Date}
**Type**: {Feature|Bugfix|Refactor|Documentation|Other}
**Status**: Draft

## Description

{Detailed 4-6 sentence description of what needs to be accomplished, including context about why this is needed and how it fits into the larger system}

## Context & Background

<context>
**Existing Implementation:**
{Summary of current state - what exists today that's relevant to this task}

**Related Features:**
{List of related features, components, or systems}

**Architectural Context:**
{How this fits into the overall architecture}

**Key Patterns & Conventions:**
{Important patterns in the codebase that should be understood}
</context>

## Requirements

<requirements>
### Functional Requirements
- [ ] {Specific functional requirement 1}
- [ ] {Specific functional requirement 2}
- [ ] {Specific functional requirement n}

### Non-Functional Requirements
- [ ] {Compatibility requirement}
- [ ] {Scalability requirement}

### Integration Requirements
- [ ] {System/component integration 1}
- [ ] {System/component integration n}
</requirements>

## Affected Areas (Deep Analysis)

<affected_areas>
**Files That Will Need Modification:**
- `path/to/file1.ext` - {detailed reason and what aspects}
- `path/to/file2.ext` - {detailed reason and what aspects}
- `path/to/file3.ext` - {detailed reason and what aspects}

**Files That May Be Impacted:**
- `path/to/related1.ext` - {why this might be affected}
- `path/to/related2.ext` - {why this might be affected}

**Configuration Files:**
- `path/to/config.ext` - {what configuration may need changes}

**Documentation Files:**
- `path/to/docs.md` - {what documentation needs updating}
</affected_areas>

## Architecture & Dependencies

<architecture>
**Current Architecture:**
{Description of how the relevant parts of the system are currently structured}

**Data Flow:**
{How data flows through the system in the affected areas}

**Key Components:**
- {Component 1} - {its role and relationships}
- {Component 2} - {its role and relationships}

**Integration Points:**
- {Integration point 1} - {what connects where}
- {Integration point 2} - {what connects where}
</architecture>

<dependencies>
**Technical Dependencies:**
- {Dependency 1} - {why it's needed and current version}
- {Dependency 2} - {why it's needed and current version}

**Internal Dependencies:**
- {Internal component 1} - {how it's used}
- {Internal component 2} - {how it's used}

**External Dependencies:**
- {External service/API 1} - {how it's integrated}
- {External service/API 2} - {how it's integrated}

**Constraints:**
- {Constraint 1} - {why this matters}
- {Constraint 2} - {why this matters}
</dependencies>

## Acceptance Criteria

<acceptance_criteria>
### Core Functionality
- [ ] {Criterion 1 - specific, measurable outcome}
- [ ] {Criterion 2 - specific, measurable outcome}

### Quality Standards
- [ ] Code follows existing patterns and conventions
- [ ] All tests pass (existing + new)
- [ ] Documentation is updated
- [ ] No breaking changes to existing functionality (or documented if necessary)

</acceptance_criteria>

## Potential Risks & Considerations

<risks>
**Technical Risks:**
- {Risk 1} - {mitigation consideration}
- {Risk 2} - {mitigation consideration}

**Breaking Changes:**
- {Potential breaking change 1} - {impact assessment}
- {Potential breaking change 2} - {impact assessment}

**Edge Cases:**
- {Edge case 1 to consider}
- {Edge case 2 to consider}
</risks>

## Analysis Summary

<analysis_summary>
**Files Analyzed**: {number}
**Directories Searched**: {number}
**Integration Points Found**: {number}
**Dependencies Identified**: {number}

**Key Findings:**
- {Finding 1}
- {Finding 2}
- {Finding n}
</analysis_summary>

## Notes

{Any additional context, assumptions, technical debt observations, or important considerations discovered during analysis}

---

**Task Folder**: `./Circle/{task-folder-name}/`

**Files in this folder**:
- `ticket.md` (this file) - Task requirements and acceptance criteria with deep context
- `plan.md` (next step) - Implementation plan with HOW to execute
- `review.md` (after implementation) - Code review and quality assessment

**Note**: Implementation progress is tracked in real-time via terminal output, not in a separate file.

**Next Step**: Create implementation plan with `/2_plan @Circle/{task-folder-name}`
</output>

## Guidelines

### DO:
- ✅ Map out all dependencies and integration points
- ✅ Understand existing patterns and architecture
- ✅ Document everything discovered during analysis
- ✅ Ask clarification questions when needed
- ✅ Focus on WHAT needs to be done (requirements, scope, context)
- ✅ Use XML tags for structured sections

### DON'T:
- ❌ Skip reading files - read them fully
- ❌ Make shallow assumptions - dig deep
- ❌ Focus on HOW to implement (that's for planning phase)
- ❌ Design the solution (that's for planning phase)
- ❌ Write implementation steps (that's for planning phase)
- ❌ Guess at unclear requirements (ask instead)
- ❌ Rush the analysis - thoroughness is critical

## Key Principle

**This phase answers "WHAT":**
- WHAT needs to be done
- WHAT files are involved
- WHAT dependencies exist
- WHAT the current state is
- WHAT the requirements are
- WHAT the acceptance criteria are

**The planning phase will answer "HOW":**
- HOW to implement it
- HOW to structure the code
- HOW to handle edge cases
- HOW to test it

## Control Flow

<execution_steps>
1. **Parse user intent** - Extract core requirements
2. **Launch parallel exploration** - Run 3-4 agents simultaneously using multiple Task tool calls in ONE message
3. **Wait for agent completion** - Collect all findings
4. **Synthesize results** - Consolidate agent outputs
5. **Validate understanding** - Ask clarification questions if needed
6. **Generate folder name** - Create descriptive kebab-case name
7. **Create Circle folder** - `./Circle/{task-folder-name}/`
8. **Generate comprehensive ticket** - With all discovered context
9. **Save ticket** - `./Circle/{task-folder-name}/ticket.md`
10. **Report completion** - Show analysis summary and next steps
</execution_steps>

<validation_criteria>
Before generating ticket:
- ✅ All parallel agents have completed
- ✅ Key files and patterns identified
- ✅ Dependencies mapped
- ✅ Requirements are clear (or clarified)
- ✅ Folder name is descriptive
</validation_criteria>

## Example Output Message

<example>
✅ Task folder created: `./Circle/oauth-authentication/`

**Analysis Complete**:
- 47 files analyzed
- 12 files will need modification
- 8 integration points identified
- 5 dependencies mapped

**Files created**:
- `./Circle/oauth-authentication/ticket.md` - Comprehensive task requirements with deep context analysis

**Task Summary**: Implement OAuth2 authentication system

**Key Findings**:
- Existing auth system uses JWT tokens in 3 different patterns
- User model has 2 authentication strategies currently
- Session management spans across 5 modules
- 23 API endpoints will need auth integration

**Next step**:
Create an implementation plan that designs HOW to build this:
```
/2_plan @Circle/oauth-authentication
```