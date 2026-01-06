---
description: Run all code quality checks (TypeScript, Prettier, Lint)
argument-hint:
model: inherit
allowed-tools: Bash
---

# Code Quality Checks

Run TypeScript type checking, Prettier formatting check, ESLint, tests, and build validation.

Output: `🔧 Running Quality Checks`

## Instructions

Run all available quality checks. Try standard npm scripts with fallbacks for different project setups:

<example>
# TypeScript type checking (try multiple variants)
Bash("npm run typecheck || npm run check:ts || npm run type-check || echo 'No typecheck script found'")

# Prettier formatting check
Bash("npm run format:check || npm run check:prettier || npm run prettier:check || echo 'No prettier check script found'")

# ESLint
Bash("npm run lint || npm run check:lint || npm run eslint || echo 'No lint script found'")

# Tests (if available)
Bash("npm run test || npm t || echo 'No test script found'")

# Build validation
Bash("npm run build || echo 'No build script found'")
</example>

Report results clearly with ✅ PASS or ❌ FAIL for each check.

Show comprehensive results:
```
┌─────────────────────────────────────────────┐
│ 🔧 Quality Checks Complete                  │
├─────────────────────────────────────────────┤
│ Overall: {✅ ALL PASS|⚠️ WARNINGS|❌ FAILED}│
│ Passed: {N}/5                               │
└─────────────────────────────────────────────┘

| Check | Status | Details |
|-------|--------|---------|
| TypeScript | ✅ PASS | No errors |
| Prettier   | ✅ PASS | All files formatted |
| ESLint     | ❌ FAIL | 3 errors, 2 warnings |
| Tests      | ✅ PASS | 24/24 passed |
| Build      | ✅ PASS | No build errors |

❌ Issues Found:
ESLint:
  - src/config.ts:12 - Missing semicolon
  - src/routes.ts:45 - Unused variable 'token'
  - src/auth.tsx:23 - Missing prop types

⚡ Quick Fixes:
  npm run lint:fix  ← Fix ESLint issues automatically
```
