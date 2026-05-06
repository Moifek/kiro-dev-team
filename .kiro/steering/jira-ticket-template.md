---
inclusion: always
version: 2.1
---

# Jira Ticket Template - ServicePower Engineering

Standard structure for creating and updating Jira tickets across WORMS and CP boards.

## Authorship Layers

| Layer | Author | When |
|-------|--------|------|
| **Layer 1** (required) | PO / PM / ticket creator | At ticket creation |
| **Layer 2** (populated later) | Developer or AI agent | During implementation |

Layer 1 defines WHAT and WHY. Layer 2 documents HOW.

---

## Story / Feature

```
## Story Type
- [ ] New Feature (greenfield)
- [ ] Enhancement (modifying existing behavior)

<!-- If Enhancement: Backward Compatibility section is REQUIRED -->

## Summary

[What is being built, why, and who benefits. One paragraph.]

## Background

[Business driver, SoW reference, tenant(s) affected.]

## Scope

### What's Changing
- [Change 1]
- [Change 2]

### Out of Scope
- [What this ticket does NOT cover]

## Requirements

1. [Requirement]
2. [Requirement]

## Acceptance Criteria

1. WHEN [trigger], THE [system] SHALL [response] (Req N)
2. IF [condition], THEN THE [system] SHALL [response] (Req N)

## Dependencies

- Blocked by / Blocks / Related: [TICKET-ID]

## Backward Compatibility

[What must NOT break. Tenants, consumers, or integrations that depend on current behavior.]
<!-- REQUIRED for Enhancement. For New Feature, write "N/A - greenfield" if no existing behavior is affected. -->

## Definition of Done

- [ ] Implementation complete
- [ ] Unit tests cover all AC
- [ ] Existing tests pass
- [ ] Code review approved
- [ ] Tested on [environment] with [tenant]

## Unknowns

- [ ] [Question or unresolved decision]

## Links

[Design, API docs, related tickets, Confluence pages]

---
<!-- LAYER 2: Populated by developer or AI agent during implementation. Leave blank at ticket creation. -->

## Technical Notes

- **Repos:** [filled during implementation]
- **Files:** [filled during implementation]
- **API Contract:** [method, endpoint, request/response JSON]
- **Config Changes:** [JSON snippet with defaults]
- **Error Messages:** [exact message, HTTP code, error class]
- **Data Model:** [schema changes, new fields/collections]
- **Test Coverage:** [what was tested, how to run]
```

---

## Bug

```
## Summary

[One sentence: what is broken and where.]

## Environment

- **Application:** WORMS Portal / WORMS Services / Consumer Portal
- **Environment:** dev / qa / stg / prod
- **Tenant:** [if tenant-specific]
- **Version:** [if known]
- **Browser:** [if UI bug]

## Steps to Reproduce

1. [Step]
2. [Step]

## Expected Result

[What should happen.]

## Actual Result

[What happens. Include error messages, HTTP codes, console output.]

## Impact

[Who is affected, severity, workaround if any.]

## Acceptance Criteria

1. WHEN [reproduction scenario], THE system SHALL [correct behavior]
2. Existing behavior for [unaffected flows] SHALL remain unchanged

## Definition of Done

- [ ] Bug no longer reproducible
- [ ] Regression test added
- [ ] No side effects
- [ ] Tested on [environment]

## Unknowns

- [ ] [Question]

## Links

[Support ticket, related tickets, screenshots]

---
<!-- LAYER 2: Populated by developer or AI agent during implementation. -->

## Technical Notes

- **Root Cause:** [code-level explanation with file/function reference]
- **Repos:** [affected repos]
- **Files:** [files changed]
- **Fix Summary:** [what was changed and why]
- **Test Coverage:** [regression test details]
```

---

## Task (Infrastructure, DevOps, Research, Migration)

```
## Summary

[What needs to be done and why. One paragraph.]

## Background

[Context, parent epic, triggering event.]

## Scope

- **In Scope:** [deliverables]
- **Out of Scope:** [exclusions]

## Approach

[Step-by-step plan or comparison table for research/spike.]

## Acceptance Criteria

- [ ] [Criterion]

## Rollback Plan

[How to undo if something goes wrong. For migrations/infra only.]

## Definition of Done

- [ ] Deliverable complete
- [ ] Validated on [environment]

## Unknowns

- [ ] [Question]

## Links

[Parent epic, related tickets]

---
<!-- LAYER 2: Populated by developer or AI agent during implementation. -->

## Technical Notes

- **Repos:** [affected repos]
- **Files:** [file paths]
- **Commands:** [scripts or CLI commands used]
- **Rollback Steps:** [exact steps to undo]
```

---

## Epic

```
## Overview

[What this epic covers and why. One paragraph.]

## Problem Statement

[What is broken, missing, or insufficient.]

## Scope of Features

1. [TICKET-ID] — description
2. [TICKET-ID] — description

## Execution Order and Dependencies

[Dependency graph: which tickets block which.]

## Target Users

[Who benefits.]

## Links

[SoW, Confluence, design docs]
```

---

## Quality Checklist (Layer 1 - for ticket authors)

Before moving a ticket to Ready:

- [ ] Summary is one clear sentence (bugs) or paragraph (stories)
- [ ] Story Type is indicated (New Feature / Enhancement)
- [ ] Acceptance criteria use EARS syntax with SHALL
- [ ] Each AC is independently testable with a clear pass/fail
- [ ] Unknowns section exists (even if "None identified")
- [ ] Out of Scope is stated (prevents scope creep)
- [ ] For Enhancement stories: Backward Compatibility section filled
- [ ] For Bugs: Steps to Reproduce are numbered and reproducible
- [ ] For Bugs: Environment details filled in
- [ ] Links to related tickets, designs, or docs are included
- [ ] No vague terms: "fast", "user-friendly", "efficient" replaced with measurable criteria
