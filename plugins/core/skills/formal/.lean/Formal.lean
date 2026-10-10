/-
Formal: the base every session file imports.

The skill's rules that Lean can check live here, as refusals:

- an axiom without a source and a kind: `given` and `observed` are the only
  ways to admit one, and `#audit` fails on a raw `axiom`
- a declaration without its sentence: every `given`, `observed`, `def`,
  `opaque`, and `theorem` carries a doc comment in the user's language
- an intent that is not a `Should …`, or a description that is
- an observation whose cited text is no longer on its cited line
- a theorem resting on a foreign axiom, such as the one `native_decide` brings
- a proved `False`: the audit fails and names the axioms it rests on

`#audit`, at the end of the file, prints the words, the premises, and the
theorems numbered in file order, each with its sentence and what it rests
on, so the report is read off Lean rather than recalled.
-/
import Lean

namespace Formal

/-- Where an axiom came from. -/
inductive Source where
  /-- The user's words, as transcribed. -/
  | given
  /-- The repository: a file and line, or a command and its output. -/
  | observed
  deriving Repr, DecidableEq

/-- What an axiom says: how things are, or how they should be. -/
inductive Kind where
  | description
  | intent
  deriving Repr, DecidableEq

/-- `Should p` is an intent. Nothing links `Should p` to `p`, so an intent and
a contrary description never meet in `False`. -/
opaque Should : Prop → Prop

/-- Intent against description: the shape of a task, not a contradiction. -/
abbrev Gap (p : Prop) : Prop := Should p ∧ ¬ p

/-- The type of every admitted axiom. Reducible, so an `Admitted … p` is used
as a `p`; the tags stay visible in the declaration and in `#print axioms`. -/
abbrev Admitted (_src : Source) (_kind : Kind) (_cite : String) (p : Prop) : Prop := p

open Lean Elab Command Meta

/-- `/-- sentence -/ given <description|intent> <name> : <prop>` -/
syntax (name := givenCmd) (docComment)? "given " ident ident " : " term : command

/-- `/-- sentence -/ observed <description|intent> <name> : <prop> at "<file>" <line> "<text>"`
Refuses unless `<text>` is on line `<line>` of `<file>`, a path relative to
the repository root, which is the parent of `.lean`. -/
syntax (name := observedAtCmd)
  (docComment)? "observed " ident ident " : " term " at " str num str : command

/-- `/-- sentence -/ observed <description|intent> <name> : <prop> from "<command>" "<output>"`
Records the output. Rerunning the command is the agent's job. -/
syntax (name := observedFromCmd)
  (docComment)? "observed " ident ident " : " term " from " str str : command

