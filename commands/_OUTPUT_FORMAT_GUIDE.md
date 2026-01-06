# Output Format Standards

All commands should follow these output formatting standards for consistency and better UX.

## Standard Components

### 1. Summary Box

Use boxes for important summaries and status updates:

```
┌─────────────────────────────────────────────┐
│ {emoji} {Title}                             │
├─────────────────────────────────────────────┤
│ {Key Info Line 1}                           │
│ {Key Info Line 2}                           │
│ {Key Info Line 3}                           │
└─────────────────────────────────────────────┘
```

**Example:**
```
┌─────────────────────────────────────────────┐
│ 🎫 Ticket Created                           │
├─────────────────────────────────────────────┤
│ Task: Add OAuth Integration                 │
│ Type: Feature (Complex)                     │
│ Folder: .claude/tasks/add-oauth-integration │
└─────────────────────────────────────────────┘
```

### 2. Standard Emojis

Use consistent emojis across all commands:

**Status:**
- ✅ Success/Complete/Pass
- ❌ Failure/Error/Fail
- ⚠️ Warning/Caution
- ℹ️ Info/Note
- 🔄 In Progress/Running

**Actions:**
- 🎫 Ticket
- 📋 Plan/Planning
- ⚡ Implementation/Executing
- 📊 Review/Analysis
- 🔍 Search/Analysis
- 📝 Writing/Creating
- 🧪 Testing
- 🔧 Fixing

**Progress:**
- 🟢 Complete
- 🟡 In Progress
- 🔴 Failed
- ⚪ Pending

**Navigation:**
- 📁 Files/Folders
- 🔗 Links
- ⏭️ Next Step
- ⬅️ Previous

### 3. Progress Indicators

#### For Parallel Agent Execution:

```
🔄 Running {N} agents in parallel...

┌─────────────────────────────────────────────┐
│ Agent Progress                              │
├─────────────────────────────────────────────┤
│ 🟢 architecture-explorer   (12s - done)     │
│ 🟡 feature-finder         (8s - running)    │
│ ⚪ dependency-mapper       (pending)         │
└─────────────────────────────────────────────┘

⏱️ Estimated completion: ~15s
```

Update as agents complete:
```
✅ All agents completed (23s total)
```

#### For Sequential Tasks:

```
📋 Implementation Progress

Phase 2: Core Features [████████░░] 80%

├─ ✅ Task 2.1: Install dependencies (5s)
├─ ✅ Task 2.2: Setup environment (8s)
├─ 🔄 Task 2.3: Create OAuth Config (in progress)
└─ ⚪ Task 2.4: Implement flow (pending)

⏱️ 15s elapsed | ~4s remaining
```

#### Simple Progress:
```
🔄 Step {N}/{Total}: {Description}...
```

### 4. Results Tables

Use tables for structured data:

```
| Category | Score | Issues |
|----------|-------|--------|
| TypeScript | ✅ 100% | 0 |
| ESLint | ⚠️ 95% | 2 warnings |
| Tests | ✅ 100% | 24/24 passed |
```

### 5. Hierarchical Lists

Use tree structures for file/folder hierarchies:

```
📁 Files Modified:
├─ src/config/oauth.ts (created)
├─ src/routes/auth.ts (modified)
└─ tests/auth.test.ts (created)
```

Use bullet points with indentation for grouped items:

```
📊 Analysis Results:
- ✅ Architecture explored
  - 12 key files identified
  - 3 integration points found
- ✅ Similar patterns found
  - user-service.ts (authentication pattern)
  - api-service.ts (error handling pattern)
- ✅ Dependencies mapped
  - 8 internal dependencies
  - 3 external libraries needed
```

### 6. Next Steps Section

Always end with clear next steps:

```
⏭️ Next Step:
/2_plan .claude/tasks/{task-folder}

Or use auto-continue:
/1_ticket "{description}" --continue=plan
```

### 7. Error Messages

Structured error format:

```
❌ {Operation} Failed

**Error**: {specific_error_message}
**Location**: {file}:{line}
**Cause**: {explanation}

**Recovery Options**:
1. ✅ {recommended_fix} (recommended)
   Command: {command}

2. {alternative_fix}
   Command: {command}

**Need Help?**
See: CLAUDE.md or run /help {command}
```

### 8. Duration Tracking

Show timing for long operations:

```
⏱️ Duration: 23s
```

For breakdown:
```
⏱️ Timing:
├─ Architecture exploration: 8s
├─ Pattern discovery: 12s
└─ Dependency mapping: 3s
Total: 23s
```

## Command-Specific Templates

### Ticket Generator Output

```
🎫 Creating Task Ticket

🔄 Running 3 agents in parallel...

┌─────────────────────────────────────────────┐
│ Agent Progress                              │
├─────────────────────────────────────────────┤
│ 🟡 architecture-explorer   (running)        │
│ 🟡 feature-finder         (running)         │
│ 🟡 dependency-mapper       (running)        │
└─────────────────────────────────────────────┘

[Update to:]

✅ All agents completed (23s)

┌─────────────────────────────────────────────┐
│ 🎫 Ticket Created                           │
├─────────────────────────────────────────────┤
│ Task: Add OAuth Integration                 │
│ Type: Feature (Complex)                     │
│ Folder: .claude/tasks/add-oauth-integration │
│ Duration: 25s                               │
└─────────────────────────────────────────────┘

📊 Analysis Results:
├─ ✅ Best practices loaded (8 categories)
├─ ✅ Architecture explored (12 key files)
├─ ✅ Similar patterns found (3 matches)
└─ ✅ Dependencies mapped (8 internal, 3 external)

📝 Ticket Details:
├─ Requirements: 5 functional, 3 non-functional
├─ Affected Areas: 4 files to modify, 2 to create
├─ Risks: 2 identified with mitigations
└─ Strategy: OAuth 2.0 with PKCE flow

📁 Files:
└─ 📝 .claude/tasks/add-oauth-integration/ticket.md

⏭️ Next Step:
/2_plan .claude/tasks/add-oauth-integration
```

