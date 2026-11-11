---
name: commit
description: Commit one cycle step. Commits without asking and tells the user the message.
---

# Commit

## Steps

0. Read `/core:reference` unless already read.
1. Check the changes: read the diff and the status. Only what belongs to this
   step goes in; anything else is a problem to raise, not to commit.
2. Commit, alone in its own command. No edit, test or next step is chained to it.
3. Tell the user the prefix and message.

## Prefixes

| Prefix       | Content                                 |
|--------------|-----------------------------------------|
| `[RED]`      | Failing test stating one case of a rule |
| `[GREEN]`    | Minimal change to pass                  |
| `[REFACTOR]` | Cleanup, behavior unchanged             |
| `[DOCS]`     | Documentation                           |
| `[DESIGN]`   | Approved design                         |
| `[HARNESS]`  | CLAUDE.md, skills, settings             |
