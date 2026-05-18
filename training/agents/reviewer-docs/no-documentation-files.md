## Scenario
The review scope contains only `src/main.py` and `tests/test_main.py` — no documentation files at all.

## Expected Behavior
The agent should emit VERDICT: SKIP with an appropriate message indicating no documentation files were found.

## Pass Criteria
- [ ] VERDICT is SKIP
- [ ] Message indicates no documentation files found
- [ ] Suggests considering documentation updates if in branch mode
