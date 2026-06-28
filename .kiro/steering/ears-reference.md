---
inclusion: always
author: Mouafak.Maiza@proton.me (Moafak Maiza)
version: 2.4.0
---

# EARS - Easy Approach to Requirements Syntax

Reference for writing unambiguous, testable acceptance criteria in Kiro specs.

## EARS Patterns

### Event-Driven (WHEN/SHALL)
`WHEN <trigger>, THE <system> SHALL <response>`
Example: WHEN a user submits the login form, THE System SHALL validate credentials and return a JWT token.

### Conditional (IF/THEN/SHALL)
`IF <condition>, THEN THE <system> SHALL <response>`
Example: IF the session token is expired, THEN THE System SHALL redirect the user to the login page.

### State-Driven (WHILE/SHALL)
`WHILE <state>, THE <system> SHALL <behavior>`
Example: WHILE the application is in offline mode, THE System SHALL queue all write operations for later sync.

### Optional/Variant (WHERE/SHALL)
`WHERE <option/variant>, THE <system> SHALL <behavior>`
Example: WHERE the tenant has SMS notifications enabled, THE System SHALL send appointment reminders via SMS.

### Compound
Combine patterns: `WHILE <state>, WHEN <trigger>, IF <condition>, THEN THE <system> SHALL <response>`

## Conversion Rules

When converting natural language requirements to EARS:
- Identify the trigger, condition, or state that activates the behavior
- Use SHALL for mandatory behavior (not "should", "may", "might")
- One behavior per criterion (split compound requirements)
- Make every criterion testable with a clear pass/fail outcome
- Avoid vague terms ("user-friendly", "fast", "efficient") - specify exact behaviors

## Property Extraction Patterns

When writing design.md, extract correctness properties from testable acceptance criteria:

### Round-Trip
*For any* X, applying operation then its inverse should return equivalent X.
Use for: serialization/deserialization, save/load, encode/decode.

### Invariant
*For any* X, after operation Y, property Z should still hold.
Use for: constraints that must always be true, data integrity rules.

### Validation
*For any* invalid input X, operation should reject it.
Use for: input validation, boundary conditions, authorization checks.

### State Transition
*For any* state X, transition Y should result in valid state Z.
Use for: workflows, status changes, state machines.

Each property must reference specific requirements (e.g., "Validates: Requirements 1.2, 3.4").

---
**Applies to all Kiro spec creation across all projects**
