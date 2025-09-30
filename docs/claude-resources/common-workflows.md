# Common Workflows

_Essential patterns and practices for Claude Code development workflows_

## Overview

This guide covers common development workflows when working with Claude Code, including task orchestration, collaboration patterns, and productivity optimization strategies.

## Core Development Workflows

### 1. Feature Development Workflow

**Standard Development Process**:

```bash
# Start new feature
claude-code "Create a new authentication system using OAuth2"

# Review implementation
@code-reviewer: Please review the authentication changes

# Debug if needed
@debugger: Fix any issues found in the authentication flow

# Run tests
claude-code "Run the test suite and fix any failures"

# Commit changes
claude-code "Create a commit with descriptive message for the auth system"
```

### 2. Bug Investigation and Resolution

**Systematic Debugging Approach**:

```bash
# Investigate the issue
claude-code "Analyze this error: [error_message]"

# Use debugger agent for deep analysis
@debugger: Investigate intermittent timeout errors in the API

# Implement fix
claude-code "Implement a fix for the connection timeout issue"

# Verify solution
claude-code "Test the fix and ensure no regression"
```

### 3. Code Review and Quality Assurance

**Multi-Agent Review Process**:

```bash
# Automated code review
@code-reviewer: Review recent changes in the user authentication module

# Security-focused review
@security: Check for vulnerabilities in the new auth system

# Performance analysis
@performance: Analyze the impact of these changes on system performance
```

## Extended Thinking Workflows

### Enabling Deep Reasoning

**Complex Problem Solving**:

```bash
# Enable extended thinking for architectural decisions
claude-code "I need to implement a new authentication system using OAuth2 for our API. Think deeply about the best approach for implementing this in our codebase."

# Encourage thorough analysis
claude-code "think about potential security vulnerabilities in this approach"

# Consider edge cases
claude-code "think hard about edge cases we should handle"
```

### Architecture and Design Decisions

**Strategic Planning Workflow**:

```text
Prompt: "We need to redesign our data processing pipeline to handle 10x more data. Think through this comprehensively, considering:

- Current bottlenecks and limitations
- Scalable architecture patterns
- Technology trade-offs
- Implementation phases
- Risk mitigation strategies

Please reason through this systematically and provide a detailed plan."
```

## Specialized Agent Workflows

### Data Analysis Workflow

**Using the Data Scientist Agent**:

```bash
# SQL analysis
@data-scientist: "Analyze our user engagement metrics from the past quarter"

# BigQuery operations
@data-scientist: "Write an efficient query to find our top-performing content"

# Data insights
@data-scientist: "Identify trends in customer behavior and recommend actions"
```

### Code Quality Workflow

**Comprehensive Quality Assurance**:

```bash
# Step 1: Implementation
claude-code "Implement the user profile update feature"

# Step 2: Automated review
@code-reviewer: Review the profile update implementation

# Step 3: Security check
@security: Scan for security vulnerabilities in user profile handling

# Step 4: Performance evaluation
@performance: Check performance impact of the profile updates

# Step 5: Testing
claude-code "Write comprehensive tests for the profile update feature"
```

## Tool Integration Workflows

### Parallel Tool Usage

**Efficient Multi-Tool Operations**:

```python
# Example prompt for parallel operations
PARALLEL_WORKFLOW = """
Please perform these operations simultaneously:
1. Check the weather in Paris and London
2. Calculate the total revenue for Q3
3. Query the database for active users
4. Generate a status report

Use parallel tool calls to minimize response time.
"""
```

### Tool Chain Orchestration

**Sequential Tool Operations**:

```python
# Complex workflow example
WORKFLOW_PROMPT = """
1. First, fetch the latest sales data using the database tool
2. Then, process the data using the analytics tool
3. Generate visualizations using the chart tool
4. Finally, create a summary report using the document tool

Execute this workflow step by step, using the output from each tool as input to the next.
"""
```

## Project Setup and Onboarding

### New Project Workflow

**Project Initialization**:

```bash
# Set up project structure
claude-code "Create a new Python web application with FastAPI, including proper project structure, requirements, and Docker setup"

# Configure development environment
claude-code "Set up development tooling including pre-commit hooks, linting, and testing framework"

# Create documentation
claude-code "Generate comprehensive README and API documentation"
```

### Team Onboarding Workflow

**Knowledge Transfer Process**:

```bash
# Code exploration
claude-code "Explain the architecture and key components of this codebase"

# Standards documentation
@code-reviewer: "Document the coding standards and best practices used in this project"

# Setup guide
claude-code "Create a developer setup guide for new team members"
```

## Continuous Integration Workflows

### Pre-commit Workflow

**Quality Gates**:

```bash
# Pre-commit checks
claude-code "Run linting and formatting on all modified files"

# Test validation
claude-code "Run unit tests and report any failures"

# Security scan
@security: "Scan the changes for potential security issues"

# Documentation updates
claude-code "Update documentation for any API changes"
```

### CI/CD Pipeline Integration

**Automated Workflows**:

```yaml
# .github/workflows/claude-review.yml
name: Claude Code Review
on: [pull_request]

jobs:
  claude-review:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Claude Code Review
        run: |
          claude-code @code-reviewer --pr ${{ github.event.number }}
          claude-code @security --scan-changes
```

## Performance Optimization Workflows

### Code Optimization Process

**Performance Enhancement**:

```bash
# Performance analysis
@performance: "Profile the application and identify bottlenecks"

# Optimization implementation
claude-code "Optimize the identified performance bottlenecks"

# Benchmarking
claude-code "Run performance benchmarks to validate improvements"

# Monitoring setup
claude-code "Add monitoring for key performance metrics"
```

