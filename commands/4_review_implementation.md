---
description: Automated code review and quality assessment against original requirements
model: claude-sonnet-4
allowed-tools: read, write, bash, search
argument-hint: <plan_file_path> [task_file_path]
---

# Implementation Quality Reviewer

Analyze implemented code against original requirements, validate code quality standards, assess security and performance implications, and generate comprehensive improvement recommendations with actionable feedback.

## Variables
- **task_folder_path**: $ARGUMENTS - Path to the task folder (e.g., `Circle/oauth-authentication`)
- **ticket_file**: `{task_folder_path}/ticket.md` - Original task requirements
- **plan_file**: `{task_folder_path}/plan.md` - Implementation plan that was executed
- **review_file**: `{task_folder_path}/review.md` - Code review report (output)
- **coding_standards**: `./context/CODING_STANDARDS.md` - Project coding standards reference (if exists)
- **security_checklist**: `./templates/security-checklist-template.md` - Security validation checklist (if exists)

## Workflow
1. **Load Task Context**
   - Load task folder path from $ARGUMENTS
   - Read `{task_folder_path}/ticket.md` for original requirements
   - Read `{task_folder_path}/plan.md` for implementation strategy
   - Use git diff to see what was implemented

2. **Requirements Validation**
   - Map implemented features against original acceptance criteria from ticket
   - Check if all requirements from ticket are met
   - Identify any missing functionality or scope deviations
   - Verify alignment with plan specifications

3. **Code Quality Analysis**
   - **For each modified file:**
     - Analyze code structure, naming conventions, and organization
     - Check adherence to project coding standards (if CODING_STANDARDS.md exists)
     - Identify code complexity and maintainability issues
     - Validate error handling and edge case coverage

4. **Security Assessment**
   - Scan for common security vulnerabilities (OWASP top 10)
   - Check input validation and sanitization
   - Validate authentication and authorization implementations
   - Review data handling and privacy compliance

5. **Performance Analysis**
   - Identify performance bottlenecks and inefficient algorithms
   - Check database query optimization opportunities
   - Analyze memory usage and potential leaks
   - Review caching strategies and implementation

6. **Test Coverage Validation**
   - Analyze test coverage for new and modified code
   - Identify untested code paths and edge cases
   - Review test quality and assertion effectiveness
   - Validate integration test coverage

7. **Documentation Review**
   - Verify code comments and inline documentation
   - Check API documentation completeness and accuracy
   - Validate README and setup instructions
   - Review architectural decision documentation

8. **Technical Debt Assessment**
   - Identify areas of technical debt introduced
   - Highlight code duplication and refactoring opportunities
   - Flag deprecated patterns or outdated practices
   - Suggest architectural improvements

9. **Automated Quality Checks (via quality-assurance-agent)**
   <instruction>
   **IMPORTANT**: Launch quality-assurance-agent using the Task tool:

   <agent_invocation>
   Task: Launch quality-assurance-agent for automated checks

   Prompt:
   "Run comprehensive quality checks on the implemented code for task: {task_folder_path}

   Perform:
   1. Linting (detect and run project linter)
   2. Type checking (TypeScript, mypy, etc.)
   3. Code formatting checks (prettier, black, gofmt)
   4. Test execution and coverage
   5. Security audit (npm audit, pip-audit, etc.)

   Generate detailed QA report and save to:
   {task_folder_path}/qa-report.yml

   Provide summary in terminal with overall status and quick fix commands."
   </agent_invocation>

   **Run this agent AUTOMATICALLY** - it should always execute during code review.
   </instruction>

