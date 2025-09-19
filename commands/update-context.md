---
description: Captures new discoveries and updates project knowledge base. Run after implementing features or gaining new insights.
model: claude-sonnet-4
allowed-tools: read, write, bash, search
argument-hint: [optional: task_file_path]
---

# Context Update System

<instruction>
Analyzes changes and discoveries to update the project knowledge base. Designed to run after completing work to capture learnings and maintain context freshness.
</instruction>

## Variables
- **context_output_directory**: `./context/` - Directory where context maps and knowledge graphs are stored
- **context_database**: `./context/project-knowledge.json` - Main knowledge graph database file
- **context_report**: `./context/context-report.md` - Human-readable context analysis report
- **backup_directory**: `./context/backups/` - Backup location for previous context versions
- **task_reference**: $2 - If --after-task= provided, path to completed task file

<workflow>
1. **Change Detection**
   <thinking>
   - Analyze changes since last context update (incremental approach)
   - If task file provided, focus on files affected by that task
   - Identify modified, added, and deleted files
   </thinking>

2. **Change Detection**
   - Compare current codebase state with last context update timestamp
   - Identify modified, added, and deleted files since last analysis
   - Check git history for recent commits and development activity
   - If task reference provided, focus on files affected by that task

3. **Backup Current Context**
   - Create timestamped backup of existing context database
   - Store backup in `./context/backups/` with version metadata
   - Ensure safe rollback capability if update fails
   - Maintain backup rotation (keep last 10 versions)

4. **Incremental Analysis**
   - Run specialized agents on changed areas only:
     - **File Analysis Agent**: New and modified files
     - **Pattern Recognition Agent**: Changed architectural patterns
     - **Git History Agent**: Recent development decisions
     - **Dependency Scanner Agent**: New or updated dependencies
     - **Documentation Extractor Agent**: Updated documentation

5. **Knowledge Integration**
   - Merge new discoveries with existing knowledge graph
   - Resolve conflicts between old and new information
   - Update architectural pattern confidence scores
   - Add new relationships and dependencies to graph

6. **Context Optimization**
   - Generate updated agent-optimized summaries
   - Create new context snippets for each agent type
   - Update prompt enhancement data with latest insights
   - Refresh searchable knowledge base

7. **Validation & Report**
   <thinking>
   - Validate updated context for consistency
   - Generate human-readable context report
   - Provide summary of changes and new discoveries
   - Include recommendations for future context maintenance
   </thinking>
</workflow>

<instructions>
- **Incremental by default**: Avoid unnecessary full re-analysis
- **Smart change detection**: Focus analysis on actual changes
- **Preserve existing knowledge**: Don't lose valuable historical context
- **Agent optimization**: Generate outputs that help agents work better
- **Performance aware**: Complete updates efficiently
- **Safe operations**: Always backup before major changes
</instructions>

## Control Flow
- **If** task file path provided:
  - Load task file and extract affected components
  - Focus context update on task-related changes
- **Default behavior**:
  - Detect changes since last update
  - Run agents only on changed areas
  - Merge discoveries with existing context

## Delegation Prompts
- **File Analysis Agent**: Analyze changed files for new patterns and relationships
- **Git History Agent**: Extract recent development decisions and evolution patterns
- **Dependency Scanner Agent**: Update dependency mappings and security analysis
- **Pattern Recognition Agent**: Identify new architectural patterns in changed code
- **Documentation Extractor Agent**: Process updated documentation and comments

<output>
Generate context update report containing:

### Update Summary
- **Update Mode**: Strategy used (full/incremental/from-git/after-task)
- **Files Analyzed**: Count and list of files processed
- **Changes Detected**: Summary of modifications since last update
- **Update Duration**: Time taken for analysis and integration

### New Discoveries
- **Architectural Patterns**: New design patterns or architectural decisions
- **Code Relationships**: New file dependencies and relationships discovered
- **Development Insights**: Recent development decisions and rationale
- **Technology Changes**: New frameworks, libraries, or tools detected

### Knowledge Graph Changes
- **Nodes Added**: New concepts and entities in knowledge graph
- **Relationships Updated**: Modified or new connections between concepts
- **Confidence Adjustments**: Updated reliability scores for existing knowledge
- **Deprecated Elements**: Outdated patterns or decisions marked for removal

### Agent Optimization
- **Context Summaries**: Updated agent-specific context data
- **Prompt Enhancements**: New context-aware prompt improvements
- **Performance Improvements**: Better agent guidance from updated context
- **Coverage Expansion**: New areas of codebase now covered by context

### Validation Results
- **Consistency Checks**: Verification that updated context is coherent
- **Conflict Resolution**: How conflicts between old and new information were resolved
- **Quality Metrics**: Coverage, accuracy, and freshness scores
- **Backup Status**: Confirmation of successful context backup

### Recommendations
- **Next Update**: Suggested timing for next context refresh
- **Focus Areas**: Parts of codebase that need more context analysis
- **Agent Usage**: How agents can best leverage updated context
- **Maintenance Tasks**: Context hygiene and optimization opportunities

### Quick Reference
- **Updated Files**: Key files with new context insights
- **New Patterns**: Recently discovered architectural or design patterns
- **Changed Dependencies**: Updates to external or internal dependencies
- **Context Freshness**: Current staleness indicators and coverage metrics