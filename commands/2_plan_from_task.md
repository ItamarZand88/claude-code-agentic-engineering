---
description: Creates comprehensive implementation plan from task file through research and codebase analysis
model: claude-sonnet-4
allowed-tools: read, write, bash, search, grep, glob, task
argument-hint: <task_file_path>
---

# Implementation Plan Generator with Research & Agent Coordination

<instruction>
Create a comprehensive, research-backed implementation plan from a task file. This command orchestrates multiple specialized agents and conducts thorough research to produce an actionable, detailed plan.
</instruction>

## Variables
- **task_folder_path**: $ARGUMENTS - Path to the task folder from `/1_task_from_scratch` (e.g., `Circle/oauth-authentication`)
- **ticket_file**: `{task_folder_path}/ticket.md` - Task ticket created by command 1
- **plan_file**: `{task_folder_path}/plan.md` - Implementation plan (output of this command)

## Workflow

### Step 1: Load Task Requirements

<thinking>
- Read the task folder path from $ARGUMENTS (e.g., `Circle/oauth-authentication`)
- Load `{task_folder_path}/ticket.md`
- Extract core requirements and objectives
- Identify the type of work (new feature, refactor, bugfix, etc.)
- Note any specific constraints or dependencies
- Understand acceptance criteria
</thinking>

<instruction>
**Load task from folder structure**:
1. Parse $ARGUMENTS to get task folder path
2. Read `{task_folder_path}/ticket.md`
3. Extract:
   - Title and description
   - Requirements checklist
   - Potentially affected files
   - Dependencies and constraints
   - Acceptance criteria
   - Open questions
</instruction>

### Step 2: Research Phase

<instruction>
Conduct comprehensive research to inform the implementation plan. Use multiple sources:
</instruction>

#### 2.1 Web Research (When Applicable)

<thinking>
For tasks involving:
- New technologies or frameworks
- Complex patterns (authentication, caching, state management)
- Industry best practices
- Security considerations
- Performance optimization

Perform web searches to find:
- Official documentation
- Best practice guides
- Common implementation patterns
- Security considerations
- Performance benchmarks
</thinking>

<example>
Example web searches:
- "OAuth2 implementation best practices Python"
- "React state management patterns 2024"
- "PostgreSQL connection pooling best practices"
- "API rate limiting strategies"
</example>

#### 2.2 Codebase Pattern Analysis with Specialized Agents

<instruction>
**IMPORTANT**: Launch the `codebase-analyst` agent to perform deep pattern discovery.

Use the Task tool to invoke the codebase-analyst agent:

<agent_invocation>
Task: Launch codebase-analyst agent for pattern discovery

Prompt:
"Analyze the codebase for patterns relevant to: {task_description}

Focus on:
1. Similar features or implementations
2. Project architecture and structure
3. Coding conventions and naming patterns
4. Testing approaches
5. Integration patterns
6. Library usage patterns

Provide specific file paths, code examples, and executable commands."
</agent_invocation>

**Run this agent in PARALLEL with other research activities when possible.**
</instruction>

#### 2.3 Documentation Analysis (When Relevant)

<thinking>
If the project has substantial documentation:
- Check for architectural docs (CLAUDE.md, .cursorrules, etc.)
- Review API documentation
- Check README files for conventions
- Look for inline code documentation
</thinking>

#### 2.4 Dependency and Library Research

<thinking>
For tasks requiring new libraries or dependencies:
- Use Context7 MCP to fetch library documentation
- Research integration patterns
- Check version compatibility
- Review security considerations
</thinking>

<example>
Example using Context7:
1. `mcp__context7__resolve-library-id` for "fastapi"
2. `mcp__context7__get-library-docs` with library ID
3. Extract relevant patterns and examples
</example>

### Step 3: Multi-Agent Coordination (When Needed)

<instruction>
For complex tasks, launch multiple specialized agents IN PARALLEL:

**Available Agents**:
- `codebase-analyst`: Pattern recognition, conventions, architecture
- `file-analysis-agent`: Deep file analysis, dependencies, relationships
- `git-history-agent`: Historical context, decision rationale
- `documentation-extractor-agent`: Documentation parsing and synthesis
- `dependency-scanner-agent`: External dependencies, security

**Use the Task tool to launch agents in parallel** for optimal performance.
</instruction>

<example>
Parallel agent launch example:
- Launch codebase-analyst for pattern discovery
- Launch file-analysis-agent for specific file dependencies
- Launch git-history-agent to understand past decisions

