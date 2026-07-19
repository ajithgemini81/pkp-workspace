# ARC-002 — Repository Architecture

## Status

Active

Version: 0.1

---

# Purpose

This document defines the architectural organization of the Personal Knowledge Platform (PKP) repository.

It describes the responsibilities, boundaries, and relationships of each top-level repository component.

The objective is to ensure that information is stored consistently, responsibilities remain clearly separated, and the repository can evolve without unnecessary restructuring.

---

# Scope

This document defines:

- Top-level repository structure
- Responsibilities of repository components
- Repository boundaries
- Relationships between components
- Repository evolution principles

This document does not define:

- Naming conventions
- Templates
- Metadata
- File formats
- Knowledge entities

Those topics are defined by separate architecture and standards documents.

---

# Repository Philosophy

The repository is organized according to responsibility rather than topic.

Every top-level folder has exactly one primary responsibility.

This minimizes duplication, improves discoverability, and supports long-term maintainability.

---

# High-Level Repository Structure

```text
PKP-Workspace/
│
├── Architecture/
├── Inbox/
├── Infrastructure/
├── Knowledge/
├── Projects/
├── Resources/
├── Standards/
├── Templates/
│
└── README.md
```

Each component represents a distinct architectural responsibility.

---

# Repository Components

## Architecture

### Purpose

Documents describing the architecture of the PKP itself.

### Contains

- Architecture documents
- Architecture diagrams
- Future Architecture Decision Records (ADRs)

### Does Not Contain

- Knowledge articles
- Project documentation
- External resources

### Relationships

Architecture guides every other repository component.

---

## Knowledge

### Purpose

Permanent curated understanding.

### Contains

- Concepts
- Principles
- Techniques
- Mental models
- Frameworks
- Checklists
- Reference knowledge

### Does Not Contain

- Raw notes
- Books
- PDFs
- Temporary thoughts

### Relationships

Knowledge is produced from Resources and Experience and consumed by Projects.

---

## Resources

### Purpose

External learning material.

### Contains

- Books
- Documentation
- Research papers
- Articles
- Videos
- Courses

### Does Not Contain

- Permanent knowledge
- Personal insights
- Project documentation

### Relationships

Resources are transformed into Knowledge through deliberate processing.

---

## Projects

### Purpose

Practical implementation.

### Contains

- Software projects
- Research initiatives
- Experiments
- Engineering work
- Project documentation

### Does Not Contain

- General knowledge
- Repository standards
- External resources

### Relationships

Projects consume Knowledge and generate Experience.

---

## Infrastructure

### Purpose

Supporting systems required to operate the PKP.

### Contains

- Git configuration
- Automation
- AI integration
- Scripts
- Backup strategies
- Tooling documentation

### Does Not Contain

- Knowledge
- Learning resources
- Project documentation

### Relationships

Infrastructure supports the entire repository.

---

## Standards

### Purpose

Repository governance.

### Contains

- Standards
- Naming conventions
- Formatting rules
- Repository policies

### Does Not Contain

- Knowledge
- Projects
- Architecture

### Relationships

Standards ensure consistency across every repository component.

---

## Templates

### Purpose

Reusable document structures.

### Contains

- Knowledge templates
- Project templates
- Architecture templates
- Resource templates

### Does Not Contain

- Actual knowledge
- Projects
- Standards

### Relationships

Templates improve consistency across the repository.

---

## Inbox

### Purpose

Temporary capture area.

### Contains

- Reading notes
- AI conversations
- Ideas
- Highlights
- Questions
- Draft material

### Does Not Contain

- Permanent knowledge
- Long-term storage

### Relationships

Inbox items should eventually be:

- Converted into Knowledge
- Added to Projects
- Linked to Resources
- Deleted

The Inbox should remain temporary.

---

# Repository Relationships

The repository operates as a connected system.

```text
Resources
        │
        ▼
Inbox
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

Architecture, Standards, Templates, and Infrastructure support every stage of this lifecycle.

---

# Repository Constraints

The repository must:

- remain portable
- remain editor-independent
- remain AI-independent
- remain understandable
- remain scalable
- avoid duplication
- preserve history through Git

---

# Repository Evolution

The repository is expected to evolve through practical use.

Future enhancements may include:

- Additional knowledge domains
- AI automation
- Metadata standards
- Knowledge review workflows
- ADRs
- Local AI integration
- Advanced search capabilities

Structural changes should preserve the architectural principles defined by the PKP.

---

# Related Documents

- [[README]]
- [[PKP-000 — Project Charter]]
- [[ARC-000 — PKP Architecture Overview]]
- [[ARC-001 — Knowledge Architecture]]
- [[STD-000 — AI Collaboration Standard]]