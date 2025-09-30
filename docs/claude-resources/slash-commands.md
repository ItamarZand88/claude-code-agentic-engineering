# Slash Commands

_Efficient shortcuts and commands for Claude Code workflows_

## Overview

Slash commands provide quick access to common functionality in Claude Code, enabling streamlined workflows and efficient task execution. This guide covers essential commands, custom command creation, and advanced usage patterns.

## Core Slash Commands

### Project Management Commands

**Todo Management**:

```bash
/todo                    # Quick todo item management
/todo add "Fix bug #123" # Add new todo with due date support
/todo list               # Show all todo items with sorting
/todo complete 1         # Mark todo item as complete
/todo priority high 2    # Set todo priority level
```

**Commit Operations**:

```bash
/commit                  # Create intelligent commit message
/commit --no-verify      # Skip pre-commit hooks
/commit --amend          # Amend previous commit
/commit --message "Custom message"  # Use custom message
```

### Code Analysis Commands

**Review and Quality**:

```bash
/review                  # Comprehensive code review
/review --security       # Security-focused review
/review --performance    # Performance analysis review
/review --style         # Style and formatting review
```

**Testing Commands**:

```bash
/test                   # Run full test suite
/test unit              # Run unit tests only
/test integration       # Run integration tests
/test coverage          # Generate coverage report
/test --watch          # Run tests in watch mode
```

### Build and Development Commands

**Common Build Operations**:

```bash
/build                  # Build the project
/build --release        # Production build
/build --debug          # Debug build with symbols
/build --clean          # Clean build from scratch
```

**Development Server Commands**:

```bash
/serve                  # Start development server
/serve --port 8080      # Specify custom port
/serve --hot           # Enable hot reloading
/serve --https         # Use HTTPS for local development
```

## Language-Specific Commands

### Python Development

**Package Management**:

```bash
/pip install package_name        # Install Python package
/pip install -r requirements.txt # Install from requirements
/pip freeze > requirements.txt   # Generate requirements file
/pip list --outdated            # Show outdated packages
```

**Python-Specific Operations**:

```bash
/python -m pytest              # Run tests with pytest
/python -m black .             # Format code with Black
/python -m flake8             # Lint code with flake8
/python -m mypy .             # Type checking with mypy
```

### JavaScript/Node.js

**Package Management**:

```bash
/npm install                   # Install dependencies
/npm install --save package   # Install and save to package.json
/npm run build                # Run build script
/npm run test                 # Run test script
/npm audit                    # Security audit
```

**Yarn Operations**:

```bash
/yarn                         # Install dependencies
/yarn add package            # Add package
/yarn workspace web test     # Run workspace-specific command
/yarn lint:fix              # Fix linting issues
```

### Database Commands

**Query Operations**:

```bash
/sql "SELECT * FROM users WHERE active = true"  # Execute SQL query
/mongo "db.users.find({active: true})"         # MongoDB query
/redis "GET user:123"                          # Redis command
```

## Custom Slash Command Creation

### Basic Command Structure

**Command Definition Template**:

````markdown
---
name: command_name
description: Brief description of what the command does
usage: /command_name [options] [arguments]
category: development|testing|deployment|analysis
---

# Command Implementation

## Behavior

[Describe what the command does]

## Parameters

- `param1`: Description of parameter 1
- `param2`: Description of parameter 2

## Examples

```bash
/command_name --option value
/command_name argument1 argument2
```
````

## Implementation

[Command logic and execution details]

````

### Example Custom Commands

**Project Setup Command**:
```markdown
---
name: setup
description: Initialize a new project with standard structure
usage: /setup [project_type] [project_name]
category: development
---

# Setup Project Command

## Behavior
Creates a new project with:
- Standard directory structure
- Configuration files
- Development dependencies
- Documentation templates

## Parameters
- `project_type`: web|cli|api|mobile (default: web)
- `project_name`: Name of the project directory

## Examples
```bash
/setup web my-app          # Create web application
/setup api user-service    # Create API service
/setup cli data-processor  # Create CLI tool
````

````

**Database Migration Command**:
```markdown
---
name: migrate
description: Run database migrations with rollback support
usage: /migrate [up|down|status] [--steps N]
category: database
---

# Database Migration Command

## Behavior
Manages database schema changes:
- Apply pending migrations
- Rollback migrations
- Show migration status

## Parameters
- `action`: up (apply) | down (rollback) | status (show current state)
- `--steps N`: Number of migrations to process (default: all)

## Examples
```bash
/migrate up               # Apply all pending migrations
/migrate down --steps 2   # Rollback last 2 migrations
/migrate status          # Show migration status
````

````

## Advanced Command Patterns

### Conditional Execution

**Environment-Aware Commands**:
```bash
/deploy --env production   # Deploy to production
/deploy --env staging     # Deploy to staging
/deploy --dry-run        # Preview deployment without execution
````

### Pipeline Commands

**Multi-Step Operations**:

```bash
/release                 # Full release pipeline:
                        # 1. Run tests
                        # 2. Build application
                        # 3. Create release notes
                        # 4. Tag version
                        # 5. Deploy to production
