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

Output: `⚡ Starting Implementation`

### 1. Pre-flight Checks

Output: `🔄 Running pre-flight checks...`

<example>
Bash("git status --porcelain")
Bash("git branch --show-current")
SlashCommand("/checks")

Show results:
```
├─ ✅ Git status: {clean|has changes}
├─ ✅ Branch: {current_branch}
└─ ✅ Quality checks: {passing|failing}
```
</example>

If working directory not clean:
```
⚠️ Uncommitted Changes Detected

**Current state**: {N} modified, {M} untracked files

**Options**:
1. ✅ Commit changes first (recommended)
   Command: git add . && git commit -m "..."

2. Stash changes temporarily
   Command: git stash

3. Continue anyway (risky - may conflict)

Choose (1-3): _
```

If on main branch:
```
⚠️ On Main Branch

**Recommendation**: Create feature branch first

**Options**:
1. ✅ Create feature branch (recommended)
   Command: git checkout -b feature/{task-name}

2. Continue on main (not recommended)

Choose (1-2): _
```

If quality checks fail → STOP with error details

### 2. Load Plan

Output: `🔄 Loading plan...`

<example>
Read(".claude/tasks/{task-folder}/ticket.md")
Read(".claude/tasks/{task-folder}/plan.md")
Output: `✅ Plan loaded: {M} tasks across {N} phases`
</example>

Create TodoWrite list with all tasks.

Show plan overview:
```
📋 Implementation Plan:
├─ Phase 1: Foundation ({N} tasks)
├─ Phase 2: Core ({M} tasks)
├─ Phase 3: Integration ({K} tasks)
├─ Phase 4: Validation ({L} tasks)
└─ Phase 5: Documentation ({P} tasks)

Total: {total} tasks
```

### 3. Implement Each Task

For each phase, show progress:

```
📋 Implementation Progress

Phase {current}: {Phase Name} [████████░░] {percentage}%

├─ ✅ Task {N}.1: {title} ({time}s)
├─ ✅ Task {N}.2: {title} ({time}s)
├─ 🔄 Task {N}.3: {title} (in progress)
└─ ⚪ Task {N}.4: {title} (pending)

⏱️  {elapsed}s elapsed | ~{remaining}s remaining
```

For each task:

**Mark in progress**:
<example>
TodoWrite("mark_in_progress", task_id)
Output:
```
┌─────────────────────────────────────────────┐
│ Task {N}.{M}: {Title}                       │
├─────────────────────────────────────────────┤
│ Status: 🔄 In Progress                      │
│ Time: 00:{seconds}                          │
└─────────────────────────────────────────────┘
```
</example>

**Read patterns**:
<example>
Read("src/existing-similar-file.ts")
Output: `├─ ✅ Read similar patterns ({file})`
</example>

**Implement**:

- Follow project patterns
- Make incremental changes
- Handle errors explicitly

Output: `├─ ✅ Implementation complete`

**Validate**:
<example>
Output: `├─ 🔄 Running validation checks...`
SlashCommand("/checks")

Show validation results:
```
│  ├─ ✅ TypeScript check passed
│  ├─ ✅ Prettier check passed
│  └─ ✅ ESLint check passed
```
</example>

If validation fails:
```
❌ Validation Failed: {Check Name}

**Error**: {specific_error_message}
**File**: {file}:{line}

**Quick Fix Options**:
1. ✅ Fix automatically (if possible)
2. Skip validation and continue (risky)
3. Edit manually
4. Rollback this task

Choose (1-4): _
```

**Mark complete**:
<example>
TodoWrite("mark_completed", task_id)
Output: `└─ ✅ Task complete ({time}s)`
</example>

### 4. Final Validation

Output: `🔄 Running final validation...`

Run full quality checks and validate against acceptance criteria from ticket:

<example>
SlashCommand("/checks")
Read(".claude/tasks/{task-folder}/ticket.md")
# Verify all acceptance criteria are met

Show results:
```
✅ Final Validation Complete

| Check | Status |
|-------|--------|
| TypeScript | ✅ PASS |
| ESLint | ✅ PASS |
| Prettier | ✅ PASS |
| Tests | ✅ PASS ({N}/{N}) |
| Build | ✅ PASS |

Acceptance Criteria: {M}/{M} met
```
</example>

### 5. Report & Continue

Show comprehensive summary:

```
┌─────────────────────────────────────────────┐
│ ⚡ Implementation Complete                  │
├─────────────────────────────────────────────┤
│ Task: {Task Title}                          │
│ Tasks Completed: {N}/{N}                    │
│ Files Modified: {M}                         │
│ Duration: {time}                            │
└─────────────────────────────────────────────┘

📁 Files Modified:
├─ {file1} (created)
├─ {file2} (modified)
├─ {file3} (modified)
└─ {file4} (created)

✅ Final Validation:
├─ All quality checks passed
├─ All tests passing ({N}/{N})
└─ All acceptance criteria met ({M}/{M})

⏭️  Next Step:
/4_review .claude/tasks/{task-folder}
```

**Handle --continue argument** (check if `$ARGUMENTS` contains `--continue=<value>`):

<example>
# Parse arguments to extract --continue value
if "--continue=all" or "--continue=review" in arguments:
  Output: `\n🔄 Auto-continuing to review (--continue=review)...\n`
  SlashCommand("/4_review .claude/tasks/{task-folder}")
else:
  # No --continue flag, ask user interactively
  AskUserQuestion("The implementation has been completed successfully. Would you like to continue to the code review phase?

I'll run: `/4_review .claude/tasks/{task-folder}`

Type 'yes' to continue automatically, or 'no' to stop here and test the changes manually first.")

  # If user confirms:
  Output: `\n🔄 Continuing to review...\n`
  SlashCommand("/4_review .claude/tasks/{task-folder}")
</example>
