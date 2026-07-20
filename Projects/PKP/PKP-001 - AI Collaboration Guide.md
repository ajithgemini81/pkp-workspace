# PKP-001 - AI Collaboration Guide

## Status

Active

Version: 1.0

Owner: PKP

---

# Purpose

This document provides the operational guidance required for any AI assistant to collaborate effectively on the Personal Knowledge Platform (PKP).

It enables work to continue across different AI services, new chat sessions, and future AI systems without relying on previous conversation history.

The PKP-not any individual AI conversation-is the permanent source of truth.

---

# Objectives

This guide enables an AI assistant to:

- Understand the purpose of the PKP.
- Quickly become familiar with the repository.
- Follow the established architecture and standards.
- Continue work from the current state of the project.
- Minimize repeated explanations from the repository owner.
- Maintain consistency across AI platforms.

---

# Fundamental Principles

Always remember:

- The PKP is the permanent knowledge repository.
- AI conversations are temporary working sessions.
- Knowledge belongs to the repository owner.
- AI assists with reasoning, analysis, learning, and documentation.
- Human review is required before permanent knowledge is added to the PKP.

---

# AI Responsibilities

An AI assistant should:

- Understand the existing architecture before suggesting changes.
- Follow established standards.
- Prefer improving existing knowledge over creating duplicates.
- Explain trade-offs before making recommendations.
- Distinguish between Knowledge, Resources, Projects, and Infrastructure.
- Think long-term rather than optimizing for short-term convenience.

---

# Repository Onboarding

Before contributing, review the following documents in order:

1. `README.md`
2. `Projects/PKP/PKP-000 - Project Charter.md`
3. `Architecture/ARC-000 - PKP Architecture Overview.md`
4. `Standards/STD-000 - AI Collaboration Standard.md`
5. Relevant Architecture documents
6. Relevant Standards
7. Relevant Knowledge or Project documents

Do not assume previous chat history is available.

The repository is the authoritative source of context.

---

# Working Workflow

Follow this workflow whenever collaborating:

```text
Question

↓

Discussion

↓

Architecture Review

↓

Decision

↓

Human Approval

↓

PKP Update

↓

Git Commit

↓

Continue
```

Never bypass the human review step.

---

# Session Continuity

Every conversation should assume that it may be the first interaction with the project.

If previous conversations are unavailable:

- Read the repository.
- Understand the current architecture.
- Review the current project status.
- Continue from the documented state.

Do not request unnecessary historical conversation context if the repository already contains the required information.

---

# Current Project Snapshot

Update this section whenever a major milestone is completed.

Current Phase:

Foundation

Current Focus:

Building the PKP architecture and governance.

Current Milestone:

Establish foundational architecture, standards, and templates.

Next Milestone:

Knowledge Engineering.

---

# AI Platform Independence

This guide is intentionally vendor independent.

It should be applicable to:

- ChatGPT
- Gemini
- Claude
- NotebookLM
- Open WebUI
- Ollama
- Local LLMs
- Future AI systems

No AI platform should become the source of truth.

---

# Knowledge Philosophy

Resources are consumed.

Knowledge is curated.

Projects implement knowledge.

Infrastructure supports the platform.

Keep these concepts distinct.

---

# Communication Style

Prefer:

- Clear explanations
- Architectural reasoning
- Practical implementation
- Incremental improvement

Avoid:

- Unnecessary complexity
- Duplicate documentation
- Premature optimization
- Vendor-specific assumptions

---

# Session Review

At the end of significant collaboration sessions, provide a concise review including:

- Architectural decisions made
- Documents created or updated
- Open questions
- Recommended Git actions
- Next milestone

The session review is temporary.

The PKP remains the permanent record.

---

# Related Documents

- [[README]]
- [[PKP-000 - Project Charter]]
- [[ARC-000 - PKP Architecture Overview]]
- [[STD-000 - AI Collaboration Standard]]
- [[STD-001 - Naming Standard]]
- [[STD-002 - Markdown Writing Standard]]