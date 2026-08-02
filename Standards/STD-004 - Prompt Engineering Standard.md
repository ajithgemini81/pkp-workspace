# STD-004 - Prompt Engineering Standard

**Status:** Active  
**Version:** 1.0  
**Owner:** Personal Knowledge Platform (PKP)  
**Location:** `Standards/STD-004 - Prompt Engineering Standard.md`  
**Last Updated:** 02-AUG-2026  

---

## Purpose

This standard operationalizes [[ARC-003 - AI Instruction Architecture]] by establishing mandatory engineering rules for creating, structuring, authoring, reviewing, testing, and governing AI instruction documents within the Personal Knowledge Platform (PKP). 

While [[ARC-003 - AI Instruction Architecture]] defines *what* the AI instruction architecture is (its scope, taxonomy, and state boundaries), this standard defines *how* human contributors and AI tools author and maintain compliant instruction artifacts on disk.

---

## Scope

This standard applies to all textual prompt artifacts, system instructions, mentor instruction sets, notebook instructions, task execution prompts, and prompt templates stored within the canonical PKP repository.

### In Scope
* File naming conventions and `PRM-` prefix rules.
* YAML frontmatter schemas and metadata requirements.
* Canonical document layout and required section structures.
* Instruction writing rules, constraint formatting, and variable templating.
* Input/Output contracts and response formatting specifications.
* Composition patterns and reusable prompt templates.
* Quality review, testing, versioning, and change management procedures.

### Out of Scope
* High-level architectural boundaries and taxonomy definitions (governed by [[ARC-003 - AI Instruction Architecture]]).
* Physical repository folder organization (governed by [[ARC-002 - Repository Architecture]]).
* General Markdown formatting rules (governed by [[STD-002 - Markdown Writing Standard]]).
* Repository naming exception registrations (governed by [[STE-001 - Repository Naming Exceptions]]).

---

## Relationship to Architecture and Governance Foundations

This standard is part of the integrated PKP governance framework and must be interpreted in alignment with the following authoritative documents:

* [[ARC-000 - PKP Architecture Overview]] — High-level platform constraints and vision.
* [[ARC-001 - Knowledge Architecture]] — Core knowledge entities and boundary rules.
* [[ARC-002 - Repository Architecture]] — Component responsibilities and physical repository structure.
* [[ARC-003 - AI Instruction Architecture]] — Theoretical architecture, taxonomy, and lifecycle governing AI instructions.
* [[STD-000 - AI Collaboration Standard]] — Fundamental rules for human-AI interaction.
* [[STD-001 - Naming Standard]] — Core naming rules for managed repository artifacts.
* [[STD-002 - Markdown Writing Standard]] — Mandatory Markdown syntax, heading, and link rules.
* [[STD-003 - Repository Marker Standard]] — Root discovery rules for tools and automation.
* [[STE-001 - Repository Naming Exceptions]] — Register of approved naming deviations.

---

## Guiding Principles

All AI instruction artifacts authored in the PKP shall adhere to six operational prompt engineering principles:

1. **Deterministic Clarity:** Instructions shall use explicit, imperative language. Ambiguity in role, scope, or expected output is considered a defect.
2. **Repository Primacy:** Prompts must treat the local PKP Git repository as the permanent source of truth and the external AI runtime as an ephemeral execution environment.
3. **Vendor-Agnostic Portability:** Prompts shall be written in plain Markdown without reliance on vendor-specific markup, proprietary XML tags, or platform-bound UI assumptions.
4. **Contract-Driven I/O:** Every operational prompt shall explicitly specify input contracts (what data is provided) and output contracts (exact response structure and tone).
5. **Defensive Constraint Design:** Negative constraints ("Do NOT...") shall be paired with affirmative alternatives ("Instead, perform...") to prevent AI hallucination and scope drift.
6. **Zero Hardcoded Paths:** Prompts shall describe architectural responsibilities and logical names rather than absolute local file paths.

---

## Repository Compliance and Naming Rules

### Canonical File Prefix (`PRM-`)

In accordance with [[STD-001 - Naming Standard]] and [[ARC-003 - AI Instruction Architecture]], all standalone instruction documents and managed prompt sets shall use the `PRM-` file prefix followed by a zero-padded three-digit numeric identifier and a descriptive Title Case title.

#### Canonical Format
`PRM-### - Descriptive Title.md`

