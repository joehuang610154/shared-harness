#!/bin/sh
# UserPromptSubmit. While the project has a .lean/ ledger, formal is on:
# remind every response to follow the skill. Delete .lean/ to turn it off.
[ -d "${CLAUDE_PROJECT_DIR:-.}/.lean" ] || exit 0
printf 'Formal is on. Follow %s/skills/formal/SKILL.md for this response.\n' "$CLAUDE_PLUGIN_ROOT"
