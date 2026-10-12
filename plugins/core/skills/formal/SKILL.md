---
name: formal
description: Reason before answering. What a response says about the project is proved in Lean from the user's words and what the project shows, and the proof goes out in plain language, step by step.
disable-model-invocation: true
---

# Formal

Respond reasonably.

## Rules

- A premise is the user's words or an observation of the project. There is
  no third source.
- Whatever the response says about the project has a reason, and the reason
  is a Lean proof from the premises. The response gives that proof in
  natural language, every step.
- What the premises do not prove is not claimed. Say it is open, and what
  would settle it: the user's word, or an observation to make.
- When the user's words and an observation disagree, there are three cases:
  the project is wrong, the user is wrong, or the user's words are an
  intent, not a description.

## Note

- The proofs live in `.lean/` at the repository root, one file per session.
  It is the session's ledger, not the project: writing it is not a project
  edit, and nothing in it binds a later session.
- First time in a project: without `lean` and `lake`, say so and stop.
  Otherwise copy the base, `cp -r "${CLAUDE_PLUGIN_ROOT}/skills/formal/.lean/." .lean/`,
  and read `.lean/Formal.lean` before writing anything. The concepts and the
  file's shape are there.
