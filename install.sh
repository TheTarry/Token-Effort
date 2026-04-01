#!/usr/bin/env bash
set -euo pipefail

BOLD="\033[1m"
GREEN="\033[32m"
CYAN="\033[36m"
YELLOW="\033[33m"
MAGENTA="\033[35m"
RED="\033[31m"
DIM="\033[2m"
RESET="\033[0m"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_SRC="$SCRIPT_DIR/claude"
CLAUDE_DEST="$HOME/.claude"

# All potential component types — missing source directories are skipped silently
# (commands, scripts are not yet used in this repo)
COMPONENTS=(skills agents hooks commands scripts)

COPY=false
FORCE=false
DRY_RUN=false
UNINSTALL=false

# ---------------------------------------------------------------------------
# Usage
# ---------------------------------------------------------------------------
show_usage() {
  echo "Usage:"
  echo "  ./install.sh --copy       # Copy files to ~/.claude"
  echo "  ./install.sh --force      # Remove existing component dirs, then copy"
  echo "  ./install.sh --uninstall  # Remove installed component dirs from ~/.claude"
  echo "  ./install.sh --dry-run    # Preview changes without applying them"
}

# ---------------------------------------------------------------------------
# Arg parsing
# ---------------------------------------------------------------------------
for arg in "$@"; do
  case "$arg" in
    --copy)      COPY=true ;;
    --force)     COPY=true; FORCE=true ;;
    --dry-run)   DRY_RUN=true ;;
    --uninstall) UNINSTALL=true ;;
    -h|--help)   show_usage; exit 0 ;;
    *) echo -e "${RED}Unknown option: $arg${RESET}"; show_usage; exit 1 ;;
  esac
done

# ---------------------------------------------------------------------------
# Counting helpers
# ---------------------------------------------------------------------------

# Count SKILL.md files recursively (each = one skill)
count_skills() {
  local dir="$CLAUDE_SRC/skills"
  [[ -d "$dir" ]] || { echo 0; return; }
  find "$dir" -name "SKILL.md" | wc -l | tr -d ' '
}

# Count skills with 'user-invocable: true' in frontmatter
count_invocable_skills() {
  local dir="$CLAUDE_SRC/skills"
  [[ -d "$dir" ]] || { echo 0; return; }
  { grep -rl "user-invocable: true" "$dir" --include="SKILL.md" 2>/dev/null || true; } | wc -l | tr -d ' '
}

# Count top-level items in a directory
count_items() {
  local dir="$1"
  [[ -d "$dir" ]] || { echo 0; return; }
  find "$dir" -mindepth 1 -maxdepth 1 | wc -l | tr -d ' '
}

# Count all files in a directory (recursive)
count_files() {
  local dir="$1"
  [[ -d "$dir" ]] || { echo 0; return; }
  find "$dir" -type f | wc -l | tr -d ' '
}

# ---------------------------------------------------------------------------
# Python detection
# ---------------------------------------------------------------------------
# Sets PYTHON_BIN (full path) and PYTHON_CMD (bare name), or both "" if not found.
# Skips Windows Store stubs that exist on PATH but fail to execute.
detect_python() {
  PYTHON_BIN=""
  PYTHON_CMD=""
  local _py_candidate _py_path
  for _py_candidate in python3 python; do
    _py_path=$(command -v "$_py_candidate" 2>/dev/null) || continue
    "$_py_path" -c "pass" 2>/dev/null && PYTHON_BIN="$_py_path" && PYTHON_CMD="$_py_candidate" && break
  done
}

