---
name: design
description: Run a Design session. Write the user's ideas down in Lean, one file per topic, changing, checking and asking until every idea they mentioned is written down.
disable-model-invocation: true
---

# Design

The user gives ideas. You write them down in Lean. Lean checks that the file
compiles. Only the user checks that it says what they meant.

## Steps

0. Read `/core:reference` unless already read.
1. Check `lean --version`. No Lean, no design.
2. Name the topic. One sentence. Its file is `design/<Topic>.lean`; continue
   it if it exists.
3. Draft, check, ask, write — again after every answer, until every idea the
   user has mentioned is written down.
   - Draft: a change to the file — what the user said, or a revision of
     what is written.
   - Check: apply it to a scratchpad copy of the file and run `lean` on it.
   - Ask: show the change and Lean's result, and ask the user to check it.
     Ask too about what they mentioned that is not written down yet.
   - Write: only what the user approved goes into `design/<Topic>.lean`.
4. Record, when the user closes. `/core:commit` as `[DESIGN]` on the current branch.

## Rules

- Never call anything approved or disapproved before the user's check.
