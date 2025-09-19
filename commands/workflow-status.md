---
description: Shows comprehensive status of all workflow components - tasks, plans, context, and execution state
model: claude-sonnet-4
allowed-tools: read, bash
argument-hint: [none]
---

# Workflow Status Overview

Provides a comprehensive dashboard view of the current workflow state including tasks, plans, context status, and execution progress. Essential for understanding project health and workflow connectivity.

## Variables
- **context_directory**: `./context/` - Directory containing context maps and knowledge graphs
- **tasks_directory**: `./tasks/` - Directory containing task requirement documents
- **plans_directory**: `./plans/` - Directory containing implementation plans
- **workflow_metadata**: `./workflow-metadata.json` - Workflow tracking database

## Workflow
1. **Scan Workflow Directories**
   - Check existence of context/, tasks/, plans/ directories
   - Count files in each directory and get last modified timestamps
   - Identify any missing or empty workflow directories

2. **Context Status Analysis** (using `/get-context`)
   - Use `/get-context` to check context availability and freshness
   - Report last update timestamp and staleness indicators
   - Verify agent-optimized context files existence
   - Calculate context age and recommend update frequency
   - Identify areas where context coverage may be incomplete

3. **Task & Plan Inventory**
   - Scan all task files and extract status/metadata
   - Map relationships between tasks and their generated plans
   - Identify orphaned tasks (no associated plan) or plans (no source task)
   - Check for incomplete or blocked workflows

4. **Active Workflow Detection**
   - Check git branch status for active feature branches
   - Identify currently executing workflows from git status
   - Detect uncommitted changes that may indicate active work
   - Cross-reference with workflow metadata if available

5. **Integration Health Check**
   - Verify all agents have access to context data
   - Check template availability and integrity
   - Validate directory structure and permissions
   - Identify missing workflow components

6. **Status Report Generation**
   - Generate comprehensive status summary report
   - Include recommendations for workflow improvements
   - Highlight any issues or inconsistencies found
   - Provide next-step suggestions for workflow optimization

## Instructions
- Provide actionable insights, not just data dumps
- Highlight workflow gaps and suggest concrete next steps
- Use color coding and clear formatting for terminal display
- Include timestamps and file counts for quick health assessment
- Suggest maintenance actions when workflow components are stale

## Control Flow
- **Standard Report**:
  - Show comprehensive workflow status with key details
  - Focus on workflow health and active items
  - Include actionable recommendations
  - Provide clear next steps for workflow advancement

## Report
Generate workflow status report containing:

### Workflow Overview
- **Directories Status**: Creation status and file counts for context/, tasks/, plans/
- **Active Workflows**: Currently executing or pending workflows
- **Health Score**: Overall workflow system health (0-100)

### Context Status
- **Context Map**: Last updated, coverage statistics, agent optimization status
- **Knowledge Graph**: Nodes, relationships, and data freshness
- **Agent Context**: Availability of context data for each specialized agent

### Task & Plan Status
- **Tasks**: Total count, status distribution (planning/in-progress/completed)
- **Plans**: Total count, task linkage status, execution progress
- **Orphaned Items**: Tasks without plans, plans without tasks
- **Completion Rate**: Percentage of tasks with completed implementations

### Integration Status
- **Template Availability**: All required templates present and accessible
- **Agent Readiness**: All agents have required context and dependencies
- **Git Integration**: Branch status, uncommitted changes, workflow branches

### Recommendations
- **Immediate Actions**: Critical items requiring attention
- **Maintenance Tasks**: Workflow hygiene and optimization opportunities
- **Context Updates**: Specific suggestions for `/get-context` or `/update-context` usage
- **Context Freshness**: Recommendations for when to run `/update-context --incremental`
- **Workflow Improvements**: Process enhancements based on current state

### Quick Actions
- **Suggested Next Steps**: Most logical next actions based on current state
- **Command Suggestions**: Specific commands to run for workflow advancement
- **Maintenance Commands**: Commands to improve workflow health