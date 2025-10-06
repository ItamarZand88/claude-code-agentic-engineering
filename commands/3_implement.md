---
description: Executes implementation plan step-by-step with comprehensive tracking
argument-hint: <task_folder_path>
model: inherit
allowed-tools: [Read, Write, Edit, Glob, Grep, Bash, Task, TodoWrite]
---

# Plan Implementation Executor

## Instructions

<instructions>
**Purpose**: Execute implementation plan step-by-step with comprehensive tracking and validation.

**Core Principles**:
- Validate git status before starting (clean working directory)
- Use TodoWrite to track progress throughout
- Delegate non-trivial implementation to code-implementer agent
- Validate after each phase (linting, type-check, build)
- Handle errors gracefully with recovery options

**Key Expectations**:
- Clean git status before starting
- Real-time progress tracking via TodoWrite
- Incremental validation at each phase
- Error recovery mechanisms
- Final validation against acceptance criteria
</instructions>

## Variables

### Dynamic Variables (User Input)
- **task_folder_path**: `$ARGUMENTS` - Path to task folder (e.g., `Circle/oauth-authentication`)

### Static Variables (Configuration)
- **PLAN_FILENAME**: `plan.md` - Standard plan filename
- **TICKET_FILENAME**: `ticket.md` - Standard ticket filename

### Derived Variables (Computed During Execution)
- **plan_path**: `{task_folder_path}/plan.md` - Full path to plan
- **ticket_path**: `{task_folder_path}/ticket.md` - Full path to ticket

## Workflow

### Step 1: Pre-flight Checks

<step>
**Objective**: Validate environment before starting implementation

**Process**:

Run these checks in parallel:
```bash
git status --porcelain           # Check working directory
git branch --show-current        # Check current branch
[project build command]          # Verify baseline build works
```

**Decision Logic**:

**IF git working directory is NOT clean**:
- Display `git status` output
- Ask user: "Working directory has uncommitted changes. Options: (1) Commit, (2) Stash, (3) Continue anyway"
- STOP and wait for user decision

**IF on main/master branch**:
- Suggest creating feature branch
- Ask user: "You're on main/master. Create feature branch? (yes/no/branch-name)"
- Wait for user decision

**IF baseline build fails**:
- Display build errors
- STOP and inform user to fix build first

**Validation**:
- ✅ Git working directory is clean (or user approved)
- ✅ On appropriate branch (or user approved)
- ✅ Baseline build passes

**Early Return**: If critical blocker found and user doesn't approve → STOP
</step>

### Step 2: Plan Loading & Todo Setup

<step>
**Objective**: Load plan and set up progress tracking

**Process**:
1. Parse `$ARGUMENTS` to get task folder path
2. Read `{task_folder_path}/plan.md` and `{task_folder_path}/ticket.md`
3. Extract implementation tasks from plan
4. Create TodoWrite list with all tasks

**Validation**:
- ✅ Plan file exists and is readable
- ✅ Ticket file exists for reference
- ✅ Tasks extracted successfully
- ✅ TodoWrite list created

**Early Return**: If plan file missing → STOP and inform user to run `/2_plan` first
</step>

### Step 3: Environment Preparation

<step>
**Objective**: Prepare environment for implementation

**Process**:
1. Verify prerequisites from plan
2. IF dependencies needed → Install them
3. Run baseline build/compile check
4. Mark environment setup as complete in TodoWrite

**Validation**:
- ✅ All prerequisites met
- ✅ Dependencies installed
- ✅ Build passes
</step>

### Step 4: Implementation Loop

<step>
**Objective**: Execute each task from plan

**Process** - FOR EACH task in plan:

1. **Mark task as in_progress** in TodoWrite (exactly ONE task in_progress at a time)
2. Display task details and objectives

3. **Execute task**:
   - IF task is non-trivial (complex logic, multiple files) → Delegate to code-implementer agent
   - ELSE (simple config, single file edit) → Implement directly

   **For agent delegation**:
   ```
   Use code-implementer agent to implement: {specific_task}

   Context:
   - Files to modify: {file_list}
   - Pattern to follow: {similar_code_reference}
   - Requirements: {task_requirements}
   ```

4. **Validate changes**:
   ```bash
   [linting command]
   [type check command]
   [build command]
   ```

