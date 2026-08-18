/-
Per-module proof-term size probe.

    lake env lean --run scripts/module_stats.lean <Module.Name> [more...]

Reports, for each named module, the number of constants it defines and their
deduplicated `Expr` node count at both granularities used by
`scripts/closure_stats.lean` (per-module and per-constant), so a single
file's cost can be measured without paying a full closure rebuild.
-/
import Lean
open Lean

def countNodes (env : Environment) (names : Array Name) (perConstant : Bool) : Nat := Id.run do
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

unsafe def main (args : List String) : IO Unit := do
  let targets := args.map (·.toName)
  initSearchPath (← findSysroot)
  let imps : Array Import := (targets.map (fun m => ({ module := m } : Import))).toArray
  let env ← importModules imps {} (trustLevel := 0)
  let mut byMod : Std.HashMap Name (Array Name) := {}
  for (n, _) in env.constants.toList do
    match env.getModuleIdxFor? n with
    | none => pure ()
    | some idx =>
      let m := env.header.moduleNames[idx.toNat]!
      if targets.contains m then
        byMod := byMod.insert m ((byMod.getD m #[]).push n)
  let mut tc := 0
  let mut tm := 0
  let mut tp := 0
  for m in targets do
    let names := byMod.getD m #[]
    let nm := countNodes env names false
    let np := countNodes env names true
    tc := tc + names.size; tm := tm + nm; tp := tp + np
    IO.println s!"{m}\tconstants={names.size}\tdedup-per-module={nm}\tdedup-per-constant={np}"
  if targets.length > 1 then
    IO.println s!"TOTAL\tconstants={tc}\tdedup-per-module={tm}\tdedup-per-constant={tp}"