10. **Standards Compliance Check (via standards-compliance-agent)**
   <instruction>
   **IMPORTANT**: Launch standards-compliance-agent using the Task tool:

   <agent_invocation>
   Task: Launch standards-compliance-agent for best practices validation

   Prompt:
   "Validate implementation against project standards for task: {task_folder_path}

   Check compliance with standards defined in Circle/standards/:
   1. Load all standards files
   2. Analyze code against coding standards
   3. Check architecture patterns compliance
   4. Validate testing standards
   5. Review API design, security, and other category-specific standards

   Generate detailed compliance report and save to:
   {task_folder_path}/standards-compliance.yml

   Provide summary with compliance score, violations by severity, and actionable fixes."
   </agent_invocation>

   **Run this agent AUTOMATICALLY** - it should always execute during code review.
   </instruction>

11. **Generate Review Report**
   - Compile all findings into comprehensive report
   - Include results from quality-assurance-agent
   - Include results from standards-compliance-agent
   - Save as `{task_folder_path}/review.md`
   - Include actionable recommendations with priority levels

## Instructions
- Focus on actionable feedback with specific line numbers and examples
- Prioritize issues by business impact and security risk
- Provide both immediate fixes and long-term improvement suggestions
- Include positive feedback for well-implemented sections

## Control Flow
- **If** task folder doesn't exist:
  - Stop and inform user to create task with `/1_task_from_scratch`
- **Standard review**:
  - Load task artifacts (ticket, plan)
  - Use git diff to analyze implemented changes
  - Analyze all identified issues regardless of severity
  - Save comprehensive review to `{task_folder_path}/review.md`

## Report
Generate a comprehensive review report (`{task_folder_path}/review.md`) with:
- **Executive Summary**: Overall quality score and key findings
- **Requirements Compliance**: Met/partially met/missing requirements (from ticket.md)
- **Plan Adherence**: How well implementation followed the plan
- **Code Quality Assessment**: Issues categorized by severity
- **Security Analysis**: Vulnerabilities and recommendations
- **Performance Insights**: Bottlenecks and optimization opportunities
- **Technical Debt Summary**: Debt introduced and refactoring opportunities
- **Action Items**: Immediate, short-term, and long-term recommendations

## Task Folder Structure After Review

```
Circle/{task-name}/
├── ticket.md (task requirements)
├── plan.md (implementation plan)
├── qa-report.yml (quality checks results) ✅
├── standards-compliance.yml (standards compliance) ✅
└── review.md (comprehensive code review) ✅
```

## Example Output

<example>
✅ Code review completed: `Circle/oauth-authentication/`

═══════════════════════════════════════════════════════════
           COMPREHENSIVE REVIEW SUMMARY
═══════════════════════════════════════════════════════════

📊 QUALITY ASSURANCE (automated checks):
   Overall: ✅ PASS
   • Linting: ✅ 0 errors, 3 warnings
   • Type Check: ✅ No errors
   • Formatting: ❌ 5 files need formatting
   • Tests: ✅ 142/142 passed (87% coverage)
   • Security: ⚠️  2 medium vulnerabilities

📏 STANDARDS COMPLIANCE:
   Overall: 76% ⚠️  PARTIAL COMPLIANCE
   • Coding Standards: ✅ 92%
   • Architecture: ⚠️  65%
   • Testing: ❌ 45%
   • Security: ✅ 95%

🔍 CODE REVIEW:
   Overall Quality: 8.5/10
   • Requirements: ✅ All met
   • Security: ✅ No critical issues
   • Performance: ⚠️  2 optimization opportunities

═══════════════════════════════════════════════════════════

🔴 CRITICAL (must fix immediately):
   • Missing input validation (standards-compliance)

⚠️  HIGH PRIORITY (fix before merge):
   • Business logic in controller (standards-compliance)
   • Low test coverage in payment service (qa-report)

💡 IMPROVEMENTS (recommended):
   • Run `npm run format` to fix formatting (qa-report)
   • Add integration tests for OAuth flow (code review)

📄 Detailed Reports:
   • Circle/oauth-authentication/qa-report.yml
   • Circle/oauth-authentication/standards-compliance.yml
   • Circle/oauth-authentication/review.md

**Next Steps**:
- Address all critical and high-priority issues
- Review detailed reports for complete findings
</example>
