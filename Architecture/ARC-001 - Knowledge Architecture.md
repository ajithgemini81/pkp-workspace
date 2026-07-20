# ARC-001 - Knowledge Architecture

## Status

Active

Version: 0.1

---

# Purpose

This document defines the knowledge architecture of the Personal Knowledge Platform (PKP).

It establishes the fundamental knowledge entities managed by the platform, their responsibilities, and the relationships between them.

The objective is to ensure that knowledge is organized consistently, evolves predictably, and remains understandable to both humans and AI systems over decades.

This document serves as the architectural foundation for all knowledge stored within the PKP.

---

# Scope

This document defines:

- Knowledge entities
- Responsibilities of each entity
- Relationships between entities
- Knowledge boundaries
- Knowledge evolution principles

This document does not define:

- Folder structures
- File naming conventions
- Templates
- Metadata
- Workflows

Those topics are covered by other architecture and standards documents.

---

# Architectural Philosophy

The PKP distinguishes between information, knowledge, implementation, and supporting infrastructure.

Not everything collected deserves to become permanent knowledge.

Knowledge is intentionally curated.

Every entity within the PKP exists for a specific purpose.

---

# Core Knowledge Entities

The PKP is composed of four primary knowledge entities.

```text
Resources
        │
        ▼
Knowledge
        │
        ▼
Projects
        │
        ▼
Experience
        │
        ▼
Knowledge Improvement
```

Supporting these entities are:

- Architecture
- Standards
- Templates
- Infrastructure
- Inbox

Together they form the complete knowledge ecosystem.

---

# Resources

## Definition

Resources are external sources of information.

Resources provide input for learning but are not considered knowledge.

## Examples

- Books
- Research papers
- Documentation
- Articles
- Videos
- Courses
- Podcasts
- Manuals

## Purpose

Resources exist to provide ideas, facts, and perspectives that may later be transformed into knowledge.

---

# Knowledge

## Definition

Knowledge is curated understanding created through learning, experience, experimentation, and reflection.

Knowledge represents ideas that have been processed, understood, and expressed in the user's own words.

Knowledge is considered the primary asset of the PKP.

## Characteristics

Knowledge should be:

- Accurate
- Practical
- Reusable
- Well-connected
- Continuously refined

Knowledge is never copied directly from external sources.

---

# Projects

## Definition

Projects are practical implementations that apply knowledge to achieve specific outcomes.

Projects consume knowledge and often generate new knowledge through experience.

## Examples

- Software development
- AI experiments
- Home Assistant implementations
- Research initiatives
- Personal engineering projects

Projects are temporary.

The knowledge they generate is permanent.

---

# Infrastructure

## Definition

Infrastructure consists of the systems that support the PKP but are not themselves knowledge.

## Examples

- Git
- Automation
- AI integrations
- Scripts
- Backup
- Repository configuration

Infrastructure enables knowledge management without becoming part of the knowledge itself.

---

# Supporting Architectural Components

## Architecture

Architecture documents describe how the PKP is designed.

They define structure, responsibilities, and long-term direction.

---

## Standards

Standards define the rules that ensure consistency across the PKP.

Examples include naming conventions, formatting, metadata, and linking standards.

---

## Templates

Templates provide reusable document structures.

Templates improve consistency while reducing repetitive work.

---

## Inbox

The Inbox is a temporary processing area.

It exists to capture information before it has been evaluated.

Items should either be:

- Processed into Knowledge
- Moved into Projects
- Added to Resources
- Deleted

The Inbox should never become permanent storage.

---

# Knowledge Transformation

Knowledge is created through deliberate processing.

```text
External Resource
        │
        ▼
Capture
        │
        ▼
Inbox
        │
        ▼
Review
        │
        ▼
Knowledge
        │
        ▼
Implementation
        │
        ▼
Experience
        │
        ▼
Knowledge Refinement
```

The objective is continuous improvement rather than continuous accumulation.

---

# Relationships Between Entities

The primary relationships are:

- Resources inform Knowledge.
- Knowledge guides Projects.
- Projects generate Experience.
- Experience improves Knowledge.
- Infrastructure supports every stage.
- Architecture governs the platform.
- Standards ensure consistency.
- Templates improve efficiency.

No entity exists in isolation.

---

# Knowledge Boundaries

The PKP distinguishes clearly between the following concepts:

| Entity | Description |
|---------|-------------|
| Resources | External information |
| Knowledge | Curated understanding |
| Projects | Practical implementation |
| Infrastructure | Supporting systems |

Maintaining these boundaries prevents duplication, confusion, and unnecessary complexity.

---

# Architectural Constraints

The knowledge architecture must:

- remain vendor-independent
- remain editor-independent
- remain AI-independent
- support long-term evolution
- minimize duplication
- encourage refinement over accumulation
- remain understandable to humans
- remain interpretable by AI systems

---

# Future Evolution

The knowledge architecture is expected to evolve incrementally.

Future enhancements may include:

- Knowledge taxonomy
- Metadata architecture
- Relationship types
- Knowledge maturity levels
- Review lifecycle
- AI-assisted knowledge validation
- Retrieval-Augmented Generation (RAG)

Future enhancements should preserve the architectural principles defined in this document.

---

# Related Documents

- [[README]]
- [[PKP-000 - Project Charter]]
- [[ARC-000 - PKP Architecture Overview]]
- [[STD-000 - AI Collaboration Standard]]