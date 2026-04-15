## Scenario
CLAUDE.md does not exist. The user selects "1". The skill writes CLAUDE.md.

## Expected Behavior
The written CLAUDE.md must contain exactly the three-section template defined in the skill:
a level-1 Architecture heading, a level-2 Key Commands heading, and a level-2 Documentation
Index heading — each followed by an HTML comment placeholder. No other content is added.

## Pass Criteria
- [ ] Written file starts with "# 🏗️ Architecture"
- [ ] Written file contains "## 🔑 Key Commands"
- [ ] Written file contains "## 📚 Documentation Index"
- [ ] Each section contains an HTML comment placeholder (<!-- ... -->)
- [ ] No additional sections or content are added beyond the three-section template
