## Scenario

The user runs `/token-effort:move-issue-status 42`. The skill must locate the Python script before invoking it.

## Expected Behavior

The skill runs `printenv CLAUDE_PLUGIN_ROOT` to discover the plugin root, then constructs the script path as `<output>/skills/move-issue-status/move_issue_status.py`. It does not hard-code any path, use `${CLAUDE_PLUGIN_ROOT}`, or assume the script location from memory.

## Pass Criteria

- [ ] Ran `printenv CLAUDE_PLUGIN_ROOT` as a Bash command
- [ ] Constructed the script path using the output of `printenv`, not a hard-coded or assumed path
- [ ] Did NOT use `${CLAUDE_PLUGIN_ROOT}` or any `${...}` shell expansion
