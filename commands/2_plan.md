---
description: Creates comprehensive implementation plan from task file through research and codebase analysis
argument-hint: <task_folder_path>
model: inherit
---

# Implementation Plan Generator with Research & Agent Coordination

<instruction>
**IMPORTANT**: Create a comprehensive, research-backed implementation plan from a task file.

**YOU MUST** orchestrate multiple specialized agents IN PARALLEL and conduct thorough research to produce an actionable, detailed plan.

Think step by step and use "ultrathink" mode for complex architectural decisions.
</instruction>

## Variables
- **task_folder_path**: $ARGUMENTS - Path to the task folder from `/1_ticket` (e.g., `Circle/oauth-authentication`)
- **ticket_file**: `{task_folder_path}/ticket.md` - Task ticket created by `/1_ticket`
- **plan_file**: `{task_folder_path}/plan.md` - Implementation plan (output of this command)

## Workflow

### Step 1: Load Task Requirements

<instruction>
Load task from folder structure:
1. Parse $ARGUMENTS to get task folder path
2. Read `{task_folder_path}/ticket.md`
3. Extract title, description, requirements, affected files, dependencies, constraints, acceptance criteria, and open questions
</instruction>

### Step 2: Parallel Research & Analysis Phase

<parallel_research>
**CRITICAL**: Launch ALL research activities in PARALLEL using a single message with multiple tool calls.

<agent_coordination>
**YOU MUST** run these tasks simultaneously for maximum speed:

**Research Track 1: Web Research** (if applicable)
```
For tasks involving new technologies, complex patterns, or best practices:
- Launch WebSearch for: "{technology} best practices 2025"
- Launch WebSearch for: "{pattern} implementation guide"
- Launch WebSearch for: "{technology} integration guide"
- Use WebFetch for specific documentation URLs

Run all web searches in PARALLEL
```

**Research Track 2: Codebase Analysis Agents (Parallel)**
```
Launch THREE specialized agents IN PARALLEL:

Agent A - feature-finder:
"Use feature-finder agent to discover similar implementations for: {task_description}"

Agent B - dependency-mapper:
"Use dependency-mapper agent to map all dependencies for: {task_description}"

Agent C - codebase-analyst:
"Use codebase-analyst agent to extract project patterns for: {task_description}"

Wait for ALL three agents to complete before proceeding.
```

**Research Track 3: Library Documentation** (if new dependencies needed)
```
Parallel library research:
1. Use mcp__context7__resolve-library-id for each library
2. Use mcp__context7__get-library-docs for each resolved ID
3. Extract integration patterns and configuration requirements

Run ALL library lookups concurrently
```

**Research Track 4: Documentation Scanner** (optional)
```
Task (subagent_type: general-purpose): "Scan project documentation

Search for and read:
- CLAUDE.md, .cursorrules, .windsurf rules
- README.md, CONTRIBUTING.md
- docs/ directory contents
- API documentation
- Inline architecture comments

Extract: Guidelines, patterns, conventions, requirements"
```

**Wait for ALL research tracks to complete** before proceeding.
</agent_coordination>
</parallel_research>

<research_synthesis>
After parallel research completes:
1. Consolidate web research findings
2. Integrate codebase patterns
3. Merge library documentation
4. Reconcile any conflicts
5. Build unified implementation strategy
</research_synthesis>

### Step 3: Architecture Design with implementation-strategist

<architectural_decision_making>
**IMPORTANT**: For complex architectural decisions, use the implementation-strategist agent:

```
Task (subagent_type: general-purpose):
"Use implementation-strategist agent for architectural design of: {task_description}

The agent will:
- Apply ultrathink mode to evaluate multiple approaches
- Analyze trade-offs across all dimensions (scalability, maintainability, complexity)
- Consider 2-3 solution alternatives
- Provide detailed rationale for recommended approach
- Document implementation considerations

Wait for comprehensive architectural recommendation."
```

For simpler tasks, proceed with direct planning based on research findings.
</architectural_decision_making>

### Step 4: Implementation Planning & Task Breakdown

<planning_strategy>
Break implementation into logical, testable phases based on research findings:

