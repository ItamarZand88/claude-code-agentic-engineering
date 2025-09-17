---
description: Executes implementation plan with safety checks and progress tracking
model: claude-sonnet-4
allowed-tools: read, write, bash, search
argument-hint: <plan_file_path> [--dry-run] [--step=N]
---

# Plan Implementation Executor

Execute the implementation plan step-by-step with safety checks, progress tracking, testing validation, and rollback capabilities.

## Variables
- **plan_file_path**: $1 - Path to the implementation plan file
- **dry_run_mode**: $2 - If --dry-run, show what would be done without making changes  
- **target_step**: $3 - If --step=N specified, execute only that step number
- **backup_branch**: `implementation-$(date +%Y%m%d-%H%M%S)` - Git branch for safe implementation
- **progress_log**: `./logs/implementation-progress.md` - Implementation progress tracking

## Workflow
1. **Pre-Implementation Safety**
   - Verify git working directory is clean
   - Create backup branch: `git checkout -b implementation-$(date +%Y%m%d-%H%M%S)`
   - Load and validate the implementation plan file: $1
   - If plan file missing, stop and request user to run `/plan-from-task`

2. **Environment Preparation**
   - Verify all prerequisites from the plan are met
   - Install any required dependencies
   - Set up development environment as specified
   - Run initial tests to establish baseline

3. **Implementation Execution Loop**
   - **For each step in the implementation plan:**
     - Display current step details and objectives
     - If $2 equals "--dry-run", show planned changes without executing
     - Execute file modifications as specified
     - Run any specified commands or scripts
     - Validate step completion criteria
     - Update progress log with status

4. **Continuous Validation**
   - After each major step, run relevant tests
   - Check that application still builds/compiles
   - Verify no breaking changes to existing functionality
   - If validation fails, offer rollback or debugging options

5. **Error Handling and Recovery**
   - **If** any step fails:
     - Log the error with full context
     - Offer options: retry, skip, rollback, or debug
     - Provide specific guidance based on error type
   - **If** user chooses rollback:
     - Return to backup branch: `git checkout main && git branch -D {backup_branch}`
     - Restore original state completely

6. **Testing Integration**
   - Run unit tests after code modifications
   - Execute integration tests for affected components
   - Perform manual testing as specified in plan
   - Validate all acceptance criteria from original task

7. **Completion and Integration**
   - Run final comprehensive test suite
   - Generate implementation summary report
   - Create clean commit with descriptive message
   - Merge implementation branch or prepare PR

## Instructions
- Always prioritize safety - make backups before any destructive operations
- Validate each step before proceeding to the next
- Provide clear feedback on progress and any issues encountered
- Give user control over how to handle errors and failures
- Maintain detailed logs of all actions taken

## Control Flow
- **If** $2 equals "--dry-run":
  - Show all planned actions without executing them
  - Allow user to review before actual implementation
- **If** $3 contains "--step=":
  - Extract step number and execute only that specific step
  - Show dependencies and prerequisites for the step
- **If** git working directory is not clean:
  - Stop and ask user to commit or stash changes first
- **If** any test fails during implementation:
  - Pause execution and ask user how to proceed

## Report
Provide real-time progress updates including:
- **Current Step**: Which step is being executed
- **Progress**: X of Y steps completed
- **Status**: Success/Warning/Error for each step
- **Test Results**: Pass/fail status of validations
- **Final Summary**: Complete implementation report with:
  - Files modified
  - Tests run and results
  - Any issues encountered and resolutions
  - Next steps or recommendations
