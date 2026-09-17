---
name: task
description: Run a Task session. Implement one idea in one session against an approved DoD, with TDD and prefixed commits on a git-flow feature branch.
---

# Task

## Steps

0. Read `/core:reference` unless already read.
1. Draft the DoD. Each item must be checkable by a command, a test, or an
   observable behavior. "Works correctly" is not allowed;
   "the test suite passes and X renders Y on input Z" is.
2. Wait for the user's approval. No implementation before it.
   Then `git flow feature start <name>` and `/core:commit` the DoD as `[TASK]`.
3. Size check. If the DoD cannot be met in one session, stop and convert to a Plan.
4. Implement with TDD, per DoD item. Every step ends with `/core:commit`:
   - `[RED]` failing test that states the DoD item. It compiles against
     minimal stubs and fails on its assertion.
   - `[GREEN]` minimal change making it pass.
   - `[REFACTOR]` cleanup, behavior unchanged, tests still green. Required part
     of the cycle; skip only when there is nothing to clean, and say so.
     Scope: structure the Task touched or exposed, separation included.
     No new rules.
   Discoveries outside the DoD do not enter the change. A behavior-preserving
   fix waits for `[REFACTOR]`; everything else goes to step 7.
5. Verify. Run each DoD item literally. Report pass/fail per item with output.
6. Report and wait for the user's explicit close.
   - All pass: `git flow feature finish`.
   - Any fail: fix in session, or record the failed items and why.
     No partial "done". Branch stays open.
7. Spillover. Add what this Task found to `docs/todo.md`. Recording an item
   needs the user's approval.

## Testing

- A DoD item is normally backed by one integration test that states it.
- Test names read as statements, e.g.
  `player_ends_turn_with_no_moves_left_then_enemy_phase_starts`, not `test_turn_2`.
