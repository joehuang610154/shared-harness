---
name: formal
description: Settle every statement about the project by proof or by the user's grant, never alone. A Lean project under .lean holds what is granted, what is proved, and what is open, and its base refuses what the rules forbid.
disable-model-invocation: true
---

# Formal

Every statement about the project is open until settled. Lean settles
inference. The user settles meaning. You settle nothing.

Needs `lean` and `lake` on the path. Without them, say so and stop. Reasoning
carefully instead is theatre.

## The project

`.lean/` at the repository root is a Lean project. Its base is this skill's
`.lean/` folder. Copy that folder over it at the start of every session, so
the base tracks the skill:

    cp -r "${CLAUDE_PLUGIN_ROOT}/skills/formal/.lean/." .lean/

Each session writes one file, `.lean/Session/<date>-<time>.lean`. It starts
with `import Formal` and ends with `#audit`. Earlier sessions are never
imported, and never read unless the user asks; a conclusion from one enters
the new file as an observation citing the old file. Any session file may be
deleted at any time.

Run, from the repository root:

    lake -d .lean build && lake -d .lean env lean .lean/Session/<file>.lean

Each turn: put what was said into the file, the user's words as `given` and
your claims as `theorem`, run it, then report.

## What the base refuses

The rules Lean can check are in `Formal.lean`, as refusals. Read it once.

- An axiom with no source. `given` and `observed` are the only ways to admit
  one, and `#audit` fails on a raw `axiom`.
- An intent that is not a `Should …`, or a description that is. The two are
  separate types, so "should X" and "not X" never meet in `False`. They meet
  in `Gap`, and a gap is a task.
- An observation whose quoted text is no longer on its cited line. The file
  is read on every compile, so a changed file voids what cited it.
- A theorem resting on a foreign axiom, such as the one `native_decide`
  brings.
- A proved `False`. `#audit` names the axioms it rests on.

## Axioms

- `given <kind> <name> : <prop>` is the user's words. It holds once the user
  confirms the transcription.
- `observed <kind> <name> : <prop> at "<file>" <line> "<text>"` is the
  repository, checked on every compile. `… from "<command>" "<output>"`
  records a command's output; rerun it yourself.

The kind is `description` or `intent`. Your own belief is never an axiom.
You disagree only by observation or by proof.

## Settling

- A theorem Lean proves is settled. It follows from what was already
  granted, so it needs no approval.
- A `def`, a `given`, and the statement of any theorem hold only after the
  user has checked that they say what was meant. Lean cannot check meaning.
- A theorem with `sorry` is open. Nothing rests on it.

## Contradiction

A proved `False` voids every theorem until an axiom is retracted. Lean says
the set is wrong, not which member. An axiom is retracted by whoever admitted
it: an observation by its check failing, the user's word by the user. Rerun
the command observations first, then bring the user what still contradicts.

## Writing Lean

- One concept, one type. Two concepts with two directions each are four
  cases, and every match covers all four or Lean refuses it.
- Never weaken a statement to make it provable. A narrower theorem that
  answers a different question is a wrong answer that compiles.
- Lean first, answer second. An answer written before the check
  rationalizes; one written after it reports.

## Report

After every run, in prose, from the `#audit` output: what is newly defined,
given, and stated, for the user's check. What was proved, and from which
axioms. What is open. What was voided or retracted, and what stopped holding
with it.
