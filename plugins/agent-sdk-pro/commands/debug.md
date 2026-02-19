---
description: Diagnose issues with a TypeScript Agent SDK project — checks SDK installation, TypeScript config, hook implementations, common runtime errors, and provides targeted fixes
argument-hint: [issue-description]
allowed-tools: Read, Bash, Glob, Grep
---

You are diagnosing issues with a TypeScript Agent SDK project. Systematically check each area and report findings.

## Check 1: SDK Installation

```bash
npm list @anthropic-ai/claude-agent-sdk
```

Look for:
- Package installed and at a recent version
- No `UNMET PEER DEPENDENCY` errors
- Package type set to `"module"` in package.json

## Check 2: TypeScript Configuration

Read `tsconfig.json`. Verify:
- `"module"` is `"ESNext"` or `"NodeNext"` (required for ES modules)
- `"moduleResolution"` is `"bundler"`, `"node16"`, or `"nodenext"`
- `"target"` is ES2020 or later
- `"strict"` is true (recommended)

Run type checking:
```bash
npx tsc --noEmit 2>&1
```

Report all errors with their TS codes.

## Check 3: Import Pattern

Grep for SDK imports across the project:
```
Grep for: "@anthropic-ai/claude-agent-sdk"
```

Check:
- Are imports centralized in a `types.ts` file? (best practice)
- Are there scattered imports across multiple files? (anti-pattern — consolidate)
- Is `query` imported correctly?
- Are `HookCallback` and `HookJSONOutput` imported from the right place?

## Check 4: Hook Implementation Audit

Find all hook files:
```
Glob: **/hooks/*.ts
```

For each hook, verify:
1. Starts with `if (signal.aborted) return {};`
2. Has a type guard (`isPreToolUseInput` or `isPostToolUseInput`)
3. Returns `{}` for non-applicable cases
4. Uses `getToolInputFilePath` / `getToolInputCommand` helpers instead of direct `input.tool_input` access
5. `permissionDecision` uses `"allow"` or `"deny"` (not `"approve"` — common mistake)
6. PostToolUse hooks use `input.hook_event_name` for `hookEventName` field

## Check 5: query() Options Audit

Find the `query()` call:
```
Grep for: "query("
```

Read the runner file and check:
- `abortController` is created and passed correctly
- External `abortSignal` is forwarded via event listener
- `hooks` matchers use `|` not `,` for multiple tools (e.g., `"Write|Edit"` not `"Write,Edit"`)
- `permissionMode` is either `"default"` or `"bypassPermissions"` (not other values)
- `maxTurns` and `maxBudgetUsd` are set as safety rails

## Check 6: Common Runtime Issues

Based on `$ARGUMENTS` (the issue description), also check:

**"Agent runs forever"** → `maxTurns` missing or too high; `Stop` condition in system prompt unclear
**"Hook not firing"** → matcher wrong (case-sensitive: "Write" not "write"); hook array not passed to correct event
**"Permission denied errors"** → `permissionMode` not set to `"bypassPermissions"` for automated pipeline
**"Type errors in hooks"** → `HookCallback` return type mismatch; missing `hookEventName` field
**"Cost too high"** → `maxBudgetUsd` not set; system prompt too vague causing excessive turns
**"Agent writes wrong file"** → `createFileRestrictionHook` not registered; matcher doesn't include "Write"
**"additionalContext not showing"** → PostToolUse hook output format: needs `hookSpecificOutput.additionalContext`, not `systemMessage`

## Report Format

Provide a structured diagnosis:

**Status**: HEALTHY | ISSUES FOUND | CRITICAL

**Issues Found** (if any):
- [CRITICAL] Description + fix
- [WARNING] Description + recommendation
- [INFO] Observation

**Fixes Applied** (if you made changes):
- What was changed and why

**Next Steps**:
- What to test after fixes
- Relevant skill to consult: sdk-typescript-patterns, sdk-hooks-development, or sdk-agent-control
