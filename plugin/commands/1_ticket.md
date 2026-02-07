---
description: Create comprehensive task ticket with codebase analysis and clarifying questions
argument-hint: <task_description> [--continue=plan|implement|review|all]
---

# Task Ticket Generator

You are helping create a comprehensive task ticket that defines WHAT needs to be built. Follow a systematic approach: understand the request, explore the codebase, ask clarifying questions, then document everything.

## Core Principles

- **Ask clarifying questions**: Identify ambiguities and underspecified details. Ask specific questions rather than making assumptions. Wait for answers before finalizing the ticket.
- **Use AskUserQuestion for decisions**: When presenting options or asking for user input, use the AskUserQuestion tool with clear options (2-4 choices). Format: `{"questions": [{"question": "...", "header": "...", "multiSelect": false, "options": [...]}]}`
- **Understand before documenting**: Read and comprehend existing code patterns first
- **Read files identified by agents**: When launching agents, ask them to return lists of key files. After agents complete, read those files to build context.
- **Use TodoWrite**: Track all progress throughout
- **Smart execution patterns**: Choose between single explorer, parallel subagents, or agent teams based on feature complexity

---

## Phase 0: Analyze Feature Complexity

**Goal**: Determine optimal exploration pattern based on feature scope

**Actions**:
1. Analyze initial request to identify architectural layers:
   - **Backend/API**: Server-side logic, endpoints, controllers, services
   - **Database**: Schema changes, migrations, queries, models
   - **Frontend/UI**: Components, state management, routing, forms
   - **Integration**: External APIs, auth, security, third-party services

2. **Decision Logic**:
   ```
   layers_count = count_architectural_layers(request)

   IF layers_count >= 3 OR complex_integration:
     recommend = "parallel_subagents"
     trigger_question = true
   ELSE IF layers_count >= 2:
     recommend = "single_explorer"
     trigger_question = true  # Give option for parallel
   ELSE:
     recommend = "single_explorer"
     trigger_question = false  # Just proceed
   ```

3. **If question triggered**, use AskUserQuestion (see Phase 2 for options)

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

**Goal**: Understand relevant existing code and patterns using optimal execution pattern

### Option A: Single Explorer (DEFAULT for 1-2 layers)

**When**: Simple single-layer features, quick analysis, budget-sensitive

**Actions**:
1. Launch single code-explorer agent:
   ```
   Task(code-explorer, "Analyze codebase for {feature_description}

   Research:
   1. Find similar features and trace their implementation comprehensively
   2. Map relevant architecture and abstractions
   3. Identify integration points and dependencies
   4. Document patterns, conventions, and design decisions

   Provide:
   - List of 5-10 key files to read (with file paths)
   - Summary of patterns discovered
   - Recommendations for implementation approach")
   ```

2. Once agent returns, read all files it identified
3. Summarize findings

---

### Option B: Parallel Subagents (RECOMMENDED for 3+ layers) ⭐

**When**: Multi-layer features (backend + database + frontend), complex integrations

**Recommendation to User** (use AskUserQuestion):
```json
{
  "questions": [{
    "question": "This feature spans backend, database, and frontend layers. How should we analyze it?",
    "header": "Analysis",
    "multiSelect": false,
    "options": [
      {
        "label": "Parallel explorers (Recommended)",
        "description": "3-4 specialized subagents explore each layer in parallel (backend, database, frontend). Much faster comprehensive analysis. ~50K tokens."
      },
      {
        "label": "Single explorer",
        "description": "One code-explorer analyzes all layers sequentially. Slower but lower cost (~10K tokens) and simpler."
      },
      {
        "label": "Agent team analysis",
        "description": "Teammates with inter-agent communication. RARELY needed for ticket phase - use only if explorers should debate findings. ~70K tokens."
      },
      {
        "label": "Quick analysis",
        "description": "Basic codebase search without deep tracing. Fast but may miss important context."
      }
    ]
  }]
}
```

**If Parallel Subagents chosen**:

