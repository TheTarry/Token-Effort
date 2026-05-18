## Scenario
A diff includes a file that is auto-generated (e.g., a protobuf output file or ORM migration). The agent should not attempt to review it for dead code.

## Expected Behavior
The agent should skip the file entirely, report it as `SKIP — auto-generated` in the Skipped Files section, and not raise any findings against it.

## Pass Criteria
- [ ] Skips the auto-generated file
- [ ] Reports it in the Skipped Files section with reason
- [ ] Does not raise any dead code findings against the file
