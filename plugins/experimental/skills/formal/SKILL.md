---
name: formal
description: Formal-inference conversation mode. Every answer is derived in one accumulating Lean file, claims nothing beyond what its axioms grant and Lean proves, and tells in natural language, from cause to effect, what happened in the proof.
disable-model-invocation: true
---

# Formal

An experiment. The session works in one Lean file that must always compile.
Every response follows this skill, whatever other skill runs with it.

## Per project

Two choices, made once per project and recorded in its `CLAUDE.md` so later
sessions do not ask again:

```markdown
`/experimental:formal` uses the <local | Docker> toolchain.
`/experimental:formal` <saves | does not save> its Lean file.
```

A line present: use it and say nothing. Lines missing: ask for them in one
question, and offer to write them. A choice the user does not let you record
holds for this session only.

## Toolchain

Never install a toolchain or start a daemon yourself. Hand the user the
command.

### Local

Check: `elan toolchain list` — never `lean` first. With a default recorded but
nothing installed, `lean` itself starts a ~500 MB download.

- No elan: hand the user the install below.
- Nothing listed: hand the user `elan default stable`, then `lean --version`
  to run once. It fetches ~500 MB with no progress bar and looks hung for
  several minutes. It is not hung.
- A toolchain listed: ready.

`lean` repeating `warning: could not canonicalize path: …\.elan\toolchains`
with no version line means the same as nothing listed.

Install elan:

- Windows: `winget install Lean.Elan`. Its shims land in
  `%LOCALAPPDATA%\Microsoft\WinGet\Links`, which is already on PATH — nothing
  to add.
- macOS, Linux — this installs the toolchain too:

  ```bash
  curl -sSfL https://elan.lean-lang.org/elan-init.sh | sh -s -- -y --default-toolchain stable
  ```

Do **not** hand a Windows user the `curl -O --location …` line from
lean-lang.org. In PowerShell `curl` is an alias for `Invoke-WebRequest`, whose
`-O` takes a value, so it swallows `--location` and writes a file named
`--location`. For the script route, `curl.exe -L -O …` works.

Run: `lean <file>`.

### Docker

Check: `docker info`. If the engine is down, ask the user to start Docker
Desktop.

Hand the user the build, once — the image is Lean core on
`debian:bookworm-slim`, a few hundred MB:

```bash
docker build -t harness-lean:stable "${CLAUDE_PLUGIN_ROOT}/skills/formal/docker"
```

Run:

```bash
docker run --rm -v "<file's folder>:/work" harness-lean:stable lean <file's name>
```

On Windows under Git Bash, prefix it with `MSYS_NO_PATHCONV=1`, or MSYS rewrites
`/work` into a Windows path and the mount lands nowhere.

## Setup

Once, before the first answer, after the toolchain is up.

1. Name the topic: one line, and one PascalCase word for its file.
2. Find the file.
   - Saved: `formal/<Word>.lean` in the project. If a file in `formal/` is
     already on this topic, ask whether to continue it. A new file takes a
     word no file there has yet. Do not commit it unless the user asks.
   - Not saved: `<scratchpad>/formal/Session.lean`.
3. Create it, unless continuing:

   ```lean
   /- <the topic> -/
   namespace Session

   end Session
   ```

4. Add `-- Session <date>` above `end Session`, so answers can tell what an
   earlier session granted.
5. Say where the file is. The user may read it at any time.

Lean core only — no Mathlib, so no real analysis and no large lemma library.
If the topic genuinely needs it, say so and ask before building a lake
project. It goes where the Lean file goes, and runs as `lake env lean <file>`.

## Every answer

1. Write the question into the file as a Lean statement.
   If it cannot be stated, that is the answer: name the word that has no
   meaning yet, and ask what it means.
2. Add the `opaque`s, `def`s and `axiom`s it needs.
3. Prove it, or leave `sorry`. No `native_decide`: it adds an axiom of its own.
4. Check. Fix until it compiles; exit 1 is not an answer yet. Warnings do not
   say what is open.
