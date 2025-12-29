# Best Practices Review Integration Guide

## Overview

This guide explains how the `code-standards` skill integrates with the `/4_review` command to automatically validate code against project-specific best practices.

## How It Works

### 1. Best Practices Location

Generated best practices are stored in:
```
.claude/best-practices/
├── README.md                # Index of all categories
├── naming-conventions.md    # Naming standards
├── error-handling.md        # Error handling patterns
├── testing.md               # Testing best practices
├── type-safety.md           # TypeScript patterns
└── ...                      # Additional categories
```

### 2. Review Workflow

When `/4_review` is executed:

1. **Check for Best Practices**
   ```bash
   # Check if best practices exist
   if [ -d ".claude/best-practices" ]; then
       # Load and apply them
   fi
   ```

2. **Load Relevant Practices**
   - Identify changed files from git diff
   - Map files to relevant best practice categories
   - Load applicable guidelines

3. **Validate Code**
   - Check code against each applicable guideline
   - Report violations with file:line references
   - Provide specific best practice references

4. **Generate Compliance Report**
   - Include compliance score
   - List violations by severity
   - Reference specific best practices documents

## File Type → Best Practices Mapping

| File Pattern | Relevant Best Practices |
|-------------|------------------------|
| `*.ts`, `*.tsx` | naming-conventions, error-handling, type-safety, code-organization |
| `*.test.ts`, `*.spec.ts` | testing, naming-conventions |
| `*.jsx`, `*.js` | naming-conventions, error-handling, react-patterns |
| Components (`*.tsx` in `components/`) | react-patterns, performance, accessibility |
| API routes (`api/*.ts`) | api-design, error-handling, security |
| Database (`*.prisma`, `db/*.ts`) | database-queries, security |

## Review Output Format

### Compliance Section in review.md

```markdown
## Best Practices Compliance

**Overall Compliance**: 85% (17/20 guidelines checked)

### ✅ Compliant Guidelines

- **Naming Conventions** (naming-conventions.md #1-5)
  - All functions use camelCase
  - All components use PascalCase
  - File names match export names

- **Error Handling** (error-handling.md #2, #4)
  - Try-catch blocks present in async functions
  - Error messages are user-friendly

### ❌ Violations

#### High Severity

- **Type Safety Violation** (type-safety.md #3)
  - **File**: `src/api/users.ts:45`
  - **Issue**: Using `any` type instead of specific interface
  - **Guideline**: "Avoid using 'any' type. Create specific interfaces for data structures."
  - **Fix**: Define `UserCreateRequest` interface
  ```typescript
  // Current (violates guideline)
  function createUser(data: any) { ... }

  // Expected (follows guideline)
  interface UserCreateRequest {
    email: string;
    name: string;
  }
  function createUser(data: UserCreateRequest) { ... }
  ```

- **Error Handling Violation** (error-handling.md #5)
  - **File**: `src/components/Form.tsx:89`
  - **Issue**: Empty catch block suppresses errors
  - **Guideline**: "Always log errors and provide user feedback in catch blocks"
  - **Fix**: Add error logging and user notification

#### Medium Severity

- **Naming Convention** (naming-conventions.md #7)
  - **File**: `src/utils/helpers.ts:12`
  - **Issue**: Function name `getData` is too generic
  - **Guideline**: "Use descriptive, intention-revealing names"
  - **Suggested**: `fetchUserProfile` or `loadUserData`

### 📋 Recommendations

1. **Immediate**: Fix 2 high-severity violations (type safety, error handling)
2. **Next Sprint**: Address 3 medium-severity naming issues
3. **Consider**: Review and update best practices document if patterns are outdated
```

## Integration with code-reviewer Agent

The `code-reviewer` agent automatically performs best practices checking when invoked by `/4_review`.

### Agent Prompt Enhancement

The agent receives this context:

```xml
<best-practices>
<location>.claude/best-practices/</location>

<instruction>
If best practices exist in .claude/best-practices/:
1. Load all .md files from the directory
2. Parse guidelines from each document
3. For each changed file, determine relevant best practice categories
4. Check code against applicable guidelines
5. Report violations with:
   - File and line number
   - Specific guideline reference (document + number)
   - Quote of the violated guideline
   - Concrete fix example
6. Calculate compliance score
</instruction>

<output-format>
Include a "Best Practices Compliance" section in review.md with:
- Overall compliance percentage
- List of compliant guidelines (brief)
- List of violations (detailed with fixes)
- Recommendations for improvement
</output-format>
</best-practices>
```

