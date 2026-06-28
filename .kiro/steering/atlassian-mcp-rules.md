---
inclusion: always
author: Mouafak.Maiza@proton.me (Moafak Maiza)
version: 2.4.0
---

# Atlassian MCP Connection Rules

## Connection Defaults

These values are hardcoded. Do NOT call `getAccessibleAtlassianResources`.

- **cloudId**: `https://your-org.atlassian.net`
- **Auth**: API token (email + token from `~/.kiro/settings/atlassian-defaults.json`)

## Project Mapping (by repo)

| Repo | Jira Project | Confluence Space |
|------|-------------|------------------|
| service-a | PROJ | PROJ |
| service-b | PROJ | PROJ |
| service-c | PROJ2 | PROJ2 |
| service-d | PROJ2 | PROJ2 |

Determine the active project from the current repo context (branch name or working directory).

## Search Limits

- Use `maxResults: 10` for ALL Jira JQL searches
- Use `limit: 10` for ALL Confluence CQL searches
- Never omit these parameters

## Behavioral Rules

- Before updating any online resource (Confluence pages, Jira issues), present a summary overlay and wait for confirmation
- Keep comments compact and direct; aggregate multiple comments into one
- Do not suggest follow-up prompts or ask "what else can I help with"
