---
description: Automated code review and quality assessment against original requirements
argument-hint: <task_folder_path>
model: inherit
allowed-tools: Read, Write, Glob, Grep, Bash, Task
---

# Implementation Quality Reviewer

## Instructions

<instructions>
**Purpose**: Conduct comprehensive code review and quality assessment against requirements.

**Core Principles**:
- Validate implementation against acceptance criteria
- Use parallel agents for quality and compliance checks
- Provide actionable feedback with specific file:line references
- Assess code quality, security, and performance
- Generate comprehensive review report

**Key Expectations**:
- Requirements validation against ticket
- Automated quality checks (linting, type-check, formatting)
- Standards compliance verification
- Actionable recommendations
- Clear pass/fail status
</instructions>

## Variables

### Dynamic Variables (User Input)
- **task_folder_path**: `$ARGUMENTS` - Path to task folder (e.g., `Circle/oauth-authentication`)

### Static Variables
- **REVIEW_FILENAME**: `review.md` - Single comprehensive review file

### Derived Variables
- **ticket_path**: `{task_folder_path}/ticket.md`
- **plan_path**: `{task_folder_path}/plan.md`
- **review_path**: `{task_folder_path}/review.md`

## Workflow

### Step 1: Load Context & Validate Requirements

<step>
**Process**:
1. Load ticket.md, plan.md, run git diff
2. Extract acceptance criteria from ticket
3. Map implementation to criteria
4. Identify gaps/deviations

**Early Return**: If ticket/plan missing → STOP
</step>

### Step 2: Comprehensive Review with code-reviewer Agent

<step>
**Process**: Launch code-reviewer agent with consolidated review scope

**Agent Task**:
```
Use code-reviewer agent for comprehensive review of: {task_folder_path}

YOU MUST cover ALL aspects in a SINGLE review:

1. Requirements Validation:
   - Check all acceptance criteria from ticket.md
   - Note missing features or deviations

2. Code Quality Analysis:
   - Identify issues by severity (Critical/High/Medium/Low)
   - Check naming, organization, complexity
   - Review error handling patterns

3. Automated Checks (run these tools):
   - Linter: [detect and run project linter]
   - Type checker: [detect and run type checker]
   - Formatter: [check formatting]

4. Standards Compliance:
   - Check Circle/standards/ (if exists)
   - Verify architecture patterns
   - Validate coding conventions

5. Security & Performance:
   - Identify vulnerabilities
   - Find bottlenecks/optimization opportunities

Provide actionable recommendations with file:line references.
```
</step>

### Step 3: Generate Review Report

<step>
**Process**:
1. Consolidate all agent findings
2. Prioritize issues by severity
3. Save comprehensive review.md with sections:
   - Executive Summary
   - Requirements Compliance
   - Code Quality Issues (by severity)
   - Security & Performance
   - Action Items
</step>

## Control Flow

<control_flow>
1. Load context → IF missing files → STOP
2. Launch code-reviewer agent (consolidated review)
3. Generate review.md → Display summary
</control_flow>

## Report

<report>
```
✅ Review completed: Circle/{task-name}/review.md

Quality: {score}/10 | Requirements: {X}/{Y} met | Issues: {critical} critical, {high} high

Key Issues:
- {Top issue 1 with file:line}
- {Top issue 2 with file:line}
- {Top issue 3 with file:line}

Next: Address issues in review.md
```
</report>
