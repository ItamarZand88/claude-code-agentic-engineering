---
description: Create detailed implementation plan with architecture design and code examples
argument-hint: <task_folder_path> [--continue=implement|review|all]
---

# Implementation Plan Generator

You are creating a detailed implementation plan that defines HOW to build the feature. The ticket already defines WHAT - focus on architecture design, research, and actionable implementation steps.

## Core Principles

- **Research before designing**: Look up best practices and patterns for the technologies involved
- **Design with confidence**: Use code-architect to make decisive architectural choices
- **Use AskUserQuestion for decisions**: When presenting options or asking for user input, use the AskUserQuestion tool with clear options (2-4 choices). Format: `{"questions": [{"question": "...", "header": "...", "multiSelect": false, "options": [...]}]}`
- **Read files identified by agents**: Build deep context before designing
- **Provide code examples**: Every task should have concrete code showing what to write
- **Use TodoWrite**: Track all progress throughout
- **Smart execution patterns**: For architectural decisions with multiple viable approaches, research all options in parallel

---

## Phase 0: Analyze Decision Complexity

**Goal**: Identify if multiple architectural approaches need evaluation

**Actions**:
1. Analyze ticket requirements to detect decision points:
   - Are there multiple technologies that could work? (WebSockets vs SSE vs Polling)
   - Are there competing architectural patterns? (Microservices vs Monolith, REST vs GraphQL)
   - Is this a high-stakes decision with long-term implications?
   - Is the decision controversial or does it have significant trade-offs?

2. **Decision Logic**:
   ```
   approaches = detect_viable_approaches(ticket)

   IF approaches.length >= 3 OR high_stakes_decision:
     IF controversial OR requires_debate:
       recommend = "agent_teams"
     ELSE:
       recommend = "parallel_subagents"
     trigger_question = true
   ELSE IF approaches.length == 2:
     recommend = "single_architect"
     trigger_question = true  # Give option for parallel
   ELSE:
     recommend = "single_architect"
     trigger_question = false  # Approach is clear
   ```

3. **If question triggered**, use AskUserQuestion (see Phase 2 for options)

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

## Phase 2: Research & Approach Evaluation

**Goal**: Gather best practices and evaluate architectural approaches

### Option A: Single Approach Research (DEFAULT)

**When**: Clear implementation approach, no competing alternatives

