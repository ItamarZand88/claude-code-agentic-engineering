---
description: Generate project-specific coding standards from codebase analysis and PR review patterns
model: claude-sonnet-4
allowed-tools: read, write, search, bash
argument-hint: [output_path]
---

# Coding Standards Generator

<instruction>
Analyze the current codebase AND pull request review patterns to understand existing conventions, team preferences, and best practices. Generate a comprehensive coding standards document that reflects both the code patterns and the review culture of the team.
</instruction>

## Variables
- **output_path**: $ARGUMENTS - Optional custom output path (defaults to `./context/CODING_STANDARDS.md`)
- **codebase_root**: `./` - Root directory for codebase analysis
- **template_path**: `./context/CODING_STANDARDS.md` - Base template for coding standards
- **analysis_depth**: `comprehensive` - Level of codebase analysis to perform
- **pr_analysis_limit**: `20` - Number of recent PRs to analyze for review patterns

<workflow>
1. **Git Repository Analysis**
   <thinking>
   - Check if this is a git repository with remote origin
   - Verify access to pull request data (GitHub, GitLab, etc.)
   - Determine if PR analysis is possible
   </thinking>

2. **Pull Request Pattern Analysis**
   <thinking>
   - **Check PR availability**: Use `gh pr list --limit=20 --state=all` to fetch recent PRs
   - **For each meaningful PR**, analyze review comments using `gh pr view {number} --comments`
   - **Extract patterns from code review feedback**:

     **Style & Formatting Patterns:**
     - "fix indentation" → team's indentation preferences
     - "line too long" → preferred line length limits
     - "missing semicolon" → semicolon usage policy
     - "use single quotes" → quote preference

     **Code Quality Patterns:**
     - "use const instead of let" → variable declaration preferences
     - "extract this into a helper" → function size preferences
     - "add error handling" → error handling requirements
     - "missing tests" → testing expectations

     **Architecture Patterns:**
     - "follow existing pattern in X" → architectural consistency rules
     - "move this to utils" → code organization preferences
     - "don't repeat this logic" → DRY principle enforcement

     **Security Patterns:**
     - "validate input" → input validation requirements
     - "sanitize data" → data handling standards
     - "use env variables" → configuration management

     **Performance Patterns:**
     - "optimize this query" → performance expectations
     - "use lazy loading" → loading strategy preferences
     - "avoid unnecessary re-renders" → optimization standards

   - **Analyze review tone and thoroughness**:
     - Are reviews detailed or high-level?
     - How are disagreements handled?
     - What gets nitpicked vs what gets overlooked?

   - **Identify team vocabulary**: Specific terms/phrases the team uses repeatedly
   </thinking>

3. **Codebase Pattern Analysis**
   <thinking>
   - Scan project structure to identify primary languages and frameworks
   - Analyze existing code files for naming conventions, indentation, and structure patterns
   - Identify architecture patterns (MVC, microservices, component-based, etc.)
   - Extract common coding patterns and practices already in use
   - Cross-reference findings with PR review patterns
   </thinking>

4. **Technology Stack Detection**
   - Read package.json, requirements.txt, Cargo.toml, or similar dependency files
   - Identify frameworks, libraries, and development tools in use
   - Determine project type (web app, API, library, CLI tool, etc.)
   - Analyze build and testing configurations

5. **Convention Extraction**
   - Analyze naming conventions for files, functions, classes, and variables
   - Identify code organization patterns and directory structures
   - Extract formatting preferences (indentation, line length, bracket styles)
   - Document error handling and logging patterns
   - **Validate with PR insights**: Cross-reference with review comments about conventions

6. **Best Practices Identification**
   - Identify security practices already implemented
   - Analyze testing patterns and coverage strategies
   - Document performance optimization approaches
   - Extract documentation and commenting standards
   - **Integrate PR learnings**: Include team preferences discovered from review patterns

7. **Review Culture Analysis**
   <thinking>
   - Analyze PR review patterns to understand team culture:
     - How thorough are reviews? (nitpicky vs high-level)
     - What gets flagged most often? (style, logic, performance, security)
     - What are the team's "hot buttons"? (pet peeves that always get commented)
     - How does the team handle disagreements?
     - What level of testing is expected?
   - Extract implicit standards that aren't written down but are enforced in reviews
   </thinking>

8. **Standards Document Generation**
   <thinking>
   - Combine template structure with project-specific findings AND PR insights
   - Create tailored guidelines that match both code patterns and review culture
   - Include specific examples from the current project and common PR feedback
   - Highlight team preferences discovered through review patterns
   - Provide clear, actionable standards that reflect actual team practices
   </thinking>
</workflow>

<instructions>
- **Dual Analysis**: Combine codebase patterns with PR review insights for comprehensive understanding
- **Team Culture First**: Prioritize standards that reflect actual team practices over theoretical ideals
- **Evidence-Based**: Include specific examples from both code and PR comments
- **Review-Informed**: Highlight standards that are actively enforced in PR reviews
- **Actionable Guidelines**: Make standards measurable and enforceable
- **Context-Aware**: Consider the project's technology stack and team dynamics
- **Rationale Included**: Explain why each standard matters to help team buy-in
</instructions>

## Control Flow
- **If** git repository with PR access:
  - Prioritize PR analysis for team culture insights
  - Fall back to codebase-only analysis if PR data unavailable
- **If** no PR data available:
  - Focus on codebase pattern analysis
  - Note limitation in generated standards
- **If** no existing code is found:
  - Generate general standards based on detected technology stack
- **If** template already exists:
  - Enhance existing template with project-specific analysis AND PR insights
- **Standard generation**:
  - Create comprehensive standards that reflect both code patterns and review culture

<output>
Generate a coding standards document containing:
- **Project Overview**: Technology stack and architecture summary
- **Team Culture Insights**: Key findings from PR review analysis
- **File Organization**: Directory structure and naming conventions (validated by PR feedback)
- **Code Style**: Formatting, naming, and structure guidelines (informed by review patterns)
- **Best Practices**: Security, performance, and maintainability standards (based on what gets flagged in reviews)
- **Testing Standards**: Testing patterns and coverage requirements (derived from review expectations)
- **Documentation**: Comment and documentation requirements (based on review feedback)
- **Review Patterns**: Common feedback themes and team preferences
- **Hot Buttons**: Issues that consistently get flagged in PR reviews
- **Examples**: Real code snippets from the project AND actual PR comment examples
- **Enforcement**: Tools and processes for maintaining standards (including PR review practices)

### Special Sections from PR Analysis:
- **"Things That Always Get Commented"**: List of issues that repeatedly come up
- **"Team Preferences"**: Coding choices the team clearly favors based on review feedback
- **"Review Culture"**: How the team conducts reviews and what they prioritize
- **"Unwritten Rules"**: Standards that aren't documented but are enforced through reviews
</output>