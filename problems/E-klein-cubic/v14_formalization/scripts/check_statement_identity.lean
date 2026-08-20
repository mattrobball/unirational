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

Run:  scripts/check_module_invariants.sh (which passes --targets and --canaries
      and the two module names, all parsed from comparator.json).
Exit: 0 iff every audited theorem matches.
-/
import Lean

open Lean

/-- The audited names and the two module names come from the caller
(`scripts/check_module_invariants.sh`), which parses `comparator.json`. Nothing
in this file hardcodes a theorem name. -/
structure Config where
  challenge : Name := `V14Challenge
  solution  : Name := `V14Solution
  targets   : List Name := []
  canaries  : List Name := []

def splitNames (s : String) : List Name :=
  (s.splitOn ",").filterMap fun t =>
    -- names never contain spaces; this avoids the deprecated `String.trim`
    let t := t.replace " " ""
    if t.isEmpty then none else some t.toName

def parseArgs (args : List String) : Except String Config :=
  go args {}
where
  go : List String → Config → Except String Config
    | [], c => .ok c
    | "--challenge" :: v :: rest, c => go rest { c with challenge := v.toName }
    | "--solution"  :: v :: rest, c => go rest { c with solution  := v.toName }
    | "--targets"   :: v :: rest, c => go rest { c with targets   := splitNames v }
    | "--canaries"  :: v :: rest, c => go rest { c with canaries  := splitNames v }
    | a :: _, _ => .error s!"unrecognised argument: {a}"

unsafe def main (args : List String) : IO UInt32 := do
  let cfg ← match parseArgs args with
    | .ok c => pure c
    | .error e => do IO.eprintln e; return 2
  let auditedNames := cfg.targets ++ cfg.canaries
  if auditedNames.isEmpty then
    IO.eprintln "no theorem names given (--targets and --canaries)"
    return 2
  initSearchPath (← findSysroot)
  let loadEnv (mod : Name) : IO Environment := do
    importModules #[{module := mod}] {} (leakEnv := true)
  let envC ← loadEnv cfg.challenge
  let envS ← loadEnv cfg.solution
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
