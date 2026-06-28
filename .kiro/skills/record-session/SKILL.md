---
name: record-session
description: Log the current agent session to the SQLite database with tool calls, compliance, and outcome
author: Mouafak.Maiza@proton.me (Moafak Maiza)
license: MIT
compatibility: kiro
metadata:
  workflow: observability
  audience: all-agents
---

## What I do

I record the current session to `~/.kiro/logs/agent-sessions.db` by calling `~/.kiro/scripts/log-session.sh` with structured session data.

## When to use me

At the end of any agent session that performed substantive work. Trigger phrases:
- "record session"
- "log session"
- "save session"
- "end session"

## How I work

### Step 1: Derive session metadata

From the conversation context, determine:

| Field | Source | Format |
|-------|--------|--------|
| session_id | date + feature slug | `YYYY-MM-DD-{slug}` (e.g., `2026-05-21-gem2-lfs-research`) |
| agent | current agent role | `team-lead`, `builder`, `validator`, `reviewer`, `documenter` |
| project | repo or workspace name | e.g., `service-a`, `service-d`, `kiro-config` |
| ticket | Jira ticket from branch or context | e.g., `PROJ-1001`, or `none` if no ticket |
| outcome | session result | `success`, `partial`, or `failed` |
| summary | brief description of work done | 1-2 sentences max |

### Step 2: Build compliance JSON

Track which workflow steps were executed (1=ran, 0=skipped):

```json
{"branch_setup":0,"validation":0,"code-review":0,"sync-specs":0,"push":0,"PR":0,"jira-update":0}
```

Each step value may also be an object carrying `evidence` (commit hashes, PR numbers, artifact references) and `notes` (why a step passed/skipped). Prefer this richer form for sessions that will be audited or presented:

```json
{
  "branch_setup": {"passed": 1, "evidence": "PR #629 commit fb7415df", "notes": "confirmed by user"},
  "jira-update": {"passed": 0, "notes": "intentionally skipped: code-review fixes, no ticket transition"}
}
```

The flat int form and the object form can be mixed in the same JSON. Only populate `evidence` with real artifacts (commit SHAs, PR numbers, file paths). Do not invent evidence to make a step look complete.

### Step 3: Build tool calls JSON

Collect tool calls made during the session as a JSON array:

```json
[{"ts":"<ISO8601>","tool":"<tool_name>","args":"<brief summary>","result":"<brief outcome>","exit":0,"ok":1,"ms":0}]
```

Include at minimum: MCP calls, git operations, file writes, lint/test runs, and subagent delegations.

### Step 4: Execute log script

```bash
bash ~/.kiro/scripts/log-session.sh \
  "<session_id>" \
  "<agent>" \
  "<project>" \
  "<ticket>" \
  "<outcome>" \
  "<summary>" \
  '<compliance_json>' \
  '<tool_calls_json>' \
  "<started_at>"   # optional, ISO8601
```

If the tool_calls JSON is too large for a shell argument, write it to `/tmp/session-tools.json` and use `$(cat /tmp/session-tools.json)` substitution.

**Session duration / `started_at`:** `ended_at` is always stamped at log time. `started_at` resolves in this order:
1. the optional 9th `started_at` arg (ISO8601), if you know the real start;
2. else the earliest `ts` among the provided tool_calls (good proxy for session start);
3. else `now` (zero-width session — honest when no timing data exists).

To get real durations, always pass tool_calls with `ts` timestamps, or supply the explicit `started_at`. Do not invent a start time to manufacture a duration.

### Step 5: Confirm

Report the session ID and number of tool calls recorded.

## Constraints

- Do NOT fabricate tool calls that didn't happen
- Do NOT omit the tool_calls argument (arg 8)
- Keep summary concise (under 200 chars)
- session_id must be unique (date + slug ensures this)
- If outcome is unclear, use `partial`
