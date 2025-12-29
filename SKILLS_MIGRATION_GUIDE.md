# Skills Migration Guide: code-standards → Split Skills

## Overview

The `code-standards` skill has been **split into two focused skills** for better organization and clarity:

1. **`best-practices-extractor`** - Extract and generate best practices from PR comments
2. **`code-compliance`** - Validate code against established best practices

This guide helps you migrate from the old monolithic skill to the new focused skills.

---

## Why the Split?

### Before: One Monolithic Skill ❌

```
code-standards/
├── Mixed concerns (extraction + validation)
├── Confusing triggers
├── Hard to understand purpose
└── Tightly coupled workflows
```

### After: Two Focused Skills ✅

```
best-practices-extractor/          code-compliance/
├── Single purpose: Extract        ├── Single purpose: Validate
├── Clear triggers                 ├── Clear triggers
├── Easy to understand             ├── Easy to understand
└── Independent evolution          └── Independent evolution
```

---

## Migration Path

### Option 1: No Action Required (Backwards Compatible)

The old `code-standards` skill **still works** and is maintained for backwards compatibility.

- All existing scripts continue to function
- Paths remain valid: `skills/code-standards/scripts/*`
- No immediate changes needed

**However**: The old skill is **deprecated** and will be removed in a future release.

### Option 2: Migrate to New Skills (Recommended)

Update your workflows to use the new focused skills.

---

## Quick Migration Reference

| Old Path | New Path | Purpose |
|----------|----------|---------|
| `skills/code-standards/scripts/extract_pr_comments.sh` | `skills/best-practices-extractor/scripts/extract_pr_comments.sh` | Extraction |
| `skills/code-standards/scripts/incremental_update.sh` | `skills/best-practices-extractor/scripts/incremental_update.sh` | Extraction |
| `skills/code-standards/scripts/sort_comments_by_filetree.sh` | `skills/best-practices-extractor/scripts/sort_comments_by_filetree.sh` | Extraction |
| `skills/code-standards/scripts/check_compliance.sh` | `skills/code-compliance/scripts/check_compliance.sh` | Validation |
| `skills/code-standards/review-integration-guide.md` | `skills/code-compliance/review-integration-guide.md` | Validation |
| `skills/code-standards/.state.json` | `skills/best-practices-extractor/.state.json` | Extraction |

---

## Step-by-Step Migration

### Step 1: Update Extraction Scripts

**Old Usage:**
```bash
cd skills/code-standards
bash scripts/incremental_update.sh owner repo
```

**New Usage:**
```bash
cd skills/best-practices-extractor
bash scripts/incremental_update.sh owner repo
```

**Migration:**
```bash
# Option A: Update your scripts/aliases
alias update-bp='cd skills/best-practices-extractor && bash scripts/incremental_update.sh'

# Option B: Copy state file (preserves history)
cp skills/code-standards/.state.json skills/best-practices-extractor/.state.json
```

### Step 2: Update Compliance Checks

**Old Usage:**
```bash
bash skills/code-standards/scripts/check_compliance.sh .claude/best-practices/
```

**New Usage:**
```bash
bash skills/code-compliance/scripts/check_compliance.sh .claude/best-practices/
```

**Migration:**
```bash
# Update any custom scripts or CI/CD configs
sed -i 's|skills/code-standards/scripts/check_compliance.sh|skills/code-compliance/scripts/check_compliance.sh|g' .github/workflows/*.yml
```

### Step 3: Update Documentation References

**Files to check:**
- Custom scripts
- CI/CD configurations (`.github/workflows/`, `.gitlab-ci.yml`)
- Pre-commit hooks (`.git/hooks/pre-commit`)
- Team documentation
- README files

**Find and replace:**
```bash
# Find all references to old path
grep -r "skills/code-standards" .

# Replace with new paths as appropriate
# - Extraction → best-practices-extractor
# - Validation → code-compliance
```

