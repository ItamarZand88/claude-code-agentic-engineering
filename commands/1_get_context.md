---
description: Context discovery - analyzes codebase and creates markdown context files for tasks
model: claude-sonnet-4
allowed-tools: read, write, bash, search
argument-hint: <query_or_area>
---

# Context Discovery

<instruction>
Analyze the codebase for a specific query or area and create a markdown context file. This file will be used by `/task_from_scratch` to provide additional context for task creation.
</instruction>

## Variables
- **OUTPUT_DIRECTORY**: `./context/` - Directory where context files are stored
- **query_term**: $1 - Search term or area to analyze (e.g., "authentication", "database", "API")
- **output_file**: `./context/{query}-{YYYYMMDD}.md` - Simple markdown context file

<workflow>
1. **Query Analysis**
   <thinking>
   - Parse the query term: $1 (e.g., "authentication", "database", "API")
   - Determine the scope of analysis needed
   - Generate output filename: `{query}-{YYYYMMDD}.md`
   </thinking>

2. **Code Discovery**
   <thinking>
   - Search for files related to the query using grep/search tools
   - Find relevant folders and components
   - Identify key files, classes, and functions
   - Discover patterns and architectural approaches
   </thinking>

3. **Dependency Analysis**
   - Identify relevant dependencies and frameworks
   - Find configuration files and settings
   - Map integration points and external services
   - Note database schemas or API endpoints if relevant

4. **Coding Standards Integration**
   <thinking>
   - Check if `./context/CODING_STANDARDS.md` exists
   - If exists, read and extract relevant conventions for the query area
   - Use coding standards to validate discovered patterns
   - Reference established team conventions for consistency
   </thinking>

5. **Pattern Recognition**
   - Identify coding patterns used in the area
   - Find similar implementations elsewhere in the codebase
   - Note conventions and best practices observed
   - **Cross-reference with coding standards** to ensure consistency
   - Extract reusable patterns for new implementation

6. **Context File Creation**
   <thinking>
   - Create markdown file in `./context/` directory
   - Write structured context information
   - Include code snippets and examples
   - Save as `{query}-{YYYYMMDD}.md`
   </thinking>
</workflow>

<instructions>
- **Focused analysis**: Analyze only the areas relevant to the query
- **Code-first approach**: Search and analyze actual code, not abstractions
- **Standards integration**: Always check for and incorporate existing coding standards
- **Consistency validation**: Cross-reference discovered patterns with established conventions
- **Practical context**: Include real code examples and patterns
- **Simple format**: Create readable markdown files, not complex JSON
- **Task optimization**: Structure context to be useful for task creation
</instructions>

## Control Flow
- **Standard execution**:
  - Check for existing coding standards file (`./context/CODING_STANDARDS.md`)
  - Analyze codebase for the given query
  - Cross-reference findings with coding standards (if available)
  - Create markdown context file with integrated findings
  - Display file path for use with `/task_from_scratch`
- **If** coding standards exist:
  - Validate discovered patterns against standards
  - Include relevant standard sections in context
- **If** query is too broad:
  - Ask user to be more specific
  - Suggest narrower search terms

<output>
Create a markdown context file with the following structure:

# Context: {Query} - {Date}

## Overview
Brief summary of what was found related to the query.

## Relevant Files
- List of key files with their purposes
- Important classes and functions
- Configuration files

## Code Patterns
```language
// Example code snippets showing current implementation
```

## Architecture
- How this area is structured
- Key design patterns used
- Integration points

## Dependencies
- Relevant packages and libraries
- External services or APIs
- Database tables or collections

## Existing Implementation
Detailed explanation of current code with examples.

## Conventions
- **Project Standards**: Relevant guidelines from team's coding standards
- **Naming Conventions**: Observed patterns (validated against standards)
- **Code Style**: Formatting and structure patterns (cross-referenced with standards)
- **Testing Approaches**: Current testing patterns and coverage expectations
- **Standards Compliance**: How well current code follows established conventions

## Notes
- Important considerations
- Potential gotchas
- Suggestions for implementation
- **Standards integration**: If coding standards exist, include compliance notes and recommendations

---

**Standards Integration Note:**
When `./context/CODING_STANDARDS.md` exists, this command will:
- Extract relevant coding standards for the query area
- Validate discovered patterns against established conventions
- Include specific standard recommendations in the context
- Flag any deviations from team standards for consistency

---

### Usage
Context file created: `./context/{query}-{YYYYMMDD}.md`

Use with task creation:
```bash
task_from_scratch "your requirement" ./context/{query}-{YYYYMMDD}.md
```
</output>