---
description: Creates comprehensive task ticket from user prompt with deep codebase analysis
argument-hint: <task_description>
model: inherit
allowed-tools: Read, Write, Glob, Grep, Bash, Task
---

# Task Ticket Generator

## Instructions

<instructions>
**Purpose**: Create a comprehensive task ticket that answers "WHAT needs to be done" through deep codebase analysis.

**Core Principles**:

- Focus on WHAT, not HOW (implementation is for planning phase)
- Perform thorough parallel codebase exploration
- Ask clarification questions if requirements are unclear
- Document everything discovered during analysis

**Key Expectations**:

- Deep understanding of existing codebase patterns
- Comprehensive dependency mapping
- Clear, actionable requirements
- Specific file paths and integration points
  </instructions>

## Variables

### Dynamic Variables (User Input)

- **user_prompt**: `$ARGUMENTS` - The user's task description

### Static Variables (Configuration)

- **OUTPUT_DIRECTORY**: `./Circle/{task-name}/` - Base directory for task artifacts
- **TICKET_FILENAME**: `ticket.md` - Standard ticket filename
- **TASK_FOLDER_PATTERN**: `{brief-summary-kebab-case}` - Naming convention for task folders

### Derived Variables (Computed During Execution)

- **task_folder_name**: Generated from user_prompt (e.g., "oauth-authentication")
- **ticket_path**: `./Circle/{task_folder_name}/ticket.md` - Full path to ticket file

## Workflow

### Step 1: Parse User Intent

<step>
**Objective**: Extract core requirements from user input

**Process**:

1. Read `$ARGUMENTS` (user_prompt)
2. Identify task type: feature | bugfix | refactor | documentation | other
3. Extract key requirements and constraints
4. Note mentioned technologies or approaches
5. Flag ambiguous or incomplete requirements

**Validation**:

- ✅ Task type identified
- ✅ Core requirements extracted
- ✅ Constraints noted
- ✅ Ambiguities flagged (if any)

**Early Return**: If requirements are completely unclear → STOP and ask clarification questions before proceeding
</step>

### Step 2: Deep Codebase Analysis with Parallel Exploration

<step>
**Objective**: Understand codebase context through parallel agent exploration

**Process**:

**Launch Agents in Parallel** (single message with multiple Task calls):

```yaml
Parallel Agent Execution:
  Agent 1 - architecture-explorer:
    purpose: Project structure discovery
    prompt: |
      Use architecture-explorer agent to discover project structure for: {task_description}
      - Find root configs, tech stack, build commands
      - Map directory organization
      - Locate architecture documentation
      - Extract development workflows

  Agent 2 - feature-finder:
    purpose: Pattern discovery
    prompt: |
      Use feature-finder agent to find similar implementations for: {task_description}
      - Search for similar existing features
      - Extract reusable code patterns
      - Identify integration points
      - Find data model examples

  Agent 3 - dependency-mapper:
    purpose: Dependency analysis
    prompt: |
      Use dependency-mapper agent to analyze dependencies for: {task_description}
      - Map internal dependencies
      - Identify external libraries
      - Find API/database integration points
      - Flag configuration files needing updates
```

**Synthesis After Completion**:

1. Consolidate findings from all agents
2. Identify conflicts or gaps in information
3. Build comprehensive understanding
4. Document all discovered context

**Validation**:

- ✅ All 3 agents completed successfully
- ✅ Key files and patterns identified
- ✅ Dependencies mapped
- ✅ Integration points documented
- ✅ No major conflicts in findings

**Conditional**: If agents reveal blockers or missing dependencies → Document clearly and flag for planning phase
</step>

### Step 3: Clarification Questions (Conditional)

<step>
**Objective**: Resolve ambiguities before proceeding

**Condition**: Execute ONLY if requirements are ambiguous or incomplete

**Process**:

1. Identify specific unclear areas
2. Formulate precise questions
3. Present questions to user
4. STOP and wait for user response
5. Incorporate answers into understanding

**Example Questions**:

- "Could you clarify the expected behavior when {scenario}?"
- "Are there any specific constraints I should know about?"
- "I found existing pattern X - should the new feature follow this pattern?"

**Validation**:

- ✅ All ambiguities resolved
- ✅ User feedback incorporated
- ✅ Clear path forward established

**Early Return**: If user requests changes to approach → Update understanding and restart from Step 1
</step>

