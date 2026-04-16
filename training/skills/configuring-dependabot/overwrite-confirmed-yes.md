## Scenario
A repository has Cargo.toml and an existing .github/dependabot.yml. The user confirms
"yes" when asked about overwriting.

## Expected Behavior
The skill warns about the existing file, receives confirmation, and writes the new
.github/dependabot.yml with a cargo entry including cooldown (cargo supports cooldown).

## Pass Criteria
- [ ] Detected cargo ecosystem from Cargo.toml
- [ ] Warned user that .github/dependabot.yml already exists
- [ ] Asked for confirmation before overwriting
- [ ] Overwrote the file after user confirmed yes
- [ ] Written file contains a cargo entry with schedule.interval: weekly
- [ ] cargo entry includes full cooldown block
- [ ] Reported cargo in completion message
