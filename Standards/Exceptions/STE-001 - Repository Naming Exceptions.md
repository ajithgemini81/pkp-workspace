# STE-001 - Repository Naming Exceptions

Status: Active  
Version: 1.0  
Owner: Personal Knowledge Platform (PKP)  
Location: Standards/Exceptions/STE-001 - Repository Naming Exceptions.md  
Last Updated: 02-AUG-2026  

---

## Purpose

This document serves as the authoritative register of approved exceptions to the repository naming rules defined in `STD-001 - Naming Standard`. Its purpose is to document intentional, justified, and reusable deviations without altering or diluting the foundational rules of `STD-001`.

By maintaining a dedicated exception standard (`STE`) inside `Standards/Exceptions/`, the Personal Knowledge Platform (PKP) achieves both strict structural governance and the flexibility required for real-world operational workflows, file explorer prioritization, tooling integration, and AI package transport.

---

## Scope

This standard applies to all files, marker artifacts, scripts, logs, and progress reports within the PKP repository that deviate from the primary Title Case, prefix, or character rules established in `STD-001`.

This document covers:
* Workflow control files requiring top-of-list explorer pinning.
* System and repository marker files.
* Export package manifests and generated indexes.
* Milestone and stage execution reports requiring bottom-of-list transport sorting.

---

## Relationship to STD-001

1. **`STD-001` as the Primary Rulebook**: `STD-001` remains the default, authoritative standard for all standard repository artifacts, including folders, knowledge articles, architecture notes, standards, and templates.
2. **`STE-001` as the Exception Register**: Deviations from `STD-001` are non-compliant by default unless explicitly registered and justified within this document inside `Standards/Exceptions/`.
3. **No Retroactive Modification**: Introducing an approved exception in `STE-001` does not require updating `STD-001`, preserving the stability and readability of core governance documents.

---

## Guiding Principles

Naming exceptions in the PKP are governed by the following principles:

* **Intentionality**: Exceptions shall never be created to accommodate poor organization, accidental placement, or temporary laziness.
* **Operational Necessity**: An exception must solve a demonstrable functional problem in file explorers, local operating systems, Git tooling, or AI source lists.
* **Single Responsibility**: An excepted file must serve a distinct workflow or system control responsibility.
* **Minimal Scope**: Exceptions are narrow and restricted to specific file patterns or explicit directories.
* **Tool Independence**: Exceptions support platform discovery across tools (Obsidian, NotebookLM, Open WebUI, VS Code, Git) without creating lock-in to any single vendor.

---

## Exception Approval Criteria

To qualify for registration in this standard, a proposed naming deviation must satisfy all four of the following criteria:

1. **Clear Rationale**: A documented technical or operational requirement that cannot be satisfied while adhering strictly to `STD-001`.
2. **Non-Disruptive to Obsidian Graph**: The file name must not break Obsidian wiki-linking (`[[Note Name]]`) or introduce ambiguous link resolution.
3. **Transport Safety**: The file name must remain safe across cross-platform file systems (Windows, Linux, macOS) and flat export tools (`Projects/PKP Context Pack Generator`).
4. **Explicit Architectural Ownership**: The exception must be assigned to an explicit architectural category defined in this document.

---

## Exception Categories

Approved naming exceptions are classified into four functional categories:

| Category Code | Category Name | Primary Purpose | Examples |
| :--- | :--- | :--- | :--- |
| **CAT-01** | Workflow Control Files | Pins key operational or logging files to the top of file listings for human and AI efficiency. | `00-Additional Lexicon Entries.md`<br>`01-Daily Vocabulary Log.md` |
| **CAT-02** | Repository Root Markers | Identifies the canonical root directory for automated scripts and software tools. | `.pkp-root` |
| **CAT-03** | AI Export Package Manifests | System manifest files generated or read during transport package building. | `_FileList.csv`<br>`_FileListSpecification.md` |
| **CAT-04** | Milestone Sorting Control Files | Pins stage execution reports to the bottom of file lists in both tree and flat transport packages. | `zz_CompletedStage_01.md` |

---

## Detailed Exception Definitions

### EX-01: Numeric-Prefixed Workflow Control Files (CAT-01)

* **Exception Pattern**: Leading double-digit numbers followed by a hyphen (`00-`, `01-`, `02-`).
* **Why the Exception Exists**: Standard alphabetical file sorting pushes operational indexes and entry logs into the middle of large knowledge folders. Adding a leading numeric prefix forces OS file explorers, Obsidian file panes, and AI source lists (e.g., Gemini Notebooks, NotebookLM) to pin these entry-point files at the very top.
* **Problem Solved**: Eliminates time spent searching for daily logs or active entry buffers in dense directories; ensures AI assistants immediately index the active workflow log upon folder ingestion.
* **Permitted Usage**: Limited strictly to workflow control files, active daily logs, and central entry notes within specialized incubation or workflow folders (e.g., `Knowledge/Learning/Lexicon/`).
* **Prohibited Usage**: Must **not** be used on standard Knowledge Objects (`TMP-001`), architecture notes, general reference materials, or ordinary project files.
* **Approved Examples**:
  * `Knowledge/Learning/Lexicon/00-Additional Lexicon Entries.md`
  * `Knowledge/Learning/Lexicon/01-Daily Vocabulary Log.md`
* **Maintenance Considerations**: Numeric prefixes inside a folder should be kept to a minimum (typically `00` and `01`). If a folder requires more than three control files, the workflow should be re-evaluated for architectural drift.

---

### EX-02: Hidden Dot-Prefixed Repository Markers (CAT-02)

