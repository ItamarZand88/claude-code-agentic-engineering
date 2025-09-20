---
description: Creates comprehensive task requirements document from user input with optional context file
model: claude-sonnet-4
allowed-tools: read, write, bash, search
argument-hint: <user_prompt> [context_file_path]
---

# Task Requirements Generator with Context Integration

<instruction>
Create comprehensive task requirements using user input and optional context file from `/get_context`. Uses the context file to understand existing patterns and architecture for better task definition.
</instruction>

## Variables
- **user_prompt**: $1 - The initial task description from the user
- **context_file**: $2 - Optional context markdown file from `/get_context` (e.g., `./context/auth-20240120.md`)
- **OUTPUT_DIRECTORY**: `./tasks/` - Directory where task files will be stored
- **task_filename**: `./tasks/task-{summary}-{YYYYMMDD}.md` - Generated task file

<workflow>
1. **Analyze User Input**
   <thinking>
   - Parse the user prompt: $1 for key requirements, constraints, and objectives
   - Identify the type of task (feature, bugfix, refactor, new project, etc.)
   - Extract any mentioned technologies, frameworks, or specific implementation details
   </thinking>

2. **Context Integration**
   <thinking>
   - **If context file provided ($2)**: Load context markdown file
     - Extract relevant patterns, dependencies, and architectural insights
     - Use existing implementation examples and conventions
     - Build on the discovered code patterns
   - **If no context file**: Perform basic analysis
     - Search for relevant files in the codebase
     - Use general project structure understanding
   </thinking>

3. **Requirements Analysis**
   <thinking>
   - Combine user requirements with context insights (if available)
   - Map user needs to existing patterns and architecture
   - Identify what needs to be built vs what can be reused
   - Plan integration with existing codebase
   </thinking>

4. **Requirements Synthesis**
   - Combine user requirements with context insights
   - Map user needs to relevant folders and existing patterns
   - Identify affected files using context folder mappings
   - Leverage architectural patterns already discovered
   - Use dependency information from context for integration planning

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

8. **Task Documentation**
   <thinking>
   - Create comprehensive task file including all requirements
   - Include context insights where relevant
   - Reference context file used for traceability
   - Structure for easy consumption by planning command
   </thinking>

9. **Task File Generation**
   <thinking>
   - Create task file in `./tasks/` directory
   - Include all gathered requirements and context insights
   - Reference the context file used (if any)
   - Structure for easy consumption by `/plan_from_task`
   </thinking>
</workflow>

<instructions>
- **Context Usage**: If context file provided, use it to understand existing patterns and architecture
- **Focus on Requirements**: Ask for clarification on business requirements, not technical implementation
- **Practical Planning**: Structure requirements for easy planning and implementation
- **Code Integration**: Consider how new code will integrate with existing patterns
- **Simple Format**: Create readable markdown task files
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

**Context Integration:**
- **Context File Used**: Reference to context file (if provided)
- **Key Insights Applied**: How context influenced task requirements
- **Pattern Utilization**: Existing patterns that will be leveraged

**Next Step:**
- Task file ready for `/plan_from_task {task_file_path}`
- All requirements clearly documented for planning phase
</output>
