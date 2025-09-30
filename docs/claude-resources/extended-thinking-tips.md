# Extended Thinking Tips

_Maximizing Claude's reasoning capabilities for complex problems_

## Overview

Extended thinking enables Claude to use additional reasoning tokens before providing final responses, leading to better performance on complex tasks requiring deep analysis, mathematical reasoning, and multi-step problem solving.

## Understanding Extended Thinking

### What is Extended Thinking?

Extended thinking allows Claude to:

- **Reason through problems step-by-step** before responding
- **Consider multiple approaches** and select the best one
- **Show detailed work** for mathematical and logical problems
- **Think through edge cases** and potential issues
- **Verify results** before finalizing answers

### Supported Models

Currently available on:

- `claude-opus-4-1-20250805`
- `claude-opus-4-20250514`
- `claude-sonnet-4-5-20250929`

## Enabling Extended Thinking

### Basic Configuration

```json
{
  "model": "claude-sonnet-4-5",
  "max_tokens": 16000,
  "thinking": {
    "type": "enabled",
    "budget_tokens": 10000
  },
  "messages": [
    {
      "role": "user",
      "content": "Solve this complex mathematical problem..."
    }
  ]
}
```

### Python Implementation

```python
from anthropic import Anthropic

client = Anthropic()

response = client.beta.messages.create(
    model="claude-sonnet-4-5",
    max_tokens=16000,
    thinking={
        "type": "enabled",
        "budget_tokens": 10000
    },
    messages=[
        {"role": "user", "content": "Are there an infinite number of prime numbers such that n mod 4 == 3?"}
    ]
)

# Process thinking and final response
for block in response.content:
    if block.type == "thinking":
        print(f"Reasoning: {block.thinking}")
    elif block.type == "text":
        print(f"Final Answer: {block.text}")
```

### Java Implementation with Tools

```java
import com.anthropic.client.AnthropicClient;
import com.anthropic.models.beta.messages.*;

AnthropicClient client = AnthropicOkHttpClient.fromEnv();

BetaMessage response = client.beta().messages().create(
    MessageCreateParams.builder()
        .model(Model.CLAUDE_OPUS_4_0)
        .maxTokens(16000)
        .thinking(BetaThinkingConfigEnabled.builder()
            .budgetTokens(10000)
            .build())
        .addTool(weatherTool)
        .addUserMessage("What's the weather in Paris and how will it affect tourism this weekend?")
        .build()
);
```

## Prompting for Effective Thinking

### High-Level vs Step-by-Step Instructions

❌ **Less Effective (Too Prescriptive)**:

```text
Think through this math problem step by step:
1. First, identify the variables
2. Then, set up the equation
3. Next, solve for x
4. Finally, check your work
```

✅ **More Effective (High-Level Guidance)**:

```text
Please think about this math problem thoroughly and in great detail.
Consider multiple approaches and show your complete reasoning.
Try different methods if your first approach doesn't work.
```

### Encouraging Deep Analysis

**For Complex Problems**:

```text
This is a challenging problem that may require careful consideration of multiple factors.
Please think through it systematically, considering various approaches and potential edge cases.
```

**For Decision-Making**:

```text
Analyze this situation comprehensively. Consider the pros and cons, potential risks,
alternative approaches, and long-term implications before making your recommendation.
```

**For Creative Tasks**:

```text
Approach this creatively and thoughtfully. Consider multiple angles, explore different
possibilities, and think about what would make this truly exceptional.
```

## Extended Thinking with Tool Use

### Configuration Requirements

**Important Constraints**:

- Only supports `tool_choice: {"type": "auto"}` (default) or `tool_choice: {"type": "none"}`
- Cannot use `tool_choice: {"type": "any"}` or `tool_choice: {"type": "tool", "name": "..."}`
- Must preserve thinking blocks when passing tool results back to API

### Preserving Thinking Context

**Example with Tool Results**:

```json
{
  "messages": [
    { "role": "user", "content": "What's the weather in San Francisco?" },
    {
      "role": "assistant",
      "content": [
        {
          "type": "thinking",
          "thinking": "I need to find the weather for San Francisco. I will use the get_weather tool."
        },
        {
          "type": "tool_use",
          "id": "toolu_01xxxxxxxxxxxxxxxxxxxxxx",
          "name": "get_weather",
          "input": { "location": "San Francisco" }
        }
      ]
    },
    {
      "role": "user",
      "content": [
        {
          "type": "tool_result",
          "tool_use_id": "toolu_01xxxxxxxxxxxxxxxxxxxxxx",
          "content": "{\"temperature\": \"15°C\", \"condition\": \"Cloudy\"}"
        }
      ]
    }
  ],
  "thinking": {
    "type": "enabled",
    "budget_tokens": 5000
  }
}
```

### Tool Integration Pattern

```python
async def handle_thinking_with_tools(user_message, tools):
    """Handle extended thinking with tool integration"""

    # Initial request with thinking enabled
    response = await client.beta.messages.create(
        model="claude-sonnet-4-5",
        max_tokens=16000,
        thinking={"type": "enabled", "budget_tokens": 8000},
        tools=tools,
        messages=[{"role": "user", "content": user_message}]
    )

    messages = [{"role": "user", "content": user_message}]

    while True:
        # Add Claude's response to message history
        messages.append({"role": "assistant", "content": response.content})

        # Check for tool use
        tool_results = []
        for block in response.content:
            if block.type == "tool_use":
                # Execute tool
                result = await execute_tool(block.name, block.input)
                tool_results.append({
                    "type": "tool_result",
                    "tool_use_id": block.id,
                    "content": result
                })

        # If no tools used, we're done
        if not tool_results:
            break

        # Continue with tool results
        messages.append({"role": "user", "content": tool_results})

        response = await client.beta.messages.create(
            model="claude-sonnet-4-5",
            max_tokens=16000,
            thinking={"type": "enabled", "budget_tokens": 5000},
            tools=tools,
            messages=messages
        )

    return response
```

## Optimizing Thinking Performance

### Token Budget Guidelines

**Budget Allocation Strategies**:

- **Simple problems**: 2000-5000 tokens
- **Complex analysis**: 8000-12000 tokens
- **Mathematical proofs**: 10000-15000 tokens
- **Multi-step reasoning**: 5000-10000 tokens

### Thinking vs Response Balance

```python
def optimize_thinking_budget(task_complexity, max_tokens):
    """Optimize thinking budget based on task requirements"""

    if task_complexity == "simple":
        thinking_budget = min(max_tokens * 0.3, 5000)
    elif task_complexity == "moderate":
        thinking_budget = min(max_tokens * 0.5, 8000)
    elif task_complexity == "complex":
        thinking_budget = min(max_tokens * 0.7, 12000)
    else:  # very_complex
        thinking_budget = min(max_tokens * 0.8, 15000)

    return int(thinking_budget)

# Usage
budget = optimize_thinking_budget("complex", 16000)  # Returns 12000
```

## Use Cases for Extended Thinking

### Mathematical Problem Solving

**Prime Number Analysis**:

```text
Are there an infinite number of prime numbers such that n mod 4 == 3?

Please think through this mathematical question carefully, considering:
- The distribution of primes
- Modular arithmetic properties
- Proof techniques that might apply
- Historical context and related theorems
```

### Code Architecture Decisions

**System Design Reasoning**:

```text
I need to design a distributed caching system that can handle 1 million requests per second
with 99.9% availability. Think through the architecture decisions carefully, considering:
- Consistency vs availability trade-offs
- Partitioning strategies
- Failure scenarios and recovery
- Performance optimization approaches
```

### Complex Debugging

**Root Cause Analysis**:

```text
Our application is experiencing intermittent 500 errors under high load. The errors seem
random and don't correlate with any obvious patterns. Think through this debugging problem
systematically, considering potential causes and diagnostic approaches.
```

### Business Strategy Analysis

**Strategic Decision Making**:

```text
We're considering entering a new market that could represent 30% revenue growth but requires
significant investment and has regulatory uncertainty. Analyze this decision thoroughly,
weighing all factors and considering multiple scenarios.
```

## Monitoring and Optimization

### Response Analysis

```python
def analyze_thinking_effectiveness(response):
    """Analyze the quality and efficiency of thinking"""

    thinking_content = None
    final_response = None

    for block in response.content:
        if block.type == "thinking":
            thinking_content = block.thinking
        elif block.type == "text":
            final_response = block.text

    if thinking_content and final_response:
        metrics = {
            'thinking_length': len(thinking_content),
            'response_length': len(final_response),
            'thinking_to_response_ratio': len(thinking_content) / len(final_response),
            'contains_step_by_step': 'step' in thinking_content.lower(),
            'considers_alternatives': 'alternative' in thinking_content.lower(),
            'shows_verification': any(word in thinking_content.lower()
                                   for word in ['check', 'verify', 'confirm'])
        }
        return metrics

    return None
```

### Performance Tracking

```python
class ThinkingMetrics:
    def __init__(self):
        self.thinking_usage = []

    def log_thinking_request(self, task_type, thinking_budget, actual_thinking_tokens, outcome_quality):
        """Log thinking usage for analysis"""
        self.thinking_usage.append({
            'task_type': task_type,
            'budget': thinking_budget,
            'used': actual_thinking_tokens,
            'efficiency': actual_thinking_tokens / thinking_budget,
            'quality_score': outcome_quality,
            'timestamp': datetime.now()
        })

    def analyze_patterns(self):
        """Analyze thinking usage patterns"""
        df = pd.DataFrame(self.thinking_usage)

        return {
            'avg_efficiency_by_task': df.groupby('task_type')['efficiency'].mean(),
            'quality_correlation': df['efficiency'].corr(df['quality_score']),
            'optimal_budgets': df.groupby('task_type')['budget'].quantile(0.8)
        }
```

## Best Practices

### 1. Appropriate Task Selection

**Good Candidates for Extended Thinking**:

- Mathematical proofs and complex calculations
- Multi-step logical reasoning
- Code architecture and design decisions
- Strategic business analysis
- Creative problem solving with constraints
- Debugging complex systems

**Less Suitable Tasks**:

- Simple factual lookups
- Basic formatting or editing
- Routine API calls
- Simple data transformations

### 2. Prompt Engineering

**Effective Patterns**:

```text
✅ "Think through this carefully and comprehensively"
✅ "Consider multiple approaches before deciding"
✅ "Analyze this systematically, considering edge cases"
✅ "Reason about this problem in detail"
```

**Avoid**:

```text
❌ "Step 1: Do X, Step 2: Do Y, Step 3: Do Z"
❌ "Follow this exact procedure"
❌ "Think about it quickly and respond"
```

### 3. Budget Management

**Optimization Strategies**:

- Start with moderate budgets (5000-8000 tokens)
- Monitor usage patterns and adjust
- Scale budget with task complexity
- Leave adequate tokens for final response

### 4. Integration with Workflows

**Development Workflow Integration**:

```python
def enhanced_code_review(code_snippet, context):
    """Code review with extended thinking"""

    prompt = f"""
    Please review this code thoroughly, thinking through potential issues:

    <code>
    {code_snippet}
    </code>

    <context>
    {context}
    </context>

    Consider security, performance, maintainability, and correctness.
    Think through edge cases and potential improvements.
    """

    return client.beta.messages.create(
        model="claude-sonnet-4-5",
        max_tokens=12000,
        thinking={"type": "enabled", "budget_tokens": 8000},
        messages=[{"role": "user", "content": prompt}]
    )
```

## Summary

Extended thinking is most effective when:

1. **Tasks are genuinely complex** and benefit from deep reasoning
2. **Prompts encourage exploration** rather than prescribe specific steps
3. **Token budgets are appropriately sized** for the task complexity
4. **Tool integration preserves thinking context** across interactions
5. **Performance is monitored** and optimized over time

---

_For implementation details and advanced patterns, refer to Anthropic's Extended Thinking documentation._