**Actions**:
1. For new technologies or unfamiliar patterns:
   ```
   WebSearch("{technology} best practices 2026")
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

4. Summarize research findings

Skip for simple tasks where patterns are clear from ticket.

---

### Option B: Parallel Approach Research (RECOMMENDED for 3+ approaches) ⭐

**When**: Multiple viable architectural approaches, significant trade-offs to evaluate

**Recommendation to User** (use AskUserQuestion):
```json
{
  "questions": [{
    "question": "Multiple approaches exist for real-time notifications: WebSockets, SSE, Polling. How should we evaluate them?",
    "header": "Planning",
    "multiSelect": false,
    "options": [
      {
        "label": "Parallel research (Recommended)",
        "description": "3 architect subagents research each approach in parallel with pros/cons. Fast comprehensive evaluation. ~45K tokens."
      },
      {
        "label": "Single architect",
        "description": "One architect researches sequentially and recommends best approach. Simpler and lower cost (~12K tokens)."
      },
      {
        "label": "Agent team debate",
        "description": "3 teammates research AND debate approaches. Best when decision is controversial. Highest thoroughness and cost (~65K tokens)."
      },
      {
        "label": "Use {ApproachX}",
        "description": "Skip research and implement with {ApproachX} (or specify different approach in Other)."
      }
    ]
  }]
}
```

**If Parallel Research chosen**:

1. Launch 3 architect subagents in parallel (in SINGLE message with 3 Task calls):

   **Approach A Researcher**:
   ```
   Task(code-architect, "Research {Approach A} (e.g., WebSockets) for {feature}

   Research:
   1. WebSearch for best practices, pros/cons, use cases
   2. Implementation complexity assessment
   3. Performance and scalability considerations
   4. Ecosystem support and maturity
   5. Integration with existing codebase
   6. Costs and maintenance overhead

   Provide:
   - Summary of approach with clear pros/cons
   - Implementation complexity rating (Low/Medium/High)
   - Performance profile
   - Recommendation: When to use this approach")
   ```

   **Approach B Researcher**:
   ```
   Task(code-architect, "Research {Approach B} (e.g., Server-Sent Events) for {feature}

   Research:
   1. WebSearch for best practices, pros/cons, use cases
   2. Implementation complexity assessment
   3. Performance and scalability considerations
   4. Ecosystem support and maturity
   5. Integration with existing codebase
   6. Costs and maintenance overhead

   Provide:
   - Summary of approach with clear pros/cons
   - Implementation complexity rating (Low/Medium/High)
   - Performance profile
   - Recommendation: When to use this approach")
   ```

   **Approach C Researcher**:
   ```
   Task(code-architect, "Research {Approach C} (e.g., Polling) for {feature}

   Research:
   1. WebSearch for best practices, pros/cons, use cases
   2. Implementation complexity assessment
   3. Performance and scalability considerations
   4. Ecosystem support and maturity
   5. Integration with existing codebase
   6. Costs and maintenance overhead

   Provide:
   - Summary of approach with clear pros/cons
   - Implementation complexity rating (Low/Medium/High)
   - Performance profile
   - Recommendation: When to use this approach")
   ```

2. **Wait for all researchers to complete** (parallel execution)

3. **Synthesize comparison**:
   - Create comparison matrix of all approaches
   - Identify clear winner or trade-offs
   - Make recommendation with rationale
   - Present to user for final decision

---

### Option C: Agent Team Debate (For High-Stakes Decisions)

**When**: Controversial decisions, high-stakes architecture, competing advocates

**Note**: Use when architects should challenge each other's assumptions and debate merits.

**Recommendation to User** (use AskUserQuestion):
```json
{
  "questions": [{
    "question": "This is a high-stakes architectural decision: Microservices vs Monolith. This affects the system for years. How should we decide?",
    "header": "Planning",
    "multiSelect": false,
    "options": [
      {
        "label": "Agent team debate (Recommended)",
        "description": "3 teammates research and debate approaches. Advocates challenge each other's assumptions. Best for high-stakes decisions. ~65K tokens."
      },
      {
        "label": "Parallel research",
        "description": "3 architect subagents research approaches in parallel. No debate/challenge. Fast evaluation but less scrutiny. ~45K tokens."
      },
      {
        "label": "Single architect",
        "description": "One architect researches and recommends. Fastest decision but no peer challenge. ~12K tokens."
      }
    ]
  }]
}
```

**If Agent Team chosen**:

1. Create agent team:
   ```
   Create an agent team to evaluate architectural approaches for {feature}

   Team structure:
   - Lead: Synthesize debate and make final recommendation
   - Teammate 1: Advocate for Approach A with pros/cons/implementation
   - Teammate 2: Advocate for Approach B with pros/cons/implementation
   - Teammate 3: Devil's advocate - challenges both approaches, identifies risks

   Each teammate should:
   1. Research their approach thoroughly (WebSearch, documentation)
   2. Build strong case with evidence
   3. Challenge other approaches constructively
   4. Consider feedback and refine recommendations
   5. Collaborate to find best solution

   Lead synthesizes debate into clear recommendation with rationale.

   Use Sonnet model for all teammates.
   ```

2. **Lead synthesizes** recommendation based on collaborative debate

---

### After Research (All Options)

4. Summarize research findings and chosen approach (if decided)

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
   - `--continue=implement` → run `/agi:3_implement .claude/tasks/{task-folder}`
   - `--continue=review` or `--continue=all` → run `/agi:3_implement .claude/tasks/{task-folder} --continue=review`
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
             "label": "Review plan first",
             "description": "Let me review and approve the plan before implementing (Recommended)"
           },
           {
             "label": "Implement now",
             "description": "Start implementation immediately"
           },
           {
             "label": "Implement and review",
             "description": "Implement and then run code review"
           }
         ]
       }
     ]
   }
   ```

   Based on answer:
   - "Review plan first" → Stop here
   - "Implement now" → run `/agi:3_implement .claude/tasks/{task-folder}`
   - "Implement and review" → run `/agi:3_implement .claude/tasks/{task-folder} --continue=review`
