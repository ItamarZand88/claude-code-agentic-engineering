---
description: Fix PR review comments
argument-hint: <pr_number> [task_folder]
model: inherit
allowed-tools: Read, Write, Edit, Glob, Grep, Bash, Task, TodoWrite, SlashCommand
---

# PR Comment Fixer

## Purpose

Fetch PR comments and implement fixes.

Output: `🔧 Fixing PR Comments`

## Process

### 1. Fetch PR

Output: `🔄 Step 1/5: Fetching PR #{pr_number}...`

<example>
Bash("gh pr view {pr_number} --json title,body,reviews,comments")
Output: `✅ PR fetched: {title}`
</example>

### 2. Organize Comments

Output: `🔄 Step 2/5: Analyzing comments...`

Group by file and priority (Critical/High/Medium/Low).

Show analysis:
```
📋 PR #{pr_number} Comments Analysis

├─ 🔴 Critical (must fix): {N}
├─ 🟡 High Priority: {N}
├─ 🟠 Medium: {N}
└─ ⚪ Low/Nitpicks: {N}

Total: {total} comments across {M} files
Focus on: {N} critical/high priority
```

Create TodoWrite list.

Output: `✅ {total} comments analyzed`

### 3. Fix Each Comment

Output: `🔄 Step 3/5: Fixing comments...`

Show progress:
```
🔧 Fixing Comments [{N}/{total}]

├─ ✅ Comment 1: Fixed styling issue (file1.ts:12)
├─ ✅ Comment 2: Fixed type error (file2.ts:45)
├─ 🔄 Comment 3: Fixing logic issue (file3.ts:23)
└─ ⚪ Comment 4: Pending

⏱️ {elapsed}s elapsed | ~{remaining}s remaining
```

<example>
Bash("git checkout {pr_branch}")
TodoWrite("mark_in_progress", comment_id)
Read("{file}")
Edit("{file}", old_string, new_string)
TodoWrite("mark_completed", comment_id)
</example>

Output: `✅ {N}/{total} comments addressed`

### 4. Validate

Output: `🔄 Step 4/5: Validating fixes...`

<example>
SlashCommand("/checks")
</example>

Output: `✅ All checks passed`

### 5. Update Task Review (if task_folder provided)

Output: `🔄 Step 5/5: Updating review...`

Append PR fixes to `{task_folder}/review.md`.

Output: `✅ Review updated`

## Report

Show comprehensive summary:

```
┌─────────────────────────────────────────────┐
│ 🔧 PR Comments Fixed                        │
├─────────────────────────────────────────────┤
│ PR: #{pr_number}                            │
│ Addressed: {count}/{total} comments         │
│ Files Modified: {N}                         │
│ Duration: {time}s                           │
└─────────────────────────────────────────────┘

✅ Fixed Comments ({count}):
├─ 🔴 Critical: {N}/{N} fixed
├─ 🟡 High: {N}/{N} fixed
├─ 🟠 Medium: {N}/{N} fixed
└─ ⚪ Low: {N}/{N} fixed

📁 Files Modified:
├─ {file1} ({N} comments fixed)
├─ {file2} ({N} comments fixed)
└─ {file3} ({N} comments fixed)

⚠️ Manual Review Needed ({N}):
├─ {comment} - {reason}
└─ {comment} - {reason}

⏭️  Next Steps:
1. Review changes: git diff
2. Run tests: npm test
3. Commit: git commit -m "fix: Address PR #{pr_number} comments"
4. Push: git push
```
