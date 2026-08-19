/-
Project-declaration closure of the Comparator targets.

    lake env lean --run scripts/closure_project_decls.lean [Name ...]

With no arguments, measures the single Comparator target.  With arguments,
measures exactly those roots — pass all three published names to reproduce the
pre-2026-08-19 figure.

Two numbers, because two things are being counted.

  * `trusted-base-declarations` mirrors `Stan.collectDeps` with
    `proofIrrelevant := true` — theorem *bodies* are skipped, theorem types are
    not, and `_proof*` auxiliaries are followed anyway because the emitted
    source still names what they were abstracted from. This is the count that
    decides how big `artifacts/trusted_base.lean` is: the project declarations
    a reader must read to know what the statement says.

  * `walk-visited-constants` mirrors `Comparator.runForUsedConsts` — bodies
    included — which is what `scripts/check_comparator_walk.lean` reports and
    what Comparator actually compares.

`_`-prefixed internal names are split out of the first number because lean-stan
promotes them to their parent rather than emitting them.
-/
import Lean

open Lean

/-- Module prefixes that are "this project". Mirrors the `--roots` passed to
`lake exe stan_boundary`. -/
def projectRoots : Array Name := #[`V14Formalization, `BConicBundleMultisections]

def defaultTargets : List Name :=
  [`V14Formalization.Comparator.noEquivariantRationalMap_ambientFree]

/-- `Stan.isLiftedProof`. -/
def isLiftedProof : Name → Bool
  | .str _ s => s.startsWith "_proof"
  | _ => false

/-- `Stan.usedConstants`, proof-irrelevant form. -/
def stanUsedConstants (ci : ConstantInfo) : Array Name :=
  ci.type.getUsedConstants ++ match ci with
  | .thmInfo v    => if isLiftedProof ci.name then v.value.getUsedConstants else #[]
  | .defnInfo v   => v.value.getUsedConstants
  | .opaqueInfo v => v.value.getUsedConstants
  | .inductInfo v => v.ctors.toArray
  | .ctorInfo v   => #[v.name]
  | .recInfo v    => v.all.toArray
  | _             => #[]

/-- `Comparator.runForUsedConsts`. -/
def comparatorUsedConsts (info : ConstantInfo) : Array Name := Id.run do
  let mut a := info.type.getUsedConstants
  if let some v := info.value? (allowOpaque := true) then
    a := a ++ v.getUsedConstants
  match info with
  | .inductInfo i => a := a ++ i.ctors.toArray ++ i.all.toArray
  | .ctorInfo i => a := a.push i.induct
  | .recInfo i =>
    for r in i.rules do
      a := a.push r.ctor
      a := a ++ r.rhs.getUsedConstants
  | _ => pure ()
  return a

def isInternal (n : Name) : Bool :=
  n.components.any fun c => match c with
    | .str _ s => s.startsWith "_"
    | _ => false

unsafe def main (args : List String) : IO UInt32 := do
  initSearchPath (← findSysroot)
  let targets := if args.isEmpty then defaultTargets else args.map (·.toName)
  let env ← importModules #[{module := `V14Solution}] {} (leakEnv := true)
  for n in targets do
    unless (env.find? n).isSome do IO.println s!"TARGET NOT FOUND: {n}"; return 1
  let inProject (n : Name) : Bool :=
    match env.getModuleIdxFor? n with
    | some idx => projectRoots.any (·.isPrefixOf env.header.moduleNames[idx.toNat]!)
    | none => false
  let moduleOf (n : Name) : Option Name :=
    (env.getModuleIdxFor? n).map fun idx => env.header.moduleNames[idx.toNat]!

  -- 1. lean-stan boundary walk, union over targets.
  let mut deps : Std.HashSet Name := {}
  let mut visited : Std.HashSet Name := {}
  for t in targets do
    deps := deps.insert t
    visited := visited.insert t
    let some ci := env.find? t | continue
    let mut stack := stanUsedConstants ci
    while !stack.isEmpty do
      let c := stack.back!
      stack := stack.pop
      if visited.contains c then continue
      visited := visited.insert c
      let some ci' := env.find? c | continue
      if inProject c then deps := deps.insert c
      stack := stack ++ stanUsedConstants ci'
  let user := deps.toList.filter (fun n => !isInternal n)
  let internal := deps.toList.filter isInternal
  let mods : Std.HashSet Name := user.foldl (init := {}) fun s n =>
    match moduleOf n with | some m => s.insert m | none => s

  -- 2. Comparator walk, union over targets.
  let mut cVisited : Std.HashSet Name := {}
  let mut cStack : Array Name := #[]
  for t in targets do
    let some ci := env.find? t | continue
    cStack := cStack ++ ci.type.getUsedConstants
  while !cStack.isEmpty do
    let c := cStack.back!
    cStack := cStack.pop
    if cVisited.contains c then continue
    cVisited := cVisited.insert c
    let some ci := env.find? c | continue
    cStack := cStack ++ comparatorUsedConsts ci

  IO.println s!"targets={targets.length}"
  for t in targets do IO.println s!"  target {t}"
  IO.println s!"trusted-base-declarations={user.length}"
  IO.println s!"trusted-base-internal-names={internal.length}"
  IO.println s!"trusted-base-modules={mods.size}"
  IO.println s!"walk-visited-constants={cVisited.size}"
  return 0
