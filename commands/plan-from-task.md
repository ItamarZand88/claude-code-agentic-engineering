---
description: Generates detailed implementation plan from task requirements document
model: claude-sonnet-4
allowed-tools: read, write, bash
argument-hint: <task_file_path>
---

# Implementation Plan Generator

Read task requirements document, analyze current codebase state, and generate a comprehensive step-by-step implementation plan with detailed technical specifications.

## Variables
- **task_file_path**: $ARGUMENTS - Path to the task requirements file
- **plan_output_directory**: `./plans/` - Directory where implementation plans are stored
- **backup_strategy**: `git_branch` - Method for creating safe implementation environment
- **plan_template**: `./templates/implementation-plan-template.md` - Standard template for implementation plans
- **coding_standards**: `./templates/coding-standards-template.md` - Team coding standards reference

## Workflow
1. **Load Task Requirements**
   - Read the specified task requirements document: $ARGUMENTS
   - Parse all sections: overview, technical requirements, affected files, dependencies
   - Validate that all necessary information is present
   - If task file is incomplete, request user to run task-from-scratch first

2. **Current State Analysis**
   - Read all files identified in the task requirements
   - Understand current implementation state
   - Identify any changes since task requirements were created
   - Check git status and recent commits for context

3. **Implementation Strategy Design**
   - Break down the task into logical, sequential steps
   - Determine optimal order of implementation to minimize conflicts
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
   - Create detailed step-by-step implementation plan
   - Include code snippets and examples where helpful
   - Specify exact file modifications needed
   - Provide verification steps for each phase

## Instructions
- Ensure the plan is detailed enough that each step can be executed independently
- Include specific file paths, function names, and code structure details
- Plan for incremental implementation with testing at each stage
- Consider backwards compatibility and migration strategies
- Include rollback procedures for each major step

## Control Flow
- **If** task requirements file is missing or incomplete:
  - Stop execution and prompt user to run `/task-from-scratch` first
- **If** affected files have been modified since task creation:
  - Alert user and ask whether to proceed or regenerate task requirements

## Report
Create an implementation plan document containing:
- **Executive Summary**: High-level implementation approach and timeline
- **Prerequisites**: Environment setup and dependency installation steps
- **Implementation Steps**: Detailed numbered steps with code examples
- **File Modifications**: Exact changes needed for each file
- **Testing Checkpoints**: Validation steps throughout implementation
- **Risk Mitigation**: Identified risks and mitigation strategies
- **Rollback Plan**: Steps to safely revert changes if needed
