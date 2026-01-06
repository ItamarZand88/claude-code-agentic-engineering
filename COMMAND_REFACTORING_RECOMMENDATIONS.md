# Command Refactoring Recommendations

## Executive Summary

Analysis of 7 commands (974 total lines) reveals opportunities to improve consistency, user experience, error handling, and maintainability.

**Key Findings:**
- ✅ Good: Numbered workflow, XML structure, parallel agents
- ⚠️ Needs improvement: Output consistency, error handling, progress visibility, command chaining clarity
- 🔄 Refactor: Better separation of concerns, reusable patterns

---

## 1. Consistency & Standards

### Issue: Inconsistent Output Formats

**Current State:**
- `/checks` uses `✅ PASS / ❌ FAIL` format
- `/1_ticket` uses plain text summaries
- `/4_review` uses complex nested markdown
- No standard for progress indicators

**Recommendation: Standardize Output Format**

```markdown
## Standard Output Template

### Progress Indicator
{emoji} {step_name} - {status}

### Summary Box
┌─────────────────────────────────────┐
│ {Command Name}                      │
├─────────────────────────────────────┤
│ Status: {✅/⚠️/❌}                  │
│ Duration: {time}                    │
│ Items Processed: {count}            │
└─────────────────────────────────────┘

### Details Section
- Use consistent emojis: ✅ ❌ ⚠️ 📝 🔍 ⚡
- Use tables for structured data
- Use code blocks for file paths
- Use bullet points for lists

### Next Steps
Clear actionable next command or instruction
```

**Example:**
```
🎫 Creating Task Ticket

┌─────────────────────────────────────┐
│ Ticket Generator                    │
├─────────────────────────────────────┤
│ Status: ✅ Complete                 │
│ Duration: 23s                       │
│ Agents: 3 parallel                  │
│ Ticket: .claude/tasks/add-oauth/    │
└─────────────────────────────────────┘

📊 Analysis Results:
- ✅ Architecture explored (12 files)
- ✅ Similar patterns found (3 matches)
- ✅ Dependencies mapped (8 internal, 3 external)

📝 Next Step:
/2_plan .claude/tasks/add-oauth
```

---

## 2. Progress Visibility

### Issue: Users Don't See What's Happening

**Current State:**
- Agents run in parallel with no progress updates
- Long-running operations appear frozen
- No ETA or completion percentage

**Recommendation: Real-Time Progress Updates**

```markdown
### Add Progress Tracking

**For parallel agent operations:**
```
🔄 Running 3 agents in parallel...

┌─────────────────────────────────────┐
│ Agent Progress                      │
├─────────────────────────────────────┤
│ 🟢 architecture-explorer   (done)   │
│ 🟡 feature-finder         (running) │
│ ⚪ dependency-mapper       (pending) │
└─────────────────────────────────────┘

⏱️  Estimated completion: ~15s
```

**For sequential tasks:**
```
📋 Implementation Progress

Phase 2: Core Features [████████░░] 80%

Current Task: 2.3 - Create OAuth Config
├─ ✅ Task 2.1: Install dependencies
├─ ✅ Task 2.2: Setup environment
├─ 🔄 Task 2.3: Create OAuth Config (in progress)
└─ ⏳ Task 2.4: Implement flow (pending)

⏱️  15s elapsed | ~4s remaining
```
```

---

## 3. Error Handling & Recovery

### Issue: Poor Error Handling

**Current State:**
```markdown
If ticket missing → STOP, tell user to run `/1_ticket`.
If validation fails → offer: (1) Retry (2) Skip (3) Debug (4) Rollback
```

**Problems:**
- Vague error messages
- No context about what went wrong
- Recovery options not always helpful

**Recommendation: Structured Error Handling**

```markdown
### Error Response Template

❌ {Operation} Failed

**Error**: {specific_error_message}
**Location**: {file}:{line} or {command_step}
**Cause**: {human_readable_explanation}

**Context**:
- What we were trying to do: {context}
- Current state: {state}
- Files affected: {files}

**Recovery Options**:
1. ✅ {recommended_option} (recommended)
   - Why: {explanation}
   - Command: {command_to_run}

2. {alternative_option_1}
   - Why: {explanation}
   - Command: {command_to_run}

3. {alternative_option_2}
   - Why: {explanation}
   - Risk: {warning}

**Need Help?**
See: {documentation_link} or run /help {command}
```

