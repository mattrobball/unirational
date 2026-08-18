/-
Per-constant Expr-node counter (scratch measurement tool).

    lake env lean scripts/const_stats.lean

Walks the closure of the two published theorems and prints, for a chosen set
of defining modules, every closure constant with its deduped Expr-node count.
-/
import V14Solution

open Lean

def roots : Array Name :=
  #[`V14Formalization.Comparator.noEquivariantRationalMap_from_ambient,
    `V14Formalization.Comparator.noEquivariantRationalMap_projectiveGVariety]

def wanted : Array Name :=
  #[`V14Formalization.D12CompoundRRow0,
    `V14Formalization.D12PolynomialRRow0,
    `V14Formalization.D12U6PolynomialData]

run_meta do
  let env ← getEnv
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
  let count (n : Name) : MetaM Nat := do
    let mut seen : Std.HashSet Expr := {}
    let mut nodes := 0
    let some ci := env.find? n | return 0
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
  for w in wanted do
    IO.println s!"=== {w} ==="
    let mut rows : Array (Name × Nat) := #[]
    for n in visited.toList do
      match env.getModuleIdxFor? n with
      | none => pure ()
      | some idx =>
        if env.header.moduleNames[idx.toNat]! == w then
          rows := rows.push (n, ← count n)
    let sorted := rows.qsort (fun a b => a.2 > b.2)
    let mut tot := 0
    for (_, c) in sorted do tot := tot + c
    IO.println s!"(constants={sorted.size} total-per-constant-nodes={tot})"
    for (n, c) in sorted do
      IO.println s!"{c}\t{n}"
