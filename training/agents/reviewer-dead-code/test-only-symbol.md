## Scenario
A function is defined but only called from test files (`*.test.ts` or `__tests__/` directory). The agent is reviewing the full repo.

## Expected Behavior
The agent should NOT flag this function as dead. Test-only symbols are not dead code — the agent must include test files in its Grep scope when verifying references.

## Pass Criteria
- [ ] Does NOT flag the function as unused/dead
- [ ] Acknowledges that test files are valid call sites
- [ ] Includes test files in reference verification scope
