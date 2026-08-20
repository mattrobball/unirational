/-
Closure measurement for the Comparator export.

    lake env lean scripts/closure_stats.lean

Reports, for the transitive proof-term closure of the published theorem:

  * the number of constants in the closure;
  * DAG-deduplicated `Expr` nodes, per defining module, aggregated by family.

Two dedup granularities are reported, because they differ by ~1.9x and it
matters which one a quoted figure used:

  * `dedup-per-module`   — one dedup set per defining module.  Closest to what
    `lean4export` pays, since it writes each distinct subterm once.
  * `dedup-per-constant` — a fresh dedup set per constant, so a subterm shared
    between two theorems is counted twice.

**Calibration (2026-08-17).**  The published baseline figure — 160,956
constants / 270.8M nodes, export peak 22-24 GB — is the *per-constant* metric.
Verified: this file's per-constant count for `D12PieceAASplitRow1` before the
SplitRow rewrite is 1,360,772, against the 1,381,831 the v14/expose-pilot
commit reported for the neighbouring `D12PieceAASplitRow0`; and the four
SplitRow families summed to 54.1M, against the 55.2M (20.4% of 270.8M) the
baseline attributed to them.  Quote per-constant numbers when comparing to
270.8M, per-module numbers when reasoning about export memory.
-/
import V14Solution

open Lean

/-- The Comparator target, exactly as `comparator.json` names it.  Keep this in
sync with `scripts/closure_project_decls.lean`'s `defaultTargets`; measuring a
different root measures a different closure. -/
def roots : Array Name :=
  #[`V14Formalization.Comparator.noEquivariantRationalMap_projectiveSpaceOfRep]

/-- Strip trailing digits and `_`-separated index groups so that
`D12PieceAASplitRow7` and `D12PieceAASplitEntry7_9` fold into one family. -/
def familyOf (m : Name) : String :=
  let s := (m.toString).replace "V14Formalization." ""
  String.ofList (s.toList.filter (fun c => !c.isDigit && c != '_'))

run_meta do
  let env ← getEnv
  -- 1. constant closure of the root theorem (types and proof terms)
  let mut visited : Std.HashSet Name := {}
  let mut stack : Array Name := roots
  while h : stack.size > 0 do
    let n := stack[stack.size - 1]
    stack := stack.pop
    if visited.contains n then continue
    visited := visited.insert n
    match env.find? n with
    | none => pure ()
    | some ci =>
      for c in ci.type.getUsedConstants do
        if !visited.contains c then stack := stack.push c
      if let some v := ci.value? (allowOpaque := true) then
        for c in v.getUsedConstants do
          if !visited.contains c then stack := stack.push c

  -- 2. group the closure by defining module
  let mut byMod : Std.HashMap Name (Array Name) := {}
  let mut noMod := 0
  for n in visited.toList do
    match env.getModuleIdxFor? n with
    | none => noMod := noMod + 1
    | some idx =>
      let m := env.header.moduleNames[idx.toNat]!
      byMod := byMod.insert m ((byMod.getD m #[]).push n)

  -- 3. deduplicated Expr nodes, one dedup set per module
  let count (names : Array Name) (perConstant : Bool) : MetaM Nat := do
    let mut seen : Std.HashSet Expr := {}
    let mut nodes := 0
    for n in names do
      if perConstant then seen := {}
      let some ci := env.find? n | continue
      let mut st : Array Expr := #[ci.type]
      if let some v := ci.value? (allowOpaque := true) then st := st.push v
      while h : st.size > 0 do
        let e := st[st.size - 1]
        st := st.pop
        if seen.contains e then continue
        seen := seen.insert e
        nodes := nodes + 1
        match e with
        | .app f a => st := st.push f |>.push a
        | .lam _ t b _ | .forallE _ t b _ => st := st.push t |>.push b
        | .letE _ t v b _ => st := st.push t |>.push v |>.push b
        | .mdata _ b | .proj _ _ b => st := st.push b
        | _ => pure ()
    return nodes
  let mut perMod : Array (Name × Nat × Nat × Nat) := #[]
  let mut total := 0
  let mut totalPerConst := 0
  for (m, names) in byMod.toList do
    let nodes ← count names false
    let nodesPC ← count names true
    totalPerConst := totalPerConst + nodesPC
    perMod := perMod.push (m, names.size, nodes, nodesPC)
    total := total + nodes
  IO.println s!"closure-dedup-expr-nodes-per-constant={totalPerConst}"

  -- 4. report
  IO.println s!"closure-constants={visited.size}"
  IO.println s!"closure-constants-without-module={noMod}"
  IO.println s!"closure-dedup-expr-nodes={total}"
  IO.println "--- per family (constants, deduped nodes, % of closure) ---"
  let mut fam : Std.HashMap String (Nat × Nat × Nat) := {}
  for (m, c, nd, pc) in perMod do
    let f := familyOf m
    let (c0, n0, p0) := fam.getD f (0, 0, 0)
    fam := fam.insert f (c0 + c, n0 + nd, p0 + pc)
  let rows := fam.toList.toArray.qsort (fun a b => a.2.2.2 > b.2.2.2)
  IO.println "family\tconstants\tdedup-per-module\tdedup-per-constant\t% of per-constant closure"
  for (f, c, nd, pc) in rows do
    if pc * 2000 >= totalPerConst then
      IO.println s!"{f}\t{c}\t{nd}\t{pc}\t{(pc * 10000 / totalPerConst).toFloat / 100.0}%"
  IO.println "--- top modules ---"
  let mods := perMod.qsort (fun a b => a.2.2.2 > b.2.2.2)
  for (m, c, nd, pc) in mods[0:20] do
    IO.println s!"{m}\t{c}\t{nd}\t{pc}"
