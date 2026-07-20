# STD-0X3 - Repository Marker Standard

**Status:** Active

**Version:** 1.0

**Owner:** Personal Knowledge Platform (PKP)

**Last Updated:** 2026-07-20

---

# Purpose

This standard defines how software tools identify the root directory of the Personal Knowledge Platform (PKP).

Rather than relying on fixed folder structures or hard-coded relative paths, all PKP tools shall discover the repository root using a dedicated repository marker.

This approach provides a stable, portable, and vendor-independent mechanism for repository discovery.

---

# Scope

This standard applies to:

* Context Pack Generator
* AI automation tools
* Build scripts
* PowerShell utilities
* Git automation
* Backup utilities
* Documentation generators
* AI agents
* Future PKP tooling

---

# Repository Marker

The repository marker shall be a file named:

```text
.pkp-root
```

The file shall exist exactly once within a PKP repository.

Its location defines the repository root.

Example:

```text
PKP-Workspace
│
├── .pkp-root
├── README.md
├── Infrastructure
├── Projects
├── Knowledge
└── Resources
```

---

# Discovery Algorithm

Tools shall locate the repository root using the following process:

1. Start from the current working directory or script location.
2. Search the current directory for `.pkp-root`.
3. If found:

   * The current directory is the PKP repository root.
4. Otherwise:

   * Move to the parent directory.
5. Repeat until:

   * The marker is found, or
   * The filesystem root is reached.
6. If the marker cannot be found:

   * The tool shall terminate with an appropriate error.

Tools shall not rely on:

* Relative directory depth
* Folder names
* Drive letters
* Absolute paths

---

# Repository Marker Content

The repository marker is primarily identified by its filename.

The file content is informational only.

Recommended content:

```text
PKP Repository Marker
Version: 1.0

This file identifies the root of the Personal Knowledge Platform (PKP).

PKP tools use this marker to discover the repository root.

Do not remove unless intentionally relocating the repository.
```

Tools shall determine the repository root solely by the existence of the marker file.

---

# Design Principles

The repository marker supports the following PKP architectural principles:

* Vendor Independence
* Offline First
* Git First
* Markdown First
* AI First
* Documentation Driven Development
* Single Source of Truth
* Long-term Maintainability
* Portable Tooling

---

# Rationale

Hard-coded paths introduce unnecessary coupling between tools and repository layout.

Using a repository marker provides:

* Repository portability
* Stable root discovery
* Simplified automation
* Reduced maintenance
* Consistent behavior across all PKP tools

The design is conceptually similar to Git's use of the `.git` directory to identify a repository.

---

# Compliance

PKP tools that require repository discovery shall:

* Search for `.pkp-root`
* Stop searching once the marker is found
* Treat the containing directory as the repository root
* Report an error if the marker cannot be located

Tools shall not require users to manually configure repository paths.

---

# Future Considerations

Future versions of this standard may define optional metadata within the repository marker, such as:

* Repository identifier
* Repository version
* Repository format version
* Tool compatibility information

Such metadata shall remain optional unless a future standard explicitly requires it.

---

# References

- [[STD-000 - AI Collaboration Standard]]
- [[STD-001 - Naming Standard]]
- [[ARC-000 - PKP Architecture Overview]]
- [[ARC-002 - Repository Architecture]]


