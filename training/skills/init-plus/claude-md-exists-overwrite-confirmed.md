## Scenario
CLAUDE.md already exists in the repository root with custom content. The user selects "1"
and then says "yes" when asked to overwrite.

## Expected Behavior
Step 1 detects the existing file, warns the user, receives "yes", and overwrites CLAUDE.md
with the standard three-section template.

## Pass Criteria
- [ ] Warned that CLAUDE.md already exists
- [ ] Asked for overwrite confirmation before writing
- [ ] Overwrote CLAUDE.md with the three-section template after "yes"
- [ ] Written file contains all three sections (Architecture, Key Commands, Documentation Index)
- [ ] Completion summary reports "CLAUDE.md: created" or equivalent (not "skipped")