# ---------------------------------------------------------------------------
# Uninstall
# ---------------------------------------------------------------------------
do_uninstall() {
  local removed=0
  for component in "${COMPONENTS[@]}"; do
    local target="$CLAUDE_DEST/$component"
    if [[ -d "$target" ]]; then
      if $DRY_RUN; then
        echo -e "  ${DIM}[dry-run]${RESET} would remove ~/.claude/${component}/"
      else
        rm -rf "$target"
        echo -e "  ${RED}✗${RESET} Removed ~/.claude/${component}/"
      fi
      removed=$((removed + 1))
    fi
  done

  # Remove only our hook entry from ~/.claude/settings.json, identified by script filename
  local settings_file="$CLAUDE_DEST/settings.json"
  detect_python
  local python_bin="$PYTHON_BIN"
  if [[ -f "$settings_file" && -n "$python_bin" ]]; then
    if $DRY_RUN; then
      echo -e "  ${DIM}[dry-run]${RESET} would remove PostToolUse hook from ~/.claude/settings.json"
    else
      "$python_bin" - "$settings_file" <<'PYEOF'
import json, sys

settings_path = sys.argv[1]
with open(settings_path) as f:
    settings = json.loads(f.read())
post_use = settings.get("hooks", {}).get("PostToolUse", [])

# Remove hooks referencing suggest-training.py; drop entries whose hooks list becomes empty
updated = []
for entry in post_use:
    remaining = [h for h in entry.get("hooks", []) if "suggest-training.py" not in h.get("command", "")]
    if remaining:
        entry["hooks"] = remaining
        updated.append(entry)

if updated != post_use:
    settings.setdefault("hooks", {})["PostToolUse"] = updated
    with open(settings_path, "w") as f:
        f.write(json.dumps(settings, indent=2))

PYEOF
      echo -e "  ${RED}✗${RESET} Removed PostToolUse hook from ~/.claude/settings.json"
      removed=$((removed + 1))
    fi
  fi

  if [[ $removed -eq 0 ]]; then echo "  Nothing to uninstall."; fi
}

# ---------------------------------------------------------------------------
# Force cleanup (remove component dirs before install)
# ---------------------------------------------------------------------------
do_force_cleanup() {
  for component in "${COMPONENTS[@]}"; do
    local target="$CLAUDE_DEST/$component"
    [[ -d "$target" ]] || continue
    if $DRY_RUN; then
      echo -e "  ${DIM}[dry-run]${RESET} would remove ~/.claude/${component}/"
    else
      rm -rf "$target"
    fi
  done
}

# ---------------------------------------------------------------------------
# Install a single component directory
# ---------------------------------------------------------------------------
install_component() {
  local component="$1"
  local src="$CLAUDE_SRC/$component"
  local dest="$CLAUDE_DEST/$component"

  [[ -d "$src" ]] || return 0

  while IFS= read -r -d '' file; do
    local rel="${file#$src/}"
    local target="$dest/$rel"
    if $DRY_RUN; then
      echo -e "  ${DIM}[dry-run]${RESET} ${MAGENTA}~/.claude/${component}/${rel}${RESET}"
    else
      mkdir -p "$(dirname "$target")"
      cp "$file" "$target"
      echo -e "  ${MAGENTA}🤖${RESET} ~/.claude/${component}/${rel}"
    fi
  done < <(find "$src" -type f -print0)
}

# ---------------------------------------------------------------------------
# Header
# ---------------------------------------------------------------------------
echo -e ""
echo -e "${BOLD}${CYAN}  🪙  Token Effort${RESET}"
echo -e "${YELLOW}  Low-stakes intelligence for high-latency humans${RESET}"
echo -e ""

# --dry-run alone implies --copy (preview the install)
if $DRY_RUN && ! $COPY && ! $UNINSTALL; then
  COPY=true
fi

# Default: no action specified → show usage
if ! $COPY && ! $UNINSTALL; then
  show_usage
  echo -e ""
  exit 0
fi

$DRY_RUN && echo -e "${YELLOW}  (dry-run — no changes will be made)${RESET}" && echo -e ""

