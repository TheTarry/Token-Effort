## Scenario
A clean repository. The user types "all" (rather than "1 2 3 4 5") when prompted.

## Expected Behavior
The skill treats "all" as equivalent to selecting all five steps. All five steps execute
in order 1→5.

## Pass Criteria
- [ ] Parsed "all" as selecting steps 1, 2, 3, 4, and 5
- [ ] Executed all five steps
- [ ] Steps executed in order 1 → 2 → 3 → 4 → 5
- [ ] Completion summary covers all five steps
