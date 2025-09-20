# Coding Standards Template

## General Principles

### Code Philosophy
- **Readability First**: Code is read more often than it's written
- **Consistency**: Follow established patterns within the project
- **Simplicity**: Prefer simple solutions over complex ones
- **Maintainability**: Write code that's easy to modify and extend
- **Performance**: Optimize only when necessary, after profiling

### Code Structure
- **Single Responsibility**: Each function/class should have one clear purpose
- **DRY Principle**: Don't Repeat Yourself - extract common functionality
- **KISS Principle**: Keep It Simple, Stupid - avoid over-engineering
- **YAGNI**: You Aren't Gonna Need It - don't build unnecessary features

## Language-Specific Standards

### JavaScript/TypeScript

#### Naming Conventions
```javascript
// Variables and functions: camelCase
const userName = 'john_doe';
const calculateTotalPrice = (items) => { };

// Constants: SCREAMING_SNAKE_CASE
const MAX_RETRY_ATTEMPTS = 3;
const API_BASE_URL = 'https://api.example.com';

// Classes: PascalCase
class UserService { }
class PaymentProcessor { }

// Private members: prefix with underscore
class MyClass {
  constructor() {
    this._privateProperty = 'private';
  }
  
  _privateMethod() {
    // Private method implementation
  }
}

// Boolean variables: use is/has/can/should prefix
const isLoggedIn = true;
const hasPermission = false;
const canEdit = true;
const shouldValidate = false;
```

#### Function Structure
```javascript
// Good: Clear, single responsibility
function calculateOrderTotal(items, discountCode = null) {
  const subtotal = items.reduce((sum, item) => sum + item.price, 0);
  const discount = discountCode ? applyDiscount(subtotal, discountCode) : 0;
  const tax = calculateTax(subtotal - discount);
  
  return {
    subtotal,
    discount,
    tax,
    total: subtotal - discount + tax
  };
}

// Bad: Too many responsibilities
function processOrder(items, user, payment, shipping) {
  // This function does too many things
}
```

#### Error Handling
```javascript
// Good: Specific error handling
try {
  const data = await fetchUserData(userId);
  return processUserData(data);
} catch (error) {
  if (error instanceof NetworkError) {
    throw new Error('Failed to fetch user data. Please check your connection.');
  } else if (error instanceof ValidationError) {
    throw new Error(`Invalid user data: ${error.message}`);
  } else {
    logger.error('Unexpected error in fetchUserData:', error);
    throw new Error('An unexpected error occurred');
  }
}

// Bad: Generic error handling
try {
  // some operation
} catch (error) {
  console.log('Error:', error);
}
```

### Python

#### Naming Conventions
```python
# Variables and functions: snake_case
user_name = 'john_doe'
def calculate_total_price(items):
    pass

# Constants: SCREAMING_SNAKE_CASE
MAX_RETRY_ATTEMPTS = 3
API_BASE_URL = 'https://api.example.com'

# Classes: PascalCase
class UserService:
    pass

class PaymentProcessor:
    pass

# Private members: prefix with single underscore
class MyClass:
    def __init__(self):
        self._private_property = 'private'
    
    def _private_method(self):
        """Private method implementation"""
        pass
```

#### Function Structure
```python
def calculate_order_total(items: List[Item], discount_code: Optional[str] = None) -> OrderTotal:
    """
    Calculate the total cost of an order including discounts and tax.
    
    Args:
        items: List of items in the order
        discount_code: Optional discount code to apply
        
    Returns:
        OrderTotal object with subtotal, discount, tax, and total
        
    Raises:
        ValueError: If items list is empty
        InvalidDiscountCodeError: If discount code is invalid
    """
    if not items:
        raise ValueError("Items list cannot be empty")
    
    subtotal = sum(item.price for item in items)
    discount = apply_discount(subtotal, discount_code) if discount_code else 0
    tax = calculate_tax(subtotal - discount)
    
    return OrderTotal(
        subtotal=subtotal,
        discount=discount,
        tax=tax,
        total=subtotal - discount + tax
    )
```

## File Organization

### Directory Structure
```
src/
├── components/          # Reusable UI components
│   ├── common/         # Generic components
│   └── feature/        # Feature-specific components
├── services/           # Business logic and API calls
├── utils/              # Utility functions
├── hooks/              # Custom React hooks (if applicable)
├── constants/          # Application constants
├── types/              # Type definitions (TypeScript)
└── tests/              # Test files
    ├── unit/
    ├── integration/
    └── e2e/
```

### File Naming
- **Components**: PascalCase (`UserProfile.jsx`, `PaymentForm.tsx`)
- **Services**: camelCase (`userService.js`, `paymentProcessor.py`)
- **Utils**: camelCase (`dateUtils.js`, `stringHelpers.py`)
- **Constants**: camelCase (`apiEndpoints.js`, `errorMessages.py`)
- **Tests**: match the file being tested with `.test` or `.spec` suffix

## Documentation Standards

### Code Comments
```javascript
/**
 * Calculates the compound interest for an investment
 * 
 * @param {number} principal - The initial investment amount
 * @param {number} rate - The annual interest rate (as decimal, e.g., 0.05 for 5%)
 * @param {number} time - The time period in years
 * @param {number} compound - The number of times interest is compounded per year
 * @returns {number} The final amount after compound interest
 * 
 * @example
 * // Calculate compound interest for $1000 at 5% for 2 years, compounded quarterly
 * const result = calculateCompoundInterest(1000, 0.05, 2, 4);
 * console.log(result); // 1104.49
 */
function calculateCompoundInterest(principal, rate, time, compound) {
  return principal * Math.pow((1 + rate / compound), compound * time);
}
```

