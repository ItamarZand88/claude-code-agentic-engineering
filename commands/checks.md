---
description: Run all code quality checks (TypeScript, Prettier, Lint)
argument-hint:
model: inherit
allowed-tools: Bash
---

# Code Quality Checks

Run TypeScript type checking, Prettier formatting check, and ESLint across all workspaces using Turbo.

## Instructions

Run the following checks:

```bash
npm run check:ts
npm run check:prettier
npm run check:lint
```

Report results clearly with ✅ PASS or ❌ FAIL for each check.
