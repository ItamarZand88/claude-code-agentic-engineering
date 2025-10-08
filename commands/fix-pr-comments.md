---
description: Fetches PR review comments and implements requested changes
argument-hint: <pr_number>
model: inherit
allowed-tools: Read, Write, Edit, Glob, Grep, Bash, Task, TodoWrite
---

# Fix PR Comments

## Instructions

<instructions>
**Purpose**: Fetch review comments from a GitHub Pull Request and implement all requested changes.

**Core Principles**:

- Fetch and parse all PR review comments
- Organize comments by file and priority
- Implement changes systematically
- Validate each fix before moving to next
- Commit changes with references to review comments

**Success Criteria**:

- All actionable review comments addressed
- Changes follow existing code patterns
- Tests pass after fixes
- Clear commit messages referencing comments
  </instructions>

## Variables

### Dynamic Variables (User Input)

- **pr_number**: `$ARGUMENTS` - The PR number to fetch comments from

### Static Variables (Configuration)

- **GITHUB_CLI**: `gh` - GitHub CLI tool for API access

### Derived Variables (Computed During Execution)

- **pr_url**: Constructed from pr_number
- **comments_list**: Fetched review comments
- **files_affected**: List of files with comments
- **current_branch**: Git branch name

## Workflow

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
   - FOR EACH comment in file (sorted by line number):
     - Display comment context
     - Locate relevant code section
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

### Step 5: Commit and Push Changes

<step>
**Objective**: Commit fixes with clear references to review comments

**Process**:

1. Stage all changes: `git add .`
2. Generate commit message:

   ```
   Fix: Address PR review comments

   Implemented changes requested in PR #{pr_number}:
   - [{file}] {brief_description} (@{reviewer})
   - [{file}] {brief_description} (@{reviewer})

   Resolves review comments: {comment_ids}

   ```

3. Create commit with heredoc format
4. Push to remote: `git push`
5. Add comment to PR: `gh pr comment {pr_number} --body "✅ Addressed review comments in commit {sha}"`

**Validation**:

- [ ] Commit created successfully
- [ ] Pushed to remote
- [ ] PR comment added

**Early Returns**:

- IF push fails → Check if branch protection requires review
  </step>

## Report

<report>
**After displaying validation results and before committing:**

Show summary:

```
## PR Comment Fixes Complete

**PR**: #{pr_number}
**Comments Addressed**: {count}/{total}
**Files Modified**: {count}

### Changes Made:
- [{file}] {changes_summary}
- [{file}] {changes_summary}

### Manual Review Needed (if any):
- {comment_preview} - {reason}

**Next Steps**:
1. Review the changes in git diff
2. Commit and push to PR branch
3. Request re-review from reviewers
```

**Then ask user**: "Would you like me to commit and push these changes to the PR?"

**IF user confirms** → Execute Step 5 (commit and push)
**ELSE** → End with message: "Changes ready for review. You can commit manually when ready."
</report>

## Output

<output>
Final output after successful execution:

```
✅ PR Comment Fixes Applied

**PR**: #{pr_number} - {title}
**Commit**: {commit_sha}
**Comments Addressed**: {count}/{total}

### Summary:
- Modified {file_count} files
- Fixed {comment_count} review comments
- All tests passing ✓

**Next Steps**:
1. Verify changes in GitHub: {pr_url}
2. Request re-review from: {reviewer_names}
3. Monitor PR checks and CI/CD

{manual_review_section if applicable}
```

</output>

## Control Flow

```
START

INPUT pr_number

IF pr_number is empty:
  ERROR "PR number required"
  EXIT
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

  FOR each comment in file.comments:
    IF comment is actionable:
      IMPLEMENT fix
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

ASK user to confirm commit

IF user confirms:
  COMMIT with references
  PUSH to remote
  COMMENT on PR
  REPORT success
ELSE:
  REPORT "Changes ready for manual commit"
END IF

END
```
