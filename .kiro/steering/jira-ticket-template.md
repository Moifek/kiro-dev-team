---
inclusion: always
---

# Jira Ticket Template - ServicePower Engineering

Standard structure for creating and updating Jira tickets across WORMS and CP boards.
All team members and AI agents (Kiro) must follow this template when creating or updating tickets.

## When This Applies

- Creating new Jira issues via Atlassian MCP tools
- Updating existing ticket descriptions
- Reviewing tickets for completeness before moving to Ready
- AI agents reading tickets to begin implementation

---

## Template by Issue Type

### Story / Feature

```
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

## Technical Notes

- **Repos:** `worms-services`, `worms-portal`, `consumer-portal-api`, `consumer-portal-ui`
- **Files:** `src/path/to/file.ts`
- **API Contract:** method, endpoint, request/response JSON
- **Config Changes:** JSON snippet with defaults
- **Error Messages:** exact message, HTTP code, error class
- **Data Model:** schema changes, new fields/collections

## Dependencies

- Blocked by / Blocks / Related: [TICKET-ID]

## Backward Compatibility

[What must NOT break. Tenants, consumers, or integrations that depend on current behavior.]

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
```

---

### Bug

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

## Root Cause

[Code-level explanation with file/function reference, or "TBD".]

## Impact

[Who is affected, severity, workaround if any.]

## Fix

- **Repos:** [affected repos]
- **Files:** `src/path/to/file.ts`

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
```

---

### Task (Infrastructure, DevOps, Research, Migration)

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

- **Repos:** [affected repos]
- **Files:** [file paths]

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
```

---

### Epic

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

## AI Agent Instructions (Kiro)

### Before Writing Code
1. Read the full ticket. Flag missing sections to the user before starting:
   - Acceptance Criteria (cannot implement without testable criteria)
   - Files / Components Likely Involved (can investigate, but flag if missing)
   - Unknowns with unresolved items (do not guess)
2. Check Dependencies. If a blocker is not Done, flag it.
3. Read linked tickets and parent epics for context.
4. If Backward Compatibility section is absent on a Story that modifies existing APIs or UI, ask.

### When Creating Tickets via MCP
1. Follow the template for the issue type.
2. Always include: Summary, Scope, AC (EARS format), Files Likely Involved, Definition of Done, Unknowns.
3. Never leave AC empty. If unclear, write draft AC marked `[DRAFT]`.
4. If no unknowns, write "None identified."
5. Use EARS syntax per `~/.kiro/steering/ears-reference.md`.

### When Updating Tickets via MCP
1. Present proposed changes to the user before writing.
2. Do not overwrite existing content. Append or modify specific sections.
3. Post-implementation details go under Technical Notes, not replacing the original description.

### Mapping Ticket Sections to Implementation
| Ticket Section | Implementation Action |
|---|---|
| Files / Components Likely Involved | Read these files first |
| API Contract | Verify against existing code before implementing |
| Configuration Changes | Check tenant config DTO and schema |
| Error Messages | Use exact messages and HTTP codes specified |
| Acceptance Criteria | Each AC = at least one test case |
| Definition of Done | Checklist to verify before marking complete |
| Unknowns | Do not proceed past an unknown without asking |
| Out of Scope | Do not implement anything listed here |
| Backward Compatibility | Write tests that verify old behavior is preserved |

---

## Quality Checklist (for ticket authors and reviewers)

Before moving a ticket to Ready:

- [ ] Summary is one clear sentence (bugs) or paragraph (stories)
- [ ] Acceptance criteria use EARS syntax with SHALL
- [ ] Each AC is independently testable with a clear pass/fail
- [ ] Files or components likely involved are listed
- [ ] Unknowns section exists (even if "None identified")
- [ ] Out of Scope is stated (prevents scope creep)
- [ ] For Stories: Backward Compatibility section present
- [ ] For Bugs: Steps to Reproduce are numbered and reproducible
- [ ] For Bugs: Environment details filled in
- [ ] Links to related tickets, designs, or docs are included
- [ ] No vague terms: "fast", "user-friendly", "efficient" replaced with measurable criteria