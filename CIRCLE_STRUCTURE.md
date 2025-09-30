# Circle Directory Structure

## Overview

The `Circle/` directory is the organized workspace for all tasks in the agentic engineering framework. Each task gets its own dedicated folder containing all related artifacts.

## Purpose

**Why "Circle"?**
- Represents the complete **circle/cycle** of development: requirements → planning → implementation → review
- Keeps all task-related files **together in one place**
- Makes it easy to **track progress** through the lifecycle
- Provides **clear organization** for multiple concurrent tasks

## Structure

```
Circle/
├── oauth-authentication/
│   ├── ticket.md  # Task requirements (created by command 1)
│   ├── plan.md    # Implementation plan (created by command 2)
│   └── review.md  # Code review (created by command 4)
│
├── user-profile-refactor/
│   ├── ticket.md
│   ├── plan.md
│   └── review.md
│
└── payment-gateway-integration/
    ├── ticket.md
    ├── plan.md
    └── (in progress...)
```

## Folder Naming Convention

**Format**: `{brief-descriptive-name}` in kebab-case

**Examples**:
- ✅ `oauth-authentication`
- ✅ `user-profile-update`
- ✅ `payment-gateway-integration`
- ✅ `refactor-database-layer`
- ❌ `task123` (not descriptive)
- ❌ `OAuth Authentication` (spaces not allowed)
- ❌ `oAuthAuth` (use kebab-case)

## File Contents

### 1. `ticket.md` (Created by `/1_task_from_scratch`)
**Purpose**: Captures task requirements and acceptance criteria

**Contains**:
- Task title and description
- Requirements checklist
- Potentially affected areas
- Dependencies and constraints
- Acceptance criteria
- Open questions

### 2. `plan.md` (Created by `/2_plan_from_task`)
**Purpose**: Comprehensive implementation plan with research

**Contains**:
- Research findings (web + agents)
- Best practices and codebase patterns
- Technical architecture design
- Phase-based implementation tasks
- Testing strategy
- Risk assessment
- Validation commands

### 3. `review.md` (Created by `/4_review_implementation`)
**Purpose**: Comprehensive code review and quality assessment

**Contains**:
- Requirements compliance check (vs ticket.md)
- Code quality assessment
- Security analysis
- Performance insights
- Test coverage validation
- Action items by priority

## Workflow Example

```bash
# Step 1: Create task folder and ticket
$ /1_task_from_scratch "Add OAuth2 authentication"
✅ Created: Circle/oauth-authentication/ticket.md

# Step 2: Generate implementation plan
$ /2_plan_from_task Circle/oauth-authentication
✅ Created: Circle/oauth-authentication/plan.md

# Step 3: Execute implementation (reports progress in real-time)
$ /3_implement_plan Circle/oauth-authentication
✅ Implementation completed (progress shown in terminal)

# Step 4: Code review
$ /4_review_implementation Circle/oauth-authentication
✅ Created: Circle/oauth-authentication/review.md
```

## Benefits

### Organization
- **All artifacts in one place**: No searching across multiple directories
- **Clear progress tracking**: See what stage each task is at
- **Easy context switching**: Each task is self-contained

### Traceability
- **From requirement to review**: Complete audit trail
- **Decision history**: Why choices were made (in plan.md)
- **Implementation details**: Available via git history
- **Quality assessment**: What issues were found (in review.md)

### Collaboration
- **Easy handoffs**: All information in one folder
- **Code review prep**: Reviewers can read ticket + plan + git diff
- **Onboarding**: New team members can see complete examples

### Archival
- **Complete history**: Each task folder is a standalone unit
- **Easy cleanup**: Move completed tasks to archive
- **Reference**: Future tasks can learn from past implementations

## Advanced Usage

### Multiple Tasks in Parallel
```
Circle/
├── feature-a/  (in implementation)
├── feature-b/  (in planning)
└── bugfix-c/   (completed, ready for review)
```

### Task Archives
```bash
# After task completion, optionally archive
mkdir -p Circle/_archive/2024-03/
mv Circle/oauth-authentication/ Circle/_archive/2024-03/
```

### Task Dependencies
Reference other tasks in your ticket or plan:
```markdown
## Dependencies
- Depends on: `Circle/user-authentication/` (completed)
- Blocks: `Circle/admin-panel/` (waiting)
```

## Comparison with Old Structure

### Old (Scattered)
```
./tasks/task-oauth-20240315.md
./plans/plan-oauth-20240315.md
./reviews/review-oauth-20240315.md
```
❌ Files scattered across directories
❌ Hard to track related artifacts
❌ Confusing timestamps in names

### New (Organized)
```
Circle/oauth-authentication/
├── ticket.md
├── plan.md
└── review.md
```
✅ Everything together
✅ Clear folder name
✅ No timestamp confusion
✅ Easy to find and understand

## Tips

1. **Use descriptive names**: Make folder names clear and searchable
2. **One task per folder**: Keep concerns separated
3. **Don't delete**: Archive completed tasks instead of deleting
4. **Reference freely**: Link between tasks when they're related
5. **Keep tickets updated**: If requirements change, update `ticket.md`

## Quick Reference

| Command | Input | Output File |
|---------|-------|-------------|
| `/1_task_from_scratch` | User prompt | `Circle/{name}/ticket.md` |
| `/2_plan_from_task` | `Circle/{name}` | `Circle/{name}/plan.md` |
| `/3_implement_plan` | `Circle/{name}` | (progress in terminal) |
| `/4_review_implementation` | `Circle/{name}` | `Circle/{name}/review.md` |

---

**Next Steps**: Start your first task with `/1_task_from_scratch "your task here"`
