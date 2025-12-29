# Pattern Compliance: Validating Against Similar Implementations

## Overview

Pattern Compliance is a validation mechanism that ensures new implementations match existing patterns in the codebase. This creates a **third dimension of code quality**:

1. **Best Practices Compliance** - Follows documented coding standards
2. **Pattern Compliance** - Matches existing similar implementations (NEW)
3. **Code Quality** - Technical correctness and maintainability

## Why Pattern Compliance Matters

### Problem: Inconsistent Implementations

Without pattern compliance checking:

```typescript
// Existing user service (established pattern)
async function createUser(data: UserCreateDTO): Promise<User> {
  try {
    const validated = await userSchema.validate(data);
    const user = await db.users.create(validated);
    await sendWelcomeEmail(user.email);
    return user;
  } catch (error) {
    logger.error('User creation failed', { error, data });
    throw new AppError('CREATION_FAILED', error.message);
  }
}

// New team service (different pattern - INCONSISTENT!)
function addTeam(teamData) {  // ❌ Different: no types
  return db.teams.create(teamData)  // ❌ Different: no validation
    .then(team => {  // ❌ Different: promises not async/await
      console.log('Team added');  // ❌ Different: console not logger
      return team;
    })
    .catch(err => {  // ❌ Different: basic error not AppError
      throw err;
    });
}
```

**Result**: Inconsistent codebase that's harder to maintain

### Solution: Pattern Compliance Validation

With pattern compliance:

```typescript
// New team service (CONSISTENT with user service pattern)
async function createTeam(data: TeamCreateDTO): Promise<Team> {  // ✅ Matches types pattern
  try {
    const validated = await teamSchema.validate(data);  // ✅ Matches validation pattern
    const team = await db.teams.create(validated);  // ✅ Matches async/await pattern
    await sendTeamWelcomeEmail(team.adminEmail);  // ✅ Matches notification pattern
    return team;
  } catch (error) {
    logger.error('Team creation failed', { error, data });  // ✅ Matches logging pattern
    throw new AppError('CREATION_FAILED', error.message);  // ✅ Matches error pattern
  }
}
```

**Result**: Consistent, maintainable codebase

---

## How It Works

### Phase 1: Discovery (in /1_ticket)

When creating a ticket, the system:

1. **Finds Similar Implementations**
   - Uses `feature-finder` agent to discover existing similar code
   - Identifies patterns in naming, structure, error handling

2. **Documents Patterns in Ticket**
   ```markdown
   ## Similar Implementations in Codebase

   **Pattern**: User creation service
   - **Location**: src/services/user.service.ts:45
   - **Key Approach**: Async validation → DB create → Notification → Return
   - **Patterns to Follow**:
     * Use async/await (not promises)
     * Validate with schema before DB operation
     * Use structured logging
     * Throw AppError for consistency
   - **Example**:
     ```typescript
     async function createUser(data: UserCreateDTO): Promise<User> {
       try {
         const validated = await userSchema.validate(data);
         const user = await db.users.create(validated);
         await sendWelcomeEmail(user.email);
         return user;
       } catch (error) {
         logger.error('User creation failed', { error, data });
         throw new AppError('CREATION_FAILED', error.message);
       }
     }
     ```

   This implementation should follow the same patterns for consistency.
   ```

3. **Adds to Acceptance Criteria**
   ```markdown
   - [ ] Implementation matches patterns from similar existing code
   ```

### Phase 2: Validation (in /4_review)

When reviewing code, the system:

1. **Reads Similar Implementations Section** from ticket

2. **Loads Reference Implementation**
   ```typescript
   Read("src/services/user.service.ts")
   ```

3. **Compares New Implementation**
   - Naming conventions
   - Code structure
   - Error handling
   - Return types
   - API design

