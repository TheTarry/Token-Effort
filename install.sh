#!/usr/bin/env bash
set -euo pipefail

BOLD="\033[1m"
GREEN="\033[32m"
CYAN="\033[36m"
YELLOW="\033[33m"
MAGENTA="\033[35m"
RED="\033[31m"
RESET="\033[0m"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ---------------------------------------------------------------------------
# copy_dir <src_dir> <dest_dir> <label>
#
# Recursively copies all files from src_dir to dest_dir, printing each file.
# ---------------------------------------------------------------------------
copy_dir() {
  local src="$1"
  local dest="$2"
  local label="$3"

  [[ -d "$src" ]] || return 0

  while IFS= read -r -d '' file; do
    local rel="${file#$src/}"
    local target="$dest/$rel"
    mkdir -p "$(dirname "$target")"
    cp "$file" "$target"
    echo "  ${label} ~/${dest##$HOME/}/${rel}"
  done < <(find "$src" -type f -print0)
}

# ---------------------------------------------------------------------------
# install_copilot — copies copilot/* to ~/.github and ai/* to ~/.ai
# ---------------------------------------------------------------------------
install_copilot() {
  local dest="$HOME/.github"
  echo -e "\n${CYAN}${BOLD}🐙 Installing GitHub Copilot customisations...${RESET}"
  echo -e "${YELLOW}   Target : $dest${RESET}"

  local count=0

  copy_dir "$SCRIPT_DIR/copilot" "$dest" "🐙"
  count=$(find "$SCRIPT_DIR/copilot" -type f | wc -l)

  copy_dir "$SCRIPT_DIR/ai" "$HOME/.ai" "🤖"
  count=$(( count + $(find "$SCRIPT_DIR/ai" -type f | wc -l) ))

  echo -e "\n${GREEN}${BOLD}  ✅ Copilot: $count file(s) installed${RESET}"
}

# ---------------------------------------------------------------------------
# install_claude — copies claude/* to ~/.claude and ai/* to ~/.ai
# ---------------------------------------------------------------------------
install_claude() {
  local dest="$HOME/.claude"
  echo -e "\n${MAGENTA}${BOLD}🤖 Installing Claude Code customisations...${RESET}"
  echo -e "${YELLOW}   Target : $dest${RESET}"

  local count=0

  copy_dir "$SCRIPT_DIR/claude" "$dest" "🤖"
  count=$(find "$SCRIPT_DIR/claude" -type f | wc -l)

  copy_dir "$SCRIPT_DIR/ai" "$HOME/.ai" "🤖"
  count=$(( count + $(find "$SCRIPT_DIR/ai" -type f | wc -l) ))

  echo -e "\n${MAGENTA}${BOLD}  ✅ Claude: $count file(s) installed${RESET}"
}

# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------
echo -e ""
echo -e "${BOLD}${CYAN}  🪙  Token Effort${RESET}"
echo -e "${YELLOW}  Low-stakes intelligence for high-latency humans${RESET}"
echo -e ""
echo -e "  Which platform(s) would you like to set up?"
echo -e ""
echo -e "  ${BOLD}[1]${RESET} 🐙 GitHub Copilot   ${YELLOW}(~/.github)${RESET}"
echo -e "  ${BOLD}[2]${RESET} 🤖 Claude Code       ${MAGENTA}(~/.claude)${RESET}"
echo -e "  ${BOLD}[3]${RESET} ✨ Both              ${GREEN}(why not)${RESET}"
echo -e ""

while true; do
  read -r -p "  Enter choice [1-3]: " choice
  case "$choice" in
    1) install_copilot; break ;;
    2) install_claude;  break ;;
    3) install_copilot; install_claude; break ;;
    *) echo -e "  ${RED}That's not a valid option. Try 1, 2, or 3.${RESET}" ;;
  esac
done

echo -e ""
echo -e "${GREEN}${BOLD}  Done. Now go do less.${RESET}"
echo -e ""
