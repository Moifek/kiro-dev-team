---
name: sync-specs
description: Update spec files (requirements.md, design.md, bugfix.md, tasks.md) to match the current state of the code
license: MIT
compatibility: kiro
metadata:
  workflow: git
  audience: developers
---

## What I do

I review all code changes on the current branch and update the corresponding spec files in `.kiro/specs/` so they accurately reflect what the code actually does.

## When to use me

Use this skill whenever the user wants to update, sync, refresh, or reconcile spec files with the current code. This includes any mention of "specs" combined with updating, syncing, or reviewing them.

Activate phrases:
- "update the specs"
- "update specs"
- "sync the specs"
- "sync specs"
- "update the specs to match the code"
- "sync specs to code"
- "refresh the specs"
- "specs are out of date"
- "bring specs up to date"
- "reconcile specs with code"

## How I work

### Step 1: Identify the spec directory

I get the current git branch name:
```bash
git branch --show-current
```

I extract the ticket number (e.g. `SBF-1234`, `SER-319`) from the branch name using the pattern `[A-Z]+-[0-9]+`.

Then I search `.kiro/specs/` for directories whose name starts with that ticket number. If:
- Exactly one match is found → use it
- Zero matches or multiple matches → ask the user which spec directory to use
- The branch name doesn't contain a recognizable ticket number → ask the user

### Step 2: Read existing spec files

I read whichever of these files exist in the spec directory:
- `requirements.md`
- `design.md`
- `bugfix.md`
- `tasks.md`

### Step 3: Get the code changes

I run:
```bash
git diff dev... -- ':!.kiro' ':!package-lock.json' ':!**/package-lock.json'
```

This gives me all code changes on the current branch relative to dev, excluding non-meaningful files.

If the diff is very large, I also get the list of changed files:
```bash
git diff dev... --name-only -- ':!.kiro' ':!package-lock.json' ':!**/package-lock.json'
```

And read key files directly with `git show HEAD:<path>` to understand the full context.

### Step 4: Compare code to specs and update

For each spec file that exists, I:
1. Compare what the code actually does against what the spec describes
2. Identify discrepancies — things the code does differently, new functionality not in the spec, or spec items that weren't implemented
3. Update the spec file to accurately describe the current code behavior

I preserve the existing structure and formatting style of each spec file. Changes I make include:
- Updating descriptions to match actual implementation details
- Adding new requirements/design sections for functionality that was added but not originally specced
- Marking or removing items that were descoped or not implemented
- Updating task completion status in `tasks.md` to reflect what's actually done
- Correcting technical details (component names, API shapes, file paths, etc.)

### Step 5: Present a summary

After updating, I provide a brief summary of what changed in each spec file and why.

## Constraints

- I only modify files inside the `.kiro/specs/` directory — never application code
- I preserve the existing formatting conventions of each spec file
- **NEVER run any git command that modifies the repository state.** Git usage is strictly limited to read-only commands such as `git status`, `git diff`, `git log`, `git show`, `git branch`, `git remote`, and `git rev-parse`.