1. Launch 3-4 specialized explorers in parallel (in SINGLE message with multiple Task calls):

   **Backend/API Explorer**:
   ```
   Task(code-explorer, "Explore BACKEND/API layer for {feature_description}

   Focus on:
   - API endpoints, routes, controllers
   - Services and business logic
   - Middleware and authentication
   - Similar feature implementations

   Trace execution paths comprehensively.

   Provide:
   - List of 5-10 key backend files (with file paths)
   - API patterns and conventions discovered
   - Recommendations for backend implementation")
   ```

   **Database Explorer**:
   ```
   Task(code-explorer, "Explore DATABASE layer for {feature_description}

   Focus on:
   - Schema design and migrations
   - ORM models and relationships
   - Query patterns and data access
   - Similar data structures

   Trace data flow comprehensively.

   Provide:
   - List of 5-10 key database files (with file paths)
   - Database patterns and conventions discovered
   - Recommendations for database implementation")
   ```

   **Frontend/UI Explorer**:
   ```
   Task(code-explorer, "Explore FRONTEND/UI layer for {feature_description}

   Focus on:
   - UI components and layouts
   - State management patterns
   - Routing and navigation
   - Similar UI features

   Trace component composition comprehensively.

   Provide:
   - List of 5-10 key frontend files (with file paths)
   - UI patterns and conventions discovered
   - Recommendations for frontend implementation")
   ```

   **Integration Explorer** (if needed):
   ```
   Task(code-explorer, "Explore INTEGRATION layer for {feature_description}

   Focus on:
   - External APIs and services
   - Authentication and authorization flows
   - Security patterns
   - Third-party library usage

   Trace integration points comprehensively.

   Provide:
   - List of 5-10 key integration files (with file paths)
   - Integration patterns discovered
   - Recommendations for secure integration")
   ```

2. **Wait for all explorers to complete** (parallel execution)

3. **Read all files identified by all explorers**

4. **Synthesize findings**:
   - Combine insights from all layers
   - Identify cross-layer patterns and dependencies
   - Create comprehensive understanding of feature requirements

---

### Option C: Agent Teams (RARELY NEEDED)

**When**: Extremely complex features with unclear architectural boundaries

**Note**: Agent teams rarely add value for ticket phase. Exploration is inherently independent (each layer separate). Only use if explorers need to debate where feature belongs or challenge assumptions.

---

### After Exploration (All Options)

5. Summarize findings:
   - Patterns discovered from each layer (if parallel)
   - Conventions and design decisions
   - Relevant code locations with file:line references

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

2. **Present options using AskUserQuestion**:
   ```json
   {
     "questions": [
       {
         "question": "Which implementation approach do you prefer?",
         "header": "Approach",
         "multiSelect": false,
         "options": [
           {
             "label": "{Option1Name} (Recommended)",
             "description": "Pros: {benefits}. Cons: {drawbacks}"
           },
           {
             "label": "{Option2Name}",
             "description": "Pros: {benefits}. Cons: {drawbacks}"
           },
           {
             "label": "{Option3Name}",
             "description": "Pros: {benefits}. Cons: {drawbacks}"
           }
         ]
       }
     ]
   }
   ```

   **Example**:
   ```json
   {
     "questions": [
       {
         "question": "Which implementation approach do you prefer?",
         "header": "Approach",
         "multiSelect": false,
         "options": [
           {
             "label": "Extend Existing (Recommended)",
             "description": "Add to current auth module. Minimal changes, consistent with codebase."
           },
           {
             "label": "New Module",
             "description": "Create separate module. Clean separation but more boilerplate."
           }
         ]
       }
     ]
   }
   ```

3. **Wait for user decision** (the "Other" option is auto-added for custom input)

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
   - `--continue=plan` → run `/agi:2_plan .claude/tasks/{task-name}`
   - `--continue=implement` → run `/agi:2_plan .claude/tasks/{task-name} --continue=implement`
   - `--continue=review` or `--continue=all` → run `/agi:2_plan .claude/tasks/{task-name} --continue=review`
   - **No flag** → Use AskUserQuestion to ask about next steps:

   ```json
   {
     "questions": [
       {
         "question": "What would you like to do next?",
         "header": "Next step",
         "multiSelect": false,
         "options": [
           {
             "label": "Review ticket first",
             "description": "Let me review and approve the ticket before planning (Recommended)"
           },
           {
             "label": "Plan immediately",
             "description": "Continue to planning phase now"
           },
           {
             "label": "Plan and implement",
             "description": "Go all the way to implementation"
           },
           {
             "label": "Full workflow",
             "description": "Run ticket → plan → implement → review"
           }
         ]
       }
     ]
   }
   ```

   Based on answer:
   - "Review ticket first" → Stop here
   - "Plan immediately" → run `/agi:2_plan .claude/tasks/{task-name}`
   - "Plan and implement" → run `/agi:2_plan .claude/tasks/{task-name} --continue=implement`
   - "Full workflow" → run `/agi:2_plan .claude/tasks/{task-name} --continue=review`
