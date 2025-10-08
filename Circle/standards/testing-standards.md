# Testing Standards

> Testing requirements and best practices for the project

## Table of Contents

- [Test Coverage](#test-coverage)
- [Test Structure](#test-structure)
- [Test Types](#test-types)
- [Mocking and Stubbing](#mocking-and-stubbing)
- [Test Naming](#test-naming)

---

## Test Coverage

### Minimum Requirements

📋 **REQUIRED**: Minimum 80% code coverage

```yaml
coverage:
  statements: 80%
  branches: 80%
  functions: 80%
  lines: 80%
```

### Critical Paths

📋 **REQUIRED**: 100% coverage for critical paths

- Authentication/Authorization
- Payment processing
- Data validation

### New Code

📋 **REQUIRED**: All new code must include tests

```typescript
// ❌ Bad: No tests for new feature
export function processPayment(amount: number) {
  // implementation
}

// ✅ Good: Tests accompany new code
export function processPayment(amount: number) {
  // implementation
}

// processPayment.test.ts
describe("processPayment", () => {
  it("should process valid payments", () => {});
  it("should reject negative amounts", () => {});
  it("should handle payment failures", () => {});
});
```

---

## Test Structure

### AAA Pattern

📋 **REQUIRED**: Use Arrange-Act-Assert pattern

```typescript
// ✅ Good: Clear AAA structure
it("should create a new user", async () => {
  // Arrange
  const userData = { name: "John", email: "john@example.com" };
  const mockRepo = createMockRepository();

  // Act
  const result = await userService.create(userData);

  // Assert
  expect(result).toBeDefined();
  expect(result.name).toBe("John");
  expect(mockRepo.create).toHaveBeenCalledWith(userData);
});
```

### Test Independence

📋 **REQUIRED**: Tests must be independent

```typescript
// ❌ Bad: Tests depend on each other
let user: User;

it("should create user", () => {
  user = createUser(); // Sets shared state
});

it("should update user", () => {
  updateUser(user); // Depends on previous test
});

// ✅ Good: Each test is self-contained
it("should create user", () => {
  const user = createUser();
  expect(user).toBeDefined();
});

it("should update user", () => {
  const user = createUser(); // Fresh setup
  updateUser(user);
  expect(user.updated).toBe(true);
});
```

### Test Data

💡 **RECOMMENDED**: Use factories for test data

```typescript
// ✅ Good: Test data factory
const userFactory = {
  build: (overrides?: Partial<User>): User => ({
    id: "test-id",
    name: "Test User",
    email: "test@example.com",
    ...overrides,
  }),
};

// Usage
it("should handle admin users", () => {
  const admin = userFactory.build({ role: "admin" });
  // ...
});
```

---

## Test Types

### Unit Tests

📋 **REQUIRED**: Test individual functions/classes in isolation

```typescript
// ✅ Good: Unit test with mocked dependencies
describe("UserService", () => {
  let userService: UserService;
  let mockRepo: jest.Mocked<UserRepository>;
  let mockEmail: jest.Mocked<EmailService>;

  beforeEach(() => {
    mockRepo = createMockRepository();
    mockEmail = createMockEmailService();
    userService = new UserService(mockRepo, mockEmail);
  });

  it("should send welcome email on user creation", async () => {
    const userData = { email: "test@example.com" };

    await userService.create(userData);

    expect(mockEmail.sendWelcome).toHaveBeenCalledWith(userData.email);
  });
});
```

### Integration Tests

📋 **REQUIRED**: Test API endpoints end-to-end

```typescript
// ✅ Good: Integration test for API endpoint
describe("POST /api/users", () => {
  it("should create a new user", async () => {
    const response = await request(app)
      .post("/api/users")
      .send({ name: "John", email: "john@example.com" })
      .expect(201);

    expect(response.body).toMatchObject({
      name: "John",
      email: "john@example.com",
    });

    // Verify in database
    const user = await db.users.findOne({ email: "john@example.com" });
    expect(user).toBeDefined();
  });
});
```

### E2E Tests (Optional)

💡 **RECOMMENDED**: Test critical user flows

```typescript
// ✅ Good: E2E test for complete workflow
describe("User Registration Flow", () => {
  it("should complete full registration process", async () => {
    // Register
    await page.goto("/register");
    await page.fill('[name="email"]', "test@example.com");
    await page.fill('[name="password"]', "securepass");
    await page.click('button[type="submit"]');

    // Verify email
    const verificationLink = await getEmailVerificationLink();
    await page.goto(verificationLink);

    // Login
    await page.goto("/login");
    await page.fill('[name="email"]', "test@example.com");
    await page.fill('[name="password"]', "securepass");
    await page.click('button[type="submit"]');

    // Assert logged in
    await expect(page.locator(".dashboard")).toBeVisible();
  });
});
```

---

## Mocking and Stubbing

### When to Mock

💡 **RECOMMENDED**: Mock external dependencies

```typescript
// ✅ Good: Mock external API calls
it("should handle API failures", async () => {
  const mockApi = {
    fetchUserData: jest.fn().mockRejectedValue(new Error("API down")),
  };

  const service = new UserService(mockApi);

  await expect(service.loadUser("123")).rejects.toThrow("Failed to load user");
});
```

### Avoid Over-Mocking

⚠️ **AVOID**: Mocking too much defeats the purpose

```typescript
// ❌ Bad: Everything is mocked
it("should process order", () => {
  const mockOrder = { id: "1", total: 100 };
  const mockValidate = jest.fn().mockReturnValue(true);
  const mockCalculate = jest.fn().mockReturnValue(100);
  const mockSave = jest.fn().mockResolvedValue(mockOrder);

  // Test is meaningless - all logic is mocked
});

// ✅ Good: Only mock external dependencies
it("should process order", async () => {
  const mockPaymentGateway = createMockGateway();
  const order = { id: "1", items: [{ price: 100 }] };

  const result = await orderService.process(order, mockPaymentGateway);

  expect(result.total).toBe(100); // Real calculation
  expect(mockPaymentGateway.charge).toHaveBeenCalledWith(100); // Mock external
});
```

### Test Doubles

💡 **RECOMMENDED**: Use appropriate test doubles

```typescript
// Stub: Returns predefined values
const stub = {
  getConfig: () => ({ apiKey: "test-key" }),
};

// Mock: Verifies interactions
const mock = jest.fn();
mock.mockReturnValue("value");
expect(mock).toHaveBeenCalledWith("arg");

// Spy: Wraps real implementation
const spy = jest.spyOn(service, "method");
spy.mockReturnValue("value");
expect(spy).toHaveBeenCalled();
```

---

## Test Naming

### Descriptive Names

📋 **REQUIRED**: Test names describe behavior

```typescript
// ✅ Good: Describes what and why
it("should return 404 when user is not found", () => {});
it("should send welcome email after successful registration", () => {});
it("should reject negative payment amounts", () => {});

// ❌ Bad: Vague or implementation-focused
it("should work", () => {});
it("test user creation", () => {});
it("should call userRepo.create", () => {}); // Tests implementation
```

### Naming Patterns

💡 **RECOMMENDED**: Use consistent naming patterns

**Pattern 1: should [expected behavior]**

```typescript
it("should return user when ID exists", () => {});
it("should throw error when user not found", () => {});
```

**Pattern 2: [given condition] should [behavior]**

```typescript
it("given invalid email should throw ValidationError", () => {});
it("given admin role should allow access", () => {});
```

**Pattern 3: Nested describe blocks**

```typescript
describe("UserService", () => {
  describe("create", () => {
    it("should create user with valid data", () => {});
    it("should throw error if email exists", () => {});
  });

  describe("delete", () => {
    it("should delete user by ID", () => {});
    it("should throw error if user not found", () => {});
  });
});
```

---

## Test File Organization

### File Naming

📋 **REQUIRED**: Test files match source files

```
src/
├── services/
│   ├── user.service.ts
│   └── user.service.test.ts    ✅ Co-located
│
tests/
└── integration/
    └── user.api.test.ts         ✅ Separate integration tests
```

### Test Location

💡 **RECOMMENDED**: Co-locate unit tests with source

```
✅ Good:
src/users/
├── user.service.ts
├── user.service.test.ts
├── user.controller.ts
└── user.controller.test.ts

❌ Bad:
src/users/
├── user.service.ts
└── user.controller.ts

test/
└── user.service.test.ts
```

---

## Test Utilities

### Setup and Teardown

💡 **RECOMMENDED**: Use beforeEach/afterEach appropriately

```typescript
describe("DatabaseTests", () => {
  beforeEach(async () => {
    await db.migrate.latest();
    await seedTestData();
  });

  afterEach(async () => {
    await db.raw("TRUNCATE TABLE users CASCADE");
  });

  it("should query users", async () => {
    // Test uses fresh database
  });
});
```

### Custom Matchers

💡 **RECOMMENDED**: Create custom matchers for clarity

```typescript
// Custom matcher
expect.extend({
  toBeValidEmail(received: string) {
    const pass = /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(received);
    return {
      pass,
      message: () => `Expected ${received} to be a valid email`,
    };
  },
});

// Usage
it("should return valid email", () => {
  expect(user.email).toBeValidEmail();
});
```

---

## Performance

### Test Speed

⚠️ **AVOID**: Slow tests

```typescript
// ✅ Good: Fast unit test
it("should validate email format", () => {
  expect(validateEmail("test@example.com")).toBe(true);
}); // Runs in < 1ms

// ⚠️ Slow: Involves database
it("should create user", async () => {
  await db.users.create({ email: "test@example.com" });
}); // Runs in ~50ms - still acceptable for integration test
```

### Test Parallelization

💡 **RECOMMENDED**: Run tests in parallel

```json
// jest.config.js
{
  "maxWorkers": "50%",
  "testTimeout": 10000
}
```

---

## Common Mistakes

❌ **DON'T**:

- Test implementation details
- Write flaky tests
- Skip testing error cases
- Have tests with side effects
- Test third-party library code
- Write tests that depend on execution order

✅ **DO**:

- Test behavior and outcomes
- Write deterministic tests
- Test happy path AND error cases
- Ensure tests are isolated
- Test your own code
- Make tests independent

---

_These standards are enforced by the standards-compliance-agent during code review._
