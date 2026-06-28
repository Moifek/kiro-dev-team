---
name: code-review
description: Comprehensive code review of changes between current branch and dev, including style guide compliance
license: MIT
compatibility: kiro
metadata:
  workflow: git
  audience: developers
---

## What I do

I perform a comprehensive code review of changes between the current branch and a target branch (defaults to dev). I analyze the full diff holistically for logic errors, style guide violations, and code quality issues.

## When to use me

Use this skill when you want to perform a code review before creating a pull request. Useful when:
- You need to verify code follows project style guidelines
- You're preparing changes for peer review
- You need a sanity check before pushing

## How I work

### Step 1: Determine target branch

Default is `dev`. If team-lead specifies a different branch, use that.

### Step 2: Get the git diff

```bash
git diff dev... -- ':!.kiro' ':!package-lock.json' ':!**/package-lock.json' ':!**/*.wsdl'
```

This excludes .kiro configuration files, package-lock.json, and .wsdl files.

### Step 3: Get changed file list

```bash
git diff dev... --name-only -- ':!.kiro' ':!package-lock.json' ':!**/package-lock.json' ':!**/*.wsdl'
```

### Step 4: Review the full diff

Analyze the complete diff as one unit. This allows catching cross-file issues (broken imports, inconsistent patterns, data flow problems). Evaluate against:

**Style guide checks:**
- No ternary operators
- Prefer string unions over enums
- Arrow functions except for exports
- Options objects over many parameters
- Single quotes, CommonJS modules
- Proper promise handling

**Quality checks:**
- Logic errors, bugs, potential runtime issues
- Missing error handling or edge cases
- Cross-file consistency (imports, exports, shared types)
- Performance concerns
- Security issues
- CSS duplication
- Test coverage gaps (new business logic without tests)
- Ineffective tests (assertions that don't validate meaningful behavior)

If the diff is too large to reason about in one pass, read individual files with `git show HEAD:<file-path>` for additional context.

### Step 5: Compile findings

Collect all findings into the structured report format.

### Step 6: Present results

Return the report in the format defined by the reviewer agent prompt.

## Report Format

```
## Code Review Report

**Branch**: [branch name]
**Compared Against**: dev
**Files Reviewed**: [count]

### Findings

| # | File | Line | Severity | Description |
|---|------|------|----------|-------------|
| 1 | src/path/file.js | 45 | error | [what's wrong and how to fix] |
| 2 | src/path/file.js | 102 | warning | [what's wrong and how to fix] |

### Summary

**Errors**: [count] (must fix)
**Warnings**: [count] (should fix)
**Clean**: [yes/no]
```

If no findings: report `**Clean**: yes` with empty findings table.

## Severity Levels

- **error** - Must fix: logic bugs, security issues, broken functionality, missing error handling for critical paths
- **warning** - Should fix: style violations, minor missing error handling, test gaps, code smell

## Constraints

- Default comparison branch is `dev`
- Excludes .kiro/, package-lock.json, and .wsdl files
- **NEVER run git commands that modify state** (no commit, push, checkout, reset, add, etc.)
- Git usage is strictly limited to read-only: `git status`, `git diff`, `git log`, `git show`, `git branch`, `git rev-parse`
- Review is holistic (full diff as one unit, not per-file)
- No Jira ticket validation (separate concern)
- No PR commenting (report back to team-lead only)
