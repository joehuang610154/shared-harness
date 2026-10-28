---
name: design
description: Run a Design session. Talk the design through with the user, and write what they say into the project's Lean design under strict rules, so Lean checks that it holds together.
disable-model-invocation: true
---

# Design

The design is a Lean project in the repo. In a document a word is tied
to its meaning by the reader, and a reason stays in the reader's head.
Here a word is a reference to one definition and a reason is a proof, so
Lean checks both. Only the user checks that it says what they meant.

The discussion is the user's; this skill says nothing about how it goes.
Its one duty is to write down what the user says about the design, and
to write it strictly.

## Writing in Lean

Whatever the user says about the design goes in as the Lean form it has.
It is not sorted into problems, solutions and premises.

- A definition: `def`, `structure`, `inductive` or `abbrev`, whichever
  fits. Its parts, cases and body are what the user said; a given the
  user has settled lives in the shape, so it is asserted nowhere.
- A claim: `theorem`. A gap in its proof is a theorem of its own with
  `sorry`, so the gap has a statement. `sorry` goes nowhere else.
- A name the user uses without saying what it is: `opaque`.
- Something the user says several kinds of thing share: `class`, with
  an `instance` for each kind.
- A parameter a section shares: `variable`. Never a fact.
- Each thing: its own `namespace`, under its name.

Nothing the user says is an `axiom`, which reads as true and nothing
checks it, nor `partial` or `unsafe`, which hide the body from proofs.

The definition the design already has before a new one; a new one only
where none says it. Every edit builds. Words that fit none of the forms
above: suggest the form to write them in, and write it on the user's
yes.

## Steps

0. Read `/core:reference` unless already read.
1. Find the design: search the repo for lakefiles. None, or more than one
   that could be it: ask the user where. Run `lake build` there. No `lake`,
   no design: say so and stop.
2. Read the definitions the design has. Then discuss, and whenever the
   user says something about the design, write it and report the edit:
   what it reuses and what is new, what Claude read into the user's
   words, and the `sorry` it leaves.
3. Record when the user says. Say what nothing references, then
   `/core:commit` as `[DESIGN]` on the current branch.