# ---------------------------------------------------------------------------
# Uninstall path
# ---------------------------------------------------------------------------
if $UNINSTALL; then
  echo -e "${MAGENTA}${BOLD}  Uninstalling Claude Code customisations from ~/.claude${RESET}"
  echo -e ""
  do_uninstall
  echo -e ""
  if $DRY_RUN; then
    echo -e "${GREEN}${BOLD}  ✅ Dry run complete. Run without --dry-run to apply.${RESET}"
  else
    echo -e "${GREEN}${BOLD}  ✅ Uninstall complete.${RESET}"
  fi
  echo -e ""
  exit 0
fi

# ---------------------------------------------------------------------------
# Copy path
# ---------------------------------------------------------------------------
echo -e "${MAGENTA}${BOLD}  Installing Claude Code customisations → ~/.claude${RESET}"
$FORCE && echo -e "${YELLOW}  (--force: removing existing component directories first)${RESET}"
echo -e ""

$FORCE && do_force_cleanup

$DRY_RUN || mkdir -p "$CLAUDE_DEST"

for component in "${COMPONENTS[@]}"; do
  install_component "$component"
done

# Register hooks in ~/.claude/settings.json
# PYTHON_CMD is the bare name (e.g. "python") written into settings.json — avoids hardcoding install paths.
detect_python
if [[ -z "$PYTHON_BIN" ]]; then
  echo -e "  ${YELLOW}⚠${RESET}  Python not found — skipping hook registration in ~/.claude/settings.json"
else
  HOOK_COMMAND="$PYTHON_CMD ~/.claude/hooks/suggest-training.py"
  SETTINGS_FILE="$CLAUDE_DEST/settings.json"
  if $DRY_RUN; then
    echo -e "  ${DIM}[dry-run]${RESET} would register PostToolUse hook in ~/.claude/settings.json"
  else
    "$PYTHON_BIN" - "$SETTINGS_FILE" "$HOOK_COMMAND" <<'PYEOF'
import json, os, sys

settings_path, hook_command = sys.argv[1], sys.argv[2]
if os.path.exists(settings_path):
    with open(settings_path) as f:
        settings = json.loads(f.read())
else:
    settings = {}

hook = {"type": "command", "command": hook_command}
hooks_list = settings.setdefault("hooks", {}).setdefault("PostToolUse", [])

# Remove any existing entry for this hook (identified by script filename) so that
# reinstalling always writes the current command — prevents stale paths persisting.
updated = []
for entry in hooks_list:
    remaining = [h for h in entry.get("hooks", []) if "suggest-training.py" not in h.get("command", "")]
    if remaining:
        entry["hooks"] = remaining
        updated.append(entry)
hooks_list[:] = updated

hooks_list.append({"matcher": "Edit|Write", "hooks": [hook]})
with open(settings_path, "w") as f:
    f.write(json.dumps(settings, indent=2))

PYEOF
    echo -e "  ${MAGENTA}🤖${RESET} ~/.claude/settings.json  (PostToolUse hook)"
  fi
fi

# Collect counts from source
SKILL_COUNT=$(count_skills)
INVOCABLE_COUNT=$(count_invocable_skills)
AGENT_COUNT=$(count_items "$CLAUDE_SRC/agents")
HOOK_COUNT=$(count_files "$CLAUDE_SRC/hooks")
COMMAND_COUNT=$(count_items "$CLAUDE_SRC/commands")
SCRIPT_COUNT=$(count_files "$CLAUDE_SRC/scripts")

echo ""
echo "Installed components:"
echo "  • Agents:   ${AGENT_COUNT} specialized domain experts"
echo "  • Skills:   ${SKILL_COUNT} workflow methodologies (${INVOCABLE_COUNT} user-invocable)"
echo "  • Hooks:    ${HOOK_COUNT} automation hooks"
echo "  • Commands: ${COMMAND_COUNT} slash commands"
echo "  • Scripts:  ${SCRIPT_COUNT} utility scripts"
echo ""

if $DRY_RUN; then
  echo -e "${GREEN}${BOLD}  ✅ Dry run complete. Run without --dry-run to apply.${RESET}"
else
  echo -e "${GREEN}${BOLD}  ✅ Done. Now go do less.${RESET}"
fi
echo -e ""
