---
description: Complete end-to-end workflow from task description to implementation and review
argument-hint: <task_description>
---

# Complete Workflow Executor

You are running the complete 4-step workflow automatically: ticket → plan → implement → review. This is the fully automated path with minimal user interaction.

## Core Principles

- **Automatic progression**: Move through all steps without waiting for user approval
- **Use --continue flags**: Chain commands automatically
- **Report between steps**: Show brief progress updates
- **Use TodoWrite**: Track overall workflow progress

---

## Phase 1: Initialize

**Goal**: Set up the complete workflow

Input: $ARGUMENTS (task description)

**Actions**:
1. Create todo list with all 4 major steps
2. Validate task description is provided
3. If task description empty, ask user and STOP

---

## Phase 2: Execute Workflow

**Goal**: Run all 4 steps automatically

**Actions**:
1. **Create Ticket** (auto-continue to review):
   ```
   /1_ticket {task_description} --continue=review
   ```

   This will automatically chain:
   - `/1_ticket` → creates ticket
   - `/2_plan` → creates implementation plan
   - `/3_implement` → executes the plan
   - `/4_review` → reviews the code

2. Monitor progress and update TodoWrite as each step completes

---

## Phase 3: Summary

**Goal**: Report complete workflow results

**Actions**:
1. Mark all todos complete
2. Show comprehensive summary:
   ```
   Complete Workflow Finished: .claude/tasks/{task-folder}

   Steps Completed:
   ✓ Ticket created
   ✓ Plan generated
   ✓ Implementation executed
   ✓ Code reviewed

   Task: {brief_description}

   Files Modified:
   - {file}: {change}
   - {file}: {change}

   Review Status: {pass|warning|fail}
   Quality Score: {score}/10
   Issues: {count} (if any)

   Artifacts:
   - .claude/tasks/{task-folder}/ticket.md
   - .claude/tasks/{task-folder}/plan.md
   - .claude/tasks/{task-folder}/review.md
   ```

3. If review found critical issues, offer to fix them
