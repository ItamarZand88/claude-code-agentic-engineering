---
description: Understand PR context, fix review comments systematically, and update best practices
argument-hint: <pr_number> [task_folder]
---

# PR Comment Fixer

You are fixing review comments from a pull request. First understand the PR's scope and purpose, then fetch comments, prioritize them, implement fixes systematically, and extract learnings to update project best practices.

## Core Principles

- **Understand the PR scope first**: Before fixing comments, understand the PR's purpose, changed files, and implementation approach
- **Prioritize by severity**: Fix critical issues first
- **Read before editing**: Always understand context before making changes
- **Validate after each fix**: Run checks to catch regressions
- **Extract learnings**: Update best practices with patterns from review comments
- **Use TodoWrite**: Track each comment being fixed

---

## Phase 1: Fetch PR Context & Comments

**Goal**: Understand the PR scope and get all review comments

Input: $ARGUMENTS (PR number, optional task folder)

**Actions**:
1. Create todo list with phases:
   - Phase 1: Fetch PR Context & Comments
   - Phase 2: Organize Comments
   - Phase 3: Fix Comments
   - Phase 4: Update Task (if applicable)
   - Phase 5: Update Best Practices
   - Phase 6: Summary

2. Checkout the PR branch:
   ```
   gh pr checkout {pr_number}
   ```

3. Fetch PR details and understand the scope:
   ```
   gh pr view {pr_number} --json title,body,headRefName,additions,deletions,changedFiles
   gh pr diff {pr_number} --name-only
   ```

4. **Understand PR Context**:
   - **Purpose**: What is this PR trying to achieve? (from title & body)
   - **Scope**: Which files changed and why?
   - **Impact**: How many files/lines changed?
   - Read changed files to understand the implementation approach

5. Fetch all review comments:
   ```
   gh pr view {pr_number} --comments
   gh api repos/{owner}/{repo}/pulls/{pr_number}/comments
   ```

6. If no comments found, report and STOP

**Present PR Overview**:
```
PR #{pr_number}: {title}
Branch: {headRefName}

Purpose: {summary from body}
Files Changed: {count} files (+{additions} -{deletions})

Key Changes:
- {file}: {brief description}
- {file}: {brief description}

Review Comments: {count} total
```

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

**Goal**: Implement each fix with full context understanding

**For each comment to fix**:

1. **Mark in progress**:
   ```
   TodoWrite - mark comment as in_progress
   ```

2. **Read the file and understand context**:
   ```
   Read("{file}")
   ```
   - Consider: How does this file fit into the PR's overall purpose?
   - Consider: What was the original implementation trying to achieve?
   - Consider: How will this fix align with the PR's goals?

3. **Understand the reviewer's intent**:
   - What is the underlying issue?
   - Is this a bug, style issue, or architectural concern?
   - Does this comment reveal a broader pattern to address?

4. **Implement the fix**:
   ```
   Edit("{file}", old_code, new_code)
   ```
   - Ensure the fix addresses the root cause, not just the symptom
   - Maintain consistency with the PR's implementation approach

5. **Validate**:
   ```
   /agi:checks
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

## Phase 5: Update Best Practices

**Goal**: Extract and integrate learnings from review comments into project best practices

**Actions**:

1. **Check if best practices exist**:
   ```
   Glob(".claude/best-practices/*.md")
   ```

2. **Analyze review comments for patterns**:
   - Look for recurring themes across comments
   - Identify coding standards violations
   - Extract explicit rules mentioned by reviewers
   - Identify new patterns worth documenting

3. **Read existing best practices**:
   ```
   Read(".claude/best-practices/README.md")
   Read(".claude/best-practices/{relevant-file}.md")
   ```

4. **Determine updates needed**:
   - **New rules**: Extract new coding standards from comments
   - **Updated rules**: Refine existing rules based on feedback
   - **Examples**: Add concrete examples from this PR

5. **Update best practices files**:
   - If new pattern identified: Add new section or create new file
   - If refining existing rule: Update with clearer guidance
   - Add PR number as reference for context

6. **Example updates**:
   ```
   Comment: "Use const instead of let for immutable variables"
   → Update: .claude/best-practices/javascript.md
     Add/strengthen rule about preferring const

   Comment: "Missing error handling in async functions"
   → Update: .claude/best-practices/error-handling.md
     Add rule: "Always wrap async operations in try-catch"

   Comment: "Component props should be typed with interfaces not types"
   → Update: .claude/best-practices/typescript.md
     Add rule: "Prefer interfaces for component props"
   ```

7. **Report updates**:
   ```
   Best Practices Updated:

   New Rules Added:
   - {file}: {rule description}

   Rules Updated:
   - {file}: {what changed}

   (Run /agi:4_review on future PRs to enforce these automatically)
   ```

**When to skip**:
- No best practices directory exists (suggest running `/agi:best-practices` first)
- Comments are all one-off issues, not patterns
- All comments are subjective preferences without broader applicability

---

## Phase 6: Summary

**Goal**: Report what was fixed and learned

**Actions**:
1. Mark all todos complete

2. Show comprehensive summary:
   ```
   ═══════════════════════════════════════════════════
   PR #{pr_number} - Review Comments Resolution
   ═══════════════════════════════════════════════════

   📊 Overview:
   - Comments Addressed: {fixed}/{total}
   - Files Modified: {count}
   - Best Practices Updated: {yes/no}

   ✅ Fixed:
   - {file}:{line} - {what was done}
   - {file}:{line} - {what was done}

   ⚠️  Skipped (manual review needed):
   - {comment} - {reason}

   📚 Best Practices Updates:
   - {file}: {new/updated rule description}
   - {file}: {new/updated rule description}

   🎯 Impact:
   - These changes will be automatically enforced in future code reviews
   - Run /agi:4_review to validate against updated standards

   ═══════════════════════════════════════════════════
   Next Steps:
   1. Review the changes
   2. Commit and push
   3. Request re-review from the PR author
   ═══════════════════════════════════════════════════
   ```

3. Offer to commit changes:
   ```
   Ready to commit?

   Suggested commit message:
   "fix: address PR #{pr_number} review comments

   - Fixed {count} review comments
   - Updated best practices with learnings"

   Proceed? (yes/no)
   ```