Wait for all agents to complete, then synthesize findings.
</example>

### Step 4: Synthesis and Planning

<thinking>
Combine all research findings:
- Web research insights
- Codebase patterns from agents
- Existing implementations
- Best practices
- Library documentation
- Historical context

Synthesize into a cohesive implementation strategy.
</thinking>

#### 4.1 Architecture and Design Decisions

<design_thinking>
Based on research, determine:
- Overall architecture approach
- Component structure
- Data flow patterns
- Integration points
- Technology choices

Document rationale for each major decision.
</design_thinking>

#### 4.2 Task Breakdown

<instruction>
Break the implementation into logical phases and tasks:

**Phase 1: Foundation**
- Setup and configuration tasks
- Core infrastructure
- Dependencies installation

**Phase 2: Core Implementation**
- Main feature development
- Component creation
- Integration work

**Phase 3: Testing and Validation**
- Unit tests
- Integration tests
- Validation and edge cases

**Phase 4: Documentation and Polish**
- Code documentation
- User documentation
- Final refinements

Each task should include:
- Clear description
- Specific files to modify/create
- Dependencies on other tasks
- Estimated effort
- Validation steps
</instruction>

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
- Testing: {Test structure and commands}
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

### Phase 3: Integration & Testing

{Testing tasks and validation}

### Phase 4: Documentation & Polish

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

## Testing Strategy

### Unit Tests

<unit_tests>
- Test coverage for {component 1}
- Test coverage for {component 2}

**Example test structure**:
```language
// Test example following project patterns
```

**Test commands**:
```bash
# Commands to run unit tests
```
</unit_tests>

### Integration Tests

<integration_tests>
- {Integration test scenario 1}
- {Integration test scenario 2}

**Test commands**:
```bash
# Commands to run integration tests
```
</integration_tests>

### Edge Cases and Validation

<edge_cases>
- [ ] {Edge case 1 to test}
- [ ] {Edge case 2 to test}
- [ ] {Edge case n to test}
</edge_cases>

## Validation Commands

<validation>
**Before starting implementation**:
```bash
# Commands to verify environment is ready
```

**After each phase**:
```bash
# Commands to validate phase completion
```

**Final validation**:
```bash
# Complete test suite
```
</validation>

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

### Rollback Strategy

<rollback>
If implementation needs to be reverted:
1. {Rollback step 1}
2. {Rollback step 2}
</rollback>

## Success Criteria

<success_criteria>
- [ ] {Criterion 1 from task ticket}
- [ ] {Criterion 2 from task ticket}
- [ ] {Criterion n from task ticket}
- [ ] All tests passing
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

**Note**: Implementation progress is shown in real-time during `/3_implement_plan`, not saved to a file.

**Next Step**: Execute this plan with `/3_implement_plan {task_folder_path}`

The implementation command will work through this plan step-by-step, creating code, running tests, and validating each phase.
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
- ✅ Consider testing at each phase
- ✅ Document rationale for decisions

### DON'T:
- ❌ Skip the research phase
- ❌ Make assumptions without investigation
- ❌ Create vague or abstract tasks
- ❌ Forget to include validation steps
- ❌ Ignore existing codebase patterns
- ❌ Omit risk assessment
- ❌ Skip testing strategy

## Control Flow

**Standard execution**:
1. Load task folder path from $ARGUMENTS
2. Read `{task_folder_path}/ticket.md`
3. Perform web research (if applicable)
4. Launch codebase-analyst agent
5. Launch additional specialized agents (if needed)
6. Synthesize all findings
7. Design architecture and approach
8. Break down into detailed tasks
9. Generate comprehensive plan document
10. Save as `{task_folder_path}/plan.md`

**If task folder or ticket.md is missing**:
- Stop and inform user to create task with `/1_task_from_scratch`

**If research reveals blockers**:
- Document blockers clearly
- Suggest alternatives or prerequisites
- Ask user for guidance

## Example Output Message

<example>
✅ Implementation plan created: `Circle/oauth-authentication/plan.md`

**Research Summary**:
- Web research: OAuth2 best practices, security considerations
- Codebase analysis: Found similar auth pattern in `auth/session.py`
- Agent findings:
  - codebase-analyst: Identified testing patterns and integration points
  - file-analysis-agent: Mapped dependencies

**Plan includes**:
- 4 implementation phases with 12 detailed tasks
- Architecture design with component breakdown
- Testing strategy with validation commands
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
/3_implement_plan Circle/oauth-authentication
```

The implementation will proceed step-by-step with validation at each phase.
</example>
