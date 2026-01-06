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

Output: `🎫 Creating Task Ticket`

**ALWAYS start by reading best practices** (if they exist):

<example>
Output: `🔄 Step 1/6: Loading best practices...`
Bash("ls .claude/best-practices/")
Read(".claude/best-practices/README.md")
Output: `✅ Best practices loaded ({N} categories)`
</example>

This ensures the ticket accounts for:

- Project conventions
- Technical constraints
- Architecture patterns
- Coding best practices

If no best practices exist:
<example>
Output: `ℹ️  No best practices found (continuing without)`
</example>

### 2. Understand Requirements

Output: `🔄 Step 2/6: Analyzing requirements...`

Analyze `$ARGUMENTS` to identify:

- Task type (feature/bugfix/refactor/documentation)
- Core requirements
- Mentioned technologies
- Unclear areas (flag for clarification)

Output: `✅ Requirements understood (Type: {type})`

If requirements are completely unclear → ask clarifying questions and STOP.

### 3. Analyze Codebase

Output: `🔄 Step 3/6: Analyzing codebase...`

Choose agents based on task complexity:

**For new features** (complex):
<example>
Output: `🔄 Running 3 agents in parallel...`

Show agent progress:
```
┌─────────────────────────────────────────────┐
│ Agent Progress                              │
├─────────────────────────────────────────────┤
│ 🟡 architecture-explorer   (running)        │
│ 🟡 feature-finder         (running)         │
│ 🟡 dependency-mapper       (running)        │
└─────────────────────────────────────────────┘
```

Task(architecture-explorer, "Discover project structure for {task}")
Task(feature-finder, "Find similar implementations for {task}")
Task(dependency-mapper, "Map dependencies for {task}")

Update as each completes, then:
Output: `✅ All agents completed ({time}s total)`
</example>

**For bug fixes** (simple):
<example>
Output: `🔄 Running 1 agent...`
Task(feature-finder, "Locate affected code for {bug_description}")
Output: `✅ Analysis completed ({time}s)`
</example>

**For simple changes**:
<example>
Output: `🔍 Using direct search (task too simple for agents)`
</example>

### 4. Make Architecture Decision (if needed)

Output: `🔄 Step 4/6: Evaluating implementation approaches...`

For complex tasks with multiple implementation approaches:

<example>
Task(implementation-strategist, "Evaluate approaches for {task}:
- List 2-3 viable options
- Analyze trade-offs
- Recommend best approach with rationale")

Output: `✅ Analyzed {N} implementation approaches`
</example>

Present options to user:

```
┌─────────────────────────────────────────────┐
│ 🔍 Implementation Approach Options          │
├─────────────────────────────────────────────┤
│ Found {N} viable approaches                 │
└─────────────────────────────────────────────┘

**Option 1: {name}**
├─ ✅ Pros: {benefits}
└─ ❌ Cons: {drawbacks}

**Option 2: {name}**
├─ ✅ Pros: {benefits}
└─ ❌ Cons: {drawbacks}

**Recommendation**: {choice}
**Reason**: {explanation}

Which approach would you like? (1/{N}): _
```

STOP and wait for user decision.

### 5. Create Task Folder

Output: `🔄 Step 5/6: Creating task folder...`

Generate kebab-case folder name and create:

```
./.claude/tasks/{task-name}/
├── ticket.md
```

Output: `✅ Task folder created: .claude/tasks/{task-name}/`

### 6. Generate Ticket

Output: `🔄 Step 6/6: Generating ticket...`

Save to `.claude/tasks/{task-name}/ticket.md`:

Output: `✅ Ticket generated`

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

Show comprehensive summary:

```
┌─────────────────────────────────────────────┐
│ 🎫 Ticket Created                           │
├─────────────────────────────────────────────┤
│ Task: {Task Title}                          │
│ Type: {feature|bugfix|refactor}             │
│ Folder: .claude/tasks/{task-name}/          │
│ Duration: {total_time}s                     │
└─────────────────────────────────────────────┘

📊 Analysis Results:
├─ ✅ Best practices: {loaded|not available}
├─ ✅ Architecture explored: {N files|skipped}
├─ ✅ Similar patterns found: {N matches|none}
└─ ✅ Dependencies mapped: {N internal, M external|skipped}

📝 Ticket Highlights:
├─ Requirements: {N} functional, {M} non-functional
├─ Affected Areas: {N} files to modify, {M} to create
├─ Risks: {N} identified with mitigations
└─ Strategy: {brief_strategy_summary|not specified}

📁 Files:
└─ 📝 .claude/tasks/{task-name}/ticket.md

⏭️  Next Step:
/2_plan .claude/tasks/{task-name}
```

**Handle --continue argument** (check if `$ARGUMENTS` contains `--continue=<value>`):

<example>
# Parse arguments to extract --continue value
if "--continue=all" or "--continue=review" in arguments:
  Output: `\n🔄 Auto-continuing to planning (--continue=all)...\n`
  SlashCommand("/2_plan .claude/tasks/{task-name} --continue=review")
elif "--continue=implement" in arguments:
  Output: `\n🔄 Auto-continuing to planning (--continue=implement)...\n`
  SlashCommand("/2_plan .claude/tasks/{task-name} --continue=implement")
elif "--continue=plan" in arguments:
  Output: `\n🔄 Auto-continuing to planning...\n`
  SlashCommand("/2_plan .claude/tasks/{task-name}")
else:
  # No --continue flag, show next step
  Output shown above
</example>

## Guidelines

- **ALWAYS read best practices first**
- Focus on WHAT, not HOW
- Choose agents intelligently (don't use all for simple tasks)
- Ask clarifications when needed
- Document architectural decisions clearly
- Ensure ticket aligns with project best practices
