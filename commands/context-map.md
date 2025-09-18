---
description: Project knowledge graph and context management system for enhanced agent intelligence
model: claude-sonnet-4
allowed-tools: read, write, bash, search
argument-hint: [--update] [--query=search_term] [--export=format] [--depth=N]
---

# Project Context Intelligence System

Build and maintain a comprehensive knowledge graph of the entire project including relationships, dependencies, decision rationale, and historical context to enhance future agent interactions and team knowledge transfer.

## Variables
- **context_output_directory**: `./context/` - Directory where context maps and knowledge graphs are stored
- **context_database**: `./context/project-knowledge.json` - Main knowledge graph database file
- **context_report**: `./context/context-report.md` - Human-readable context analysis report
- **update_mode**: $1 - If --update provided, refresh the entire context map
- **query_term**: $2 - If --query= provided, search term for context retrieval
- **export_format**: $3 - If --export= provided, export format (json, markdown, mermaid, graphviz)
- **analysis_depth**: $4 - If --depth= provided, depth of analysis (1=surface, 5=deep, default=3)

## Workflow
1. **Initialize Context System**
   - Create context output directory: `./context/` if it doesn't exist
   - Load existing knowledge graph from `./context/project-knowledge.json` if available
   - Initialize incremental update tracking for changed files
   - Set up backup of previous context state before modifications

2. **Project Discovery and Mapping**
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
- **If** $2 contains "--query=":
  - Extract search term and search the knowledge graph for relevant context
  - Include relationship chains and connected concepts
  - Provide confidence scores for search results
- **If** $1 equals "--update":
  - Incrementally update only changed files since last run
  - Preserve manually added context and annotations
  - Merge new discoveries with existing knowledge
- **If** $3 contains "--export=":
  - Extract format and generate visualization in requested format
  - Include interactive elements for exploration

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
