---
name: best-practices-extractor
description: Extract and generate coding best practices from PR review comments. Use when you want to analyze PR comments from a repository to create best practices documentation, or update existing standards with new feedback. Triggers include "extract best practices from repo X", "analyze PR comments", "update coding standards", or "generate best practices from PRs".
---

# Best Practices Extractor

## Overview

This skill helps you build and maintain living documentation of your team's coding best practices by analyzing PR review comments. It extracts patterns from code review feedback, categorizes them, and generates structured markdown files that serve as reference documentation.

**Purpose**: Content Generation
**Output**: `.claude/best-practices/` directory with categorized best practices
**Complements**: `code-compliance` skill (which validates code against these practices)

## When to Use This Skill

### Initial Setup
- "Extract best practices from our repository"
- "Analyze PR comments in repo X and create coding standards"
- "Generate best practices documentation from code reviews"

### Regular Updates
- "Update best practices with new PR comments"
- "Refresh coding standards from recent reviews"
- "Incremental update of best practices"

## Extraction Workflows

### Workflow 1: Incremental Update (Recommended)

**Use for**: Regular updates to keep best practices current

```bash
# Navigate to skill directory
cd skills/best-practices-extractor

# Run incremental update
bash scripts/incremental_update.sh OWNER REPO_NAME

# Examples:
bash scripts/incremental_update.sh earlyai backend
bash scripts/incremental_update.sh myorg frontend
```

**What it does:**
- Tracks last update timestamp in `.state.json`
- Fetches only PRs merged since last update
- Much faster than full extraction (10-30 seconds vs 5-10 minutes)
- Automatically runs full extraction on first use
- Updates state with statistics

**First run behavior:**
```
🆕 No previous update found for this repository
   Running FULL extraction...

Done! Extracted 450 comments from 100 PRs
✅ State saved. Next run will be incremental.
```

**Subsequent runs:**
```
📅 Last update: 2025-12-20T10:00:00Z
   Fetching only NEW PRs merged after this date...

📊 Found 3 new merged PRs
  ✓ PR #1234: 5 comments
  ✓ PR #1235: 2 comments

✅ Incremental Update Complete
💾 State updated. Next run will start from: 2025-12-28T10:30:00Z
```

---

### Workflow 2: Full Extraction

**Use for**: First-time setup or comprehensive retrospectives

```bash
cd skills/best-practices-extractor

# Full extraction
bash scripts/extract_pr_comments.sh REPO_NAME

# Examples:
bash scripts/extract_pr_comments.sh backend
bash scripts/extract_pr_comments.sh vscode-extension
```

**What it does:**
- Fetches all PRs from repository
- Extracts all inline code review comments
- Outputs to `{REPO_NAME}_inline_comments.ndjson`
- Shows progress as it processes

**Output format (NDJSON - one JSON object per line):**
```json
{
  "repo": "backend",
  "owner": "earlyai",
  "pr_number": 1207,
  "file": "src/components/Dashboard.tsx",
  "line": 30,
  "author": "reviewer",
  "body": "Consider using a more descriptive variable name here",
  "created_at": "2025-12-24T08:55:51Z",
  "url": "https://github.com/earlyai/backend/pull/1207#discussion_r2645175276"
}
```

---

### Workflow 3: Sort Comments by File Tree

**Use for**: Organizing comments by directory structure

```bash
cd skills/best-practices-extractor

# Sort comments into folder structure
bash scripts/sort_comments_by_filetree.sh COMMENTS_FILE [REPO_PATH]

# Examples:
bash scripts/sort_comments_by_filetree.sh backend_inline_comments.ndjson /path/to/backend
bash scripts/sort_comments_by_filetree.sh vscode-extension_inline_comments.ndjson .
```

**What it creates:**
```
repo/pr-review-comments/
├── summary.json                    # Overall statistics
├── src/
│   ├── core/config/
│   │   └── comments.json           # Comments for this directory
│   ├── telemetry/
│   │   └── comments.json           # 23 comments
│   └── ...
```

**Each `comments.json` contains:**
```json
{
  "directory": "src/telemetry",
  "generated_at": "2025-12-28T...",
  "comment_count": 23,
  "files": ["src/telemetry/ai-cost-telemetry.service.ts"],
  "comments": [...]
}
```

**Benefits:**
- Identifies hotspots (files with most feedback)
- Finds patterns by module/directory
- Enables per-directory best practices
- Keeps review feedback alongside code

---

## Generating Best Practices

After extracting comments, analyze them to create best practices documentation:

### Step 1: Collect Comments

Use one of the workflows above to gather PR comments.

### Step 2: Analyze and Categorize

**Analysis Process:**

1. **Load the comments**
   - Read the NDJSON file or sorted directory structure
   - Extract comment bodies, file paths, and context

2. **Identify patterns**
   - Look for recurring themes across comments
   - Group similar feedback together
   - Note frequently mentioned issues

3. **Create categories**
   - Common categories: naming-conventions, error-handling, type-safety, testing, security, performance
   - See `references/default-categories.md` for examples
   - Create categories based on your project's actual patterns

4. **Extract actionable guidelines**
   - For each category, create clear best practices
   - Include rationale (why it matters)
   - Add code examples from comments
   - Reference specific PRs

### Step 3: Create Best Practices Files

**Directory structure to create:**
```
.claude/best-practices/
├── README.md                    # Index file
├── naming-conventions.md
├── error-handling.md
├── type-safety.md
├── testing.md
├── security.md
├── performance.md
└── ...
```

