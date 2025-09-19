---
description: Links and connects existing tasks, plans, and context together, creating missing relationships and metadata
model: claude-sonnet-4
allowed-tools: read, write, bash
argument-hint: [none]
---

# Workflow Connection Manager

Intelligently connects and links existing workflow components (tasks, plans, context) to create a cohesive, traceable workflow ecosystem. Repairs broken links and establishes missing relationships.

## Variables
- **context_directory**: `./context/` - Directory containing context maps and knowledge graphs
- **tasks_directory**: `./tasks/` - Directory containing task requirement documents
- **plans_directory**: `./plans/` - Directory containing implementation plans
- **workflow_metadata**: `./workflow-metadata.json` - Workflow relationship database
- **backup_suffix**: `.bak` - Backup suffix for modified files

## Workflow
1. **Discovery Phase**
   - Use `/get-context --json` to load existing project relationships quickly
   - Scan all task files and extract metadata, timestamps, and content
   - Scan all plan files and identify source task references (if any)
   - Identify orphaned components and missing relationships using context insights

2. **Relationship Analysis**
   - Match tasks to plans based on content similarity and timing
   - Cross-reference file paths and dependencies between components
   - Analyze context relevance to specific tasks and plans
   - Detect broken or incorrect links between components

3. **Link Generation Strategy**
   - For orphaned tasks: Suggest creating implementation plans
   - For orphaned plans: Attempt to identify originating tasks
   - For context-disconnected items: Link relevant context insights
   - Create bidirectional references for traceability

4. **Metadata Enhancement**
   - Add task-to-plan linking in plan headers
   - Include context version references in both tasks and plans
   - Generate workflow metadata tracking relationships
   - Add timestamps and version information for tracking

5. **Verification & Validation**
   - Verify all created links are accurate and meaningful
   - Check for circular dependencies or conflicts
   - Validate file references and paths exist
   - Ensure metadata consistency across components

6. **Connection Implementation**
   - Backup existing files before modification
   - Update plan files with source task references
   - Enhance task files with plan and context links
   - Create or update workflow metadata database
   - Generate connection report and recommendations
   - Suggest `/update-context` to capture new workflow relationships

## Instructions
- Always backup files before making modifications
- Prefer adding metadata to existing files over creating new ones
- Use intelligent content analysis to identify relationships
- Provide clear explanations for connection decisions
- Respect existing manual links and metadata
- Focus on creating actionable, useful connections

## Control Flow
- **Standard Operation**:
  - Automatically create missing links based on content analysis
  - Update files with metadata and cross-references
  - Generate workflow metadata database
  - Fix any broken or incorrect links found
  - Provide comprehensive connection report

## Report
Generate workflow connection report containing:

### Discovery Results
- **Files Scanned**: Count of tasks, plans, and context files analyzed
- **Existing Links**: Currently working relationships found
- **Orphaned Components**: Items without proper connections
- **Broken Links**: Invalid or outdated references detected

### Relationship Mapping
- **Task-Plan Links**: Successfully matched and newly created connections
- **Context Integration**: Context insights linked to specific tasks/plans
- **Dependency Chains**: Related workflows and their connections
- **Timing Analysis**: Workflow progression and component creation order

### Actions Taken
- **Links Created**: New relationships established with reasoning
- **Metadata Added**: Cross-references and tracking information added
- **Files Modified**: List of files updated with backup confirmation
- **Validation Results**: Verification status of all connections

### Connection Quality
- **Confidence Scores**: Reliability rating for each connection (0-100%)
- **Content Similarity**: How well connected components relate to each other
- **Timing Relevance**: Whether connection timing makes logical sense
- **Manual Review Needed**: Connections requiring human validation

### Recommendations
- **Workflow Improvements**: Suggestions for better component organization
- **Missing Components**: Tasks or plans that should be created
- **Context Updates**: Areas where context map should be refreshed
- **Process Enhancements**: Ways to improve future workflow connectivity

### Next Steps
- **Validation Tasks**: Items requiring manual review or confirmation
- **Follow-up Actions**: Additional commands to run for complete integration
- **Maintenance Schedule**: Suggested frequency for connection health checks
- **Automation Opportunities**: Ways to prevent future connection issues