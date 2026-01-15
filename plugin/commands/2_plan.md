---
description: Create detailed implementation plan with architecture design and code examples
argument-hint: <task_folder_path> [--continue=implement|review|all]
---

# Implementation Plan Generator

You are creating a detailed implementation plan that defines HOW to build the feature. The ticket already defines WHAT - focus on architecture design, research, and actionable implementation steps.

## Core Principles

- **Research before designing**: Look up best practices and patterns for the technologies involved
- **Design with confidence**: Use code-architect to make decisive architectural choices
- **Read files identified by agents**: Build deep context before designing
- **Provide code examples**: Every task should have concrete code showing what to write
- **Use TodoWrite**: Track all progress throughout

---

## Phase 1: Load Context

**Goal**: Understand the ticket requirements

Input: $ARGUMENTS (task folder path)

**Actions**:
1. Create todo list with all phases
2. Read the ticket:
   ```
   Read(".claude/tasks/{task-folder}/ticket.md")
   ```
3. Extract:
   - Requirements and acceptance criteria
   - Implementation strategy (if decided)
   - Affected areas and dependencies
   - Similar implementations to follow

If ticket is missing, STOP and tell user to run `/1_ticket`.

---

## Phase 2: Research

**Goal**: Gather best practices and patterns for the implementation

**Actions**:
1. For new technologies or unfamiliar patterns:
   ```
   WebSearch("{technology} best practices 2025")
   WebFetch("{documentation_url}")
   ```

2. For library-specific guidance:
   ```
   mcp__context7__resolve-library-id("{library_name}")
   mcp__context7__query-docs("{library_id}", "{specific question}")
   ```

3. For codebase patterns not covered in ticket:
   - Launch code-explorer agent to find additional patterns
   - Read the files it identifies

4. Summarize research findings relevant to implementation

Skip this phase for simple tasks where patterns are already clear from ticket.

---

## Phase 3: Architecture Design

**Goal**: Design the complete implementation architecture

**Actions**:
1. Launch 1-2 code-architect agents in parallel with different focuses:
   - "Design implementation for [task] following patterns from [similar implementations in ticket]"
   - "Design component architecture for [feature] with focus on [testability/performance/simplicity]"

2. Each agent should provide:
   - Component design with responsibilities
   - File paths to create/modify
   - Interfaces and data flow
   - Integration points

3. Synthesize agent outputs into a unified design
4. Present architecture summary to user for confirmation

For simple tasks, design directly without agents.

---

## Phase 4: Create Implementation Tasks

**Goal**: Break down into actionable tasks with code examples

**Actions**:
1. Organize into phases:

   **Phase 1: Foundation**
   - Setup, dependencies, configuration

   **Phase 2: Core**
   - Main features and business logic

   **Phase 3: Integration**
   - Connect to existing systems

   **Phase 4: Validation**
   - Tests and quality checks

2. For each task, include:
   - Clear description
   - Files to create/modify
   - **Concrete code example**
   - Dependencies on other tasks
   - Validation command

   Example:
   ```
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
   ```

---

## Phase 5: Generate Plan

**Goal**: Document the complete implementation plan

**Actions**:
1. Save plan to `.claude/tasks/{task-folder}/plan.md`:

```markdown
# Implementation Plan

**Task**: {name}
**Date**: {date}

## Architecture Overview

{High-level design from code-architect, component diagram if complex}

## Research Summary

- {key finding 1}
- {key finding 2}

## Phase 1: Foundation

### Task 1.1: {title}

**Files**:
- CREATE/MODIFY: `{path}`

**Code**:
```{language}
{example code}
```

**Validation**: `{command}`

### Task 1.2: ...

## Phase 2: Core

...

## Phase 3: Integration

...

## Phase 4: Validation

...

## Dependencies

- {library}: `npm install {library}`

## Risks

- {risk}: {mitigation}

## Next

`/3_implement .claude/tasks/{task-folder}`
```

---

## Phase 6: Summary

**Goal**: Report and optionally continue

**Actions**:
1. Mark all todos complete
2. Show summary:
   ```
   Plan: .claude/tasks/{task-folder}/plan.md

   Architecture: {brief description}
   Phases: {N}
   Tasks: {M}
   ```

3. Handle `--continue` flag in `$ARGUMENTS`:
   - `--continue=implement` → run `/3_implement .claude/tasks/{task-folder}`
   - `--continue=review` or `--continue=all` → run `/3_implement .claude/tasks/{task-folder} --continue=review`
   - No flag → ask user if ready to implement
