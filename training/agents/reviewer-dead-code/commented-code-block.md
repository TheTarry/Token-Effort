## Scenario
A file contains 5 consecutive lines of commented-out code (using `//` or `/* */`), clearly not documentation comments.

## Expected Behavior
The agent should flag the commented-out block as LOW severity, distinguish it from intentional documentation, and suggest deletion or archiving to git history.

## Pass Criteria
- [ ] Identifies the commented block as dead code (≥3 consecutive lines)
- [ ] Assigns LOW severity
- [ ] Distinguishes from documentation comments
- [ ] Suggests deletion or archival
