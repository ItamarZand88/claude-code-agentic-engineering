---
description: Generate project coding best practices from PR comments and codebase analysis
argument-hint: [owner/repo]
---

# Best Practices Generator

Generate coding best practices by combining **PR review comments** with **codebase pattern analysis**.

## Input

Arguments: $ARGUMENTS

If no repo provided, detect from current git remote.

---

## Phase 1: Setup

**Actions**:
1. Create todo list tracking all phases
2. Detect repository owner/name:
   ```bash
   gh repo view --json owner,name
   ```
3. Create output directory: `.claude/best-practices/`

---

## Phase 2: Extract PR Comments

**Goal**: Gather real team feedback from code reviews

**Actions**:
1. Run the extraction script (auto-sorts results):
   ```bash
   bash plugin/skills/best-practices-extractor/scripts/incremental_update.sh {OWNER} {REPO}
   ```

2. Read the summary:
   ```
   Read(".claude/pr-review-comments/sorted/summary.json")
   ```

3. Identify top directories with most comments and read their feedback:
   ```
   Read(".claude/pr-review-comments/sorted/{top-dir}/comments.json")
   ```

4. Categorize patterns found:
   - Naming conventions
   - Error handling
   - Type safety
   - Code organization
   - Testing practices
   - Performance concerns
   - Security issues

---

## Phase 3: Analyze Codebase Patterns

**Goal**: Discover established conventions from existing code

**Actions**:
1. **Spawn codebase-analyst sub-agent** to discover patterns:

   ```
   Use the Task tool with:
   - subagent_type: "agi:codebase-analyst"
   - prompt: "Analyze this codebase to discover coding patterns and conventions. Focus on:
     1. Naming conventions (variables, functions, classes, files, directories)
     2. File organization (imports order, exports, module structure)
     3. Error handling approaches (try/catch patterns, error types, logging)
     4. Type patterns (interfaces vs types, generics usage, utility types)
     5. Testing patterns (test file naming, assertion styles, mocking approaches)
     6. Common abstractions (utilities, hooks, helpers, base classes)

     Sample 20-30 files across different directories. Return findings as structured patterns with examples."
   ```

2. Also check existing configs:
   ```
   Read("eslint.config.js") or Read(".eslintrc.js")
   Read(".prettierrc") or Read("prettier.config.js")
   Read("tsconfig.json")
   ```

---

## Phase 4: Generate Documentation

**Goal**: Create best practices files combining both sources

**Actions**:
1. Merge findings from:
   - PR comment patterns (Phase 2)
   - Codebase patterns (Phase 3)
   - Config files

2. Generate category files in `.claude/best-practices/`:

**README.md** (index):
```markdown
# Coding Best Practices

Auto-generated from PR review comments and codebase analysis.

## Categories
- [Naming Conventions](naming-conventions.md)
- [Error Handling](error-handling.md)
- [Type Safety](type-safety.md)
- [Code Organization](code-organization.md)
- [Testing](testing.md)

## Sources
- PR Comments: {N} analyzed
- Codebase: {M} files sampled
- Generated: {date}
```

**Category files** (e.g., `naming-conventions.md`):
```markdown
# Naming Conventions

## 1. {Guideline Title}

**Guideline:** {Clear statement}

**Why:** {Reasoning}

**Example:**
```typescript
// Good
{good_example}

// Bad
{bad_example}
```

**Source:** PR #{number} / Codebase pattern
```

---

## Phase 5: Summary

**Actions**:
1. Mark all todos complete
2. Report results:

```
Best Practices Generated: .claude/best-practices/

Sources:
- PR Comments: {N} PRs, {M} comments analyzed
- Codebase: {X} files sampled by codebase-analyst

Files created:
- README.md
- naming-conventions.md
- error-handling.md
- type-safety.md
- code-organization.md
- testing.md

Next: Review with team and commit to repository
```