### Step 4: Update State File (Optional)

If you want to preserve your extraction history:

```bash
# Copy state file to new location
cp skills/code-standards/.state.json skills/best-practices-extractor/.state.json

# Verify it works
cd skills/best-practices-extractor
bash scripts/incremental_update.sh owner repo
# Should show: "Last update: ..." instead of first-time message
```

---

## Integration Points Already Updated

These have been automatically updated for you:

### ✅ `/4_review` Command

**Updated** to use `code-compliance` skill:

```bash
# Old (still works)
bash skills/code-standards/scripts/check_compliance.sh

# New (recommended)
bash skills/code-compliance/scripts/check_compliance.sh
```

### ✅ Documentation

- `NEW_FEATURES.md` - References new skills
- `SKILL_IMPROVEMENT_RECOMMENDATIONS.md` - Updated paths
- Command documentation - Updated references

---

## Skill-Specific Guides

### Using best-practices-extractor

**Purpose**: Generate `.claude/best-practices/` from PR comments

**Triggers**:
- "Extract best practices from repo X"
- "Update coding standards from PRs"
- "Analyze PR comments"

**Usage**:
```bash
cd skills/best-practices-extractor

# Incremental update (recommended)
bash scripts/incremental_update.sh owner repo

# Full extraction
bash scripts/extract_pr_comments.sh repo

# Sort by file tree
bash scripts/sort_comments_by_filetree.sh comments.ndjson
```

**Documentation**: `skills/best-practices-extractor/SKILL.md`

---

### Using code-compliance

**Purpose**: Validate code against `.claude/best-practices/`

**Triggers**:
- "Check code compliance"
- "Validate against best practices"
- Automatically used by `/4_review`

**Usage**:
```bash
# Automatic (recommended)
/4_review .claude/tasks/my-feature

# Manual check
bash skills/code-compliance/scripts/check_compliance.sh .claude/best-practices/

# Check specific files
bash skills/code-compliance/scripts/check_compliance.sh .claude/best-practices/ file1.ts file2.ts
```

**Documentation**: `skills/code-compliance/SKILL.md`

---

## Workflow Comparison

### Old Workflow

```
┌────────────────────────────────────┐
│  code-standards skill              │
│  (does everything)                 │
│                                    │
│  1. Extract from PRs               │
│  2. Generate best practices        │
│  3. Validate code                  │
│  4. Report violations              │
└────────────────────────────────────┘
```

### New Workflow

```
┌─────────────────────────────────────┐
│  best-practices-extractor           │
│  (content generation)               │
│                                     │
│  1. Extract from PRs                │
│  2. Generate best practices         │
│  → Output: .claude/best-practices/  │
└─────────────────────────────────────┘
              ↓
┌─────────────────────────────────────┐
│  code-compliance                    │
│  (content validation)               │
│                                     │
│  3. Load best practices             │
│  4. Validate code                   │
│  5. Report violations               │
└─────────────────────────────────────┘
```

---

## Common Migration Scenarios

### Scenario 1: Regular Best Practices Updates

**Old:**
```bash
cd skills/code-standards
bash scripts/incremental_update.sh earlyai backend
# Analyze and update best practices
```

**New:**
```bash
cd skills/best-practices-extractor
bash scripts/incremental_update.sh earlyai backend
# Same analysis and update process
```

**Change**: Just the directory path

---

### Scenario 2: Code Review with Compliance

**Old:**
```bash
/4_review .claude/tasks/my-feature
# Uses skills/code-standards/scripts/check_compliance.sh
```

**New:**
```bash
/4_review .claude/tasks/my-feature
# Automatically uses skills/code-compliance/scripts/check_compliance.sh
```

**Change**: None! Happens automatically

---

### Scenario 3: CI/CD Pipeline

**Old `.github/workflows/compliance.yml`:**
```yaml
- name: Check Compliance
  run: bash skills/code-standards/scripts/check_compliance.sh .claude/best-practices/
```

