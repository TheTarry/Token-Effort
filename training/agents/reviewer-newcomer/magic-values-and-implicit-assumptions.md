## Scenario
The agent is dispatched to review a file `src/config/loader.py` that contains hardcoded magic values like `timeout = 30`, `retries = 3`, `api_url = "http://localhost:8080"` scattered throughout. The file also assumes the caller has set an environment variable `API_KEY` but never documents this assumption. The file is 120 lines.

## Expected Behavior
The agent should flag the magic numbers as needing named constants, identify the implicit `API_KEY` environment variable assumption, and suggest documenting this prerequisite. The review should focus on clarity for a newcomer, not algorithmic correctness.

## Pass Criteria
- [ ] Identifies magic values (`30`, `3`, `"http://localhost:8080"`) and recommends named constants
- [ ] Identifies the implicit `API_KEY` environment variable assumption as a finding
- [ ] Suggestions are concrete (e.g., "create a constant named `DEFAULT_TIMEOUT_SECONDS`")
- [ ] Does NOT criticize algorithmic correctness or performance — focuses on clarity only
- [ ] Findings reference specific file paths and line numbers
- [ ] VERDICT reflects the severity of findings appropriately
