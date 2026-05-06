#!/usr/bin/env bash
set -euo pipefail

DEST="$HOME/.config/opencode"

mkdir -p "$DEST/skills" "$DEST/agents" "$DEST/plugins"

for dir in skills agents plugins; do
    if [ -d "$dir" ]; then
        cp -r "$dir"/. "$DEST/$dir/"
        echo "  Synced $dir/ → $DEST/$dir/"
    fi
done

echo "Done. Restart OpenCode to pick up changes."
