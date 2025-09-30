---
description: Executes implementation plan step-by-step with comprehensive tracking and testing
model: claude-sonnet-4
allowed-tools: read, write, bash, search
argument-hint: <plan_file_path>
---

# Plan Implementation Executor

Execute implementation plans step-by-step with comprehensive tracking, testing, and error handling.

## Variables
- **task_folder_path**: $ARGUMENTS - Path to the task folder (e.g., `Circle/oauth-authentication`)
- **plan_file**: `{task_folder_path}/plan.md` - Implementation plan to execute
- **ticket_file**: `{task_folder_path}/ticket.md` - Original task requirements for reference

## Workflow
1. **Plan Loading & Pre-Implementation Setup**
   <thinking>
   - Load task folder path from $ARGUMENTS
   - Read plan file: `{task_folder_path}/plan.md`
   - Reference ticket file: `{task_folder_path}/ticket.md` for acceptance criteria
   - Parse implementation steps and requirements
   - Verify git working directory is clean
   </thinking>

2. **Environment Preparation**
   - Verify all prerequisites from the plan are met
   - Install any required dependencies
   - Set up development environment as specified
   - Run initial tests to establish baseline

3. **Implementation Execution Loop**
   - **For each step in the implementation plan:**
     - Display current step details and objectives
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
     - Offer options: retry, skip, or debug
     - Provide specific guidance based on error type

6. **Testing Integration**
   - Run unit tests after code modifications
   - Execute integration tests for affected components
   - Perform manual testing as specified in plan
   - Validate all acceptance criteria from original task

7. **Completion and Integration**
   - Run final comprehensive test suite
   - Create clean commit with descriptive message
   - Merge implementation branch or prepare PR

8. **Implementation Summary**
   <thinking>
   - Document what was implemented
   - Note any deviations from the plan
   - Record any issues encountered and resolved
   - Inform user that task is ready for `/4_review_implementation`
   </thinking>

## Instructions
- Validate each step before proceeding to the next
- Provide clear feedback on progress and any issues encountered
- Give user control over how to handle errors and failures
- Maintain detailed logs of all actions taken

## Control Flow
- **If** git working directory is not clean:
  - Stop and ask user to commit or stash changes first
- **If** any test fails during implementation:
  - Pause execution and ask user how to proceed
- **Standard execution**:
  - Execute all steps sequentially with validation
  - Track progress throughout

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
  - Next steps: Run `/4_review_implementation {task_folder_path}` for code review

## Task Folder Structure After Implementation

```
Circle/{task-name}/
├── ticket.md (task requirements)
├── plan.md (implementation plan)
└── review.md (to be created by command 4)
```
