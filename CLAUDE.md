# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

# 🪙 Token-Effort

A Claude Code plugin that provides agents and skills for automating GitHub-based development workflows: triaging issues, brainstorming specs, planning, building, and releasing.

## 🛠️ Commands

**Testing hooks:**
```bash
python tests/hooks/test_compound_bash_allow.py
```

**Releasing a new version** (manual via GitHub Actions):
- Go to Actions → Release → Run workflow → enter SemVer (e.g. `1.2.3`)
- This patches `plugins/token-effort/.claude-plugin/plugin.json`, creates a git tag, and publishes a GitHub release.

**No build step.** This is a definitions-only repository (skills, agents, hooks). There's no compilation, bundling, or npm scripts.

## 🏗️ Architecture

### Plugin layout

```
plugins/token-effort/
├── .claude-plugin/plugin.json   ← version and plugin metadata
├── skills/<name>/SKILL.md       ← 12 skill definitions
├── agents/<name>.md             ← 5 agent definitions
└── hooks/                       ← hook handlers + hooks.json

training/
├── skills/<name>/               ← eval cases for each skill
├── agents/<name>/               ← eval cases for each agent
└── build/                       ← special training cases

.claude/
├── skills/run-training/         ← local-only training skill (not distributed)
└── hooks/suggest-training.py    ← PostToolUse hook: prompts to run /run-training after editing skills/agents
```

**Key distinction:** `.claude/skills/` are local-only. `plugins/token-effort/skills/` are distributed with the plugin.

### Issue lifecycle

Issues flow through the GitHub Project board:

```
New → Brainstorming → Planning → Building → Done
```

Each stage is handled by a dedicated skill (`/triaging-gh-issues`, `/brainstorming-gh-issue`, `/planning-gh-issue`, `/building-gh-issue`). Skills call `/move-issue-status` at completion to advance the board.

### Skills

Each skill is a `SKILL.md` with YAML frontmatter + structured Markdown phases. Required frontmatter:

```yaml
---
name: kebab-case-name
description: Use when... [trigger conditions, third-person]
user-invocable: true
---
```

Invoked as `/token-effort:skill-name` in Claude Code sessions, or via `anthropics/claude-code-action` in GitHub Actions.

### Agents

Each agent is an `agents/<name>.md` with frontmatter including `tools`, `model`, `background`, and `initialPrompt`. Agents are dispatched as subagents by skills (e.g. `reviewing-code-systematically` dispatches parallel reviewer agents).

Required frontmatter:

```yaml
---
name: kebab-case-name
description: Use when... [trigger conditions]
tools: Glob,Grep,Read,Bash
model: sonnet
background: false
initialPrompt: "REQUIRED SETUP — ..."
---
```

### Hooks

- **`compound_bash_allow.py`** (plugin, PreToolUse on Bash): Auto-approves compound shell commands (`&&`, `||`, `|`, `;`) if every sub-command is individually in the allow list. Never blocks on error — falls through to Claude Code default.
- **`suggest-training.py`** (local, PostToolUse): After editing any skill or agent file, prompts the user to run `/run-training`.

### Training system

`/run-training` iteratively improves skills/agents against committed eval cases:

1. Score current definition (baseline).
2. Mutate with operators: `add-constraint`, `add-example`, `tighten-language`, `restructure`, `add-negative-example`, `remove-bloat`.
3. Score mutated version; keep if improved.
4. Human gates every 5 cycles or on perfect score.

Eval files live in `training/skills/<name>/` and `training/agents/<name>/`. Format:

```markdown
## Scenario
...

## Expected Behavior
...

## Pass Criteria
- [ ] Binary pass/fail criterion
```

Naming: lowercase-hyphenated (e.g. `no-shell-expansion.md`).

## ⚠️ Skill constraints (enforced across all skills)

- **No shell variable expansion** (`${VAR}`) — use `printenv VAR` instead.
- **All `gh` calls use `--json`** for structured, parseable output.
