---
name: formal
description: Makes a session's responses about the project's contents better. Not a step of its own and not a block of its own. The session skill (/core:do, /core:task, /core:plan, /core:discussion) decides what the response says; formal verifies its logic, cuts what bears on nothing, and turns every reason into a proof. The concepts and the rules are in the base, Formal.lean.
disable-model-invocation: true
---

# Formal

Formal causes one thing: a response whose every claim about the project is
proved, and whose every reason is that proof. It is not a step and has no
block of its own; the session skill decides what the response says and when.

## Rules

- Nothing goes out unproved. Every claim the response makes about the contents
  is a `theorem` Lean proved from `given` or `observed`.
- A claim Lean refuses is not sent. The refusal is sent instead. A statement is
  never weakened to make it pass.
- A question goes out only with the claim that makes it necessary, proved.
- An option goes out only with what follows from it, proved from the option's
  sentence.
- Nothing goes out that bears on no claim the response makes.
- Every "because" is a proof: one sentence per step, in the proof's order.
  "Because" and "so" only for a step Lean checked, "and" for what is merely
  granted together.
- A premise goes out as its sentence, quoted, in the user's language. A
  transcription that is your reading, not the user's words, says so where it
  stands.
- Proofs go out one at a time, as "proof k of N, m remaining", the next when
  the user says so.
- A response that claims nothing about the contents says so in one line.
- No Lean goes out, and nothing about the file.
- A voiding, a retraction, or a new meaning goes out when it happened, and
  never otherwise.

## Which responses

The ones that say something about the project's contents: what is in it, what
it does, what it should be. A response about the session — which step this is,
what is running, what the file holds, a request to say something again, the
work itself — goes out as drafted. One that does both is formal for the part
about the contents.

What a command shows is the project's. That it ran is the session's.

## The file

`.lean/Session/<date>-<time>.lean`, `import Formal` above and `#audit` below,
copied from the base at the first response that needs it —
`cp -r "${CLAUDE_PLUGIN_ROOT}/skills/formal/.lean/." .lean/` — then read
`.lean/Formal.lean`, where the concepts are. Checked with
`lake -d .lean build && lake -d .lean env lean .lean/Session/<file>.lean`.
Without `lean` and `lake`, say so and stop. A session with no such response
writes no file.
