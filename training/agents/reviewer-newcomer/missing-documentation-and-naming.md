## Scenario
The agent is dispatched to review a single source file `src/auth/token_validator.py` containing a function `validate_token(token)` with no comments, cryptic variable names like `t`, `r`, `x`, and a bare `raise Exception("Invalid")` error. The file is 80 lines long.

## Expected Behavior
The agent should identify multiple clarity issues: missing comments explaining the validation logic, poor variable names, and an unhelpful error message. It should produce a VERDICT of NEEDS_CHANGES or BLOCK, with specific findings referencing file paths and line numbers, concrete suggestions for each issue, and a Positive Elements section.

## Pass Criteria
- [ ] Identifies poor variable naming (e.g., `t`, `r`, `x`) as a finding with concrete rename suggestions
- [ ] Identifies missing comments explaining non-obvious validation logic
- [ ] Identifies the unhelpful error message `"Invalid"` and suggests a more descriptive alternative
- [ ] Output includes a VERDICT that is not PASS (should be NEEDS_CHANGES or BLOCK)
- [ ] Each finding includes Location, Type, Issue, Impact, and Suggestion fields
- [ ] Includes a Positive Elements section (even if brief)
