---
name: formal
description: Formal-inference conversation mode. Every answer is derived in one Lean file that accumulates across the session, and nothing is claimed beyond what Lean checks.
disable-model-invocation: true
---

# Formal

An experiment. The session keeps one Lean file. Every answer extends it and the
file must still compile. What the file does not prove, the answer does not
claim.

## Toolchain

Two routes. Pick once per project, then record the choice in the project's
`CLAUDE.md` so later sessions do not ask again:

```markdown
`/experimental:formal` uses the <local | Docker> toolchain.
```

If `CLAUDE.md` already says which, use it and say nothing. Otherwise ask, in
one question, and offer to write the line.

Never install a toolchain or start a daemon yourself. Hand the user the
command and stop.

### Local

Check: `lean --version`. Repeated
`warning: could not canonicalize path: …\.elan\toolchains` with no version
line means elan is installed but no toolchain is.

Install elan:

- Windows: `winget install Lean.Elan`. Its shims land in
  `%LOCALAPPDATA%\Microsoft\WinGet\Links`, which is already on PATH — nothing
  to add.
- macOS, Linux:

  ```bash
  curl -sSfL https://elan.lean-lang.org/elan-init.sh | sh -s -- -y --default-toolchain stable
  ```

Then `elan default stable`. That only records the default — elan downloads
lazily, so the first real `lean` call fetches ~500 MB with no progress bar and
looks hung for several minutes. It is not hung. Run it in the background.

Do **not** hand a Windows user the `curl -O --location …` line from
lean-lang.org. In PowerShell `curl` is an alias for `Invoke-WebRequest`, whose
`-O` takes a value, so it swallows `--location` and writes a file named
`--location`. For the script route, `curl.exe -L -O …` works.

Run: `lean <scratchpad>/formal/Session.lean`.

### Docker

Check: `docker info`. If the engine is down, ask the user to start Docker
Desktop.

Build, once — the image is Lean core on `debian:bookworm-slim`, a few hundred MB:

```bash
docker build -t harness-lean:stable "${CLAUDE_PLUGIN_ROOT}/skills/formal/docker"
```

Run:

```bash
docker run --rm -v "<scratchpad>/formal:/work" harness-lean:stable lean Session.lean
```

On Windows under Git Bash, prefix it with `MSYS_NO_PATHCONV=1`, or MSYS rewrites
`/work` into a Windows path and the mount lands nowhere.

## Setup

Once, before the first answer, after the toolchain is up.

1. Create `<scratchpad>/formal/Session.lean`:

   ```lean
   /- Session: <the topic, one line> -/
   namespace Session

   end Session
   ```

2. Say where the file is. The user may read it at any time.

Lean core only — no Mathlib, so no real analysis and no large lemma library.
If the topic genuinely needs it, say so and ask before building a lake project.

## Every answer

1. State the question as a Lean statement, before anything else.
   If it cannot be stated, that is the answer: name the word that has no
   meaning yet, and ask what it means.
2. Add what the statement needs — `def` for each vague term, `axiom` for each
   thing granted rather than derived.
3. Prove it, or leave `sorry`.
4. Check. Fix until it compiles.
   - exit 1 — errors. Not an answer yet. Keep working.
   - exit 0 with `declaration uses 'sorry'` — the named claim is open. That is
     a result, not a failure, and it goes in the block.
   - exit 0, silent — everything stated is established from the axioms.
5. Write the prose from what the file now holds, and nothing more.
6. End with the block.

New material goes above `end Session`, under a `-- § <n>. <the question>`
heading.

## Vocabulary

| Form | Means | Rule |
| --- | --- | --- |
| `def` | a vague word made precise | before its first use |
| `axiom` | granted, not derived | one comment line: where it came from |
| `theorem` | established | the only thing the prose may assert |
| `theorem … := by sorry` | open | the prose must mark it open |

An axiom's comment names its source, and only these count:

- `given` — the user said it, in this session.
- `observed` — a file read or a command's output. Quote the part that shows it.
- `external` — a fact from outside the session. Name where it comes from.

"It is obvious" is not a source. Neither is your own earlier answer.

## Accumulate

- Append. Earlier turns are not rewritten.
- A new fact that contradicts a standing axiom is a **retraction**: delete that
  axiom, say so in the answer, and say what stops holding. Everything that
  depended on it is open again until reproved.
- Contradictory axioms prove everything, and Lean will not warn you. Retraction
  is the only thing standing between this mode and nonsense.

## Block

Last in the response.

````markdown
---
**Formal**

```lean
<what this turn added — the delta, not the whole file>
```

`lean Session.lean` → <ok | n warnings | n errors>

- Established: <theorem names>
- Open: <names resting on sorry>
- Granted: <axiom names, with sources>
````

## Rules

- Lean first, prose second. Prose written before the check rationalizes; prose
  written after it reports.
- The answer may not exceed the file. No theorem, no claim.
- Axioms are not evidence. An answer that is all axioms and one restatement has
  established nothing, and says so in those words.
- `sorry` is never quiet. Everything downstream of it is open too.
- Do not weaken a statement to make it provable. A narrower theorem that
  answers a different question is a wrong answer that happens to compile.
- No toolchain, no mode. Never fall back to "reasoning carefully" instead —
  unchecked, this is theatre.
- Scratchpad only. The Lean file is never part of the project.
