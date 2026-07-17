# Personal Knowledge Platform (PKP)

## Overview

The Personal Knowledge Platform (PKP) is the permanent, authoritative repository for my knowledge, research, architectural decisions, learning, and personal projects.

The PKP is designed to be a long-term, vendor-independent knowledge platform that remains useful regardless of changes in software tools, AI platforms, or technology trends.

Knowledge is stored as plain Markdown files under version control, making it human-readable, AI-readable, portable, and maintainable for decades.

---

## Vision

Build a world-class Personal Knowledge Platform that serves as the single source of truth for all curated knowledge while remaining independent of any specific software vendor or AI platform.

---

## Objectives

* Maintain a single source of truth for personal knowledge.
* Capture knowledge in a structured, maintainable manner.
* Support long-term learning and continuous improvement.
* Enable efficient retrieval of information by both humans and AI systems.
* Preserve complete version history using Git.
* Remain portable across operating systems, editors, and AI tools.

---

## Guiding Principles

The PKP follows these core principles:

* Markdown First
* Git First
* AI First
* Vendor Independent
* Offline First
* Documentation Driven Development
* Single Source of Truth
* Progressive Domain Evolution
* Human Readable
* AI Readable
* Long-term Maintainability

Detailed governance and standards are defined in:

* `Standards/STD-000 — ChatGPT Project Standard.md`

---

## Repository Structure

```text
PKP-Workspace/
│
├── Architecture/
├── Infrastructure/
├── Knowledge/
├── Projects/
├── Resources/
├── Standards/
├── Templates/
│
└── README.md
```

---

## Folder Responsibilities

| Folder         | Purpose                                                                                          |
| -------------- | ------------------------------------------------------------------------------------------------ |
| Architecture   | Architecture documents describing the design and evolution of the PKP.                           |
| Infrastructure | Automation, Git, scripts, backups, AI integrations, and operational assets.                      |
| Knowledge      | Curated knowledge organized into long-term knowledge domains.                                    |
| Projects       | Active and completed projects that produce knowledge and implementations.                        |
| Resources      | External reference material such as books, research papers, articles, videos, and documentation. |
| Standards      | Standards, governance documents, conventions, and policies.                                      |
| Templates      | Reusable document templates and knowledge capture templates.                                     |

---

## Knowledge Philosophy

Resources are not knowledge.

Projects are not knowledge.

Knowledge is curated understanding created through learning, experience, experimentation, and reflection.

The PKP distinguishes between:

* Knowledge
* Resources
* Projects
* Infrastructure

to minimize duplication and improve long-term maintainability.

---

## AI Philosophy

AI systems are assistants—not the source of truth.

The PKP remains the permanent repository.

AI platforms consume knowledge from the PKP and assist with reasoning, learning, writing, analysis, implementation, and decision support.

The architecture is designed to support both cloud-based AI services and locally hosted AI systems.

---

## Workflow

The general workflow is:

1. Learn
2. Research
3. Think
4. Create or update knowledge
5. Review
6. Commit changes to Git
7. Synchronize across devices

---

## Future Evolution

The PKP is expected to evolve continuously.

Architecture, standards, automation, templates, and workflows will be refined over time while preserving compatibility with existing knowledge whenever practical.

New technologies should enhance the platform without compromising its core principles.

---

## Repository Status

This repository is under active development and follows an iterative, architecture-first approach.

All significant architectural decisions are documented before implementation whenever practical.
