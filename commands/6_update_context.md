---
description: Updates existing context files with new discoveries after implementation
model: claude-sonnet-4
allowed-tools: read, write, bash, search
argument-hint: <context_file_path>
---

# Context Update System

<instruction>
Updates existing context files with new discoveries and changes after implementation work. Keeps context files current and accurate.
</instruction>

## Variables
- **context_file_path**: $1 - Path to the context file to update
- **OUTPUT_DIRECTORY**: `./context/` - Directory where context files are stored

<workflow>
1. **Load Context File**
   <thinking>
   - Read the existing context file: $1
   - Parse the current content and structure
   - Identify areas covered in the context
   </thinking>

2. **Change Detection**
   <thinking>
   - Check git status for changes since context was created
   - Identify new files, modified files, and deleted files
   - Focus on areas covered by the context file
   </thinking>

3. **Analyze Changes**
   - Read modified files identified in the context
   - Discover new patterns, dependencies, or approaches
   - Note any architectural changes or improvements
   - Check for new dependencies or configuration changes

4. **Update Context Content**
   <thinking>
   - Update relevant sections with new information
   - Add new code examples if patterns have changed
   - Update dependency lists and architecture notes
   - Refresh file lists with new or moved files
   - Keep historical context for comparison
   </thinking>

5. **Validation & Report**
   <thinking>
   - Ensure updated context is accurate and complete
   - Generate summary of what was updated
   - Note any important changes or new discoveries
   </thinking>
</workflow>

<instructions>
- **Focus on changes**: Only update areas that have actually changed
- **Preserve valuable context**: Don't lose important historical information
- **Keep it readable**: Maintain clear, useful markdown format
- **Be specific**: Include concrete examples and code snippets
</instructions>

## Control Flow
- **Standard execution**:
  - Load existing context file
  - Detect changes in relevant areas
  - Update context with new discoveries
  - Save updated file

## Update Process
- **Content Analysis**: Re-analyze changed files for new patterns and approaches
- **Dependency Updates**: Check for new libraries, frameworks, or configurations
- **Pattern Evolution**: Update existing patterns with new implementations
- **Example Refresh**: Update code examples with current implementations

<output>
Generate context update report containing:

### Update Summary
- **Context File**: Path to the updated context file
- **Files Analyzed**: Count and list of files processed
- **Changes Detected**: Summary of modifications since last update

### Changes Made
- **New Information**: What new insights were added
- **Updated Sections**: Which parts of the context were modified
- **Removed Content**: Any outdated information that was removed
- **Code Examples**: New or updated code snippets included

### New Discoveries
- **Architectural Changes**: New design patterns or architectural decisions
- **Dependencies**: New frameworks, libraries, or tools detected
- **Implementation Patterns**: New coding approaches or conventions
- **Configuration Changes**: Updates to settings or environment

### Validation Results
- **Accuracy Check**: Verification that updated context reflects current code
- **Completeness**: Assessment of context coverage

### Recommendations
- **Next Update**: When to consider updating this context again
- **Related Areas**: Other parts of codebase that might need context updates
- **Usage Notes**: How to best use the updated context file
</output>