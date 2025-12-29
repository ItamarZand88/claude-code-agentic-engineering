# New Features: Incremental Updates & /4_review Integration

## Overview

This document describes two major enhancements to the `code-standards` skill:

1. **Incremental Update Mechanism** - Fetch only new PRs since last update
2. **/4_review Integration** - Automatic best practices compliance checking

---

## Feature 1: Incremental Updates

### What It Does

Instead of re-processing all PRs every time, the incremental update mechanism tracks when you last ran the extraction and only fetches NEW PRs merged since then.

### Why It Matters

**Before:**
- Full extraction processes 100+ PRs
- Takes 5-10 minutes every time
- Discouraged regular updates

**After:**
- Incremental update processes only 3-5 new PRs
- Takes 10-30 seconds
- Enables weekly/daily updates

### How to Use

#### First Run (Full Extraction)

```bash
cd skills/code-standards
bash scripts/incremental_update.sh earlyai backend
```

Output:
```
🆕 No previous update found for this repository
   Running FULL extraction...

Done! Extracted 450 comments from 100 PRs
✅ State saved. Next run will be incremental.
```

#### Subsequent Runs (Incremental)

```bash
bash scripts/incremental_update.sh earlyai backend
```

Output:
```
📅 Last update: 2025-12-20T10:00:00Z
   Fetching only NEW PRs merged after this date...

📊 Found 3 new merged PRs

  ✓ PR #1234: 5 comments
  ✓ PR #1235: 2 comments

✅ Incremental Update Complete

📈 Statistics:
   New PRs processed: 3
   Comments extracted: 7

💾 State updated. Next run will start from: 2025-12-28T10:30:00Z
```

### State Tracking

State is stored in `skills/code-standards/.state.json`:

```json
{
  "version": "1.0.0",
  "repos": {
    "earlyai/backend": {
      "last_update": "2025-12-28T10:30:00Z",
      "total_prs_processed": 103,
      "total_comments_collected": 457,
      "update_count": 4
    }
  }
}
```

### Benefits

✅ **10x faster updates** - Process only new PRs
✅ **Regular best practices** - Update weekly without pain
✅ **Historical tracking** - Know when last updated
✅ **Cumulative stats** - Track total PRs/comments processed

---

## Feature 2: /4_review Integration

### What It Does

When you run `/4_review`, it automatically:

1. Checks if `.claude/best-practices/` exists
2. Loads ALL best practices documents
3. Maps changed files to relevant categories
4. Validates code against applicable guidelines
5. Reports violations with specific references
6. Calculates compliance score

### Why It Matters

**Before:**
- Best practices were documentation only
- Manual checking required
- Inconsistent enforcement

**After:**
- Automatic validation during code review
- Specific violations with file:line references
- Measurable compliance percentage
- Links to specific guidelines

### How It Works

#### Step 1: Generate Best Practices

```bash
/best-practices
# or
cd skills/code-standards
bash scripts/incremental_update.sh earlyai backend
```

This creates:
```
.claude/best-practices/
├── README.md
├── naming-conventions.md
├── error-handling.md
├── type-safety.md
└── testing.md
```

#### Step 2: Run Review with Integration

```bash
/4_review .claude/tasks/add-user-auth
```

The review will:

1. **Check for best practices**
   ```
   ✅ Best practices found - will validate compliance
   📚 Found 5 best practices documents
   ```

2. **Load all category files**
   - naming-conventions.md
   - error-handling.md
   - type-safety.md
   - testing.md
   - security.md

3. **Map files to categories**
   ```
   Changed files:
     - src/api/auth.ts → api-design, error-handling, security, type-safety
     - src/utils/jwt.ts → error-handling, security, type-safety
     - tests/auth.test.ts → testing, naming-conventions
   ```

4. **Validate and report**

#### Step 3: Review Output

The review report (`.claude/tasks/{task}/review.md`) includes:

