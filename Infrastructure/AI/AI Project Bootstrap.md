# AI Bootstrap Prompt

You are joining an existing long-term engineering project.

This is NOT a new project.

Continue from the current implementation without redesigning the architecture unless there is a compelling technical reason.

---

# Project

Personal Knowledge Platform (PKP)

The PKP is a long-term, Git-first, Markdown-first, AI-first knowledge platform.

The PKP repository is the permanent source of truth.

AI systems are consumers of the PKP.

Never recommend changing the repository structure simply to satisfy the limitations of an AI tool.

---

# Current Objective

Complete the AI Continuity System.

The objective is to make the PKP portable across:

- ChatGPT
- Gemini
- NotebookLM
- Open WebUI
- Future AI systems

The continuity mechanism should survive:

- Lost chats
- Context window limits
- AI platform changes

---

# Current Status

Repository Context Pack Generator v1 is complete.

Implemented:

- Manifest-based Context Packs
- Manifest validation
- Repository Context Pack generation
- START-HERE.md generation
- BuildReport.md generation
- Generate ALL Context Packs
- PKP-999 integration
- Repository output generation

Repository Output:

Infrastructure/
AI/
ContextPacks/
Output/
Repository/

The Repository Package generation is considered complete.

---

# Current Generator

The current PowerShell generator script follows this architecture:

User Interface

↓

Discovery

↓

Validation

↓

Pipeline

↓

Processing

↓

Copy

↓

Generated Files

↓

Reports

↓

Main

The script is fully functional.

The current PowerShell source code is attached below this prompt.

Treat it as the latest implementation.

Do not rewrite it from scratch unless requested.

---

# Next Objective

Implement Context Pack Generator v2.

The remaining work is:

1. Flat Package generation
2. Filename collision detection
3. Automatic filename renaming only when collisions occur
4. INDEX.md generation
5. Optional ZIP generation

---

# Flat Package Requirements

The Flat Package is generated FROM the Repository Package.

Do NOT regenerate files from the repository.

Pipeline:

Repository Package

↓

Flat Package

↓

ZIP (optional)

The Flat Package should contain every file in one directory.

Original folder hierarchy is preserved only inside INDEX.md.

---

# Collision Detection

When filenames collide:

Example

README.md

README.md

Rename only the minimum number of files necessary.

Example:

README.md

Learning - README.md

Record every rename inside INDEX.md.

Never rename files unnecessarily.

---

# INDEX.md Requirements

INDEX.md must contain:

- Original repository path
- Flat filename
- Rename mapping
- Package metadata

INDEX.md becomes the navigation document for Flat Packages.

---

# ZIP

ZIP generation is optional.

ZIP should package either:

Repository Package

or

Flat Package

depending on the selected transport profile.

---

# Architectural Principles

Always prioritize:

- Vendor Independence
- Git First
- Markdown First
- AI First
- Offline First
- Single Source of Truth
- Knowledge and Storage are Separate Concerns
- Repository structure is immutable
- Transport Packages adapt to AI limitations
- Open for extension
- Minimal duplication

---

# Important Decisions Already Made

Do NOT suggest:

- Renaming repository files
- Flattening the repository itself
- Changing PKP folder structure

The repository remains unchanged.

Only generated transport packages may differ.

---

# Coding Style

Language:

PowerShell

Current script organization:

- User Interface Functions
- Discovery Functions
- Validation Functions
- Build Functions
- Pipeline Functions
- Processing Functions
- Copy Functions
- Generated File Functions
- Report Functions
- Utility Functions
- Main Program

Maintain this organization unless a significantly better architecture is justified.

---

# Current Task

Continue implementing Context Pack Generator v2.

Focus only on the remaining implementation.

Avoid unnecessary architectural discussions.

Provide production-quality PowerShell code.

---

# Attached Files

The following content follows this prompt:

1. Current PowerShell Generator (Part 1)
2. Current PowerShell Generator (Part 2)
3. Current PowerShell Generator (Part 3)

Treat those parts as a single script.
Continue from that implementation.