#### Examples
* `PRM-001 - Generate Knowledge Document.md`
* `PRM-002 - Reading Mentor Concept Explainer Detailed.md`
* `PRM-003 - Reading Mentor Concept Explainer Concise.md`
* `PRM-004 - NotebookLM - Reading Passage Explainer.md`
* `PRM-005 - Smart Home Engineering Mentor.md`

### Logical Classification Codes vs. Physical File Names

Logical classification codes defined in [[ARC-003 - AI Instruction Architecture]] (`SYS`, `MTR`, `CTX`, `WFK`, `TSK`) represent functional categories in metadata and indices. **They shall never be used as file prefixes on disk.**

| Logical Category | Classification Code | Managed File Prefix | Canonical Naming Example |
| :--- | :--- | :--- | :--- |
| **System & Startup** | `SYS` | `PRM-` | `PRM-010 - Session Startup Instruction Set.md` |
| **Mentor & Coach** | `MTR` | `PRM-` | `PRM-005 - Smart Home Engineering Mentor.md` |
| **Notebook & Context** | `CTX` | `PRM-` | `PRM-004 - NotebookLM - Reading Passage Explainer.md` |
| **Workflow & Checklist** | `WFK` | `PRM-` or `TMP-` | `PRM-012 - Resource Processing Workflow.md` |
| **Task & Prompt** | `TSK` | `PRM-` | `PRM-001 - Generate Knowledge Document.md` |

*(Note: Reusable prompt structural templates are governed by the `TMP-` prefix under [[STD-001 - Naming Standard]].)*

---

## Metadata and YAML Frontmatter Requirements

Every `PRM-` artifact shall begin with a compliant YAML frontmatter block enclosed by triple-dashed dividers (`---`). Frontmatter must follow `STD-002` encoding rules (UTF-8, no BOM).

### Mandatory Frontmatter Schema

```yaml
---
title: "PRM-### - Title Matching Filename"
document-type: prompt
logical-category: SYS | MTR | CTX | WFK | TSK
status: Active | Draft | Refinement | Deprecated | Archived
version: "1.0"
owner: PKP
last-reviewed: DD-MMM-YYYY
target-runtimes:
  - Generic Markdown
  - Example Runtime A
  - Example Runtime B
tags:
  - prompt
  - ai-instruction
  - domain-name
---

```

### Schema Field Specifications

* `title`: Must exactly match the document's file name (excluding the `.md` extension).
* `document-type`: Must be set to `prompt`.
* `logical-category`: Must be one of the five authorized logical codes from [[ARC-003 - AI Instruction Architecture]] (`SYS`, `MTR`, `CTX`, `WFK`, `TSK`).
* `status`: Must reflect a valid state from the lifecycle model in [[ARC-003 - AI Instruction Architecture]].
* `version`: Semantic version string enclosed in quotes.
* `owner`: Document owner (default: `PKP`).
* `last-reviewed`: Date formatted strictly as `DD-MMM-YYYY` using Indian Standard Time (IST) convention (e.g., `02-AUG-2026`).
* `target-runtimes`: An optional, non-controlled list of validated AI runtime environments or platforms where the instruction set has been tested (e.g., `Generic Markdown`, `Claude`, `ChatGPT`, `Open WebUI`, `Ollama`). Listed runtimes serve as illustrative examples and compatibility indicators rather than a closed, restricted enumeration.

---

## Standard Prompt Layout and Section Architecture

To ensure consistent execution across diverse LLM tokenizers and human readability, `PRM-` documents shall follow a standardized section hierarchy.

### Required Header Sequence

1. **Title Heading (`# PRM-### - Document Title`):** Level-1 heading.
2. **Metadata Block:** Human-readable status summary below the title.
3. **Identity & Role (`## Identity`):** Defines assistant persona, expertise domain, and authoritative boundary.
4. **Primary Objectives (`## Primary Objectives`):** Ordered list of core goals.
5. **Scope & Context (`## Scope and Context`):** Operational boundary and input grounding assumptions.
6. **Instruction Rules (`## Instructions`):** Step-by-step procedural directives.
7. **Constraints & Guardrails (`## Constraints`):** Strict operational boundaries and negative rules.
8. **Input / Output Contract (`## Input and Output Contract`):** Data payload expectations and response formats.
9. **Response Style (`## Response Style`):** Tone, formatting, and conciseness rules.

---

