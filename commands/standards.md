---
description: Generate project coding standards
argument-hint:
model: inherit
allowed-tools: Read, Write, Glob, Grep, Bash, Task
---

# Standards Generator

## Purpose

Analyze codebase and generate `Circle/standards/README.md`.

## Process

<example>
Task(standards-generator, "Analyze codebase and create standards:
- Sample 20-30 files
- Extract naming conventions
- Document patterns
- Include real examples with frequencies
- Save to Circle/standards/README.md")
</example>

## Report

```
✅ Standards: Circle/standards/README.md

Analyzed: {N} files
Patterns: {M} documented

Review and refine with team.
```
