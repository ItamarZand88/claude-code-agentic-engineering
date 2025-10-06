---
description: Automated code review and quality assessment against original requirements
argument-hint: <plan_file_path> [task_file_path]
model: inherit
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
   - Read `{task_folder_path}/ticket.md` and `{task_folder_path}/plan.md`
   - Use git diff to see what was implemented

2. **Requirements Validation**
   - Map implemented features against acceptance criteria from ticket
   - Identify missing functionality or scope deviations
   - Verify alignment with plan specifications

3. **Code Quality Review with code-reviewer Agent**

<code_review_delegation>
**YOU MUST** use the code-reviewer agent for comprehensive code analysis:

```
Task (subagent_type: general-purpose):
"Use code-reviewer agent to review implementation for: {task_folder_path}

The agent will:
- Validate against requirements from ticket.md
- Identify code quality issues by severity
- Find maintainability concerns
- Assess complexity implications
- Provide actionable recommendations with file:line references

Wait for comprehensive code review report."
```
</code_review_delegation>

9. **Parallel Automated Quality & Compliance Checks**

<parallel_review_agents>
**CRITICAL**: Launch BOTH review agents in PARALLEL using a single message with multiple Task tool calls.

<agent_coordination>
**YOU MUST** run these agents simultaneously for maximum speed:

**Agent 1: Quality Assurance**
```
Task (subagent_type: general-purpose):
"Run comprehensive automated quality checks for: {task_folder_path}

**IMPORTANT**: Think step by step through each check.

**YOU MUST** perform:
1. Detect and run project linter (eslint, pylint, etc.)
2. Run type checking (tsc, mypy, etc.)
3. Check code formatting (prettier, black, etc.)

**Output Requirements**:
- Save detailed report to: {task_folder_path}/qa-report.yml
- Provide terminal summary with:
  - Overall pass/fail status
  - Error/warning counts
  - Quick fix commands
  - File references with line numbers"
```

**Agent 2: Standards Compliance**
```
Task (subagent_type: general-purpose):
"Validate implementation against project standards for: {task_folder_path}

**IMPORTANT**: Load ALL standards from Circle/standards/ directory.

**YOU MUST** check:
1. Coding standards compliance
2. Architecture patterns adherence
3. API design principles
4. Documentation standards
5. Error handling patterns

**Output Requirements**:
- Save detailed report to: {task_folder_path}/standards-compliance.yml
- Provide terminal summary with:
  - Overall compliance score
  - Violations by severity (critical, high, medium, low)
  - Specific file:line references
  - Actionable fix recommendations"
```

**Wait for BOTH agents to complete** before generating final review report.
</agent_coordination>
</parallel_review_agents>

<agent_synthesis>
After parallel agents complete:
1. Collect QA report results
2. Collect compliance report results
3. Consolidate findings
4. Identify overlapping issues
5. Prioritize by severity and impact
</agent_synthesis>

10. **Generate Comprehensive Review Report**
   - Compile all findings into comprehensive report
   - Include results from quality-assurance-agent and standards-compliance-agent
   - Save as `{task_folder_path}/review.md`
   - Include actionable recommendations with priority levels

## Instructions
- Focus on actionable feedback with specific line numbers and examples
- Prioritize issues by business impact and security risk
- Provide immediate fixes and long-term improvement suggestions
- Include positive feedback for well-implemented sections

## Control Flow
- **If task folder doesn't exist**: Stop and inform user to create task with `/1_ticket`
- **Standard review**: Load task artifacts, use git diff to analyze changes, analyze all issues, save review to `{task_folder_path}/review.md`

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