### Inline Comments
```javascript
// Good: Explains why, not what
if (user.lastLoginDate < thirtyDaysAgo) {
  // Send reactivation email to inactive users to improve retention
  await sendReactivationEmail(user);
}

// Bad: Explains what the code does (obvious from reading)
// Check if user login date is less than thirty days ago
if (user.lastLoginDate < thirtyDaysAgo) {
  await sendReactivationEmail(user);
}
```

### README Documentation
Each major component/module should include:
- **Purpose**: What the component does
- **Usage**: How to use it with examples
- **API**: Input parameters and return values
- **Dependencies**: What it depends on
- **Testing**: How to test it

## Testing Standards

### Test Structure
```javascript
describe('UserService', () => {
  describe('createUser', () => {
    beforeEach(() => {
      // Setup code
    });

    it('should create a new user with valid data', async () => {
      // Arrange
      const userData = {
        name: 'John Doe',
        email: 'john@example.com'
      };

      // Act
      const result = await userService.createUser(userData);

      // Assert
      expect(result).toHaveProperty('id');
      expect(result.name).toBe(userData.name);
      expect(result.email).toBe(userData.email);
    });

    it('should throw validation error for invalid email', async () => {
      // Arrange
      const userData = {
        name: 'John Doe',
        email: 'invalid-email'
      };

      // Act & Assert
      await expect(userService.createUser(userData))
        .rejects
        .toThrow('Invalid email format');
    });
  });
});
```

### Test Naming
- **Describe blocks**: Use the name of the component/function being tested
- **Test cases**: Use "should [expected behavior] when [condition]"
- **Be specific**: Tests should clearly indicate what they're testing

### Test Coverage
- **Minimum coverage**: 80% for new code
- **Critical paths**: 100% coverage for critical business logic
- **Edge cases**: Always test boundary conditions and error cases

## Code Review Standards

### Review Checklist
- [ ] **Functionality**: Does the code do what it's supposed to do?
- [ ] **Readability**: Is the code easy to read and understand?
- [ ] **Performance**: Are there any obvious performance issues?
- [ ] **Security**: Are there any security vulnerabilities?
- [ ] **Testing**: Is the code adequately tested?
- [ ] **Documentation**: Is the code properly documented?
- [ ] **Standards**: Does the code follow our coding standards?

### Review Process
1. **Author self-review**: Review your own code before submitting
2. **Automated checks**: Ensure all linters and tests pass
3. **Peer review**: At least one team member must review
4. **Address feedback**: Respond to all review comments
5. **Final approval**: Get explicit approval before merging

## Security Standards

### Input Validation
```javascript
// Good: Validate and sanitize input
function createUser(userData) {
  const schema = Joi.object({
    name: Joi.string().min(2).max(50).required(),
    email: Joi.string().email().required(),
    age: Joi.number().integer().min(13).max(120)
  });

  const { error, value } = schema.validate(userData);
  if (error) {
    throw new ValidationError(error.details[0].message);
  }

  // Use validated data
  return userService.create(value);
}
```

### SQL Injection Prevention
```javascript
// Good: Use parameterized queries
const query = 'SELECT * FROM users WHERE id = ? AND status = ?';
const result = await db.query(query, [userId, status]);

// Bad: String concatenation
const query = `SELECT * FROM users WHERE id = ${userId}`;
```

### Authentication & Authorization
```javascript
// Good: Check permissions before operations
async function updateUser(userId, userData, currentUser) {
  if (!canUserEdit(currentUser, userId)) {
    throw new ForbiddenError('Insufficient permissions');
  }
  
  return await userService.update(userId, userData);
}
```

## Performance Standards

### Database Queries
- **Use indexes**: Ensure frequently queried columns are indexed
- **Limit results**: Always use LIMIT for potentially large result sets
- **Avoid N+1**: Use joins or batch queries instead of loops
- **Connection pooling**: Use connection pools for database connections

### Frontend Performance
- **Code splitting**: Split large bundles into smaller chunks
- **Lazy loading**: Load components and images only when needed
- **Memoization**: Use React.memo, useMemo, useCallback appropriately
- **Bundle analysis**: Regularly analyze and optimize bundle size

### API Design
- **Pagination**: Always paginate list endpoints
- **Caching**: Implement appropriate caching strategies
- **Rate limiting**: Protect APIs with rate limiting
- **Compression**: Use gzip compression for responses

## Version Control Standards

### Commit Messages
```bash
# Format: type(scope): description

feat(auth): add OAuth2 login support
fix(api): resolve user creation validation bug
docs(readme): update installation instructions
style(css): fix button alignment issues
refactor(utils): simplify date formatting functions
test(user): add unit tests for user service
chore(deps): update dependencies to latest versions
```

### Branch Naming
- **Feature branches**: `feature/user-authentication`
- **Bug fixes**: `fix/login-validation-error`
- **Hotfixes**: `hotfix/security-patch`
- **Releases**: `release/v1.2.0`

### Pull Request Standards
- **Clear title**: Summarize what the PR does
- **Description**: Explain why changes were made
- **Testing**: Describe how changes were tested
- **Screenshots**: Include UI changes screenshots
- **Checklist**: Use PR template checklist

---

## Enforcement

### Automated Tools
- **Linters**: ESLint, Prettier, Black, etc.
- **Type checking**: TypeScript, mypy, etc.
- **Security**: Snyk, SonarQube, etc.
- **Testing**: Jest, pytest, etc.

### Code Quality Gates
- All automated checks must pass
- Code review approval required
- Test coverage meets minimum requirements
- No security vulnerabilities allowed

### Continuous Improvement
- Regular review and update of standards
- Team feedback incorporation
- Tool and process optimization
- Knowledge sharing sessions

---

**Document Version**: 1.0
**Last Updated**: [Date]
**Next Review**: [Date]
**Maintained By**: [Team/Person]
