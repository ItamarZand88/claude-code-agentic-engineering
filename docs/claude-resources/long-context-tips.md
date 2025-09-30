# Long Context Tips

_Maximizing effectiveness with Claude's extended context windows_

## Overview

Claude's extended context capabilities allow for processing large documents, maintaining long conversations, and analyzing complex multi-document scenarios. This guide covers strategies for optimizing long-context usage.

## Understanding Context Windows

### Available Context Sizes

**Standard Models**:

- Claude Sonnet: 200K tokens
- Claude Opus: 200K tokens
- Claude Haiku: 200K tokens

**Extended Context (1M Tokens)**:

- Claude Sonnet 4: 1M tokens with beta flag
- Claude Sonnet 4.5: 1M tokens with beta flag

### Enabling 1M Context Window

**Python Implementation**:

```python
from anthropic import Anthropic

client = Anthropic()

response = client.beta.messages.create(
    model="claude-sonnet-4-5",
    max_tokens=1024,
    messages=[
        {"role": "user", "content": "Process this large document..."}
    ],
    betas=["context-1m-2025-08-07"]
)
```

**TypeScript Implementation**:

```typescript
import Anthropic from "@anthropic-ai/sdk";

const anthropic = new Anthropic();

const msg = await anthropic.beta.messages.create({
  model: "claude-sonnet-4-5",
  max_tokens: 1024,
  messages: [{ role: "user", content: "Process this large document..." }],
  betas: ["context-1m-2025-08-07"],
});
```

**cURL Implementation**:

```bash
curl https://api.anthropic.com/v1/messages \
    -H "x-api-key: $ANTHROPIC_API_KEY" \
    -H "anthropic-version: 2023-06-01" \
    -H "anthropic-beta: context-1m-2025-08-07" \
    -H "content-type: application/json" \
    -d '{
      "model": "claude-sonnet-4-5",
      "max_tokens": 1024,
      "messages": [
        {"role": "user", "content": "Process this large document..."}
      ]
    }'
```

## Multi-Document Structure Strategies

### Hierarchical Document Organization

**Best Practice Pattern**:

```xml
<documents>
  <document index="1">
    <source>annual_report_2023.pdf</source>
    <document_content>
      {{ANNUAL_REPORT_CONTENT}}
    </document_content>
  </document>
  <document index="2">
    <source>competitor_analysis_q2.xlsx</source>
    <document_content>
      {{COMPETITOR_ANALYSIS_CONTENT}}
    </document_content>
  </document>
  <document index="3">
    <source>market_trends_report.docx</source>
    <document_content>
      {{MARKET_TRENDS_CONTENT}}
    </document_content>
  </document>
</documents>

Analyze the annual report and competitor analysis. Identify strategic advantages and recommend Q3 focus areas based on market trends.
```

### Document Metadata Integration

**Enhanced Document Structure**:

```xml
<documents>
  <document index="1">
    <metadata>
      <source>financial_report_2023.pdf</source>
      <date_created>2023-12-31</date_created>
      <document_type>financial_statement</document_type>
      <page_count>45</page_count>
      <relevance_score>high</relevance_score>
    </metadata>
    <document_content>
      {{FINANCIAL_REPORT_CONTENT}}
    </document_content>
  </document>
  <document index="2">
    <metadata>
      <source>board_meeting_minutes.docx</source>
      <date_created>2024-01-15</date_created>
      <document_type>meeting_minutes</document_type>
      <attendees>7</attendees>
      <relevance_score>medium</relevance_score>
    </metadata>
    <document_content>
      {{MEETING_MINUTES_CONTENT}}
    </document_content>
  </document>
</documents>
```

## Grounding and Citation Techniques

### Quote-Based Response Grounding

**Pattern for Accuracy**:

```xml
<documents>
  <document index="1">
    <source>patient_symptoms.txt</source>
    <document_content>
      {{PATIENT_SYMPTOMS}}
    </document_content>
  </document>
  <document index="2">
    <source>patient_records.txt</source>
    <document_content>
      {{PATIENT_RECORDS}}
    </document_content>
  </document>
  <document index="3">
    <source>patient01_appt_history.txt</source>
    <document_content>
      {{APPOINTMENT_HISTORY}}
    </document_content>
  </document>
</documents>

Find quotes from the patient records and appointment history that are relevant to diagnosing the patient's reported symptoms. Place these in <quotes> tags. Then, based on these quotes, list all information that would help the doctor diagnose the patient's symptoms. Place your diagnostic information in <info> tags.
```

