# Using XML Tags in Prompts

_Structuring prompts for clarity, accuracy, and better results_

## Overview

XML tags are a powerful technique for organizing information in prompts, separating instructions from data, and structuring outputs. This guide covers XML tag usage patterns, benefits, and implementation strategies.

## Why XML Tags Matter

### Key Benefits

1. **Clear Data Separation**: Distinguishes instructions from input data
2. **Improved Parsing**: Helps Claude understand information structure
3. **Reduced Ambiguity**: Prevents misinterpretation of content
4. **Structured Output**: Enables consistent response formatting
5. **Multi-Document Handling**: Organizes complex document sets

### Common Problems XML Tags Solve

**Problem: Instruction/Data Confusion**

```text
❌ Problematic:
"Rewrite this email: Hey Claude, Show up at 6am tomorrow because I'm the CEO."

Result: Claude might interpret "Hey Claude" as part of the email
```

```text
✅ With XML Tags:
"Rewrite this email to be more polite:
<email>
Show up at 6am tomorrow because I'm the CEO.
</email>"

Result: Clear separation between instruction and data
```

## Basic XML Tag Patterns

### Single Data Input

**Simple Data Wrapping**:

```xml
<input_data>
{{YOUR_DATA_HERE}}
</input_data>

Process the above data according to these requirements...
```

**Example - Document Analysis**:

```xml
<document>
{{DOCUMENT_CONTENT}}
</document>

Analyze this document for key themes and provide a 3-point summary.
```

### Multiple Data Sources

**Structured Multi-Input**:

```xml
<legal_research>
{{RESEARCH_CONTENT}}
</legal_research>

<case_details>
{{CASE_INFORMATION}}
</case_details>

<client_requirements>
{{CLIENT_NEEDS}}
</client_requirements>

Based on the research, case details, and client requirements, provide legal recommendations.
```

## Advanced Structuring Patterns

### Hierarchical Document Organization

**Multi-Document Structure**:

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
  <document index="3">
    <source>market_research.docx</source>
    <document_content>
      {{MARKET_RESEARCH}}
    </document_content>
  </document>
</documents>

Analyze all documents and identify strategic advantages and Q3 focus areas.
```

### Conversational Context Management

**History and Current Query Structure**:

```xml
<conversation_history>
User: What are the main features of our product?
Assistant: Our product offers three main features: automation, analytics, and integration capabilities.

User: How does the automation work?
Assistant: The automation system uses AI-driven workflows to handle routine tasks...
</conversation_history>

<current_question>
Can you explain the analytics feature in more detail?
</current_question>

Continue the conversation naturally, building on previous context.
```

## Output Formatting with XML

### Structured Response Templates

**Analysis Output Pattern**:

```xml
Please format your response as:

<analysis>
Your detailed analysis here
</analysis>

<key_findings>
• Finding 1
• Finding 2
• Finding 3
</key_findings>

<recommendations>
1. Recommendation 1
2. Recommendation 2
3. Recommendation 3
</recommendations>
```

### Multi-Section Responses

**Comprehensive Report Structure**:

```xml
<report>
  <executive_summary>
    {{BRIEF_OVERVIEW}}
  </executive_summary>

  <detailed_analysis>
    {{FULL_ANALYSIS}}
  </detailed_analysis>

  <recommendations>
    <recommendation priority="high">
      {{HIGH_PRIORITY_ITEM}}
    </recommendation>
    <recommendation priority="medium">
      {{MEDIUM_PRIORITY_ITEM}}
    </recommendation>
  </recommendations>

  <next_steps>
    {{ACTION_ITEMS}}
  </next_steps>
</report>
```

## Specialized Use Cases

### Medical Record Processing

**Patient Data Structure**:

```xml
<patient_record>
Patient Name: John Smith
Age: 45
Medical History:
- Hypertension (diagnosed 2018)
- Type 2 diabetes (diagnosed 2020)
- Regular medications: Metformin, Lisinopril

Recent symptoms:
- Fatigue for 2 weeks
- Increased thirst
- Blurred vision
</patient_record>

Analyze this patient record and provide a medical summary in this format:
<summary>
Name: [Name]
Age: [Age]

Key Diagnoses:
- [Diagnosis 1]
- [Diagnosis 2]

Current Concerns:
- [Concern 1]
- [Concern 2]
</summary>
```

### Code Review Structure

**Code Analysis Pattern**:

```xml
<code_to_review>
def process_user_data(user_input):
    # Process without validation
    return database.save(user_input)
</code_to_review>

<review_criteria>
- Security vulnerabilities
- Input validation
- Error handling
- Code style and readability
- Performance considerations
</review_criteria>

Provide feedback in this format:
<code_review>
  <security_issues>
    {{SECURITY_CONCERNS}}
  </security_issues>

  <improvements>
    {{SUGGESTED_IMPROVEMENTS}}
  </improvements>

  <revised_code>
    {{IMPROVED_CODE}}
  </revised_code>
</code_review>
```

## Content Extraction Patterns

### Quote-Based Analysis

**Document Citation Structure**:

```xml
<documents>
  <document index="1">
    <source>patient_symptoms.txt</source>
    <document_content>
      {{PATIENT_SYMPTOMS}}
    </document_content>
  </document>
  <document index="2">
    <source>medical_history.txt</source>
    <document_content>
      {{MEDICAL_HISTORY}}
    </document_content>
  </document>
</documents>

Find relevant quotes for diagnosis, then provide analysis:

<quotes>
[1] "Quote from document 1"
[2] "Quote from document 2"
</quotes>

