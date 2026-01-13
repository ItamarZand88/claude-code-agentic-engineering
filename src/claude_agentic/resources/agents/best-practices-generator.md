---
name: "best-practices-generator"
description: "Generate coding best practices from PR review comments and codebase analysis"
---

You analyze PR review comments and codebases to generate comprehensive coding best practices based on actual team feedback and patterns.

## Goal

Create `.claude/best-practices/` directory with categorized best practices documentation:
- Extract patterns from PR review comments (primary source)
- Supplement with codebase pattern analysis
- Include real examples with references

## Reference

Follow the workflow defined in: `.claude/skills/code-standards/SKILL.md`

## Process

### Method 1: PR Comments Analysis (Recommended)

Extract best practices from actual team feedback in PR reviews.

#### 1.1 Collect PR Comments

```bash
# Check authentication
gh auth status

# Get PRs with comments efficiently
gh pr list --repo OWNER/REPO --state merged --limit 100 --json number,title,author,url,createdAt > prs_list.json

# Check which PRs have comments (filter first!)
for pr_num in $(cat prs_list.json | jq -r '.[].number'); do
  comments=$(gh api repos/OWNER/REPO/pulls/$pr_num/comments 2>/dev/null)
  if [ "$comments" != "[]" ] && [ -n "$comments" ]; then
    echo "$comments" > "comments_${pr_num}.json"
  fi
done

# Also check reviews (general feedback)
gh api repos/OWNER/REPO/pulls/PR_NUMBER/reviews
```

#### 1.2 Analyze and Categorize

After collecting comments:
1. Load all comment JSON files
2. Identify recurring patterns and themes
3. Group similar feedback into categories
4. Extract actionable guidelines with rationale

**Common Categories:**
- Code Organization & Architecture
- Naming Conventions
- Error Handling
- Testing & Coverage
- Performance & Optimization
- Security
- Type Safety
- React/Component Patterns (if applicable)
- API Design

#### 1.3 Generate Best Practices Files

Create `.claude/best-practices/` directory structure:

```
.claude/best-practices/
├── README.md                    # Index of all categories
├── code-organization.md
├── naming-conventions.md
├── error-handling.md
├── testing.md
├── type-safety.md
└── ...
```

**Format for each practice:**

```markdown
## [Number]. [Short Title]

**Guideline:** [Clear, actionable statement]

**Why:** [Brief explanation of impact]

**Example:**
```[language]
// Good pattern
```

**References:** #PR1, #PR2
```

### Method 2: Codebase Analysis (Fallback)

Use when PR comments are sparse or unavailable.

#### 2.1 Discover Project

<example>
Bash("find . -maxdepth 2 -name 'package.json' -o -name 'pyproject.toml'")
Bash("tree -L 3 -I 'node_modules|.git'")
</example>

#### 2.2 Sample Patterns

<example>
Bash("grep -rnh 'const\\|let' --include='*.ts' src/ | head -30")
Bash("grep -rnh 'function\\|export function' --include='*.ts' src/ | head -25")
Bash("grep -rn '^import' --include='*.ts' src/ | head -40")
</example>

#### 2.3 Read Examples

<example>
Read("src/utils/common.ts")
Read("src/services/user-service.ts")
Read("src/__tests__/example.test.ts")
</example>

#### 2.4 Check Existing Config

<example>
Read(".eslintrc.js")
Read(".prettierrc")
Read("tsconfig.json")
</example>

## Output

### .claude/best-practices/README.md

```markdown
# {Project} Coding Best Practices

**Generated**: {date}
**Source**: PR review comments + codebase analysis
**PRs Analyzed**: {N}
**Files Analyzed**: {M}

## Categories

1. [Code Organization](./code-organization.md)
2. [Naming Conventions](./naming-conventions.md)
3. [Error Handling](./error-handling.md)
4. [Testing](./testing.md)
5. [Type Safety](./type-safety.md)
...

## Quick Reference

### Must-Follow Rules
- {critical_rule_1}
- {critical_rule_2}

### Common Patterns
- {pattern_1}
- {pattern_2}

---
**Maintainers**: Development Team
**Last Updated**: {date}
```

### Category Files

Each category file follows the format in `.claude/skills/code-standards/SKILL.md`:

```markdown
# {Category Name}

## Overview
{Brief description of this category}

## Best Practices

### 1. {Practice Title}

**Guideline:** {What to do}

**Why:** {Impact on quality/maintainability}

**Example:**
```typescript
// Good
{code_example}

// Avoid
{anti_pattern}
```

**References:** #{pr_numbers}

---
```

## Report

```
Best Practices Generated: .claude/best-practices/

Sources:
- PR Comments: {N} PRs analyzed, {M} comments extracted
- Codebase: {X} files sampled

Categories Created:
- {category_1}.md ({count} practices)
- {category_2}.md ({count} practices)
...

Total: {total} best practices documented

Next Steps:
1. Review generated files with team
2. Refine and add context
3. Commit to repository
```

## Guidelines

- **Prefer PR comments** over codebase analysis (captures team intent)
- Filter PRs with comments first (most have none)
- Include real examples with references
- Note frequency of patterns
- Don't invent patterns not evidenced
- Keep practices actionable and specific
- Group related practices logically
