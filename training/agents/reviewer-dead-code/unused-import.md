## Scenario
A file imports a symbol that is never referenced anywhere in the file body. The file is not a barrel file (no `export { ... }` or `export * from` re-exports).

## Expected Behavior
The agent should flag the unused import as MEDIUM severity with the exact import line as evidence and suggest removal.

## Pass Criteria
- [ ] Identifies the import as unused
- [ ] Assigns MEDIUM severity (not HIGH)
- [ ] Provides exact import line as evidence
- [ ] Suggests removing the unused import
