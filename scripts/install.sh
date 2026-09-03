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
  mkdir -p "$TARGET/.cursor/rules" "$TARGET/.claude/skills" "$TARGET/.github/instructions"
  cp "$ROOT/.cursor/rules/"*.mdc "$TARGET/.cursor/rules/"
  cp "$ROOT/.github/copilot-instructions.md" "$TARGET/.github/"
  cp "$ROOT/.github/instructions/"*.instructions.md "$TARGET/.github/instructions/"
  if [ -e "$TARGET/AGENTS.md" ]; then
    HAD_AGENTS=1
  else
    HAD_AGENTS=0
    cp "$ROOT/AGENTS.md" "$TARGET/"
  fi
  rm -rf "$TARGET/.claude/skills/engineering-standards"
  cp -r "$ROOT/skills/engineering-standards" "$TARGET/.claude/skills/"
  echo "installed -> $TARGET: .cursor/rules/, .github/, .claude/skills/"
  [ "$HAD_AGENTS" -eq 0 ] || echo "note: AGENTS.md already existed, left untouched — merge by hand"
fi
