---
name: address-pr-review
description: Fetch PR review comments, cross-reference with spec/app_docs, classify each comment, implement fixes, validate, commit, and post summary.
agent: team-lead
triggers:
  - "address PR review"
  - "fix PR comments"
  - "handle code review"
inputs:
  - repo: string (e.g., "service-b")
  - pr_number: integer
author: Mouafak.Maiza@proton.me (Moafak Maiza)
---

# Address PR Review

Systematically process code review comments on a pull request: fetch, classify, fix, validate, push, and respond.

## Prerequisites

- PR branch checked out locally
- Spec exists in `.kiro/specs/{feature}/` for the feature under review
- Relevant `app_docs/` available for domain context

## Steps

### 0. Resolve inputs

If `repo` or `pr_number` were not supplied by the user:
- Prompt: "Which repo? (e.g., service-b, service-a)"
- Prompt: "Which PR number?"

Do not proceed until both values are confirmed.

### 1. Fetch PR metadata

Use GitLab MCP (`get_merge_request` + `get_merge_request_notes`) to retrieve:
- PR title, source branch, state
- All comments with: user, content, inline location (file + line)

Output: structured list of review comments with file paths and line numbers.

### 2. Checkout and read

- `git checkout {source_branch}` in the repo
- Read each file referenced in review comments (only the relevant line ranges)

### 3. Load context

- Identify the matching spec in `.kiro/specs/` (match by ticket number or feature name from PR title)
- Read `requirements.md` and `design.md` from that spec
- Read relevant `app_docs/` for domain knowledge

### 4. Classify each comment

For every review comment, assign one of:

| Classification | Meaning | Action |
|---|---|---|
| **BUG** | Real defect, will crash or produce wrong behavior | Must fix |
| **CORRECTNESS** | Logic inconsistency or spec violation | Should fix |
| **NIT** | Style, naming, comment suggestion | Fix if trivial |
| **FALSE_POSITIVE** | Reviewer mistaken — code is already correct | Defend with evidence |
| **BY_DESIGN** | Behavior is intentional per spec requirement | Cite spec reference |
| **NO_ACTION** | Reviewer confirmed correct, informational only | Acknowledge in PR comment |

#### No-Skip Policy

Every finding MUST be addressed — no item may be silently skipped. For each finding, either:
- **Fix it** (BUG, CORRECTNESS, NIT)
- **Defend it** with evidence in the PR comment (FALSE_POSITIVE, BY_DESIGN)

If a finding cannot be fixed in this PR (e.g., requires architectural change, blocked by external dependency), classify it as a separate item and document in the PR comment:
- Why it cannot be addressed now
- What the plan is (follow-up ticket, tech debt item)

Test-related findings are NOT lower priority. Tests are part of the deliverable and must be addressed with the same rigor as production code.

For each classification, record:
- The comment text
- The file + line
- The classification + rationale
- If FALSE_POSITIVE or BY_DESIGN: the evidence (spec requirement number, code line showing correctness)

#### Defending false positives

When a comment is classified as FALSE_POSITIVE or BY_DESIGN, the PR comment must **explain the reasoning and defend the implementation**:

1. **State what the reviewer expected** — acknowledge their concern
2. **Show the hard evidence** — quote the exact code line, spec requirement number, or runtime behavior that proves correctness
3. **Explain why the current implementation is correct** — connect the evidence to the design decision

Do not dismiss with "already correct" alone. The reviewer deserves to understand *why* it's correct so they can verify independently.

Examples:
- "Reviewer expected `gblFontFamily` to be `Open Sans` but line 28 of `admin-custom-theme-state.service.ts` already reads `'"Lato", sans-serif'` — this was updated as part of the default font change (Spec Req 4.1). The diff may show stale context."
- "Reviewer suggests a migration warning for removed fonts. Per Spec Req 9.4: 'THE Custom_Theme_Editor SHALL fall back to the default font and display the theme without error.' Silent fallback is the specified behavior. Tenants with custom fonts load them from `config.ui.googleFonts` (Req 9.3), so only fonts absent from both lists trigger fallback."

### 5. Plan fixes

For each BUG/CORRECTNESS/NIT that needs fixing:
- State the exact change (before → after)
- Group changes by file to minimize builder dispatches

Test files are in scope. If a finding targets test code (refactoring, assertion improvements, stub changes), plan and implement it like any other fix.

### 6. Implement fixes

Delegate to builder per file group. Each dispatch includes:
- File path
- Exact changes with line numbers
- Instruction to change nothing else

### 7. Validate

Delegate to validator:
- Run ESLint on modified files
- Run relevant tests (unit/PBT/integration)
- Confirm 0 new lint errors from our changes (pre-existing errors are acceptable)
- Confirm tests pass

If validation fails → retry per execution policy (max 3 attempts).

### 8. Commit and push

Delegate to builder:
- Stage modified files only
- Commit with message: `fix({scope}): address PR #{pr_number} review comments`
- Body: bullet list of fixes applied
- Push to source branch

### 9. Post PR comment (MANDATORY)

This step is NON-OPTIONAL. After push, ALWAYS post a comment on the MR summarizing what was addressed. If GitLab MCP is unavailable, output the comment text and instruct the user to post it manually.

Use GitLab MCP (`create_merge_request_note`) to comment on the MR with:

```
## Review Comments Addressed — Commit {sha}

### Fixed
| # | Comment | Fix |
|---|---------|-----|
...

### No Action — False Positives / By-Design
| # | Comment | Reasoning |
|---|---------|----------|
...

For each false positive/by-design item, include:
- What the reviewer expected
- The evidence (code line, spec requirement, or runtime proof)
- Why the current implementation is correct

### Deferred (with reasoning)
| # | Comment | Why deferred | Follow-up |
|---|---------|-------------|------------|
...

### Validation
- ESLint: {result}
- Tests: {result}
```

## Output

- Commit pushed to PR branch
- PR comment summarizing all actions taken with defended reasoning for dismissed items
- Each review comment classified with rationale
- Every review finding accounted for in the PR comment (none silently skipped)

## Error Handling

| Scenario | Behavior |
|---|---|
| No spec found for the feature | Proceed without spec cross-reference; classify based on code reading only |
| GitLab MCP unavailable | Report error, provide fix plan as text output instead |
| Push fails (auth) | Report command needed, wait for user |
| All comments are false positives | Post explanation comment only, no code changes |
| Inputs not supplied | Prompt user before proceeding (Step 0) |
