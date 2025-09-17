# Workflow Guide

This guide demonstrates how to use the Claude Code Agentic Engineering system for various development scenarios.

## 🎯 Core Workflow Philosophy

The system follows the **"Input → Workflow → Output"** pattern with intelligent delegation to specialized subagents. Each command builds context for the next, creating a self-improving engineering loop.

## 🚀 Basic Workflows

### Simple Feature Development
**Scenario**: Add a dark mode toggle to your application

```bash
# 1. Start with context exploration (optional but recommended)
/context-map --query="theme dark mode"

# 2. Generate comprehensive requirements
/task-from-scratch "Add a dark mode toggle button to the header that persists user preference"

# 3. Create detailed implementation plan
/plan-from-task "./tasks/dark-mode-toggle-task.md"

# 4. Test the implementation plan (safety first!)
/implement-plan "./plans/dark-mode-toggle-plan.md" --dry-run

# Review the planned changes, then execute for real
/implement-plan "./plans/dark-mode-toggle-plan.md"

# 5. Comprehensive quality review
/review-implementation "./plans/dark-mode-toggle-plan.md"

# 6. Update project context for future tasks
/context-map --update
```

### Bug Fix Workflow
**Scenario**: Fix a memory leak in the image upload component

```bash
# 1. Gather context about the problematic area
/context-map --query="image upload memory performance"

# 2. Analyze the issue with comprehensive requirements
/task-from-scratch "Fix memory leak in ImageUploader component - browser tab crashes after uploading multiple large images"

# 3. Create focused debugging and fix plan
/plan-from-task "./tasks/image-uploader-memory-leak-task.md"

# 4. Implement fix with careful testing
/implement-plan "./plans/image-uploader-fix-plan.md" --dry-run
/implement-plan "./plans/image-uploader-fix-plan.md"

# 5. Validate the fix and performance
/review-implementation "./plans/image-uploader-fix-plan.md" --severity=high

# 6. Capture lessons learned
/context-map --update --depth=4
```

## 🔧 Advanced Workflows

### Complex System Integration
**Scenario**: Integrate Stripe payments with subscription management

```bash
# 1. Research existing payment patterns in codebase
/context-map --query="payment billing subscription"
/context-map --export=mermaid > ./docs/current-payment-architecture.md

# 2. Comprehensive requirements with business logic
/task-from-scratch "Integrate Stripe payments with subscription management - support monthly/annual plans, trial periods, and payment method updates"

# 3. Detailed technical architecture planning
/plan-from-task "./tasks/stripe-subscription-integration-task.md"

# 4. Phased implementation with checkpoints
/implement-plan "./plans/stripe-subscription-plan.md" --step=1  # Database changes
# Test database changes, then continue
/implement-plan "./plans/stripe-subscription-plan.md" --step=2  # Backend API
# Test API endpoints, then continue
/implement-plan "./plans/stripe-subscription-plan.md" --step=3  # Frontend integration

# 5. Security and integration review
/review-implementation "./plans/stripe-subscription-plan.md" --severity=high

# 6. Update architectural knowledge
/context-map --update --depth=5
```

## 🎯 Best Practices

### Context Management
- **Start sessions** with `/context-map --query` to gather relevant background
- **End sessions** with `/context-map --update` to capture new knowledge
- **Export context** regularly for team sharing: `/context-map --export=mermaid`

### Safety and Quality
- **Always use dry-run** first: `--dry-run` flag for implementation
- **Review before deploy**: Use `/review-implementation` before merging
- **Incremental steps**: Use `--step=N` for complex implementations
- **Version control**: Commands automatically create git branches

### Efficiency Optimization  
- **Severity filtering**: Use `--severity=high` for focused reviews
- **Targeted queries**: Be specific with context queries
- **Batch operations**: Process related tasks together
- **Template reuse**: Save successful task patterns for reuse

### Team Collaboration
- **Share context maps**: Export and commit context for team knowledge
- **Document decisions**: Task and plan files become living documentation  
- **Standard workflows**: Establish team patterns using these workflows
- **Knowledge transfer**: Use context maps for onboarding new team members

## 🔍 Troubleshooting Common Scenarios

### When Requirements Are Unclear
The system will ask clarifying questions automatically

### When Implementation Fails
The system offers options: retry, skip, rollback, or debug specific failures

### When Review Finds Critical Issues
Creates prioritized action items: immediate, short-term, and long-term recommendations

This workflow system transforms development from ad-hoc coding to systematic, context-aware engineering that gets smarter with every iteration.
