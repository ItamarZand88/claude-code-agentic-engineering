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
- **Smart execution patterns**: Choose between single reviewer, parallel subagents, or agent teams based on PR complexity
- **Use AskUserQuestion for decisions**: When parallel execution recommended, present clear options

---

## Phase 0: Analyze Complexity & Recommend Approach

**Goal**: Determine optimal review pattern based on PR characteristics

**Actions**:
1. Count changed files:
   ```bash
   git diff --name-only main...HEAD | wc -l
   ```

2. Analyze PR characteristics:
   - File count
   - Security-sensitive code (auth, payments, data handling)
   - Performance-sensitive code (database, API, loops)
   - Critical production code

3. **Decision Logic**:
   ```
   IF changed_files >= 15 OR is_critical_production_code:
     recommend = "agent_teams"
     trigger_question = true
   ELSE IF changed_files >= 5 OR is_security_sensitive OR is_performance_sensitive:
     recommend = "parallel_subagents"
     trigger_question = true
   ELSE:
     recommend = "single_reviewer"
     trigger_question = false  # Just proceed
   ```

4. **If question triggered**, use AskUserQuestion to present options (see Phase 3)

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

**Goal**: Comprehensive review of changed code using optimal execution pattern

### Option A: Single Reviewer (DEFAULT for < 5 files)

**When**: Small PRs, simple changes, budget-sensitive

**Actions**:
1. Launch single code-reviewer agent:
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

---

### Option B: Parallel Subagents (RECOMMENDED for 5-15 files)

**When**: Medium PRs, security/performance-sensitive code

**Recommendation to User** (use AskUserQuestion):
```json
{
  "questions": [{
    "question": "This PR changes {N} files with {security/performance}-sensitive code. How should we review it?",
    "header": "Review mode",
    "multiSelect": false,
    "options": [
      {
        "label": "Parallel reviewers (Recommended)",
        "description": "4 specialized subagents (security, performance, testing, compliance) review in parallel. Comprehensive coverage, moderate cost (~45K tokens). Best balance."
      },
      {
        "label": "Single reviewer",
        "description": "One code-reviewer handles all aspects. Faster and lower cost (~10K tokens), but single perspective may miss issues."
      },
      {
        "label": "Agent team review",
        "description": "4 teammate reviewers with inter-agent communication. Most thorough with collaborative challenge. Highest cost (~70K tokens). Best for critical PRs."
      },
      {
        "label": "Quick check only",
        "description": "Automated checks only (lint, typecheck, format). Fastest but no deep analysis."
      }
    ]
  }]
}
```

**If Parallel Subagents chosen**:

1. Launch 4 specialized reviewers in parallel (in SINGLE message with 4 Task calls):

   **Security Reviewer**:
   ```
   Task(code-reviewer, "Review SECURITY aspects of PR for .claude/tasks/{task-folder}

   Scope: ONLY changes from git diff main...HEAD

   Focus on:
   - Authentication and authorization
   - Input validation and sanitization
   - Data exposure risks
   - SQL injection, XSS, CSRF vulnerabilities
   - Secrets or API keys in code

   Use confidence scoring (0-100). Only report issues ≥ 80.
   Provide file:line references and concrete fixes.")
   ```

   **Performance Reviewer**:
   ```
   Task(code-reviewer, "Review PERFORMANCE aspects of PR for .claude/tasks/{task-folder}

   Scope: ONLY changes from git diff main...HEAD

   Focus on:
   - Database query efficiency (N+1 queries, missing indexes)
   - Bottlenecks and scalability issues
   - Memory leaks or excessive allocations
   - Caching opportunities
   - Algorithm complexity

   Use confidence scoring (0-100). Only report issues ≥ 80.
   Provide file:line references and concrete fixes.")
   ```

   **Testing Reviewer**:
   ```
   Task(code-reviewer, "Review TESTING aspects of PR for .claude/tasks/{task-folder}

   Scope: ONLY changes from git diff main...HEAD

   Focus on:
   - Test coverage for new/changed code
   - Missing edge cases
   - Test quality and maintainability
   - Error case coverage

   Use confidence scoring (0-100). Only report issues ≥ 80.
   Provide file:line references and concrete fixes.")
   ```

   **Compliance Reviewer**:
   ```
   Task(code-reviewer, "Review COMPLIANCE aspects of PR for .claude/tasks/{task-folder}

   Scope: ONLY changes from git diff main...HEAD

   Focus on:
   - Best practices from .claude/best-practices/ (if exists)
   - Code quality standards
   - Naming conventions and style
   - Documentation completeness

   Use confidence scoring (0-100). Only report issues ≥ 80.
   Provide file:line references and concrete fixes.")
   ```

2. **Wait for all 4 subagents to complete** (parallel execution)

3. **Synthesize findings**:
   - Collect all 4 review reports
   - Remove duplicate issues
   - Organize by severity: Critical (≥90), Important (80-89)
   - Combine into unified review

---

### Option C: Agent Teams (RECOMMENDED for 15+ files or critical production)

**When**: Large PRs, critical production code, requires collaborative review