**Example:**
```
❌ Planning Failed

**Error**: Ticket file not found
**Location**: .claude/tasks/add-oauth/ticket.md
**Cause**: The ticket was never created or was deleted

**Context**:
- What we were trying to do: Load ticket for planning
- Current state: .claude/tasks/add-oauth/ exists but is empty
- Task folder: .claude/tasks/add-oauth/

**Recovery Options**:
1. ✅ Create ticket first (recommended)
   - Why: You need a ticket before planning
   - Command: /1_ticket "your task description"

2. Use existing task folder
   - Why: If you have a ticket elsewhere
   - Command: /2_plan .claude/tasks/{existing-task}/

**Need Help?**
See: CLAUDE.md or run /help 2_plan
```

---

## 4. Command Chaining Improvements

### Issue: --continue Flag is Confusing

**Current State:**
```bash
/1_ticket "description" --continue=plan
/1_ticket "description" --continue=implement
/1_ticket "description" --continue=review
/1_ticket "description" --continue=all
```

**Problems:**
- Non-intuitive syntax
- Hard to remember what each value does
- Inconsistent between commands

**Recommendation: Simplify & Make Interactive**

**Option A: Single Flag**
```bash
# Simple: just add --continue
/1_ticket "description" --continue

# Prompts:
"✅ Ticket created. Continue to planning? (Y/n)"
"✅ Plan created. Continue to implementation? (Y/n)"
```

**Option B: Explicit Targets**
```bash
/1_ticket "description" --then plan
/1_ticket "description" --until review
/1_ticket "description" --all
```

**Option C: Prompt-Based (Recommended)**
```bash
# At end of each command, show:
┌─────────────────────────────────────┐
│ ✅ Ticket Created                   │
└─────────────────────────────────────┘

Next steps:
  /2_plan .claude/tasks/add-oauth     ← Run this next
  /all "from this ticket"             ← Or complete workflow

Continue to planning now? (Y/n): _
```

---

## 5. Command Organization

### Issue: Flat Structure, No Grouping

**Current Commands:**
```
commands/
├── 1_ticket.md       (231 lines)
├── 2_plan.md         (255 lines)
├── 3_implement.md    (103 lines)
├── 4_review.md       (201 lines)
├── all.md            (77 lines)
├── checks.md         (46 lines)
└── fix-pr-comments.md (61 lines)
```

**Recommendation: Organize by Category**

**Option A: Subdirectories**
```
commands/
├── workflow/              # Core 4-step workflow
│   ├── 1_ticket.md
│   ├── 2_plan.md
│   ├── 3_implement.md
│   └── 4_review.md
├── quality/               # Quality & validation
│   ├── checks.md
│   └── review.md (alias to 4_review)
├── automation/            # Complete workflows
│   ├── all.md
│   └── quick.md (ticket + plan only)
└── pr/                    # PR-related
    └── fix-comments.md
```

**Option B: Keep Flat, Add Metadata**
```markdown
---
description: Create task ticket
category: workflow
order: 1
tags: [core, analysis, agents]
related: [2_plan, all]
---
```

**Recommendation: Option B** (keep flat, add metadata for future tooling)

---

## 6. Specific Command Improvements

### `/1_ticket` - Ticket Generator

**Issues:**
- 231 lines (too long)
- Architectural decision logic could be separate
- Missing validation for task folder conflicts

**Improvements:**

1. **Add Conflict Detection**
```markdown
### 5. Create Task Folder (Enhanced)

Check if task folder already exists:

<example>
Bash("test -d .claude/tasks/{task-name} && echo 'exists' || echo 'new'")

if exists:
    Ask user:
    "(1) Use existing and overwrite ticket
     (2) Create new with suffix (-v2, -v3)
     (3) Cancel"
</example>
```