### Step 4: Create Task Folder Structure

<step>
**Objective**: Set up organized workspace for task artifacts

**Process**:

1. Generate descriptive kebab-case folder name from task
   - Examples: "oauth-authentication", "user-profile-update", "api-rate-limiting"
2. Create directory: `./Circle/{task-folder-name}/`
3. Prepare to save ticket: `./Circle/{task-folder-name}/ticket.md`

**Folder Purpose**:

```
Circle/{task-folder-name}/
├── ticket.md   ← Created NOW (this step)
├── plan.md     ← Created by /2_plan
└── review.md   ← Created by /4_review
```

**Validation**:

- ✅ Folder name is descriptive and follows kebab-case
- ✅ Directory created successfully
- ✅ Path is valid for ticket save
  </step>

### Step 5: Generate Comprehensive Task Ticket

## Output Format

<output>
Save to `{task_folder_path}/ticket.md` with:

**Header**: Title, Date, Type, Status
**Description**: 3-4 sentences on WHAT and WHY
**Context**: Existing implementation, patterns, architecture
**Requirements**: Functional, non-functional, integration (checkboxes)
**Affected Areas**: Files to modify, related files, configs
**Dependencies**: Technical, internal, external, constraints
**Acceptance Criteria**: Core functionality + quality standards (checkboxes)
**Risks**: Technical risks, breaking changes, edge cases
**Analysis Summary**: Metrics + key findings

Next step reference: `/2_plan @Circle/{task-folder-name}`
</output>

## Guidelines

**Focus**: WHAT needs to be done (not HOW - that's for planning)
**DO**: Deep analysis, ask clarifications, document findings
**DON'T**: Skip files, make assumptions, design solutions

## Control Flow

<control_flow>
**Execution Pattern**: Sequential with Conditional Branching

**Flow Logic**:

1. **Parse user intent from $ARGUMENTS**

   - IF requirements are unclear → Ask clarification questions and STOP
   - ELSE → Continue to exploration

2. **Launch parallel exploration** (single message with 3 Task tool calls)

   - Launch architecture-explorer agent
   - Launch feature-finder agent
   - Launch dependency-mapper agent
   - Wait for ALL agents to complete

3. **Synthesize findings**

   - Consolidate all agent results
   - IF new ambiguities found → Ask clarification questions and STOP
   - ELSE → Continue to folder creation

4. **Create folder structure**

   - Generate kebab-case folder name from task description
   - Create `./Circle/{task-folder-name}/` directory

5. **Generate comprehensive ticket**

   - Build ticket from task info + agent findings
   - Save to `./Circle/{task-folder-name}/ticket.md`

6. **Report completion**
   - Display analysis metrics
   - Show key findings
   - Ask user if they want to proceed to planning phase

**Critical Decision Points**:

- ✅ Before exploration: Are requirements clear enough?
- ✅ Before synthesis: Did all agents complete successfully?
- ✅ Before ticket save: Are there unresolved ambiguities?
- ✅ After completion: Does user want to proceed to /2_plan?
  </control_flow>

## Report

<report>
**Format**: Structured completion summary

**Required Elements**:

1. **Task Folder Path**: Display created folder path
2. **Analysis Metrics**: Files analyzed, files to modify, integration points, dependencies
3. **Files Created**: List with descriptions
4. **Task Summary**: One-line description
5. **Key Findings**: Bullet list of discoveries (3-5 items)
6. **Next Step**: Explicit command to run

**Example Output**:

```
✅ Task folder created: `./Circle/oauth-authentication/`

**Analysis Complete**:
- 47 files analyzed
- 12 files will need modification
- 8 integration points identified
- 5 dependencies mapped

Files Created:
- ./Circle/oauth-authentication/ticket.md - Comprehensive task requirements with deep context

Task Summary: Implement OAuth2 authentication system

Key Findings:
- Existing auth system uses JWT tokens in 3 different patterns
- User model has 2 authentication strategies currently
- Session management spans across 5 modules
- 23 API endpoints will need auth integration

Next Step:
Ready to create implementation plan?

---

**After displaying the report above:**

1. Ask user: "Would you like me to proceed with creating the implementation plan?"
2. IF user confirms (yes/proceed/continue) → Use SlashCommand tool to run: SlashCommand(`/2_plan @Circle/{task-folder-name}`)
3. ELSE → Stop and wait for user instructions
```

</report>
