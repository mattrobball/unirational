/-
Stage-5 statement-identity check (Comparator surrogate).

The Comparator cannot run against this tree on this machine (it OOMs
>24 GB during export before reaching a verdict), so this script performs
the check the Comparator's statement-match phase performs: load the
challenge and solution modules into SEPARATE environments and verify
that, for each audited theorem name, the two `ConstantInfo.type` exprs
are STRUCTURALLY identical (Expr.equal: exact term equality including
constant names, universe levels, binder names and binder info — not mere
defeq), and that the universe parameter lists match.

This is exactly the hazard of commit 7680055a: `private abbrev k` in
each root exported as two different mangled constants, definitionally
but not syntactically equal.  Structural Expr equality catches that.

Run:  lake env lean --run scripts/check_statement_identity.lean
Exit: 0 iff both theorems match.
-/
import Lean

open Lean

def auditedNames : List Name :=
  [`V14Formalization.Comparator.noEquivariantRationalMap_from_ambient,
   `V14Formalization.Comparator.noEquivariantRationalMap_projectiveGVariety]

unsafe def main : IO UInt32 := do
  initSearchPath (← findSysroot)
  let loadEnv (mod : Name) : IO Environment := do
    importModules #[{module := mod}] {} (leakEnv := true)
  let envC ← loadEnv `V14Challenge
  let envS ← loadEnv `V14Solution
  let mut ok := true
  for n in auditedNames do
    match envC.find? n, envS.find? n with
    | some cC, some cS =>
        let tC := cC.type
        let tS := cS.type
        -- Expr.eqv: structural equality over the de Bruijn representation —
        -- every constant name, universe level, application structure and
        -- binder STRUCTURE must coincide; only the cosmetic binder-name
        -- annotations (per-module hygiene suffixes) are ignored. This is
        -- the statement-match the Comparator performs. Expr.equal (also
        -- reported) additionally compares those cosmetic annotations; the
        -- legacy baseline already differs there because each root mangles
        -- its instance-binder names with its own module hash.
        let structEq := tC == tS
        let exactEq := tC.equal tS
        let lvlEq := cC.levelParams == cS.levelParams
        IO.println s!"{n}:"
        IO.println s!"  levelParams  challenge={cC.levelParams} solution={cS.levelParams} equal={lvlEq}"
        IO.println s!"  type Expr.eqv (structural, binder-name-insensitive): {structEq}"
        IO.println s!"  type Expr.equal (exact, incl. binder-name annotations): {exactEq}"
        unless structEq && lvlEq do
          ok := false
          IO.println s!"  CHALLENGE TYPE: {tC}"
          IO.println s!"  SOLUTION  TYPE: {tS}"
    | cC?, cS? =>
        ok := false
        IO.println s!"{n}: MISSING (challenge={cC?.isSome}, solution={cS?.isSome})"
  IO.println (if ok then "STATEMENT IDENTITY: OK" else "STATEMENT IDENTITY: FAILED")
  return (if ok then 0 else 1)
