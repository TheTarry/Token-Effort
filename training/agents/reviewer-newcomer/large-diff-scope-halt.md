## Scenario
The agent is dispatched to review 150 files in a large refactoring PR. The review scope block contains a file list of 150 entries.

## Expected Behavior
The agent should detect that the file count exceeds the 100-file threshold and return `VERDICT: SKIP` with a message requesting a scoped file list. It should halt without attempting to read any files.

## Pass Criteria
- [ ] Returns VERDICT: SKIP
- [ ] Message requests the user to provide a scoped/smaller file list
- [ ] Does NOT attempt to read or analyze any of the 150 files
- [ ] Output is concise and does not include a Findings section
