---
description: Create detailed implementation plan with code examples
argument-hint: <task_folder_path> [--continue=implement|review|all]
model: inherit
allowed-tools: Read, Write, Glob, Grep, Bash, Task, WebSearch, WebFetch, SlashCommand
---

# Implementation Plan Generator

## Purpose

Transform ticket requirements into actionable tasks with code examples. Architectural decisions are ALREADY made in ticket - focus on detailed HOW.

## Process

### 1. Load Ticket

<example>
Read(".claude/tasks/{task-folder}/ticket.md")
</example>

Extract:

- Requirements
- **Implementation Strategy** (decided approach)
- Affected areas
- Dependencies

If ticket missing → STOP, tell user to run `/1_ticket`.

### 2. Interactive Clarification

**CRITICAL**: Before diving into research and planning, identify unclear areas and ask the user clarifying questions.

**Use AskUserQuestion tool to clarify**:

<example>
AskUserQuestion("I have a few questions about the implementation approach:

1. **Authentication Flow**: The ticket mentions OAuth integration. Should this:
   - Replace existing email/password auth entirely?
   - Work alongside existing auth as an additional option?
   - Be the only auth method for new users?

2. **User Linking**: If a user signs up with OAuth using an email that already exists in our system, should we:
   - Automatically link the accounts?
   - Treat them as separate accounts?
   - Ask the user to confirm linking?

3. **Session Management**: For OAuth sessions, should we:
   - Use JWT tokens (like current system)?
   - Use provider's tokens directly?
   - Implement a hybrid approach?

Please answer these questions so I can create an accurate implementation plan.")
</example>

**When to ask questions**:

✅ **Always ask when**:
- Multiple valid implementation approaches exist
- Requirements are ambiguous or incomplete
- Trade-offs need user input (e.g., performance vs simplicity)
- Edge cases aren't addressed in ticket
- Integration points are unclear
- UI/UX decisions needed
- Technical choices have business implications

✅ **Question types to ask**:
- **Scope**: "Should this feature also handle X scenario?"
- **Behavior**: "When error Y happens, should we...?"
- **Integration**: "Should this integrate with existing Z component?"
- **Trade-offs**: "Would you prefer approach A (simpler) or B (more flexible)?"
- **Edge Cases**: "How should we handle users who...?"
- **UI/UX**: "Where should this button be placed? Should it be...?"
- **Security**: "Who should have permission to...?"

❌ **Don't ask obvious questions**:
- Questions already answered in ticket
- Questions about general best practices (use best-practices/ for that)
- Questions that don't affect implementation
- Questions you can research yourself

**Guidelines for questions**:

1. **Group related questions** - Don't ask one at a time
2. **Be specific** - Provide context and options
3. **Explain why** - Help user understand the impact
4. **Suggest defaults** - Show what you'd recommend
5. **Stop when clear** - Don't over-ask

**Example flow**:

```
Read ticket → Identify 3-4 unclear areas → Ask ALL questions at once →
Wait for answers → Continue with planning
```

**After getting answers**:
- Document decisions in plan
- Update mental model of requirements
- Proceed with confidence

### 3. Research (if needed)

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

### 4. Create Tasks

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

### 5. Generate Plan

Save to `.claude/tasks/{task-folder}/plan.md`:

```markdown
# Implementation Plan

**Task**: {name}
**Date**: {date}

## Strategy (from ticket)

{implementation_strategy_from_ticket}

## Clarifications (from user)

{Document answers to clarifying questions asked during planning:

**Q: {question_summary}**
A: {user_answer}
Decision: {how_this_affects_implementation}

Include all clarifications that influenced the plan.}

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

`/3_implement .claude/tasks/{task-folder}`
```

### 6. Report & Continue

Show summary:

```
Plan: .claude/tasks/{task-folder}/plan.md

Phases: {N}
Tasks: {M}
```

**Handle --continue argument** (check if `$ARGUMENTS` contains `--continue=<value>`):

<example>
# Parse arguments to extract --continue value
if "--continue=all" or "--continue=review" in arguments:
  SlashCommand("/3_implement .claude/tasks/{task-folder} --continue=review")
elif "--continue=implement" in arguments:
  SlashCommand("/3_implement .claude/tasks/{task-folder}")
else:
  # No --continue flag, ask user interactively
  response = AskUserQuestion(
    question: "The implementation plan has been created successfully. What would you like to do next?",
    options: [
      "Continue to implementation phase (/3_implement)",
      "Review the plan first (stop here)",
      "Revise the plan (make changes)",
      "Other (specify custom action)"
    ]
  )

  # Handle response:
  if response == "Continue to implementation phase (/3_implement)":
    Output: `\n🔄 Continuing to implementation...\n`
    SlashCommand("/3_implement .claude/tasks/{task-folder}")
  elif response == "Review the plan first (stop here)":
    Output: `\n✅ Stopped. Review the plan at .claude/tasks/{task-folder}/plan.md\n`
  elif response == "Revise the plan (make changes)":
    Output: `\n✅ Plan saved at .claude/tasks/{task-folder}/plan.md\nPlease tell me what changes you'd like to make.\n`
  else:
    # User selected "Other" or provided custom input
    Output: `\n✅ Plan saved at .claude/tasks/{task-folder}/plan.md\n`
    # Handle custom user input as needed
</example>
