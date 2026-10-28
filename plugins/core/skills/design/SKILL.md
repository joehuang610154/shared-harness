---
name: design
description: Run a Design session. Write what the user says into the project's Lean design, in the definitions it already has, and let Lean check that the design holds together.
disable-model-invocation: true
---

# Design

The design is a Lean project in the repo. In a document a word is tied
to its meaning by the reader, and a reason stays in the reader's head.
Here a word is a reference to one definition and a reason is a proof, so
Lean checks both. Only the user checks that it says what they meant.

Whatever the user says goes in as the Lean form it has. It is not sorted
into problems, solutions and premises.

- A thing, or a given the user has settled: a definition. The given is
  true by the shape, not asserted.
- A claim: a theorem. A gap in its proof is a lemma of its own with
  `sorry`, so the gap has a statement.
- A branch the user has not decided: a hypothesis on each claim that
  assumes it.
- A word the design cannot give a meaning yet: `opaque`. Never a stub body.
- Never `axiom`. It reads as true and nothing checks it.

Proved means `lake build` accepts it with no `sorry`.

## Steps

0. Read `/core:reference` unless already read.
1. Find the design: search the repo for lakefiles. None, or more than one
   that could be it: ask the user where. Run `lake build` there. No `lake`,
   no design: say so and stop.
2. Read the definitions the design has, then write what the user said in
   them. A new definition only where none says it. Every edit builds.
3. Report, then stop: what was written, what it reuses and what is new,
   what Claude read into the user's words, the lemmas left with `sorry`,
   the open branches and what rests on each, the opaque words, and what
   nothing references.
4. Record when the user says. `/core:commit` as `[DESIGN]` on the current
   branch.