4. **Reports Deviations**
   ```markdown
   ## Pattern Compliance

   **Overall Pattern Match**: 80% (4/5 patterns followed)

   ### ❌ Pattern Deviations

   - **Pattern Deviation: Error Handling** (ref: ticket "Similar Implementations")
     - **File**: src/services/team.service.ts:52
     - **Issue**: Using generic Error instead of AppError
     - **Expected Pattern** (from src/services/user.service.ts:45):
       ```typescript
       throw new AppError('CREATION_FAILED', error.message);
       ```
     - **Actual Implementation**:
       ```typescript
       throw new Error(`Failed: ${error.message}`);
       ```
     - **Fix**: Use AppError class for consistency
     - **Impact**: Inconsistent error handling makes debugging harder
   ```

---

## Pattern Aspects Checked

### 1. Naming Conventions

**What's Checked:**
- Function/method names follow same pattern
- Variable naming matches conventions
- File/module naming consistent

**Examples:**

| Existing Pattern | Compliant | Non-Compliant |
|-----------------|-----------|---------------|
| `createUser()` | `createTeam()` ✅ | `addTeam()` ❌ |
| `getUserById()` | `getTeamById()` ✅ | `fetchTeam()` ❌ |
| `user.service.ts` | `team.service.ts` ✅ | `teams.ts` ❌ |

### 2. Code Structure

**What's Checked:**
- Same folder organization for similar features
- Similar file structure
- Consistent module organization

**Examples:**

```
Existing Pattern:
src/services/user/
├── user.service.ts
├── user.schema.ts
├── user.dto.ts
└── user.types.ts

✅ Compliant:
src/services/team/
├── team.service.ts
├── team.schema.ts
├── team.dto.ts
└── team.types.ts

❌ Non-Compliant:
src/team-service.ts  (different organization)
```

### 3. Error Handling

**What's Checked:**
- Same error handling approach
- Consistent error types
- Similar logging patterns

**Examples:**

```typescript
// Existing Pattern
try {
  // operation
} catch (error) {
  logger.error('Operation failed', { error });
  throw new AppError('CODE', error.message);
}

// ✅ Compliant
try {
  // operation
} catch (error) {
  logger.error('Team operation failed', { error });
  throw new AppError('TEAM_ERROR', error.message);
}

// ❌ Non-Compliant
try {
  // operation
} catch (error) {
  console.error(error);  // Different logging
  throw error;  // Different error type
}
```

### 4. Return Types

**What's Checked:**
- Consistent return type patterns
- Similar async/await usage
- Matching promise patterns

**Examples:**

```typescript
// Existing Pattern
async function createUser(data: UserCreateDTO): Promise<User>

// ✅ Compliant
async function createTeam(data: TeamCreateDTO): Promise<Team>

// ❌ Non-Compliant
function createTeam(data: any): Promise<any>  // Less specific
function createTeam(data: TeamData): Team | null  // Different pattern
```

### 5. API Design

**What's Checked:**
- Consistent endpoint patterns
- Similar request/response structures
- Matching parameter patterns

**Examples:**

```typescript
// Existing Pattern
router.post('/users', validateBody(userSchema), createUser);

// ✅ Compliant
router.post('/teams', validateBody(teamSchema), createTeam);

// ❌ Non-Compliant
router.post('/teams', createTeam);  // Missing validation middleware
router.post('/team/create', createTeam);  // Different path pattern
```

---

## Review Report Format

### Pattern Compliance Section

