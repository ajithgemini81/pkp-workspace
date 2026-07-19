# STD-002 — Markdown Writing Standard

## Status

Active

Version: 1.0

Owner: PKP

---

# Purpose

This standard defines how Markdown documents are written within the Personal Knowledge Platform (PKP).

Its objectives are to:

- Maintain consistency across the repository.
- Improve readability for humans.
- Improve parsing by AI systems.
- Minimize formatting ambiguity.
- Ensure long-term portability.

This standard applies to all Markdown documents unless a document-specific template defines otherwise.

---

# Scope

This standard applies to:

- Architecture documents
- Standards
- Knowledge articles
- Project documentation
- Templates
- Resource documentation
- Repository documentation

This standard does not define:

- Naming conventions
- Repository structure
- Knowledge content

These topics are defined by other standards and architecture documents.

---

# Guiding Principles

Markdown documents should be:

- Simple
- Consistent
- Readable
- Portable
- Tool-independent

Prefer clarity over clever formatting.

Avoid using Markdown features solely because they are available.

---

# Document Structure

Documents should present information from general to specific.

A recommended hierarchy is:

- Title
- Purpose
- Main Sections
- Supporting Details
- Related Documents

Document templates may define additional sections where appropriate.

Example:

```markdown
# Title

## Purpose

---

# Main Section

## Subsection

### Details
```

Avoid skipping heading levels.

Example:

✔

```
#

##

###
```

✘

```
#

####

##
```

---

# Headings

Use ATX-style headings.

Example:

```markdown
# Title

## Section

### Subsection
```

Do not use Setext headings.

Avoid:

```markdown
Title
=====
```

---

# Paragraphs

Separate paragraphs with a blank line.

Keep paragraphs reasonably short.

Prefer multiple short paragraphs over one large block of text.

---

# Whitespace

Separate paragraphs with a blank line.

Separate major sections using a horizontal rule (`---`).

Avoid excessive blank lines.

Keep related content visually grouped.

---

# Line Length

Prefer readable paragraphs.

Avoid extremely long lines when practical.

Do not manually wrap text simply to enforce a fixed line width.

Allow the editor to manage visual line wrapping.

---

# Lists

Use unordered lists when sequence is unimportant.

Example:

```markdown
- Item
- Item
- Item
```

Use numbered lists only when order matters.

```markdown
1. First
2. Second
3. Third
```

---

# Checklists

Use Markdown task lists.

Example:

```markdown
- [ ] Not started
- [x] Completed
```

---

# Emphasis

Use:

```markdown
**Bold**
```

for emphasis.

Use:

```markdown
*Italic*
```

for titles and occasional emphasis.

Avoid excessive formatting.

---

# Horizontal Rules

Use:

```markdown
---
```

to separate major sections.

Do not overuse horizontal rules.

---

# Blockquotes

Use blockquotes for:

- Definitions
- Important quotations
- Key principles

Example:

```markdown
> Knowledge belongs to me.
```

---

# Callouts

Use callouts sparingly.

Reserve them for:

- Important notes
- Warnings
- Tips

Example:

> [!NOTE]
> Knowledge evolves through continuous refinement.

Avoid excessive use of callouts, as they reduce readability when overused.

---

# Code Blocks

Use fenced code blocks.

Specify the language whenever practical to improve readability and syntax highlighting.

Example:

```text
Knowledge
    ↓
Projects
```

Another example:

```bash
git status
```

Avoid indented code blocks.

---

# Tables

Use tables when comparing structured information.

Example:

```markdown
| Concept | Description |
|----------|-------------|
| Resource | External information |
| Knowledge | Curated understanding |
```

---

# Internal Links

Use Obsidian wiki-links for references within the PKP.

Examples:

[[Deep Work]]

[[Knowledge Architecture]]

[[PKP-000 — Project Charter]]

Avoid linking temporary Inbox documents unless necessary.

Prefer linking permanent Knowledge, Architecture, Standards, Projects, or Templates.

---

# External Links

Use standard Markdown links for references outside the PKP.

Example:

[Git Documentation](https://git-scm.com/docs)

Prefer descriptive link text over raw URLs.

Avoid using bare URLs unless necessary.

---

# File Encoding

Markdown files shall use UTF-8 encoding.

UTF-8 ensures compatibility across editors, operating systems, Git, and AI tools.

---

# Document Philosophy

Every Markdown document should prioritize:

1. Understanding
2. Readability
3. Maintainability
4. Portability

Formatting exists to improve communication, not decoration.

Prefer clarity over complexity.

---

# Compliance

All newly created Markdown documents should follow this standard.

Existing documents may be updated gradually during normal maintenance.

Consistency is preferred over perfection.

---

# Related Documents

- [[README]]
- [[ARC-002 — Repository Architecture]]
- [[STD-001 — Naming Standard]]
- [[TMP-001 — Knowledge Object]]
- [[TMP-002 — Resource Processing Checklist]]