---
name: formal
description: Makes a session's responses about the project's contents better. Not a step of its own and not a block of its own. The session skill (/core:do, /core:task, /core:plan, /core:discussion) decides what the response says; formal verifies its logic, cuts what bears on nothing, and turns every reason into a proof. The concepts and the rules are in the base, Formal.lean.
disable-model-invocation: true
---

# Formal

Formal does no work of its own and has no block of its own. It makes the
response the session skill would give better. The session skill decides what
the response says and when; formal works on that response before it goes
out, through `.lean/`. The concepts and the rules are in `.lean/Formal.lean`.
This is only the steps.

## Which responses

The ones that say something about the project's contents: what is in it, what
it does, what it should be. A response about the session — which step this is,
what is running, what the file holds, a request to say something again, the
work itself — goes out as drafted. One that does both is formal for the part
about the contents.

What a command shows is the project's. That it ran is the session's.

## Once, at the first such response

1. `lean` and `lake` on the path. Without them, say so and stop.
2. Copy the base over the project's: `cp -r "${CLAUDE_PLUGIN_ROOT}/skills/formal/.lean/." .lean/`
3. Read `.lean/Formal.lean`.
4. Create `.lean/Session/<date>-<time>.lean`: `import Formal`, then `#audit`.

A session with no such response writes no file.

## Every such response

Draft the response the session skill asks for. Before it goes out:

1. **Verify the logic.** Every claim the draft makes about the project goes
   into the file as a `theorem`, above `#audit`, with what it rests on as
   `given` or `observed`. What follows from an option is such a claim, with
   the option's sentence as hypothesis, proved before the option is offered.
   A `given` holds what the user meant: a choice resolved to the option
   chosen, a pointer to what it points at. Run
   `lake -d .lean build && lake -d .lean env lean .lean/Session/<file>.lean`.
   A claim Lean refuses is not sent; the refusal is said instead, as part of
   the answer. Never weaken a statement to make it pass.
2. **Filter.** Cut what bears on no claim the response makes. The premises
   that remain are the ones a proof uses.
3. **Prove the reason.** Every "because" in the response is the proof of
   that claim: one sentence per step, in the proof's order. "Because" and
   "so" only for a step Lean checked; "and" for things merely granted
   together. A premise is quoted as its sentence; where the transcription is
   your reading rather than the user's words, say so there. Nothing rests on
   the reader taking your word.
4. **Keep it the session's response.** In the user's language, with the
   user's words quoted, and no Lean in it. A response may rest on several
   proofs; each is the proof of a claim the response makes. Give them one
   at a time, as "proof k of N, m remaining", the next when the user says
   so. That something was voided, retracted, or given a new meaning is said
   only when it happened.

The file is the instrument for this, and the record if the user asks for
one. The response is never about the file.