* **Exception Pattern**: Leading dot prefix (`.`).
* **Why the Exception Exists**: Standard operating systems and development tools recognize dot-prefixed files as hidden configuration or root-marker files (similar to `.git` or `.gitignore`).
* **Problem Solved**: Enables automated tools (PowerShell utilities, build scripts, AI agents) to traverse parent directories dynamically and discover the repository root without relying on hardcoded file paths.
* **Permitted Usage**: Restricted exclusively to repository discovery markers at the root level as defined in `STD-003 - Repository Marker Standard`.
* **Prohibited Usage**: Must **not** be used for ordinary markdown notes, user content, or subfolder markers.
* **Approved Examples**:
  * `.pkp-root`
  * `.gitignore`
* **Maintenance Considerations**: File content is intentionally empty or minimal. Do not delete or rename this file.

---

### EX-03: Underscore-Prefixed Manifest Files (CAT-03)

* **Exception Pattern**: Leading single underscore (`_`).
* **Why the Exception Exists**: Leading underscores sort files above standard alphabetical characters while distinguishing automated manifest data from human-curated content.
* **Problem Solved**: Instantly identifies files as package-level or repository-level metadata manifests generated by transport tools.
* **Permitted Usage**: Used for export package manifests, file inventory manifests, and manifest specification guides created at the repository root or export root.
* **Prohibited Usage**: Must **not** be used for standard knowledge notes, resource files, or internal drafts.
* **Approved Examples**:
  * `_FileList.csv`
  * `_FileListSpecification.md`
* **Maintenance Considerations**: `_FileList.csv` is updated during export package generation by the `PKP Context Pack Generator`.

---

### EX-04: Bottom-Pinned Stage Progress Reports (CAT-04)

* **Exception Pattern**: Leading double-z prefix with underscore (`zz_`).
* **Why the Exception Exists**: When repository files are exported into Flat Transport Packages for AI migration (where all subfolder paths are collapsed into a single directory), standard progress reports would interleave alphabetically with core architecture and standards notes.
* **Problem Solved**: Forcing the `zz_` prefix guarantees that historical stage reports sort at the absolute bottom of file listings in both hierarchical folder structures and flattened transport packages, keeping primary reference files at the top.
* **Permitted Usage**: Applied to completed milestone reports and historical stage execution logs located inside `Projects/PKP/Progress/`.
* **Prohibited Usage**: Must **not** be used for active project status notes (e.g., `PKP-999 - Current Project Status.md`), active standards, or general knowledge notes.
* **Approved Examples**:
  * `Projects/PKP/Progress/zz_CompletedStage_01.md`
  * `Projects/PKP/Progress/zz_CompletedStage_02.md`
* **Maintenance Considerations**: Sequence numbers (`01`, `02`, `03`) must increment sequentially. The highest-numbered file always represents the latest completed stage.

---

## Examples and Non-Examples

### Compliant Approved Exceptions (✔)
* `Knowledge/Learning/Lexicon/00-Additional Lexicon Entries.md` *(Approved EX-01: CAT-01 Workflow Control)*
* `.pkp-root` *(Approved EX-02: CAT-02 Marker)*
* `_FileList.csv` *(Approved EX-03: CAT-03 Package Manifest)*
* `Projects/PKP/Progress/zz_CompletedStage_01.md` *(Approved EX-04: CAT-04 Progress Report)*

### Non-Compliant Invalid Names (✘)
* `Knowledge/Learning/Deep Work/01-Deep Work Overview.md` *(Violation: Ordinary Knowledge Object using numeric prefix without approval)*
* `Standards/_NamingRules.md` *(Violation: Underscore used on standard document)*
* `Infrastructure/Prompts/zz_OldPrompt.md` *(Violation: `zz_` prefix used to archive a file instead of proper lifecycle deprecation)*
* `Projects/PKP/01-Project Plan.md` *(Violation: Numeric prefix used on project document; should use `PKP-xxx` identifier)*

---

## Impact on Repository Organization

* **Positive Graph & Link Resolution**: Because Obsidian resolves wiki-links by exact filename (`[[00-Additional Lexicon Entries]]` or `[[zz_CompletedStage_01]]`), registered exceptions maintain 100% backlink integrity across `Standards/Exceptions/`.
* **Transport Reliability**: The PowerShell Context Pack Generator (`Projects/PKP Context Pack Generator`) accounts for underscore and `zz_` patterns, preventing collision errors during flat package compilation.
* **Audit Transparency**: Automated scripts and future AI assistants auditing repository compliance can cross-reference `_FileList.csv` against `Standards/Exceptions/STE-001 - Repository Naming Exceptions.md` to filter out false-positive naming violations.

---

## Implementation Guidance

1. **Registering a New Exception**:
   - If an operational need arises that requires a new naming pattern, draft a proposal explaining the rationale.
   - Evaluate against the **Exception Approval Criteria**.
   - Upon approval, assign a new Exception ID (`EX-05`) and document it in this file inside `Standards/Exceptions/`.
2. **Refactoring Unregistered Exceptions**:
   - Files found violating `STD-001` that are *not* listed in `STE-001` must either be renamed to comply with `STD-001` or formally submitted for registration in `Standards/Exceptions/STE-001 - Repository Naming Exceptions.md`.

---

## Review and Maintenance

This standard shall be reviewed whenever:
* A new managed document prefix or repository control pattern is introduced.
* Major updates occur to the `Projects/PKP Context Pack Generator` transport logic.
* An Information Architecture Review milestone is completed.

---

## Related Standards and Architecture Documents

* [[STD-001 - Naming Standard]]
* [[STD-003 - Repository Marker Standard]]
* [[ARC-001 - Knowledge Architecture]]
* [[ARC-002 - Repository Architecture]]
* [[PKP-000 - Project Charter]]
* [[zz_CompletedStage_01]]