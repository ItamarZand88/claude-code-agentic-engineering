---
description: Create comprehensive task ticket with codebase analysis and clarifying questions
argument-hint: <task_description> [--continue=plan|implement|review|all]
---

# Task Ticket Generator

You are helping create a comprehensive task ticket that defines WHAT needs to be built. Follow a systematic approach: understand the request, explore the codebase, ask clarifying questions, then document everything.

## Core Principles

- **Ask clarifying questions**: Identify ambiguities and underspecified details. Ask specific questions rather than making assumptions. Wait for answers before finalizing the ticket.
- **Understand before documenting**: Read and comprehend existing code patterns first
- **Read files identified by agents**: When launching agents, ask them to return lists of key files. After agents complete, read those files to build context.
- **Use TodoWrite**: Track all progress throughout

---

## Phase 1: Discovery

**Goal**: Understand what needs to be built

Initial request: $ARGUMENTS

**Actions**:
1. Create todo list with all phases
2. Load best practices if they exist:
   ```
   Glob(".claude/best-practices/*.md")
   Read(".claude/best-practices/README.md")
   ```
3. Analyze the request to identify:
   - Task type (feature/bugfix/refactor/documentation)
   - Core requirements
   - Mentioned technologies
   - Unclear areas (flag for clarification)
4. If requirements are completely unclear, ask user for clarification and STOP

---

## Phase 2: Codebase Exploration

**Goal**: Understand relevant existing code and patterns

**Actions**:
1. Launch 2-3 code-explorer agents in parallel. Each agent should:
   - Trace through code comprehensively
   - Focus on architecture, abstractions, and control flow
   - Target different aspects (similar features, architecture, integrations)
   - Include a list of 5-10 key files to read

   **Example agent prompts**:
   - "Find features similar to [feature] and trace their implementation comprehensively"
   - "Map the architecture and abstractions for [feature area]"
   - "Analyze integration points and dependencies for [feature]"

2. Once agents return, read all files they identified
3. Summarize findings: patterns discovered, conventions, relevant code locations

---

## Phase 3: Clarifying Questions

**Goal**: Fill in gaps and resolve ambiguities before documenting

**CRITICAL**: This is one of the most important phases. DO NOT SKIP.

**Actions**:
1. Review codebase findings and original request
2. Identify underspecified aspects:
   - Edge cases and error handling
   - Integration points and scope boundaries
   - Design preferences and constraints
   - Performance and security needs
3. **Present all questions to user in a clear, organized list**
4. **Wait for answers before proceeding**

If user says "whatever you think is best", provide your recommendation and get explicit confirmation.

---

## Phase 4: Architecture Decision (if needed)

**Goal**: Evaluate implementation approaches for complex tasks

**Actions**:
1. For complex tasks with multiple viable approaches, launch 1-2 code-architect agents:
   - "Evaluate implementation approaches for [task]: list 2-3 options with trade-offs"
   - Focus on: minimal changes vs clean architecture vs pragmatic balance

2. Present options to user:
   ```
   I've analyzed approaches for {task}:

   Option 1: {name}
   - Pros: {benefits}
   - Cons: {drawbacks}

   Option 2: {name}
   - Pros: {benefits}
   - Cons: {drawbacks}

   Recommendation: {choice} because {reason}

   Which approach would you like?
   ```

3. **Wait for user decision before proceeding**

For simple tasks, skip this phase.

---

## Phase 5: Generate Ticket

**Goal**: Document everything in a comprehensive ticket

**Actions**:
1. Create task folder: `.claude/tasks/{task-name}/`
2. Generate kebab-case folder name from task description
3. Save ticket to `.claude/tasks/{task-name}/ticket.md`:

```markdown
# {Task Title}

**Date**: {date}
**Type**: feature|bugfix|refactor|documentation
**Status**: ready-for-planning

## Description

{3-4 sentences on WHAT and WHY}

## Context

{Existing implementation, patterns discovered from exploration}

## Similar Implementations

{From code-explorer findings:
- **Location**: {file_path}:{line}
- **Pattern**: {how it works}
- **Follow**: {naming, structure, error handling patterns}}

## Best Practices (if exist)

{Key guidelines from .claude/best-practices/ relevant to this task}

## Implementation Strategy (if architectural decision made)

- **Approach**: {chosen_approach}
- **Rationale**: {why}
- **Key Decisions**: {important_choices}

## Requirements

**Functional**:
- [ ] {requirement_1}
- [ ] {requirement_2}

**Non-Functional**:
- [ ] {performance/security requirements}

## Affected Areas

- {files to modify/create}

## Acceptance Criteria

- [ ] {criterion_1}
- [ ] {criterion_2}

## Risks

- {risk} - {mitigation}

## Next

`/2_plan .claude/tasks/{task-name}`
```

---

## Phase 6: Summary

**Goal**: Report and optionally continue

**Actions**:
1. Mark all todos complete
2. Show summary:
   ```
   Ticket: .claude/tasks/{task-name}/ticket.md

   Summary: {brief description}

   Key Findings:
   - {finding_1}
   - {finding_2}
   ```

3. Handle `--continue` flag in `$ARGUMENTS`:
   - `--continue=plan` → run `/2_plan .claude/tasks/{task-name}`
   - `--continue=implement` → run `/2_plan .claude/tasks/{task-name} --continue=implement`
   - `--continue=review` or `--continue=all` → run `/2_plan .claude/tasks/{task-name} --continue=review`
   - No flag → ask user if ready for planning
