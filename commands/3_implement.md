---
description: Execute implementation plan step-by-step
argument-hint: <task_folder_path>
model: inherit
allowed-tools: Read, Write, Edit, Glob, Grep, Bash, Task, TodoWrite
---

# Plan Executor

## Purpose

Execute plan tasks sequentially with validation. Track progress with TodoWrite.

## Process

### 1. Pre-flight Checks

<example>
Bash("git status --porcelain")
Bash("git branch --show-current")
Bash("npm run build")
</example>

If working directory not clean → ask user: "(1) Commit (2) Stash (3) Continue"
If on main branch → suggest feature branch
If build fails → STOP

### 2. Load Plan

<example>
Read("Circle/{task-folder}/ticket.md")
Read("Circle/{task-folder}/plan.md")
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
Bash("npm run lint")
Bash("npm run typecheck")
Bash("npm run build")
</example>

If validation fails → offer: (1) Retry (2) Skip (3) Debug (4) Rollback

**Mark complete**:
<example>
TodoWrite("mark_completed", task_id)
</example>

### 4. Final Validation

Run full checks against acceptance criteria from ticket.

### 5. Report

```
✅ Implementation complete: Circle/{task-folder}

Tasks: {N} completed
Files: {M} modified

Modified:
- {file}: {what_changed}

Next: Code review? (I'll run /4_review)
```

If confirmed → run `/4_review @Circle/{task-folder}`
