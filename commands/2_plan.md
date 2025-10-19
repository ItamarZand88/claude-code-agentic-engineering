---
description: Create detailed implementation plan with code examples
argument-hint: <task_folder_path>
model: inherit
allowed-tools: Read, Write, Glob, Grep, Bash, Task, WebSearch, WebFetch, SlashCommand
---

# Implementation Plan Generator

## Purpose

Transform ticket requirements into actionable tasks with code examples. Architectural decisions are ALREADY made in ticket - focus on detailed HOW.

## Process

### 1. Load Ticket

<example>
Read("Circle/{task-folder}/ticket.md")
</example>

Extract:

- Requirements
- **Implementation Strategy** (decided approach)
- Affected areas
- Dependencies

If ticket missing → STOP, tell user to run `/1_ticket`.

### 2. Research (if needed)

Launch only relevant research:

**For new technologies**:
<example>
WebSearch("OAuth2 best practices 2025")
WebFetch("https://oauth.net/2/")
</example>

**For codebase patterns**:
<example>
Task(feature-finder, "Find similar auth implementations")
Task(codebase-analyst, "Extract error handling patterns")
</example>

**For library usage**:
<example>
Context7_resolve-library-id("next-auth")
Context7_get-library-docs("/nextauthjs/next-auth")
</example>

### 3. Create Tasks

Break into phases with detailed tasks:

**Phase 1: Foundation**

- Setup, dependencies, config

**Phase 2: Core**

- Main features and logic

**Phase 3: Integration**

- Connect to existing systems

**Phase 4: Validation**

- Tests and quality checks

**Phase 5: Documentation**

- Comments and guides

For each task include:

- Description
- Files to create/modify
- **Code example**
- Dependencies
- Validation command
- Effort (S/M/L/XL)

<example>
**Task 2.1**: Create OAuth Config

Files:

- CREATE: `src/config/oauth.ts`

Code:

```typescript
export const oauthConfig = {
  clientId: process.env.OAUTH_CLIENT_ID,
  secret: process.env.OAUTH_SECRET,
};
```

Dependencies: Task 1.1 (env setup)
Validation: `npm run typecheck`
Effort: S (15min)
</example>

### 4. Generate Plan

Save to `Circle/{task-folder}/plan.md`:

```markdown
# Implementation Plan

**Task**: {name}
**Date**: {date}

## Strategy (from ticket)

{implementation_strategy_from_ticket}

## Research Summary

- {finding_1}
- {finding_2}

## Phase 1: Foundation

### Task 1.1: {title}

{details with code example}

## Phase 2: Core

...

## Dependencies

- {library}: `npm install {library}`

## Risks

- {risk}: {mitigation}

## Next

`/3_implement Circle/{task-folder}`
```

### 5. Report

```
✅ Plan: Circle/{task-folder}/plan.md

Phases: {N}
Tasks: {M}

Ready to implement? (I'll run /3_implement)
```

If confirmed → run `/3_implement @Circle/{task-folder}`