```

### Interactive Commands

**User Input Commands**:

```bash
/configure              # Interactive configuration wizard
/scaffold component     # Interactive component generator
/analyze --interactive  # Interactive analysis with questions
```

## Command Integration Patterns

### Git Workflow Commands

**Branch Management**:

```bash
/branch feature/new-auth          # Create and switch to feature branch
/branch --list                   # List all branches
/branch --delete old-feature     # Delete branch safely
/branch --merge feature/auth     # Merge feature branch
```

**Worktree Operations**:

```bash
/worktree create feature/ui      # Create worktree for branch
/worktree list                  # List all worktrees
/worktree remove old-feature    # Remove worktree
```

### CI/CD Integration

**Build Pipeline Commands**:

```bash
/pipeline status                # Show pipeline status
/pipeline trigger              # Manually trigger pipeline
/pipeline logs --job test      # Show logs for specific job
/pipeline cancel               # Cancel running pipeline
```

### Monitoring Commands

**System Health**:

```bash
/health                        # System health check
/metrics                      # Show key metrics
/logs --tail 100              # Show recent logs
/status services              # Service status overview
```

## Command Automation

### Batch Operations

**Multiple Command Execution**:

```bash
/batch "test && build && deploy"     # Sequential execution
/parallel "lint,test,security"       # Parallel execution
/workflow release                    # Pre-defined workflow
```

### Scheduled Commands

**Automated Execution**:

```bash
/schedule daily "backup --incremental"   # Daily backup
/schedule weekly "update --dependencies" # Weekly updates
/cron "0 2 * * *" "cleanup --temp"      # Cron-style scheduling
```

## Browser and External Tool Integration

### Browser Automation

**Web Interaction Commands**:

```bash
/browser open "https://example.com"              # Open URL
/browser act "Click Login | Type credentials"    # Multi-step actions
/browser extract "product names"                 # Data extraction
/browser observe "interactive elements"          # Element discovery
```

**Browser Options**:

```bash
/browser --headless          # Run without GUI
/browser --video            # Record session
/browser --connect-to       # Maintain session state
```

### External API Integration

**Service Integration**:

```bash
/github pr create                    # Create pull request
/github issues list --assignee me   # List assigned issues
/slack send "Build completed"       # Send Slack notification
/email report --to team@company.com # Send email report
```

## Command Development Best Practices

### Command Design Principles

1. **Single Responsibility**: Each command should have a clear, focused purpose
2. **Consistent Interface**: Use standard patterns for options and arguments
3. **Error Handling**: Provide clear error messages and recovery suggestions
4. **Documentation**: Include comprehensive usage examples and descriptions
5. **Testing**: Create test cases for command functionality

### Parameter Handling

**Standard Patterns**:

```bash
# Boolean flags
/command --verbose --dry-run

# Value parameters
/command --output file.txt --count 10

# Positional arguments
/command source_file target_file

# Combined usage
/command file.txt --format json --output results.json --verbose
```

### Error Handling

**Robust Command Implementation**:

```python
def execute_command(args):
    try:
        # Validate inputs
        if not validate_args(args):
            return error_response("Invalid arguments provided")

        # Execute command logic
        result = perform_operation(args)

        # Return success response
        return success_response(result)

    except FileNotFoundError as e:
        return error_response(f"File not found: {e.filename}")
    except PermissionError:
        return error_response("Insufficient permissions to execute command")
    except Exception as e:
        return error_response(f"Unexpected error: {str(e)}")
```

## Command Discovery and Help

### Help System

**Getting Command Information**:

```bash
/help                      # List all available commands
/help command_name         # Show detailed help for specific command
/help --category testing   # Show commands by category
/help --search keyword     # Search commands by keyword
```

### Command Listing

**Discovery Commands**:

```bash
/list commands            # List all commands
/list recent             # Show recently used commands
/list favorites          # Show bookmarked commands
/which command_name      # Show command location and details
```

## Performance and Optimization

### Command Caching

**Speed Optimization**:

```bash
/cache clear             # Clear command cache
/cache status           # Show cache statistics
/cache warm            # Pre-warm frequently used commands
```

### Parallel Execution

**Concurrent Operations**:

```bash
/parallel "test,lint,build"        # Run commands concurrently
/sequence "install && test && build"  # Run commands sequentially
/conditional "test || exit 1"      # Conditional execution
```

## Integration with Development Tools

### IDE Integration

**Editor Commands**:

```bash
/format                   # Format current file
/organize imports        # Organize import statements
/refactor rename old new # Rename symbol across project
/find references symbol  # Find all references to symbol
```

### Version Control

**Git Integration**:

```bash
/diff                    # Show working directory changes
/stage files            # Stage specific files
/unstage files          # Unstage files
/stash save "work"      # Stash current changes
/cherry-pick commit     # Cherry-pick specific commit
```

## Summary

Slash commands provide:

1. **Quick Access**: Instant execution of common operations
2. **Workflow Integration**: Seamless integration with development processes
3. **Customization**: Ability to create project-specific commands
4. **Automation**: Support for batch and scheduled operations
5. **Tool Integration**: Connection to external services and APIs
6. **Consistency**: Standardized interface across different operations

---

_For creating custom commands and advanced integration patterns, refer to the Claude Code Command Development Guide._
