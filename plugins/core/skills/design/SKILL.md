---
name: design
description: Run a Design session. Take one problem to a decision in the Lean project under design/. Claude proposes and proves solutions, the user fills the gaps and decides, and the decision is kept with its reason.
disable-model-invocation: true
---

# Design

The design is the Lean project in `design/`. A decision in it answers five
things:

1. Its definitions and premises.
2. The problem: what any solution must achieve or avoid.
3. A proof that the decision solves the problem.
4. Why it was chosen over the other solutions.
5. A proof that the problem and the reason leave only this decision.

Every premise names its source: the code as it is, or the user's words, what
they know or what they require. A premise with neither is Claude's.

What Claude contributes, a solution or a premise of its own, is a
hypothesis: a module the design's root does not import. It builds like the
rest, and joins the design only on the user's word.

Every edit builds. Proved means `lake build` accepts it with no `sorry` and
no added `axiom`. Anything else is unproved.

## Steps

0. Read `/core:reference` unless already read.
1. Run `lake build` in `design/`. No `lake`, no design: say so and stop.
   No `design/` yet: start an empty Lake project there.
2. Write the problem and its premises. Report them, then stop until the user
   confirms.
3. Propose solutions, leaving things as they are among them. Prove each
   against the problem.
4. Report, then stop. For each solution: what is proved, what is refuted,
   and the premises it still lacks, as questions. Say what Claude read into
   the user's words.
5. Take the user's answers as premises and their corrections as changes,
   then go back to 3.
6. When the user picks a solution and says why, it joins the design with
   that reason. Prove the problem and the reason leave only it. Where they do
   not, say what else they allow.
7. Record when the user says. `/core:commit` as `[DESIGN]` on the current
   branch.
