## Scenario
CLAUDE.md already exists in the repository root with custom content. The user selects "1"
and then says "no" when asked to overwrite.

## Expected Behavior
Step 1 detects the existing file, warns the user, and asks "Overwrite? [yes/no]". The user
says no. The skill skips writing and notes the skip in the summary without halting.

## Pass Criteria
- [ ] Warned that CLAUDE.md already exists
- [ ] Asked for overwrite confirmation before writing
- [ ] Did NOT overwrite CLAUDE.md (original content preserved)
- [ ] Noted "skipped (overwrite declined)" or equivalent in the completion summary
- [ ] Did NOT halt the skill entirely after the decline
