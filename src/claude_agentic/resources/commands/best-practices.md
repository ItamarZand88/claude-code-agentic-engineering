---
description: Generate project coding best practices
argument-hint: [repo-name] [--from-prs | --from-code]
model: inherit
allowed-tools: Read, Write, Glob, Grep, Bash, Task, SlashCommand
---

# Best Practices Generator

## Purpose

Generate `.claude/best-practices/` documentation from PR review comments and/or codebase analysis.

## Reference

Follow the workflow in: `.claude/skills/code-standards/SKILL.md`

## Process

### Option 1: From PR Comments (Recommended)

Extract best practices from actual team feedback:

<example>
# Use the code-standards skill
SlashCommand("/code-standards analyze PR comments from {repo}")

# Or manually with best-practices-generator agent
Task(best-practices-generator, "Generate best practices from PR comments:
- Collect PR review comments from {repo}
- Categorize feedback patterns
- Create .claude/best-practices/ directory
- Include examples and PR references")
</example>

### Option 2: From Codebase Analysis

When PR comments are unavailable:

<example>
Task(best-practices-generator, "Generate best practices from codebase:
- Sample 20-30 files across project
- Extract naming conventions
- Document patterns with frequencies
- Check ESLint/Prettier configs
- Save to .claude/best-practices/")
</example>

### Option 3: Combined (Most Comprehensive)

<example>
Task(best-practices-generator, "Generate comprehensive best practices:
1. Collect PR review comments (if available)
2. Analyze codebase patterns
3. Cross-reference with existing configs
4. Create .claude/best-practices/ with all findings")
</example>

## Output

```
.claude/best-practices/
├── README.md                    # Index
├── code-organization.md
├── naming-conventions.md
├── error-handling.md
├── testing.md
├── type-safety.md
└── ...
```

## Report

```
Best Practices Generated: .claude/best-practices/

Sources:
- PR Comments: {N} PRs, {M} comments
- Codebase: {X} files analyzed

Categories: {count}
Practices: {total} documented

Next: Review with team and commit
```
