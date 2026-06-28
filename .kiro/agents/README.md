---
name: kiro-ensemble-readme
description: Roster and workflow summary for the WF1 multi-agent development framework.
author: Mouafak.Maiza@proton.me (Moafak Maiza)
version: 2.4.0
---

# KiroEnsemble (WF1)

Orchestrated multi-agent development workflow.

## Roster

| Agent | Role |
|-------|------|
| **team-lead** | Orchestrates workflow, delegates tasks, creates MRs |
| **builder** | Implements tasks, commits, runs sync-specs |
| **validator** | Verifies against spec + eslint + tests (read-only) |
| **reviewer** | Code review against dev, reports findings (read-only) |
| **documenter** | Incremental docs in app_docs/ |

## Workflow Summary

1. Load spec + repo steering + domain context
2. Branch setup
3. Create TODO list
4. Per task: builder → validator → commit → documenter
5. Code review (reviewer)
6. Sync specs (builder)
7. Final commits + push
8. MR creation (GitLab MCP, user-prompted)
9. Jira update (team-lead)
10. Execution report + session log

## Key Paths

- Specs: `.kiro/specs/{feature}/`
- Repo steering: `.kiro/steering/`
- Settings: `.kiro/settings/git-convention.json`
- Hooks: `.kiro/hooks/`
- Skills (global): `~/.kiro/skills/`
- Domain docs: `app_docs/backend/` and `app_docs/frontend/`
