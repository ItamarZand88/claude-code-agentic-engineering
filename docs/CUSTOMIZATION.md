# Customization Guide

This guide explains how to customize and extend the Claude Code Agentic Engineering system for your specific needs.

## 🔧 Customizing Slash Commands

All slash commands are stored as Markdown files in the `commands/` directory. You can modify them to fit your team's needs.

### Basic Command Structure
```markdown
---
description: Brief description of what the command does
model: claude-sonnet-4
allowed-tools: read, write, bash, search
argument-hint: <required_arg> [optional_arg]
---

# Command Name

Purpose statement...

## Variables
- **variable_name**: $ARGUMENTS - Description

## Workflow
1. **Step Name**
   - Detailed instructions

## Instructions
- Additional guidance

## Control Flow
- Error handling
- Conditional logic

## Report
- Output format specification
```

### Customization Examples

#### Adding Project-Specific Context
Modify commands to include your project's specific patterns:

```markdown
## Variables
- **project_config**: `./config/project.json` - Your project configuration
- **coding_standards**: `./docs/CODING_STANDARDS.md` - Team coding standards
```

#### Adding Custom Tools
If you have MCP servers installed, add them to allowed-tools:

```markdown
---
allowed-tools: read, write, bash, search, github, jira, slack
---
```

#### Customizing Output Formats
Modify the Report section to match your team's documentation style:

```markdown
## Report
Generate output using our standard template:
- **Epic**: Link to Jira epic
- **User Stories**: Acceptance criteria in Given/When/Then format
- **Technical Spec**: Architecture decision records
- **Testing Plan**: BDD scenarios
```

## 🤖 Customizing Subagents

Subagents are in the `agents/` directory. Each agent specializes in specific expertise areas.

### Agent Structure
```markdown
---
name: agent-name
description: MUST BE USED for specific expertise. Expert in domain.
tools: read, write, bash
model: sonnet
---

You are a specialized expert...

## Core Responsibilities
- Primary responsibility
- Secondary responsibility

## Output Format
- Structured output specification

## Special Instructions
- Domain-specific guidance
```

### Creating Domain-Specific Agents

#### Example: Frontend Specialist
```markdown
---
name: frontend-specialist
description: MUST BE USED for React, Vue, Angular, or any frontend framework work. Expert in modern frontend development, component architecture, and UI/UX patterns.
tools: read, write, bash, search
model: sonnet
---

You are a frontend development specialist focused on modern web applications...

## Core Responsibilities
### React Expertise
- Component architecture and patterns
- State management (Redux, Zustand, Context)
- Performance optimization and React profiling
- Testing with Jest, React Testing Library

### UI/UX Focus
- Accessibility (WCAG) compliance
- Responsive design and mobile-first approach
- Design system implementation
- CSS-in-JS and styling solutions

## Framework-Specific Patterns
- React: Hooks, Context, HOCs, Render Props
- Vue: Composition API, Pinia, Vue Router
- Angular: Services, RxJS, NgRx, Angular Material

## Output Format
- **Component Analysis**: Architecture assessment
- **Performance Insights**: Bundle size, rendering optimization
- **Accessibility Report**: WCAG compliance and improvements
- **Best Practices**: Framework-specific recommendations
```

#### Example: DevOps Specialist
```markdown
---
name: devops-specialist  
description: MUST BE USED for deployment, CI/CD, infrastructure, containerization, and cloud platform tasks. Expert in DevOps practices and platform engineering.
tools: bash, read, write, search
model: sonnet
---

You are a DevOps and platform engineering specialist...

## Core Responsibilities
### Infrastructure as Code
- Terraform, CloudFormation, Pulumi
- Container orchestration (Docker, Kubernetes)
- Cloud platforms (AWS, GCP, Azure)

### CI/CD Pipeline Design
- GitHub Actions, GitLab CI, Jenkins
- Automated testing and deployment
- Environment management and promotion

### Monitoring and Observability
- Prometheus, Grafana, ELK stack
- Application and infrastructure monitoring
- Alerting and incident response

## Output Format
- **Infrastructure Assessment**: Current state and recommendations
- **Pipeline Analysis**: CI/CD optimization opportunities
- **Security Review**: Infrastructure security best practices
- **Monitoring Plan**: Observability and alerting strategy
```

## 📝 Creating New Commands

### 1. Plan Your Command
- What problem does it solve?
- What inputs does it need?
- What outputs should it produce?
- Which subagents might it need?

### 2. Create the Command File
```bash
# Create new command file
touch commands/your-new-command.md
```

### 3. Define the Command Structure
Follow the standard format with your specific workflow steps.

### 4. Test Your Command
```bash
# Copy to Claude Code
cp commands/your-new-command.md .claude/commands/

# Test in Claude Code
claude
/help  # Should show your new command
/your-new-command "test input"
```

## 🎯 Team-Specific Customizations

### Adding Company Standards
Modify commands to reference your company's specific standards:

```markdown
## Variables
- **company_standards**: `./docs/COMPANY_CODING_STANDARDS.md`
- **security_policy**: `./docs/SECURITY_POLICY.md`
- **architecture_guide**: `./docs/ARCHITECTURE_GUIDE.md`
```

### Integration with Team Tools
Add your team's tools to the allowed-tools list:

```markdown
---
allowed-tools: read, write, bash, search, jira, slack, github, datadog
---
```

### Custom Workflows
Create commands for your specific development workflows:

```markdown
# Example: Release Command
---
description: Manages release process including changelog, tagging, and deployment
argument-hint: <version> [environment]
---

## Workflow
1. **Version Validation**
   - Validate semver format
   - Check for existing tags
   
2. **Changelog Generation**  
   - Generate from git commits
   - Format according to Keep a Changelog
   
3. **Release Preparation**
   - Update version files
   - Create git tag
   - Build release artifacts
```

## 🔄 Version Control Integration

### Committing Customizations
```bash
# Add your customizations to version control
git add commands/ agents/ docs/
git commit -m "feat: customize commands for team workflow"
```

### Sharing with Team
1. Commit your customizations to your project repository
2. Team members run `./setup.sh` to get the customized commands
3. Use `.claude/` directory in project for project-specific commands

## 🚀 Advanced Customizations

### Conditional Logic
Add environment-specific behavior:

```markdown
## Control Flow
- **If** environment is production:
  - Require additional approval
  - Run full security scan
- **If** environment is development:
  - Allow fast-track deployment
  - Skip certain validations
```

### Dynamic Variables
Use command output as variables:

```markdown
## Variables
- **current_branch**: `$(git branch --show-current)` - Current git branch
- **project_version**: `$(cat package.json | jq -r '.version')` - Project version
```

Remember: Customizations should enhance your workflow while maintaining the core principles of safety, quality, and context awareness.
