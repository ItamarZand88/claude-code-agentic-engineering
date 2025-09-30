# Project Standards

This directory contains project-specific coding standards, best practices, and guidelines that all code must follow.

## Purpose

Standards files are used by the **standards-compliance-agent** during code review (`/4_review_implementation`) to automatically check if implementations follow project conventions.

## Standards Files

### Core Standards (Recommended)

1. **`coding-standards.md`** - General coding conventions
   - Naming conventions
   - Code organization
   - Documentation requirements
   - Error handling patterns

2. **`architecture-patterns.md`** - Architectural guidelines
   - Design patterns to use
   - Layer separation rules
   - Dependency management
   - Module boundaries

3. **`testing-standards.md`** - Testing requirements
   - Test coverage requirements
   - Test structure and organization
   - Mocking/stubbing guidelines
   - Test naming conventions

### Optional Standards

4. **`api-design.md`** - API design principles
5. **`database-guidelines.md`** - Database best practices
6. **`security-practices.md`** - Security requirements
7. **`performance-guidelines.md`** - Performance best practices
8. **`documentation-standards.md`** - Documentation requirements
9. **`ui-ux-guidelines.md`** - Frontend/UI standards
10. **`git-workflow.md`** - Git conventions

## How It Works

1. **Create standards files** in this directory
2. **Run code review**: `/4_review_implementation Circle/{task-name}`
3. **Automatic compliance check**: Standards-compliance-agent reads these files
4. **Get detailed report**: Violations and recommendations in `standards-compliance.yml`

## Example Standard Format

````markdown
# Coding Standards

## Function Naming

✅ **DO**: Use camelCase for function names
```typescript
function getUserById(id: string) { }
```

❌ **DON'T**: Use snake_case or PascalCase
```typescript
function get_user_by_id(id: string) { } // Wrong
function GetUserById(id: string) { }     // Wrong
```

📋 **REQUIRED**: All exported functions must have documentation
```typescript
/**
 * Retrieves a user by their unique identifier
 * @param id - The user's unique ID
 * @returns User object or null if not found
 */
export function getUserById(id: string): User | null {
  // implementation
}
```

## Error Handling

✅ **DO**: Use try-catch for async operations
```typescript
async function fetchData() {
  try {
    const result = await api.getData();
    return result;
  } catch (error) {
    logger.error('Failed to fetch data', error);
    throw new AppError('Data fetch failed');
  }
}
```

❌ **DON'T**: Swallow errors silently
```typescript
async function fetchData() {
  try {
    return await api.getData();
  } catch (error) {
    // Empty catch - BAD!
  }
}
```
````

## Pattern Syntax

Standards-compliance-agent looks for these patterns:

- `✅ DO:` - Recommended practice
- `❌ DON'T:` - Anti-pattern to avoid
- `📋 REQUIRED:` - Mandatory requirement
- `💡 RECOMMENDED:` - Best practice suggestion
- `⚠️ AVOID:` - Problematic pattern

## Getting Started

### Quick Start

1. Create at least 3 core standards files:
   ```bash
   touch Circle/standards/coding-standards.md
   touch Circle/standards/architecture-patterns.md
   touch Circle/standards/testing-standards.md
   ```

2. Add your team's conventions and best practices

3. Run code review to see compliance checks in action

### Example Workflow

```bash
# After implementing a feature
/4_review_implementation Circle/oauth-authentication

# Agent automatically:
# 1. Loads standards from Circle/standards/
# 2. Checks code compliance
# 3. Generates compliance report
# 4. Shows violations and recommendations
```

## Benefits

✅ **Automated consistency**: No manual standard enforcement
✅ **Educational**: Team learns best practices through feedback
✅ **Measurable**: Compliance scores track quality over time
✅ **Actionable**: Specific violations with file/line references
✅ **Scalable**: Standards evolve with the team

## Tips

1. **Start simple**: Begin with core standards, add more as needed
2. **Be specific**: Provide code examples for each rule
3. **Keep updated**: Review and update standards regularly
4. **Make discoverable**: Reference standards in code reviews
5. **Celebrate compliance**: Highlight good examples

## No Standards?

If this directory is empty, the standards-compliance-agent will:
- Note that no standards are defined
- Skip compliance checking
- Provide recommendation to create standards

This is optional but highly recommended for team consistency.

---

**Next Steps**: Create your first standards file! Start with `coding-standards.md`.