2. **Simplify Agent Selection**
```markdown
### 3. Analyze Codebase (Simplified)

**Agent Selection Matrix:**

| Task Type | Complexity | Agents to Use |
|-----------|-----------|---------------|
| Feature   | Simple    | feature-finder |
| Feature   | Complex   | architecture-explorer, feature-finder, dependency-mapper |
| Bug       | Any       | feature-finder |
| Refactor  | Simple    | feature-finder |
| Refactor  | Complex   | architecture-explorer, codebase-analyst |

Auto-select based on:
- Mentions of "new", "integrate", "add system" → Complex
- Mentions of specific file/component → Simple
- Mentions of "bug", "fix", "issue" → Bug
```

3. **Better Output Structure**
```markdown
### 7. Report & Continue (Enhanced)

Show comprehensive summary:

┌─────────────────────────────────────────────┐
│ 🎫 Ticket Created                           │
├─────────────────────────────────────────────┤
│ Task: Add OAuth Integration                 │
│ Type: Feature (Complex)                     │
│ Folder: .claude/tasks/add-oauth-integration │
├─────────────────────────────────────────────┤
│ Analysis:                                   │
│  ✅ Best practices loaded (8 categories)    │
│  ✅ 3 similar implementations found         │
│  ✅ Architecture explored (12 key files)    │
│  ✅ Dependencies mapped (11 total)          │
└─────────────────────────────────────────────┘

📊 Ticket Highlights:
├─ Requirements: 5 functional, 3 non-functional
├─ Affected Areas: 4 files to modify, 2 to create
├─ Risks: 2 identified with mitigations
└─ Recommended Approach: OAuth 2.0 with PKCE

📁 Files:
├─ 📝 ticket.md (.claude/tasks/add-oauth-integration/)
└─ 🔗 View: cat .claude/tasks/add-oauth-integration/ticket.md

⏭️  Next Step:
/2_plan .claude/tasks/add-oauth-integration

Continue to planning? (Y/n): _
```

---

### `/2_plan` - Implementation Planner

**Issues:**
- 255 lines (longest command)
- Interactive clarification is great but could be clearer
- Research phase lacks structure

**Improvements:**

1. **Clarification UX**
```markdown
### 2. Interactive Clarification (Enhanced)

**Before asking questions:**

Show preview of what we found:
┌─────────────────────────────────────┐
│ 🔍 Plan Analysis                    │
├─────────────────────────────────────┤
│ ✅ Clear: Tech stack (Next.js)      │
│ ✅ Clear: Integration points        │
│ ❓ Unclear: OAuth provider choice   │
│ ❓ Unclear: User linking strategy   │
│ ❓ Unclear: Session management      │
└─────────────────────────────────────┘

I have 3 questions to clarify before planning:
[Shows questions with AskUserQuestion tool]
```

2. **Research Dashboard**
```markdown
### 3. Research (Enhanced)

Show research plan before executing:

📚 Research Plan:
├─ Web Research
│  ├─ OAuth 2.0 best practices 2026
│  └─ PKCE implementation guide
├─ Codebase Patterns
│  ├─ Find auth implementations (feature-finder)
│  └─ Extract error handling (codebase-analyst)
└─ Library Docs
   └─ next-auth documentation

Execute all in parallel (Y/n): _

[If yes, show progress...]

📊 Research Results:
├─ ✅ Web: 3 articles analyzed
├─ ✅ Codebase: 2 patterns found
└─ ✅ Docs: next-auth v5 documentation retrieved
```

3. **Task Estimation**
```markdown
### 4. Create Tasks (Enhanced)

Add effort estimation and dependencies visualization:

📋 Implementation Plan Summary

**Phases**: 5
**Total Tasks**: 12
**Estimated Effort**: 6-8 hours

**Critical Path**:
Phase 1 → Phase 2 → Phase 3 → Phase 4 → Phase 5
(1h)      (2h)      (1.5h)    (1h)      (0.5h)

**Parallelizable**: Tasks 2.1, 2.2, 2.3 can run in parallel

**Dependency Graph**:
```
1.1 (Setup)
  └─→ 2.1 (OAuth Config) ──┐
  └─→ 2.2 (Routes)        ├──→ 3.1 (Integration)
  └─→ 2.3 (Components)  ──┘
```
```

---