```markdown
## Pattern Compliance

**Overall Pattern Match**: 85% (6/7 patterns followed)

### ✅ Patterns Followed

- **Naming Convention** (from src/services/user.service.ts:45)
  - Function name follows `create{Entity}` pattern
  - Variables use camelCase consistently
  - Types use PascalCase with DTO suffix

- **Async/Await Pattern** (from src/services/user.service.ts:45)
  - Uses async/await instead of .then()/.catch()
  - Proper error propagation
  - Consistent promise handling

- **Validation Pattern** (from src/services/user.service.ts:50)
  - Schema validation before DB operation
  - Uses same validation library
  - Consistent error messages

### ❌ Pattern Deviations

#### High Severity

- **Pattern Deviation: Error Handling** (ref: ticket "Similar Implementations")
  - **File**: src/services/team.service.ts:52
  - **Issue**: Not using AppError class consistently
  - **Expected Pattern** (from src/services/user.service.ts:62):
    ```typescript
    throw new AppError('CREATION_FAILED', error.message);
    ```
  - **Actual Implementation**:
    ```typescript
    throw new Error(`Team creation failed: ${error}`);
    ```
  - **Fix**: Replace with `throw new AppError('TEAM_CREATION_FAILED', error.message);`
  - **Impact**: Inconsistent error handling breaks error monitoring

#### Medium Severity

- **Pattern Deviation: Logging Format** (ref: ticket "Similar Implementations")
  - **File**: src/services/team.service.ts:58
  - **Issue**: Missing structured logging context
  - **Expected Pattern**:
    ```typescript
    logger.error('User creation failed', { error, data });
    ```
  - **Actual Implementation**:
    ```typescript
    logger.error('Team creation failed');
    ```
  - **Fix**: Add context object: `logger.error('Team creation failed', { error, data });`
  - **Impact**: Harder to debug issues without context
```

---

## Benefits

### 1. **Consistency Across Codebase**

**Before:**
- Each developer implements features differently
- Similar features have different patterns
- Hard to predict where things are

**After:**
- Consistent patterns across similar features
- Predictable codebase structure
- Easy to find and understand code

### 2. **Faster Onboarding**

**Before:**
- New developers must figure out patterns by trial and error
- Inconsistent feedback in code reviews
- Long learning curve

**After:**
- Clear examples to follow
- Automated consistency checking
- Faster time to productivity

### 3. **Reduced Maintenance Cost**

**Before:**
- Different error handling in each module
- Inconsistent logging makes debugging hard
- Pattern inconsistency causes bugs

**After:**
- Uniform error handling and logging
- Easier debugging
- Fewer bugs from inconsistency

### 4. **Better Code Reviews**

**Before:**
- Reviewers give subjective "I prefer..." feedback
- Inconsistent review standards
- Hard to explain why something should change

**After:**
- Objective "This doesn't match the established pattern" feedback
- Consistent review standards
- Clear references to follow

---

## Integration with Existing Compliance

### Three Dimensions of Quality

```
┌─────────────────────────────────────────────┐
│ 1. Best Practices Compliance                │
│    ↓                                        │
│    Follows documented coding standards      │
│    (.claude/best-practices/)                │
└─────────────────────────────────────────────┘
                  ↓
┌─────────────────────────────────────────────┐
│ 2. Pattern Compliance (NEW)                 │
│    ↓                                        │
│    Matches existing similar implementations │
│    (from ticket "Similar Implementations")  │
└─────────────────────────────────────────────┘
                  ↓
┌─────────────────────────────────────────────┐
│ 3. Code Quality                             │
│    ↓                                        │
│    Technical correctness                    │
│    (linting, type-checking, security)       │
└─────────────────────────────────────────────┘
```

### Combined Compliance Score

```markdown
**Date**: 2025-12-28
**Quality**: 8/10
**Best Practices Compliance**: 90% (18/20 guidelines)
**Pattern Compliance**: 85% (6/7 patterns matched)  ← NEW
**Overall Compliance**: 87.5%
**Status**: Warning
```

---

## Examples

### Example 1: Creating a New Service

**Ticket** (from /1_ticket):
```markdown
## Similar Implementations in Codebase

**Pattern**: User Service
- **Location**: src/services/user.service.ts:20-80
- **Key Approach**: Class-based service with dependency injection
- **Patterns to Follow**:
  * Export as singleton instance
  * Constructor takes dependencies (db, logger)
  * All methods are async
  * Use private methods for internal logic
- **Example**:
  ```typescript
  class UserService {
    constructor(
      private db: Database,
      private logger: Logger
    ) {}

    async create(data: UserCreateDTO): Promise<User> {
      // implementation
    }

    private async validate(data: unknown): Promise<UserCreateDTO> {
      // validation logic
    }
  }

  export const userService = new UserService(db, logger);
  ```
```

