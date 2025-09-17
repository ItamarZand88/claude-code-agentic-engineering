---
description: Automated code review and quality assessment against original requirements
model: claude-sonnet-4
allowed-tools: read, write, bash, search
argument-hint: <plan_file_path> [--task-file=path] [--severity=low|medium|high]
---

# Implementation Quality Reviewer

Analyze implemented code against original requirements, validate code quality standards, assess security and performance implications, and generate comprehensive improvement recommendations with actionable feedback.

## Variables
- **plan_file_path**: $1 - Path to the implementation plan that was executed
- **task_file_path**: $2 - Path to original task requirements (if --task-file= provided)
- **severity_filter**: $3 - Minimum severity level for reported issues (if --severity= provided)
- **review_output_directory**: `./reviews/` - Directory for review reports
- **coding_standards**: `./templates/coding-standards-template.md` - Project coding standards reference
- **security_checklist**: `./templates/security-checklist-template.md` - Security validation checklist
- **review_template**: `./templates/code-review-template.md` - Code review report template

## Workflow
1. **Requirements Validation**
   - Load original task requirements and implementation plan: $1
   - If $2 provided, also load task file for additional context
   - Map implemented features against original acceptance criteria
   - Identify any missing functionality or scope deviations

2. **Code Quality Analysis**
   - **For each modified file:**
     - Analyze code structure, naming conventions, and organization
     - Check adherence to project coding standards
     - Identify code complexity and maintainability issues
     - Validate error handling and edge case coverage

3. **Security Assessment**
   - Scan for common security vulnerabilities (OWASP top 10)
   - Check input validation and sanitization
   - Validate authentication and authorization implementations
   - Review data handling and privacy compliance

4. **Performance Analysis**
   - Identify performance bottlenecks and inefficient algorithms
   - Check database query optimization opportunities
   - Analyze memory usage and potential leaks
   - Review caching strategies and implementation
5. **Test Coverage Validation**
   - Analyze test coverage for new and modified code
   - Identify untested code paths and edge cases
   - Review test quality and assertion effectiveness
   - Validate integration test coverage

6. **Documentation Review**
   - Verify code comments and inline documentation
   - Check API documentation completeness and accuracy
   - Validate README and setup instructions
   - Review architectural decision documentation

7. **Technical Debt Assessment**
   - Identify areas of technical debt introduced
   - Highlight code duplication and refactoring opportunities
   - Flag deprecated patterns or outdated practices
   - Suggest architectural improvements

## Instructions
- Focus on actionable feedback with specific line numbers and examples
- Prioritize issues by business impact and security risk
- Provide both immediate fixes and long-term improvement suggestions
- Include positive feedback for well-implemented sections

## Control Flow
- **If** original task or plan files are missing:
  - Perform review based on git diff and commit messages
  - Note limited context in review report
- **If** $3 contains severity filter:
  - Only report issues at or above the specified severity level
  - Include summary of filtered issues for awareness

## Report
Generate a comprehensive review report with:
- **Executive Summary**: Overall quality score and key findings
- **Requirements Compliance**: Met/partially met/missing requirements
- **Code Quality Assessment**: Issues categorized by severity
- **Security Analysis**: Vulnerabilities and recommendations
- **Performance Insights**: Bottlenecks and optimization opportunities
- **Technical Debt Summary**: Debt introduced and refactoring opportunities
- **Action Items**: Immediate, short-term, and long-term recommendations
