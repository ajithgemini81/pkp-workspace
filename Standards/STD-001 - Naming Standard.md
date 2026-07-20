# STD-001 - Naming Standard

## Status

Active

Version: 1.0

Owner: PKP

---

# Purpose

This standard defines the naming conventions for all repository artifacts within the Personal Knowledge Platform (PKP).

Its goals are to:

- Improve consistency
- Reduce ambiguity
- Support discoverability
- Improve Git history readability
- Improve AI retrieval
- Support long-term maintainability

This standard applies to every document, folder, and artifact created within the PKP.

---

# Guiding Principles

Repository names should be:

- Human readable
- AI readable
- Stable
- Descriptive
- Predictable
- Independent of any specific software tool

Avoid abbreviations unless they are widely recognized (e.g., AI, SQL, API, .NET).

---

# Repository Naming Rules

## Folder Names

Folder names shall:

- Use **Title Case**
- Avoid prefixes and numeric identifiers
- Represent a single responsibility
- Avoid unnecessary abbreviations

### Examples

✔

```
Architecture
Knowledge
Resources
Projects
Infrastructure
Templates
Standards
Learning
Software Engineering
Enterprise Architecture
```

✘

```
architecture
software_engineering
SE
Docs
Misc
New Folder
```

---

## Knowledge Articles

Knowledge articles represent concepts rather than managed documents.

Knowledge articles shall:

- Use descriptive concept names
- Use Title Case
- Not include document identifiers

### Examples

✔

```
Deep Work.md

Attention Residue.md

Time Blocking.md

Dependency Injection.md

Entity Framework.md
```

✘

```
KNW-001.md

Notes.md

DeepWork.md

concept1.md

Untitled.md
```

---

## Architecture Documents

Architecture documents shall use the format:

```
ARC-### - Title.md
```

Examples:

```
ARC-000 - PKP Architecture Overview.md

ARC-001 - Knowledge Architecture.md

ARC-002 - Repository Architecture.md
```

Architecture document identifiers are permanent.

Identifiers shall never be reused.

---

## Standards

Standards shall use:

```
STD-### - Title.md
```

Examples:

```
STD-000 - AI Collaboration Standard.md

STD-001 - Naming Standard.md

STD-002 - Markdown Standard.md
```

---

## Templates

Templates shall use:

```
TMP-### - Title.md
```

Examples:

```
TMP-001 - Knowledge Object.md

TMP-002 - Resource Processing Checklist.md
```

---

## Architecture Decision Records

Architecture Decision Records shall use:

```
ADR-#### - Title.md
```

Examples:

```
ADR-0001 - Markdown First.md

ADR-0002 - Resources Are Not Knowledge.md
```

ADR identifiers are sequential and permanent.

---

## Project Documents

Each project owns its own namespace.

Example:

```
PKP-000 - Project Charter.md

SH-000 - Project Charter.md

AI-000 - Project Charter.md
```

The project prefix should be concise and unique.

---

## Resources

Resources are organized by hierarchy rather than document identifiers.

Example:

```
Resources/

Books/

Deep Work/

Book Overview.md

Reading Notes.md

Progress.md
```

The folder identifies the resource.

Files inside follow consistent descriptive names.

---

## Inbox

Inbox content is temporary.

Names may be descriptive but need not follow permanent conventions.

Examples:

```
Idea - Better Review Workflow.md

Conversation - NotebookLM Setup.md

Reading Highlights.md
```

Inbox content should eventually be:

- promoted
- merged
- archived
- deleted

---

# Characters

Use:

- Letters
- Numbers (where required)
- Spaces
- Hyphens
- Parentheses (only when necessary)

Avoid:

```
_

#

@

!

?

%

&
```

unless required by technical constraints.

---

# File Extensions

Preferred formats:

```
.md

.pdf

.png

.jpg

.drawio

.excalidraw
```

Avoid proprietary formats whenever practical.

---

# Capitalization

Use **Title Case** for:

- Folder names
- Document titles

Examples:

```
Deep Work.md

Repository Architecture.md

Enterprise Architecture
```

Do not use:

```
deep work.md

repositoryArchitecture.md

DEEP WORK.md
```

---

# Renaming

Documents may be renamed to improve clarity.

When renaming:

- Preserve links where possible.
- Update references.
- Commit the rename separately if it represents a significant architectural change.

Git history preserves previous names.

---

# Future Naming

As the PKP evolves, additional managed document types may be introduced.

Examples:

```
DEC - Decisions

PAT - Patterns

REF - Reference Guides

EXP - Experiments

RFC - Requests for Comment
```

New prefixes should be standardized before use.

---

# Compliance

All newly created repository artifacts shall follow this standard.

Existing documents may be updated gradually during normal maintenance.

Consistency is preferred over immediate perfection.

---

# Related Documents

- [[README]]
- [[ARC-002 - Repository Architecture]]
- [[STD-000 - AI Collaboration Standard]]