---
description: Code review and quality assessment
argument-hint: <task_folder_path>
model: inherit
allowed-tools: Read, Write, Glob, Grep, Bash, Task, SlashCommand
---

# Code Reviewer

## Purpose

Review implementation against requirements and best practices.

## Process

### 1. Load Context

<example>
# Read task requirements and plan
Read(".claude/tasks/{task-folder}/ticket.md")
Read(".claude/tasks/{task-folder}/plan.md")

# Get ONLY changes for this task (not entire codebase)
Bash("git diff main...HEAD")

# Identify which files were changed in this task
Bash("git diff --name-only main...HEAD")

# Check for best practices
if [ -d ".claude/best-practices" ]; then
    echo "✅ Best practices found - will validate compliance"
    Bash("bash skills/code-standards/scripts/check_compliance.sh .claude/best-practices")
else
    echo "⚠️  No best practices found (run /best-practices to generate)"
fi
</example>

**CRITICAL SCOPE CONSTRAINT**:
- Review ONLY files and lines changed in this specific task
- Do NOT review unchanged code or unrelated files
- Focus on the git diff output from this task's branch

### 2. Run Automated Checks

<example>
SlashCommand("/checks")
</example>

### 3. Comprehensive Review

<example>
Task(code-reviewer, "Review implementation for .claude/tasks/{task-folder}:

**CRITICAL**: Review ONLY the changes introduced by this specific task.
- Scope: ONLY files changed in git diff main...HEAD
- Focus: ONLY lines modified in this task
- Ignore: Unchanged code, unrelated files, existing issues in other parts of codebase

Review Checklist:

1. Requirements: Check all acceptance criteria from ticket
2. Code Quality: Find critical/high/medium/low severity issues IN CHANGED CODE ONLY
3. Best Practices Compliance:
   - IF .claude/best-practices/ exists:
     * Load all .md files from the directory
     * Map ONLY changed files to relevant best practice categories
     * Validate ONLY modified code against applicable guidelines
     * Report violations with file:line, guideline reference, and fix examples
     * Calculate compliance score for changed code only
   - ELSE: Skip and note in report
4. Security: Check for vulnerabilities IN CHANGED CODE
5. Performance: Identify bottlenecks IN CHANGED CODE

Provide file:line references for all issues found in the git diff.

See: skills/code-standards/review-integration-guide.md for detailed best practices validation instructions.")
</example>

### 4. Generate Report

Save to `.claude/tasks/{task-folder}/review.md`:

```markdown
# Code Review

**Date**: {date}
**Quality**: {score}/10
**Best Practices Compliance**: {percentage}% ({X}/{Y} guidelines)
**Status**: {pass/warning/fail}

## Summary

Requirements: {X}/{Y} met
Issues: {critical} critical, {high} high

## Automated Checks

- Lint: {pass/fail}
- Typecheck: {pass/fail}
- Tests: {pass/fail}

## Best Practices Compliance

**Overall Compliance**: {percentage}% ({compliant}/{total} guidelines checked)

### ✅ Compliant Guidelines

- **{Category}** ({file}.md #{numbers})
  - {brief_description}

### ❌ Violations

#### High Severity

- **{Category} Violation** ({file}.md #{number})
  - **File**: {file}:{line}
  - **Issue**: {description}
  - **Guideline**: "{quoted_guideline}"
  - **Fix**: {concrete_fix_with_code_example}

#### Medium Severity

- {similar_format}

## Issues

### Critical

- {file}:{line} - {issue}

### High

- {file}:{line} - {issue}

## Recommendations

1. {fix_1}
2. {fix_2}
```

### 5. Report

```
Review: .claude/tasks/{task-folder}/review.md

Quality: {score}/10
Issues: {count}

Top Issues:
- {issue_1}
- {issue_2}
```