### Structured Citation Format

**Response Template**:

```text
<quotes>
[1] "Patient reports experiencing chest pain during physical exertion" (patient_symptoms.txt)
[2] "Previous EKG from 2022 showed normal sinus rhythm" (patient_records.txt)
[3] "Last appointment noted elevated blood pressure" (patient01_appt_history.txt)
</quotes>

<info>
Based on the provided information:
- Current symptoms suggest possible cardiac involvement [1]
- Previous cardiac testing was normal [2]
- Hypertension may be a contributing factor [3]

Recommended next steps:
- Stress test to evaluate exercise-induced symptoms
- Updated cardiovascular assessment
- Blood pressure monitoring
</info>
```

## Long Context Optimization

### Information Architecture

**Hierarchical Information Structure**:

```xml
<analysis_context>
  <primary_documents>
    <document priority="critical">
      <title>Core Business Strategy</title>
      <content>{{STRATEGY_DOC}}</content>
    </document>
    <document priority="critical">
      <title>Financial Performance</title>
      <content>{{FINANCIAL_DATA}}</content>
    </document>
  </primary_documents>

  <supporting_documents>
    <document priority="medium">
      <title>Market Research</title>
      <content>{{MARKET_RESEARCH}}</content>
    </document>
    <document priority="low">
      <title>Historical Context</title>
      <content>{{BACKGROUND_INFO}}</content>
    </document>
  </supporting_documents>

  <reference_materials>
    <glossary>{{TERMS_AND_DEFINITIONS}}</glossary>
    <methodology>{{ANALYSIS_FRAMEWORK}}</methodology>
  </reference_materials>
</analysis_context>
```

### Context Chunking Strategies

**Logical Section Division**:

```xml
<large_document>
  <section id="executive_summary">
    <title>Executive Summary</title>
    <content>{{SUMMARY_CONTENT}}</content>
  </section>

  <section id="methodology">
    <title>Research Methodology</title>
    <content>{{METHODOLOGY_CONTENT}}</content>
  </section>

  <section id="findings">
    <title>Key Findings</title>
    <subsection id="quantitative_results">
      <content>{{QUANT_RESULTS}}</content>
    </subsection>
    <subsection id="qualitative_insights">
      <content>{{QUAL_INSIGHTS}}</content>
    </subsection>
  </section>

  <section id="recommendations">
    <title>Strategic Recommendations</title>
    <content>{{RECOMMENDATIONS_CONTENT}}</content>
  </section>
</large_document>

Focus your analysis on sections "findings" and "recommendations" while considering the context from other sections.
```

## Conversation Management

### Long Conversation Context

**Conversation History Structure**:

```xml
<conversation_context>
  <session_metadata>
    <start_time>2024-01-15T10:00:00Z</start_time>
    <topic>quarterly_business_review</topic>
    <participants>user, claude</participants>
  </session_metadata>

  <conversation_summary>
    We've been discussing Q4 performance metrics, identifying key growth areas, and planning Q1 initiatives. Key decisions made include budget allocation for marketing and timeline for product launch.
  </conversation_summary>

  <recent_exchanges>
    <exchange id="1">
      <user>What were our top 3 performing products last quarter?</user>
      <claude>Based on the data: Product A (35% growth), Product B (28% growth), Product C (22% growth)</claude>
    </exchange>
    <exchange id="2">
      <user>How should we allocate marketing budget across these products?</user>
      <claude>Recommended allocation: Product A (45%), Product B (35%), Product C (20%) based on growth potential and market size</claude>
    </exchange>
  </recent_exchanges>

  <current_question>
    Given this allocation strategy, what specific marketing channels should we prioritize for each product?
  </current_question>
</conversation_context>
```

### Context Compression Techniques

**Selective Context Preservation**:

```python
def compress_conversation_context(full_history, max_tokens=150000):
    """Compress conversation while preserving key information"""

    # Always preserve recent exchanges
    recent_context = full_history[-10:]

    # Extract key decisions and outcomes
    key_decisions = extract_decisions(full_history)

    # Summarize middle sections
    middle_summary = summarize_exchanges(full_history[10:-10])

    # Create compressed context
    compressed = {
        "recent_exchanges": recent_context,
        "key_decisions": key_decisions,
        "session_summary": middle_summary
    }

    return format_compressed_context(compressed)
```

## Search Results Integration

### External Information Integration

**Search Results Structure**:

