---
description: Code review and quality assessment with confidence-based filtering
argument-hint: <task_folder_path>
---

# Code Reviewer

You are reviewing the implementation against requirements and best practices. Focus on high-confidence issues that truly matter - quality over quantity.

## Core Principles

- **Review only changed code**: Focus on git diff, not the entire codebase
- **High confidence only**: Only report issues with confidence ≥ 80
- **Actionable feedback**: Every issue must have a concrete fix suggestion
- **Use TodoWrite**: Track review progress

---

## Phase 1: Load Context

**Goal**: Understand what was built and what to review

Input: $ARGUMENTS (task folder path)

**Actions**:
1. Create todo list with review phases
2. Read task artifacts:
   ```
   Read(".claude/tasks/{task-folder}/ticket.md")
   Read(".claude/tasks/{task-folder}/plan.md")
   ```

3. Get changes to review:
   ```
   git diff --name-only main...HEAD
   git diff main...HEAD
   ```

4. Load best practices if they exist:
   ```
   Glob(".claude/best-practices/*.md")
   Read(".claude/best-practices/README.md")
   ```

---

## Phase 2: Automated Checks

**Goal**: Run automated quality tools

**Actions**:
1. Run project checks:
   ```
   /checks
   ```

2. Document any failures with file:line references

---

## Phase 3: Code Review

**Goal**: Comprehensive review of changed code

**Actions**:
1. Launch code-reviewer agent:
   ```
   Task(code-reviewer, "Review implementation for .claude/tasks/{task-folder}

   Scope: ONLY changes from git diff main...HEAD

   Check:
   1. Requirements from ticket - are acceptance criteria met?
   2. Best practices from .claude/best-practices/ (if exists)
   3. Bugs, security issues, performance problems
   4. Pattern consistency with similar implementations from ticket

   Use confidence scoring (0-100). Only report issues ≥ 80.
   Provide file:line references and concrete fixes for each issue.")
   ```

2. Review agent findings
3. **Present findings to user and ask what they want to do**:
   - Fix critical issues now
   - Fix all issues now
   - Proceed as-is

---

## Phase 4: Generate Report

**Goal**: Document review findings

**Actions**:
1. Save report to `.claude/tasks/{task-folder}/review.md`:

```markdown
# Code Review

**Date**: {date}
**Status**: {pass|warning|fail}

## Summary

- Requirements: {X}/{Y} met
- Best practices: {compliant|violations found}
- High-confidence issues: {count}

## Automated Checks

- Lint: {pass/fail}
- Typecheck: {pass/fail}
- Tests: {pass/fail}

## Issues

### Critical (confidence ≥ 90)

[{confidence}] {file}:{line} - {description}
- {why it matters}
- Fix: {concrete suggestion}

### Important (confidence ≥ 80)

[{confidence}] {file}:{line} - {description}
- {why it matters}
- Fix: {concrete suggestion}

## Recommendations

1. {action item}
2. {action item}
```

---

## Phase 5: Summary

**Goal**: Report and handle fixes

**Actions**:
1. Mark all todos complete
2. Show summary:
   ```
   Review: .claude/tasks/{task-folder}/review.md

   Status: {pass|warning|fail}
   Issues: {critical} critical, {important} important

   Top issues:
   - {issue 1}
   - {issue 2}
   ```

3. If user chose to fix issues:
   - Create TodoWrite with each fix
   - Implement fixes one by one
   - Re-run `/checks` after each fix
