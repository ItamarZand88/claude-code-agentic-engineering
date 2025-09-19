---
description: Creates comprehensive task requirements document from user input
model: claude-sonnet-4
allowed-tools: read, write, bash, search
argument-hint: <user_prompt>
---

# Task Requirements Generator

<instruction>
Analyze user requirements, understand codebase context, identify relevant files and dependencies, ask clarifying questions when needed, and generate a comprehensive task requirements document.
</instruction>

## Variables
- **user_prompt**: $ARGUMENTS - The initial task description from the user
- **task_output_directory**: `./tasks/` - Directory where task files will be stored
- **requirements_template**: `./templates/task-requirements-template.md` - Standard template for task documentation
- **coding_standards**: `./templates/coding-standards-template.md` - Team coding standards reference

<workflow>
1. **Analyze User Input**
   <thinking>
   - Parse the user prompt: $ARGUMENTS for key requirements, constraints, and objectives
   - Identify the type of task (feature, bugfix, refactor, new project, etc.)
   - Extract any mentioned technologies, frameworks, or specific implementation details
   </thinking>

2. **Context Loading** (using `/get-context`)
   <thinking>
   - Use `/get-context --summary` to load existing project context quickly
   - If context exists, extract architectural patterns, technology stack, and key insights
   - Parse context summary to understand project structure and conventions
   - If no context exists, recommend running: `/update-context --full` first
   </thinking>

3. **Codebase Discovery**
   - Scan the current directory structure to understand project layout (guided by context if available)
   - Identify relevant files, directories, and configuration files
   - Read package.json, requirements.txt, or similar dependency files
   - Analyze existing code patterns and architecture

4. **Contextual Analysis**
   - Read relevant source files that might be affected by the task
   - Understand current implementation patterns and coding standards
   - Identify potential integration points and dependencies
   - Check for existing similar functionality or related features
   - Cross-reference with context insights for architectural considerations

5. **Requirements Clarification**
   - **Important**: If any requirements are ambiguous, incomplete, or unclear, immediately ask the user for clarification
   - Generate specific questions about:
     - Technical implementation preferences
     - User interface requirements
     - Performance constraints
     - Integration requirements
     - Testing expectations
   - Wait for user responses before proceeding

6. **Dependency Mapping**
   - Identify all files that will need to be modified
   - Map out dependencies between components
   - Note any external libraries or services required
   - Identify potential breaking changes or compatibility issues
   - Reference context map for existing dependency relationships

7. **Requirements Document Generation**
   <thinking>
   - Create a comprehensive task requirements file in `./tasks/`
   - Include all gathered information in structured format
   - Add acceptance criteria and definition of done
   - Document assumptions and constraints
   - **Context Integration**: Include relevant context insights and architectural considerations
   - **Smart Suggestions**: Add context-based recommendations for implementation approach
   </thinking>
</workflow>

<instructions>
- **Context First**: Always use `/get-context` before starting analysis for faster, informed task creation
- Be thorough in codebase analysis - understanding context prevents implementation issues
- Always ask for clarification rather than making assumptions about requirements
- Focus on creating actionable, specific requirements that can be directly translated to implementation plans
- Include code examples or references to existing patterns when relevant
- Ensure the requirements document is comprehensive enough for another developer to understand and implement
- **Recommend Context Updates**: If no context exists, suggest running `/update-context --full` before proceeding
- **Performance**: Use fast context retrieval instead of heavy analysis during task creation
</instructions>

<output>
Generate a task requirements document with the following structure:
- **Task Overview**: Clear summary of what needs to be accomplished
- **Context Summary**: Key insights from project context map (if available)
- **Technical Requirements**: Detailed specifications and constraints
- **Affected Files**: List of files that will be modified or created
- **Dependencies**: External and internal dependencies
- **Architectural Considerations**: Patterns and design principles from context analysis
- **Acceptance Criteria**: Measurable success criteria
- **Implementation Notes**: Technical considerations and recommendations
- **Context-Based Recommendations**: Specific suggestions based on existing project patterns
- **Questions/Assumptions**: Any clarifications needed or assumptions made
</output>
