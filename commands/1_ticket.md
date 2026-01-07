---
description: Create task ticket from user prompt with codebase analysis
argument-hint: <task_description> [--continue=plan|implement|review|all]
model: inherit
allowed-tools: Read, Write, Glob, Grep, Bash, Task, SlashCommand
---

# Task Ticket Generator

## Purpose

Understand WHAT needs to be done by analyzing the codebase and asking clarifying questions. The ticket defines requirements and context for the planning phase.

## Process

### 1. Load Project Best Practices

**ALWAYS start by reading best practices** (if they exist):

<example>
Bash("ls .claude/best-practices/")
Read(".claude/best-practices/README.md")
</example>

This ensures the ticket accounts for:

- Project conventions
- Technical constraints
- Architecture patterns
- Coding best practices

If no best practices exist → continue without them.

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
./.claude/tasks/{task-name}/
├── ticket.md
```

### 6. Generate Ticket

Save to `.claude/tasks/{task-name}/ticket.md`:

```markdown
# {Task Title}

**Date**: {date}
**Type**: feature|bugfix|refactor|documentation
**Status**: ready-for-planning

## Description

{3-4 sentences on WHAT and WHY}

## Context

{Existing implementation, patterns discovered from agents}

## Similar Implementations in Codebase

{Document similar existing implementations found by feature-finder agent:

**Pattern**: {name_of_pattern}
- **Location**: {file_path}:{line}
- **Key Approach**: {how_it_works}
- **Patterns to Follow**: {naming, structure, error handling, etc.}
- **Example**:
  ```typescript
  // Show relevant code snippet
  ```

This implementation should follow the same patterns for consistency.}

## Project Best Practices (if exist)

{Key best practices from .claude/best-practices/ relevant to this task:

- Naming conventions to follow
- Architecture patterns to use
- Technical constraints to consider}

## Implementation Strategy (if architectural decision made)

- **Approach**: {chosen_approach}
- **Rationale**: {why}
- **Key Decisions**: {important_choices}
- **Technologies**: {libraries_to_use}
- **Integration Points**: {where_it_connects}
- **Best Practices Alignment**: {how_approach_follows_best_practices}

## Requirements

**Functional**:

- [ ] {requirement_1}
- [ ] {requirement_2}

**Non-Functional**:

- [ ] {performance_requirement}
- [ ] {security_requirement}
- [ ] Follows project best practices

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
- [ ] Code follows .claude/best-practices/
- [ ] Implementation matches patterns from similar existing code

## Risks

- {risk} - {mitigation}

## Next

`/2_plan @.claude/tasks/{task-name}`
```

### 7. Report & Continue

Show summary:

```
Ticket: .claude/tasks/{task-name}/ticket.md

Summary: {brief_task_description}

Key Findings:
- {finding_1}
- {finding_2}
```

**Handle --continue argument** (check if `$ARGUMENTS` contains `--continue=<value>`):

<example>
# Parse arguments to extract --continue value
if "--continue=all" or "--continue=review" in arguments:
  SlashCommand("/2_plan .claude/tasks/{task-name} --continue=review")
elif "--continue=implement" in arguments:
  SlashCommand("/2_plan .claude/tasks/{task-name} --continue=implement")
elif "--continue=plan" in arguments:
  SlashCommand("/2_plan .claude/tasks/{task-name}")
else:
  # No --continue flag, ask user interactively
  response = AskUserQuestion(
    question: "The ticket has been created successfully. What would you like to do next?",
    options: [
      "Continue to planning phase (/2_plan)",
      "Review the ticket first (stop here)",
      "Other (specify custom action)"
    ]
  )

  # Handle response:
  if response == "Continue to planning phase (/2_plan)":
    Output: `\n🔄 Continuing to planning...\n`
    SlashCommand("/2_plan .claude/tasks/{task-name}")
  elif response == "Review the ticket first (stop here)":
    Output: `\n✅ Stopped. Review the ticket at .claude/tasks/{task-name}/ticket.md\n`
  else:
    # User selected "Other" or provided custom input
    Output: `\n✅ Task ticket saved at .claude/tasks/{task-name}/ticket.md\n`
    # Handle custom user input as needed
</example>

## Guidelines

- **ALWAYS read best practices first**
- Focus on WHAT, not HOW
- Choose agents intelligently (don't use all for simple tasks)
- Ask clarifications when needed
- Document architectural decisions clearly
- Ensure ticket aligns with project best practices
