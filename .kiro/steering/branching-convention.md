---
inclusion: always
author: Mouafak.Maiza@proton.me (Moafak Maiza)
version: 2.4.0
---

# Branching & PR Naming Convention

## Branch Format
```
<type>/PROJ-<number>-up-to-five-words-from-title
```

### Types
- `feature` - new functionality / stories
- `bugfix` - bug fixes
- `hotfix` - urgent production fixes
- `chore` - dependency updates, config, non-functional changes
- `tech` - technical tasks / subtasks

### Rules
- All lowercase
- Words separated by hyphens
- Max 5 words after the ticket number (pick the most meaningful ones)
- No `origin/` prefix, no underscores, no extra suffixes

### Examples
```
feature/PROJ-1001-display-customizable-message-portal-home
feature/PROJ-1002-dedicated-broker-credentials-transaction-report
feature/PROJ-1003-implement-custom-domain-feature
bugfix/PROJ-1004-profile-settings-saves-notifyconsent-null
bugfix/PROJ-1005-cross-tenant-data-access-broker-webhook
bugfix/PROJ-1006-broken-access-control-portal-config
hotfix/PROJ-1007-check-empty-jobid-init-load
```

## PR Title Format
```
[PROJ-<number>] <Jira issue summary (verbatim or close)>
```

### Examples
```
[PROJ-1001] Display customizable message on portal home based upon status
[PROJ-1002] Use dedicated broker credentials for internal transaction report emails
[PROJ-1004] Profile settings saves notifyConsent as null for webhook-created profiles
```

