---
description: Generate project coding best practices from PR comments or codebase analysis
argument-hint: [repo-name] [--from-prs | --from-code | --combined]
---

# Best Practices Generator

You are generating coding best practices documentation for the project. Extract patterns from PR review comments and/or codebase analysis to create actionable guidelines.

## Core Principles

- **Learn from real feedback**: PR review comments reflect actual team standards
- **Document with examples**: Every guideline should have code examples
- **Categorize clearly**: Group practices by type (naming, error handling, etc.)
- **Use TodoWrite**: Track progress through analysis

---

## Phase 1: Determine Source

**Goal**: Decide where to extract best practices from

Input: $ARGUMENTS

**Actions**:
1. Create todo list with phases
2. Determine mode from arguments:
   - `--from-prs` → Extract from PR review comments only
   - `--from-code` → Extract from codebase patterns only
   - `--combined` or no flag → Use both sources (recommended)

3. If repo name provided, use it. Otherwise use current repo.

---

## Phase 2: Extract from PR Comments (if applicable)

**Goal**: Gather patterns from actual team feedback

**Actions**:
1. Fetch recent PRs with review comments:
   ```
   gh pr list --state merged --limit 50 --json number,title
   gh api repos/{owner}/{repo}/pulls/{pr_number}/comments
   ```

2. Categorize feedback patterns:
   - Naming conventions
   - Error handling
   - Type safety
   - Code organization
   - Testing practices
   - Performance concerns
   - Security issues

3. Note frequency of each pattern (how often mentioned)

---

## Phase 3: Extract from Codebase (if applicable)

**Goal**: Identify established patterns in existing code

**Actions**:
1. Sample 20-30 files across the project:
   ```
   Glob("src/**/*.ts")
   Glob("src/**/*.tsx")
   ```

2. Analyze patterns:
   - Naming conventions (variables, functions, files)
   - File organization and structure
   - Import patterns
   - Error handling approaches
   - Testing patterns

3. Check existing configs:
   ```
   Read(".eslintrc.js") or Read("eslint.config.js")
   Read(".prettierrc")
   Read("tsconfig.json")
   ```

---

## Phase 4: Generate Documentation

**Goal**: Create structured best practices files

**Actions**:
1. Create directory: `.claude/best-practices/`

2. Generate files by category:

```
.claude/best-practices/
├── README.md              # Index with all categories
├── naming-conventions.md  # Variable, function, file naming
├── error-handling.md      # Try/catch, error types, logging
├── type-safety.md         # TypeScript patterns, avoid any
├── code-organization.md   # File structure, imports, exports
├── testing.md             # Test patterns, coverage
└── {other-categories}.md  # Based on findings
```

3. Each file should follow this format:
```markdown
# {Category Name}

## Guidelines

### 1. {Guideline Title}

**Rule**: {Clear statement}

**Why**: {Reasoning}

**Example**:
```typescript
// Good
{good_example}

// Bad
{bad_example}
```

**Source**: {PR #123 or "codebase pattern"}
```

---

## Phase 5: Summary

**Goal**: Report what was generated

**Actions**:
1. Mark all todos complete
2. Show summary:
   ```
   Best Practices Generated: .claude/best-practices/

   Sources:
   - PR Comments: {N} PRs, {M} comments analyzed
   - Codebase: {X} files sampled

   Categories: {count}
   Guidelines: {total} documented

   Files created:
   - README.md
   - {category}.md
   - ...

   Next: Review with team and commit
   ```
