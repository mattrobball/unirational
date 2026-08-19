/-
Comparator surrogate, phase 2: the reachable-constant walk.

`scripts/check_statement_identity.lean` covers Comparator's *first* check — the
two named theorems must have structurally identical types. That is not the whole
of what Comparator compares. `Comparator/Compare.lean` continues:

  * `compareAt` compares each named theorem by `ConstantVal` alone (name,
    levelParams, type) and pushes `type.getUsedConstants` onto a worklist;
  * `Compare.loop` then walks that worklist and, for every constant it reaches,
    requires the challenge's and the solution's full `ConstantInfo` to be equal —
    **values included**. `Comparator.runForUsedConsts` (Comparator/Util.lean)
    follows `info.value? (allowOpaque := true)`, so definition bodies are walked
    and every theorem those bodies name is compared as a proof term.
  * Only names in `definition_names` get type-only treatment inside the loop.
    `theorem_names` does NOT exempt a constant here, and `definitionHoleMatches`
    demands a `.defnInfo`, so a theorem cannot be parked there either.

That matters for this project because its statement vocabulary is proof-carrying.
`ambientFor`'s body passes `sigma_isInvolution` to `plusMinusAmbientBasis`;
`ProjectiveGVariety.v14` carries a closed immersion as a structure field; a
`MatrixRepresentation` is a monoid hom, so building the `Action` needs
`projectiveActionHom_one`/`_mul`. The walk reaches all of them. Any challenge that
states the theorem but leaves the supporting lemmas open — a `sorry` skeleton of the
kind `mattrobball/lean-stan` emits — matches on statements and then fails here, with
`sorryAx` on the challenge side against a real proof on the solution side. See
DEFECTS.md D15.

(Until 2026-08-18 the clearest example was the coordinate choice: `ambientOf` took no
coordinates and unfolded to `PlusMinusCoords.ofRep`, dragging
`exists_plus_minus_projective_bases` and `not_degenerates` into the walk. The
published theorems now take a `PlusMinusCoords` parameter, which removed those two
and 30 further constants — 55,029 -> 54,997 — without rescuing a skeleton challenge:
38 mismatches became 36.)

Run:  lake env lean --run scripts/check_comparator_walk.lean
Exit: 0 iff both named statements match AND the walk finds no mismatch.
-/
import Lean

open Lean

-- Comparator derives exactly these four; the rest of `ConstantInfo`'s fields
-- already have `BEq` in core.
deriving instance BEq for Lean.QuotKind
deriving instance BEq for Lean.QuotVal
deriving instance BEq for Lean.InductiveVal
deriving instance BEq for Lean.ConstantInfo

/-- The names `comparator.json` lists. -/
def comparatorTargets : List Name :=
  [`V14Formalization.Comparator.noEquivariantRationalMap_ambientFree]

/-- Corollaries that are no longer Comparator targets but are still published.
Walking them too makes this gate strictly stronger than Comparator; the
reduction they buy is in the trusted base, not in this check. -/
def localCanaries : List Name :=
  [`V14Formalization.Comparator.noEquivariantRationalMap_from_ambient,
   `V14Formalization.Comparator.noEquivariantRationalMap_projectiveGVariety]

def auditedNames : List Name := comparatorTargets ++ localCanaries

/-- Mirror of `Comparator.runForUsedConsts` (Comparator/Util.lean). -/
def usedConsts (info : ConstantInfo) : Array Name := Id.run do
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

unsafe def main : IO UInt32 := do
  initSearchPath (← findSysroot)
  let loadEnv (mod : Name) : IO Environment :=
    importModules #[{module := mod}] {} (leakEnv := true)
  let envC ← loadEnv `V14Challenge
  let envS ← loadEnv `V14Solution
  let mut ok := true
  let mut worklist : Array Name := #[]
  -- Phase 1: named theorems, ConstantVal only. Their VALUES are deliberately not
  -- compared -- that is the whole point of a challenge carrying `sorry`.
  for n in auditedNames do
    match envC.find? n, envS.find? n with
    | some (.thmInfo c), some (.thmInfo s) =>
      let same := c.name == s.name && c.levelParams == s.levelParams && c.type == s.type
      IO.println s!"[statement] {n}: {if same then "MATCH" else "MISMATCH"}"
      unless same do ok := false
      worklist := worklist ++ c.type.getUsedConstants
    | _, _ =>
      ok := false
      IO.println s!"[statement] {n}: MISSING, or not a theorem on both sides"
  -- Phase 2: the walk. Full ConstantInfo equality, values included.
  let mut checked : Std.HashSet Name := {}
  let mut mismatches : Array Name := #[]
  let mut missing : Array Name := #[]
  while !worklist.isEmpty do
    let t := worklist.back!
    worklist := worklist.pop
    if checked.contains t then continue
    checked := checked.insert t
    match envC.find? t, envS.find? t with
    | some c, some s =>
      -- Do not recurse past a mismatch: the point is to report it, and the
      -- subtree below a differing constant is noise.
      if c != s then mismatches := mismatches.push t
      else worklist := worklist ++ usedConsts s
    | _, _ => missing := missing.push t
  -- Report how much of the walk Comparator itself pays for, i.e. the closure of
  -- `comparatorTargets` alone. The canaries above are checked in addition.
  let mut tVisited : Std.HashSet Name := {}
  let mut tWork : Array Name := #[]
  for n in comparatorTargets do
    if let some ci := envS.find? n then tWork := tWork ++ ci.type.getUsedConstants
  while !tWork.isEmpty do
    let t := tWork.back!
    tWork := tWork.pop
    if tVisited.contains t then continue
    tVisited := tVisited.insert t
    if let some s := envS.find? t then tWork := tWork ++ usedConsts s
  IO.println s!"[walk] visited {checked.size} constants \
    ({tVisited.size} from the {comparatorTargets.length} Comparator target(s), \
    the rest from the {localCanaries.length} local canaries)"
  IO.println s!"[walk] challenge/solution mismatches: {mismatches.size}"
  for n in mismatches.toList.take 20 do
    let sorried := match envC.find? n with
      | some ci => match ci.value? (allowOpaque := true) with
        | some v => v.getUsedConstants.contains `sorryAx
        | none => false
      | none => false
    IO.println s!"  MISMATCH {n}{if sorried then "  (challenge side is sorryAx)" else ""}"
  IO.println s!"[walk] constants absent from one side: {missing.size}"
  for n in missing.toList.take 10 do
    IO.println s!"  MISSING {n}"
  unless mismatches.isEmpty && missing.isEmpty do ok := false
  IO.println (if ok then "COMPARATOR WALK: OK" else "COMPARATOR WALK: FAILED")
  return (if ok then 0 else 1)