5. **IF validation fails**:
   - Show error output
   - Offer options: (1) Retry, (2) Skip, (3) Debug, (4) Rollback
   - Wait for user decision

6. **Mark task as completed** in TodoWrite
7. Continue to next task

**Validation**:
- ✅ Each task validated before marking complete
- ✅ Only ONE task in_progress at a time
- ✅ No validation failures unresolved
</step>

### Step 5: Final Validation

<step>
**Objective**: Validate complete implementation against acceptance criteria

**Process**:
1. Read acceptance criteria from ticket.md
2. Validate each criterion
3. Run full test suite (if exists)
4. Run linting and type checking
5. Verify no breaking changes

**Validation**:
- ✅ All acceptance criteria met
- ✅ Code compiles/builds
- ✅ Tests pass
- ✅ No breaking changes
</step>

### Step 6: Implementation Summary & Next Steps

<step>
**Objective**: Summarize implementation and prepare for review

**Process**:
1. Document what was implemented
2. Note any deviations from plan
3. Record issues encountered and resolutions
4. Clear TodoWrite list
5. Ask user if ready for code review

**Validation**:
- ✅ Summary complete
- ✅ TodoWrite cleared
- ✅ User informed of next step
</step>

## Progress Tracking

Use TodoWrite: ONE task "in_progress" at a time, mark completed IMMEDIATELY

## Control Flow

<control_flow>
**Execution Pattern**: Sequential with Error Handling and Loops

**Flow Logic**:

1. **Pre-flight checks**
   - Run git status, branch check, baseline build in parallel
   - IF git not clean → Ask user for action (commit/stash/continue)
   - IF on main/master → Ask user about feature branch
   - IF build fails → STOP and inform user
   - ELSE → Continue

2. **Load plan and setup**
   - Parse `$ARGUMENTS` for task folder
   - IF plan missing → STOP and inform to run `/2_plan`
   - Read plan.md and ticket.md
   - Create TodoWrite list with all tasks

3. **Environment preparation**
   - Verify prerequisites
   - Install dependencies if needed
   - Mark setup complete in TodoWrite

4. **Implementation loop** - FOR EACH task in plan:
   - Mark task as in_progress in TodoWrite
   - IF task is non-trivial → Delegate to code-implementer agent
   - ELSE → Implement directly
   - Validate changes (lint, type-check, build)
   - IF validation fails → Offer retry/skip/debug/rollback options
   - Mark task as completed in TodoWrite
   - Continue to next task

5. **Final validation**
   - Read acceptance criteria from ticket
   - Validate each criterion
   - Run full test suite
   - Verify no breaking changes

6. **Summary and next steps**
   - Document implementation
   - Note deviations and issues
   - Clear TodoWrite
   - Ask user if ready for code review

**Critical Decision Points**:
- ✅ Before start: Git clean and build passes?
- ✅ Before loop: Plan loaded successfully?
- ✅ After each task: Validation passes?
- ✅ After all tasks: Acceptance criteria met?
- ✅ After completion: Proceed to /4_review?
</control_flow>

## Report

<report>
**Format**: Real-time progress updates + Final summary

**During Execution** (continuous updates):
- Current Step: {step name}
- Progress: {X} of {Y} tasks completed
- Status: Success | Warning | Error
- Test Results: Pass/Fail for validations

**Final Summary**:
```
✅ Implementation completed: {task_folder_path}

Implementation Summary:
- {N} tasks completed
- {M} files modified
- All tests passing
- Build successful

Files Modified:
- path/to/file1.ext - {what changed}
- path/to/file2.ext - {what changed}

Issues Encountered:
- {Issue 1} - {Resolution}
- {Issue 2} - {Resolution}

Task Folder Structure:
Circle/{task-name}/
├── ticket.md (task requirements) ✅
├── plan.md (implementation plan) ✅
└── review.md (to be created next)

Next Step:
Ready for code review?
```

**After displaying summary:**

1. Ask user: "Would you like me to proceed with code review?"
2. IF user confirms (yes/proceed/continue) → Use SlashCommand tool to run: `/4_review @Circle/{task-folder-name}`
3. ELSE → Stop and wait for user instructions
</report>
