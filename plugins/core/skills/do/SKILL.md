---
name: do
description: Run a Do session. Implement one system of the project's Lean design, with TDD and prefixed commits on a git-flow feature branch.
---

# Do

The design is the DoD. Every rule the code must hold is a `Prop` field
of a rule set in the Lean design, proved in its witness. This skill
drafts no DoD and asks for none to be approved: that was `/core:design`.

## Steps

0. Read `/core:reference` unless already read.
1. Find the design: search the repo for lakefiles. None, or more than one
   that could be it: ask the user where. Run `lake build` there. No `lake`,
   no design: say so and stop.
2. Read the system this session implements. The request names it; if
   not, ask which. One system, or one sub-rule set of it, per session.
3. Discuss the implementation with the user: the language, the structure,
   and whatever else the code needs decided. Nothing is implemented
   before the user confirms it. The design says what the system is;
   these are the user's choices about how it is coded.
4. `git flow feature start <name>`.
5. Implement with TDD, per rule. A rule is a test group under the rule's
   name. Each test states one case of the rule, named as a statement.
   Every step ends with `/core:commit`:
   - `[RED]` failing test stating one case. It compiles against minimal
     stubs and fails on its assertion.
   - `[GREEN]` minimal change making it pass.
   - `[REFACTOR]` cleanup, behavior unchanged, tests still green. Required
     part of the cycle; skip only when there is nothing to clean, and say
     so. Scope: structure this session touched or exposed. No new rules.
   A rule that rests on a `sorry` theorem or an `opaque` definition is a
   gap the user left. Implement up to it, say which gap, and stop there.
   Filling it is `/core:design`.
6. Verify. Run the tests. Report pass or fail per rule, with output.
7. Report and wait for the user's explicit close.
   - All pass: `git flow feature finish`.
   - Any fail: fix in session, or record the failed rules and why.
     No partial "done". Branch stays open.

## Testing

- Test names read as statements, e.g.
  `player_ends_turn_with_no_moves_left_then_enemy_phase_starts`, not `test_turn_2`.
