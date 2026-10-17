---
name: design
description: Run a Design session. Write the user's design as a Lean project under design/, building after every edit, and commit only on the user's word.
disable-model-invocation: true
---

# Design

The design is the Lean project in `design/`: the user's words, written as
propositions, and what Lean derives from them. Nothing else goes in.

What Claude contributes, a goal, a what-if or a rule of its own, is a
hypothesis: a module the design's root does not import. It builds like the
rest, and joins the design only on the user's word.

## Steps

0. Read `/core:reference` unless already read.
1. Run `lake build` in `design/`. No `lake`, no design: say so and stop.
   No `design/` yet: start an empty Lake project there.
2. Write what the user's message settles. Material they point to, such as
   a plan or a demo, is a base to draw on, not settled: bring it in one
   concept at a time, a whole before its parts. Every edit builds.
3. Report, then stop: what was written, what Claude read into the user's
   words, what Lean shows follows, and what looks wrong, as questions.
   What Lean has not shown is called unproved.
4. Record when the user says. `/core:commit` as `[DESIGN]` on the current
   branch.
