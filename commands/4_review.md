---
description: Code review and quality assessment
argument-hint: <task_folder_path>
model: inherit
allowed-tools: Read, Write, Glob, Grep, Bash, Task
---

# Code Reviewer

## Purpose

Review implementation against requirements and standards.

## Process

### 1. Load Context

<example>
Read("Circle/{task-folder}/ticket.md")
Read("Circle/{task-folder}/plan.md")
Bash("git diff main...HEAD")
</example>

### 2. Run Automated Checks

<example>
Bash("npm run lint")
Bash("npm run typecheck")
Bash("npm run test")
</example>

### 3. Comprehensive Review

<example>
Task(code-reviewer, "Review implementation for Circle/{task-folder}:

1. Requirements: Check all acceptance criteria from ticket
2. Code Quality: Find critical/high/medium/low severity issues
3. Standards: Validate against Circle/standards/ (if exists)
4. Security: Check for vulnerabilities
5. Performance: Identify bottlenecks

Provide file:line references for all issues.")
</example>

### 4. Generate Report

Save to `Circle/{task-folder}/review.md`:

```markdown
# Code Review

**Date**: {date}
**Quality**: {score}/10
**Status**: {pass/warning/fail}

## Summary

Requirements: {X}/{Y} met
Issues: {critical} critical, {high} high

## Automated Checks

- Lint: {pass/fail}
- Typecheck: {pass/fail}
- Tests: {pass/fail}

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
✅ Review: Circle/{task-folder}/review.md

Quality: {score}/10
Issues: {count}

Top Issues:
- {issue_1}
- {issue_2}
```
