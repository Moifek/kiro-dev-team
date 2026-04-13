# Kiro Agent Team

A custom agent team that integrates with Kiro's spec-driven development workflow.

## Overview

This setup combines Kiro's built-in spec creation with a custom execution team:

- **Kiro Spec Workflow** - Creates formal specs (requirements → design → tasks)
- **Custom Team** - Executes specs with builder/validator/documenter agents

## Team Members

| Agent | Role | Tools |
|-------|------|-------|
| **team-lead** | Orchestrates execution, delegates tasks, handles retries | read, subagent, todo, Jira MCP |
| **builder** | Implements tasks (writes code, runs commands) | read, write, shell |
| **validator** | Verifies completed work (read-only, runs tests) | read, shell |
| **documenter** | Generates documentation for completed features | read, write, Confluence MCP |

## Workflow

```
┌─────────────────────────────────────────────────────────────┐
│  PHASE 1: Spec Creation (Kiro Built-in)                    │
│                                                             │
│  Describe feature → requirements.md → design.md → tasks.md │
│  Location: .kiro/specs/{feature-name}/                      │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│  PHASE 2: Spec Execution (Custom Team)                      │
│                                                             │
│  team-lead reads tasks.md                                   │
│         │                                                   │
│         ▼                                                   │
│  For each task (sequential):                                │
│         │                                                   │
│         builder ──► validator ──► (next task)               │
│            │           │                                    │
│            │           └── FAIL: retry up to 3x             │
│            │               with richer context              │
│            │               then incident report             │
│            │                                                │
│         ▼ (all tasks complete)                              │
│    documenter ──► generates docs in app_docs/               │
│         │                                                   │
│         ▼                                                   │
│    final report                                             │
└─────────────────────────────────────────────────────────────┘
```

## Usage

### Step 1: Create a Spec

Use Kiro's spec workflow to create requirements, design, and tasks:

```
"I want to add user authentication"
```

Kiro will guide you through:
1. Spec type selection (feature vs bugfix)
2. Workflow selection (requirements-first vs design-first)
3. Document creation (requirements.md, design.md, tasks.md)

### Step 2: Execute the Spec

Switch to the team-lead agent and tell it to execute:

```
/agent swap → team-lead
```

Then:

```
Execute the spec in .kiro/specs/user-authentication/
```

The team-lead will:
1. Read the tasks from `tasks.md`
2. Create a TODO list
3. Delegate each task to builder → validator
4. Handle failures with retry policy
5. Run documenter at the end
6. Report results

## Execution Policy

When a task fails validation, the team-lead follows a bounded retry protocol:

| Attempt | Strategy |
|---------|----------|
| 1 | Initial dispatch with task description |
| 2 | Re-dispatch with previous output + failure report |
| 3 | Diagnosis-assisted dispatch with root cause analysis |
| 4 | Incident report and halt |

This prevents unbounded token spend while progressively adding context.

## File Structure

```
.kiro/
├── agents/
│   ├── team-lead.json
│   ├── team-lead-prompt.md
│   ├── builder.json
│   ├── builder-prompt.md
│   ├── validator.json
│   ├── validator-prompt.md
│   ├── documenter.json
│   └── documenter-prompt.md
├── specs/
│   └── {feature-name}/
│       ├── requirements.md
│       ├── design.md
│       └── tasks.md
└── templates/
    └── incident-report.md

app_docs/
├── backend/
└── frontend/
```

## EARS Format

All acceptance criteria in specs use EARS (Easy Approach to Requirements Syntax):

- **WHEN/SHALL** - Event-driven behavior
- **IF/THEN/SHALL** - Conditional behavior
- **WHILE/SHALL** - State-driven behavior
- **WHERE/SHALL** - Optional/variant behavior

Example:
```
WHEN a user submits the login form, THE System SHALL validate credentials and return a JWT token.
IF the session token is expired, THEN THE System SHALL redirect the user to the login page.
```

## Jira Integration

The team-lead can read Jira tickets as input for spec creation:

- Fetch ticket details with `mcp_atlassian__jira_get_issue`
- Search related tickets with `mcp_atlassian__jira_search`
- Convert Jira acceptance criteria to EARS format

## Agent Separation of Concerns

| Agent | Owns |
|-------|------|
| team-lead | EARS formatting, BMAD triage, property extraction, Jira MCP read |
| documenter | Confluence MCP write, prose docs only, no EARS |
| builder | Code execution only, no spec creation, no EARS, no MCP tools |
| validator | Read-only verification, unchanged |