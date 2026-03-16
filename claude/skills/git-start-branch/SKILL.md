---
name: git-start-branch
description: Use when starting any new piece of work that requires a fresh branch — before implementing a feature, fixing a bug, or working on a GitHub issue. Ensures main is up to date, handles uncommitted changes, and creates a properly named branch from main.
---

# Git: Start a Branch

Prepare a clean, up-to-date branch for new work.

## Workflow

### 1. Check for uncommitted changes

```bash
git status --short
```

If there are uncommitted changes, **stop and tell the user** — do not proceed. Ask them to commit, stash, or discard the changes before continuing.

### 2. Switch to main and pull latest

```bash
git checkout main
git pull
```

If `git pull` fails (e.g. diverged history, merge conflict), stop and report the error. Do not attempt to resolve it automatically.

### 3. Determine the branch name

**If a GitHub issue number is available** in the current context (user's message, a URL, or a referenced issue):

Use `feature/<issue-number>` — e.g. for issue #42 → `feature/42`

**Otherwise**, ask the user:

> What should the branch be called?

Use their answer as-is, normalising spaces to hyphens if needed.

### 4. Check if the branch already exists

```bash
git branch --list <branch-name>
```

If it exists locally, warn the user and ask: switch to it, or use a different name? Wait for their decision before continuing.

### 5. Create and switch to the branch

```bash
git checkout -b <branch-name>
```

Confirm: "Now on `<branch-name>`, branched from main."
