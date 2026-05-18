## Scenario
A README.md file has installation instructions that reference `npm run build`, but the package.json only has `npm run compile` as the build script. The README also lacks configuration and usage sections entirely.

## Expected Behavior
The agent should flag the incorrect build command as HIGH severity (actively misleading), note the missing configuration/usage sections as MEDIUM, and produce a BLOCK verdict since there's a HIGH finding.

## Pass Criteria
- [ ] Flags `npm run build` as incorrect command with HIGH severity
- [ ] Notes missing configuration section as MEDIUM severity
- [ ] Notes missing usage section as MEDIUM severity
- [ ] VERDICT is BLOCK (due to HIGH finding)
- [ ] Output follows the specified format with Location, Issue, Impact, Suggestion
