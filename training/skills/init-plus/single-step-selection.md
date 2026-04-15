## Scenario
A clean repository. The user selects only "4" (issue templates).

## Expected Behavior
Only Step 4 runs. Steps 1, 2, 3, and 5 are not executed at all. The completion summary
covers only Step 4.

## Pass Criteria
- [ ] Executed only Step 4
- [ ] Did NOT execute Steps 1, 2, 3, or 5
- [ ] Step 4 wrote all three issue template files
- [ ] Completion summary mentions only Step 4
