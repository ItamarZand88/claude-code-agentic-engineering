---
description: Project knowledge graph and context management system for enhanced agent intelligence
model: claude-sonnet-4
allowed-tools: read, write, bash, search
argument-hint: [search_term]
---

# Project Context Intelligence System

⚠️ **DEPRECATED**: This command will be replaced by `/get-context` (read) and `/update-context` (write).
For better performance and clarity, consider using:
- `/get-context` - Fast context retrieval
- `/update-context` - Update context with new discoveries

**Legacy Mode**: This command now internally uses both get-context and update-context for backward compatibility.

Build and maintain a comprehensive knowledge graph of the entire project including relationships, dependencies, decision rationale, and historical context to enhance future agent interactions and team knowledge transfer.

## Variables
- **context_output_directory**: `./context/` - Directory where context maps and knowledge graphs are stored
- **context_database**: `./context/project-knowledge.json` - Main knowledge graph database file
- **context_report**: `./context/context-report.md` - Human-readable context analysis report

## Workflow
**Legacy Implementation**: This command now delegates to the new context commands:

1. **Context Reading Phase** (using `/get-context`)
   - If --query= provided: Use `/get-context --query=term` and return results
   - If --export= provided: Use `/get-context --json` then format for export
   - Otherwise: Load existing context for update preparation

2. **Context Update Phase** (using `/update-context`)
   - If --update provided: Use `/update-context --incremental`
   - If no existing context: Use `/update-context --full`
   - Otherwise: Perform standard incremental update

**Note**: For detailed implementation steps, refer to `/get-context` and `/update-context` commands.

## Legacy Workflow (for reference)
   - Scan entire project structure and identify all file types
   - Map directory hierarchies and organizational patterns
   - Identify configuration files, documentation, and metadata
   - Catalog all entry points, main modules, and key components

3. **Code Relationship Analysis**
   - **For each source file:**
     - Parse imports, exports, and dependencies
     - Identify function calls and class relationships
     - Map data flow and control flow patterns
     - Extract API endpoints and route definitions

4. **Architecture Pattern Recognition**
   - Identify architectural patterns (MVC, microservices, monolith, etc.)
   - Map design patterns used throughout the codebase
   - Document framework and library usage patterns
   - Analyze separation of concerns and layer boundaries

5. **Historical Context Extraction**
   - Analyze git commit history for decision context
   - Extract meaningful commit messages and PR descriptions
   - Identify major refactoring events and their rationale
   - Map feature development timelines and iterations

6. **Decision and Rationale Mining**
   - Extract architectural decisions from code comments
   - Identify TODO/FIXME items and their context
   - Document technology choices and alternatives considered
   - Map performance optimizations and their trade-offs

7. **Knowledge Graph Construction**
   - Build nodes for: files, functions, classes, modules, decisions, features
   - Create edges for: dependencies, calls, inheritance, composition, influences
   - Weight relationships by importance and frequency
   - Add temporal dimensions for evolution tracking

8. **Context Optimization for Agents**
   - Create agent-friendly summaries for different contexts
   - Generate reusable context snippets for common scenarios
   - Build prompt templates with embedded project knowledge
   - Create decision trees for common development questions

9. **Generate and Save Reports**
   - Save knowledge graph database to `./context/project-knowledge.json`
   - Generate human-readable report at `./context/context-report.md`
   - Create visualization files if export format specified
   - Update incremental change tracking for future runs

## Instructions
- Prioritize accuracy over speed - incorrect context is worse than no context
- Update incrementally to avoid performance issues on large codebases
- Focus on relationships and patterns that affect future development
- Maintain version history of context changes for rollback capability

## Control Flow
- **If** search term provided:
  - Search the knowledge graph for relevant context
  - Return focused results with relationship chains
- **Default behavior**:
  - Load existing context and provide comprehensive overview
  - Generate human-readable context report

## Delegation Prompts
- **File Analysis Agent**: Analyze individual files for patterns and relationships
- **Git History Agent**: Extract decision context from commit history and PRs
- **Dependency Scanner Agent**: Map external dependencies and integration points
- **Pattern Recognition Agent**: Identify architectural and design patterns
- **Documentation Extractor Agent**: Parse and structure existing documentation

## Report
Generate comprehensive project context dashboard with:
- **Project Overview**: Architecture, technology stack, development phase
- **Knowledge Graph Statistics**: Nodes, relationships, coverage metrics
- **Key Insights**: Architectural hotspots, technical debt clusters, decision rationale
- **Searchable Knowledge Base**: Quick access and relationship explorer
- **Agent Enhancement Data**: Context snippets and prompt templates for future use

When --for-agents flag is used, additionally generate:
- **context-summary.json**: Agent-consumable context data with structured insights
- **agent-context-snippets.json**: Pre-formatted context blocks for each agent type
- **prompt-enhancements.json**: Context-aware prompt improvements for better agent performance