```markdown
# Code Review

**Date**: 2025-12-28
**Quality**: 8/10
**Best Practices Compliance**: 85% (17/20 guidelines)
**Status**: Warning

## Best Practices Compliance

**Overall Compliance**: 85% (17/20 guidelines checked)

### ✅ Compliant Guidelines

- **Naming Conventions** (naming-conventions.md #1-5)
  - All functions use camelCase
  - All interfaces use PascalCase
  - File names match exports

- **Error Handling** (error-handling.md #1, #2, #4)
  - Try-catch blocks present
  - Error messages are descriptive
  - Errors are logged properly

### ❌ Violations

#### High Severity

- **Type Safety Violation** (type-safety.md #3)
  - **File**: src/api/auth.ts:45
  - **Issue**: Using `any` type instead of specific interface
  - **Guideline**: "Avoid using 'any' type. Create specific interfaces."
  - **Fix**: Define AuthRequest interface

  ```typescript
  // Current (violates guideline)
  function authenticate(req: any) { ... }

  // Expected (follows guideline)
  interface AuthRequest {
    email: string;
    password: string;
  }
  function authenticate(req: AuthRequest) { ... }
  ```

#### Medium Severity

- **Naming Convention** (naming-conventions.md #7)
  - **File**: src/utils/jwt.ts:12
  - **Issue**: Function name `doStuff` is too generic
  - **Guideline**: "Use descriptive, intention-revealing names"
  - **Suggested**: `generateAccessToken`

## Recommendations

1. **Immediate**: Fix type safety violation (src/api/auth.ts:45)
2. **Short-term**: Rename generic function names
3. **Overall**: Strong compliance with most best practices
```

### File-to-Category Mapping

The system automatically maps file types to relevant best practices:

| File Pattern | Checked Categories |
|-------------|-------------------|
| `*.ts`, `*.tsx` | naming-conventions, error-handling, type-safety, code-organization |
| `*.test.ts` | testing, naming-conventions |
| `components/*.tsx` | react-patterns, performance, accessibility |
| `api/*.ts` | api-design, error-handling, security |
| `*.prisma`, `db/*.ts` | database-queries, security |

### Benefits

✅ **Automated enforcement** - No manual checking needed
✅ **Specific violations** - Exact file:line references
✅ **Clear fixes** - Code examples showing corrections
✅ **Measurable compliance** - Track improvement over time
✅ **Learning tool** - Developers learn best practices through violations
✅ **Consistent reviews** - Same standards applied every time

---

## Usage Examples

### Example 1: Weekly Best Practices Update

```bash
# Monday morning: Update best practices
cd skills/code-standards
bash scripts/incremental_update.sh earlyai backend

# Output: 5 new PRs, 12 new comments
# Time: 15 seconds

# Analyze and merge into best practices
# (Claude Code helps with this)
```

### Example 2: Feature Implementation with Review

```bash
# 1. Create ticket
/1_ticket "Add OAuth integration"

# 2. Plan implementation
/2_plan .claude/tasks/add-oauth-integration

# 3. Implement
/3_implement .claude/tasks/add-oauth-integration

# 4. Review with automatic best practices check
/4_review .claude/tasks/add-oauth-integration

# Review output includes:
# - Best Practices Compliance: 92% (23/25)
# - 2 violations found with fixes
# - Clear action items
```

### Example 3: First-Time Setup

```bash
# 1. Generate initial best practices
/best-practices

# 2. OR extract from PR comments
cd skills/code-standards
bash scripts/incremental_update.sh myorg myrepo

# 3. Sort comments by file tree
bash scripts/sort_comments_by_filetree.sh myrepo_inline_comments.ndjson

# 4. Analyze and create best practices
# (Claude Code analyzes pr-review-comments/ and generates .claude/best-practices/)

# 5. All future /4_review commands will use these practices
```

---

## Integration Points

### Commands Affected

- **`/4_review`** - Now includes automatic best practices validation
- **`/best-practices`** - Can use incremental updates for efficiency

