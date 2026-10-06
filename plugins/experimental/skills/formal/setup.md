# Setup

Once, before the first answer. Read by [SKILL.md](SKILL.md).

Never install a toolchain or start a daemon yourself. Hand the user the
command.

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

Hand the user the build, once, with the absolute path of the `docker` folder
beside this file. The image is Lean core on `debian:bookworm-slim`, a few
hundred MB:

```bash
docker build -t harness-lean:stable "<this skill's folder>/docker"
```

Run:

```bash
docker run --rm -v "<file's folder>:/work" harness-lean:stable lean <file's name>
```

On Windows under Git Bash, prefix it with `MSYS_NO_PATHCONV=1`, or MSYS rewrites
`/work` into a Windows path and the mount lands nowhere.

## The file

After the toolchain is up.

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

Nothing enters the project but the `CLAUDE.md` lines the user accepts and,
when saving is chosen, the Lean file and any lake project it needs.
