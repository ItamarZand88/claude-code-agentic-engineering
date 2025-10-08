---
description: Generates comprehensive coding standards document by analyzing project codebase patterns
argument-hint:
model: inherit
allowed-tools: Read, Write, Glob, Grep, Bash, Task
---

# Project Standards Generator

## Instructions

<instructions>
**Purpose**: Analyze the current project and generate a comprehensive, project-specific coding standards document.

**Core Principles**:
- Discover actual patterns from existing code
- Document what IS being done consistently
- Provide real examples from the project
- Cover all major coding areas
- Make standards enforceable and practical

**Key Expectations**:
- Comprehensive standards document
- Real code examples with file:line references
- Pattern frequency analysis
- Honest documentation of inconsistencies
- Actionable guidelines
</instructions>

## Variables

### Static Variables
- **OUTPUT_FILE**: `Circle/standards/README.md` - Standards document location

## Workflow

### Step 1: Pre-Analysis Checks

<step>
**Objective**: Verify project is ready for analysis

**Process**:
1. Check if we're in a valid project directory (has source code)
2. Verify Circle/standards/ directory exists (create if needed)
3. Warn user if standards file already exists

**Validation**:
- ✅ Project has source code files
- ✅ Circle/standards/ directory ready

**Early Return**: If no source files found → STOP and inform user
</step>

### Step 2: Launch standards-generator Agent

<step>
**Objective**: Analyze codebase and generate standards

**Process**: Launch standards-generator agent

**Agent Task**:
```
Use standards-generator agent to analyze this project.

YOU MUST perform comprehensive analysis:

1. Project Discovery:
   - Identify tech stack (package.json, requirements.txt, etc.)
   - Analyze directory structure
   - Count file types and sizes

2. Pattern Analysis (run in parallel):
   - Variable naming conventions
   - Function/method naming patterns
   - Class/type naming conventions
   - File naming patterns
   - Import/export patterns
   - Error handling approaches
   - Testing patterns
   - Comment and documentation styles

3. Standards Generation:
   - Create Circle/standards/README.md
   - Include ALL sections from agent template
   - Provide real code examples with file:line refs
   - Document pattern frequencies
   - Note any inconsistencies found

Analyze at least 20-30 representative files across the codebase.
```

**Validation**:
- ✅ Agent completed analysis
- ✅ Standards document created
- ✅ Document is comprehensive (all sections present)
</step>

### Step 3: Validate & Report

<step>
**Objective**: Verify standards document quality

**Process**:
1. Read generated Circle/standards/README.md
2. Verify all major sections are present:
   - File Organization
   - Naming Conventions
   - Code Structure
   - Error Handling
   - Comments & Documentation
   - Testing Standards
   - Best Practices
   - Technology-Specific Guidelines
3. Check that examples have file:line references
4. Confirm patterns are backed by evidence

**Validation**:
- ✅ All sections present
- ✅ Real code examples included
- ✅ File references provided
- ✅ Standards are actionable
</step>

## Control Flow

<control_flow>
1. Pre-check → IF no source files → STOP
2. Create Circle/standards/ if needed
3. Launch standards-generator agent
4. Wait for completion
5. Validate document quality
6. Display summary
</control_flow>

## Report

<report>
```
✅ Standards document generated: Circle/standards/README.md

Analysis Summary:
- Tech Stack: {discovered languages/frameworks}
- Files Analyzed: {count}
- Patterns Discovered: {major pattern categories}

Document Sections:
✅ File Organization
✅ Naming Conventions
✅ Code Structure
✅ Error Handling
✅ Testing Standards
✅ Best Practices

Key Findings:
- {Finding 1}
- {Finding 2}
- {Finding 3}

Next Steps:
1. Review Circle/standards/README.md
2. Share with team for feedback
3. Refine based on team discussion
4. Use as reference for code reviews (/4_review uses this!)
```
</report>

## Usage Examples

<examples>
**Generate standards for current project**:
```
/standards
```

**When to use**:
- New project setup
- Onboarding new team members
- Before major refactoring
- When establishing code review guidelines
- When inconsistencies are noticed

**After generation**:
- Review and adjust as needed
- Get team consensus
- Update as project evolves
- Reference in /4_review command (it checks Circle/standards/)
</examples>

## Guidelines

**Focus**: DISCOVER patterns, don't IMPOSE them
**DO**: Analyze real code, provide examples, document frequencies
**DON'T**: Invent standards, cherry-pick examples, ignore inconsistencies