### Agents Enhanced

- **`code-reviewer`** - Enhanced with detailed best practices validation instructions
  - Loads ALL .md files from .claude/best-practices/
  - Maps files to relevant categories
  - Reports violations with document references
  - Calculates compliance percentage

### Files Modified

1. **`skills/code-standards/scripts/incremental_update.sh`** (new)
   - Incremental PR comment extraction

2. **`skills/code-standards/.state.json`** (new)
   - State tracking for incremental updates

3. **`skills/code-standards/SKILL.md`** (updated)
   - Documentation for incremental updates

4. **`skills/code-standards/scripts/check_compliance.sh`** (new)
   - Helper script for compliance checking

5. **`skills/code-standards/review-integration-guide.md`** (new)
   - Comprehensive integration documentation

6. **`commands/4_review.md`** (updated)
   - Best practices checking in workflow
   - Enhanced report template

7. **`agents/code-reviewer.md`** (updated)
   - Load ALL best practices files
   - File-to-category mapping
   - Detailed violation reporting format

---

## Technical Details

### Incremental Update Algorithm

1. Check if `.state.json` exists
2. If yes: Read last update timestamp
3. Fetch PRs with GitHub search: `merged:>={timestamp}`
4. Process only returned PRs
5. Update state with new timestamp and stats

### Best Practices Validation Algorithm

1. Check if `.claude/best-practices/` directory exists
2. If yes:
   a. Run `check_compliance.sh` to list available practices
   b. Use `Glob()` to discover all .md files
   c. Read each discovered file
   d. Parse guidelines from markdown
   e. Get changed files from `git diff`
   f. For each changed file:
      - Determine file type (*.ts, *.test.ts, etc.)
      - Map to relevant best practice categories
      - Load applicable guidelines
      - Validate code against guidelines
      - Record violations with references
   g. Calculate compliance: (compliant / total) * 100
   h. Generate report section
3. If no: Add warning to report and continue

### State File Schema

```json
{
  "version": "1.0.0",
  "repos": {
    "{owner}/{repo}": {
      "last_update": "ISO8601 timestamp",
      "total_prs_processed": number,
      "total_comments_collected": number,
      "update_count": number
    }
  },
  "metadata": {
    "created_at": "ISO8601 timestamp",
    "description": "State tracking for incremental PR comment updates"
  }
}
```

---

## Troubleshooting

### Incremental Update Issues

**Issue**: Script always does full extraction

**Cause**: `.state.json` doesn't exist or is corrupted

**Fix**:
```bash
# Check state file
cat skills/code-standards/.state.json

# If corrupted, delete and re-run
rm skills/code-standards/.state.json
bash scripts/incremental_update.sh owner repo
```

---

**Issue**: GitHub API rate limit

**Cause**: Too many API calls

**Fix**: Wait for rate limit reset or reduce frequency

---

### Review Integration Issues

**Issue**: Best practices not being checked

**Check**:
```bash
# 1. Does directory exist?
ls -la .claude/best-practices/

# 2. Are there .md files?
find .claude/best-practices -name "*.md"

# 3. Try running compliance check manually
bash skills/code-standards/scripts/check_compliance.sh
```

**Fix**: Generate best practices first:
```bash
/best-practices
```

---

**Issue**: Too many false positives

**Fix**: Refine best practices documents to add context/exceptions

---

## Future Enhancements

Potential improvements for future versions:

1. **Auto-fix generation** - Automatically create fix patches
2. **Exemption system** - Allow files to opt-out of specific guidelines
3. **Compliance trends** - Track compliance over time with charts
4. **Multi-repo support** - Aggregate best practices across repositories
5. **PR comment integration** - Post compliance report as PR comment

---

## Feedback & Questions

For issues or suggestions, please:
- Open an issue on GitHub
- Update `.claude/best-practices/` with your team's standards
- Contribute improvements to the incremental update script

---

**Happy coding with automated best practices! 🚀**
