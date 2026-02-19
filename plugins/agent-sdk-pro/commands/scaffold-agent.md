---
description: Scaffold a new TypeScript Agent SDK runner in the current project — generates the runner class, types file, constants, and hooks directory with working examples
argument-hint: [agent-name]
allowed-tools: Read, Write, Bash, Glob
---

You are scaffolding a new TypeScript Agent SDK runner. Use the sdk-typescript-patterns, sdk-hooks-development, and sdk-agent-control skills to guide your implementation.

## Step 1: Gather context

Read the following to understand the project:
1. `package.json` — check SDK version, project structure, DI framework (inversify?), package manager
2. `tsconfig.json` — understand module settings
3. Look for an existing `src/services/` or similar directory to determine where to place the new agent

If `$ARGUMENTS` is provided, use it as the agent name (e.g., `code-reviewer` → `CodeReviewerAgent`).
If not provided, ask the user: "What should the agent be called? (e.g., code-reviewer, data-processor)"

## Step 2: Determine structure

Ask the user:
1. "Where should I create the agent? (default: `src/services/<agent-name>/`)"
2. "What tools should the agent have access to? (default: Read, Write, Edit, Bash, Glob, Grep)"
3. "Does your project use a DI framework like Inversify?" (check package.json for `inversify`)
4. "What should this agent do? (brief description — this becomes the system prompt)"

## Step 3: Scaffold the files

Create the following files in the agent directory:

### `<agent-name>.const.ts`
```typescript
/**
 * <AgentName> Constants
 */
export const SDK_MODEL = "claude-sonnet-4-5-20250929" as const;
export const SDK_MAX_BUDGET_USD = 2;
export const SDK_MAX_TURNS = 50;
export const SDK_PERMISSION_MODE = "bypassPermissions" as const;
export const SDK_ALLOWED_TOOLS = ["Read", "Write", "Edit", "Bash", "Glob", "Grep"] as const;
export const isSdkVerboseLogging = false;
```

### `types.ts`
Single point of contact for all SDK imports — re-export types and add type guards:
```typescript
export type { HookCallback, HookInput, HookJSONOutput, Options, PostToolUseHookInput, PreToolUseHookInput, SDKMessage, SDKResultMessage } from "@anthropic-ai/claude-agent-sdk";
export { query } from "@anthropic-ai/claude-agent-sdk";
// Type guards: isResultMessage, isPreToolUseInput, isPostToolUseInput
// Helpers: getToolInputFilePath, getToolInputCommand, getExecOutput
```

### `hooks/index.ts`
Barrel export for all hooks:
```typescript
export { envProtectionHook } from "./env-protection-hook";
export { createFileRestrictionHook } from "./file-restriction-hook";
```

### `hooks/env-protection-hook.ts`
A PreToolUse hook blocking .env file reads.

### `hooks/file-restriction-hook.ts`
A PreToolUse factory hook restricting writes to a specific file.

### `<agent-name>-runner.ts`
The main runner class with:
- `query()` call with proper options
- Message iteration with `isResultMessage` guard
- AbortSignal forwarding
- Hook composition
- Run result type with `code`, `costUsd`

## Step 4: Verify

Run type checking after creating files:
```bash
npx tsc --noEmit
```

Fix any TypeScript errors before finishing.

## Step 5: Report

Show the user:
- Files created and their purposes
- How to use the new runner
- The hook strategy implemented
- Next steps: customize system prompt, add more hooks, adjust tool list

## Important

- Use `@injectable()` and `@inject()` if the project uses Inversify
- Follow the single-point-of-contact pattern for all SDK type imports
- Always check `signal.aborted` at the start of each hook
- Use factory functions for parameterized hooks
- Include JSDoc comments on all exported functions
