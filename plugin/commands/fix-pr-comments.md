---
description: Understand PR context, fix review comments systematically, and update best practices
argument-hint: <pr_number> [task_folder]
---

# PR Comment Fixer

You are fixing review comments from a pull request. First understand the PR's scope and purpose, then fetch comments, prioritize them, implement fixes systematically, and extract learnings to update project best practices.

## Core Principles

- **Understand the PR scope first**: Before fixing comments, understand the PR's purpose, changed files, and implementation approach
- **Document the process**: Create comprehensive tracking document in `.claude/pr-fixes/pr-{number}.md`
- **Prioritize by severity**: Fix critical issues first
- **Read before editing**: Always understand context before making changes
- **Validate after each fix**: Run checks to catch regressions
- **Track progress**: Update status for each comment as you work
- **Extract learnings**: Update best practices with patterns from review comments
- **Use TodoWrite**: Track each comment being fixed

## Output Files

This command creates the following files:
- `.claude/pr-fixes/pr-{pr_number}.md` - Comprehensive PR fix tracking document with:
  - PR overview and context
  - Analysis of each review comment
  - Fix plan for each comment
  - Status tracking (Pending → In Progress → Fixed/Skipped)
  - Best practices learnings extracted
  - Complete audit trail

---

## Phase 1: Fetch PR Context & Comments

**Goal**: Understand the PR scope and get all review comments

Input: $ARGUMENTS (PR number, optional task folder)

**Actions**:
1. Create todo list with phases:
   - Phase 1: Fetch PR Context & Comments
   - Phase 2: Create PR Fix Plan Document
   - Phase 3: Organize & Prioritize Comments
   - Phase 4: Fix Comments
   - Phase 5: Update Task (if applicable)
   - Phase 6: Update Best Practices
   - Phase 7: Summary

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

## Phase 2: Create PR Fix Plan Document

**Goal**: Create a comprehensive tracking document for the PR fix process

**Actions**:

1. **Create directory structure**:
   ```
   mkdir -p .claude/pr-fixes
   ```

2. **Create PR fix plan file**: `.claude/pr-fixes/pr-{pr_number}.md`

3. **Document Structure**:
   ```markdown
   # PR #{pr_number} - {title}

   > Created: {timestamp}
   > Branch: {headRefName}
   > Status: 🔄 In Progress

   ## PR Overview

   **Purpose:** {summary from PR body}

   **Scope:**
   - Files Changed: {count} files
   - Lines: +{additions} -{deletions}
   - Commits: {count}

   **Key Changes:**
   - `{file1}`: {brief description of what changed and why}
   - `{file2}`: {brief description of what changed and why}

   ## Review Comments Summary

   - **Total Comments:** {count}
   - **Critical:** {count} 🔴
   - **High:** {count} 🟠
   - **Medium:** {count} 🟡
   - **Low:** {count} 🟢

   ---

   ## Comments & Fix Plan

   ### 1. [🔴 Critical] {file}:{line} - {brief title}

   **Reviewer Comment:**
   ```
   {original comment text from reviewer}
   ```

   **Analysis:**
   - **Issue Type:** {Bug / Security / Breaking Change / etc.}
   - **Impact:** {description of why this matters}
   - **Root Cause:** {what's the underlying problem}

   **Fix Plan:**
   - **Approach:** {how we'll fix it}
   - **Changes Needed:** {specific files/functions to modify}
   - **Validation:** {how to verify the fix works}

   **Status:** ⏳ Pending

   ---

   ### 2. [🟠 High] {file}:{line} - {brief title}

   {repeat structure for each comment}

   ---

   ## Fix Progress

   - [ ] Comment 1: {brief description}
   - [ ] Comment 2: {brief description}
   - [ ] Comment 3: {brief description}

   ---

   ## Best Practices Learnings

   {Will be populated after fixes are complete}
   ```

4. **Write the file**:
   ```
   Write(".claude/pr-fixes/pr-{pr_number}.md", content)
   ```

5. **Report to user**:
   ```
   📝 Created PR Fix Plan: .claude/pr-fixes/pr-{pr_number}.md

   This document tracks:
   - PR context and scope
   - All {count} review comments with analysis
   - Fix plan for each comment
   - Progress status (will update as we fix each comment)

   You can review this file to understand the full scope before we start fixing.
   ```

---

## Phase 3: Organize & Prioritize Comments

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

## Phase 4: Fix Comments

**Goal**: Implement each fix with full context understanding and track progress

**For each comment to fix**:

1. **Mark in progress in both places**:
   ```
   # Update TodoWrite
   TodoWrite - mark comment as in_progress

   # Update PR fix plan document
   Read(".claude/pr-fixes/pr-{pr_number}.md")
   Edit - Update status for this comment from "⏳ Pending" to "🔄 In Progress"
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

7. **Mark complete and update document**:
   ```
   # Update TodoWrite
   TodoWrite - mark comment as completed

   # Update PR fix plan document
   Read(".claude/pr-fixes/pr-{pr_number}.md")
   Edit - Update status for this comment from "🔄 In Progress" to "✅ Fixed"
   Edit - Check the checkbox in "Fix Progress" section
   Edit - Add brief note about what was done if helpful
   ```

8. **If skipped** (manual review needed):
   ```
   # Update PR fix plan document
   Read(".claude/pr-fixes/pr-{pr_number}.md")
   Edit - Update status from "⏳ Pending" to "⚠️ Skipped: {reason}"
   ```

---

## Phase 5: Update Task (if task folder provided)

**Goal**: Document fixes in task artifacts

**Actions**:
1. If task folder provided:
   - Read existing review: `Read("{task_folder}/review.md")`
   - Append PR fixes section with what was addressed

---

## Phase 6: Update Best Practices

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

8. **Update PR fix plan document**:
   ```
   Read(".claude/pr-fixes/pr-{pr_number}.md")
   Edit - Update "Best Practices Learnings" section with:
     - List of new rules extracted
     - List of updated rules
     - Reference to best practices files that were modified
   ```

**When to skip**:
- No best practices directory exists (suggest running `/agi:best-practices` first)
- Comments are all one-off issues, not patterns
- All comments are subjective preferences without broader applicability

---

## Phase 7: Summary

**Goal**: Report what was fixed and learned

**Actions**:
1. Mark all todos complete

2. **Update PR fix plan document status**:
   ```
   Read(".claude/pr-fixes/pr-{pr_number}.md")
   Edit - Update top status from "🔄 In Progress" to "✅ Complete"
   ```

3. Show comprehensive summary:
   ```
   ═══════════════════════════════════════════════════
   PR #{pr_number} - Review Comments Resolution
   ═══════════════════════════════════════════════════

   📋 Full Details: .claude/pr-fixes/pr-{pr_number}.md

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

4. Offer to commit changes:
   ```
   Ready to commit?

   Files to commit:
   - {modified code files}
   - .claude/pr-fixes/pr-{pr_number}.md (tracking document)
   - .claude/best-practices/*.md (if updated)

   Suggested commit message:
   "fix: address PR #{pr_number} review comments

   - Fixed {count} review comments
   - Updated best practices with learnings
   - Added PR fix tracking document"

   Proceed? (yes/no)
   ```

**Note**: The `.claude/pr-fixes/pr-{pr_number}.md` file serves as:
- Historical record of the PR fix process
- Reference for similar issues in the future
- Documentation of decisions made during fixes
- Audit trail for what was changed and why
