#!/bin/sh
# UserPromptSubmit. While the project has a .lean/ ledger, formal is on:
# every response is made better by the skill before it goes out. Delete
# .lean/ to turn it off.
[ -d "${CLAUDE_PROJECT_DIR:-.}/.lean" ] || exit 0
printf 'Formal is on. Before this response goes out, make it better by %s/skills/formal/SKILL.md: logic verified in .lean/, the unrelated cut, every reason a proof. It stays the response of the session skill; formal has no block of its own.\n' "$CLAUDE_PLUGIN_ROOT"