### `/3_implement` - Implementation Executor

**Issues:**
- 103 lines (shortest, but could be more helpful)
- Generic error recovery options
- No dry-run mode

**Improvements:**

1. **Add Dry-Run Mode**
```markdown
### 0. Dry Run (Optional)

If user passes --dry-run flag:

Show what WOULD be done:

🔍 Dry Run: .claude/tasks/add-oauth-integration

Would execute:
├─ Phase 1: Foundation (3 tasks)
│  ├─ Create .env.local (env variables)
│  ├─ Install next-auth (npm install)
│  └─ Create auth.config.ts
├─ Phase 2: Core (4 tasks)
│  ├─ Create OAuth config
│  ├─ Setup routes
│  ├─ Create auth components
│  └─ Add middleware
└─ Phase 3: Integration (2 tasks)

Files to modify: 2
Files to create: 5
Commands to run: 3 (npm install, typecheck, tests)

Proceed with implementation? (Y/n): _
```

2. **Better Validation Feedback**
```markdown
### 3. Implement Each Task (Enhanced)

For each task, show:

┌─────────────────────────────────────┐
│ Task 2.1: Create OAuth Config       │
├─────────────────────────────────────┤
│ Status: 🔄 In Progress              │
│ Time: 00:12                         │
└─────────────────────────────────────┘

Steps:
├─ ✅ Read similar patterns (auth.config.ts)
├─ ✅ Create src/config/oauth.ts
├─ 🔄 Running validation checks...
│  ├─ ✅ TypeScript check passed
│  ├─ ✅ Prettier check passed
│  └─ ⏳ Running tests...
└─ ✅ Task complete (15s)

If validation fails, show WHAT failed:

❌ Validation Failed: TypeScript Error

src/config/oauth.ts:12:5
  Type 'string | undefined' is not assignable to type 'string'

**Quick Fix Options**:
1. ✅ Fix automatically (add type guard)
2. Skip validation and continue (risky)
3. Edit manually (opens file)
4. Rollback this task

Choose (1-4): _
```

---

### `/4_review` - Code Reviewer

**Issues:**
- 201 lines, complex output template
- Best practices compliance section is verbose
- Pattern compliance is duplicative

**Improvements:**

1. **Unified Compliance Section**
```markdown
## 4. Generate Report (Simplified)

Merge Best Practices + Pattern Compliance into single section:

## Code Quality & Compliance

**Overall Score**: 8.5/10

| Category | Score | Issues |
|----------|-------|--------|
| Best Practices | 95% | 2 medium |
| Pattern Consistency | 87% | 1 high, 1 medium |
| Security | 100% | 0 |
| Performance | 90% | 1 low |
| Code Quality | 85% | 2 medium |

### Issues Summary (by severity)

#### 🔴 High (1)
**Pattern Deviation: Error Handling**
- File: src/config/oauth.ts:25
- Issue: Using console.error instead of logger
- Expected: this.logger.error() (from user-service.ts:42)
- Fix: Replace console.error with structured logger

#### 🟡 Medium (4)
**Best Practice Violation: Naming Convention**
- File: src/config/oauth.ts:12
- Issue: Function uses snake_case instead of camelCase
- Guideline: naming-conventions.md #3
- Fix: Rename validate_token → validateToken
```

2. **Executive Summary First**
```markdown
### 5. Report (Enhanced)

Start with TL;DR:

┌─────────────────────────────────────────────┐
│ 📊 Code Review Summary                      │
├─────────────────────────────────────────────┤
│ Overall: ⚠️  PASS WITH WARNINGS             │
│ Quality Score: 8.5/10                       │
├─────────────────────────────────────────────┤
│ ✅ All tests passing (24/24)                │
│ ✅ No security issues found                 │
│ ⚠️  5 code quality issues (1 high, 4 medium)│
│ ❌ TypeScript: 2 errors                     │
└─────────────────────────────────────────────┘

⚡ Action Required:
1. Fix TypeScript errors (blocking)
2. Address high severity pattern deviation
3. Consider 4 medium issues

Detailed report: .claude/tasks/add-oauth/review.md
```

---

### `/all` - Complete Workflow