## Instruction Authoring and Drafting Rules

### Imperative Language Standard

Instructions must be written in second-person direct imperative phrasing. Avoid passive voice, conversational filler, or indirect suggestions.

* **Non-Compliant:** "You should try to summarize the document if you can."
* **Compliant:** "Summarize the input document into three bullet points. Do not exceed 150 words."

### Negative Constraint Pairing Pattern

When instructing an AI runtime to avoid a behavior, always provide the explicit replacement behavior immediately following the constraint.

```markdown
Do NOT invent facts, citations, or domain relationships beyond the provided source text.
Instead, if a requested fact is absent from the source, explicitly state: "Information not present in source."

```

### Context Management and Variable Placeholders

Prompts requiring runtime inputs from human users or automation scripts shall use double angle-bracket variable placeholders: `<Variable_Name>`.

#### Standard Placeholder Catalog

* `<Input_Text>` — Raw source text provided for processing.
* `<Target_Domain>` — Destination knowledge domain (e.g., `.NET Architecture`, `Smart Home`).
* `<User_Objective>` — Goal statement for the active chat session.
* `<Current_Date>` — IST formatted date string (`DD-MMM-YYYY`).

```markdown
Transform the following input text:
<Input_Text>

Format the output for integration into the <Target_Domain> domain.

```

---

## Input / Output Contracts and Response Formatting

### Input Payload Contracts

Operational prompts must define the expected payload type:

* **Plain Text Payload:** Unstructured text or passage excerpts.
* **Structured Markdown Payload:** Managed documents with frontmatter or backlink references.
* **Repository Package Payload:** Manifests or Context Packs generated by platform automation.

### Output Formatting Contracts

Prompts shall mandate standard Markdown constructs compliant with [[STD-002 - Markdown Writing Standard]]:

* Use ATX headings (`#`, `##`, `###`). Do not skip heading levels.
* Mandate Obsidian wiki-links (`[[Concept Name]]`) for all internal PKP entity references.
* Enforce code block language identifiers (e.g., `csharp `, `powershell `).
* Prohibit raw HTML tags unless required for specific Markdown tables.

---

## Composition Patterns and Reusable Templates

### Standard Reusable Prompt Template

The following reusable template illustrates the canonical structure for all newly created `PRM-` artifacts:

```markdown
---
title: "PRM-### - Standard Task Prompt Title"
document-type: prompt
logical-category: TSK
status: Active
version: "1.0"
owner: PKP
last-reviewed: 02-AUG-2026
target-runtimes:
  - Generic Markdown
tags:
  - prompt
  - task
---

# PRM-### - Standard Task Prompt Title

**Status:** Active | **Version:** 1.0 | **Owner:** PKP | **Last Reviewed:** 02-AUG-2026

---

## Identity
You are an expert <Role Title> specializing in <Domain Expertise>. Your mission is to <Core Purpose Statement>.

## Primary Objectives
1. <Objective 1 in order of priority>
2. <Objective 2>
3. <Objective 3>

## Scope and Context
This instruction set governs <Target Task / Operational Scope>. Treat the provided input as <Primary Source / Ephemeral Input>.

## Instructions
1. Analyze the input payload provided under `<Input_Text>`.
2. Extract core concepts, structural relationships, and key insights.
3. Transform the extracted concepts into the structured output contract defined below.

## Constraints
* Do NOT <Prohibited Action 1>. Instead, <Corrective Action 1>.
* Do NOT <Prohibited Action 2>.
* Do NOT hardcode file system paths. Refer to repository components by logical responsibility per [[ARC-002 - Repository Architecture]].

## Input and Output Contract

### Input Contract
The prompt expects a text payload in the following format:
```markdown
<Input_Text>
```

### Output Contract
The response MUST follow this exact structure:

```markdown
### Summary
<Concise 2-3 sentence overview>

### Key Concepts
* **[[Concept 1]]**: <Explanation>
* **[[Concept 2]]**: <Explanation>

### Actionable Insights
1. <Insight 1>
2. <Insight 2>
```

## Response Style
* **Tone:** Professional, objective, and analytical.
* **Formatting:** Clean GitHub-flavored Markdown compliant with [[STD-002 - Markdown Writing Standard]].
* **Conciseness:** Prefer precise, dense statements over conversational filler.

```

---

## Versioning, Review, and Quality Management

### Semantic Versioning Rules

