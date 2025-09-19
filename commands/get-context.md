---
description: Fast, read-only context retrieval for agents and commands. Loads existing project knowledge without modifications.
model: claude-sonnet-4
allowed-tools: read, bash
argument-hint: [optional: query_term]
---

# Context Retrieval System

<instruction>
Lightweight, read-only command for quickly accessing existing project context. Optimized for speed and safe for frequent use by agents and other commands.
</instruction>

## Variables
- **context_output_directory**: `./context/` - Directory where context maps and knowledge graphs are stored
- **context_database**: `./context/project-knowledge.json` - Main knowledge graph database file
- **context_summary**: `./context/context-summary.json` - Agent-optimized context data
- **agent_snippets**: `./context/agent-context-snippets.json` - Pre-formatted context blocks
- **prompt_enhancements**: `./context/prompt-enhancements.json` - Context-aware prompt improvements

<workflow>
1. **Context Availability Check**
   <thinking>
   - Check if `./context/` directory exists
   - Verify presence of context database file
   - Check freshness of context data (last modified timestamps)
   - If no context exists, provide guidance on running `/update-context`
   </thinking>

2. **Context Loading**
   - Load main knowledge graph from `./context/project-knowledge.json`
   - Load agent-optimized summaries if available
   - Parse context metadata (version, coverage, last update)
   - Extract key architectural insights and patterns

3. **Context Loading & Processing**
   - Load project context summary for quick overview
   - If query term provided, search for specific information
   - Return structured, human-readable context summary

4. **Fast Response Generation**
   <thinking>
   - Format output based on requested mode
   - Include context freshness indicators
   - Provide relevant snippets without deep analysis
   - Include recommendations for context updates if stale
   </thinking>
</workflow>

<instructions>
- **Read-only operation**: Never modify any files or directories
- **Performance optimized**: Return results quickly without heavy analysis
- **Safe for automation**: Can be called frequently by agents and scripts
- **Context guidance**: Help users understand when to update context
- **Structured output**: Provide consistent, parseable responses
</instructions>

## Control Flow
- **If** no context directory exists:
  - Return guidance on running `/update-context` first
- **If** context exists but is stale (>7 days):
  - Load available context but warn about staleness
  - Recommend running `/update-context`
- **If** query term provided:
  - Search knowledge graph for relevant information
  - Return focused results with context

<output>
Generate context retrieval response containing:

### Context Status
- **Availability**: Whether context data exists and is accessible
- **Freshness**: Last update timestamp and staleness indicators
- **Coverage**: Scope of context data (files analyzed, patterns identified)
- **Version**: Context database version or generation timestamp

### Project Overview (if --summary or default)
- **Architecture**: High-level architectural patterns identified
- **Technology Stack**: Primary frameworks, languages, and tools
- **Key Patterns**: Most important design patterns and conventions
- **Development Phase**: Project maturity and current development focus

### Agent Context (if --for-agents)
- **Pattern Recognition**: Known architectural and design patterns
- **File Analysis**: Key file relationships and structure insights
- **Git History**: Important development decisions and evolution
- **Dependencies**: External library usage and integration patterns
- **Documentation**: Known documentation structure and conventions

### Query Results (if --query= provided)
- **Matching Concepts**: Context elements related to search term
- **Confidence Scores**: Relevance rating for each result (0-100%)
- **Related Patterns**: Connected architectural or design elements
- **File References**: Specific files or locations related to query

### Recommendations
- **Context Updates**: Suggestions for when to refresh context
- **Missing Analysis**: Areas where context might be incomplete
- **Next Steps**: Recommended actions based on current context state
- **Usage Tips**: How to best leverage existing context data

### Quick Access
- **Key Files**: Most important files identified in context
- **Entry Points**: Main application entry points and initialization
- **Configuration**: Key configuration files and patterns
- **Testing**: Test structure and patterns (if analyzed)