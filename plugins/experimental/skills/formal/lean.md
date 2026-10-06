# The Lean file

How to write the file so its trace tells the truth. Read by
[SKILL.md](SKILL.md).

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

## Sources

An axiom's comment names its source, and only these count:

- `given` — the user said it.
- `observed` — a file read or a command's output. Quote the part that shows it.
- `external` — a fact from outside the session. Name where it comes from.

"It is obvious" is not a source. Neither is your own earlier answer.

## Prove, check, trace

- No `native_decide`: it adds an axiom of its own.
- Exit 1 is not an answer yet. Warnings do not say what is open.
- Lean flags a `sorry` only where it is written, not what rests on it. To
  trace, append `#print axioms Session.<name>` on a scratchpad copy for each
  theorem the answer will claim, and run it. Only `Session.` axioms and
  `sorryAx` are the session's; leave out the rest.

## Accumulate

New material goes above `end Session`, under a `-- § <n>. <the question>`
heading. Numbering runs on across sessions.

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
