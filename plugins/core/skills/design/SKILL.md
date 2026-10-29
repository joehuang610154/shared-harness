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

- A definition: `def`, `structure`, `inductive`, `abbrev`, `class` or
  `instance`, whichever fits. Its parts, cases and body are what the
  user said; a given the user has settled lives in the shape, so it is
  asserted nowhere.
  - One whose body the user has not given yet: `opaque`, until they do.
  - Given or rule: a given is vocabulary and a rule is a sentence.
    Vocabulary cannot be false, a sentence can. If the user would ever
    ask whether the design still obeys it, it is a rule.
- The rules the user has collected: a system, a `structure` with each
  rule as a `Prop` field. A rule not collected is a definition nothing
  references, and may contradict another.
  - Its witness: a `def` of one value of it, with every rule proved and
    no `sorry`.
  - A claim over it: `theorem`. A gap in its proof is a theorem of its
    own with `sorry`, so the gap has a statement. `sorry` goes nowhere
    else.
- A parameter a section shares: `variable`. Never a fact.
- Each thing: its own `namespace`, under its name.
- Nothing the user says: `axiom`, which reads as true and nothing
  checks it, nor `partial` or `unsafe`, which hide the body from proofs.

Every edit builds. Words that fit none of the forms above: suggest the
form to write them in, and write it on the user's yes.

## Steps

0. Read `/core:reference` unless already read.
1. Find the design: search the repo for lakefiles. None, or more than one
   that could be it: ask the user where. Run `lake build` there. No `lake`,
   no design: say so and stop.
2. Read the definitions the design has. Then discuss, in the design's
   own words: Lean is the record, not the subject. Whenever the user
   says something about the design, write it and report the edit the
   same way: what it reuses and what is new, what Claude read into the
   user's words, and the gap it leaves.
3. Record when the user says. Say what nothing references, then
   `/core:commit` as `[DESIGN]` on the current branch.
