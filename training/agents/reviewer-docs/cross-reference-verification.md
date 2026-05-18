## Scenario
A README.md contains a link to `docs/getting-started.md` and references a command `make deploy`. The file `docs/getting-started.md` does not exist, and the Makefile has no `deploy` target.

## Expected Behavior
The agent should verify both cross-references, report the broken link and missing Makefile target, and include the results in the Cross-Reference Results section.

## Pass Criteria
- [ ] Reports `docs/getting-started.md` link as broken/missing
- [ ] Reports `make deploy` target as not found in Makefile
- [ ] Includes findings in Cross-Reference Results section
- [ ] Assigns appropriate severity (HIGH for broken link that blocks readers)
