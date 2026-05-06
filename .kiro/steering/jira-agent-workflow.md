---
inclusion: always
version: 2.1
---

# Jira Agent Workflow

How AI agents interact with Jira tickets throughout the development lifecycle.

## Ticket Lifecycle

```
PO/PM creates ticket (Layer 1)
       │
       ▼
Developer / AI agent picks up ticket
       │
       ├── Investigates codebase
       ├── Populates Technical Notes (Layer 2)
       ├── Implements the work
       │
       ▼
Tester AI agent picks up completed ticket
       │
       ├── Reads AC from Layer 1 (what to validate)
       ├── Reads Technical Notes from Layer 2 (how to test, what changed)
       ├── Runs validation / E2E tests
       │
       ▼
Done
```

---

## Before Writing Code

1. Read the full ticket. Flag missing Layer 1 sections before starting:
   - Acceptance Criteria (cannot implement without testable criteria)
   - Unknowns with unresolved items (do not guess)
2. Check Dependencies. If a blocker is not Done, flag it.
3. Read linked tickets and parent epics for context.
4. If Story Type is "Enhancement" and Backward Compatibility is empty, ask.
5. If Technical Notes (Layer 2) is empty, investigate the codebase and populate it before starting implementation.

## Creating Tickets via MCP

1. Follow the template for the issue type (see `jira-ticket-template.md`).
2. Always include Layer 1 sections: Summary, Scope, AC (EARS format), Definition of Done, Unknowns.
3. Never leave AC empty. If unclear, write draft AC marked `[DRAFT]`.
4. If no unknowns, write "None identified."
5. Use EARS syntax per `ears-reference.md`.
6. Leave Technical Notes (Layer 2) blank unless you already have the technical context.

## Updating Tickets via MCP

1. Present proposed changes to the user before writing.
2. Do not overwrite existing Layer 1 content. Append or modify specific sections.
3. Implementation findings go under Technical Notes (Layer 2).

## Populating Technical Notes (Layer 2)

After investigating the codebase and before/during implementation:

1. Fill in repos and file paths affected.
2. Document API contracts (method, endpoint, request/response).
3. Note config changes with JSON snippets and defaults.
4. Record exact error messages and HTTP codes introduced or changed.
5. Document data model changes (schema, new fields/collections).
6. Add test coverage notes so the Tester AI knows what to validate and how.

---

## Mapping Ticket Sections to Implementation

| Ticket Section | Action |
|---|---|
| Acceptance Criteria | Each AC = at least one test case |
| Technical Notes > Files | Read these files first |
| Technical Notes > API Contract | Verify against existing code before implementing |
| Technical Notes > Config Changes | Check tenant config DTO and schema |
| Technical Notes > Error Messages | Use exact messages and HTTP codes specified |
| Definition of Done | Checklist to verify before marking complete |
| Unknowns | Do not proceed past an unknown without asking |
| Out of Scope | Do not implement anything listed here |
| Backward Compatibility | Write tests that verify old behavior is preserved |