5. Trace. Lean flags a `sorry` only where it is written, not what rests on it.
   On a scratchpad copy, append `#print axioms Session.<name>` for each theorem
   the answer will claim, and run it. Only `Session.` axioms and `sorryAx` are
   the session's; leave out the rest.
6. Write the answer.

New material goes above `end Session`, under a `-- § <n>. <the question>`
heading. Numbering runs on across sessions.

## Vocabulary

| Form | Means | Rule |
| --- | --- | --- |
| `opaque` | a thing from the world, named, not defined | only axioms say anything about it |
| `def` | a vague word made precise | before its first use; never a fact about the world — the trace cannot see it |
| `axiom` | granted, not derived | a source comment, below |
| `theorem` | proved from the axioms its trace lists | open if the list holds `sorryAx`: a `sorry` beneath it |

`opaque` needs a nonempty type. A kind of thing with named members:

```lean
opaque Cache.carrier : NonemptyType
def Cache : Type := Cache.carrier.type
instance : Nonempty Cache := Cache.carrier.property
noncomputable opaque main : Cache
```

Members, and functions into a kind, are `noncomputable opaque`. Never `axiom`
a name and never `sorry` an instance: either puts in the trace something that
is not a granted fact.

An axiom's comment names its source, and only these count:

- `given` — the user said it.
- `observed` — a file read or a command's output. Quote the part that shows it.
- `external` — a fact from outside the session. Name where it comes from.

"It is obvious" is not a source. Neither is your own earlier answer.

## Accumulate

- Append. Earlier material is never deleted or reworded. The only edits to it:
  a retraction, a `sorry` filled, a proof repaired for a newer Lean.
- A new fact that contradicts a standing axiom is a **retraction**:
  1. Trace every theorem in the file. Each one that lists the axiom stops
     holding.
  2. In place, comment the axiom out under `-- retracted in § <n>: <why>`.
  3. Check. In each proof that no longer compiles, comment the proof out and
     put `sorry -- rested on <axiom>` in its place. What used those now traces
     to `sorryAx` by itself.
- A new meaning for a `def` is a new `def` under a new name. The old one stays.
- Contradictory axioms prove everything, and Lean will not warn you. Retraction
  is the only thing standing between this mode and nonsense.

## Answer

Natural language, in the language of the conversation, ordered from cause to
effect: start from what is granted, end on what answers the question — proved,
or open. No Lean code unless the user asks to see it.

### What it tells

What happened in the proof, honestly:

- What was granted, and from what source. Granted in an earlier session: say
  so, and that it was not checked again now.
- What each vague word was taken to mean: the `def`s the claims use. A `def`
  given a new meaning: which claims used the old one.
- How Lean proved it: every step, in the order the proof takes it — what the
  step starts from, and what that implies. One step per sentence. A step the
  prose cannot say in one sentence is a missing lemma: add it to the file,
  then say it.
- What is open.
- What was retracted, and what stopped holding.
- Earlier material edited, and how.
- A statement changed after a failed check: what changed, and why it still
  asks the user's question.

### How it says it

- Every claim about the topic is an axiom or a theorem in the file. No
  declaration, no claim.
- "Because" and "so" claim a step Lean checked. Things merely granted together
  are joined with "and".
- Saved file: cite each declaration where its claim is made, linked to its
  line — [`shared`](formal/Cache.lean:20). A link holds as of its answer. Not
  saved: no lines cited.

## Rules

- Lean first, answer second. An answer written before the check rationalizes;
  one written after it reports.
- Axioms are not evidence. A theorem is only as good as what its trace lists;
  one that restates a granted axiom proved nothing, and the answer says so.
- Do not weaken a statement to make it provable. A narrower theorem that
  answers a different question is a wrong answer that happens to compile.
- No toolchain, no mode. Never fall back to "reasoning carefully" instead —
  unchecked, this is theatre.
- Nothing enters the project but the `CLAUDE.md` lines the user accepts and,
  when saving is chosen, the Lean file and any lake project it needs.
