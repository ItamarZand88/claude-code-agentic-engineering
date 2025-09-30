# Architecture Patterns

> Architectural guidelines and design patterns for the project

## Table of Contents
- [Layer Separation](#layer-separation)
- [Design Patterns](#design-patterns)
- [Dependency Management](#dependency-management)
- [Module Organization](#module-organization)

---

## Layer Separation

### Controller Layer

📋 **REQUIRED**: Controllers handle HTTP concerns only
```typescript
// ✅ Good: Controller delegates to service
export class UserController {
  constructor(private userService: UserService) {}

  async getUser(req: Request, res: Response) {
    const user = await this.userService.findById(req.params.id);
    return res.json(user);
  }
}
```

❌ **DON'T**: Put business logic in controllers
```typescript
// ❌ Bad: Business logic in controller
export class UserController {
  async getUser(req: Request, res: Response) {
    const user = await db.users.findOne({ id: req.params.id });
    if (user.age < 18) {
      user.restrictions = ['no_purchase'];
    }
    // ... more business logic
    return res.json(user);
  }
}
```

### Service Layer

📋 **REQUIRED**: Services contain business logic
```typescript
// ✅ Good: Service handles business rules
export class UserService {
  constructor(
    private userRepo: UserRepository,
    private notificationService: NotificationService
  ) {}

  async createUser(data: CreateUserDto) {
    // Validation
    this.validateUserData(data);

    // Business logic
    const user = await this.userRepo.create(data);

    // Side effects
    await this.notificationService.sendWelcomeEmail(user);

    return user;
  }
}
```

### Repository/Data Layer

📋 **REQUIRED**: Repositories handle data access only
```typescript
// ✅ Good: Repository for data operations
export class UserRepository {
  async findById(id: string): Promise<User | null> {
    return await this.db.users.findUnique({ where: { id } });
  }

  async create(data: CreateUserData): Promise<User> {
    return await this.db.users.create({ data });
  }
}
```

❌ **DON'T**: Put business logic in repositories
```typescript
// ❌ Bad: Business logic in repository
export class UserRepository {
  async findById(id: string): Promise<User | null> {
    const user = await this.db.users.findUnique({ where: { id } });

    // Business logic doesn't belong here!
    if (user && user.age < 18) {
      user.canPurchase = false;
    }

    return user;
  }
}
```

---

## Design Patterns

### Dependency Injection

📋 **REQUIRED**: Use constructor injection
```typescript
// ✅ Good: Dependencies injected
export class OrderService {
  constructor(
    private orderRepo: OrderRepository,
    private paymentService: PaymentService,
    private emailService: EmailService
  ) {}
}

// Usage with DI container
const orderService = new OrderService(
  orderRepository,
  paymentService,
  emailService
);
```

❌ **DON'T**: Create dependencies internally
```typescript
// ❌ Bad: Hard-coded dependencies
export class OrderService {
  private orderRepo = new OrderRepository();
  private paymentService = new PaymentService();

  // Hard to test and tightly coupled
}
```

### Factory Pattern

💡 **RECOMMENDED**: Use factories for complex object creation
```typescript
// ✅ Good: Factory for object creation
export class UserFactory {
  static createFromSocialAuth(profile: SocialProfile): User {
    return {
      id: generateId(),
      name: profile.displayName,
      email: profile.email,
      authProvider: profile.provider,
      createdAt: new Date(),
    };
  }
}
```

### Strategy Pattern

💡 **RECOMMENDED**: Use strategy for varying algorithms
```typescript
// ✅ Good: Strategy pattern for different payment methods
interface PaymentStrategy {
  process(amount: number): Promise<PaymentResult>;
}

class CreditCardPayment implements PaymentStrategy {
  async process(amount: number) { /* ... */ }
}

class PayPalPayment implements PaymentStrategy {
  async process(amount: number) { /* ... */ }
}

class PaymentService {
  constructor(private strategy: PaymentStrategy) {}

  async pay(amount: number) {
    return await this.strategy.process(amount);
  }
}
```

### Repository Pattern

📋 **REQUIRED**: Abstract data access behind repositories
```typescript
// ✅ Good: Repository interface
interface IUserRepository {
  findById(id: string): Promise<User | null>;
  findByEmail(email: string): Promise<User | null>;
  create(data: CreateUserData): Promise<User>;
  update(id: string, data: UpdateUserData): Promise<User>;
  delete(id: string): Promise<void>;
}

// Implementation can swap databases easily
export class PrismaUserRepository implements IUserRepository {
  // Prisma-specific implementation
}

export class MongoUserRepository implements IUserRepository {
  // MongoDB-specific implementation
}
```

---

## Dependency Management

### Dependency Direction

📋 **REQUIRED**: Dependencies flow inward (toward business logic)
```
┌─────────────────┐
│   Controllers   │ ─────┐
└─────────────────┘      │
                         ▼
┌─────────────────┐   ┌─────────────┐
│      DTOs       │ ─▶│  Services   │
└─────────────────┘   └─────────────┘
                         │
                         ▼
                   ┌─────────────┐
                   │ Repositories│
                   └─────────────┘
                         │
                         ▼
                   ┌─────────────┐
                   │  Database   │
                   └─────────────┘
```

### Interface Segregation

💡 **RECOMMENDED**: Keep interfaces focused
```typescript
// ✅ Good: Focused interfaces
interface IUserReader {
  findById(id: string): Promise<User | null>;
  findByEmail(email: string): Promise<User | null>;
}

interface IUserWriter {
  create(data: CreateUserData): Promise<User>;
  update(id: string, data: UpdateUserData): Promise<User>;
}

// ❌ Bad: Fat interface
interface IUserRepository {
  findById(id: string): Promise<User | null>;
  findByEmail(email: string): Promise<User | null>;
  create(data: CreateUserData): Promise<User>;
  update(id: string, data: UpdateUserData): Promise<User>;
  delete(id: string): Promise<void>;
  search(query: string): Promise<User[]>;
  bulkUpdate(users: User[]): Promise<void>;
  // ... many more methods
}
```

---

## Module Organization

### Feature-Based Structure

📋 **REQUIRED**: Organize by feature, not by type
```
✅ Good: Feature-based
src/
├── users/
│   ├── user.controller.ts
│   ├── user.service.ts
│   ├── user.repository.ts
│   ├── user.types.ts
│   └── user.test.ts
├── orders/
│   ├── order.controller.ts
│   ├── order.service.ts
│   └── ...
└── payments/
    └── ...

❌ Bad: Type-based
src/
├── controllers/
│   ├── user.controller.ts
│   ├── order.controller.ts
│   └── payment.controller.ts
├── services/
│   ├── user.service.ts
│   └── ...
└── repositories/
    └── ...
```

### Module Boundaries

📋 **REQUIRED**: Features should be self-contained
```typescript
// ✅ Good: Clear module boundary
// users/index.ts (public API)
export { UserController } from './user.controller';
export { UserService } from './user.service';
export type { User, CreateUserDto } from './user.types';

// Internal details not exported
// user.repository.ts stays internal
```

### Shared Code

💡 **RECOMMENDED**: Extract truly shared code to common modules
```
src/
├── common/
│   ├── types/
│   ├── utils/
│   ├── middleware/
│   └── errors/
├── users/
└── orders/
```

---

## Anti-Patterns to Avoid

### God Object

❌ **DON'T**: Create objects that do too much
```typescript
// ❌ Bad: God object
class ApplicationManager {
  handleUserRegistration() { }
  processPayment() { }
  sendEmail() { }
  generateReport() { }
  validateInput() { }
  // ... 50 more methods
}

// ✅ Good: Split responsibilities
class UserService { }
class PaymentService { }
class EmailService { }
class ReportService { }
class ValidationService { }
```

### Circular Dependencies

❌ **DON'T**: Create circular module dependencies
```typescript
// ❌ Bad: userService imports orderService, orderService imports userService
// Break the cycle by extracting shared types or using events
```

### Tight Coupling

❌ **DON'T**: Directly depend on concrete implementations
```typescript
// ❌ Bad
class OrderService {
  private emailer = new SmtpEmailer(); // Tight coupling
}

// ✅ Good
interface IEmailService {
  send(to: string, subject: string, body: string): Promise<void>;
}

class OrderService {
  constructor(private emailer: IEmailService) {} // Loose coupling
}
```

---

## Architecture Decision Records (ADRs)

💡 **RECOMMENDED**: Document significant architectural decisions

```markdown
# ADR 001: Use Repository Pattern

## Status
Accepted

## Context
We need to abstract database operations to make testing easier and allow for future database migrations.

## Decision
Implement the Repository pattern for all data access.

## Consequences
- **Positive**: Easy to test, swap databases
- **Negative**: Extra layer of abstraction
```

---

_These patterns are enforced by the standards-compliance-agent during code review._