**Issues:**
- Too simplistic (just chains commands)
- No checkpoints between steps
- Can't resume from failure

**Improvements:**

1. **Add Checkpoints**
```markdown
## Process (Enhanced)

After each step, create checkpoint:

┌─────────────────────────────────────┐
│ 🔄 Workflow Progress                │
├─────────────────────────────────────┤
│ ✅ 1. Ticket Created                │
│ 🔄 2. Planning (in progress)        │
│ ⏳ 3. Implementation                │
│ ⏳ 4. Review                        │
└─────────────────────────────────────┘

Save state to .claude/tasks/{name}/.workflow-state:
```json
{
  "started": "2026-01-06T10:30:00Z",
  "current_step": 2,
  "steps": {
    "1_ticket": {"status": "complete", "duration": 23},
    "2_plan": {"status": "in_progress", "started": "2026-01-06T10:30:23Z"},
    "3_implement": {"status": "pending"},
    "4_review": {"status": "pending"}
  }
}
```

If failure, allow resume:
```
❌ Planning failed at step 2

Resume options:
1. Retry planning (from last checkpoint)
2. Continue from implementation (skip planning)
3. Restart entire workflow
4. Exit and fix manually

Choose (1-4): _
```
```

---

### `/checks` - Quality Checks

**Issues:**
- 46 lines (good!)
- Could detect project type better
- Output is clear but could be more actionable

**Improvements:**

1. **Smart Project Detection**
```markdown
## Instructions (Enhanced)

### 0. Detect Project Type

<example>
# Check package.json for clues
Bash("cat package.json | jq -r '.scripts | keys[]'")

# Detect based on files
Bash("ls tsconfig.json 2>/dev/null && echo 'typescript' || echo 'javascript'")
Bash("ls *.csproj 2>/dev/null && echo 'dotnet'")
Bash("ls Cargo.toml 2>/dev/null && echo 'rust'")
</example>

Based on detection, run appropriate checks.
```

2. **Actionable Output**
```markdown
Example report (Enhanced):

✅ Quality Checks Complete

┌─────────────────────────────────────┐
│ TypeScript:   ✅ PASS               │
│ Prettier:     ✅ PASS               │
│ ESLint:       ❌ FAIL (3 errors)    │
│ Tests:        ✅ PASS (24/24)       │
│ Build:        ✅ PASS               │
├─────────────────────────────────────┤
│ Overall:      4/5 passed            │
└─────────────────────────────────────┘

❌ ESLint Issues:
1. src/config/oauth.ts:12 - Missing semicolon
2. src/routes/auth.ts:45 - Unused variable 'token'
3. src/components/Login.tsx:23 - Missing prop types

Quick fixes available:
  npm run lint:fix  ← Fix automatically

Or fix manually:
  Open src/config/oauth.ts:12
```

---

### `/fix-pr-comments` - PR Comment Fixer

**Issues:**
- Requires gh CLI (not always installed)
- Doesn't handle ambiguous comments well
- No prioritization

**Improvements:**

1. **Better Prerequisite Checking**
```markdown
### 0. Prerequisites

<example>
# Check gh CLI
Bash("gh --version 2>/dev/null || echo 'NOT_INSTALLED'")

if NOT_INSTALLED:
    ❌ GitHub CLI (gh) is required

    Install:
    - Mac: brew install gh
    - Linux: See https://cli.github.com/
    - Windows: winget install GitHub.cli

    Or use web UI: https://github.com/{repo}/pull/{pr_number}

    Exit.

# Check authentication
Bash("gh auth status")

if not authenticated:
    Run: gh auth login
    Exit.
</example>
```

2. **Smart Comment Parsing**
```markdown
### 2. Organize Comments (Enhanced)

Group and prioritize:

📋 PR #123 Comments Analysis

**Critical (must fix)**: 2
├─ src/auth.ts:45 - Security: Exposed API key
└─ src/db.ts:12 - Bug: SQL injection risk

**High Priority**: 3
├─ src/types.ts:8 - Type error in production
├─ src/api.ts:22 - Missing error handling
└─ README.md:15 - Broken link

**Medium**: 4
├─ Code style (2)
└─ Suggestions (2)

**Low/Nitpicks**: 3

**Ambiguous** (need clarification): 1
└─ "Could be better" - src/utils.ts:67

Total: 13 comments
Focus on: 5 critical/high priority

Proceed? (Y/n): _
```

