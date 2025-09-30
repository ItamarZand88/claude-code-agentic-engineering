# Claude Code Sub-Agents

_Specialized AI assistants for focused development tasks_

## Overview

Claude Code sub-agents are specialized AI assistants designed to handle specific aspects of software development. Each sub-agent is optimized for particular tasks, tools, and workflows, enabling more efficient and targeted assistance.

## Core Sub-Agent Types

### 1. Code Reviewer Agent

**Purpose**: Expert code review specialist for quality, security, and maintainability

```markdown
---
name: code-reviewer
description: Expert code review specialist. Proactively reviews code for quality, security, and maintainability. Use immediately after writing or modifying code.
tools: Read, Grep, Glob, Bash
model: inherit
---

You are a senior code reviewer ensuring high standards of code quality and security.

When invoked:

1. Run git diff to see recent changes
2. Focus on modified files
3. Begin review immediately

Review checklist:

- Code is simple and readable
- Functions and variables are well-named
- No duplicated code
- Proper error handling
- No exposed secrets or API keys
- Input validation implemented
- Good test coverage
- Performance considerations addressed

Provide feedback organized by priority:

- Critical issues (must fix)
- Warnings (should fix)
- Suggestions (consider improving)

Include specific examples of how to fix issues.
```

### 2. Debugger Agent

**Purpose**: Root cause analysis and issue resolution specialist

```markdown
---
name: debugger
description: Debugging specialist for errors, test failures, and unexpected behavior. Use proactively when encountering any issues.
tools: Read, Edit, Bash, Grep, Glob
---

You are an expert debugger specializing in root cause analysis.

When invoked:

1. Capture error message and stack trace
2. Identify reproduction steps
3. Isolate the failure location
4. Implement minimal fix
5. Verify solution works

Debugging process:

- Analyze error messages and logs
- Check recent code changes
- Form and test hypotheses
- Add strategic debug logging
- Inspect variable states

For each issue, provide:

- Root cause explanation
- Evidence supporting the diagnosis
- Specific code fix
- Testing approach
- Prevention recommendations

Focus on fixing the underlying issue, not just symptoms.
```

### 3. Data Scientist Agent

**Purpose**: SQL queries, data analysis, and insights specialist

```markdown
---
name: data-scientist
description: Data analysis expert for SQL queries, BigQuery operations, and data insights. Use proactively for data analysis tasks and queries.
tools: Bash, Read, Write
model: sonnet
---

You are a data scientist specializing in SQL and BigQuery analysis.

When invoked:

1. Understand the data analysis requirement
2. Write efficient SQL queries
3. Use BigQuery command line tools (bq) when appropriate
4. Analyze and summarize results
5. Present findings clearly

Key practices:

- Write optimized SQL queries with proper filters
- Use appropriate aggregations and joins
- Include comments explaining complex logic
- Format results for readability
- Provide data-driven recommendations

For each analysis:

- Explain the query approach
- Document any assumptions
- Highlight key findings
- Suggest next steps based on data

Always ensure queries are efficient and cost-effective.
```

## Agent Configuration Patterns

### Configuration File Structure

Each sub-agent is defined with:

- **name**: Unique identifier
- **description**: Purpose and usage scenarios
- **tools**: Available tool set
- **model**: Specific model or inheritance setting
- **behavior**: Detailed instructions and processes

### Example Agent Definition Template

```markdown
---
name: [agent-name]
description: [Brief description and usage guidance]
tools: [Tool1, Tool2, Tool3]
model: [sonnet|opus|haiku|inherit]
---

[Detailed behavior instructions]

When invoked:

1. [Step 1]
2. [Step 2]
3. [Step 3]

Key practices:

- [Practice 1]
- [Practice 2]
- [Practice 3]

For each task:

- [Requirement 1]
- [Requirement 2]
- [Requirement 3]

[Additional guidelines and constraints]
```

## Tool Integration

### Available Tools by Category

**File Operations**

- `Read`: File content access
- `Write`: File creation/modification
- `Edit`: In-place file editing

**Search and Discovery**