**Recommendation to User** (use AskUserQuestion):
```json
{
  "questions": [{
    "question": "This PR changes {N} files in critical production code. How should we review it?",
    "header": "Review mode",
    "multiSelect": false,
    "options": [
      {
        "label": "Agent team review (Recommended)",
        "description": "4 teammate reviewers with inter-agent communication. Teammates challenge each other's findings for maximum thoroughness. ~70K tokens. Best for critical code."
      },
      {
        "label": "Parallel reviewers",
        "description": "4 specialized subagents review in parallel. Comprehensive but no inter-reviewer communication. ~45K tokens. Good balance of thoroughness and cost."
      },
      {
        "label": "Single reviewer",
        "description": "One code-reviewer handles all aspects. Faster and lower cost (~10K tokens), but may miss issues in large PRs."
      }
    ]
  }]
}
```

**If Agent Teams chosen**:

1. Create agent team:
   ```
   Create an agent team to review PR for .claude/tasks/{task-folder}

   Team structure:
   - Lead: Synthesize findings and create final review report
   - Teammate 1: Security reviewer - authentication, authorization, input validation, data exposure
   - Teammate 2: Performance reviewer - bottlenecks, queries, scalability, memory issues
   - Teammate 3: Testing reviewer - coverage, edge cases, test quality, error handling
   - Teammate 4: Compliance reviewer - best practices from .claude/best-practices/, code quality, conventions

   Each reviewer should:
   1. Read changed files from git diff main...HEAD
   2. Analyze code for issues in their domain ONLY
   3. Use confidence scoring (0-100), report only issues ≥ 80
   4. Provide file:line references and concrete fixes
   5. Broadcast significant findings to other teammates
   6. Consider findings from other reviewers for cross-domain insights

   Load best practices from .claude/best-practices/ before reviewing.

   Use Sonnet model for all teammates.
   ```

2. **Lead synthesizes** unified review report with collaborative insights

---

### After Review (All Options)

3. **Present findings to user and ask what they want to do**:
   - Fix critical issues now
   - Fix all issues now
   - Proceed as-is

---

## Phase 4: Generate Report

**Goal**: Document review findings from chosen execution pattern

**Actions**:
1. **Synthesize findings** (if parallel subagents or agent teams used):
   - Collect all reviewer reports
   - Remove duplicate issues (same file:line and description)
   - Organize by severity
   - For agent teams: Include cross-domain insights from teammate collaboration

2. Save report to `.claude/tasks/{task-folder}/review.md`:

```markdown
# Code Review

**Date**: {date}
**Review Pattern**: {Single Reviewer | Parallel Subagents (4) | Agent Team (4 teammates)}
**Status**: {pass|warning|fail}

## Summary

- Requirements: {X}/{Y} met
- Best practices: {compliant|violations found}
- High-confidence issues: {count}
- Changed files: {count}

## Automated Checks

- Lint: {pass/fail}
- Typecheck: {pass/fail}
- Tests: {pass/fail}

## Issues

### Critical (confidence ≥ 90)

[{confidence}] **{domain}** {file}:{line} - {description}
- {why it matters}
- Fix: {concrete suggestion}

### Important (confidence ≥ 80)

[{confidence}] **{domain}** {file}:{line} - {description}
- {why it matters}
- Fix: {concrete suggestion}

## Cross-Domain Insights

{Only if agent teams used - insights from collaborative review}

## Recommendations

1. {action item}
2. {action item}
```

**Note**: For parallel subagents/agent teams, add domain labels (Security, Performance, Testing, Compliance) to each issue for clarity.

---

## Phase 5: Summary

**Goal**: Report and handle fixes

**Actions**:
1. Mark all todos complete
2. Show summary:
   ```
   Review Complete: .claude/tasks/{task-folder}/review.md

   Pattern: {Single Reviewer | Parallel Subagents (4) | Agent Team (4 teammates)}
   Status: {pass|warning|fail}
   Issues: {critical} critical, {important} important

   {If parallel/team: Domains reviewed: Security, Performance, Testing, Compliance}

   Top issues:
   - {issue 1}
   - {issue 2}
   - {issue 3}
   ```

3. If user chose to fix issues:
   - Create TodoWrite with each fix
   - Implement fixes one by one
   - Re-run `/checks` after each fix

---

## Execution Pattern Selection Guide

**For reference during Phase 0 analysis:**

| Changed Files | Characteristics | Recommended Pattern | Token Cost |
|---------------|----------------|-------------------|------------|
| < 5 files | Simple changes | Single Reviewer | ~10K |
| 5-15 files | Medium complexity | **Parallel Subagents** ⭐ | ~45K |
| 15+ files | Large PR | Agent Teams | ~70K |
| Any size | Critical production (payments, auth, security) | Agent Teams | ~70K |
| Any size | Security-sensitive code | Parallel Subagents or Teams | ~45-70K |

**Key Decision Factors**:
- **Single Reviewer**: Fast, low cost, sufficient for routine changes
- **Parallel Subagents**: Best balance - 4 specialized reviews in parallel, no inter-reviewer communication needed
- **Agent Teams**: Maximum thoroughness - reviewers challenge each other, best for critical code
