#!/usr/bin/env bash
# install.sh [target-repo]
#   no arg  -> installs the skill for Claude Code, user-wide (~/.claude/skills)
#   arg     -> copies Cursor rules + skill into that repo
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
"$ROOT/scripts/build.sh" >/dev/null

if [ $# -eq 0 ]; then
  DEST="${CLAUDE_HOME:-$HOME/.claude}/skills/engineering-standards"
  mkdir -p "$(dirname "$DEST")"
  rm -rf "$DEST"
  cp -r "$ROOT/skills/engineering-standards" "$DEST"
  echo "installed skill -> $DEST"
else
  TARGET="$1"
  [ -d "$TARGET" ] || { echo "no such directory: $TARGET" >&2; exit 1; }
  mkdir -p "$TARGET/.cursor/rules" "$TARGET/.claude/skills"
  cp "$ROOT/.cursor/rules/"*.mdc "$TARGET/.cursor/rules/"
  rm -rf "$TARGET/.claude/skills/engineering-standards"
  cp -r "$ROOT/skills/engineering-standards" "$TARGET/.claude/skills/"
  echo "installed -> $TARGET/.cursor/rules/ and $TARGET/.claude/skills/"
fi
