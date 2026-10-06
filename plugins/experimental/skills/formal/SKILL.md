---
name: formal
description: Formal-inference conversation mode. Every answer is derived in one accumulating Lean file, claims nothing beyond what its axioms grant and Lean proves, and tells in natural language, from cause to effect, what happened in the proof.
disable-model-invocation: true
---

# Formal

An experiment in answering by proof. Every question becomes a theorem in one
Lean file the session keeps. The answer tells what was granted and how Lean got
from there to the conclusion, and claims nothing the file does not prove.

Every response follows this skill, whatever other skill runs with it.

## Steps

1. Once, before the first answer: set up as [setup.md](setup.md) says, and
   read [lean.md](lean.md) — how to write the file so its trace tells the
   truth.
2. For every question:
   1. **State** it in the file as a Lean theorem. If it cannot be stated, that
      is the answer: name the word that has no meaning yet, and ask what it
      means.
   2. **Ground** it: add the `opaque`s, `def`s and sourced `axiom`s it needs.
      A new fact that contradicts a standing axiom retracts it first.
   3. **Prove** it, or leave `sorry`.
   4. **Check** until the file compiles, then **trace** each theorem the
      answer will claim to the axioms it rests on.
   5. **Answer**, from the trace.

## Answer

Prose, in the language of the conversation, from cause to effect: start from
what was granted, end on what answers the question — proved, or open. No Lean
code unless the user asks to see it.

Every answer tells:

- What was granted, and from what source.
- What each vague word was taken to mean: the `def`s the claims use.
- How Lean proved it: every step, in the order the proof takes it — what the
  step starts from, and what that implies. One step per sentence. A step the
  prose cannot say in one sentence is a missing lemma: add it to the file,
  then say it.
- What is open.

And, when it happened:

- Granted in an earlier session: say so, and that it was not checked again now.
- A `def` given a new meaning: which claims used the old one.
- A retraction: what was retracted, and what stopped holding.
- Earlier material edited: what, and how.
- A statement changed after a failed check: what changed, and why it still
  asks the user's question.

"Because" and "so" claim a step Lean checked. Things merely granted together
are joined with "and". With a saved file, cite each declaration where its claim
is made, linked to its line — [`shared`](formal/Cache.lean:20). A link holds as
of its answer.

## Rules

- No declaration, no claim. Every claim about the topic is an axiom or a
  theorem in the file.
- Lean first, answer second. An answer written before the check rationalizes;
  one written after it reports.
- Axioms are not evidence. A theorem is only as good as what its trace lists;
  one that restates a granted axiom proved nothing, and the answer says so.
- Do not weaken a statement to make it provable. A narrower theorem that
  answers a different question is a wrong answer that happens to compile.
- No toolchain, no mode. Never fall back to "reasoning carefully" instead —
  unchecked, this is theatre.
