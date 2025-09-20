# Basic Workflow Examples

This document provides simple examples of using the Claude Code Agentic Engineering system for common development tasks.

## Example 1: Adding a Simple Feature

**Goal**: Add a "Contact Us" form to a website

```bash
# Step 1: Generate requirements
/task-from-scratch "Add a contact us form with name, email, message fields and email notification"

# Expected output: ./tasks/contact-form-task.md
# The system will ask clarifying questions like:
# - Should it use a specific email service?
# - What validation is needed?
# - Should it store submissions in a database?

# Step 2: Create implementation plan
/plan-from-task "./tasks/contact-form-task.md"

# Expected output: ./plans/contact-form-plan.md
# Includes frontend form, backend API, email integration, validation

# Step 3: Test the plan safely
/implement-plan "./plans/contact-form-plan.md" --dry-run

# Review what would happen, then execute
/implement-plan "./plans/contact-form-plan.md"

# Step 4: Quality review
/review-implementation "./plans/contact-form-plan.md"

# Step 5: Update context for future use
/update_context ./context/context-file.md
```

## Example 2: Fixing a Bug

**Goal**: Fix a login issue where users get logged out randomly

```bash
# Step 1: Gather context about authentication
/get_context "authentication session login logout"

# Step 2: Analyze the bug
/task-from-scratch "Fix random logout issue - users report getting logged out after 5-10 minutes of activity"

# System will analyze authentication code, session management, and ask for:
# - Error logs
# - Reproduction steps
# - Browser/environment details

# Step 3: Create debug and fix plan
/plan-from-task "./tasks/random-logout-bug-task.md"

# Step 4: Implement fix with testing
/implement-plan "./plans/logout-bug-fix-plan.md" --dry-run
/implement-plan "./plans/logout-bug-fix-plan.md"

# Step 5: Review fix thoroughly
/review-implementation "./plans/logout-bug-fix-plan.md" --severity=high

# Step 6: Update knowledge
/update_context ./context/context-file.md
```

## Example 3: Code Quality Improvement

**Goal**: Improve test coverage for a specific module

```bash
# Step 1: Analyze current testing patterns
/get_context "testing unit tests coverage"

# Step 2: Define testing requirements  
/task-from-scratch "Improve test coverage for the user authentication module to achieve 90% coverage"

# Step 3: Create testing strategy
/plan-from-task "./tasks/auth-module-testing-task.md"

# Step 4: Implement tests
/implement-plan "./plans/auth-testing-plan.md"

# Step 5: Review test quality
/review-implementation "./plans/auth-testing-plan.md"

# Step 6: Document testing patterns
/update_context ./context/context-file.md
```

## Tips for Success

1. **Start with context**: Use `/get_context` to understand existing patterns
2. **Be specific**: The more specific your requirements, the better the results
3. **Use dry-run**: Always test with `--dry-run` first for complex changes
4. **Review thoroughly**: Use `/review-implementation` before deploying
5. **Build context**: End sessions with `/update_context ./context/context-file.md`

## Common Command Patterns

```bash
# Research and requirements
/get_context "relevant topic"
/task-from-scratch "detailed requirements"

# Planning and implementation
/plan-from-task "./tasks/task-file.md"
/implement-plan "./plans/plan-file.md" --dry-run
/implement-plan "./plans/plan-file.md"

# Quality assurance
/review-implementation "./plans/plan-file.md" --severity=medium
/update_context ./context/context-file.md
```

These examples show the basic patterns. For more complex scenarios, see [WORKFLOW_GUIDE.md](../docs/WORKFLOW_GUIDE.md).
