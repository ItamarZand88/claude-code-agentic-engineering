# Claude 4 Best Practices

_Optimizing performance and results with Claude 4 models_

## Overview

Claude 4 introduces enhanced capabilities requiring updated best practices for prompt engineering, tool use, and task orchestration. This guide covers key strategies for maximizing Claude 4's potential.

## Core Best Practices

### 1. Context and Motivation in Prompts

**Provide Clear Reasoning for Instructions**

❌ **Less Effective (Negative Constraint)**:

```text
NEVER use ellipses
```

✅ **More Effective (Contextual Explanation)**:

```text
Your response will be read aloud by a text-to-speech engine, so never use ellipses
since the text-to-speech engine will not know how to pronounce them.
```

**Why This Works**:

- Gives Claude understanding of the underlying purpose
- Enables better adherence to instructions
- Allows intelligent adaptation to edge cases

### 2. Optimize Parallel Tool Calling

**Maximize Efficiency with Simultaneous Operations**

```text
For maximum efficiency, whenever you need to perform multiple independent operations,
invoke all relevant tools simultaneously rather than sequentially.
```

**Implementation Strategy**:

```python
# Agent prompt optimization
PARALLEL_TOOL_PROMPT = """
When you identify multiple independent tasks, execute them concurrently:
- Use parallel tool calls for unrelated operations
- Batch similar operations when possible
- Minimize sequential dependencies
"""
```

**Success Rate**: This approach achieves approximately 100% parallel tool use success rate.

### 3. Long Task Management

**Handle Extended Workflows Effectively**

```text
This is a very long task, so it may be beneficial to plan out your work clearly.
It's encouraged to spend your entire output context working on the task - just
make sure you don't run out of context with significant uncommitted work.
Continue working systematically until you have completed this task.
```

**Key Principles**:

- **Clear Planning**: Outline approach before execution
- **Context Efficiency**: Use full output context effectively
- **Systematic Progress**: Work methodically through complex tasks
- **Checkpoint Management**: Avoid uncommitted work at context limits

## Advanced Prompting Techniques

### System Prompt Configuration

**Effective System Prompt Structure**:

```json
{
  "system": "You are a helpful assistant with expertise in [domain].
            Your responses should be [characteristics].
            When handling [specific scenarios], [specific instructions]."
}
```

**Example - AI Career Coach**:

```python
SYSTEM_PROMPT = """
You are an AI career coach named Joe created by AI Career Coach Co.
Your goal is to give career advice to users who are on the AI Career Coach Co. site.

Key rules:
- Always stay in character as Joe from AI Career Coach Co
- If unsure, say "Sorry, I didn't understand that. Could you rephrase your question?"
- For irrelevant questions, redirect: "Sorry, I am Joe and I give career advice.
  Do you have a career question today I can help you with?"
"""
```

### Structured Input Processing

**Multi-Document Analysis Pattern**:

```python
STRUCTURED_INPUT = """
<documents>
  <document index="1">
    <source>{SOURCE_1}</source>
    <document_content>{CONTENT_1}</document_content>
  </document>
  <document index="2">
    <source>{SOURCE_2}</source>
    <document_content>{CONTENT_2}</document_content>
  </document>
</documents>

Analyze the documents and provide insights on [specific_requirements].
"""
```

## Tool Use Optimization

### Enhanced Tool Integration

**Tool Choice Configuration**:

```python
# Force specific tool usage
tool_choice = {"type": "tool", "name": "print_sentiment_scores"}

# Enable automatic tool selection (recommended)
tool_choice = {"type": "auto"}

# Require any tool usage
tool_choice = {"type": "any"}

# Disable all tools
tool_choice = {"type": "none"}
```

### Thinking with Tool Use

**Enable Enhanced Reasoning**:

```java
// Java implementation with extended thinking
BetaMessage response = client.beta().messages().create(
    MessageCreateParams.builder()
        .model(Model.CLAUDE_OPUS_4_0)
        .maxTokens(16000)
        .thinking(BetaThinkingConfigEnabled.builder()
            .budgetTokens(10000)
            .build())
        .addTool(calculatorTool)
        .addTool(databaseTool)
        .addUserMessage("Calculate total revenue and compare to historical averages")
        .build()
);
```

## Model-Specific Features

### Extended Thinking Capabilities

**When to Enable Extended Thinking**:

- Complex mathematical problems
- Multi-step reasoning tasks
- Architectural decision-making
- Debugging complex issues

**Configuration**:

```json
{
  "model": "claude-opus-4-1-20250805",
  "temperature": 1,
  "thinking": {
    "type": "enabled",
    "budget_tokens": 10000
  },
  "max_tokens": 16000
}
```

### Non-Interleaved vs Interleaved Thinking

**Non-Interleaved (Recommended for Tool Use)**:

- Single thinking phase before all tool calls
- More efficient for parallel operations
- Better for complex tool coordination

**Interleaved**:

- Thinking between each tool call
- Better for sequential reasoning
- More granular decision-making