```python
from anthropic import MessageParam, SearchResultBlockParam, TextBlockParam

messages = [
    MessageParam(
        role="user",
        content=[
            SearchResultBlockParam(
                type="search_result",
                source="https://docs.company.com/overview",
                title="Product Overview",
                content=[
                    TextBlockParam(type="text", text="Our product helps teams collaborate...")
                ],
                citations={"enabled": True}
            ),
            SearchResultBlockParam(
                type="search_result",
                source="https://support.company.com/pricing",
                title="Pricing Information",
                content=[
                    TextBlockParam(type="text", text="Pricing tiers start at $10/month...")
                ],
                citations={"enabled": True}
            ),
            TextBlockParam(
                type="text",
                text="Based on these search results, explain the product and pricing structure"
            )
        ]
    )
]
```

## Performance and Pricing Considerations

### Long Context Pricing

**Pricing Tiers (Claude Sonnet 4/4.5)**:

| Token Count   | Input Rate | Output Rate |
| ------------- | ---------- | ----------- |
| ≤ 200K tokens | $3/MTok    | $15/MTok    |
| > 200K tokens | $6/MTok    | $22.50/MTok |

**Cost Optimization Strategies**:

1. **Selective Context**: Include only relevant documents
2. **Document Summarization**: Compress non-critical sections
3. **Batch Processing**: Group related queries
4. **Context Reuse**: Leverage similar document sets

### Performance Monitoring

**Usage Tracking**:

```python
def analyze_context_usage(api_response):
    """Analyze context window usage and costs"""
    usage = api_response.usage

    total_input_tokens = (
        usage.input_tokens +
        usage.get('cache_creation_input_tokens', 0) +
        usage.get('cache_read_input_tokens', 0)
    )

    is_long_context = total_input_tokens > 200000
    pricing_tier = "premium" if is_long_context else "standard"

    return {
        'total_input_tokens': total_input_tokens,
        'output_tokens': usage.output_tokens,
        'pricing_tier': pricing_tier,
        'estimated_cost': calculate_cost(usage, pricing_tier)
    }
```

## Advanced Long Context Patterns

### Iterative Document Analysis

**Progressive Analysis Pattern**:

```xml
<analysis_framework>
  <phase_1>
    <focus>Document overview and structure</focus>
    <documents>{{CORE_DOCUMENTS}}</documents>
    <output>High-level themes and organization</output>
  </phase_1>

  <phase_2>
    <focus>Detailed content analysis</focus>
    <documents>{{ALL_DOCUMENTS}}</documents>
    <input_from_phase_1>{{THEMES_AND_STRUCTURE}}</input_from_phase_1>
    <output>Specific insights and evidence</output>
  </phase_2>

  <phase_3>
    <focus>Synthesis and recommendations</focus>
    <input_from_previous_phases>{{ACCUMULATED_INSIGHTS}}</input_from_previous_phases>
    <output>Strategic recommendations with supporting evidence</output>
  </phase_3>
</analysis_framework>
```

### Cross-Document Reference Mapping

**Reference Tracking Pattern**:

```xml
<document_analysis>
  <primary_document id="doc_1">
    <source>strategic_plan.pdf</source>
    <content>{{STRATEGIC_PLAN}}</content>
    <key_concepts>
      <concept id="growth_targets">Revenue growth of 25% annually</concept>
      <concept id="market_expansion">Enter 3 new geographical markets</concept>
    </key_concepts>
  </primary_document>

  <supporting_document id="doc_2">
    <source>market_research.docx</source>
    <content>{{MARKET_RESEARCH}}</content>
    <references_to_primary>
      <reference concept_id="growth_targets">Market size supports 30% growth potential</reference>
      <reference concept_id="market_expansion">Identified 5 viable new markets</reference>
    </references_to_primary>
  </supporting_document>
</document_analysis>

Analyze the strategic plan against market research findings and identify alignment or conflicts between the documents.
```

## Best Practices Summary

1. **Structure First**: Always use clear XML hierarchies for multi-document scenarios
2. **Ground Responses**: Use quotes and citations for accuracy
3. **Manage Costs**: Monitor token usage and optimize for pricing tiers
4. **Context Hierarchy**: Prioritize information by relevance and importance
5. **Progressive Analysis**: Break complex analyses into phases
6. **Reference Tracking**: Maintain clear connections between related information
7. **Conversation Management**: Preserve key context while compressing non-essential details
8. **Performance Monitoring**: Track usage patterns and optimize accordingly

---

_For technical implementation details and API specifications, refer to Anthropic's Context Windows documentation._
