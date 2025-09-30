---
description: Creates lightweight task ticket from user prompt without deep codebase analysis
model: claude-sonnet-4
allowed-tools: read, write, bash, search, grep, glob
argument-hint: <user_prompt>
---

# Task Ticket Generator

<instruction>
Create a lightweight, actionable task ticket from user input. Focus on WHAT needs to be done, not HOW to do it. This is the first step in the workflow - quick reconnaissance only, no deep analysis.
</instruction>

## Variables
- **user_prompt**: $ARGUMENTS - The user's description of what they want to accomplish
- **OUTPUT_DIRECTORY**: `./Circle/{task-name}/` - Directory where all task-related files are stored
- **task_folder_name**: `{brief-summary-kebab-case}` - Folder name derived from task description
- **ticket_filename**: `./Circle/{task-folder-name}/ticket.md` - Task ticket file

## Workflow

### 1. Parse User Intent

<thinking>
- Understand the core request from the user prompt
- Identify the type of task (feature, bugfix, refactor, documentation, etc.)
- Extract key requirements and constraints
- Note any technologies or specific approaches mentioned
</thinking>

### 2. Quick File Reconnaissance

<instruction>
Perform LIGHTWEIGHT reconnaissance only:
- Quick grep/glob searches for potentially related files (limit: 5-10 files max)
- Identify the general area of the codebase affected
- Note any obvious integration points
- Find similar features if mentioned
</instruction>

**Important**: Do NOT perform deep analysis. The planning phase will handle that.

### 3. Clarification Questions

<thinking>
If any of these are unclear, ask the user:
- What specific functionality is needed?
- What is the expected behavior?
- Are there specific constraints (performance, security, compatibility)?
- Who is the target user/audience?
- What defines "done" for this task?
</thinking>

<instruction>
**IMPORTANT**: If requirements are ambiguous or incomplete, STOP and ask clarification questions before proceeding.

Example clarification prompts:
- "Could you clarify the expected behavior when...?"
- "Should this integrate with the existing X feature?"
- "What are the performance requirements?"
- "Are there any specific constraints I should know about?"
</instruction>

### 4. Create Task Folder Structure

<thinking>
Before generating the ticket:
1. Generate a folder name from the task description (kebab-case, descriptive)
2. Create the folder structure: `./Circle/{task-folder-name}/`
3. This folder will contain all task-related artifacts:
   - `ticket.md` - The task ticket (created now)
   - `plan.md` - Implementation plan (created by `/2_plan_from_task`)
   - `review.md` - Review results (created by `/4_review_implementation`)
</thinking>

<instruction>
**IMPORTANT**: Create the Circle folder structure:
1. Generate a descriptive, kebab-case folder name from the task (e.g., "oauth-authentication", "user-profile-update")
2. Create `./Circle/{task-folder-name}/` directory
3. Save the ticket as `./Circle/{task-folder-name}/ticket.md`
</instruction>

### 5. Generate Task Ticket

<thinking>
Create a structured task document that captures:
- Clear title and description
- Specific requirements as a checklist
- Potentially affected files (from quick reconnaissance)
- Known dependencies and constraints
- Acceptance criteria
- Open questions or assumptions
</thinking>

## Output Format

<output>
Generate a task ticket document with this structure:

# Task: {Brief Descriptive Title}

**Created**: {Date}
**Type**: {Feature|Bugfix|Refactor|Documentation|Other}
**Status**: Draft

## Description

{Clear 2-3 sentence description of what needs to be accomplished}

## Requirements

<requirements>
- [ ] {Specific requirement 1}
- [ ] {Specific requirement 2}
- [ ] {Specific requirement 3}
- [ ] {Specific requirement n}
</requirements>

## Potentially Affected Areas

<affected_areas>
**Files to likely modify:**
- `path/to/file1.ext` - {reason}
- `path/to/file2.ext` - {reason}

**Areas to investigate during planning:**
- {Area 1}
- {Area 2}
</affected_areas>

## Dependencies & Constraints

<dependencies>
**Technical Dependencies:**
- {Dependency 1}
- {Dependency n}

**Constraints:**
- {Constraint 1}
- {Constraint n}
</dependencies>

## Acceptance Criteria

<acceptance_criteria>
- [ ] {Criterion 1 - what defines successful completion}
- [ ] {Criterion 2}
- [ ] {Criterion n}
</acceptance_criteria>

## Open Questions

<questions>
- {Question 1 that needs resolution during planning}
- {Question n}
</questions>

## Notes

{Any additional context, assumptions, or considerations}

---

**Task Folder**: `./Circle/{task-folder-name}/`

**Files in this folder**:
- `ticket.md` (this file) - Task requirements and acceptance criteria
- `plan.md` (next step) - Implementation plan with research and design
- `review.md` (after implementation) - Code review and quality assessment

**Note**: Implementation progress is tracked in real-time via terminal output, not in a separate file.

**Next Step**: Create implementation plan with `/2_plan_from_task Circle/{task-folder-name}`
</output>

## Guidelines

### DO:
- ✅ Keep it lightweight and fast (target: < 2 minutes)
- ✅ Ask clarification questions when needed
- ✅ Focus on WHAT, not HOW
- ✅ Use quick searches for context (grep/glob)
- ✅ Make the ticket actionable and clear
- ✅ Use XML tags for structured sections

### DON'T:
- ❌ Perform deep codebase analysis (that's for planning phase)
- ❌ Research implementation approaches (that's for planning phase)
- ❌ Launch specialized agents (that's for planning phase)
- ❌ Make architecture decisions (that's for planning phase)
- ❌ Guess at unclear requirements (ask instead)

## Control Flow

**If requirements are clear:**
1. Quick reconnaissance
2. Generate descriptive folder name (kebab-case)
3. Create `./Circle/{task-folder-name}/` directory
4. Generate task ticket
5. Save as `./Circle/{task-folder-name}/ticket.md`
6. Inform user of task folder and next step

**If requirements are unclear:**
1. Identify ambiguities
2. Ask specific clarification questions
3. Wait for user response
4. Then proceed with ticket generation

## Example Output Message

<example>
✅ Task folder created: `./Circle/oauth-authentication/`

**Files created**:
- `./Circle/oauth-authentication/ticket.md` - Task requirements and acceptance criteria

**Task Summary**: Implement OAuth2 authentication system

**Next step**:
Create a comprehensive implementation plan with research and codebase analysis:
```
/2_plan_from_task Circle/oauth-authentication
```

The planning phase will:
- Research best practices
- Analyze codebase patterns with specialized agents
- Design the implementation approach
- Create detailed step-by-step plan
- Save plan as `Circle/oauth-authentication/plan.md`
</example>