private def parseKind (k : TSyntax `ident) : CommandElabM Kind :=
  match k.getId.toString with
  | "description" => pure .description
  | "intent" => pure .intent
  | other => throwErrorAt k "expected `description` or `intent`, got `{other}`"

/-- Declare the axiom, after checking that it has its sentence and that its
kind matches its shape. -/
private def admit (src : Source) (doc? : Option (TSyntax ``Parser.Command.docComment))
    (kindStx : TSyntax `ident) (name : Ident) (cite : String) (prop : Term) :
    CommandElabM Unit := do
  let some doc := doc?
    | throwErrorAt name "no sentence: every premise carries one as a doc comment, in the user's language"
  let kind ← parseKind kindStx
  let isShould ← liftTermElabM do
    let e ← Term.elabTerm prop (some (mkSort Level.zero))
    Term.synthesizeSyntheticMVarsNoPostponing
    let e ← instantiateMVars e
    pure (e.getAppFn.isConstOf ``Formal.Should)
  match kind, isShould with
  | .intent, false => throwErrorAt prop "an intent is a `Should …`, and this is not"
  | .description, true => throwErrorAt prop "a description is not a `Should …`, and this is"
  | _, _ => pure ()
  let s ← match src with
    | .given => `(Formal.Source.given)
    | .observed => `(Formal.Source.observed)
  let k ← match kind with
    | .description => `(Formal.Kind.description)
    | .intent => `(Formal.Kind.intent)
  let c : Term := quote cite
  elabCommand (← `($doc:docComment axiom $name:ident : Formal.Admitted $s $k $c $prop))

@[command_elab givenCmd] def elabGiven : CommandElab := fun stx => do
  match stx with
  | `($[$doc?:docComment]? given $k:ident $n:ident : $p:term) => admit .given doc? k n "" p
  | _ => throwUnsupportedSyntax

/-- The repository root: the parent of `.lean` when run from inside it. -/
private def repoRoot : IO System.FilePath := do
  let cwd ← IO.currentDir
  pure (if cwd.fileName == some ".lean" then cwd.parent.getD cwd else cwd)

@[command_elab observedAtCmd] def elabObservedAt : CommandElab := fun stx => do
  match stx with
  | `($[$doc?:docComment]? observed $k:ident $n:ident : $p:term at $file:str $line:num $text:str) =>
    let rel := file.getString
    let path := (← repoRoot) / rel
    let lineNo := line.getNat
    let expected := text.getString
    unless ← path.pathExists do throwErrorAt file "no such file: {path.toString}"
    let lines := ((← IO.FS.readFile path).replace "\r\n" "\n").splitOn "\n"
    if lineNo == 0 || lineNo > lines.length then
      throwErrorAt line "{rel} has {lines.length} lines"
    let actual := lines[lineNo - 1]!
    if expected.isEmpty || (actual.splitOn expected).length < 2 then
      throwErrorAt text "line {lineNo} of {rel} reads\n  {actual}\nnot\n  {expected}"
    admit .observed doc? k n s!"{rel}:{lineNo} {expected.quote}" p
  | _ => throwUnsupportedSyntax

@[command_elab observedFromCmd] def elabObservedFrom : CommandElab := fun stx => do
  match stx with
  | `($[$doc?:docComment]? observed $k:ident $n:ident : $p:term from $cmd:str $out:str) =>
    let out := out.getString.replace "\n" "\n    "
    admit .observed doc? k n s!"$ {cmd.getString}\n    {out}" p
  | _ => throwUnsupportedSyntax

/-- Axioms Lean's own tactics may use. Anything else not admitted is foreign. -/
private def standard : List Name := [``propext, ``Classical.choice, ``Quot.sound]

private def lastName (e : Expr) : String :=
  match e.getAppFn with
  | .const n _ => n.getString!
  | _ => "?"

private def litString (e : Expr) : String :=
  match e with
  | .lit (.strVal s) => s
  | _ => ""

/-- Collapse whitespace, so a doc comment reads as one line. -/
private def squash (s : String) : String :=
  let flat := ((s.replace "\r" " ").replace "\n" " ").replace "\t" " "
  " ".intercalate ((flat.splitOn " ").filter (· ≠ ""))

private def sentenceOf (n : Name) : CommandElabM String := do
  match ← findDocString? (← getEnv) n with
  | some s => pure (squash s)
  | none => pure ""

private def lineOf (n : Name) : CommandElabM Nat := do
  match ← findDeclarationRanges? n with
  | some r => pure r.range.pos.line
  | none => pure 0

private def isAdmittedType (t : Expr) : Bool := t.isAppOfArity ``Formal.Admitted 4

/-- `given intent`, `observed description`, `theorem`, or `axiom`. -/
private def labelOf (ci : ConstantInfo) : String :=
  match ci with
  | .axiomInfo ax =>
    if isAdmittedType ax.type then
      let args := ax.type.getAppArgs
      s!"{lastName args[0]!} {lastName args[1]!}"
    else "axiom"
  | .thmInfo _ => "theorem"
  | _ => "?"

/-- The local theorems and axioms a proof uses directly, seen through internal
auxiliaries such as `match_1` and `_proof_1`. -/
private partial def usedLocally (env : Environment) (e : Expr) (acc : Array Name := #[]) :
    Array Name :=
  e.getUsedConstants.foldl (init := acc) fun acc c =>
    if acc.contains c then acc else
    match env.constants.map₂.find? c with
    | none => acc
    | some ci =>
      if c.isInternalDetail then
        match ci.value? (allowOpaque := true) with
        | some v => usedLocally env v (acc.push c)
        | none => acc.push c
      else match ci with
        | .thmInfo _ | .axiomInfo _ => acc.push c
        | _ => acc

private structure Item where
  line : Nat
  name : Name
  text : String

private def byLine (a b : Item) : Bool :=
  a.line < b.line || (a.line == b.line && a.name.toString < b.name.toString)

/-- `#audit`: fail on raw or foreign axioms, a proved `False`, and a missing
sentence; print the words, the premises, and the theorems in file order,
numbered, each with its sentence and what it rests on. -/
syntax (name := auditCmd) "#audit" : command

@[command_elab auditCmd] def elabAudit : CommandElab := fun _ => do
  let env ← getEnv
  let isAdmitted (a : Name) : Bool :=
    match env.find? a with
    | some (.axiomInfo ax) => isAdmittedType ax.type
    | _ => false
  let mut errors : Array String := #[]
  let mut words : Array Item := #[]
  let mut premises : Array Item := #[]
  let mut thms : Array Item := #[]
  for (n, c) in env.constants.map₂.toList do
    if n.isInternalDetail then continue
    match c with
    | .axiomInfo ax =>
      if isAdmitted n then
        let cite := litString ax.type.getAppArgs[2]!
        let cite := if cite.isEmpty then "" else s!"  [{cite}]"
        premises := premises.push ⟨← lineOf n, n, s!"{labelOf c}  {n}: {← sentenceOf n}{cite}"⟩
      else
        errors := errors.push s!"{n}: raw axiom; admit it with given or observed"
    | .thmInfo _ =>
      thms := thms.push ⟨← lineOf n, n, ""⟩
    | .defnInfo _ | .opaqueInfo _ | .inductInfo _ =>
      if isAuxRecursor env n || isNoConfusion env n || env.isProjectionFn n
          || Meta.isInstanceCore env n then
        continue
      let s ← sentenceOf n
      if s.isEmpty then
        errors := errors.push s!"{n}: no sentence; every word carries its meaning as a doc comment"
      words := words.push ⟨← lineOf n, n, s!"{n}: {s}"⟩
    | _ => pure ()
  let ordered := thms.qsort byLine
  let total := ordered.size
  let mut out : Array String := #[]
  let mut k := 0
  for it in ordered do
    k := k + 1
    let n := it.name
    let some ci := env.find? n | continue
    let axs ← collectAxioms n
    let admitted := axs.filter isAdmitted
    let foreign := axs.filter fun a => !isAdmitted a && a != ``sorryAx && !standard.contains a
    let from_ := if admitted.isEmpty then "nothing"
      else ", ".intercalate (admitted.toList.map toString)
    let s ← sentenceOf n
    if s.isEmpty then
      errors := errors.push s!"{n}: no sentence; every claim carries one as a doc comment"
    for a in foreign do
      errors := errors.push s!"{n}: rests on foreign axiom {a}"
    let status :=
      if !foreign.isEmpty then "foreign"
      else if axs.contains ``sorryAx then "open   "
      else if ci.type.isConstOf ``False then "False  "
      else "proved "
    if status == "False  " then
      errors := errors.push s!"{n}: proves False from {from_}; retract one of them"
    out := out.push s!"  {k} of {total}  {status} {n}: {s}"
    let used := match ci.value? (allowOpaque := true) with
      | some v => (usedLocally env v).filter fun (c : Name) => !c.isInternalDetail && c != n
      | none => #[]
    let mut usedItems : Array Item := #[]
    for u in used do
      let label := match env.find? u with
        | some uci => labelOf uci
        | none => "?"
      usedItems := usedItems.push ⟨← lineOf u, u, s!"      {label}  {u}: {← sentenceOf u}"⟩
    for u in usedItems.qsort byLine do
      out := out.push u.text
    out := out.push s!"      from  {from_}"
  let block (title : String) (xs : Array Item) : Array String :=
    if xs.isEmpty then #[] else #[title] ++ (xs.qsort byLine).map fun i => s!"  {i.text}"
  let report := block "words" words ++ block "premises" premises
    ++ (if total == 0 then #[] else #[s!"theorems  {total}"] ++ out)
  logInfo ("\n".intercalate report.toList)
  unless errors.isEmpty do
    throwError ("\n".intercalate (errors.qsort (· < ·)).toList)

end Formal
