---
name: formal
description: Per-response procedure, run alongside the session skill (/core:do, /core:task, /core:plan, /core:discussion). Every answer is written into a Lean file, checked, and reported from Lean's audit, one proof at a time. The concepts and the rules are in the base, Formal.lean.
disable-model-invocation: true
---

# Formal

Runs on every response, with whatever session skill is running. The
concepts and the rules live in `.lean/Formal.lean`. This is only the steps.

While `.lean/` exists, a hook in this plugin repeats these steps to every
response. Delete `.lean/` to turn formal off.

## Once, at the first response

1. `lean` and `lake` on the path. Without them, say so and stop.
2. Copy the base over the project's: `cp -r "${CLAUDE_PLUGIN_ROOT}/skills/formal/.lean/." .lean/`
3. Read `.lean/Formal.lean`.
4. Create `.lean/Session/<date>-<time>.lean`: `import Formal`, then `#audit`.

## Every response

1. Write what was said into the file, above `#audit`: the user's words as
   `given`, what you looked up as `observed`, what you answer as `theorem`.
   Each with its sentence.
2. Run `lake -d .lean build && lake -d .lean env lean .lean/Session/<file>.lean`.
   A refusal is part of the answer. Never weaken a statement to pass.
3. Report from the audit output, nothing else:
   1. The new words, premises, and claims, each as its sentence, for the
      user's check.
   2. One proof, as "proof k of N, m remaining": the claim, what it rests
      on, then the steps, one sentence each, in the proof's order. "Because"
      and "so" only for a step Lean checked; "and" for things merely granted
      together.
   3. When it happened: what is open, what was voided or retracted and what
      stopped holding with it, a word given a new meaning, a statement
      changed after a failed check.
4. The next proof when the user says so.
