---
description: Create task ticket from user prompt with codebase analysis
argument-hint: <task_description>
model: inherit
allowed-tools: Read, Write, Glob, Grep, Bash, Task
---

# Task Ticket Generator

## Purpose

Understand WHAT needs to be done by analyzing the codebase and asking clarifying questions. The ticket defines requirements and context for the planning phase.

## Process

### 1. Load Project Standards

**ALWAYS start by reading standards** (if they exist):

<example>
Bash("ls Circle/standards/")
Read("Circle/standards/README.md")
</example>

This ensures the ticket accounts for:

- Project conventions
- Technical constraints
- Architecture patterns
- Coding standards

If no standards exist → continue without them.

### 2. Understand Requirements

Analyze `$ARGUMENTS` to identify:

- Task type (feature/bugfix/refactor/documentation)
- Core requirements
- Mentioned technologies
- Unclear areas (flag for clarification)

If requirements are completely unclear → ask clarifying questions and STOP.

### 3. Analyze Codebase

Choose agents based on task complexity:

**For new features** (complex):
<example>
Task(architecture-explorer, "Discover project structure for {task}")
Task(feature-finder, "Find similar implementations for {task}")
Task(dependency-mapper, "Map dependencies for {task}")
</example>

**For bug fixes** (simple):
<example>
Task(feature-finder, "Locate affected code for {bug_description}")
</example>

**For simple changes** - skip agents, use direct search.

### 4. Make Architecture Decision (if needed)

For complex tasks with multiple implementation approaches:

<example>
Task(implementation-strategist, "Evaluate approaches for {task}:
- List 2-3 viable options
- Analyze trade-offs
- Recommend best approach with rationale")
</example>

Present options to user:

```
I've analyzed {N} approaches for {task}:

Option 1: {name}
- Pros: {benefits}
- Cons: {drawbacks}

Option 2: {name}
- Pros: {benefits}
- Cons: {drawbacks}

Recommendation: {choice} because {reason}

Which approach would you like?
```

STOP and wait for user decision.

### 5. Create Task Folder

Generate kebab-case folder name and create:

```
./Circle/{task-name}/
├── ticket.md
```

### 6. Generate Ticket

Save to `Circle/{task-name}/ticket.md`:

```markdown
# {Task Title}

**Date**: {date}
**Type**: feature|bugfix|refactor|documentation
**Status**: ready-for-planning

## Description

{3-4 sentences on WHAT and WHY}

## Context

{Existing implementation, patterns discovered from agents}

## Project Standards (if exist)

{Key standards from Circle/standards/ relevant to this task:

- Naming conventions to follow
- Architecture patterns to use
- Technical constraints to consider}

## Implementation Strategy (if architectural decision made)

- **Approach**: {chosen_approach}
- **Rationale**: {why}
- **Key Decisions**: {important_choices}
- **Technologies**: {libraries_to_use}
- **Integration Points**: {where_it_connects}
- **Standards Alignment**: {how_approach_follows_standards}

## Requirements

**Functional**:

- [ ] {requirement_1}
- [ ] {requirement_2}

**Non-Functional**:

- [ ] {performance_requirement}
- [ ] {security_requirement}
- [ ] Follows project standards

## Affected Areas

- {file_to_modify}
- {file_to_create}
- {config_to_update}

## Dependencies

- {internal_dependency}
- {external_library}

## Acceptance Criteria

- [ ] {criterion_1}
- [ ] {criterion_2}
- [ ] Code follows Circle/standards/

## Risks

- {risk} - {mitigation}

## Next

`/2_plan @Circle/{task-name}`
```

### 7. Report

Show summary and ask:

```
✅ Ticket: Circle/{task-name}/ticket.md

Summary: {brief_task_description}

Key Findings:
- {finding_1}
- {finding_2}

Ready for planning? (I'll run /2_plan)
```

If user confirms → run `/2_plan @Circle/{task-name}`

## Guidelines

- **ALWAYS read standards first**
- Focus on WHAT, not HOW
- Choose agents intelligently (don't use all for simple tasks)
- Ask clarifications when needed
- Document architectural decisions clearly
- Ensure ticket aligns with project standards
