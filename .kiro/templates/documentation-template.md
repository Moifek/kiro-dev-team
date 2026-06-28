---
name: documentation-template
description: Template for app_docs/ files; structure and style to match when creating or updating documentation.
author: Mouafak.Maiza@proton.me (Moafak Maiza)
version: 2.4.0
---

# Documentation Template

Template for `app_docs/` files. Match this structure and style when creating or updating documentation.

---

## Structure

```markdown
# [Domain Name] — [Layer: Backend | Frontend] (optional: ticket ref)

## Overview

[1-2 paragraphs: what this does, why it exists, key constraints. No fluff.]

---

## Files

[List of files involved, grouped by directory]

---

## [Core Concept / Architecture Section]

[Tables, code blocks, or diagrams explaining the main mechanism.
Use whatever format best communicates the design: tables for mappings,
code blocks for pipelines/chains, diagrams for flows.]

---

## [Detail Sections as needed]

[Each major aspect gets its own section. Examples:
- Validation rules (table format)
- Configuration options (table with key/type/default/purpose)
- Auth/permissions
- Error messages
- API endpoints
- Component breakdown]

---

## Tests

[Test file paths and counts, if applicable]

---

## Related Tickets

[Table of ticket references, if applicable]
```

---

## Style Rules

- **Concise**: No filler. State what it does, not what it "aims to achieve"
- **Tables over prose**: Use tables for mappings, configs, enums, permissions
- **Code blocks for structure**: Hook chains, file trees, URL patterns, pipelines
- **One file per domain**: `example-feature.md`, `authentication.md`, `job-tracker-screen.md`
- **Layer prefix in title**: "Backend" or "Frontend" after the domain name
- **Flat sections**: No deeply nested headers. H2 for main sections, H3 only when grouping within a section
- **Horizontal rules**: Use `---` between major sections for visual separation
- **No raw source code dumps**: Show signatures, patterns, and key snippets only
- **Ticket references**: Include related ticket IDs where relevant

---

## Naming Convention

```
app_docs/backend/<domain-name>.md
app_docs/frontend/<domain-name>.md
```

Use kebab-case. Name matches the feature/service domain, not the ticket or task.

Examples: `example-feature.md`, `authentication.md`, `image-service.md`, `job-tracker-screen.md`
