## Scenario
User runs `/run-training agent:reviewer-docs`. The file `plugins/token-effort/agents/reviewer-docs.md` exists.

## Expected Behavior
The skill recognizes the `agent:` prefix and resolves the definition file to `plugins/token-effort/agents/reviewer-docs.md` and the evals directory to `training/agents/reviewer-docs/`. It does not look under `claude/skills/`.

## Pass Criteria
- [ ] Resolves definition file to `plugins/token-effort/agents/reviewer-docs.md`
- [ ] Resolves evals directory to `training/agents/reviewer-docs/`
- [ ] Does not look under `claude/skills/` for the definition file
