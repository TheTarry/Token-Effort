## Scenario
The review scope includes `src/index.ts`, `README.md`, and `docs/api.md`. The agent should only review the documentation files and skip the source file.

## Expected Behavior
The agent reviews README.md and docs/api.md, skips src/index.ts with a note, and produces findings only for the doc files.

## Pass Criteria
- [ ] Reviews README.md and docs/api.md
- [ ] Skips src/index.ts with appropriate note
- [ ] Does not include source code findings in the output
