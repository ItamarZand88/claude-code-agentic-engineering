# Coding Standards

> General coding conventions and best practices for the project

## Table of Contents
- [Naming Conventions](#naming-conventions)
- [Code Organization](#code-organization)
- [Documentation](#documentation)
- [Error Handling](#error-handling)
- [Imports and Dependencies](#imports-and-dependencies)

---

## Naming Conventions

### Variables and Functions

✅ **DO**: Use camelCase for variables and functions
```typescript
const userName = "John";
function getUserById(id: string) { }
```

❌ **DON'T**: Use snake_case or PascalCase for variables/functions
```typescript
const user_name = "John";        // Wrong
function get_user_by_id(id) { }  // Wrong
```

### Classes and Types

✅ **DO**: Use PascalCase for classes, interfaces, and types
```typescript
class UserService { }
interface UserData { }
type UserRole = 'admin' | 'user';
```

### Constants

✅ **DO**: Use UPPER_SNAKE_CASE for true constants
```typescript
const MAX_RETRY_ATTEMPTS = 3;
const API_BASE_URL = 'https://api.example.com';
```

### Boolean Variables

💡 **RECOMMENDED**: Prefix with is, has, can, should
```typescript
const isActive = true;
const hasPermission = false;
const canDelete = user.role === 'admin';
```

---

## Code Organization

### File Structure

📋 **REQUIRED**: One primary export per file
```typescript
// ✅ Good: user.service.ts
export class UserService {
  // implementation
}

// ❌ Bad: services.ts with multiple unrelated exports
export class UserService { }
export class PaymentService { }
export class EmailService { }
```

### Function Length

⚠️ **AVOID**: Functions longer than 50 lines
```typescript
// If a function exceeds 50 lines, consider breaking it into smaller functions
function processUserData(data) {
  // Extract into smaller functions:
  const validated = validateData(data);
  const transformed = transformData(validated);
  const saved = saveData(transformed);
  return saved;
}
```

### Nesting Depth

⚠️ **AVOID**: More than 3 levels of nesting
```typescript
// ❌ Too deep
if (user) {
  if (user.isActive) {
    if (user.hasPermission) {
      if (user.role === 'admin') {
        // Too nested!
      }
    }
  }
}

// ✅ Better: Early returns
if (!user) return null;
if (!user.isActive) return null;
if (!user.hasPermission) return null;
if (user.role !== 'admin') return null;
// Now do the work
```

---

## Documentation

### Function Documentation

📋 **REQUIRED**: All exported functions must have JSDoc/TSDoc comments
```typescript
/**
 * Retrieves a user by their unique identifier
 * @param id - The user's unique ID
 * @returns User object or null if not found
 * @throws {UserNotFoundError} If user doesn't exist and throwOnError is true
 */
export function getUserById(id: string): User | null {
  // implementation
}
```

### Complex Logic Comments

💡 **RECOMMENDED**: Explain "why", not "what"
```typescript
// ✅ Good: Explains reasoning
// Use exponential backoff to avoid overwhelming the API during rate limits
await retryWithBackoff(apiCall, 3);

// ❌ Bad: States the obvious
// Retry the API call 3 times
await retryWithBackoff(apiCall, 3);
```

### TODO Comments

✅ **DO**: Include context and owner
```typescript
// TODO(username): Add caching layer for performance - ticket #123
// TODO: This should be refactored when we migrate to v2 API
```

❌ **DON'T**: Leave vague TODOs
```typescript
// TODO: fix this
// TODO: improve
```

---

## Error Handling

### Try-Catch Blocks

📋 **REQUIRED**: Always handle async errors
```typescript
// ✅ Good
async function fetchUserData(id: string) {
  try {
    const response = await api.getUser(id);
    return response.data;
  } catch (error) {
    logger.error('Failed to fetch user', { id, error });
    throw new AppError('User fetch failed', { cause: error });
  }
}
```

❌ **DON'T**: Swallow errors silently
```typescript
// ❌ Bad
async function fetchUserData(id: string) {
  try {
    return await api.getUser(id);
  } catch (error) {
    // Empty catch block - errors disappear!
  }
}
```

### Error Types

✅ **DO**: Use custom error types
```typescript
class ValidationError extends Error {
  constructor(message: string, public field: string) {
    super(message);
    this.name = 'ValidationError';
  }
}

throw new ValidationError('Invalid email format', 'email');
```

### Error Messages

💡 **RECOMMENDED**: Include context in error messages
```typescript
// ✅ Good: Specific and actionable
throw new Error(`Failed to process payment for order ${orderId}: ${reason}`);

// ❌ Bad: Vague
throw new Error('Payment failed');
```

---

## Imports and Dependencies

### Import Order

✅ **DO**: Group imports logically
```typescript
// 1. External dependencies
import React from 'react';
import { z } from 'zod';

// 2. Internal modules
import { UserService } from '@/services/user';
import { logger } from '@/utils/logger';

// 3. Relative imports
import { Button } from './Button';
import { styles } from './styles';
```

### Avoid Circular Dependencies

⚠️ **AVOID**: Circular imports between modules
```typescript
// ❌ Bad: user.ts imports order.ts, order.ts imports user.ts

// ✅ Good: Extract shared code to a common module
// shared/types.ts
export interface User { }
export interface Order { }
```

### Barrel Exports

💡 **RECOMMENDED**: Use index files for clean exports
```typescript
// services/index.ts
export { UserService } from './user.service';
export { PaymentService } from './payment.service';

// Usage
import { UserService, PaymentService } from '@/services';
```

---

## General Best Practices

### Magic Numbers

⚠️ **AVOID**: Magic numbers in code
```typescript
// ❌ Bad
if (user.age > 18) { }

// ✅ Good
const LEGAL_AGE = 18;
if (user.age > LEGAL_AGE) { }
```

### String Concatenation

💡 **RECOMMENDED**: Use template literals
```typescript
// ✅ Good
const greeting = `Hello, ${user.name}!`;

// ❌ Avoid
const greeting = 'Hello, ' + user.name + '!';
```

### Null vs Undefined

✅ **DO**: Be consistent - prefer `null` for intentional absence
```typescript
function findUser(id: string): User | null {
  // Return null if not found
  return user || null;
}
```

### Boolean Expressions

✅ **DO**: Keep boolean expressions simple
```typescript
// ✅ Good
if (isAdmin) { }
if (!isActive) { }

// ❌ Avoid
if (isAdmin === true) { }
if (isActive === false) { }
```

---

## Code Smells to Avoid

1. **Duplicate code** - Extract to functions
2. **Long parameter lists** - Use options objects
3. **Feature envy** - Move logic closer to data
4. **Premature optimization** - Optimize when needed
5. **God objects** - Break into smaller classes

---

_These standards are enforced by the standards-compliance-agent during code review._
