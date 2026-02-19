---
description: Run all code quality checks (TypeScript, Prettier, Lint, Tests, Build)
argument-hint: [--fix]
---

# Code Quality Checks

Run all available quality checks for the project. Detects available scripts and runs them with clear pass/fail reporting.

## Core Principles

- **Try multiple variants**: Different projects use different script names
- **Report clearly**: Show pass/fail for each check
- **Continue on failure**: Run all checks even if some fail

---

## Process

**Goal**: Run all quality checks and report results

Input: $ARGUMENTS (optional --fix flag)

**Actions**:

1. **TypeScript type checking**:
   ```
   npm run typecheck || npm run check:ts || npm run type-check || tsc --noEmit
   ```

2. **Prettier formatting**:
   ```
   # If --fix flag provided
   npm run format || npm run prettier:fix || prettier --write .

   # Otherwise just check
   npm run format:check || npm run check:prettier || prettier --check .
   ```

3. **ESLint**:
   ```
   # If --fix flag provided
   npm run lint:fix || npm run eslint:fix || eslint . --fix

   # Otherwise just check
   npm run lint || npm run check:lint || eslint .
   ```

4. **Tests** (if available):
   ```
   npm run test || npm t
   ```

5. **Build validation** (if available):
   ```
   npm run build
   ```

---

## Output

Report results with clear status:

```
Quality Checks Complete

TypeScript: ✓ PASS
Prettier:   ✓ PASS
ESLint:     ✗ FAIL (3 errors)
  - src/index.ts:15 - no-unused-vars
  - src/utils.ts:42 - prefer-const
  - src/api.ts:8 - no-explicit-any
Tests:      ✓ PASS (24/24)
Build:      ✓ PASS

Overall: 4/5 passed

{If failures exist}
Run `/checks --fix` to auto-fix formatting and lint issues.
```
