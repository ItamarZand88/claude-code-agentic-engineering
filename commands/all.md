---
description: Complete end-to-end workflow from task description to implementation and review
argument-hint: <task_description>
model: inherit
allowed-tools: Read, Write, Edit, Glob, Grep, Bash, Task, TodoWrite, WebSearch, WebFetch, SlashCommand
---

# Complete Workflow Executor

## Purpose

Execute the complete 4-step workflow automatically: ticket → plan → implement → review. No user interaction needed between steps.

Output: `🚀 Starting Complete Workflow`

## Process

Show workflow progress:
```
📋 Workflow Progress:
├─ ⚪ 1. Ticket
├─ ⚪ 2. Plan
├─ ⚪ 3. Implementation
└─ ⚪ 4. Review
```

### 1. Create Ticket

Update progress:
```
📋 Workflow Progress:
├─ 🔄 1. Ticket (in progress)
├─ ⚪ 2. Plan
├─ ⚪ 3. Implementation
└─ ⚪ 4. Review
```

<example>
SlashCommand("/1_ticket {task_description}")
</example>

Wait for completion:
```
📋 Workflow Progress:
├─ ✅ 1. Ticket (completed)
├─ 🔄 2. Plan (in progress)
├─ ⚪ 3. Implementation
└─ ⚪ 4. Review
```

Then automatically proceed to planning.

### 2. Create Plan

<example>
SlashCommand("/2_plan .claude/tasks/{task-folder}")
</example>

Wait for completion, then automatically proceed to implementation.

### 3. Implement

<example>
SlashCommand("/3_implement .claude/tasks/{task-folder}")
</example>

Wait for completion, then automatically proceed to review.

### 4. Review

<example>
SlashCommand("/4_review .claude/tasks/{task-folder}")
</example>

Wait for completion, then show final summary.

## Report

Show final summary:

```
┌─────────────────────────────────────────────┐
│ 🚀 Complete Workflow Finished               │
├─────────────────────────────────────────────┤
│ Task: {Task Title}                          │
│ Folder: .claude/tasks/{task-folder}/        │
│ Total Duration: {time}                      │
└─────────────────────────────────────────────┘

✅ All Steps Completed:
├─ ✅ 1. Ticket created ({time}s)
├─ ✅ 2. Plan generated ({time}s)
├─ ✅ 3. Implementation executed ({time}s)
└─ ✅ 4. Code reviewed ({time}s)

📁 Files Created/Modified ({N} total):
├─ {file1} (created)
├─ {file2} (modified)
└─ {file3} (modified)

📊 Final Quality Score: {score}/10
├─ Issues: {count} total ({critical}🔴 {high}🟡)
├─ Tests: {✅/❌} ({N}/{N} passing)
└─ Overall: {✅ READY|⚠️ NEEDS FIXES|❌ BLOCKED}

⏭️  Next Steps:
1. {Review issues if any|Commit and push changes|Fix blocking issues}
2. {Create PR|Deploy|Test manually}
```

## Guidelines

- **NO user interaction** - run all steps automatically
- Use SlashCommand to execute each step
- Wait for each step to complete before proceeding
- Show progress between steps
- Provide comprehensive final summary
