---
description: Execute implementation plan step-by-step
argument-hint: <task_folder_path> [--continue=review|all]
model: inherit
allowed-tools: Read, Write, Edit, Glob, Grep, Bash, Task, TodoWrite, SlashCommand
---

# Plan Executor

## Purpose

Execute plan tasks sequentially with validation. Track progress with TodoWrite.

## Process

### 1. Pre-flight Checks

<example>
Bash("git status --porcelain")
Bash("git branch --show-current")
SlashCommand("/checks")
</example>

If working directory not clean → ask user: "(1) Commit (2) Stash (3) Continue"
If on main branch → suggest feature branch
If quality checks fail → STOP

### 2. Load Plan

<example>
Read(".claude/tasks/{task-folder}/ticket.md")
Read(".claude/tasks/{task-folder}/plan.md")
</example>

Create TodoWrite list with all tasks.

### 3. Implement Each Task

For each task:

**Mark in progress**:
<example>
TodoWrite("mark_in_progress", task_id)
</example>

**Read patterns**:
<example>
Read("src/existing-similar-file.ts")
</example>

**Implement**:

- Follow project patterns
- Make incremental changes
- Handle errors explicitly

**Validate**:
<example>
SlashCommand("/checks")
</example>

If validation fails → offer: (1) Retry (2) Skip (3) Debug (4) Rollback

**Mark complete**:
<example>
TodoWrite("mark_completed", task_id)
</example>

### 4. Final Validation

Run full quality checks and validate against acceptance criteria from ticket:

<example>
SlashCommand("/checks")
Read(".claude/tasks/{task-folder}/ticket.md")
# Verify all acceptance criteria are met
</example>

### 5. Report & Continue

Show summary:

```
Implementation complete: .claude/tasks/{task-folder}

Tasks: {N} completed
Files: {M} modified

Modified:
- {file}: {what_changed}
```

**Handle --continue argument** (check if `$ARGUMENTS` contains `--continue=<value>`):

<example>
# Parse arguments to extract --continue value
if "--continue=all" or "--continue=review" in arguments:
  SlashCommand("/4_review .claude/tasks/{task-folder}")
else:
  # No --continue flag, ask user interactively
  response = AskUserQuestion(
    question: "The implementation has been completed successfully. What would you like to do next?",
    options: [
      "Continue to code review phase (/4_review)",
      "Test the changes manually first (stop here)",
      "Run quality checks (/checks)",
      "Other (specify custom action)"
    ]
  )

  # Handle response:
  if response == "Continue to code review phase (/4_review)":
    Output: `\n🔄 Continuing to review...\n`
    SlashCommand("/4_review .claude/tasks/{task-folder}")
  elif response == "Test the changes manually first (stop here)":
    Output: `\n✅ Implementation complete. Test your changes before running /4_review\n`
  elif response == "Run quality checks (/checks)":
    Output: `\n🔄 Running quality checks...\n`
    SlashCommand("/checks")
  else:
    # User selected "Other" or provided custom input
    Output: `\n✅ Implementation complete.\n`
    # Handle custom user input as needed
</example>
