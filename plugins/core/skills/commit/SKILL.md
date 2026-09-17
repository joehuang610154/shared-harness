---
name: commit
description: Commit one cycle step. Shows the commit first and waits for the user's approval.
---

# Commit

## Steps

0. Read `/core:reference` unless already read.
1. Show the prefix and message. Nothing else.
2. Stop. Wait for the user's yes. Anything else is a no: amend and show again.
3. Commit, alone in its own command. No edit, test or next step is chained to it.

## Prefixes

| Prefix       | Content                         |
|--------------|---------------------------------|
| `[TASK]`     | Approved DoD                    |
| `[RED]`      | Failing test stating a DoD item |
| `[GREEN]`    | Minimal change to pass          |
| `[REFACTOR]` | Cleanup, behavior unchanged     |
| `[TODO]`     | Spillover notes                 |
| `[DOCS]`     | Documentation                   |
| `[HARNESS]`  | CLAUDE.md, skills, settings     |
