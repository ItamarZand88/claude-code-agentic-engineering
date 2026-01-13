---
description: Fix PR review comments
argument-hint: <pr_number> [task_folder]
model: inherit
allowed-tools: Read, Write, Edit, Glob, Grep, Bash, Task, TodoWrite, SlashCommand
---

# PR Comment Fixer

## Purpose

Fetch PR comments and implement fixes.

## Process

### 1. Fetch PR

<example>
Bash("gh pr view {pr_number} --json title,body,reviews,comments")
</example>

### 2. Organize Comments

Group by file and priority (Critical/High/Medium/Low).

Create TodoWrite list.

### 3. Fix Each Comment

<example>
Bash("git checkout {pr_branch}")
TodoWrite("mark_in_progress", comment_id)
Read("{file}")
Edit("{file}", old_string, new_string)
TodoWrite("mark_completed", comment_id)
</example>

### 4. Validate

<example>
SlashCommand("/checks")
</example>

### 5. Update Task Review (if task_folder provided)

Append PR fixes to `{task_folder}/review.md`.

## Report

```
✅ PR Comments Fixed

PR: #{pr_number}
Addressed: {count}/{total}
Files: {N} modified

Manual Review Needed:
- {comment} - {reason}

Next: Review changes and commit
```
