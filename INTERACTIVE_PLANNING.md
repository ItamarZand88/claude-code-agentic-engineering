# Interactive Planning with Clarifying Questions

## Overview

Interactive Planning enhances the `/2_plan` workflow by using the **AskUserQuestion tool** to clarify ambiguous requirements, trade-offs, and edge cases **before** creating the implementation plan.

This ensures plans are accurate, comprehensive, and aligned with user expectations.

## Inspiration

Inspired by [@trq212's tweet](https://twitter.com/trq212) about spec-based development:

> "my favorite way to use Claude Code to build large features is spec based
> start with a minimal spec or prompt and ask Claude to interview you using the AskUserQuestionTool
> then make a new session to execute the spec"

We adapted this approach for our workflow:
- **Ticket** (`/1_ticket`) = Initial requirements
- **Interactive Clarification** (in `/2_plan`) = Interview/clarification phase
- **Plan** (`/2_plan`) = Detailed specification
- **Implementation** (`/3_implement`) = Execution

---

## Why Interactive Planning?

### Problem: Plans Based on Assumptions

**Without clarification:**

```
User Request: "Add OAuth authentication"

Claude's Assumptions:
❌ Assumes it replaces existing auth
❌ Assumes JWT tokens
❌ Assumes auto-account-linking
❌ Assumes specific OAuth provider

Result: Plan doesn't match user's actual needs
```

### Solution: Ask Before Planning

**With interactive clarification:**

```
User Request: "Add OAuth authentication"

Claude Asks:
1. Should OAuth replace or supplement existing email/password auth?
2. How should we handle account linking for duplicate emails?
3. Which OAuth providers (Google, GitHub, both)?
4. Should we use JWT or provider tokens?

User Answers → Accurate plan aligned with expectations
```

---

## How It Works

### Workflow

```
┌────────────────────────────────────────┐
│  1. /1_ticket                          │
│     Creates initial requirements       │
└────────────────────────────────────────┘
                  ↓
┌────────────────────────────────────────┐
│  2. /2_plan                            │
│                                        │
│  Step 1: Load Ticket                  │
│  Step 2: Interactive Clarification ✨  │
│          ↓ AskUserQuestion            │
│          ↓ Get Answers                │
│  Step 3: Research                     │
│  Step 4: Create Tasks                 │
│  Step 5: Generate Plan                │
└────────────────────────────────────────┘
                  ↓
┌────────────────────────────────────────┐
│  3. /3_implement                       │
│     Execute the clarified plan         │
└────────────────────────────────────────┘
```

### Step 2: Interactive Clarification

**What happens:**

1. **Review ticket** - Understand initial requirements
2. **Identify unclear areas** - Find ambiguities, multiple approaches, edge cases
3. **Formulate questions** - Group related questions, provide context
4. **Ask user** - Use `AskUserQuestion` tool with all questions at once
5. **Get answers** - Wait for user responses
6. **Document clarifications** - Add to plan
7. **Continue planning** - Proceed with confidence

---

## When to Ask Questions

### ✅ Always Ask When

| Scenario | Example Question |
|----------|------------------|
| **Multiple approaches** | "Should we use approach A (simpler) or B (more flexible)?" |
| **Ambiguous requirements** | "The ticket mentions 'notifications' - should these be in-app, email, or both?" |
| **Trade-offs** | "Performance vs maintainability: should we cache at DB or app level?" |
| **Edge cases** | "How should we handle users who are offline when this happens?" |
| **Integration unclear** | "Should this integrate with the existing dashboard or be standalone?" |
| **UI/UX decisions** | "Where should the export button go? Header or footer?" |
| **Business rules** | "Who should have permission to delete? Admins only or all users?" |

### ❌ Don't Ask When

| Scenario | Why Not |
|----------|---------|
| **Already in ticket** | "What color should the button be?" (if ticket says blue) |
| **Best practice** | "Should we validate inputs?" (always yes - check best-practices/) |
| **Obvious** | "Should we handle errors?" (obviously yes) |
| **Researchable** | "What's the syntax for X?" (look it up) |
| **Doesn't affect implementation** | "What's your favorite framework?" (irrelevant) |

---

## Question Types

### 1. Scope Questions

**When:** Feature boundaries unclear

**Examples:**
```
❓ "Should this feature also handle X scenario, or is that out of scope?"
❓ "Do we need to support Y use case, or just Z?"
❓ "Should this work for anonymous users or only authenticated?"
```

### 2. Behavior Questions

**When:** Expected behavior not specified

**Examples:**
```
❓ "When error Y happens, should we:
    a) Show error message and retry
    b) Fail silently and log
    c) Redirect to error page"

❓ "If the user hasn't set up X yet, should we:
    a) Guide them through setup
    b) Show a placeholder
    c) Hide the feature"
```

### 3. Integration Questions

**When:** How components connect is unclear

**Examples:**
```
❓ "Should this integrate with the existing notification system or be separate?"
❓ "Should we reuse the user service or create a new one?"
❓ "How should this interact with the payment workflow?"
```

### 4. Trade-off Questions

**When:** Technical choices need user input

**Examples:**
```
❓ "Trade-off decision:
    Option A: Real-time updates (complex, resource-intensive)
    Option B: Polling every 30s (simpler, lower resources)

    Which approach fits your priorities better?"

❓ "For data storage:
    Option A: Store in DB (persistent, slower reads)
    Option B: Store in cache (fast, volatile)

    What matters more: speed or persistence?"
```

### 5. Edge Case Questions

**When:** Unusual scenarios not addressed

**Examples:**
```
❓ "What should happen if a user tries to X while Y is in progress?"
❓ "How should we handle concurrent edits to the same resource?"
❓ "What if the third-party API is down?"
```

### 6. UI/UX Questions

**When:** Interface decisions needed

**Examples:**
```
❓ "Where should the export button be placed:
    a) In the header
    b) At the bottom of the table
    c) In a dropdown menu"

❓ "Should validation errors show:
    a) Inline next to each field
    b) In a toast notification
    c) Both"
```

### 7. Security/Permissions Questions

**When:** Access control not specified

**Examples:**
```
❓ "Who should be able to delete items:
    a) Only admins
    b) Item owners
    c) Anyone in the workspace"

❓ "Should API keys be:
    a) User-specific
    b) Workspace-specific
    c) Organization-specific"
```

---

## Guidelines for Good Questions

### 1. Group Related Questions

**❌ Bad (One at a time):**
```
AskUserQuestion("Should OAuth replace existing auth?")
// Wait for answer...
AskUserQuestion("Which OAuth providers?")
// Wait for answer...
AskUserQuestion("How to handle duplicate emails?")
```

**✅ Good (All together):**
```
AskUserQuestion("I have questions about the OAuth implementation:

1. **Auth Strategy**: Should OAuth:
   - Replace existing email/password auth entirely
   - Work alongside as an additional option

2. **OAuth Providers**: Which providers should we support:
   - Google only
   - GitHub only
   - Both Google and GitHub
   - Configurable (can add more later)

3. **Account Linking**: For duplicate emails, should we:
   - Automatically link accounts
   - Ask user to confirm linking
   - Treat as separate accounts

Please answer all three so I can create an accurate plan.")
```

### 2. Be Specific with Context

**❌ Bad (Vague):**
```
"How should errors work?"
```

**✅ Good (Specific):**
```
"When OAuth authentication fails (e.g., user denies permission), should we:
- Show an error message and return to login page
- Retry with a different provider option
- Fall back to email/password login

This affects error handling in the auth flow."
```

### 3. Explain Why It Matters

**❌ Bad (No context):**
```
"Should we cache this data?"
```

**✅ Good (Explains impact):**
```
"**Caching Decision**: User profile data is fetched frequently (every page load).

Option A: Cache for 5 minutes
  ✅ Faster page loads
  ❌ Profile changes take up to 5min to appear

Option B: Fetch fresh every time
  ✅ Always up-to-date
  ❌ Slower page loads, more DB queries

Which trade-off fits your priorities?"
```

### 4. Suggest Defaults

**❌ Bad (No guidance):**
```
"What should we do here?"
```

**✅ Good (Suggests default):**
```
"**Recommended**: Store OAuth tokens in HTTP-only cookies (more secure).

Alternative: Store in localStorage (simpler but less secure).

Unless you have security concerns, I recommend cookies. Which would you prefer?"
```

### 5. Stop When Clear

**❌ Bad (Over-asking):**
```
1. Should buttons be rounded?
2. What radius for rounded corners?
3. Should all buttons have same radius?
4. What about mobile vs desktop?
5. Should icon buttons also be rounded?
6. ...15 more questions...
```

**✅ Good (Focus on essentials):**
```
1. UI follows existing design system? (yes/no)
   If no:
   2. Rounded or square buttons?
   3. Match existing components or new style?
```

---

## Real-World Examples

### Example 1: OAuth Integration

**Ticket:** "Add OAuth authentication with Google"

**Clarifying Questions:**
```markdown
I have a few questions about the OAuth integration:

1. **Existing Auth**: Should OAuth:
   - ✅ Work alongside existing email/password (add "Sign in with Google" button)
   - Replace email/password entirely

2. **Account Linking**: If a user's Google email matches an existing account:
   - Automatically link the accounts
   - ✅ Ask user to confirm linking first
   - Keep them separate

3. **New User Flow**: For users signing up with Google:
   - ✅ Create account automatically
   - Show signup form pre-filled with Google data

4. **Session Management**:
   - ✅ Use our existing JWT system
   - Use Google's tokens directly

I've marked my recommendations (✅). Please confirm or adjust these choices.
```

**User Response:**
```
Agree with all recommendations except #2 - let's automatically link accounts
if the email matches. We trust Google's verification.
```

**Documented in Plan:**
```markdown
## Clarifications (from user)

**Q: Account linking strategy for duplicate emails**
A: Automatically link accounts when Google email matches existing account
Decision: Skip confirmation step, trust Google's email verification.
          Add security log entry when linking occurs.

**Q: OAuth integration approach**
A: Confirmed - work alongside existing auth, don't replace
Decision: Add "Sign in with Google" button to login page.
          Keep email/password as fallback.
```

---

### Example 2: Export Feature

**Ticket:** "Add data export functionality"

**Clarifying Questions:**
```markdown
Questions about the export feature:

1. **Export Format**: Which formats should we support:
   - ✅ CSV only (simplest)
   - JSON only
   - Both CSV and JSON
   - Excel (.xlsx) as well

2. **Data Scope**: What data should be exportable:
   - Current page/table view only
   - All data (entire dataset)
   - ✅ User-selected rows
   - Let user choose between all three

3. **Large Datasets**: If export has >10,000 rows:
   - ✅ Generate asynchronously, email download link
   - Stream directly (might time out)
   - Show error, suggest filtering first

4. **Security**: Who can export:
   - Anyone (including free users)
   - ✅ Paid users only
   - Admins only

Recommendations marked (✅). Please adjust if needed.
```

**User Response:**
```
1. Let's support both CSV and JSON - our users need both
2. Agree on user-selected rows
3. Good idea on async for large exports
4. Actually, let everyone export but limit free users to 1000 rows max
```

**Documented in Plan:**
```markdown
## Clarifications (from user)

**Q: Export formats to support**
A: Support both CSV and JSON (user chooses format)
Decision: Add format selector in export dialog.
          Implement both formatters.

**Q: Export limits and permissions**
A: All users can export, but free tier limited to 1000 rows
Decision: Check user tier before export.
          Show upgrade prompt if selection exceeds limit.
          Paid users = unlimited.
```

---

## Benefits

### 1. **Accurate Plans**

**Before:**
```
Plan based on assumptions
    ↓
Implementation doesn't match expectations
    ↓
Rework required
    ↓
Wasted time
```

**After:**
```
Plan based on clarifications
    ↓
Implementation matches expectations
    ↓
First-time right
    ↓
Time saved
```

### 2. **Better User Involvement**

**Before:**
- User provides vague requirements
- Claude makes assumptions
- User sees final result: "That's not what I wanted"

**After:**
- User provides initial requirements
- Claude asks clarifying questions
- User makes informed decisions
- Claude builds exactly what user wants

### 3. **Reduced Rework**

**Stat from [@trq212's approach]:**
> "Dramatically reduces back-and-forth during implementation"

**Why:**
- Ambiguities resolved upfront
- Trade-offs discussed before coding
- Edge cases addressed in planning

### 4. **Learning Tool**

**For Claude:**
- Understands user's priorities
- Learns project-specific preferences
- Builds better mental model

**For User:**
- Thinks through edge cases early
- Makes informed technical decisions
- Understands implementation trade-offs

---

## Integration with Workflow

### Enhanced Workflow

```
┌─────────────────────────────────────────┐
│  /1_ticket "Add OAuth"                  │
│  → Creates initial requirements         │
│  → Documents similar implementations    │
└─────────────────────────────────────────┘
                  ↓
┌─────────────────────────────────────────┐
│  /2_plan .claude/tasks/add-oauth        │
│                                         │
│  1. Loads ticket                        │
│  2. ✨ Asks clarifying questions        │
│     "I have 3 questions..."             │
│     ↓ Wait for user answers             │
│  3. Research with answers in mind       │
│  4. Create tasks based on clarifications│
│  5. Generate plan with documented       │
│     decisions                           │
└─────────────────────────────────────────┘
                  ↓
┌─────────────────────────────────────────┐
│  /3_implement .claude/tasks/add-oauth   │
│  → Executes plan with confidence        │
│  → No mid-implementation questions      │
└─────────────────────────────────────────┘
                  ↓
┌─────────────────────────────────────────┐
│  /4_review .claude/tasks/add-oauth      │
│  → Validates against clarified plan     │
└─────────────────────────────────────────┘
```

---

## Best Practices

### DO ✅

1. **Ask Early** - Clarify before deep research/planning
2. **Batch Questions** - Ask all related questions together
3. **Provide Context** - Explain why you're asking
4. **Suggest Defaults** - Show recommended options
5. **Document Answers** - Add clarifications to plan
6. **Be Specific** - Give concrete options, not open-ended
7. **Explain Trade-offs** - Help user understand implications

### DON'T ❌

1. **Ask One-by-One** - Don't ping-pong with user
2. **Ask Obvious** - Don't ask things covered in ticket
3. **Ask Everything** - Focus on what affects implementation
4. **Be Vague** - Don't ask "What do you want?"
5. **Skip When Needed** - Don't avoid asking important questions
6. **Ignore Answers** - Always incorporate user's input
7. **Over-Ask** - Stop when you have enough clarity

---

## Troubleshooting

### Issue: User doesn't know the answer

**Solution:**
- Provide more context about trade-offs
- Suggest a default and ask for confirmation
- Explain implications of each option
- Offer to research and present findings

**Example:**
```
"I don't know which caching strategy is better"

Response:
"Let me explain the trade-offs:

Option A: Redis cache
- Pros: Very fast, shared across servers
- Cons: Another service to manage, costs $

Option B: In-memory cache
- Pros: Simple, no extra service
- Cons: Lost on restart, not shared between servers

For your scale (< 1000 users), I recommend Option B (simpler).
We can migrate to Redis later if needed. Sound good?"
```

### Issue: Too many questions

**Solution:**
- Prioritize by impact
- Group related questions
- Save minor details for implementation
- Focus on architecture/scope decisions

**Example:**
```
Instead of 10 questions about button styling,
Ask 1 question: "Should UI match existing design system? (yes/no)"
```

### Issue: User's answer is ambiguous

**Solution:**
- Paraphrase and confirm understanding
- Provide concrete example
- Ask follow-up if needed

**Example:**
```
User: "Make it flexible"

Response:
"By 'flexible', do you mean:
a) Support multiple providers (Google, GitHub, etc.)
b) Allow configuration without code changes
c) Both

Confirming this will help me design the right architecture."
```

---

## Success Metrics

### Indicators of Good Clarification

✅ User feels involved in decision-making
✅ Plan has zero ambiguities
✅ Implementation proceeds without mid-stream changes
✅ Final result matches user's expectations
✅ Fewer "that's not what I meant" moments

### Indicators of Poor Clarification

❌ User feels overwhelmed by questions
❌ Questions are obvious or already answered
❌ Plan still has ambiguities
❌ User says "I don't know" to most questions
❌ Questions don't affect implementation

---

## Comparison: With vs Without

### Feature: "Add notifications"

**Without Clarification:**

```
Ticket: "Add notifications"
    ↓
Plan assumes:
- In-app notifications only
- Real-time updates
- Stored in database
    ↓
Implementation built
    ↓
User: "I wanted email notifications too"
    ↓
Rework required
```

**With Clarification:**

```
Ticket: "Add notifications"
    ↓
Questions:
1. In-app, email, or both?
2. Real-time or digest?
3. What events trigger notifications?
    ↓
User answers:
1. Both in-app and email
2. In-app real-time, email daily digest
3. Mentions, comments, status changes
    ↓
Plan built with this clarity
    ↓
Implementation matches expectations
```

---

## Advanced Techniques

### 1. Conditional Questions

```markdown
"Initial question: Should this feature be public or require login?

If login required → Follow-up: Which user roles can access?
If public → Follow-up: Should we add rate limiting?"
```

### 2. Matrix Questions

```markdown
"**Permission Matrix**: Please fill in who can perform each action:

|  Action  | Admin | Manager | User | Guest |
|----------|-------|---------|------|-------|
| View     | ?     | ?       | ?    | ?     |
| Create   | ?     | ?       | ?    | ?     |
| Edit own | ?     | ?       | ?    | ?     |
| Edit any | ?     | ?       | ?    | ?     |
| Delete   | ?     | ?       | ?    | ?     |

Please mark Y/N for each cell."
```

### 3. Scenario-Based Questions

```markdown
"**Scenario 1**: User uploads a 100MB file
Should we:
a) Accept it (no limit)
b) Reject with error
c) Accept but compress
d) Other (please describe)

**Scenario 2**: User uploads corrupted file
Should we:
a) Auto-detect and reject
b) Accept and show error on open
c) Auto-repair if possible
d) Other (please describe)"
```

---

## Conclusion

Interactive planning with clarifying questions:

✅ **Reduces assumptions** - Plans based on facts, not guesses
✅ **Engages users** - Involves user in technical decisions
✅ **Saves time** - Less rework from misunderstandings
✅ **Improves quality** - Edge cases addressed early
✅ **Builds trust** - User sees thoughtful consideration

**Use it for every `/2_plan` where any ambiguity exists!**

---

**Credits:**
- Inspired by [@trq212's spec-based development approach](https://twitter.com/trq212)
- Adapted for claude-code-agentic-engineering workflow
- Integrated with ticket → plan → implement → review process