### Plan Generator Output

```
📋 Creating Implementation Plan

🔄 Step 1/4: Loading ticket...
✅ Ticket loaded

🔄 Step 2/4: Interactive clarification...
[AskUserQuestion if needed]
✅ Requirements clarified

🔄 Step 3/4: Researching...

┌─────────────────────────────────────────────┐
│ Research Progress                           │
├─────────────────────────────────────────────┤
│ 🟡 Web research          (running)          │
│ 🟡 Pattern analysis      (running)          │
│ ⚪ Library docs          (pending)          │
└─────────────────────────────────────────────┘

✅ Research completed (15s)

🔄 Step 4/4: Generating plan...
✅ Plan created

┌─────────────────────────────────────────────┐
│ 📋 Plan Generated                           │
├─────────────────────────────────────────────┤
│ Task: Add OAuth Integration                 │
│ Phases: 5                                   │
│ Tasks: 12                                   │
│ Estimated Effort: 6-8 hours                 │
│ Duration: 42s                               │
└─────────────────────────────────────────────┘

📊 Plan Summary:
├─ Phase 1: Foundation (3 tasks, ~1h)
├─ Phase 2: Core (4 tasks, ~2h)
├─ Phase 3: Integration (2 tasks, ~1.5h)
├─ Phase 4: Validation (2 tasks, ~1h)
└─ Phase 5: Documentation (1 task, ~0.5h)

📁 Files:
└─ 📝 .claude/tasks/add-oauth-integration/plan.md

⏭️ Next Step:
/3_implement .claude/tasks/add-oauth-integration
```

### Implementation Output

```
⚡ Starting Implementation

📋 Loading plan...
✅ Plan loaded: 12 tasks across 5 phases

🔄 Pre-flight checks...
├─ ✅ Git status: clean
├─ ✅ Branch: feature/add-oauth
└─ ✅ Quality checks: passing

📋 Implementation Progress

Phase 1: Foundation [██████████] 100%
├─ ✅ Task 1.1: Install dependencies (5s)
├─ ✅ Task 1.2: Setup environment (8s)
└─ ✅ Task 1.3: Create config (12s)

Phase 2: Core [████████░░] 75%
├─ ✅ Task 2.1: OAuth config (15s)
├─ ✅ Task 2.2: Routes (20s)
├─ ✅ Task 2.3: Components (18s)
└─ 🔄 Task 2.4: Middleware (in progress)

⏱️ 78s elapsed | ~20s remaining

[When complete:]

┌─────────────────────────────────────────────┐
│ ⚡ Implementation Complete                  │
├─────────────────────────────────────────────┤
│ Task: Add OAuth Integration                 │
│ Tasks Completed: 12/12                      │
│ Files Modified: 6                           │
│ Duration: 3m 45s                            │
└─────────────────────────────────────────────┘

📁 Files Modified:
├─ src/config/oauth.ts (created)
├─ src/routes/auth.ts (modified)
├─ src/components/Login.tsx (modified)
├─ src/middleware/auth.ts (created)
├─ tests/auth.test.ts (created)
└─ .env.local (modified)

✅ Final validation passed

⏭️ Next Step:
/4_review .claude/tasks/add-oauth-integration
```

### Review Output

```
📊 Starting Code Review

🔄 Step 1/4: Loading context...
✅ Context loaded

🔄 Step 2/4: Running automated checks...

| Check | Status | Details |
|-------|--------|---------|
| TypeScript | ✅ PASS | No errors |
| ESLint | ⚠️ WARN | 2 warnings |
| Prettier | ✅ PASS | Formatted |
| Tests | ✅ PASS | 24/24 |

🔄 Step 3/4: Comprehensive review...
✅ Review completed (45s)

🔄 Step 4/4: Generating report...
✅ Report created

┌─────────────────────────────────────────────┐
│ 📊 Code Review Complete                     │
├─────────────────────────────────────────────┤
│ Overall: ⚠️ PASS WITH WARNINGS              │
│ Quality Score: 8.5/10                       │
│ Issues: 1 high, 4 medium, 2 low             │
│ Duration: 52s                               │
└─────────────────────────────────────────────┘

📊 Quality Summary:
├─ ✅ All tests passing (24/24)
├─ ✅ No security issues
├─ ✅ No performance issues
├─ ⚠️ Best practices: 95% compliant
└─ ⚠️ Pattern compliance: 87% compliant

⚠️ Action Required:
├─ 1 high severity issue (pattern deviation)
└─ 4 medium issues (code quality)

📁 Files:
└─ 📝 .claude/tasks/add-oauth-integration/review.md

⏭️ Next Steps:
1. Review issues in review.md
2. Fix high severity issues
3. Commit changes
```

## Guidelines

1. **Always use summary boxes** for major milestones and final outputs
2. **Show progress** for operations longer than 5 seconds
3. **Use consistent emojis** as defined above
4. **Include timing** for operations longer than 10 seconds
5. **End with clear next steps** - always tell user what to do next
6. **Use tables** for structured comparison data
7. **Use tree structures** for hierarchies
8. **Keep it scannable** - use whitespace and visual separators
9. **Be consistent** - same format across all commands
10. **Make errors actionable** - always provide recovery options
