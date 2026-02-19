# Agent SDK Pro

A professional TypeScript Claude Agent SDK development toolkit. Covers patterns, hooks, agent control, and architecture for building production-grade Agent SDK platforms.

**TypeScript only.** This plugin assumes `@anthropic-ai/claude-agent-sdk` with TypeScript.

---

## Features

### Skills (auto-activate)

| Skill | Triggers on |
|-------|------------|
| `sdk-typescript-patterns` | `query()` usage, SDK imports, streaming, message types |
| `sdk-hooks-development` | `HookCallback`, `HookJSONOutput`, PreToolUse/PostToolUse patterns |
| `sdk-agent-control` | `allowedTools`, `maxTurns`, system prompt design, file pre-creation |

### Commands (user-invoked)

| Command | Purpose |
|---------|---------|
| `/agent-sdk-pro:scaffold-agent [name]` | Scaffold a complete TypeScript SDK runner with hooks |
| `/agent-sdk-pro:add-hook [type]` | Add a new PreToolUse or PostToolUse hook to a project |
| `/agent-sdk-pro:debug [issue]` | Diagnose issues with an Agent SDK project |
| `/agent-sdk-pro:sync-docs [focus]` | Fetch latest SDK docs, find gaps in plugin content, apply updates |

### Agents (autonomous)

| Agent | Triggers on |
|-------|------------|
| `sdk-architecture-advisor` | "review my agent architecture", "how should I structure my SDK platform" |
| `sdk-hook-strategist` | "design my hook strategy", "what hooks do I need", "help me implement hooks" |

### Plugin Hooks

| Hook | Behavior |
|------|----------|
| `SessionStart` | Detects if current project uses the SDK and logs context |
| `PostToolUse` (opt-in) | Reviews edited `.ts` files for SDK pattern issues |

---

## Quick Start

### Scaffold a new agent
```
/agent-sdk-pro:scaffold-agent test-generator
```

### Add a hook
```
/agent-sdk-pro:add-hook PreToolUse
```

### Get architecture advice
```
"Review my Agent SDK architecture"
```

### Get a hook strategy
```
"Design a complete hook strategy for my code generation agent"
```

---

## TypeScript SDK Hook Quick Reference

```typescript
// The core types
type HookCallback = (
  input: HookInput,
  toolUseId: string,
  context: { signal: AbortSignal }
) => Promise<HookJSONOutput>;

// PreToolUse: deny a tool call
return {
  hookSpecificOutput: {
    hookEventName: "PreToolUse",
    permissionDecision: "deny",
    permissionDecisionReason: "Only test files can be modified",
  },
};

// PostToolUse: inject feedback into tool result
return {
  hookSpecificOutput: {
    hookEventName: input.hook_event_name,
    additionalContext: "TypeCheck errors found:\n...",
  },
};

// No-op (allow / skip)
return {};
```

---

## Enable Real-Time SDK Feedback

The PostToolUse hook is opt-in. To enable real-time feedback when editing SDK TypeScript files:

```bash
# Enable (in your project directory)
touch .enable-sdk-feedback

# Disable
rm .enable-sdk-feedback
```

**Note**: Requires restarting Claude Code after creating/removing the flag file.

---

## Skills Reference

| File | Contents |
|------|----------|
| `skills/sdk-typescript-patterns/SKILL.md` | `query()`, message iteration, AbortSignal, metadata |
| `skills/sdk-typescript-patterns/references/query-options.md` | Full options object: `canUseTool`, `disallowedTools`, `permissionMode`, `settingSources` |
| `skills/sdk-typescript-patterns/references/message-types.md` | SDKMessage variants, all error subtypes, `permission_denials`, logging |
| `skills/sdk-typescript-patterns/examples/basic-runner.ts` | Minimal working runner |
| `skills/sdk-hooks-development/SKILL.md` | HookCallback, factory patterns, type guards |
| `skills/sdk-hooks-development/references/pretooluse-patterns.md` | 4 PreToolUse patterns |
| `skills/sdk-hooks-development/references/posttooluse-patterns.md` | 4 PostToolUse patterns |
| `skills/sdk-hooks-development/references/hook-events-reference.md` | PreToolUse and PostToolUse deep dive, execution model, tool name reference |
| `skills/sdk-hooks-development/references/smart-dispatch-pattern.md` | Dispatcher pattern: route by file type and tool, merge strategies, testing |
| `skills/sdk-hooks-development/references/testing-hooks.md` | Unit testing with vitest, mock helpers, mocking execSync |
| `skills/sdk-hooks-development/examples/env-protection-hook.ts` | `.env` file read blocker |
| `skills/sdk-hooks-development/examples/file-restriction-hook.ts` | Single-file write restriction factory |
| `skills/sdk-hooks-development/examples/security-blocker-hook.ts` | Comprehensive security: dangerous commands + protected files + out-of-project writes |
| `skills/sdk-hooks-development/examples/smart-dispatch-hook.ts` | Single dispatcher routing by file type and tool name |
| `skills/sdk-hooks-development/examples/auto-format-hook.ts` | Silent Prettier formatting after edits (no additionalContext) |
| `skills/sdk-hooks-development/examples/input-redirect-hook.ts` | `updatedInput` patterns: sandbox redirect, strip dangerous flags, inject env vars |
| `skills/sdk-agent-control/SKILL.md` | allowedTools, maxTurns, system prompts, pre-creation |
| `skills/sdk-agent-control/references/hook-strategy.md` | Hook strategy matrix, anti-patterns |
| `skills/sdk-agent-control/references/velocity-control.md` | Velocity governor, output validator, budget guard, checkpoint |
| `skills/sdk-agent-control/examples/complete-runner.ts` | Production-ready runner with all patterns |

---

## Architecture Principles

1. **Single point of contact** — all SDK imports through one `types.ts` file
2. **TypeScript hooks** — `HookCallback` functions, not JSON config
3. **Always `signal.aborted` first** — in every hook callback
4. **Return `{}`** for no-op — not `null` or `undefined`
5. **Factory functions** for parameterized hooks (e.g., `createFileRestrictionHook(targetFile)`)
6. **Graceful disable** — factory hooks return `null` if prerequisites missing
7. **Minimal `allowedTools`** — give agents only what they need
8. **Safety rails always** — `maxTurns` and `maxBudgetUsd` on every run
9. **File pre-creation** — scaffold → agent edits → read back
10. **Velocity + budget guards** — rate-limit tool calls and deny when budget nearly exhausted
