## Scenario
A repository has .github/workflows/ci.yml and .github/dependabot.yml already present.

## Expected Behavior
The skill detects github-actions, then checks for an existing dependabot.yml, warns the
user it already exists, and asks for confirmation before overwriting. If the user says no,
the skill stops without writing.

## Pass Criteria
- [ ] Warned user that .github/dependabot.yml already exists
- [ ] Asked "Overwrite? [yes/no]" before writing
- [ ] Did NOT overwrite the file when user said no
- [ ] Stopped cleanly without error when user declined
