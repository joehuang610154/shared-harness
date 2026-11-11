---
name: commit
description: Commit one cycle step. Commits without asking and tells the user the message.
---

# Commit

## Steps

0. Read `/core:reference` unless already read.
1. Commit, alone in its own command. No edit, test or next step is chained to it.
2. Tell the user the prefix and message.

## Prefixes

| Prefix       | Content                         |
|--------------|---------------------------------|
| `[RED]`      | Failing test stating a DoD item |
| `[GREEN]`    | Minimal change to pass          |
| `[REFACTOR]` | Cleanup, behavior unchanged     |
| `[TODO]`     | Spillover notes                 |
| `[DOCS]`     | Documentation                   |
| `[DESIGN]`   | Approved design                 |
| `[HARNESS]`  | CLAUDE.md, skills, settings     |
