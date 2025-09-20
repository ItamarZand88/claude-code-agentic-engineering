---
description: Generates detailed implementation plan from task requirements with inherited context chain
model: claude-sonnet-4
allowed-tools: read, write, bash
argument-hint: <task_file_path>
---

# Implementation Plan Generator

<instruction>
Generate detailed implementation plans from task requirements. Uses the information in the task file to create step-by-step implementation guidance.
</instruction>

## Variables
- **task_file_path**: $ARGUMENTS - Path to the task requirements file
- **OUTPUT_DIRECTORY**: `./plans/` - Directory where implementation plans are stored
- **plan_filename**: `./plans/plan-{task-summary}-{YYYYMMDD}.md` - Generated plan file

<workflow>
1. **Load Task Requirements**
   <thinking>
   - Read the specified task requirements document: $ARGUMENTS
   - Parse task sections: overview, technical requirements, affected files, dependencies
   - Extract any context file references used during task creation
   - Understand the full scope of what needs to be implemented
   </thinking>

2. **Current State Analysis**
   <thinking>
   - Read all files identified in task requirements
   - Understand current architecture and patterns
   - Check git status for any recent changes
   - Verify all dependencies and prerequisites
   </thinking>

3. **Implementation Strategy Design**
   - Break down the task into logical, sequential steps
   - Determine optimal order of implementation to minimize conflicts
   - Use existing project patterns and conventions
   - Identify testing checkpoints throughout the process
   - Plan for rollback strategies if needed

4. **Technical Architecture Planning**
   - Design any new components, functions, or classes needed
   - Plan database schema changes if applicable
   - Define API contracts and interfaces
   - Consider performance and scalability implications

5. **Dependency Resolution**
   - Verify all required dependencies are available
   - Plan installation of new packages or libraries
   - Identify version compatibility requirements
   - Plan for environment setup if needed

6. **Risk Assessment**
   - Identify potential implementation risks and blockers
   - Plan mitigation strategies for each risk
   - Estimate complexity and time requirements for each step
   - Identify critical path dependencies

7. **Testing Strategy**
   - Plan unit tests for new functionality
   - Design integration testing approach
   - Define manual testing procedures
   - Plan for edge case validation

8. **Implementation Plan Generation**
   <thinking>
   - Create detailed step-by-step implementation plan
   - Include code snippets and examples where helpful
   - Specify exact file modifications needed
   - Provide verification steps for each phase
   </thinking>

9. **Plan File Generation**
   <thinking>
   - Create comprehensive implementation plan file
   - Include reference to source task file
   - Structure plan for easy execution by `/implement_plan`
   - Include all technical details and step-by-step guidance
   </thinking>
</workflow>

<instructions>
- Ensure the plan is detailed enough that each step can be executed independently
- Include specific file paths, function names, and code structure details
- Plan for incremental implementation with testing at each stage
- Consider backwards compatibility and migration strategies
- Include rollback procedures for each major step
</instructions>

## Control Flow
- **If** task requirements file is missing or incomplete:
  - Stop execution and prompt user to run `/task-from-scratch` first
- **If** affected files have been modified since task creation:
  - Alert user and ask whether to proceed or regenerate task requirements

<output>
Create an implementation plan document containing:
- **Plan Metadata**:
  - Source task file: `$ARGUMENTS`
  - Context version used (if available)
  - Plan generation timestamp
- **Executive Summary**: High-level implementation approach and timeline
- **Context Insights**: Relevant architectural patterns and project conventions
- **Prerequisites**: Environment setup and dependency installation steps
- **Implementation Steps**: Detailed numbered steps with code examples
- **File Modifications**: Exact changes needed for each file (with context-aware suggestions)
- **Testing Checkpoints**: Validation steps throughout implementation
- **Risk Mitigation**: Identified risks and mitigation strategies
- **Rollback Plan**: Steps to safely revert changes if needed
- **Post-Implementation**: Recommendation to run `/update-context --after-task=$ARGUMENTS` after completion

**Plan File Output:**
- **Source Task**: Reference to the task file used
- **Implementation Strategy**: Clear step-by-step approach
- **Technical Details**: All necessary implementation information

**Next Step:**
- Plan file ready for `/implement_plan {plan_file_path}`
- All requirements and strategy documented for implementation
</output>
