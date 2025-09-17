---
description: Creates comprehensive task requirements document from user input
model: claude-sonnet-4
allowed-tools: read, write, bash, search
argument-hint: <user_prompt>
---

# Task Requirements Generator

Analyze user requirements, understand codebase context, identify relevant files and dependencies, ask clarifying questions when needed, and generate a comprehensive task requirements document.

## Variables
- **user_prompt**: $ARGUMENTS - The initial task description from the user
- **task_output_directory**: `./tasks/` - Directory where task files will be stored
- **requirements_template**: `./templates/task-requirements-template.md` - Standard template for task documentation
- **coding_standards**: `./templates/coding-standards-template.md` - Team coding standards reference

## Workflow
1. **Analyze User Input**
   - Parse the user prompt: $ARGUMENTS for key requirements, constraints, and objectives
   - Identify the type of task (feature, bugfix, refactor, new project, etc.)
   - Extract any mentioned technologies, frameworks, or specific implementation details

2. **Codebase Discovery**
   - Scan the current directory structure to understand project layout
   - Identify relevant files, directories, and configuration files
   - Read package.json, requirements.txt, or similar dependency files
   - Analyze existing code patterns and architecture

3. **Contextual Analysis**
   - Read relevant source files that might be affected by the task
   - Understand current implementation patterns and coding standards
   - Identify potential integration points and dependencies
   - Check for existing similar functionality or related features

4. **Requirements Clarification**
   - **Important**: If any requirements are ambiguous, incomplete, or unclear, immediately ask the user for clarification
   - Generate specific questions about:
     - Technical implementation preferences
     - User interface requirements
     - Performance constraints
     - Integration requirements
     - Testing expectations
   - Wait for user responses before proceeding

5. **Dependency Mapping**
   - Identify all files that will need to be modified
   - Map out dependencies between components
   - Note any external libraries or services required
   - Identify potential breaking changes or compatibility issues

6. **Requirements Document Generation**
   - Create a comprehensive task requirements file in `./tasks/`
   - Include all gathered information in structured format
   - Add acceptance criteria and definition of done
   - Document assumptions and constraints

## Instructions
- Be thorough in codebase analysis - understanding context prevents implementation issues
- Always ask for clarification rather than making assumptions about requirements
- Focus on creating actionable, specific requirements that can be directly translated to implementation plans
- Include code examples or references to existing patterns when relevant
- Ensure the requirements document is comprehensive enough for another developer to understand and implement

## Report
Generate a task requirements document with the following structure:
- **Task Overview**: Clear summary of what needs to be accomplished
- **Technical Requirements**: Detailed specifications and constraints
- **Affected Files**: List of files that will be modified or created
- **Dependencies**: External and internal dependencies
- **Acceptance Criteria**: Measurable success criteria
- **Implementation Notes**: Technical considerations and recommendations
- **Questions/Assumptions**: Any clarifications needed or assumptions made
