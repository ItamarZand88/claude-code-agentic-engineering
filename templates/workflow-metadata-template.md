# Workflow Metadata Template

Use this template to track relationships between tasks, plans, context, and execution history in your agentic engineering workflow.

## Basic Information
- **Created**: [ISO timestamp]
- **Last Updated**: [ISO timestamp]
- **Workflow Type**: [feature | bugfix | refactor | enhancement | research]
- **Status**: [planning | in-progress | testing | completed | paused | cancelled]

## Workflow Components

### Task Requirements
- **Task File**: `[./tasks/task-name.md]`
- **Task Created**: [ISO timestamp]
- **Task Description**: [Brief one-line summary]
- **Context Used**: [context version/timestamp if available]

### Implementation Plan
- **Plan File**: `[./plans/plan-name.md]`
- **Plan Created**: [ISO timestamp]
- **Source Task**: `[./tasks/task-name.md]` (link to originating task)
- **Context Version**: [context version used for planning]

### Context Map
- **Context Database**: `[./context/project-knowledge.json]`
- **Context Version**: [timestamp or version]
- **Relevant Context Areas**: [list of context domains used]
- **Agent Insights Used**: [which agents contributed context]

### Execution History
- **Started**: [ISO timestamp]
- **Current Phase**: [analysis | implementation | testing | review]
- **Branch Created**: `[feature/branch-name]`
- **Commits**: [list of relevant commit hashes]
- **Agents Involved**: [list of agents used during execution]

## Relationships

### Dependencies
- **Blocks**: [list of other tasks this blocks]
- **Blocked By**: [list of tasks blocking this one]
- **Related Tasks**: [list of related or similar tasks]

### Files Affected
- **Modified Files**:
  - `[file-path]` - [brief description of changes]
  - `[file-path]` - [brief description of changes]
- **New Files**:
  - `[file-path]` - [brief description of purpose]
  - `[file-path]` - [brief description of purpose]

### Context Updates
- **Context Contributions**: [what this workflow added to project context]
- **Pattern Discoveries**: [new patterns or insights discovered]
- **Architecture Changes**: [any architectural implications]

## Quality Tracking

### Testing
- **Test Coverage**: [percentage or status]
- **Test Files**: [list of test files created/modified]
- **Test Strategy**: [unit | integration | e2e | manual]

### Review
- **Code Review Status**: [pending | approved | changes-requested]
- **Review Comments**: [summary of feedback]
- **Security Review**: [if applicable]

### Validation
- **Acceptance Criteria Met**: [yes/no with checklist]
- **Performance Impact**: [measured or estimated]
- **Breaking Changes**: [list any breaking changes]

## Lessons Learned
- **What Worked Well**: [successes and good practices]
- **What Could Improve**: [challenges and areas for improvement]
- **Context Insights**: [how context helped or could be improved]
- **Agent Performance**: [which agents were most/least effective]

## Next Steps
- **Follow-up Tasks**: [related tasks to create]
- **Context Updates Needed**: [context map updates required]
- **Documentation Updates**: [docs that need updating]

---
*Generated using workflow-metadata-template.md*
*Part of Claude Code Agentic Engineering System*