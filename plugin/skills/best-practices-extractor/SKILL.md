---
name: best-practices-extractor
description: Extract and generate coding best practices from PR review comments and codebase analysis. Use when the user asks to "extract best practices", "analyze PR comments", "generate coding standards", or "update coding guidelines".
version: 2.0.0
---

# Best Practices Extractor

Generate `.claude/best-practices/` documentation by combining **PR review comments** with **codebase pattern analysis**.

## Quick Start

```bash
# Extract PR comments (auto-sorts by file tree)
bash plugin/skills/best-practices-extractor/scripts/incremental_update.sh OWNER REPO_NAME
```

First run does full extraction; subsequent runs fetch only new PRs. Comments are automatically sorted into `.claude/pr-review-comments/sorted/`.

## Two-Source Approach

Best practices should come from **two sources**:

### 1. PR Review Comments
Real team feedback from code reviews - captures what reviewers consistently flag.

**Output**: `.claude/pr-review-comments/sorted/` (organized by directory)

### 2. Codebase Patterns
Existing conventions in the code - captures established patterns.

**Action**: Spawn a **codebase-analyst sub-agent** to discover patterns:

```
Use the Task tool with subagent_type="agi:codebase-analyst" to analyze:
- Naming conventions (variables, functions, files, directories)
- File organization patterns (imports, exports, structure)
- Error handling approaches
- Testing patterns
- Type usage patterns
- Common abstractions and utilities
```

## Generating Best Practices

After gathering both sources:

1. **Analyze PR comments** - Read `.claude/pr-review-comments/sorted/summary.json` and directory comments
2. **Spawn codebase-analyst** - Discover patterns from actual code
3. **Merge findings** - Combine PR feedback with codebase patterns
4. **Generate documentation** - Create `.claude/best-practices/` files

### Output Structure

```
.claude/best-practices/
├── README.md              # Index of all categories
├── naming-conventions.md  # Variable, function, file naming
├── error-handling.md      # Error patterns, logging
├── type-safety.md         # TypeScript patterns
├── code-organization.md   # File structure, imports
├── testing.md             # Test patterns
└── {category}.md          # Additional categories from analysis
```

### Guideline Format

Each guideline should include:

```markdown
## [Number]. [Title]

**Guideline:** [Clear statement]

**Why:** [Impact explanation]

**Example:**
```typescript
// Good
{example}

// Bad
{counter_example}
```

**Source:** PR #{number} / Codebase pattern
```

## Prerequisites

- **GitHub CLI (`gh`)**: Authenticated - `gh auth status`
- **jq**: JSON processor - `jq --version`

## Integration

This skill **generates** best practices. The `code-reviewer` agent and `/agi:4_review` command **validate** code against them.
