---
description: Add a new TypeScript hook to an existing Agent SDK project — interactively guides you through hook type selection and generates the HookCallback implementation with proper typing
argument-hint: [hook-type] (PreToolUse|PostToolUse)
allowed-tools: Read, Write, Glob, Grep
---

You are adding a new TypeScript hook to an Agent SDK project. Use the sdk-hooks-development skill.

## Step 1: Understand the project

Find the existing hooks directory and types file:
- Glob for `**/hooks/index.ts` to find the hooks directory
- Read the existing hooks to understand patterns already in use
- Read `types.ts` to confirm `HookCallback` and helper functions are available

## Step 2: Ask what hook to create

Ask the user these questions **one at a time**:

**Q1**: "What event type should this hook handle?"
- PreToolUse — runs before a tool executes (can allow/deny)
- PostToolUse — runs after a tool completes (injects additionalContext)

**Q2**: "Which tool(s) should this hook match?"
- A specific tool: "Write", "Edit", "Bash", "Read"
- Multiple tools: "Write|Edit"
- All tools: "*"

**Q3**: "What should this hook do?" (free text description)
Examples:
- "Block writes to any file except the test file"
- "After Bash commands, remind the agent to check test results"
- "Block reading .env files"
- "Run eslint --fix after any Edit"
- "Deny writes to files outside the src/ directory"

**Q4** (if PreToolUse): "Is this a factory function (needs runtime params like a file path)?"
- Yes → creates `createXxxHook(params): HookCallback`
- No → creates `export const xxxHook: HookCallback`

## Step 3: Generate the hook file

Create the hook file in the `hooks/` directory following the exact pattern from sdk-hooks-development skill:

For **PreToolUse**:
```typescript
import path from "node:path";
import type { HookCallback, HookJSONOutput } from "../types";
import { getToolInputFilePath, isPreToolUseInput } from "../types";

export const myHook: HookCallback = async (input, _toolUseId, { signal }): Promise<HookJSONOutput> => {
  if (signal.aborted) return {};
  if (!isPreToolUseInput(input)) return {};
  // ... logic ...
  return {
    hookSpecificOutput: {
      hookEventName: "PreToolUse",
      permissionDecision: "deny",
      permissionDecisionReason: "Reason",
    },
  };
};
```

For **PostToolUse**:
```typescript
import type { HookCallback, HookJSONOutput } from "../types";
import { getToolInputCommand, isPostToolUseInput } from "../types";

export const myHook: HookCallback = async (input, _toolUseId, { signal }): Promise<HookJSONOutput> => {
  if (signal.aborted) return {};
  if (!isPostToolUseInput(input)) return {};
  // ... logic ...
  return {
    hookSpecificOutput: {
      hookEventName: input.hook_event_name,
      additionalContext: "...",
    },
  };
};
```

## Step 4: Update hooks/index.ts

Add the export for the new hook:
```typescript
export { myNewHook } from "./my-new-hook";
```

## Step 5: Show integration snippet

Show the user exactly how to add this hook to their `query()` call:

```typescript
import { myNewHook } from "./hooks";

// In query() options:
hooks: {
  PreToolUse: [
    { matcher: "Write|Edit", hooks: [myNewHook] },
  ],
}
```

## Step 6: Verify

Run `npx tsc --noEmit` to confirm no TypeScript errors.

## Notes

- Always check `signal.aborted` first in every hook
- Return `{}` (empty object) for cases where the hook doesn't apply — not `undefined` or `null`
- Use `getToolInputFilePath` and `getToolInputCommand` from `../types` — never access `input.tool_input` directly without a type assertion helper
- Factory functions should return `null` if prerequisites (binaries, config files) are missing