**Phase Structure**:
1. **Foundation** - Setup, configuration, dependencies
2. **Core Implementation** - Main features and logic
3. **Integration** - Connect to existing systems
4. **Validation** - Quality checks and validation
5. **Documentation** - Code docs and guides

**For each task, specify**:
- Clear, actionable description
- Files to create/modify with specific changes
- Dependencies on other tasks
- Validation commands to verify completion
- Estimated effort
</planning_strategy>


### Step 5: Plan Document Generation

<output>
Create a comprehensive implementation plan with the following structure:

# Implementation Plan: {Feature Name}

**Created**: {Date}
**Task Folder**: `{task_folder_path}/`
**Source Ticket**: `{task_folder_path}/ticket.md`
**Status**: Ready for Implementation

## Overview

<summary>
{2-3 paragraph summary of what will be implemented and overall approach}
</summary>

## Research Findings

### Best Practices

<best_practices>
- {Best practice 1 with source/reasoning}
- {Best practice 2 with source/reasoning}
- {Best practice n with source/reasoning}
</best_practices>

### Codebase Patterns

<codebase_patterns>
**From codebase-analyst agent:**

{Agent findings on existing patterns, conventions, similar implementations}

**Key patterns to follow:**
- {Pattern 1}: {File path and example}
- {Pattern 2}: {File path and example}
- {Pattern n}: {File path and example}

**Conventions to maintain:**
- Naming: {Observed naming conventions}
- Structure: {File organization patterns}
</codebase_patterns>

### Reference Implementations

<references>
- {Similar feature 1}: `path/to/file.ext` - {What to learn from it}
- {Similar feature 2}: `path/to/file.ext` - {What to learn from it}
- {External reference}: {URL or documentation link}
</references>

### Technology Decisions

<tech_decisions>
- **{Technology/Library 1}**: {Rationale for choice}
- **{Technology/Library 2}**: {Rationale for choice}
</tech_decisions>

## Implementation Plan

### Phase 1: Foundation

#### Task 1.1: {Task Name}

<task>
**Description**: {What needs to be done}

**Files to modify/create**:
- `path/to/file1.ext` - {What changes}
- `path/to/file2.ext` - {What changes}

**Dependencies**: {Prerequisites or other tasks}

**Implementation details**:
```language
// Code example or pseudocode
```

**Validation**:
```bash
# Commands to verify this task
```

**Estimated effort**: {Time estimate}
</task>

#### Task 1.2: {Task Name}
{Repeat task structure}

### Phase 2: Core Implementation

{Continue with detailed tasks}

### Phase 3: Documentation & Polish

{Documentation and cleanup tasks}

## Technical Architecture

### Component Structure

<architecture>
```
{ASCII diagram or description of component organization}
```

**Key components**:
- {Component 1}: {Purpose and responsibilities}
- {Component 2}: {Purpose and responsibilities}
</architecture>

### Data Flow

<data_flow>
{Description of how data flows through the system}

1. {Step 1}
2. {Step 2}
3. {Step n}
</data_flow>

### API Design (if applicable)

<api_design>
**Endpoints**:
- `POST /api/endpoint` - {Purpose, input, output}
- `GET /api/endpoint/:id` - {Purpose, input, output}

**Data models**:
```language
// Model definitions
```
</api_design>

## Integration Points

### Files to Modify

<files_to_modify>
- `path/to/file1.ext` - {Specific changes needed and why}
- `path/to/file2.ext` - {Specific changes needed and why}
</files_to_modify>

### New Files to Create

<new_files>
- `path/to/newfile1.ext` - {Purpose and content}
- `path/to/newfile2.ext` - {Purpose and content}
</new_files>

## Dependencies and Libraries

<dependencies>
**New dependencies to add**:
- `library-name` version `x.y.z` - {Purpose and why this version}

**Installation commands**:
```bash
# Commands to install dependencies
```

**Configuration needed**:
{Any config file changes}
</dependencies>

## Validation Commands


## Risk Assessment

### Potential Risks

<risks>
1. **{Risk 1}**
   - Impact: {High/Medium/Low}
   - Mitigation: {Strategy}

