---
description: Fetches PR review comments and implements requested changes
argument-hint: <pr_number> [task_folder]
model: inherit
allowed-tools: Read, Write, Edit, Glob, Grep, Bash, Task, TodoWrite
---

# Fix PR Comments

## Instructions

<instructions>
**Purpose**: Fetch review comments from a GitHub Pull Request and implement all requested changes, with optional context from the original task.

**Core Principles**:

- Fetch and parse all PR review comments
- Link to original task context (ticket, plan, review) if provided
- Organize comments by file and priority
- Implement changes systematically
- Validate each fix before moving to next
- Commit changes with references to review comments
- Update task review.md with PR fixes summary

**Success Criteria**:

- All actionable review comments addressed
- Changes follow existing code patterns and original plan (if task provided)
- Tests pass after fixes
- Clear commit messages referencing comments
- Task artifacts updated with PR fix summary
  </instructions>

## Variables

### Dynamic Variables (User Input)

- **pr_number**: `$ARGUMENTS[0]` - The PR number to fetch comments from
- **task_folder**: `$ARGUMENTS[1]` (Optional) - Path to Circle task folder (e.g., `Circle/oauth-authentication`)

### Static Variables (Configuration)

- **GITHUB_CLI**: `gh` - GitHub CLI tool for API access

### Derived Variables (Computed During Execution)

- **pr_url**: Constructed from pr_number
- **comments_list**: Fetched review comments
- **files_affected**: List of files with comments
- **current_branch**: Git branch name
- **original_ticket**: Content from task_folder/ticket.md (if task_folder provided)
- **original_plan**: Content from task_folder/plan.md (if task_folder provided)
- **original_review**: Content from task_folder/review.md (if task_folder provided)

## Workflow

### Step 0: Load Task Context (Optional)

<step>
**Objective**: Load original task artifacts if task_folder provided

**Process**:

1. IF task_folder is provided:
   - Verify folder exists
   - Read `{task_folder}/ticket.md` → Store as original_ticket
   - Read `{task_folder}/plan.md` → Store as original_plan
   - Read `{task_folder}/review.md` → Store as original_review
   - Display task context summary
2. ELSE:
   - Skip task context loading
   - Proceed without task context

**Output Format** (if task_folder provided):

```
## Task Context Loaded

**Task**: {task_name}
**Ticket**: {brief_summary_from_ticket}
**Plan**: {brief_summary_from_plan}
**Original Review**: {brief_summary_from_review}

Using this context to inform PR comment fixes.
```

**Validation**:

- [ ] IF task_folder provided → All artifacts loaded successfully
- [ ] Task context available for reference during fixes

**Early Returns**:

- IF task_folder provided BUT folder not found → Warning: "Task folder not found, proceeding without context"
  </step>

### Step 1: Fetch PR Information

<step>
**Objective**: Retrieve PR details and review comments

**Process**:

1. Verify pr_number is provided
2. Check GitHub CLI is available: `gh --version`
3. Fetch PR information: `gh pr view {pr_number} --json title,body,state,headRefName`
4. Fetch review comments: `gh pr view {pr_number} --json reviews,comments`
5. Parse comments to extract:
   - File paths
   - Line numbers
   - Comment text
   - Reviewer name
   - Comment ID

**Validation**:

- [ ] PR exists and is accessible
- [ ] Review comments fetched successfully
- [ ] At least one actionable comment found

**Early Returns**:

- IF pr_number is empty → Error: "Please provide PR number"
- IF gh not installed → Error: "GitHub CLI not found. Install with: brew install gh"
- IF PR not found → Error: "PR #{pr_number} not found"
- IF no comments → Success: "No review comments to address"
  </step>

### Step 2: Organize and Analyze Comments

<step>
**Objective**: Categorize comments by file and priority

**Process**:

1. Group comments by file path
2. Sort by line number within each file
3. Classify comment types:
   - **Critical**: Security, bugs, breaking changes
   - **High**: Performance, architecture, maintainability
   - **Medium**: Code quality, readability, best practices
   - **Low**: Formatting, naming, documentation
4. Create task list using TodoWrite:
   - One task per file with comments
   - Mark critical/high priority items clearly
   - Include comment summary in task description

**Output Format**:

```
## PR Review Comments Summary

**PR**: #{pr_number} - {title}
**Branch**: {headRefName}
**Total Comments**: {count}

### Comments by File:

**{file_path}** ({comment_count} comments)
- Line {line}: [{priority}] {comment_preview} (@{reviewer})
- Line {line}: [{priority}] {comment_preview} (@{reviewer})

### Implementation Plan:
1. [ ] {file_path} - {comment_count} changes
2. [ ] {file_path} - {comment_count} changes
```

**Validation**:

- [ ] All comments categorized
- [ ] Priority levels assigned
- [ ] TodoWrite list created

**Early Returns**:

- IF all comments are low priority AND user prefers to skip → Ask: "All comments are minor. Proceed anyway?"
  </step>

### Step 3: Implement Changes

<step>
**Objective**: Address each comment systematically

**Process**:

1. Checkout PR branch: `git checkout {headRefName}`
2. FOR EACH file with comments:
   - Mark todo as in_progress
   - Read current file content
   - IF task_folder provided → Check original_plan for relevant implementation details
   - FOR EACH comment in file (sorted by line number):
     - Display comment context
     - Locate relevant code section
     - IF original_plan exists → Reference planned approach for this file
     - Implement requested change using Edit tool
     - IF change affects other files → Note for cross-file fixes
   - Validate changes (syntax check, run linter if available)
   - Mark todo as completed
3. Handle cross-file impacts if any

**Control Flow**:

```
FOR each file in files_affected:
  SET todo status to in_progress
  READ file content

  FOR each comment in file.comments (sorted by line_number DESC):
    DISPLAY comment text and context
    LOCATE code at line_number

    IF change is straightforward:
      APPLY fix using Edit tool
    ELSE IF change requires discussion:
      SKIP and mark for manual review
    END IF

    VALIDATE syntax
  END FOR

  SET todo status to completed
END FOR

IF cross_file_changes exist:
  APPLY cross-file fixes
END IF
```

**Validation**:

- [ ] All comments addressed or marked for manual review
- [ ] No syntax errors introduced
- [ ] Code follows existing patterns

**Early Returns**:

- IF comment is unclear → Skip and add to manual review list
- IF change conflicts with other changes → Pause and ask user
  </step>

### Step 4: Validate and Test

<step>
**Objective**: Ensure changes don't break existing functionality

**Process**:

1. Check git status for modified files
2. Run project-specific validation:
   - Linter (if configured)
   - Type checker (if TypeScript/Python typed)
   - Unit tests (if test command found)
3. Review diff of changes: `git diff`
4. IF tests fail → Analyze failures and fix
5. IF linter errors → Fix automatically or ask user

**Output Format**:

```
## Validation Results

**Modified Files**: {count}
- {file_path}
- {file_path}

**Linter**: {PASS/FAIL}
**Type Check**: {PASS/FAIL}
**Tests**: {PASS/FAIL - X passed, Y failed}

### Test Failures (if any):
- {test_name}: {error_message}
```

**Validation**:

- [ ] All automated checks pass OR failures explained
- [ ] Changes reviewed in diff
- [ ] No unintended side effects

**Early Returns**:

- IF critical test failures → Report and ask user how to proceed
  </step>

### Step 5: Update Task Review (If Task Context Provided)

<step>
**Objective**: Document PR fixes in original task artifacts

**Process**:

1. IF task_folder NOT provided → Skip this step
2. ELSE:
   - Read current `{task_folder}/review.md`
   - Append PR Fixes section:

   ```markdown
   ## PR Review Fixes

   **PR**: #{pr_number}
   **Date**: {current_date}

   ### Comments Addressed: {count}/{total}

   **Files Modified**:
   - {file_path} - {changes_summary}
   - {file_path} - {changes_summary}

   ### Review Comments:
   1. **{file}:{line}** (@{reviewer}) - {comment_preview}
      - ✅ Fixed: {fix_description}

   2. **{file}:{line}** (@{reviewer}) - {comment_preview}
      - ✅ Fixed: {fix_description}

   ### Manual Review Needed (if any):
   - {comment} - {reason}

   ### Validation:
   - Linter: {PASS/FAIL}
   - Tests: {PASS/FAIL}
   - Type Check: {PASS/FAIL}
   ```

   - Write updated content to `{task_folder}/review.md`

**Validation**:

- [ ] review.md updated successfully
- [ ] PR fixes documented with all details

**Early Returns**:

- None (this step is optional based on task_folder)
  </step>

## Report

<report>
**After completing all fixes and validation:**

Show summary:

```
## PR Comment Fixes Complete

**PR**: #{pr_number} - {title}
**Comments Addressed**: {count}/{total}
**Files Modified**: {count}

### Changes Made:
- [{file}] {changes_summary}
- [{file}] {changes_summary}

### Manual Review Needed (if any):
- {comment_preview} - {reason}

### Validation Results:
- Linter: {PASS/FAIL}
- Tests: {PASS/FAIL}
- Type Check: {PASS/FAIL}

{IF task_folder: "**Task Updated**: Circle/{task_name}/review.md"}
```

**User is responsible for**:
1. Review the changes: `git diff`
2. Commit: `git add . && git commit -m "Fix: Address PR review comments"`
3. Push: `git push`
4. Comment on PR (optional): `gh pr comment {pr_number} --body "✅ Addressed review comments"`
</report>

## Output

<output>
Final output after successful execution:

```
✅ PR Comment Fixes Ready for Review

**PR**: #{pr_number} - {title}
**Comments Addressed**: {count}/{total}

### Summary:
- Modified {file_count} files
- Fixed {comment_count} review comments
- Validation: {status}

{IF task_folder: "✅ Updated Circle/{task_name}/review.md with PR fixes summary"}

**Next Steps**:
1. Review changes: `git diff`
2. Commit and push your changes
3. Request re-review from: {reviewer_names}

{manual_review_section if applicable}
```

</output>

## Control Flow

```
START

INPUT pr_number, task_folder (optional)

IF pr_number is empty:
  ERROR "PR number required"
  EXIT
END IF

IF task_folder is provided:
  IF task_folder exists:
    LOAD ticket.md, plan.md, review.md
    DISPLAY task context summary
  ELSE:
    WARN "Task folder not found, proceeding without context"
  END IF
END IF

FETCH pr_info and comments using gh CLI

IF fetch fails:
  ERROR "Could not fetch PR"
  EXIT
END IF

IF no comments:
  SUCCESS "No comments to address"
  EXIT
END IF

ORGANIZE comments by file and priority
CREATE TodoWrite tasks

CHECKOUT pr_branch

FOR each file in files_with_comments:
  MARK todo in_progress
  READ file

  IF task_folder provided:
    REFERENCE original_plan for implementation guidance
  END IF

  FOR each comment in file.comments:
    IF comment is actionable:
      IMPLEMENT fix (using task context if available)
    ELSE:
      ADD to manual_review_list
    END IF
  END FOR

  MARK todo completed
END FOR

RUN validation (linter, tests)

IF validation fails AND not critical:
  FIX issues
ELSE IF critical failures:
  REPORT and ASK user
END IF

IF task_folder provided:
  APPEND PR fixes to task_folder/review.md
END IF

REPORT summary with next steps for user
  - All changes applied
  - Validation results
  - User must commit and push manually

END
```
