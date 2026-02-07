---
description: Execute implementation plan step-by-step with validation
argument-hint: <task_folder_path> [--continue=review|all]
---

# Plan Executor

You are implementing the feature by executing the plan step-by-step. Follow the plan closely, validate after each task, and track progress throughout.

## Core Principles

- **Follow the plan**: The plan has been approved - execute it faithfully
- **Validate continuously**: Run checks after each task to catch issues early
- **Use AskUserQuestion for decisions**: When presenting options or asking for user input, use the AskUserQuestion tool with clear options (2-4 choices). Format: `{"questions": [{"question": "...", "header": "...", "multiSelect": false, "options": [...]}]}`
- **Read before writing**: Always read existing files before modifying them
- **Use TodoWrite**: Track every task's progress in real-time
- **Ask when blocked**: If something doesn't work as planned, ask user before improvising

---

## Phase 1: Pre-flight Checks

**Goal**: Ensure clean starting state

Input: $ARGUMENTS (task folder path)

**Actions**:
1. Check git status:
   ```
   git status --porcelain
   git branch --show-current
   ```

2. **Handle issues using AskUserQuestion**:

   If working directory not clean, ask:
   ```json
   {
     "questions": [
       {
         "question": "Working directory has uncommitted changes. What would you like to do?",
         "header": "Git status",
         "multiSelect": false,
         "options": [
           {
             "label": "Commit changes",
             "description": "Create a commit with current changes before proceeding"
           },
           {
             "label": "Stash changes",
             "description": "Temporarily stash changes and restore later"
           },
           {
             "label": "Continue anyway",
             "description": "Proceed with implementation despite uncommitted changes"
           }
         ]
       }
     ]
   }
   ```

   If on main branch, ask:
   ```json
   {
     "questions": [
       {
         "question": "You're on the main branch. Create a feature branch?",
         "header": "Branch",
         "multiSelect": false,
         "options": [
           {
             "label": "Create feature branch (Recommended)",
             "description": "Create and switch to a new feature branch"
           },
           {
             "label": "Stay on main",
             "description": "Continue implementing on main branch"
           }
         ]
       }
     ]
   }
   ```

3. Run quality checks to establish baseline:
   ```
   /checks
   ```
   If checks fail on existing code, note it but continue.

---

## Phase 2: Load Plan

**Goal**: Understand what needs to be built

**Actions**:
1. Read ticket and plan:
   ```
   Read(".claude/tasks/{task-folder}/ticket.md")
   Read(".claude/tasks/{task-folder}/plan.md")
   ```

2. Extract all tasks from plan
3. Create TodoWrite list with every task from the plan

If plan is missing, STOP and tell user to run `/2_plan`.

---

## Phase 3: Execute Tasks

**Goal**: Implement each task from the plan

**For each task in order**:

1. **Mark in progress**:
   ```
   TodoWrite - mark task as in_progress
   ```

2. **Read relevant files**:
   - Read files that will be modified
   - Read similar implementations mentioned in ticket
   - Understand existing patterns before writing

3. **Implement**:
   - Follow the code example from plan
   - Match existing codebase conventions
   - Handle errors explicitly

4. **Validate**:
   ```
   /checks
   ```
   Or run the specific validation command from the task.

5. **Handle failures using AskUserQuestion**:
   If validation fails, use:
   ```json
   {
     "questions": [
       {
         "question": "Validation failed. How should we proceed?",
         "header": "Fix issue",
         "multiSelect": false,
         "options": [
           {
             "label": "Fix and retry (Recommended)",
             "description": "Attempt to fix the validation error and try again"
           },
           {
             "label": "Debug together",
             "description": "Let's investigate the error together before fixing"
           },
           {
             "label": "Skip this task",
             "description": "Skip this task and continue with remaining tasks"
           },
           {
             "label": "Rollback changes",
             "description": "Undo changes from this task and stop"
           }
         ]
       }
     ]
   }
   ```

6. **Mark complete**:
   ```
   TodoWrite - mark task as completed
   ```

**Important**: Complete each task fully before moving to the next. Don't batch multiple tasks.

---

## Phase 4: Final Validation

**Goal**: Ensure everything works together

**Actions**:
1. Run full quality checks:
   ```
   /checks
   ```

2. Verify acceptance criteria from ticket:
   ```
   Read(".claude/tasks/{task-folder}/ticket.md")
   ```
   Go through each acceptance criterion and verify it's met.

3. If any criteria not met, identify which task needs adjustment.

---

## Phase 5: Summary

**Goal**: Report results and optionally continue

**Actions**:
1. Mark all todos complete
2. Show summary:
   ```
   Implementation complete: .claude/tasks/{task-folder}

   Tasks: {N} completed
   Files modified:
   - {file}: {what changed}
   - {file}: {what changed}

   Acceptance criteria: {X}/{Y} met
   ```

3. Handle `--continue` flag in `$ARGUMENTS`:
   - `--continue=review` or `--continue=all` → run `/agi:4_review .claude/tasks/{task-folder}`
   - **No flag** → Use AskUserQuestion to ask about code review:

   ```json
   {
     "questions": [
       {
         "question": "Implementation complete! Run code review?",
         "header": "Review",
         "multiSelect": false,
         "options": [
           {
             "label": "Yes, review now (Recommended)",
             "description": "Run comprehensive code review to check quality and compliance"
           },
           {
             "label": "Skip review",
             "description": "Skip code review for now"
           }
         ]
       }
     ]
   }
   ```

   Based on answer:
   - "Yes, review now" → run `/agi:4_review .claude/tasks/{task-folder}`
   - "Skip review" → Stop here
