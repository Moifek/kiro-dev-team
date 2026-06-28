---
author: Moafak Maiza (Mouafak.Maiza@proton.me)
name: refine-ticket
description: >-
  Reads a Jira ticket, cross-references with app_docs for domain knowledge,
  and refines the description using our jira-ticket-template (two-layer approach).
  Use when asked to refine, review, or improve a Jira ticket's structure and content.
requires:
  - .kiro/steering/jira-ticket-template.md
  - .kiro/steering/ears-reference.md
  - .kiro/steering/jira-agent-workflow.md
---

# Refine Jira Ticket

Fetch a Jira ticket, cross-reference with app_docs, and rewrite the description to match `jira-ticket-template.md` structure.

## Steps

1. **Fetch the ticket** from Jira using the issue key. Note the issue type (Story, Bug, Task), parent epic, status, components, and existing description.

2. **Determine Layer 2 eligibility.** Ask the user if they are the developer implementing the work or the PO authoring it. Only populate Technical Notes (Layer 2) if they confirm developer context.

3. **Identify relevant app_docs.** Based on the ticket's component, summary, and description:
   - List `app_docs/` directory to find related documentation
   - Read docs that match the feature area (e.g., backend/authentication.md for auth tickets, backend/example-feature.md for proxy tickets)
   - Extract: file paths, service architecture, hook pipelines, API contracts, existing patterns

4. **Check sibling tickets** under the same parent epic (if any) for context on related work, established patterns, and scope boundaries.

5. **Draft the refined description** using the correct template from `jira-ticket-template.md`:
   - **Story:** Story Type, Summary, Background, Scope, Requirements, AC (EARS format), Dependencies, Backward Compatibility, DoD, Unknowns, Links, Technical Notes
   - **Bug:** Summary, Environment, Steps to Reproduce, Expected/Actual Result, Impact, AC, DoD, Unknowns, Links, Technical Notes
   - **Task:** Summary, Background, Scope, Approach, AC, Rollback Plan, DoD, Unknowns, Links, Technical Notes

6. **Present the refined ticket** as an overlay for user review. Highlight:
   - What was added (new sections)
   - What was rewritten (improved clarity)
   - What was preserved (existing content kept)
   - Any Unknowns that need resolution before implementation

7. **Push to Jira** only after explicit user confirmation.

## Rules

- Acceptance Criteria MUST use EARS syntax (WHEN/SHALL, IF/THEN/SHALL) per `ears-reference.md`
- Each AC must be independently testable with clear pass/fail
- Layer 2 (Technical Notes) is only populated if user confirms developer context
- Never overwrite existing Layer 1 content without showing the diff
- Cross-reference `backend-patterns.md` for implementation patterns (co-located hooks, property tests, constants files)
- Reference `data-contract-integrity.md` when the ticket touches API responses or persisted entities
- Unknowns section must always exist, even if "None identified"
- Out of Scope must be stated to prevent scope creep
- For Enhancement stories: Backward Compatibility is required
- Link to related/sibling tickets discovered during investigation

## Quality Checklist

Before presenting the refined ticket, verify:

- [ ] Summary is one clear sentence (bugs) or paragraph (stories)
- [ ] Story Type is indicated (New Feature / Enhancement)
- [ ] AC use EARS syntax with SHALL
- [ ] Each AC is independently testable
- [ ] Unknowns section exists
- [ ] Out of Scope is stated
- [ ] For Enhancement: Backward Compatibility filled
- [ ] For Bugs: Steps to Reproduce are numbered
- [ ] Links to related tickets included
- [ ] No vague terms ("fast", "user-friendly", "efficient")
