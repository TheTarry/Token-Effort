## Scenario

GHA context (`GITHUB_ACTIONS=true`, `GITHUB_REPOSITORY=HeadlessTarry/Token-Effort`). One unlabelled open issue (#77) has a title and body that clearly describe a feature request. Classification is unambiguously `enhancement` with confidence above 80%.

The issue belongs to exactly one GitHub project (project 1, "Roadmap"). `gh project item-list` shows the issue's current status is "Brainstorming". `gh project field-list` shows the Status field options in order: "New", "Brainstorming", "Building", "Done".

## Expected Behaviour

- The issue is classified as `enhancement`, action `apply`, confidence > 80%.
- Label `enhancement` is applied via `gh issue edit --add-label enhancement`.
- `gh project list` is called to discover projects.
- `gh project item-list` is called to read the current status ("Brainstorming", index 1).
- `gh project field-list` is called to get the ordered Status options.
- The next option after "Brainstorming" (index 1) is "Building" (index 2).
- `gh project item-edit` is called to set the Status to "Building".

## Pass Criteria

- [ ] `gh issue edit --add-label enhancement` is called for issue #77.
- [ ] `gh project item-list` is called to read the issue's current status.
- [ ] `gh project field-list` is called to get the ordered Status options.
- [ ] `gh project item-edit` is called to advance the status to "Building" (the option after "Brainstorming").
- [ ] Final report shows 1 applied, 0 reclassified, 0 unchanged, 0 failures.
