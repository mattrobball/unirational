# Problem G — work order 3: the formal core, and the fate of HYZZ (A3)

**Worker:** Codex.  **Authored:** 2026-07-29.  **Inputs:** the current
`certificates/REPAIRED_PROOF.md`, `GW_INPUT.md` (atom-formalism census),
`FACTORIZATION.md` §6 (trusted boundary: HYZZ is the one brace this work
order can still discharge).  **Deliverable:** `certificates/ATOM_CORE.md`
plus edits noted below.  **Gate:** director review; then WP-4.

## Mission, two halves

### Half A — discharge HYZZ Theorem 3.42, or crown it the fourth axiom

The certificate consumes HYZZ only as: *a maximal F-bundle over the
27-dimensional germ, whose fiber operator has a finite cluster
decomposition with pairwise disjoint spectra, decomposes as an external
direct sum of F-bundles lifting the primary decomposition* — plus the
uniqueness that the certificate's own Lemma 3.2 already proves.  Attempt
to PROVE the consumed statement at certificate standard, exploiting the
restricted generality:

1. **Formal layer first.**  Over `k[[t_1,…,t_27]][[u]]` (or the germ's
   local ring), the decomposition is a Hensel/idempotent-lifting
   argument: lift the fiberwise primary idempotents of `κ_b` to flat
   idempotents order by order in the maximal ideal, solving the same
   Sylvester-type equations that Lemma 3.2's uniqueness computation
   already manipulates — disjoint spectra make the off-diagonal
   obstruction operators invertible at every order.  This half should be
   self-contained linear algebra; write it as such.
2. **Analytic layer second.**  The certificate lives on an analytic
   germ.  Determine what upgrades the formal decomposition to the
   analytic one: convergence of the lifted idempotents (majorant/
   Banach-fixed-point estimate on the non-archimedean polydisk), or an
   abstract analytic-vs-formal faithful-flatness argument, or HYZZ's own
   proof restricted.  If the analytic upgrade is where the genuine
   content lives and it resists a certificate-standard reproof, SPLIT
   the interface: the formal statement becomes a proved lemma; the
   surviving axiom shrinks to "formal implies analytic here" — a
   smaller, sharper fourth axiom than all of HYZZ.  If even that is not
   cleanly statable, fall back to pinning HYZZ Thm 3.42 whole (artifact
   already hashed), with the honesty section explaining what was tried.

Either outcome updates `FACTORIZATION.md` §6's display — that is the
scoreboard; keep it true.

### Half B — `ATOM_CORE.md`: the formalization spine in plain language

Restate the ENTIRE formalization spine — everything WP-1's census marked
FORMALIZE (F0/F1/F2) plus the certificate's Lemmas 3.1/3.2 plus Half A's
formal layer — as a single self-contained document in the minimum
structure the Lean phase will implement:

1. Finite free modules over explicit base rings (`k[[u]]`, the germ's
   local ring, `ℚ̄`-linear representation categories); operators,
   generalized eigenspaces, projectors as polynomials in the operator,
   idempotent lifting; a proreductive group acting with exact
   invariants.  NO F-bundle vocabulary, NO nc-Hodge packaging, NO
   ∞-categories — each abstraction earns its place only by a use-site.
2. Every statement in Mathlib-shaped phrasing where one exists (name
   candidate Mathlib homes: `Module`, `LinearMap.charpoly`, generalized
   eigenspace API, `IsIdempotentElem`, Henselian rings, category of
   finite-dimensional representations), and where none exists, flag the
   gap as a named pre-requisite lemma — these flags are the Lean phase's
   shopping list.
3. The three Beauville numbers (GW-2) enter as pinned constants with
   their finite verification (the `6,15,6` eliminations and the
   characteristic polynomial) written out — F0 material, fully proved.
4. The axiom interfaces (GW-1, GW-3, WF₄, HYZZ-or-its-residue, the
   Hodge-side rows) appear ONLY as named hypotheses of the top-level
   theorem statement, each with its one-line content and its hash-pinned
   source — the document must compile conceptually from hypotheses to
   Theorem 6.8 with no other inputs.

The acceptance shape: a Lean-fluent reader should be able to estimate
the formalization from `ATOM_CORE.md` alone, file by file.

## Housekeeping

- Merge `FACTORIZATION.md`'s WF₄ row into `GW_INPUT.md`'s interface
  table so the trusted base has ONE table of record; leave a pointer in
  `FACTORIZATION.md`.
- Carry any Half-A outcome into the same table.

## House rules

Unchanged.  The live razor for Half A: do not claim the analytic upgrade
if the estimate is not actually written — a formal-only discharge with
an honest residual axiom is a success, not a failure.  Dated
`RESOLUTION.md` entry; diff confined to `certificates/`,
`RESOLUTION.md`, `tmp/pdfs/`.

## Gate

Director review of `ATOM_CORE.md` + the updated trusted-base table.
Review questions: is Half A's outcome (discharge / split / pin) honestly
argued at its hardest step; does `ATOM_CORE.md` genuinely close over its
named hypotheses; is the Mathlib gap list concrete enough to cost.