Prompt documents follow standard two-digit semantic versioning:

* **Major Version Update (e.g., 1.0 $\rightarrow$ 2.0):** Architectural restructuring of the prompt, changing input/output contracts, or fundamentally altering role personas.
* **Minor Version Update (e.g., 1.0 $\rightarrow$ 1.1):** Refining instructions, adding negative constraints, clarifying examples, or improving tone without breaking output contracts.

### Review and Validation Checklist

Before promoting a `PRM-` document from `Draft` or `Refinement` to `Active`, it must pass this validation checklist:

* [ ] **Naming:** Filename matches `PRM-### - Title.md` (`STD-001`).
* [ ] **Frontmatter:** Mandatory YAML block present, valid IST date, valid logical code (`STD-004`).
* [ ] **Markdown Compliance:** Headers use ATX syntax; wiki-links use `[[Document]]` (`STD-002`).
* [ ] **Scope Alignment:** Bounded strictly to instruction directives without including unbuilt asset definitions (`ARC-003`).
* [ ] **Constraint Pairing:** All negative rules ("Do NOT") are paired with positive alternatives (`STD-004`).
* [ ] **Vendor Neutrality:** Prompts contain no vendor-specific lock-in or proprietary markup (`ARC-000`, `ARC-003`).
* [ ] **Execution Testing:** Prompt validated against one or more intended target runtimes appropriate for the prompt's purpose.

---

## Common Anti-Patterns to Avoid

| Anti-Pattern | Why It Is Defective | Compliant Correction |
| --- | --- | --- |
| **Vendor Syntax Coupling** | Using `< | im_start |
| **Hardcoded Folder Paths** | Paths like `C:\PKP\Infrastructure\AI` break when syncing across hosts. | Reference logical areas: "stored in the canonical AI instruction area as defined by [[ARC-002 - Repository Architecture]]". |
| **Conversational Prompts** | Phrases like "Please try your best to..." weaken LLM constraint adherence. | Use direct imperative commands: "Perform X. Ensure Y." |
| **Unpaired Negative Rules** | Telling LLMs "Do NOT do X" without an alternative causes unpredictability. | Pair negative rules: "Do NOT do X. Instead, perform Y." |
| **Logical Prefix as Filename** | Naming a file `SYS-001 - Startup.md` violates managed prefix standards. | Use `PRM-` for all instruction files: `PRM-001 - Session Startup Instruction Set.md`. |

---

## Production Examples

The following active repository prompt documents serve as authoritative operational implementations of this standard:

* `[[PRM-001 - Generate Knowledge Document]]` — Task prompt governing knowledge object extraction from raw input text.
* `[[PRM-002 - Reading Mentor Concept Explainer Detailed]]` — Mentor prompt governing deep concept breakdowns for technical literature.
* `[[PRM-003 - Reading Mentor Concept Explainer Concise]]` — Lightweight companion prompt for fast reading workflows.
* `[[PRM-004 - NotebookLM - Reading Passage Explainer]]` — Specialized passage explainer optimized for multi-document notebook environments.
* `[[PRM-005 - Smart Home Engineering Mentor]]` — Specialized engineering persona governing local home automation architecture.

---

## Related Documents

* [[README]]
* [[PKP-000 - Project Charter]]
* [[PKP-001 - AI Collaboration Guide]]
* [[ARC-000 - PKP Architecture Overview]]
* [[ARC-001 - Knowledge Architecture]]
* [[ARC-002 - Repository Architecture]]
* [[ARC-003 - AI Instruction Architecture]]
* [[STD-000 - AI Collaboration Standard]]
* [[STD-001 - Naming Standard]]
* [[STD-002 - Markdown Writing Standard]]
* [[STD-003 - Repository Marker Standard]]
* [[STE-001 - Repository Naming Exceptions]]

---

## Document Summary & Audit Trail

| Date | Version | Summary of Changes | Author |
| --- | --- | --- | --- |
| **02-AUG-2026** | **1.0** | Initial publication of STD-004 - Prompt Engineering Standard. Operationalizes ARC-003 by defining mandatory frontmatter schemas, PRM- prefix usage, section hierarchy, imperative authoring rules, constraint pairing, I/O contract design, and validation checklists. Refined target-runtimes as an optional open-ended list, relaxed validation testing to one or more intended runtimes, and removed forward template references. | Personal Knowledge Platform (PKP) |

```

```