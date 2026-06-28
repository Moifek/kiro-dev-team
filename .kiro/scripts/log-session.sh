#!/usr/bin/env bash
set -euo pipefail

# Usage: log-session.sh <session_id> <agent> <project> <ticket> <outcome> <summary> [compliance_json] [tool_calls_json] [started_at]
# Example: log-session.sh "2026-05-19-example-feature" "team-lead" "service-a" "PROJ-1001" "success" "Implemented upload validation" '{"branch_setup":1,"validation":1}' '[{"ts":"2026-05-19T10:00:00","tool":"git","args":"checkout -b feat/x","result":"branch created","exit":0,"ok":1,"ms":500}]'
#
# started_at resolution (for real durations):
#   1. explicit <started_at> arg (ISO8601), if provided
#   2. else the earliest tool-call "ts" in the tool_calls JSON
#   3. else datetime('now') (zero-width session, honest fallback)
# ended_at is always datetime('now') at log time.

DB="$HOME/.kiro/logs/agent-sessions.db"

# Auto-init DB if it doesn't exist
if [ ! -f "$DB" ]; then
  bash "$HOME/.kiro/hooks/init-session-db.sh"
fi

SESSION_ID="${1:?session_id required}"
AGENT="${2:?agent required}"
PROJECT="${3:-}"
TICKET="${4:-}"
OUTCOME="${5:?outcome required}"
SUMMARY="${6:-}"
COMPLIANCE="${7:-}"
TOOL_CALLS="${8:-}"
STARTED_AT_OVERRIDE="${9:-}"

# Resolve started_at: explicit override > earliest tool-call ts > now
STARTED_AT=$(STARTED_AT_OVERRIDE="$STARTED_AT_OVERRIDE" TOOL_CALLS="$TOOL_CALLS" python3 -c "
import os, json
from datetime import datetime, timezone

override = os.environ.get('STARTED_AT_OVERRIDE','').strip()
if override:
    print(override); raise SystemExit

raw = os.environ.get('TOOL_CALLS','').strip()
earliest = None
if raw:
    try:
        calls = json.loads(raw)
        ts_list = [c.get('ts') for c in calls if c.get('ts')]
        # normalize to comparable strings; keep the lexicographically smallest valid ISO ts
        parsed = []
        for t in ts_list:
            try:
                parsed.append(datetime.fromisoformat(t.replace('Z','+00:00')))
            except Exception:
                pass
        if parsed:
            earliest = min(parsed)
    except Exception:
        pass

if earliest is not None:
    # store as 'YYYY-MM-DD HH:MM:SS' to match datetime('now') format
    print(earliest.astimezone(timezone.utc).strftime('%Y-%m-%d %H:%M:%S') if earliest.tzinfo else earliest.strftime('%Y-%m-%d %H:%M:%S'))
")

# Insert session. If STARTED_AT resolved, use it; else fall back to now in SQL.
if [ -n "$STARTED_AT" ]; then
  sqlite3 "$DB" "INSERT OR REPLACE INTO sessions (id, started_at, ended_at, agent_name, project, task_summary, jira_ticket, outcome)
  VALUES ('$SESSION_ID', '$STARTED_AT', datetime('now'), '$AGENT', '$PROJECT', '$SUMMARY', '$TICKET', '$OUTCOME');"
else
  sqlite3 "$DB" "INSERT OR REPLACE INTO sessions (id, started_at, ended_at, agent_name, project, task_summary, jira_ticket, outcome)
  VALUES ('$SESSION_ID', datetime('now'), datetime('now'), '$AGENT', '$PROJECT', '$SUMMARY', '$TICKET', '$OUTCOME');"
fi

# Insert compliance checks if provided
# Each step value may be either:
#   - an int/bool (1=ran, 0=skipped), or
#   - an object {"passed":1, "evidence":"...", "notes":"..."}
if [ -n "$COMPLIANCE" ]; then
  echo "$COMPLIANCE" | python3 -c "
import sys, json, sqlite3

db = sqlite3.connect('$DB')
data = json.load(sys.stdin)
for step, val in data.items():
    if isinstance(val, dict):
        passed = int(val.get('passed', 0))
        evidence = val.get('evidence')
        notes = val.get('notes')
    else:
        passed = int(val)
        evidence = None
        notes = None
    db.execute(
        'INSERT INTO compliance_checks (session_id, workflow_name, step_name, passed, evidence, notes) VALUES (?, ?, ?, ?, ?, ?)',
        ('$SESSION_ID', 'agentic-team-v2', step, passed, evidence, notes)
    )
db.commit()
db.close()
"
fi

# Insert tool_calls if provided
if [ -n "$TOOL_CALLS" ]; then
  echo "$TOOL_CALLS" | python3 -c "
import sys, json, sqlite3

db = sqlite3.connect('$DB')
calls = json.load(sys.stdin)
for c in calls:
    db.execute(
        'INSERT INTO tool_calls (session_id, timestamp, tool_name, arguments_summary, result_summary, exit_code, success, duration_ms) VALUES (?, ?, ?, ?, ?, ?, ?, ?)',
        ('$SESSION_ID', c.get('ts',''), c.get('tool',''), c.get('args',''), c.get('result',''), c.get('exit',0), c.get('ok',1), c.get('ms',0))
    )
db.commit()
db.close()
print(f'{len(calls)} tool_calls inserted')
"
fi

echo "Session $SESSION_ID logged to $DB"