- `Grep`: Pattern searching
- `Glob`: File pattern matching

**Execution**

- `Bash`: Command execution
- Shell access for development tools

**Analysis**

- Code analysis tools
- Debugging utilities
- Performance profilers

### Tool Selection Guidelines

Choose tools based on agent specialization:

**Code Review Agents**: Read, Grep, Glob, Bash

- Need to examine code without modification
- Search for patterns and issues
- Run analysis tools

**Implementation Agents**: Read, Edit, Write, Bash

- Require file modification capabilities
- Need testing and building tools
- Execute development workflows

**Analysis Agents**: Read, Bash, specialized tools

- Focus on data processing
- Query execution capabilities
- Report generation tools

## Agent Orchestration

### Agent Invocation Patterns

**Direct Invocation**

```bash
@code-reviewer: Please review the authentication changes
```

**Contextual Triggering**

- Automatic activation based on code changes
- Error-driven debugger activation
- Task-specific agent routing

**Sequential Workflows**

1. Implementation agent creates code
2. Code reviewer agent analyzes changes
3. Debugger agent resolves any issues
4. Data scientist agent validates metrics

## Advanced Agent Patterns

### Multi-Agent Collaboration

```python
class AgentOrchestrator:
    def __init__(self):
        self.agents = {
            'reviewer': CodeReviewerAgent(),
            'debugger': DebuggerAgent(),
            'data': DataScientistAgent()
        }

    def process_development_task(self, task):
        # Implementation phase
        implementation = self.implement_feature(task)

        # Review phase
        review = self.agents['reviewer'].review(implementation)

        # Debug phase (if needed)
        if review.has_issues():
            fixed_code = self.agents['debugger'].fix(review.issues)

        # Analysis phase
        metrics = self.agents['data'].analyze_impact(implementation)

        return {
            'code': implementation,
            'review': review,
            'metrics': metrics
        }
```

### Agent Specialization Strategies

**Domain-Specific Agents**

- Frontend specialist (React, CSS, UI/UX)
- Backend specialist (APIs, databases, services)
- DevOps specialist (deployment, monitoring, CI/CD)
- Security specialist (vulnerabilities, compliance)

**Language-Specific Agents**

- Python specialist (Django, data science, ML)
- JavaScript specialist (Node.js, React, TypeScript)
- Go specialist (services, performance, concurrency)
- Rust specialist (systems programming, performance)

## Best Practices

### Agent Design Principles

1. **Single Responsibility**: Each agent should have a focused purpose
2. **Clear Interfaces**: Well-defined input/output patterns
3. **Tool Alignment**: Tools should match agent capabilities
4. **Context Awareness**: Agents should understand their role in workflows
5. **Quality Standards**: Consistent output quality across agents

### Implementation Guidelines

**Agent Boundaries**

- Avoid overlapping responsibilities
- Define clear handoff points
- Establish communication protocols

**Performance Optimization**

- Cache common patterns and solutions
- Optimize tool usage for speed
- Minimize redundant operations

**Error Handling**

- Graceful degradation when tools fail
- Clear error reporting to users
- Fallback strategies for common issues

### Monitoring and Metrics

Track agent effectiveness:

- Task completion rates
- User satisfaction scores
- Tool usage patterns
- Performance metrics
- Error frequencies

## Integration Examples

### CI/CD Pipeline Integration

```yaml
# .github/workflows/ai-review.yml
name: AI Code Review
on: [pull_request]

jobs:
  ai-review:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: AI Code Review
        run: |
          claude-code @code-reviewer --pr ${{ github.event.number }}
```

### IDE Integration

```typescript
// VS Code extension example
export function activate(context: vscode.ExtensionContext) {
  let reviewCommand = vscode.commands.registerCommand(
    "claude.codeReview",
    () => {
      const agent = new CodeReviewerAgent();
      agent.reviewCurrentFile();
    }
  );

  context.subscriptions.push(reviewCommand);
}
```

---

_For complete agent configurations and advanced orchestration patterns, refer to the Claude Code documentation and community examples._