## Performance Optimization

### Prompt Engineering for Speed

**Efficient Prompt Structure**:

1. **Front-load context**: Place critical information early
2. **Use clear delimiters**: XML tags for data separation
3. **Minimize redundancy**: Avoid repeating information
4. **Optimize examples**: Provide concise, relevant examples

### Context Window Management

**Long Context Best Practices**:

- Structure documents with clear hierarchies
- Use consistent tagging schemes
- Provide document summaries when helpful
- Ground responses with specific quotes

### Response Quality Assurance

**Multi-Step Verification**:

```text
Please solve this problem step by step:
1. First, identify the key variables
2. Then, set up the equations
3. Solve systematically
4. Verify your answer makes sense
5. Check against alternative approaches
```

## Common Patterns and Solutions

### Information Extraction

**Structured Data Pattern**:

```xml
<source_documents>
  <document id="1">{{CONTENT_1}}</document>
  <document id="2">{{CONTENT_2}}</document>
</source_documents>

Extract key information and format as:
<extracted_info>
  <key_points>
    <point category="A">{{POINT_1}}</point>
    <point category="B">{{POINT_2}}</point>
  </key_points>
  <summary>{{BRIEF_SUMMARY}}</summary>
</extracted_info>
```

### Decision Making Framework

**Systematic Decision Process**:

```text
For this decision, please:
1. Identify all viable options in <options> tags
2. List pros/cons for each in <analysis> tags
3. Consider risks and mitigation in <risks> tags
4. Provide final recommendation in <recommendation> tags
5. Include confidence level and reasoning
```

## Error Handling and Edge Cases

### Graceful Degradation

**Handle Unknown Information**:

```python
ROBUST_PROMPT = """
If you don't have enough information to answer completely:
1. State what you can determine with confidence
2. Clearly identify information gaps
3. Suggest what additional data would help
4. Provide partial insights where possible
"""
```

### Input Validation

**Validate Tool Inputs**:

```python
def validate_before_tool_use(tool_input):
    """Validate inputs before tool execution"""
    if not tool_input or not isinstance(tool_input, dict):
        return False

    # Check required fields
    required_fields = get_required_fields(tool_name)
    for field in required_fields:
        if field not in tool_input:
            return False

    return True
```

## Testing and Evaluation

### A/B Testing Framework

```python
def compare_prompt_versions(prompt_a, prompt_b, test_cases):
    """Compare two prompt versions across test cases"""
    results = {'prompt_a': [], 'prompt_b': []}

    for case in test_cases:
        response_a = get_completion(prompt_a.format(**case))
        response_b = get_completion(prompt_b.format(**case))

        results['prompt_a'].append(evaluate_response(response_a, case))
        results['prompt_b'].append(evaluate_response(response_b, case))

    return analyze_performance_difference(results)
```

### Quality Metrics

**Key Performance Indicators**:

- **Accuracy**: Correctness of factual information
- **Completeness**: Coverage of required topics
- **Coherence**: Logical flow and structure
- **Efficiency**: Token usage and response time
- **Tool Usage**: Appropriate tool selection and execution

## Integration Patterns

### API Integration

**Robust API Calls**:

```python
async def claude_4_completion(
    messages,
    model="claude-opus-4-1-20250805",
    max_tokens=4096,
    temperature=1.0,
    tools=None,
    thinking_budget=None
):
    """Optimized Claude 4 API call with error handling"""

    params = {
        "model": model,
        "messages": messages,
        "max_tokens": max_tokens,
        "temperature": temperature
    }

    if tools:
        params["tools"] = tools

    if thinking_budget:
        params["thinking"] = {
            "type": "enabled",
            "budget_tokens": thinking_budget
        }

    try:
        response = await client.messages.create(**params)
        return response
    except Exception as e:
        logger.error(f"Claude 4 API error: {e}")
        raise
```

### Monitoring and Analytics

**Track Usage Patterns**:

```python
def log_claude_4_usage(request, response, execution_time):
    """Log detailed usage metrics"""
    metrics = {
        'model': request.get('model'),
        'input_tokens': response.usage.input_tokens,
        'output_tokens': response.usage.output_tokens,
        'tools_used': len([b for b in response.content if b.type == 'tool_use']),
        'thinking_enabled': 'thinking' in request,
        'execution_time_ms': execution_time,
        'timestamp': datetime.utcnow()
    }

    analytics_client.track('claude_4_completion', metrics)
```

## Summary

Claude 4 best practices focus on:

1. **Contextual Clarity**: Explain the 'why' behind instructions
2. **Parallel Efficiency**: Optimize for simultaneous operations
3. **Systematic Planning**: Structure complex tasks clearly
4. **Tool Integration**: Leverage enhanced tool capabilities
5. **Extended Thinking**: Use for complex reasoning tasks
6. **Quality Assurance**: Implement verification patterns
7. **Performance Monitoring**: Track and optimize usage

---

_For the latest features and updates, refer to the official Claude 4 documentation and API reference._
