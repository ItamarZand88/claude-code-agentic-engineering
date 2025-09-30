# Effective Context Engineering for AI Agents

_Based on Anthropic's engineering insights and best practices_

## Overview

Effective context engineering is crucial for building high-performing AI agents. This document outlines key principles and techniques for providing Claude with optimal context to achieve better results in complex tasks.

## Core Principles

### 1. Context Structure and Organization

**Provide Clear Task Context Early**

- Give Claude context about the role it should take on
- Explain overarching goals and tasks upfront
- Place context early in the prompt body for maximum effectiveness

```python
# Example: Task context definition
TASK_CONTEXT = "You are an expert lawyer specializing in contract analysis."
```

### 2. Structured Input with XML Tags

**Use XML Tags for Data Organization**

- Wrap input data in relevant XML tags
- Enable clear separation between instructions and data
- Support multiple data pieces with distinct tag sets

```xml
<legal_research>
{LEGAL_RESEARCH_CONTENT}
</legal_research>

<contract_details>
{CONTRACT_CONTENT}
</contract_details>
```

### 3. Multi-Document Structure

**Organize Complex Document Sets**

```xml
<documents>
  <document index="1">
    <source>annual_report_2023.pdf</source>
    <document_content>
      {{ANNUAL_REPORT}}
    </document_content>
  </document>
  <document index="2">
    <source>competitor_analysis_q2.xlsx</source>
    <document_content>
      {{COMPETITOR_ANALYSIS}}
    </document_content>
  </document>
</documents>
```

## Advanced Context Engineering Techniques

### Grounding with Quotes

For accuracy in long-context scenarios, use quote-based grounding:

```xml
<documents>
  <document index="1">
    <source>patient_symptoms.txt</source>
    <document_content>
      {{PATIENT_SYMPTOMS}}
    </document_content>
  </document>
</documents>

Find quotes from the documents that are most relevant to the question.
Place these in <quotes> tags. Then provide your analysis in <analysis> tags.
```

### Parallel Processing Instructions

**Optimize for Efficiency**

```text
For maximum efficiency, whenever you need to perform multiple independent
operations, invoke all relevant tools simultaneously rather than sequentially.
```

### Context Preservation in Conversations

**Maintain Context Across Messages**

- Use conversation history in structured format
- Include previous context when building on earlier interactions
- Preserve important details through XML structure

```python
INPUT_DATA = f"""Here is the conversational history:
<history>
{HISTORY}
</history>

Here is the current question:
<question>
{QUESTION}
</question>"""
```

## Prompt Engineering Best Practices

### Essential Prompt Elements

1. **User Role**: Always start with `user` role in Messages API
2. **Task Context**: Define role and goals early
3. **Tone Context**: Specify desired communication style
4. **Input Data**: Structure with XML tags
5. **Examples**: Provide ideal response examples
6. **Immediate Task**: Clarify expected actions

### Example Structure

```python
# Task definition
TASK_CONTEXT = "You are an AI assistant specializing in data analysis."

# Tone specification
TONE_CONTEXT = "Maintain a professional, analytical tone."

# Structured input
INPUT_DATA = f"""<dataset>
{DATA_CONTENT}
</dataset>

<analysis_requirements>
{REQUIREMENTS}
</analysis_requirements>"""

# Examples for guidance
EXAMPLES = """<example>
User: Analyze the sales trends
Assistant: Based on the dataset analysis...
</example>"""
```

## Key Takeaways

1. **Structure is Critical**: Use XML tags to organize information clearly
2. **Context Early**: Place important context at the beginning of prompts
3. **Examples Matter**: Provide concrete examples for complex tasks
4. **Parallel Processing**: Enable simultaneous operations when possible
5. **Maintain Continuity**: Preserve context across conversation turns
6. **Ground Responses**: Use quotes and citations for accuracy

## Implementation Tips

- Test prompt structures with colleagues to identify ambiguities
- Use consistent XML tag naming across related tasks
- Provide "outs" for Claude when information is unavailable
- Break complex tasks into clear, actionable steps
- Validate responses against expected outcomes

---

_For more detailed implementation examples, refer to Anthropic's documentation on prompt engineering and tool use._