## Example Review Session

```bash
# 1. User runs review
/4_review .claude/tasks/add-user-auth

# 2. System checks for best practices
Checking for best practices...
✅ Found 8 best practices documents in .claude/best-practices/

# 3. System identifies changed files
Analyzing git diff...
Changed files:
  - src/api/auth.ts (new)
  - src/middleware/auth.middleware.ts (new)
  - src/utils/jwt.ts (modified)

# 4. System maps files to best practices
Relevant best practices:
  - naming-conventions.md
  - error-handling.md
  - security.md
  - api-design.md
  - type-safety.md

# 5. code-reviewer agent analyzes
Running comprehensive review with best practices validation...

# 6. Generates report with compliance section
Saved: .claude/tasks/add-user-auth/review.md

Quality: 8/10
Best Practices Compliance: 90% (18/20)
Issues: 0 critical, 1 high, 2 medium
```

## Fallback Behavior

If no best practices exist:

```
⚠️  Best Practices Check Skipped

No best practices found in .claude/best-practices/

To generate best practices:
1. Run: /best-practices
2. Or use code-standards skill to extract from PR comments

Review will proceed without best practices validation.
```

## Testing the Integration

### Test 1: With Best Practices

```bash
# Generate best practices
/best-practices

# Create a task with known violations
echo "const x = (data: any) => { try { riskyOp() } catch {} }" > test.ts

# Run review
/4_review .claude/tasks/test-task

# Expected: Violations detected for:
# - any type usage
# - empty catch block
# - non-descriptive variable name
```

### Test 2: Without Best Practices

```bash
# Remove best practices
rm -rf .claude/best-practices

# Run review
/4_review .claude/tasks/test-task

# Expected: Warning shown, review proceeds without best practices check
```

## Updating Best Practices

To keep best practices current:

```bash
# Option 1: Full regeneration
/best-practices

# Option 2: Incremental update (if using code-standards skill)
bash skills/code-standards/scripts/incremental_update.sh earlyai backend

# Reviews will automatically use latest best practices
```

## Benefits

### For Developers

- ✅ Automatic enforcement of team standards
- ✅ Consistent code review feedback
- ✅ Learn best practices through violations
- ✅ Self-service compliance checking

### For Teams

- ✅ Codified team knowledge
- ✅ Reduced subjective code review debates
- ✅ Onboarding documentation
- ✅ Living, evolving standards

### For Quality

- ✅ Catches common issues early
- ✅ Maintains consistency across codebase
- ✅ Reduces technical debt
- ✅ Measurable compliance metrics

## Advanced Configuration

### Custom Best Practices Location

Modify `/4_review` command to use custom location:

```markdown
Read("{custom-path}/best-practices/")
```

### Selective Category Checking

Only check specific categories:

```bash
# In code-reviewer agent context
<categories-to-check>
  - naming-conventions
  - security
  - type-safety
</categories-to-check>
```

### Compliance Thresholds

Set minimum compliance scores:

```markdown
<compliance-requirements>
  - Minimum overall: 80%
  - Critical guidelines: 100%
  - High severity: 90%
</compliance-requirements>
```

## Troubleshooting

### Issue: Best practices not being checked

**Check:**
1. Does `.claude/best-practices/` exist?
2. Are there `.md` files in the directory?
3. Is the code-reviewer agent being invoked correctly?

**Solution:**
```bash
# Verify directory
ls -la .claude/best-practices/

# Regenerate if needed
/best-practices
```

### Issue: Too many false positives

**Solution:**
1. Review and refine best practices documents
2. Add context/exceptions to guidelines
3. Update examples to match current patterns

### Issue: Best practices are outdated

**Solution:**
```bash
# Incremental update from recent PRs
bash skills/code-standards/scripts/incremental_update.sh owner repo

# Regenerate best practices with new comments
# Merge with existing practices
```

## Future Enhancements

Planned improvements:

1. **Auto-fix suggestions** - Generate code patches for violations
2. **Severity levels** - Configure which guidelines are blocking vs. warning
3. **Exemptions** - Allow files to opt-out of specific guidelines
4. **Metrics dashboard** - Track compliance trends over time
5. **AI learning** - Learn from accepted/rejected violations
