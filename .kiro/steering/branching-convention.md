# Branching & PR Naming Convention

## Branch Format
```
<type>/CP-<number>-up-to-five-words-from-title
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
feature/CP-3916-display-customizable-message-portal-home
feature/CP-3921-dedicated-broker-credentials-transaction-report
feature/CP-3927-implement-custom-domain-feature
bugfix/CP-3936-profile-settings-saves-notifyconsent-null
bugfix/CP-3940-cross-tenant-data-access-broker-webhook
bugfix/CP-3941-broken-access-control-portal-config
hotfix/CP-3940-check-empty-jobid-init-load
```

## PR Title Format
```
[CP-<number>] <Jira issue summary (verbatim or close)>
```

### Examples
```
[CP-3916] Display customizable message on portal home based upon status
[CP-3921] Use dedicated broker credentials for internal transaction report emails
[CP-3936] Profile settings saves notifyConsent as null for webhook-created profiles
```

