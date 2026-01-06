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

Output: `📋 Creating Implementation Plan`

### 1. Load Ticket

Output: `🔄 Step 1/5: Loading ticket...`

<example>
Read(".claude/tasks/{task-folder}/ticket.md")
Output: `✅ Ticket loaded`
</example>

Extract:

- Requirements
- **Implementation Strategy** (decided approach)
- Affected areas
- Dependencies

If ticket missing:
```
❌ Planning Failed

**Error**: Ticket file not found
**Location**: .claude/tasks/{task-folder}/ticket.md
**Cause**: The ticket was never created or was deleted

**Recovery Options**:
1. ✅ Create ticket first (recommended)
   Command: /1_ticket "your task description"

2. Use existing task folder
   Command: /2_plan .claude/tasks/{existing-task}/

**Need Help?**
See: CLAUDE.md or run /help 2_plan
```
STOP.

### 2. Interactive Clarification

Output: `🔄 Step 2/5: Analyzing requirements for clarity...`

**CRITICAL**: Before diving into research and planning, identify unclear areas and ask the user clarifying questions.

If clarification needed:
<example>
Output: `❓ Found {N} areas needing clarification`
</example>

If no clarification needed:
<example>
Output: `✅ Requirements are clear (no clarification needed)`
</example>

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

Output: `🔄 Step 3/5: Researching...`

Launch only relevant research:

**For new technologies**:
<example>
Output: `🔄 Running web research in parallel...`

Show research progress:
```
┌─────────────────────────────────────────────┐
│ Research Progress                           │
├─────────────────────────────────────────────┤
│ 🟡 Web search         (running)             │
│ 🟡 Documentation      (running)             │
│ ⚪ Pattern analysis   (pending)             │
└─────────────────────────────────────────────┘
```

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

After research completes:
<example>
Output: `✅ Research completed ({time}s)`

Show results:
```
📚 Research Results:
├─ ✅ Web: {N} articles analyzed
├─ ✅ Codebase: {N} patterns found
└─ ✅ Documentation: {library} docs retrieved
```
</example>

If no research needed:
<example>
Output: `ℹ️  No research needed (using ticket information)`
</example>

### 4. Create Tasks

Output: `🔄 Step 4/5: Creating implementation tasks...`

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

Output: `🔄 Step 5/5: Generating plan document...`

Save to `.claude/tasks/{task-folder}/plan.md`:

Output: `✅ Plan generated`

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

Show comprehensive summary:

```
┌─────────────────────────────────────────────┐
│ 📋 Plan Generated                           │
├─────────────────────────────────────────────┤
│ Task: {Task Title}                          │
│ Phases: {N}                                 │
│ Tasks: {M}                                  │
│ Estimated Effort: {X-Y hours}               │
│ Duration: {total_time}s                     │
└─────────────────────────────────────────────┘

📊 Plan Summary:
├─ Phase 1: Foundation ({N} tasks, ~{X}h)
├─ Phase 2: Core ({N} tasks, ~{X}h)
├─ Phase 3: Integration ({N} tasks, ~{X}h)
├─ Phase 4: Validation ({N} tasks, ~{X}h)
└─ Phase 5: Documentation ({N} tasks, ~{X}h)

📚 Research:
├─ Web research: {completed|skipped}
├─ Codebase patterns: {N patterns|skipped}
└─ Library docs: {retrieved|skipped}

📁 Files:
└─ 📝 .claude/tasks/{task-folder}/plan.md

⏭️  Next Step:
/3_implement .claude/tasks/{task-folder}
```

**Handle --continue argument** (check if `$ARGUMENTS` contains `--continue=<value>`):

<example>
# Parse arguments to extract --continue value
if "--continue=all" or "--continue=review" in arguments:
  Output: `\n🔄 Auto-continuing to implementation (--continue=all)...\n`
  SlashCommand("/3_implement .claude/tasks/{task-folder} --continue=review")
elif "--continue=implement" in arguments:
  Output: `\n🔄 Auto-continuing to implementation...\n`
  SlashCommand("/3_implement .claude/tasks/{task-folder}")
else:
  # No --continue flag, ask user interactively
  AskUserQuestion("The implementation plan has been created successfully. Would you like to continue to the implementation phase?

I'll run: `/3_implement .claude/tasks/{task-folder}`

Type 'yes' to continue automatically, or 'no' to stop here and review the plan first.")

  # If user confirms:
  Output: `\n🔄 Continuing to implementation...\n`
  SlashCommand("/3_implement .claude/tasks/{task-folder}")
</example>