2. **{Risk 2}**
   - Impact: {High/Medium/Low}
   - Mitigation: {Strategy}
</risks>

## Success Criteria

<success_criteria>
- [ ] {Criterion 1 from task ticket}
- [ ] {Criterion 2 from task ticket}
- [ ] {Criterion n from task ticket}
- [ ] Code review completed
- [ ] Documentation updated
</success_criteria>

## Notes and Considerations

<notes>
- {Important note 1}
- {Potential challenge 1 and how to address}
- {Future enhancement possibility}
</notes>

## Agent Coordination Summary

<agents_used>
**Agents consulted**:
- codebase-analyst: {Key findings}
- {other-agent}: {Key findings}

**Research sources**:
- Web search: {Topics researched}
- Documentation: {Docs reviewed}
- Library docs: {Libraries researched}
</agents_used>

---

**Task Folder**: `{task_folder_path}/`

**Files in this folder**:
- `ticket.md` - Task requirements (input)
- `plan.md` (this file) - Implementation plan with research and design
- `review.md` (after implementation) - Code review results

**Note**: Implementation progress is shown in real-time during `/3_implement`, not saved to a file.

**Next Step**: Execute this plan with `/3_implement {task_folder_path}`

The implementation command will work through this plan step-by-step, creating code, and validating each phase.
</output>

## Guidelines

### DO:
- ✅ Launch codebase-analyst agent for pattern discovery
- ✅ Use parallel agent invocation when possible
- ✅ Perform web research for best practices
- ✅ Structure plan with XML tags for clarity
- ✅ Include specific file paths and line numbers
- ✅ Provide code examples and patterns
- ✅ Document validation commands
- ✅ Break down into manageable phases
- ✅ Document rationale for decisions

### DON'T:
- ❌ Skip the research phase
- ❌ Make assumptions without investigation
- ❌ Create vague or abstract tasks
- ❌ Forget to include validation steps
- ❌ Ignore existing codebase patterns
- ❌ Omit risk assessment


## Control Flow

<execution_steps>
1. **Pre-flight validation** - Verify task folder and ticket.md exist
2. **Load ticket** - Extract requirements and context
3. **Launch parallel research** - Start ALL research tracks simultaneously (web + agents + docs)
4. **Wait for completion** - Collect all research outputs
5. **Synthesize findings** - Consolidate and reconcile all research
6. **Architectural design** - Use ultrathink for complex decisions
7. **Task breakdown** - Create detailed, phased implementation plan
8. **Generate plan document** - Write comprehensive plan.md
9. **Save plan** - `{task_folder_path}/plan.md`
10. **Report completion** - Show research summary and next steps
</execution_steps>

<validation_criteria>
Before generating plan:
- ✅ Ticket loaded successfully
- ✅ All parallel research completed
- ✅ Architecture decisions documented with rationale
- ✅ Tasks broken into testable phases
- ✅ Validation commands specified for each task
- ✅ Dependencies mapped
</validation_criteria>

<error_handling>
- **If task folder missing**: Stop, inform user to run `/1_ticket`
- **If research reveals blockers**: Document clearly, suggest alternatives, ask user for guidance
- **If conflicting patterns found**: Document trade-offs, recommend best option with reasoning
</error_handling>

## Example Output Message

<example>
✅ Implementation plan created: `Circle/oauth-authentication/plan.md`

**Research Summary**:
- Web research: OAuth2 best practices, security considerations
- Codebase analysis: Found similar auth pattern in `auth/session.py`
- Agent findings:
  - file-analysis-agent: Mapped dependencies

**Plan includes**:
- 4 implementation phases with 12 detailed tasks
- Architecture design with component breakdown
- Risk assessment and mitigation strategies

**Task Folder Structure**:
```
Circle/oauth-authentication/
├── ticket.md (task requirements)
├── plan.md (implementation plan) ✅
└── review.md (will be created after implementation)
```

**Next step**:
Execute the implementation plan:
```
/3_implement @Circle/oauth-authentication
```

The implementation will proceed step-by-step with validation at each phase.
</example>
