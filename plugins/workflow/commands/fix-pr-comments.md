---
description: Fetch and fix PR review comments systematically
argument-hint: <pr_number> [task_folder]
---

# PR Comment Fixer

You are fixing review comments from a pull request. Fetch comments, prioritize them, and implement fixes systematically.

## Core Principles

- **Prioritize by severity**: Fix critical issues first
- **Read before editing**: Always understand context before making changes
- **Validate after each fix**: Run checks to catch regressions
- **Use TodoWrite**: Track each comment being fixed

---

## Phase 1: Fetch PR Comments

**Goal**: Get all review comments from the PR

Input: $ARGUMENTS (PR number, optional task folder)

**Actions**:
1. Create todo list with phases
2. Checkout the PR branch:
   ```
   gh pr checkout {pr_number}
   ```

3. Fetch PR details and comments:
   ```
   gh pr view {pr_number} --json title,body,headRefName
   gh pr view {pr_number} --comments
   gh api repos/{owner}/{repo}/pulls/{pr_number}/comments
   ```

4. If no comments found, report and STOP

---

## Phase 2: Organize Comments

**Goal**: Prioritize and plan fixes

**Actions**:
1. Group comments by severity:
   - **Critical**: Bugs, security issues, breaking changes
   - **High**: Logic errors, major improvements
   - **Medium**: Code quality, refactoring suggestions
   - **Low**: Style, nitpicks, optional improvements

2. Group by file for efficient editing

3. Create TodoWrite list with all comments to fix

4. **Present prioritized list to user**:
   ```
   PR #{pr_number} Comments:

   Critical ({count}):
   - {file}:{line} - {comment summary}

   High ({count}):
   - {file}:{line} - {comment summary}

   Medium ({count}):
   - {file}:{line} - {comment summary}

   Which would you like to fix? (all / critical+high / select specific)
   ```

5. **Wait for user decision**

---

## Phase 3: Fix Comments

**Goal**: Implement each fix

**For each comment to fix**:

1. **Mark in progress**:
   ```
   TodoWrite - mark comment as in_progress
   ```

2. **Read the file**:
   ```
   Read("{file}")
   ```

3. **Understand the context** and the reviewer's intent

4. **Implement the fix**:
   ```
   Edit("{file}", old_code, new_code)
   ```

5. **Validate**:
   ```
   /checks
   ```

6. **Handle failures**: If checks fail, fix or ask user

7. **Mark complete**:
   ```
   TodoWrite - mark comment as completed
   ```

---

## Phase 4: Update Task (if task folder provided)

**Goal**: Document fixes in task artifacts

**Actions**:
1. If task folder provided:
   - Read existing review: `Read("{task_folder}/review.md")`
   - Append PR fixes section with what was addressed

---

## Phase 5: Summary

**Goal**: Report what was fixed

**Actions**:
1. Mark all todos complete
2. Show summary:
   ```
   PR Comments Fixed: #{pr_number}

   Addressed: {fixed}/{total}
   Files modified: {count}

   Fixed:
   - {file}:{line} - {what was done}
   - {file}:{line} - {what was done}

   Skipped (manual review needed):
   - {comment} - {reason}

   Next: Commit changes and request re-review
   ```

3. Offer to commit changes:
   ```
   Ready to commit? (Will use: "fix: address PR review comments")
   ```
