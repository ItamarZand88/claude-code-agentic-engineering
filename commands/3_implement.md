---
description: Executes implementation plan step-by-step with comprehensive tracking
argument-hint: <task_folder_path>
model: inherit
---

# Plan Implementation Executor

<instruction>
**IMPORTANT**: Execute implementation plans step-by-step with comprehensive tracking, testing, and error handling.

**YOU MUST** validate git status before starting and use TodoWrite to track progress throughout implementation.

Think step by step through each implementation phase before proceeding.
</instruction>

## Variables
- **task_folder_path**: $ARGUMENTS - Path to the task folder (e.g., `Circle/oauth-authentication`)
- **plan_file**: `{task_folder_path}/plan.md` - Implementation plan to execute
- **ticket_file**: `{task_folder_path}/ticket.md` - Original task requirements for reference

## Workflow

<pre_flight_checks>
**CRITICAL**: Run these checks BEFORE starting implementation:

```bash
# 1. Verify git status
git status --porcelain

# 2. Check current branch
git branch --show-current

# 3. Check build works (baseline)
[run project build command if exists]
```

**If git working directory is NOT clean**:
- STOP immediately
- Show `git status` output
- Ask user: "Working directory has uncommitted changes. Commit, stash, or continue anyway?"
- Wait for user decision

**If on main/master branch**:
- Suggest creating feature branch
- Ask user for branch name or proceed
</pre_flight_checks>

<execution_phases>
### 1. **Plan Loading & Todo Setup**
- Load task folder path from $ARGUMENTS
- Read `{task_folder_path}/plan.md` and `{task_folder_path}/ticket.md`
- Parse implementation tasks
- **Create TodoWrite list** with all implementation tasks

### 2. **Environment Preparation**
- Verify prerequisites from plan
- Install dependencies if specified
- Run baseline build/compile check
- Mark environment setup as complete in TodoWrite

### 3. **Implementation Loop with code-implementer**

<implementation_delegation>
For each implementation task in plan:

1. **Mark task as in_progress** in TodoWrite
2. Display task details and objectives

3. **Delegate to code-implementer agent** (for non-trivial tasks):
```
Task (subagent_type: general-purpose):
"Use code-implementer agent to implement: {specific_task}

Context:
- Files to modify: {file_list}
- Pattern to follow: {similar_code_reference}
- Requirements: {task_requirements}

The agent will:
- Follow project patterns
- Implement incrementally with validation
- Handle errors properly
- Ensure code quality

Wait for implementation completion."
```

4. **Validate changes**:
```bash
[linting command]
[type check command]
[build command]
```

5. **Mark task as completed** in TodoWrite
6. Continue to next task
</implementation_delegation>

**Note**: For simple file edits or configuration changes, implement directly without agent delegation.

### 4. **Continuous Validation**
After each major phase:
```bash
# Run relevant validation
[linting command]
[type check command]
[build command]
```

If validation fails:
- Show error output
- Offer: retry, skip, debug, or rollback
- Wait for user decision

### 5. **Error Recovery**
<error_handling>
If any step fails:
1. Log full error with context
2. Mark task as failed (keep in_progress)
3. Offer options:
   - Retry the failed step
   - Skip and continue
   - Debug (explain what went wrong)
   - Rollback changes (`git checkout`)
4. Provide specific guidance based on error type
</error_handling>

### 6. **Final Validation & Acceptance Criteria**
- Validate all acceptance criteria from ticket.md
- Check code compiles/builds
- Run linting and type checking
- Verify no breaking changes

### 7. **Implementation Summary**
- Document what was implemented
- Note any deviations from plan
- Record issues encountered and resolutions
- Clear TodoWrite list
- Inform user: Run `/4_review {task_folder_path}` for code review
</execution_phases>

## Progress Tracking

<todo_management>
**YOU MUST** use TodoWrite throughout implementation:

```typescript
// At start
TodoWrite: [
  {task: "Install dependencies", status: "pending"},
  {task: "Create user model", status: "pending"},
  {task: "Implement auth service", status: "pending"},
  {task: "Add tests", status: "pending"},
  {task: "Run validation", status: "pending"}
]

// During execution - mark current task
TodoWrite: [
  {task: "Install dependencies", status: "completed"},
  {task: "Create user model", status: "in_progress"},  // Currently working
  ...
]

// Mark completed IMMEDIATELY after finishing each task
TodoWrite: [
  {task: "Install dependencies", status: "completed"},
  {task: "Create user model", status: "completed"},  // Just finished
  {task: "Implement auth service", status: "in_progress"},  // Now working
  ...
]
```

**Rules**:
- ONE task "in_progress" at a time
- Mark completed IMMEDIATELY after finishing
- Update after every significant change
</todo_management>

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
  - Next steps: Run `/4_review @{task_folder_path}` for code review

## Task Folder Structure After Implementation

```
Circle/{task-name}/
├── ticket.md (task requirements)
├── plan.md (implementation plan)
└── review.md (to be created by command 4)
```
