---
description: Complete end-to-end workflow from task description to implementation and review
argument-hint: <task_description>
model: inherit
allowed-tools: Read, Write, Edit, Glob, Grep, Bash, Task, TodoWrite, WebSearch, WebFetch, SlashCommand
---

# Complete Workflow Executor

## Purpose

Execute the complete 4-step workflow automatically: ticket → plan → implement → review. No user interaction needed between steps.

## Process

### 1. Create Ticket

<example>
SlashCommand("/1_ticket {task_description}")
</example>

Wait for completion, then automatically proceed to planning.

### 2. Create Plan

<example>
SlashCommand("/2_plan Circle/{task-folder}")
</example>

Wait for completion, then automatically proceed to implementation.

### 3. Implement

<example>
SlashCommand("/3_implement Circle/{task-folder}")
</example>

Wait for completion, then automatically proceed to review.

### 4. Review

<example>
SlashCommand("/4_review Circle/{task-folder}")
</example>

Wait for completion, then show final summary.

## Report

```
✅ Complete Workflow Finished: Circle/{task-folder}

All Steps Completed:
- ✅ Ticket created
- ✅ Plan generated
- ✅ Implementation executed
- ✅ Code reviewed

Task Summary: {brief_description}

Files Created/Modified:
- {file1} - {what_changed}
- {file2} - {what_changed}

Quality Score: {score}/10
Issues Found: {count}

Ready for production!
```

## Guidelines

- **NO user interaction** - run all steps automatically
- Use SlashCommand to execute each step
- Wait for each step to complete before proceeding
- Show progress between steps
- Provide comprehensive final summary
