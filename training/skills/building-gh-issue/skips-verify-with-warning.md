## Scenario

The user runs `/token-effort:building-gh-issue 44`. Valid spec and plan comments exist and the plan executes successfully through Phase 3. In Phase 4, the skill attempts to invoke `/verify`, but the skill is not available in this project.

## Expected Behaviour

- Phase 4 attempts to invoke `/verify`.
- Because `/verify` is unavailable, a named warning is logged: "⚠️ Phase 4 skipped: `/verify` skill not available in this project".
- Execution continues without stopping; Phase 5 (inline simplify pass) runs next.

## Pass Criteria

- [ ] An attempt to invoke `/verify` is made in Phase 4.
- [ ] A named warning is logged that includes both "Phase 4 skipped" and "/verify".
- [ ] Execution does NOT stop or error out after the warning.
- [ ] Phase 5 (inline simplify pass) runs after the warning is logged.