### Scalability Planning

**System Scaling Workflow**:

```text
Prompt: "Our application needs to scale from 1,000 to 100,000 concurrent users. Think through this scaling challenge systematically:

1. Identify current limitations
2. Design scalable architecture
3. Plan implementation phases
4. Consider cost implications
5. Define success metrics

Provide a comprehensive scaling strategy with detailed implementation steps."
```

## Debugging and Troubleshooting

### Systematic Debugging Workflow

**Issue Resolution Process**:

```bash
# Problem identification
claude-code "Analyze this error and identify the root cause: [error_details]"

# Reproduction steps
@debugger: "Create steps to reproduce this issue consistently"

# Solution implementation
claude-code "Implement a fix for the identified issue"

# Testing and validation
claude-code "Create tests to prevent this issue from recurring"
```

### Production Issue Workflow

**Incident Response**:

```bash
# Immediate analysis
claude-code "Urgently analyze this production error: [error_log]"

# Quick fix implementation
@debugger: "Implement a hotfix for this critical issue"

# Monitoring and verification
claude-code "Monitor the fix and confirm the issue is resolved"

# Post-mortem analysis
claude-code "Create a post-mortem report with root cause analysis and prevention measures"
```

## Documentation Workflows

### API Documentation Workflow

**Comprehensive Documentation**:

```bash
# API documentation generation
claude-code "Generate OpenAPI specifications for all endpoints"

# Usage examples
claude-code "Create code examples for each API endpoint"

# Integration guides
claude-code "Write integration guides for common use cases"
```

### Knowledge Base Maintenance

**Documentation Updates**:

```bash
# Architecture documentation
claude-code "Update the architecture documentation to reflect recent changes"

# Troubleshooting guides
@debugger: "Create troubleshooting guides for common issues"

# Best practices documentation
@code-reviewer: "Document coding standards and best practices"
```

## Advanced Workflow Patterns

### Multi-Agent Collaboration

**Complex Task Orchestration**:

```python
class WorkflowOrchestrator:
    def __init__(self):
        self.agents = {
            'implementer': ImplementerAgent(),
            'reviewer': CodeReviewerAgent(),
            'debugger': DebuggerAgent(),
            'data_scientist': DataScientistAgent()
        }

    async def execute_feature_workflow(self, feature_request):
        """Execute complete feature development workflow"""

        # Phase 1: Implementation
        implementation = await self.agents['implementer'].implement(feature_request)

        # Phase 2: Review
        review_results = await self.agents['reviewer'].review(implementation)

        # Phase 3: Debug if needed
        if review_results.has_issues():
            fixed_implementation = await self.agents['debugger'].fix(
                implementation, review_results.issues
            )
            implementation = fixed_implementation

        # Phase 4: Data analysis (if applicable)
        if feature_request.requires_analytics():
            metrics = await self.agents['data_scientist'].analyze_impact(
                implementation
            )

        return {
            'implementation': implementation,
            'review': review_results,
            'metrics': metrics if 'metrics' in locals() else None,
            'status': 'completed'
        }
```

### Adaptive Workflows

**Context-Aware Process Selection**:

```python
def select_workflow(task_type, complexity, urgency):
    """Select appropriate workflow based on task characteristics"""

    if urgency == "critical":
        return {
            'agents': ['debugger'],
            'thinking_budget': 5000,
            'parallel_tools': True,
            'review_required': False
        }
    elif complexity == "high":
        return {
            'agents': ['implementer', 'code-reviewer', 'debugger'],
            'thinking_budget': 15000,
            'parallel_tools': True,
            'review_required': True
        }
    else:
        return {
            'agents': ['implementer'],
            'thinking_budget': 8000,
            'parallel_tools': False,
            'review_required': True
        }
```

## Monitoring and Optimization

### Workflow Performance Tracking

**Metrics Collection**:

```python
class WorkflowMetrics:
    def __init__(self):
        self.workflow_data = []

    def log_workflow_execution(self, workflow_type, duration, success_rate, agent_usage):
        """Track workflow performance"""
        self.workflow_data.append({
            'type': workflow_type,
            'duration': duration,
            'success_rate': success_rate,
            'agents_used': agent_usage,
            'timestamp': datetime.now()
        })

    def analyze_efficiency(self):
        """Analyze workflow efficiency patterns"""
        df = pd.DataFrame(self.workflow_data)

        return {
            'avg_duration_by_type': df.groupby('type')['duration'].mean(),
            'success_rates': df.groupby('type')['success_rate'].mean(),
            'most_efficient_patterns': self.identify_efficient_patterns(df)
        }
```

### Continuous Improvement

**Workflow Optimization**:

```bash
# Performance analysis
claude-code "Analyze our development workflow efficiency and identify bottlenecks"

# Process improvement
claude-code "Suggest optimizations for our current development process"

# Tool usage optimization
claude-code "Recommend better tool combinations for common tasks"
```

## Best Practices Summary

1. **Start Simple**: Begin with basic workflows and add complexity as needed
2. **Use Appropriate Agents**: Match specialized agents to their strengths
3. **Enable Extended Thinking**: For complex decisions and architectural choices
4. **Parallel Processing**: Utilize parallel tool calls for independent operations
5. **Quality Gates**: Implement review and testing checkpoints
6. **Monitor Performance**: Track workflow efficiency and optimize
7. **Document Processes**: Maintain clear workflow documentation
8. **Iterate and Improve**: Continuously refine workflows based on results

---

_For specific implementation examples and advanced orchestration patterns, refer to the Claude Code documentation and community best practices._
