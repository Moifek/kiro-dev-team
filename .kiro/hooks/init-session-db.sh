#!/usr/bin/env bash
mkdir -p ~/.kiro/logs/

sqlite3 ~/.kiro/logs/agent-sessions.db <<'EOF'
CREATE TABLE IF NOT EXISTS sessions (
    id TEXT PRIMARY KEY,
    started_at TEXT NOT NULL,
    ended_at TEXT,
    agent_name TEXT NOT NULL,
    project TEXT,
    task_summary TEXT,
    jira_ticket TEXT,
    outcome TEXT CHECK(outcome IN ('success','partial','failed','abandoned')),
    issues_discovered TEXT
);

CREATE TABLE IF NOT EXISTS tool_calls (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    session_id TEXT NOT NULL REFERENCES sessions(id),
    timestamp TEXT,
    tool_name TEXT NOT NULL,
    arguments_summary TEXT,
    result_summary TEXT,
    exit_code INTEGER,
    success INTEGER NOT NULL DEFAULT 1,
    duration_ms INTEGER
);

CREATE TABLE IF NOT EXISTS compliance_checks (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    session_id TEXT NOT NULL REFERENCES sessions(id),
    workflow_name TEXT NOT NULL,
    step_name TEXT NOT NULL,
    passed INTEGER NOT NULL,
    evidence TEXT,
    notes TEXT
);

CREATE INDEX IF NOT EXISTS idx_sessions_agent ON sessions(agent_name);
CREATE INDEX IF NOT EXISTS idx_sessions_project ON sessions(project);
CREATE INDEX IF NOT EXISTS idx_sessions_date ON sessions(started_at);
CREATE INDEX IF NOT EXISTS idx_tool_calls_session ON tool_calls(session_id);
CREATE INDEX IF NOT EXISTS idx_compliance_session ON compliance_checks(session_id);
EOF

echo "agent-sessions.db initialized at ~/.kiro/logs/agent-sessions.db"
