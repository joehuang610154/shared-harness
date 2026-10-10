---
name: formal
description: Settle every statement about the project by proof or by the user's grant, never alone. One Lean file holds what is granted, what is proved, and what is open.
disable-model-invocation: true
---

# Formal

Every statement about the project is open until settled. Lean settles
inference. The user settles meaning. You settle nothing.

Needs `lean` on the path. Without it, say so and stop. Reasoning carefully
instead is theatre.

## The file

One Lean file per project, in the repo. Every claim about the project is a
declaration in it: a `def`, an `axiom`, or a `theorem`. No declaration, no
claim.

Each turn: put what was said into the file, the user's words as axioms and
your claims as theorems, run `lean`, then report.

## Axioms

An axiom comes from two sources only, and says which:

- **The user's words.** Admitted once the user confirms the transcription.
- **An observation of the repo.** Admitted with the check that reproduces it:
  a file and line, or a command and its output. Void when what it cites
  changes, until rerun.

Each axiom is a description or an intent, and the two are separate types.
"Should X" and "not X" is not a contradiction. It is a gap, and a gap is a
task.

Your own belief is never an axiom. You disagree only by observation or by
proof.

## Settling

- A theorem Lean proves is settled. It follows from what was already
  granted, so it needs no approval.
- A `def`, an axiom from the user's words, and the statement of any theorem
  hold only after the user has checked that they say what was meant. Lean
  cannot check meaning.
- A theorem with `sorry` is open. Nothing rests on it.

## Contradiction

`False` voids every theorem until an axiom is retracted. Lean says the set is
wrong, not which member. An axiom is retracted by whoever admitted it: an
observation by its check failing on rerun, the user's word by the user. Rerun
the observations first, then bring the user what still contradicts.

## Writing Lean

- One concept, one type. Two concepts with two directions each are four
  cases, and every match covers all four or Lean refuses it.
- Never weaken a statement to make it provable. A narrower theorem that
  answers a different question is a wrong answer that compiles.
- Lean first, answer second. An answer written before the check
  rationalizes; one written after it reports.

## Report

After every check, in prose: what is newly defined, granted, and stated, for
the user's check. What was proved, and from which axioms. What is open. What
was voided or retracted, and what stopped holding with it.
