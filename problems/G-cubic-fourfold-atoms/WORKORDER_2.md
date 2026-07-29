# Problem G — work order 2: the fate of A7 (weak factorization)

**Worker:** Codex.  **Authored:** 2026-07-29.  **Inputs:** the
WP-0.6-final `certificates/REPAIRED_PROOF.md` (A7 consumed in the
target-specific factorization argument, certificate lines 563–598, used
at 825–827) and `certificates/GW_INPUT.md` (D8: Prop. 5.30 replaced by
the in-certificate Proposition 3.7, whose premises are GW-3 plus A7).
**Deliverable:** `certificates/FACTORIZATION.md`.  **Gate:** director
review; then WP-3 per `WORKORDER.md`.

## Mission

A7 is the last unexamined non-GW infrastructure input: the
Abramovich–Karu–Matsuki–Włodarczyk weak factorization theorem, consumed
for birational maps between smooth complex projective FOURFOLDS.  Decide
its fate among three exits, in this order of preference, and deliver the
verdict with the work that justifies it:

## Exit E1 — DELETE: morphism-monotonicity + Hironaka only

The hoped-for replacement.  `X` rational gives a birational map
`ℙ⁴ ⇢ X`; Hironaka resolves the indeterminacy to a birational MORPHISM
`f : Z → X` with `Z` an iterated blowup of `ℙ⁴` along smooth centers
(automatically of dimension ≤ 2 — codimension ≥ 2 in a fourfold).
GW-3 telescoped along the tower computes the atomic composition of `Z`
from `ℙ⁴` and the centers.  What is missing is exactly one lemma:

> **(MONO)**  For a birational morphism `f : Z → X` of smooth complex
> projective fourfolds, the atomic composition of `X` embeds
> Hodge-equivariantly as a sub-collection of that of `Z` (atom-summand
> monotonicity), at least at the level the certificate consumes: any
> atom of `X` with `Coeff_{t²}P_α = 1` appears among the atoms of `Z`.

Attempt (MONO) honestly, with the routes ranked by plausibility:

1. **Inside the F-bundle formalism**: does the certificate's own
   machinery (HYZZ decomposition + the cover-native fibers) give a
   comparison map for a birational morphism — e.g. via Iritani's
   quantum-D-module relationship when `f` IS a smooth blowup, extended
   along the Hironaka tower one blowup at a time?  Note the trap: the
   tower's blowups live over `ℙ⁴`, not over `X`; (MONO) is about the
   OTHER leg.  A one-blowup-at-a-time argument down the `X`-leg is
   exactly what fails without strong factorization — say so precisely
   if that is where it dies.
2. **Via the graph**: `Γ_f ⊂ Z × X` with both projections; whether any
   atom-functoriality exists for the correspondences the formalism
   already handles.
3. **Literature**: any published monotonicity of quantum/atom-type
   invariants under birational morphisms of smooth varieties
   (Iritani's papers' remarks; Katzarkov school).  Timebox this sweep.

If every route fails, record the precise failure point of each — that
record is the justification for E2, and per the house standard a
delimited negative here is a full deliverable.

## Exit E2 — MINIMIZE: pin A7 as the third permanent axiom interface

If (MONO) resists:

1. Extract the EXACT statement consumed: quote certificate lines
   563–598; the required form is AKMW for birational maps of smooth
   complex projective fourfolds — smooth centers, projective
   intermediate steps, both directions of blowup — nothing about
   dimension of centers needs assuming (codimension gives ≤ 2 free;
   state this so the interface is not over-broad).
2. Produce the interface row in `GW_INPUT.md`'s format: statement,
   hash-pinned citation (AKMW, *Torification and factorization of
   birational maps*, JAMS 15 (2002) — pin the artifact; also Włodarczyk's
   earlier paper if the fourfold case can cite less), use-sites, minimal
   special case, independent route (Włodarczyk's independent proof
   counts), cost class (F3 — and say honestly WHY it is
   formalization-hostile: toroidal/torification machinery, no known
   elementary proof even in dimension 3), Lean recommendation
   AXIOM-INTERFACE.
3. State the resulting permanent trusted base of the whole program in
   one display: GW-1, GW-3, A7, plus the Hodge-side interfaces — this
   sentence is what the eventual paper's introduction will contain.

## Exit E3 — RESTRUCTURE (exploratory, strictly timeboxed)

One pass over whether the rationality obstruction can be rephrased to
avoid factorization entirely — e.g. a Grothendieck-ring/Burnside-style
presentation where the blowup relation is imposed by definition and the
atom map descends.  Known risk: this usually re-encounters (MONO) as the
well-definedness of the map on the quotient.  If nothing convincing
appears within the timebox, one paragraph in the deliverable saying what
was tried suffices.  Do not let E3 delay E1/E2.

## Housekeeping (small, same commit)

- Reconcile the "Proposition 5.31" ghost: GW_INPUT found no such
  proposition in the pinned artifact, while the audit record cites one.
  Locate the actual statement (the `ρ_α ≥ 1` content) in the artifact,
  correct the label wherever it appears in `certificates/`, and note the
  correction in `RESOLUTION.md`.

## House rules

Unchanged: never state a lemma you believe might be false — (MONO) is
the live instance; a wrong monotonicity lemma would poison the program,
so the null outcome is fully acceptable.  Exact citations; dated
`RESOLUTION.md` entry; diff confined to `certificates/` and
`RESOLUTION.md` plus pinned artifacts under `tmp/pdfs/`.

## Gate

Director review of `FACTORIZATION.md`.  Review questions: if E1 —
is (MONO)'s proof airtight and does it really cover the consumed case;
if E2 — is the interface row minimal and the trusted-base display
honest; either way — is the housekeeping item closed.
