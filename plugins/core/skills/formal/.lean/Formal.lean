/-
Formal: the base every session file imports.

The skill's rules that Lean can check live here, as refusals:

- an axiom without a source and a kind: `given` and `observed` are the only
  ways to admit one, and `#audit` fails on a raw `axiom`
- an intent that is not a `Should …`, or a description that is
- an observation whose cited text is no longer on its cited line
- a theorem resting on a foreign axiom, such as the one `native_decide` brings
- a proved `False`: the audit fails and names the axioms it rests on

`#audit`, at the end of the file, lists every axiom with its tags and what
every theorem rests on, so the report is read off Lean rather than recalled.
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

/-- `given <description|intent> <name> : <prop>` -/
syntax (name := givenCmd) "given " ident ident " : " term : command

/-- `observed <description|intent> <name> : <prop> at "<file>" <line> "<text>"`
Refuses unless `<text>` is on line `<line>` of `<file>`, a path relative to
the repository root, which is the parent of `.lean`. -/
syntax (name := observedAtCmd) "observed " ident ident " : " term " at " str num str : command

/-- `observed <description|intent> <name> : <prop> from "<command>" "<output>"`
Records the output. Rerunning the command is the agent's job. -/
syntax (name := observedFromCmd) "observed " ident ident " : " term " from " str str : command

private def parseKind (k : TSyntax `ident) : CommandElabM Kind :=
  match k.getId.toString with
  | "description" => pure .description
  | "intent" => pure .intent
  | other => throwErrorAt k "expected `description` or `intent`, got `{other}`"

/-- Declare the axiom, after checking that its kind matches its shape. -/
private def admit (src : Source) (kindStx : TSyntax `ident) (name : Ident)
    (cite : String) (prop : Term) : CommandElabM Unit := do
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
  elabCommand (← `(axiom $name:ident : Formal.Admitted $s $k $c $prop))

@[command_elab givenCmd] def elabGiven : CommandElab := fun stx => do
  match stx with
  | `(given $k:ident $n:ident : $p:term) => admit .given k n "" p
  | _ => throwUnsupportedSyntax

/-- The repository root: the parent of `.lean` when run from inside it. -/
private def repoRoot : IO System.FilePath := do
  let cwd ← IO.currentDir
  pure (if cwd.fileName == some ".lean" then cwd.parent.getD cwd else cwd)

@[command_elab observedAtCmd] def elabObservedAt : CommandElab := fun stx => do
  match stx with
  | `(observed $k:ident $n:ident : $p:term at $file:str $line:num $text:str) =>
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
    admit .observed k n s!"{rel}:{lineNo} {expected.quote}" p
  | _ => throwUnsupportedSyntax

@[command_elab observedFromCmd] def elabObservedFrom : CommandElab := fun stx => do
  match stx with
  | `(observed $k:ident $n:ident : $p:term from $cmd:str $out:str) =>
    let out := out.getString.replace "\n" "\n    "
    admit .observed k n s!"$ {cmd.getString}\n    {out}" p
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

/-- `#audit`: fail on raw or foreign axioms; list every axiom with its tags and
what every theorem rests on. -/
syntax (name := auditCmd) "#audit" : command

@[command_elab auditCmd] def elabAudit : CommandElab := fun _ => do
  let env ← getEnv
  let isAdmitted (a : Name) : Bool :=
    match env.find? a with
    | some (.axiomInfo ax) => ax.type.isAppOfArity ``Formal.Admitted 4
    | _ => false
  let mut errors : Array String := #[]
  let mut axioms : Array String := #[]
  let mut theorems : Array String := #[]
  for (n, c) in env.constants.map₂.toList do
    if n.isInternalDetail then continue
    match c with
    | .axiomInfo ax =>
      if isAdmitted n then
        let args := ax.type.getAppArgs
        let cite := litString args[2]!
        let cite := if cite.isEmpty then "" else s!"  {cite}"
        axioms := axioms.push s!"{lastName args[0]!} {lastName args[1]!}  {n}{cite}"
      else
        errors := errors.push s!"{n}: raw axiom; admit it with given or observed"
    | .thmInfo t =>
      let axs ← collectAxioms n
      let admitted := axs.filter isAdmitted
      let foreign := axs.filter fun a => !isAdmitted a && a != ``sorryAx && !standard.contains a
      let from_ := if admitted.isEmpty then "nothing"
        else ", ".intercalate (admitted.toList.map toString)
      if !foreign.isEmpty then
        for a in foreign do
          errors := errors.push s!"{n}: rests on foreign axiom {a}"
        theorems := theorems.push
          s!"foreign {n}  rests on  {", ".intercalate (foreign.toList.map toString)}"
      else if axs.contains ``sorryAx then
        theorems := theorems.push s!"open    {n}"
      else if t.type.isConstOf ``False then
        errors := errors.push s!"{n}: proves False from {from_}; retract one of them"
        theorems := theorems.push s!"False   {n}  from  {from_}"
      else
        theorems := theorems.push s!"proved  {n}  from  {from_}"
    | _ => pure ()
  let report := (axioms.qsort (· < ·)).toList ++ (theorems.qsort (· < ·)).toList
  logInfo ("\n".intercalate report)
  unless errors.isEmpty do
    throwError ("\n".intercalate (errors.qsort (· < ·)).toList)

end Formal