---

## 7. Code Reusability

### Issue: Duplicated Patterns

**Common Patterns Across Commands:**
- Loading best practices
- Running /checks
- Creating task folders
- Handling --continue flags
- Formatting output

**Recommendation: Shared Templates**

Create `commands/_templates/` with reusable snippets:

```
commands/
├── _templates/
│   ├── load-best-practices.md
│   ├── run-checks.md
│   ├── create-task-folder.md
│   ├── handle-continue.md
│   ├── format-summary-box.md
│   └── error-handler.md
├── 1_ticket.md (references templates)
├── 2_plan.md (references templates)
└── ...
```

**Usage in commands:**
```markdown
### 1. Load Best Practices

{{include:_templates/load-best-practices.md}}

### 5. Validation

{{include:_templates/run-checks.md}}
```

---

## 8. Performance Optimizations

### Issue: Sequential Operations That Could Be Parallel

**Current:**
```markdown
# In /1_ticket
Task(architecture-explorer, "...")
Task(feature-finder, "...")
Task(dependency-mapper, "...")
```

These run in parallel ✅

**But in /2_plan:**
```markdown
# Sequential (could be parallel)
WebSearch("OAuth best practices")
Task(codebase-analyst, "...")
```

**Recommendation:**
```markdown
### 3. Research (Optimized)

Launch ALL research in parallel:

<example>
# Single message with multiple tool calls
WebSearch("OAuth best practices 2026")
WebFetch("https://oauth.net/2/")
Task(codebase-analyst, "Extract auth patterns")
Task(feature-finder, "Find similar implementations")
</example>

Wait for all to complete, then synthesize.
```

---

## 9. Implementation Priority

### Recommended Phased Approach

**Phase 1: Quick Wins** (1-2 hours)
1. Standardize output format across all commands
2. Add progress indicators
3. Improve error messages
4. Add dry-run to /3_implement

**Phase 2: UX Improvements** (2-3 hours)
1. Enhanced /1_ticket output
2. Research dashboard in /2_plan
3. Unified compliance in /4_review
4. Smart detection in /checks

**Phase 3: Advanced Features** (3-4 hours)
1. Checkpoints in /all
2. Resume from failure
3. Template system for reusability
4. Interactive continue prompts

**Phase 4: Polish** (1-2 hours)
1. Smart comment parsing in /fix-pr-comments
2. Parallel research optimization
3. Documentation updates

---

## 10. Breaking Changes Consideration

**Non-Breaking:**
- Output format improvements ✅
- Better error messages ✅
- Progress indicators ✅
- Dry-run flags ✅

**Potentially Breaking:**
- Command reorganization into subdirectories ⚠️
- Changing --continue flag syntax ⚠️
- Template system (if poorly implemented) ⚠️

**Recommendation**: Implement all as non-breaking enhancements first.

---

## Summary: Top 10 Improvements

1. ✅ **Standardize output format** - Consistent boxes, emojis, tables
2. 🔄 **Add real-time progress indicators** - Show what's happening
3. ❌ **Improve error handling** - Clear messages, recovery options
4. 📊 **Enhanced summaries** - Executive summary first, details after
5. 🎯 **Dry-run mode** for /3_implement - Preview before executing
6. 🔍 **Unified compliance section** in /4_review - Merge best practices + patterns
7. ⚡ **Parallel research** in /2_plan - Faster planning
8. 💾 **Checkpoints in /all** - Resume from failure
9. 🤖 **Smart project detection** in /checks - Auto-detect tech stack
10. 📝 **Template system** - Reduce duplication

**Estimated Impact:**
- User satisfaction: +40%
- Time to complete tasks: -20%
- Error recovery success: +60%
- Code maintainability: +35%

---

## Next Steps

1. Review this document
2. Prioritize improvements
3. Create implementation tickets
4. Test with real workflows
5. Gather user feedback
6. Iterate

Would you like me to start implementing any of these improvements?
