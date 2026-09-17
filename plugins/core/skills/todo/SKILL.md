---
name: todo
description: Read the TODO list whole, delete what is done or obsolete, and name the route for what remains. Called by the user or by Claude, at any time.
---

# Todo

The list is `docs/todo.md`. One file, read in one pass.

## Item

- What to do.
- Why it should be done.

Nothing else. No status, no owner, no date.

## Steps

0. Read `/core:reference` unless already read.
1. Read `docs/todo.md` whole. Never a sample.
2. Say what each item is now, with evidence:
   - **Done.** Later work already met it. Name what met it.
   - **Obsolete.** Its reason no longer holds. Say why.
   - **Alive.** Name its route.
3. Propose deleting every done and obsolete item. The user's yes deletes them.
4. An alive item stays on the list only with the user's approval. Otherwise, it
   goes to its route now, or is deleted.
5. `/core:commit` as `[TODO]`.

## Routes

Route by what the item is missing.

| Missing                             | Route                                   |
|-------------------------------------|-----------------------------------------|
| An answer                           | Discussion                              |
| A shape, or too big for one session | Plan                                    |
| Only the work                       | Task, or a DoD item in a Task on that ground |
| Nothing                             | Delete                                  |

## Rules

- Clearing an item is deleting it. No checkmark, no strikethrough, no done
  section. A list that keeps its dead entries is a history, and a history is
  not read.
- Neither a Discussion nor a Plan closes an item. A Discussion turns it into
  a stated answer; a Plan absorbs it into a picture. The item stays on the
  list until the Task lands or it is deleted.
- Two things never enter the list: what a future Task obviously meets, and
  what should have been done in the session that found it.
