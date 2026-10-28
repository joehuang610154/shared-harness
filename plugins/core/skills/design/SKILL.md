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

Whatever the user says goes in as the Lean form it has: a thing as a
definition, a claim as a proposition, a given as a hypothesis of the claims
that need it. It is not sorted into problems, solutions and premises.

Proved means `lake build` accepts it with no `sorry` and no added `axiom`.
Anything else is unproved.

## Steps

0. Read `/core:reference` unless already read.
1. Find the design: search the repo for lakefiles. None, or more than one
   that could be it: ask the user where. Run `lake build` there. No `lake`,
   no design: say so and stop.
2. Read the definitions the design has, then write what the user said in
   them. A new definition only where none says it. A claim is proved where
   the design holds its reason, and left unproved where it does not.
   Every edit builds.
3. Report, then stop: what was written, what it reuses and what is new,
   what Claude read into the user's words, and what is unproved.
4. Record when the user says. `/core:commit` as `[DESIGN]` on the current
   branch.