**Implementation** (compliant):
```typescript
// src/services/team.service.ts
class TeamService {  // ✅ Matches class-based pattern
  constructor(
    private db: Database,  // ✅ Same dependency injection
    private logger: Logger
  ) {}

  async create(data: TeamCreateDTO): Promise<Team> {  // ✅ Same method pattern
    const validated = await this.validate(data);  // ✅ Uses private method
    return await this.db.teams.create(validated);
  }

  private async validate(data: unknown): Promise<TeamCreateDTO> {  // ✅ Private method pattern
    return await teamSchema.validate(data);
  }
}

export const teamService = new TeamService(db, logger);  // ✅ Singleton export
```

**Review Result**:
```markdown
## Pattern Compliance: 100% (5/5 patterns matched) ✅
```

---

### Example 2: Creating an API Endpoint

**Ticket**:
```markdown
## Similar Implementations in Codebase

**Pattern**: User API Endpoints
- **Location**: src/api/users.ts:15-45
- **Patterns to Follow**:
  * Use express Router
  * Validate request body with middleware
  * Use async route handlers
  * Return consistent JSON responses
  * Include error handling
```

**Implementation** (with deviation):
```typescript
// src/api/teams.ts
const router = express.Router();  // ✅ Uses Router

router.post('/teams',  // ✅ POST method
  validateBody(teamSchema),  // ✅ Validation middleware
  (req, res) => {  // ❌ Not async!
    const team = teamService.create(req.body);  // ❌ Not awaited!
    res.json(team);  // ✅ JSON response
  }
);
```

**Review Result**:
```markdown
## Pattern Compliance: 60% (3/5 patterns matched)

### ❌ Pattern Deviations

- **Async Handler Pattern** (ref: ticket)
  - **File**: src/api/teams.ts:5
  - **Issue**: Route handler not async, missing await
  - **Expected**:
    ```typescript
    async (req, res) => {
      const team = await teamService.create(req.body);
      res.json(team);
    }
    ```
  - **Fix**: Add async/await
```

---

## Best Practices for Pattern Compliance

### DO ✅

1. **Document Clear Patterns in Tickets**
   - Include specific file references
   - Show code examples
   - Explain WHY the pattern exists

2. **Keep Patterns Reasonable**
   - Don't force patterns where they don't fit
   - Allow justified deviations
   - Update patterns when they become outdated

3. **Explain Deviations**
   - If you must deviate, document why in code comments
   - Discuss with team before major pattern changes

4. **Use as Learning Tool**
   - Help new developers learn established patterns
   - Use deviations as teaching moments

### DON'T ❌

1. **Over-Enforce Patterns**
   - Don't block progress for minor deviations
   - Use as guidance, not gates

2. **Ignore Context**
   - Patterns may not fit every situation
   - Consider if deviation is justified

3. **Ossify Patterns**
   - Patterns can evolve
   - Discuss improvements with team

4. **Skip Documentation**
   - Always document why a pattern exists
   - Explain the benefits

---

## Troubleshooting

### Issue: No similar implementations found

**Solution**:
- This is OK for truly novel features
- Skip pattern compliance for unique implementations
- Establish NEW patterns for future similar work

### Issue: Pattern doesn't fit new requirements

**Solution**:
- Document WHY the deviation is necessary
- Discuss with team if this should be a new pattern
- Add to ticket: "Deviates from X pattern because Y"

### Issue: Multiple conflicting patterns

**Solution**:
- Identify which pattern is more recent/better
- Standardize on one pattern
- Document in best practices which to use

---

## Future Enhancements

Potential improvements:

1. **Automated Pattern Detection** - AI finds patterns automatically
2. **Pattern Library** - Catalog of approved patterns
3. **Pattern Versioning** - Track pattern evolution
4. **Auto-Refactor Suggestions** - Generate code to match pattern
5. **Team Pattern Voting** - Democratize pattern adoption

---

**Pattern compliance ensures your codebase stays consistent and maintainable! 🎯**