**New `.github/workflows/compliance.yml`:**
```yaml
- name: Check Compliance
  run: bash skills/code-compliance/scripts/check_compliance.sh .claude/best-practices/
```

**Change**: Update script path in CI/CD config

---

### Scenario 4: Pre-commit Hook

**Old `.git/hooks/pre-commit`:**
```bash
bash skills/code-standards/scripts/check_compliance.sh .claude/best-practices/
```

**New `.git/hooks/pre-commit`:**
```bash
bash skills/code-compliance/scripts/check_compliance.sh .claude/best-practices/
```

**Change**: Update script path in hook

---

## Benefits After Migration

### ✅ Clearer Purpose

**Before:**
> "Use code-standards skill to... extract? validate? both?"

**After:**
> "Use best-practices-extractor to extract, code-compliance to validate"

### ✅ Better Organization

```
skills/
├── best-practices-extractor/  ← Content generation
│   ├── Extraction scripts
│   ├── State tracking
│   └── References
└── code-compliance/           ← Content validation
    ├── Compliance checker
    └── Integration guide
```

### ✅ Independent Evolution

- Update extraction logic without affecting validation
- Add new compliance checks without touching extraction
- Different versioning and changelog

### ✅ Improved Reusability

- Use compliance checker even with manually-written best practices
- Extract best practices without using compliance checker
- Other tools can depend on just one skill

---

## Troubleshooting Migration

### Issue: State not preserved

**Problem**: After migration, incremental update runs full extraction

**Solution**:
```bash
# Copy state file
cp skills/code-standards/.state.json skills/best-practices-extractor/.state.json

# Verify
cat skills/best-practices-extractor/.state.json
```

### Issue: Scripts not found

**Problem**: CI/CD or custom scripts fail with "file not found"

**Solution**:
```bash
# Find all references
grep -r "skills/code-standards" .

# Update to new paths:
# - Extraction → best-practices-extractor
# - Compliance → code-compliance
```

### Issue: Compliance not working

**Problem**: /4_review doesn't check compliance

**Solution**:
```bash
# Verify /4_review command updated
grep "check_compliance.sh" commands/4_review.md

# Should show: skills/code-compliance/scripts/check_compliance.sh
```

---

## Timeline

- **Now**: Both old and new skills work
- **Next 3 months**: Migration period, deprecation warnings
- **6 months**: `code-standards` skill will be removed

**Recommendation**: Migrate soon to avoid disruption

---

## Questions?

- **Old skill still works?** Yes, for now (deprecated)
- **Must migrate immediately?** No, but recommended
- **Breaking changes?** No, backwards compatible
- **State preserved?** Yes, copy `.state.json`
- **CI/CD updates needed?** Yes, update script paths

---

## Quick Migration Checklist

```markdown
Migration Checklist:

### Extraction
- [ ] Update extraction script paths
- [ ] Copy .state.json to new location
- [ ] Test incremental update works
- [ ] Update documentation/aliases

### Compliance
- [ ] Verify /4_review works (auto-updated)
- [ ] Update CI/CD configs
- [ ] Update pre-commit hooks
- [ ] Test manual compliance checks

### Documentation
- [ ] Update team docs
- [ ] Update README if applicable
- [ ] Notify team of new paths
- [ ] Remove references to old skill

### Cleanup (optional, later)
- [ ] Remove skills/code-standards/ after migration
- [ ] Update any remaining references
- [ ] Celebrate cleaner architecture! 🎉
```

---

## Support

If you encounter issues during migration:

1. Check this guide for common scenarios
2. Review skill documentation:
   - `skills/best-practices-extractor/SKILL.md`
   - `skills/code-compliance/SKILL.md`
3. Open an issue on GitHub

---

**Happy migrating! The new focused skills provide better clarity and maintainability.** 🚀
