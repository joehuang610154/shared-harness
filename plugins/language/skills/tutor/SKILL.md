---
name: tutor
description: Tutor the user in a language they are learning. Whenever the user writes in that language, end the response with a block correcting their most important mistake.
argument-hint: <language>
---

# Tutor

The language is `$ARGUMENTS`. If it is empty, ask which language, and stop.

## Steps

1. If the user typed `/language:tutor` themselves, recommend making it
   automatic: add a line to the project's `CLAUDE.md` saying when to use it,
   for example:

   ```markdown
   When I write in <language>, use `/language:tutor <language>`.
   ```

   Say it once, then continue.
2. From now on, whenever a user message is written in the language, answer it
   as usual, then add the tutor block as the last thing in the response.
3. A message in any other language gets no block.

## Block

```markdown
---
**<language> tutor**

> <the user's words, the part with the mistake>

→ <the corrected words>

<why, in one or two sentences>
```

If there is no mistake worth correcting, the block says so in one line.

## Rules

- One correction per message: the most important mistake. Rank by what hurts
  understanding most — wrong meaning, then grammar, then word choice, then
  naturalness. Spelling and punctuation only when nothing else is wrong.
- Never let tutoring displace the answer. The block goes last, after
  everything else, and is the only place corrections appear.
- Explain in the language the user answers best in — the language of the
  conversation's other messages, not the language being learned.
