# Writing Tools for Agents

_Best practices for creating and implementing tools in AI agent systems_

## Overview

Writing effective tools for AI agents is crucial for enabling sophisticated automation and problem-solving capabilities. This guide covers tool design principles, implementation patterns, and optimization strategies for Claude-based agent systems.

## Tool Design Fundamentals

### Core Tool Components

Every tool should include:

- **Clear name and purpose**
- **Well-defined input schema**
- **Comprehensive description**
- **Error handling capabilities**
- **Return value specification**

### Tool Choice Configuration

```json
{
  "tool_choice": {
    "type": "auto|any|tool|none",
    "disable_parallel_tool_use": false,
    "name": "specific_tool_name"
  }
}
```

#### Tool Choice Types:

- **auto**: Model decides automatically (recommended)
- **any**: Model must use at least one tool
- **tool**: Force usage of specific tool
- **none**: Disable all tool usage

## Agent Loop Implementation

### Basic Agent Loop Pattern

```python
async def sampling_loop(
    *,
    model: str,
    messages: list[dict],
    api_key: str,
    max_tokens: int = 4096,
    max_iterations: int = 10,
):
    """
    A simple agent loop for Claude interactions with tools.
    """
    client = Anthropic(api_key=api_key)

    iterations = 0
    while iterations < max_iterations:
        iterations += 1

        # Call Claude API
        response = client.beta.messages.create(
            model=model,
            max_tokens=max_tokens,
            messages=messages,
            tools=tools,
        )

        # Process tool calls
        tool_results = []
        for block in response.content:
            if block.type == "tool_use":
                # Execute tool and get results
                result = execute_tool(block.name, block.input)
                tool_results.append({
                    "type": "tool_result",
                    "tool_use_id": block.id,
                    "content": result
                })

        # Check if conversation is complete
        if not tool_results:
            return messages

        # Continue with tool results
        messages.append({"role": "user", "content": tool_results})
```

## Tool Integration Patterns

### 1. Function-Based Tools

```python
def create_calculator_tool():
    return {
        "name": "calculator",
        "description": "Perform mathematical calculations",
        "input_schema": {
            "type": "object",
            "properties": {
                "expression": {
                    "type": "string",
                    "description": "Mathematical expression to evaluate"
                }
            },
            "required": ["expression"]
        }
    }
```

### 2. Database Query Tools

```python
def create_database_tool():
    return {
        "name": "database_query",
        "description": "Query product database",
        "input_schema": {
            "type": "object",
            "properties": {
                "query": {
                    "type": "string",
                    "description": "SQL query to execute"
                }
            },
            "required": ["query"]
        }
    }
```

## Parallel Tool Usage

### Enabling Parallel Execution

**Effective Prompting for Parallel Tools:**

```python
# Instead of sequential requests:
"Check the weather in Paris. Also check London."

# Use explicit parallel instructions:
"Check the weather in Paris and London simultaneously."

# Be explicit about parallelism:
"Please use parallel tool calls to get weather for Paris, London, and Tokyo at the same time."
```

### Configuration for Parallel Tools

```python
# Enable parallel tool usage (default)
tool_choice = {
    "type": "auto",
    "disable_parallel_tool_use": False
}

# Disable parallel usage (sequential only)
tool_choice = {
    "type": "auto",
    "disable_parallel_tool_use": True
}
```

## Tool Execution Workflow

### Standard Tool Workflow

1. **Define Tools**: Specify available tools with schemas
2. **Claude Decision**: Model assesses if tools are needed
3. **Tool Execution**: Extract parameters and run tools
4. **Result Integration**: Return results to Claude
5. **Final Response**: Claude formulates answer using results

### Example Implementation

```java
// Java example with tool thinking
BetaTool calculatorTool = BetaTool.builder()
    .name("calculator")
    .description("Perform mathematical calculations")
    .inputSchema(calculatorSchema)
    .build();

BetaMessage response = client.beta().messages().create(
    MessageCreateParams.builder()
        .model(Model.CLAUDE_OPUS_4_0)
        .maxTokens(16000)
        .thinking(BetaThinkingConfigEnabled.builder()
            .budgetTokens(10000)
            .build())
        .addTool(calculatorTool)
        .addUserMessage("What's the total revenue if we sold 150 units at $50 each?")
        .build()
);
```

## Error Handling and Validation

### Tool Input Validation

```python
def validate_tool_input(tool_name: str, input_data: dict) -> bool:
    """Validate tool input against schema"""
    try:
        # Validate against schema
        return validate_schema(tool_name, input_data)
    except ValidationError as e:
        return {"error": f"Invalid input: {e}"}
```

### Graceful Error Handling

```python
def execute_tool_safely(tool_name: str, input_data: dict):
    """Execute tool with error handling"""
    try:
        result = execute_tool(tool_name, input_data)
        return {
            "success": True,
            "result": result
        }
    except Exception as e:
        return {
            "success": False,
            "error": str(e),
            "fallback": "Tool execution failed, proceeding without result"
        }
```

## Advanced Tool Patterns

### Tool Chaining

Enable complex workflows by chaining tool outputs:

```python
def create_analysis_workflow():
    """Example: Data retrieval → Processing → Visualization"""
    return [
        {"name": "fetch_data", "description": "Retrieve data from source"},
        {"name": "process_data", "description": "Clean and transform data"},
        {"name": "create_visualization", "description": "Generate charts"}
    ]
```

### Conditional Tool Usage

```python
def smart_tool_selection(user_query: str, available_tools: list):
    """Select appropriate tools based on query analysis"""
    if "weather" in user_query.lower():
        return [weather_tool]
    elif "calculation" in user_query.lower():
        return [calculator_tool]
    else:
        return available_tools  # All tools available
```

## Performance Optimization

### Tool Response Optimization

1. **Minimize tool calls** - Design efficient single-purpose tools
2. **Batch operations** - Combine related operations when possible
3. **Cache results** - Store frequently accessed data
4. **Async execution** - Use parallel processing for independent tools

### Monitoring and Metrics

```python
def log_tool_usage(tool_name: str, execution_time: float, success: bool):
    """Track tool performance metrics"""
    metrics = {
        "tool": tool_name,
        "duration": execution_time,
        "success": success,
        "timestamp": datetime.now()
    }
    # Log to monitoring system
```

## Best Practices Summary

1. **Clear Naming**: Use descriptive, unambiguous tool names
2. **Comprehensive Schemas**: Define complete input/output specifications
3. **Error Resilience**: Implement robust error handling
4. **Performance Focus**: Optimize for speed and reliability
5. **Parallel Design**: Enable concurrent tool execution
6. **User Experience**: Provide clear feedback on tool operations
7. **Security**: Validate inputs and sanitize outputs
8. **Documentation**: Maintain clear tool descriptions and examples

---

_For implementation details and advanced patterns, refer to Anthropic's Tool Use documentation and Claude Code examples._
