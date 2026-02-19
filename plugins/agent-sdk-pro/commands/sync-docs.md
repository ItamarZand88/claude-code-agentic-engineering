---
description: Fetch the latest Claude Agent SDK TypeScript documentation online, compare it against this plugin's reference files, and apply updates for any new options, hook events, message types, or behavioral changes. Run this periodically to keep the plugin accurate.
argument-hint: [focus-area: hooks|options|messages|all]
allowed-tools: WebFetch, Read, Write, Edit, Glob
---

You are performing a documentation sync for the `agent-sdk-pro` plugin. Your goal is to fetch the latest official Claude Agent SDK TypeScript docs, compare them against the plugin's reference files, and patch any gaps or inaccuracies.

The focus area is: `$ARGUMENTS` (if empty, treat as "all").

---

## Step 1: Fetch Official Docs

Fetch these pages and extract TypeScript-specific content. Read carefully — you are looking for types, options, behaviors, and patterns that may have changed or been added since the plugin was last updated.

**Primary sources** — fetch all of these:

1. `https://docs.anthropic.com/en/docs/claude-code/sdk` — main SDK overview and `query()` API
2. `https://docs.anthropic.com/en/docs/claude-code/hooks` — hook events, input types, output types

For each page, extract:
- New or changed TypeScript types and interfaces
- New options or fields
- New hook events or changes to existing events
- New behaviors, caveats, or deprecations
- Code examples that differ from what the plugin currently documents

---

## Step 2: Read Current Plugin Reference Files

Read the files that correspond to the focus area:

**If focus is "hooks" or "all":**
- `skills/sdk-hooks-development/SKILL.md`
- `skills/sdk-hooks-development/references/hook-events-reference.md`
- `skills/sdk-hooks-development/references/pretooluse-patterns.md`
- `skills/sdk-hooks-development/references/posttooluse-patterns.md`

**If focus is "options" or "all":**
- `skills/sdk-typescript-patterns/references/query-options.md`
- `skills/sdk-typescript-patterns/SKILL.md`

**If focus is "messages" or "all":**
- `skills/sdk-typescript-patterns/references/message-types.md`

---

## Step 3: Gap Analysis

Compare docs vs plugin content. For each difference, categorize it:

| Category | Description |
|----------|-------------|
| **MISSING** | Something in the docs that the plugin doesn't cover at all |
| **INACCURATE** | Plugin says X but docs say Y |
| **OUTDATED** | Plugin references deprecated behavior or old type names |
| **EXAMPLE MISMATCH** | Plugin code example doesn't match current API shape |

List every gap found before making any edits.

**Focus areas to check carefully:**

For **hooks**:
- All `HookJSONOutput` top-level fields (`continue`, `stopReason`, `suppressOutput`, `systemMessage`, `decision`, `reason`, `async`, `asyncTimeout`)
- `hookSpecificOutput` discriminated union — which events support which fields
- Which events are TypeScript-only vs universal
- `updatedInput` rules (requires `permissionDecision: "allow"`)
- `PostToolUseFailure` — cannot use `hookSpecificOutput`, must use top-level `systemMessage`
- `SubagentStop` — only has `stop_hook_active`, not `agent_id`/`agent_type`
- `PreToolUse additionalContext` — not in TypeScript type (use `systemMessage` instead)
- Permission evaluation order (deny > ask > allow > default)
- New hook event types added since last sync
- Input type fields for each event (e.g. `session_id`, `tool_name`, `tool_input`, `tool_response`)

For **options**:
- All `Options` fields including `canUseTool`, `disallowedTools`, `settingSources`, `agents`
- `permissionMode` — all 4 values: `"default" | "acceptEdits" | "bypassPermissions" | "plan"`
- Hook registration object shape
- Any new fields added since last sync

For **messages**:
- All `SDKResultMessage` subtypes including `error_max_budget_usd` and `error_max_structured_output_retries`
- `permission_denials` field in result message
- `SDKPermissionDenial` shape
- `result` field (final text output)
- Any new message variants added since last sync

---

## Step 4: Apply Updates

For each gap found, apply the minimal necessary edit:

- **MISSING**: Add the new content to the appropriate reference file. Place it logically — new options in `query-options.md`, new events in `hook-events-reference.md`, etc.
- **INACCURATE**: Replace the wrong content with the correct information.
- **OUTDATED**: Update deprecated patterns to current equivalents. Add a comment if the old pattern still works but is discouraged.
- **EXAMPLE MISMATCH**: Fix the code example to match the current API.

Rules for edits:
- Preserve existing structure and formatting conventions
- Do not remove content that is still accurate
- Keep TypeScript examples compilable — never use incorrect types
- Use `input.hook_event_name` not hardcoded strings in `hookEventName` fields
- Always show `if (signal.aborted) return {}` first in hook examples

---

## Step 5: Report

After all edits, produce a structured report:

**Sync Report — [date]**

**Docs fetched:**
- [list pages fetched]

**Gaps found:** [count]

| # | Category | File | Description |
|---|----------|------|-------------|
| 1 | MISSING | `hook-events-reference.md` | `NewEvent` hook not documented |
| 2 | INACCURATE | `query-options.md` | `permissionMode` missing `"plan"` value |
| ... | | | |

**Changes applied:** [count]
- [File]: [what changed]

**No changes needed:** (if everything was already accurate)

**Recommendation:** If major new features were found, consider also updating `SKILL.md` trigger descriptions and README so skills auto-activate correctly for new patterns.
