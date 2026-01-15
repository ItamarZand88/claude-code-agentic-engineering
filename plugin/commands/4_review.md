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
    Bash("bash skills/code-compliance/scripts/check_compliance.sh .claude/best-practices")
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

4. Pattern Compliance (NEW):
   - Read "Similar Implementations in Codebase" section from ticket
   - IF similar implementations documented:
     * Compare new implementation against documented patterns
     * Check: naming conventions, structure, error handling, patterns
     * Validate consistency with existing similar code
     * Report deviations with specific pattern references
     * Calculate pattern compliance score
   - ELSE: Skip and note in report

5. Security: Check for vulnerabilities IN CHANGED CODE

6. Performance: Identify bottlenecks IN CHANGED CODE

Provide file:line references for all issues found in the git diff.

See: skills/code-compliance/review-integration-guide.md for detailed best practices validation instructions.")
</example>

### 4. Generate Report

Save to `.claude/tasks/{task-folder}/review.md`:

```markdown
# Code Review

**Date**: {date}
**Quality**: {score}/10
**Best Practices Compliance**: {percentage}% ({X}/{Y} guidelines)
**Pattern Compliance**: {percentage}% ({X}/{Y} patterns matched)
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

## Pattern Compliance

**Overall Pattern Match**: {percentage}% ({matched}/{total} patterns followed)

### ✅ Patterns Followed

- **{Pattern Name}** (from {similar_file}:{line})
  - Naming convention matches
  - Structure follows established pattern
  - Error handling consistent

### ❌ Pattern Deviations

#### High Severity

- **Pattern Deviation: {pattern_name}** (ref: {ticket_section})
  - **File**: {file}:{line}
  - **Issue**: {description of deviation}
  - **Expected Pattern** (from {similar_file}:{line}):
    ```typescript
    // Existing pattern
    {pattern_code}
    ```
  - **Actual Implementation**:
    ```typescript
    // New code (deviates)
    {actual_code}
    ```
  - **Fix**: Align with existing pattern for consistency

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