**Format for each guideline:**
```markdown
## [Number]. [Short Descriptive Title]

**Guideline:** [Clear, actionable statement]

**Why:** [Brief explanation of impact]

**Example:**
```[language]
// Good example
```

**References:** [PR numbers: #123, #456]
```

---

## Prerequisites

- **GitHub CLI (`gh`)**: Must be installed and authenticated
  - Check: `gh auth status`
  - Install: https://cli.github.com/

- **jq**: JSON processor for parsing data
  - Check: `jq --version`
  - Install: https://stedolan.github.io/jq/

**Windows-specific:**
- Git Bash or WSL recommended
- jq auto-detection includes common Windows paths

---

## State Management

### State File: `.state.json`

Tracks extraction history for incremental updates:

```json
{
  "version": "1.0.0",
  "repos": {
    "owner/repo": {
      "last_update": "2025-12-28T10:30:00Z",
      "total_prs_processed": 103,
      "total_comments_collected": 457,
      "update_count": 4
    }
  }
}
```

### Reset State

To start fresh:
```bash
rm .state.json
bash scripts/incremental_update.sh owner repo  # Will run full extraction
```

---

## Best Practices Maintenance

### When to Update

- **Initial Setup**: First time creating standards
- **Weekly/Monthly**: Regular updates with incremental script
- **After Major Changes**: When team or tech stack changes
- **New Team Members**: Refresh for onboarding

### Update Schedule Recommendations

| Team Size | Update Frequency |
|-----------|------------------|
| Small (2-5) | Monthly |
| Medium (6-15) | Bi-weekly |
| Large (16+) | Weekly |

### Quality Tips

1. **Focus on merged PRs** - Accepted patterns, not rejected ones
2. **Use reasonable limits** - 50-100 PRs balances coverage and noise
3. **Filter by author** - Start with experienced reviewers' feedback
4. **Review generated docs** - Validate with team before adoption
5. **Version control** - Commit best-practices/ to your repo

---

## Integration with Code Compliance

This skill **generates** best practices that the `code-compliance` skill **validates against**.

**Workflow:**
```bash
# 1. Extract best practices (this skill)
cd skills/best-practices-extractor
bash scripts/incremental_update.sh earlyai backend

# 2. Analyze and generate .claude/best-practices/ folder
# (Claude Code helps with this)

# 3. Validate code automatically (code-compliance skill)
/4_review .claude/tasks/my-feature
# → Automatically checks against .claude/best-practices/
```

---

## Troubleshooting

### Issue: GitHub API rate limit

**Solution:**
- Check rate limit: `gh api rate_limit`
- Wait for reset or reduce PR count
- Spread requests over time

### Issue: jq not found

**Solution:**
```bash
# macOS
brew install jq

# Ubuntu/Debian
sudo apt install jq

# Windows
winget install jqlang.jq
```

### Issue: No inline comments found

**Common:** Many teams don't use inline comments extensively.

**Alternatives:**
1. Check PR reviews (general feedback): `gh api repos/owner/repo/pulls/PR/reviews`
2. Check issue comments: `gh api repos/owner/repo/issues/PR/comments`
3. Analyze commit messages
4. Direct codebase analysis instead of PR comments

### Issue: Script permissions

**Solution:**
```bash
chmod +x scripts/*.sh
```

---

## Advanced Usage

### Filter by Author

```bash
# Modify script to add --author flag:
gh pr list --repo owner/repo --state merged --author username
```

### Filter by Date Range

```bash
# Modify script to use search:
gh pr list --repo owner/repo --search "merged:2024-01-01..2024-12-31"
```

### Multiple Repositories

```bash
# Extract from multiple repos
for repo in backend frontend mobile; do
  bash scripts/incremental_update.sh myorg $repo
done
```

---

## Output Examples

### Successful Incremental Update

```
╔════════════════════════════════════════╗
║  Incremental PR Comment Update         ║
╚════════════════════════════════════════╝

Repository: earlyai/backend

📅 Last update: 2025-12-20T10:00:00Z
   Fetching only NEW PRs merged after this date...

📊 Found 3 new merged PRs

🔍 Extracting comments from new PRs...

  ✓ PR #1234: 5 comments
  ✓ PR #1235: 2 comments

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅ Incremental Update Complete
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📈 Statistics:
   New PRs processed: 3
   Comments extracted: 7
   Output file: backend_inline_comments_incremental.ndjson

💾 State updated. Next run will start from: 2025-12-28T10:30:00Z
```

### No New PRs

```
📅 Last update: 2025-12-27T10:00:00Z
   Fetching only NEW PRs merged after this date...

✨ No new PRs found since last update
   Your best practices are up to date!
```

---

## Related Resources

- **Category Examples**: `references/default-categories.md`
- **Code Compliance**: Use `code-compliance` skill to validate against generated practices
- **Integration Guide**: See `/4_review` command for automatic validation

---

## Quick Reference

```bash
# Incremental update (recommended)
bash scripts/incremental_update.sh owner repo

# Full extraction
bash scripts/extract_pr_comments.sh repo

# Sort by file tree
bash scripts/sort_comments_by_filetree.sh comments.ndjson

# Reset state
rm .state.json
```

---

**Next Steps:**
1. Run extraction script to gather PR comments
2. Analyze comments and identify patterns
3. Generate `.claude/best-practices/` documentation
4. Use `code-compliance` skill for automatic validation
