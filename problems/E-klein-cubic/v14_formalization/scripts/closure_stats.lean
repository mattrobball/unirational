/-
Closure measurement for the Comparator export.

    lake env lean scripts/closure_stats.lean

Reports, for the transitive proof-term closure of the two published theorems:

  * the number of constants in the closure;
  * DAG-deduplicated `Expr` nodes, per defining module, aggregated by family.

Deduplicated nodes are the right unit: `lean4export` writes each distinct
subterm once, so its peak memory tracks the deduplicated closure, not the raw
node count.  Dedup is done per defining module (a set per module, released
before the next one), which keeps the measurement's own footprint bounded and
matches how the per-module pilot numbers were taken.

Baseline to compare against (measured before this migration, 2026-08-16/17):
160,956 constants / 270.8M deduped Expr nodes; export peak 22-24 GB.
-/
import V14Solution

open Lean

def roots : Array Name :=
  #[`V14Formalization.Comparator.noEquivariantRationalMap_from_ambient,
    `V14Formalization.Comparator.noEquivariantRationalMap_projectiveGVariety]

/-- Strip trailing digits and `_`-separated index groups so that
`D12PieceAASplitRow7` and `D12PieceAASplitEntry7_9` fold into one family. -/
def familyOf (m : Name) : String :=
  let s := m.toString
  let s := if s.startsWith "V14Formalization." then s.drop "V14Formalization.".length else s
  let cs := s.toList.filter (fun c => !c.isDigit && c != '_')
  String.mk cs

run_meta do
  let env ← getEnv
  -- 1. constant closure of the two root theorems (types and proof terms)
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
      if let some v := ci.value? then
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
  let mut perMod : Array (Name × Nat × Nat) := #[]
  let mut total := 0
  for (m, names) in byMod.toList do
    let mut seen : Std.HashSet Expr := {}
    let mut nodes := 0
    for n in names do
      let some ci := env.find? n | continue
      let mut st : Array Expr := #[ci.type]
      if let some v := ci.value? then st := st.push v
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
    perMod := perMod.push (m, names.size, nodes)
    total := total + nodes

  -- 4. report
  IO.println s!"closure-constants={visited.size}"
  IO.println s!"closure-constants-without-module={noMod}"
  IO.println s!"closure-dedup-expr-nodes={total}"
  IO.println "--- per family (constants, deduped nodes, % of closure) ---"
  let mut fam : Std.HashMap String (Nat × Nat) := {}
  for (m, c, nd) in perMod do
    let f := familyOf m
    let (c0, n0) := fam.getD f (0, 0)
    fam := fam.insert f (c0 + c, n0 + nd)
  let rows := fam.toList.toArray.qsort (fun a b => a.2.2 > b.2.2)
  for (f, c, nd) in rows do
    if nd * 1000 >= total then
      IO.println s!"{f}\t{c}\t{nd}\t{(nd * 10000 / total).toFloat / 100.0}%"
  IO.println "--- top modules ---"
  let mods := perMod.qsort (fun a b => a.2.2 > b.2.2)
  for (m, c, nd) in mods[0:25] do
    IO.println s!"{m}\t{c}\t{nd}"
