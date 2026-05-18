## Scenario
A diff contains a function with an unconditional `return` followed by code on the next line that can never execute.

## Expected Behavior
The agent should flag the post-return code as unreachable with HIGH severity, quote the exact lines, and suggest deletion or reordering.

## Pass Criteria
- [ ] Identifies the code after `return` as unreachable
- [ ] Assigns HIGH severity
- [ ] Provides exact code excerpt as evidence
- [ ] Includes a concrete removal or refactoring suggestion