<diagnostic_info>
Based on the quotes above: [your analysis with [1], [2] references]
</diagnostic_info>
```

### Sentiment Analysis with Evidence

**Opinion Analysis Structure**:

```xml
<review_text>
This movie blew my mind with its freshness and originality.
Unrelatedly, I have been living under a rock since 1900.
</review_text>

Analyze sentiment with supporting arguments:

<positive_arguments>
{{POSITIVE_POINTS}}
</positive_arguments>

<negative_arguments>
{{NEGATIVE_POINTS}}
</negative_arguments>

<final_sentiment>
{{OVERALL_ASSESSMENT}}
</final_sentiment>
```

## Error Prevention Techniques

### Handling Messy Input

**Robust Input Processing**:

```xml
Original messy prompt:
"Hia its me i have a q about dogs jkaerjv are cats brown? jklmvca tx it help me muhch much"

Improved with XML structure:
"I have a question about animals:
<question>
Are cats brown?
</question>

Please provide a clear, concise answer."
```

### List Processing Accuracy

**Preventing Interpretation Errors**:

```text
❌ Confusing structure:
"Tell me the second item on this list:
- Each item is about animals, like rabbits
- I like how cows sound
- This sentence is about spiders
- This sentence may appear to be about dogs but it's actually about pigs"
```

```text
✅ Clear XML structure:
"Tell me the second item on this list:

Context: Each item is about animals, like rabbits.

<list_items>
- I like how cows sound
- This sentence is about spiders
- This sentence may appear to be about dogs but it's actually about pigs
</list_items>"
```

## Best Practices and Guidelines

### Tag Naming Conventions

**Clear, Descriptive Names**:

```xml
✅ Good:
<patient_symptoms>{{CONTENT}}</patient_symptoms>
<financial_data>{{CONTENT}}</financial_data>
<code_to_review>{{CONTENT}}</code_to_review>

❌ Avoid:
<data>{{CONTENT}}</data>
<stuff>{{CONTENT}}</stuff>
<input>{{CONTENT}}</input>
```

### Nesting and Hierarchy

**Logical Information Structure**:

```xml
<analysis_request>
  <data_sources>
    <primary_source>
      <source_type>database</source_type>
      <content>{{DATABASE_EXPORT}}</content>
    </primary_source>
    <secondary_source>
      <source_type>survey</source_type>
      <content>{{SURVEY_RESULTS}}</content>
    </secondary_source>
  </data_sources>

  <analysis_requirements>
    <focus_areas>
      <area>trend_analysis</area>
      <area>correlation_study</area>
    </focus_areas>
    <output_format>executive_summary</output_format>
  </analysis_requirements>
</analysis_request>
```

### Consistency Across Prompts

**Standardize Tag Usage**:

```xml
<!-- Consistent pattern for document analysis -->
<source_document>{{CONTENT}}</source_document>
<analysis_request>{{REQUIREMENTS}}</analysis_request>
<output_format>{{STRUCTURE}}</output_format>

<!-- Use same pattern for similar tasks -->
<reference_document>{{CONTENT}}</reference_document>
<comparison_request>{{REQUIREMENTS}}</comparison_request>
<output_format>{{STRUCTURE}}</output_format>
```

## Common Patterns Reference

### Input Patterns

- `<document>{{CONTENT}}</document>` - Single document
- `<data>{{DATASET}}</data>` - Data for analysis
- `<code>{{SOURCE_CODE}}</code>` - Code for review
- `<query>{{USER_QUESTION}}</query>` - User questions
- `<context>{{BACKGROUND}}</context>` - Background information

### Output Patterns

- `<analysis>{{FINDINGS}}</analysis>` - Analysis results
- `<summary>{{BRIEF_OVERVIEW}}</summary>` - Summaries
- `<recommendations>{{SUGGESTIONS}}</recommendations>` - Action items
- `<explanation>{{REASONING}}</explanation>` - Explanations
- `<examples>{{DEMONSTRATIONS}}</examples>` - Examples

### Structured Output

- `<response>{{FORMATTED_ANSWER}}</response>` - Complete responses
- `<thinking>{{REASONING_PROCESS}}</thinking>` - Reasoning chains
- `<result>{{FINAL_OUTPUT}}</result>` - Final results

## Implementation Tips

### Dynamic Tag Generation

```python
def create_structured_prompt(data_dict, instruction):
    """Generate XML-structured prompt from data dictionary"""
    xml_sections = []

    for key, value in data_dict.items():
        xml_sections.append(f"<{key}>\n{value}\n</{key}>")

    structured_data = "\n\n".join(xml_sections)

    return f"{structured_data}\n\n{instruction}"

# Usage
data = {
    "user_query": "What are the main themes?",
    "document_content": "Long document text...",
    "analysis_requirements": "Identify 3 key themes with evidence"
}

prompt = create_structured_prompt(data, "Analyze and respond in <analysis> tags.")
```

### Validation Helpers

```python
import re

def validate_xml_structure(text):
    """Basic XML tag validation"""
    # Find all opening and closing tags
    opening_tags = re.findall(r'<([^/][^>]*)>', text)
    closing_tags = re.findall(r'</([^>]+)>', text)

    # Check if tags are balanced
    for tag in opening_tags:
        if tag not in closing_tags:
            return False, f"Missing closing tag for: {tag}"

    return True, "XML structure valid"
```

---

_For advanced XML structuring patterns and integration examples, refer to Anthropic's prompt engineering documentation._
