---
inclusion: auto
---

# Data Contract Integrity

When editing code that touches persisted entities or API response structures, always verify:

## Persisted Values
- Never introduce field values that fall outside the defined enum/schema for that field
- If a field has a known set of valid values (e.g., status: `pending_verification | verified | failed`), any code path that sets or returns that field must use one of those values
- Internal-only metadata (like "skipped" or "retrying") must use a separate field, not overload an existing contract field

## API Response Structure
- Endpoint responses must match the documented contract (field names, types, value ranges)
- If a response includes entity status fields, those values must match what the DB actually stores — no transient/internal-only statuses leaking into the response
- When adding new fields to a response, verify that all consumers (frontend, cron, other services) can handle them gracefully

## Communication Contract Checklist
Before modifying any hook, service method, or utility that shapes a response or writes to the DB:
1. Check the documented response shape (design.md, app_docs, or inline JSDoc)
2. Confirm every returned `status`/enum field uses only values from the defined set
3. If you need to convey internal state (backoff skip, retry, etc.), use a dedicated boolean or metadata field — not the entity's status field
