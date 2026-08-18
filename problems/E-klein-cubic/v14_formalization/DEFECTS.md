# DEFECTS — V14 formalization audit

Audit of `problems/E-klein-cubic/v14_formalization/` (Lean 4.32.1 + Mathlib v4.32.1),
started 2026-08-11. Written to be handed to a fresh agent: every claim below was
checked against the tree, and each entry says how to reproduce it.

**Status of this document:** complete. Defects D1–D13 were verified against the tree
directly. The reuse section is based on three surveys of
`problems/B-conic-bundle-multisections/`; every file path, declaration name, line count and
dependency count quoted from those surveys was spot-checked before being written here.

## How to reproduce the baseline

```bash
cd problems/E-klein-cubic/v14_formalization
lake build                              # green, 2946 jobs, ~1s cached
bash scripts/verify.sh                  # ALL VERIFY CHECKS PASSED
lake build V14Formalization.ResidualNotInM   # FAILS — see D2
```

## What is actually sound

Stated up front so the defect list is not read as a verdict on the whole tree.

* The abstract argument in `V14Formalization/CentralizerObstruction.lean:85` is
  correctly and completely proved, and it is not vacuous — it is instantiated on a
  carrier where both hypotheses are theorems.
* The six headline theorems (`centralizerObstruction`, `centralizerObstruction_one_rep`,
  `noDegenerates_of_centerless_involution`, `V14App.V14_not_weakly_versal`,
  `V14App.V14_no_equivariant_map_from_faithful_rep`, `V14App.V14_not_GUnirational`)
  depend only on `propext`, `Classical.choice`, `Quot.sound`.
* Zero project `axiom` declarations, zero `sorry` tokens in the source.
* The group theory and character theory (~16k lines) is real work: `|PSL₂(F₁₁)| = 660`,
  `N ≃ D₁₂`, the Weil representation of `SL₂(F₁₁)`, the class-function ledger.

The defects below are about **trust** (D1), **coverage** (D2–D3), and
**faithfulness — the theorems not meaning what their names claim** (D4–D9).

---

## S1 — Soundness / trust

### D1. `native_decide` is used in 21 places and taints 32 results, including the rank-10 seal

**This is cheating and must be removed.** `native_decide` bypasses the Lean kernel: it
compiles the proposition to machine code, runs it, and trusts the result via a per-call
axiom. Nothing in the kernel — and nothing in an external kernel replay such as Nanoda —
ever re-checks it. A formalization that carries it is asking the reader to trust the Lean
compiler, the C backend, and the machine it ran on.

**Call sites (21):**

| File | Lines | Count |
|---|---|---|
| `V14Formalization/PSLCard.lean` | 181–187, 203, 594, 607, 782–795 | 15 |
| `V14Formalization/ResidualNotInM.lean` | 59, 70, 98, 318 | 4 |
| `V14Formalization/Ord11CharacterSum.lean` | 659 | 1 |
| `V14Formalization/GeometricV14Carrier.lean` | 7140 | 1 |

**Blast radius:** of 147 declarations audited by `#print axioms` in the build log,
115 are clean and **32 carry `native_decide` axioms**. Reproduce with:

```bash
lake build 2>&1 | python3 -c "
import re,sys
for n,a in re.findall(r\"'([^']+)' depends on axioms: \[(.*?)\]\", sys.stdin.read(), re.S):
    bad=[x.strip() for x in a.replace('\n',' ').split(',')
         if x.strip() not in ('propext','Classical.choice','Quot.sound')]
    if bad: print(len(bad), n)"
```

The load-bearing casualties, in dependency order:

* `PSLCard.slChiSumSq_eq`, `PSLCard.orderOf_mk_eq_pslOrd`, `PSLCard.convAt_eq`,
  `PSLCard.chi10Int_convolution` — the SL₂ order profile and the χ₁₀′ convolution.
* `GeometricV14Carrier.chiLambda2_sigma`, `..._eq_zero_of_order_three`, `..._of_order_six`,
  `sum_chi_chiLambda2*`, `Mfix_eq_Msub`, `projectorM_isProj`, `projectorM_trace_eq_finrank`.
* `Ord11CharacterSum.sum_chi_chiLambda2_order_eleven` (3 native axioms),
  `sum_chi_chiLambda2_eq_sixsixty` (7), and
* **`Ord11CharacterSum.finrank_Msub_eq_ten` (8 native axioms)** — this is the rank
  `dim M = 10` seal, the single most important input to the real-V₁₄ route. It is
  currently not kernel-checked.

**Why it matters beyond principle:** the whole point of the M-cut programme is to replace
the coset carrier with the actual V₁₄ = Gr(2,6) ∩ ℙ(M). That construction is built on
`finrank Msub = 10`. If the headline is ever rewired onto the M-cut carrier (see D7), the
`native_decide` taint moves onto the headline, and the project loses its clean axiom audit
in the same commit that makes it faithful.

**Suggested fixes, cheapest first:**

1. Most of these are finite computations over small finite structures — `slCardOrder n`
   over 1320 SL₂(F₁₁) matrices, `conv4FailCount`, `pslOrd` of five explicit matrices,
   `Nat.divisors 11`, and four `ZMod 23` vector evaluations. `ResidualNotInM.lean:59,70,98,318`
   and `PSLCard.lean:782–795` are small enough that plain `decide` (kernel-checked) or
   `norm_num`/`simp` with `Finset.sum` unfolding should work directly. Try those first;
   they are pure wins.
2. The 1320-element sweeps (`slCardOrder_*`, `slChiSumSq_eq`, `card_allSL4`,
   `conv4FailCount_eq_zero`) will not survive plain `decide` at default settings. Options:
   raise `maxRecDepth`/`Nat.binaryRec` friendliness and measure; restructure the sweep as a
   `Finset.sum` over an explicitly enumerated `List` with `List.all` + `decide`; or replace
   the enumeration with a structural proof (Sylow counting and conjugacy-class arithmetic
   already exist in this tree and in Mathlib, and would be shorter than the sweep).
3. Whatever cannot be discharged must be quarantined and *declared*: a single
   `NativeDecideLedger.lean` listing every remaining site with its statement, plus a
   `verify.sh` gate that fails if the set grows. Silent tolerance is what let this reach 32
   declarations.

**Comparison point — and a worked template.** `problems/B-conic-bundle-multisections/` —
same toolchain, same Mathlib commit, ~100k lines, a much harder theorem — uses
`native_decide` **zero** times and declares **zero** project axioms (verified by grep). It
uses `decide` 114 times but only on trivially decidable finite propositions (`Fin 3` index
inequalities and the like), never to certify field arithmetic.

How B verifies an *explicit* witness without deciding anything (`BConicBundleMultisections/Bidegree23Example.lean`,
787 lines) — this is the pattern E should copy:

1. Build the object from a small coefficient matrix chosen in generic position, so that the
   property to be checked reduces *algebraically* to finitely many scalar nonvanishing
   conditions (there: 19 — all entries, all 2×2 minors, the determinant).
2. Pick the matrix so those scalars are small numerals
   (`vandermonde123 = !![1,1,1;1,2,4;1,3,9]`, or `universalMatrix = !![1,1,1;1,2,3;1,3,4]`
   whose 19 values are all `±1…±4`).
3. Discharge them with `norm_num` plus small `NeZero`-derived helpers
   (`NeZeroTwoThree.lean`: `four_ne_zero'`, `six_ne_zero'`, …) — genuine algebra, not a
   truth table.
4. Feed the result into a proved criterion to get the real instance.

B proves the *negative* direction the same way: `not_smooth_F_of_ringChar_five` exhibits an
explicit singular point at char 5 by direct computation, no `decide`.

E's `native_decide` sites are mostly of exactly this shape — small `ZMod 23` vector
evaluations (`ResidualNotInM.lean:59,70,318`), `Nat.divisors 11` (line 98), and `pslOrd` of
five explicit matrices (`PSLCard.lean:782–795`). There is no argument from necessity here.

### D2. `ResidualNotInM.lean` does not compile, at HEAD or in the working tree

`V14Formalization/ResidualNotInM.lean` is the frontier module for the M-cut programme
(residual Plücker point ∉ M over K).

* **Working tree** (uncommitted, +690/−211 lines): 11 elaboration errors. Reproduce:
  `lake build V14Formalization.ResidualNotInM`. Errors at lines 367, 368, 428, 473, 484,
  578, 637, 735 (a syntax error: `unexpected token 'have'`), 803, 805. Two are unqualified
  identifiers — `mem_MFix_of_chiCrossTerm_eq_forty_two` and
  `not_mem_MFix_of_cross_parallel_ne_forty_two` — which exist but in a namespace the file
  does not open.
* **At HEAD** it is worse: `open BigOperators GeometricFanoCarrier` sits *before*
  `namespace V14Formalization`, so the namespace does not resolve (`unknown namespace`)
  and ~30 errors cascade from it. Verified by extracting `git show HEAD:…ResidualNotInM.lean`
  into a scratch module and building it.
* Because elaboration errors are filled with `sorryAx`, the module's two top-level results
  — `residual_plucker_not_mem_Msub` and `not_pureM_residual` — currently *print* as
  depending on `sorryAx`.

The uncommitted work is a genuine repair-and-extend (namespace fixed, F₂₃ certificate and
`reduceCyclo : ℤ[ζ₁₁] → F₂₃` added), just unfinished. The real mathematical gap behind the
errors is the one the file's own header names: the K-model match — free S-module Plücker
coordinates of the residual `tDiff`, and its identification with `pureMWitness` under
reduction.

**Fix:** finish or revert. Do not leave a red module in the tree.

### D3. Nothing builds `ResidualNotInM`, so nothing catches D2

`V14Formalization.lean` (the root module) does not import `ResidualNotInM`, and no other
module does either — verified by grep. Lake's default target is the root's import closure,
so `lake build` never touches the file, and `scripts/verify.sh` never mentions it. **A red
module reads as green.**

**Fix (do this first, it is five minutes and it is what let D2 persist):**

1. Add `import V14Formalization.ResidualNotInM` to `V14Formalization.lean`.
2. Change `scripts/verify.sh` to build *every* `.lean` under `V14Formalization/` rather
   than the root import closure — e.g. glob the directory and `lake build` each module, or
   add a `lean_lib` with `globs = #[.andSubmodules \`V14Formalization]`.
3. Add the `#print axioms` parse from D1 as a gate, with an explicit allowlist.

### D4. Committed build artifacts in `.lake/` are stale and misleading

`.lake/build/` is tracked in git. The committed
`.lake/build/lib/lean/V14Formalization/ResidualNotInM.olean` does **not** correspond to the
committed source — the source does not compile, so that `.olean` is from an older revision.
Anyone inspecting the tree for evidence of a successful build will be misled.

**Fix:** `.gitignore` the `.lake/build` tree. If artifacts must be committed for some
downstream consumer, regenerate them in the same commit as any source change and add a
freshness check to `verify.sh`.

---

## S2 — Faithfulness: the theorems do not mean what their names claim

These are all recorded honestly in `FAITHFULNESS_CHECK.md` — they are known gaps, not
concealed ones. They are listed here because a reader of the theorem statements alone would
be misled, and because they define the actual remaining work.

### D5. `SmoothProjectiveGVariety` is neither smooth, nor projective, nor a variety

`V14Formalization/Definitions.lean:181`. The structure is: a type `X`, an injection
`X ↪ ℙ k ambient` into Mathlib's `Projectivization`, a `G`-action on `X`, a linear
`G`-action on `ambient`, and a compatibility square. There is no scheme, no Zariski
topology, no smoothness condition, no closed-subvariety condition — nothing constrains `X`
to be the point set of an algebraic variety at all.

Consequence: `Y.fixedBy N = ∅` (Hypothesis B) is a statement about a bare `G`-set, and
"Hypothesis (a)" quantifies over arbitrary *subsets* of that set.

**Fix direction:** rebuild on `AlgebraicGeometry.Scheme`. Note that Mathlib v4.32.1 has
**no** bridge from `Projectivization` to `Scheme` — verified: nothing under
`Mathlib/AlgebraicGeometry/` mentions `Projectivization`. So this is not a matter of finding
the right import; the current foundation is disconnected from schemes by construction. See
the reuse section below — Problem B already has ℙⁿ as `Proj` with charts.

**Blast radius is small:** `SmoothProjectiveGVariety` appears 40 times across 8 files and
`GEquivariantMorphism` 9 times, concentrated in `Definitions.lean` and `Foundations.lean`.
The 16k lines of group/character theory underneath reference neither.

### D6. `GEquivariantMorphism` is not a rational map — this is the weakest link

`V14Formalization/Definitions.lean:282`. It is an **everywhere-defined** map `X.X → Y.X`
that is induced by an **injective linear** map of ambient modules. A genuine rational map
ℙ(V) ⇢ Y is given by a linear system of degree-`d` forms and is undefined on a base locus;
it is not induced by a linear map of ambients, and there is no injectivity constraint.

Two separate problems:

* **Everywhere-defined.** The writeup's Theorem 3.1 resolves a rational map and tracks a
  stratum through the resolution. Modelling the resolved map directly is defensible as a
  first pass (the README says "resolved `GEquivariantMorphism`"), but the resolution step is
  then assumed, not proved.
* **`lin_injective` and linear-induced.** Negating the existence of such a map is a much
  weaker statement than negating the existence of a rational map. `lin_injective` even
  forces `dim V ≤ dim ambient(Y)`, which is an artifact of the encoding with no counterpart
  in the mathematics.

**Fix direction:** Mathlib v4.32.1 already provides `Scheme.RationalMap` (`⤏`),
`Scheme.PartialMap`, `RationalMap.IsDominant`, `RationalMap.comp`/`compHom`,
`Scheme.functionField`. Problem B uses exactly these. E should too, then add
G-equivariance on top.

### D7. `IsRCC` is "contained in a linear subspace", not rational chain connectedness

`V14Formalization/Definitions.lean:262`, via `IsLinearRCC`: a set is "RCC" iff its image
lies in a positive-dimensional linear subspace of the ambient projective space. That is a
sound *sufficient* condition for the argument as encoded, and `HypothesisA` is correspondingly
weakened to "no positive-dimensional linear subspace inside `Y^σ`" — but the name invites
the reader to think rational chain connectivity has been formalized. It has not.

**Fix:** at minimum rename to `IsLinearlyDegenerate` / `HypothesisA_linear` so the statement
is self-describing; properly, prove the writeup's Hypothesis (a) shape.

### D8. The headline theorem's `Y` is the coset space G/C₁₁, not the Fano threefold V₁₄

`V14Formalization/V14Application.lean:307`: `V14App.V14Variety := GeometricCarrier.V14Variety`,
the left cosets of the order-11 unipotent subgroup, with Hypotheses (a) and (b) proved from
|N| = 12 ∤ 11. So `V14_not_GUnirational` is a true theorem about a genuine object, but that
object is **not** V₁₄ = Gr(2,6) ∩ ℙ(M), and the paper's Corollary 6.1 is about V₁₄.

The M-cut replacement is scaffolded but not wired in: `IsV14MPoint`
(`GeometricV14Carrier.lean:2277`) is `IsDecomposable p ∧ p.rep ∈ Msub`, with `V14MPoint`,
`actV14M`, `embedV14M` built on it. Remaining, per `FAITHFULNESS_CHECK.md:154–156`:
`V14MVariety` faithful + nonempty, `V14_hypothesisB` on the M-cut, and the rewire.
Blocking all of it: D2, and the K-model match inside it.

Note the base field is `k = K = ℚ(ζ₁₁)` (`WeilRep.lean:53`, `AdjoinRoot Φ11`), char 0,
**not** algebraically closed. `U` is 6-dimensional, `Λ²U` is 15-dimensional.

### D9. `IsGUnirational` uses surjectivity-on-points, not scheme-theoretic dominance

`V14Formalization/Definitions.lean:304,537`: `HasDominantGEquivariantRationalMap` is
`∃ f : GEquivariantMorphism X Y, Function.Surjective f.toFun`. Given D5 (no scheme) and D6
(not a rational map), "dominant" here is surjectivity of a map of bare sets. Mathlib's
`IsDominant` (dense image) and `RationalMap.IsDominant` are the right notions and are
available.

### D10. The writeup shape of Hypothesis (a) is never constructed

`FAITHFULNESS_CHECK.md:20`: the operational linear-RCC form is proved on pure Gr, but the
writeup's genus-1-plus-two-points shape is not built. Recorded here so it is not lost when
D5–D9 are addressed.

### D11. `FAITHFULNESS_CHECK.md` overstates the axiom situation

Lines 7–9 claim: *"Zero project `axiom` / `sorry` / `admit` / `sorryAx` on the shipped path
and on all green geometric lemmas in `GeometricV14Carrier`. `#print axioms` → only
`propext`, `Classical.choice`, `Quot.sound`."*

The first sentence is true. The second is false for `GeometricV14Carrier`: 32 declarations
there and in `Ord11CharacterSum`/`PSLCard` carry `native_decide` axioms (D1). Line 46 of the
same file is honest about it ("classical + native_decide only"), so the document contradicts
itself.

**Fix:** correct lines 7–9 to scope the classical claim to the six headline theorems and
state the `native_decide` count explicitly.

---

## S3 — Hygiene

### D12. Fourteen `probe_*.lean` scratch files (188 KB) are committed at the project root

They are explicitly excluded from the `verify.sh` sorry census by
`--glob '!probe*.lean'`, and `probe_irr_trace.lean` does contain a `sorry`. They are not
part of any build target.

**Fix:** move to a `probes/` directory outside the library, or delete. If kept, drop the
census exclusion so they are held to the same standard.

### D13. `verify.sh`'s sorry census filters by grepping out prose

`scripts/verify.sh` pipes its `rg` output through
`grep -v 'zero \`sorry\`' | grep -v 'no sorry' | grep -v '# Zero'`. This is fragile: any
future comment phrased differently trips a false failure, and — worse — a real `sorry` on a
line that happens to contain one of those strings is filtered out. Prefer
`#guard_no_sorry` on the audited endpoints (Problem B uses exactly this in
`MainTheoremGuard.lean`), which is an elaborator check rather than a text match.

---

## Reuse: what to take from `problems/B-conic-bundle-multisections/`

Same repo, **same toolchain and same Mathlib commit** (`v4.32.1`, `520045ab14e2…`), so code
copies over and compiles unchanged. B proves unirationality of smooth bidegree-(2,3)
hypersurfaces in ℙ²×ℙ² using genuine scheme theory, with zero `native_decide` and zero
project axioms. It is the model for what E's foundations should look like.

**The single most valuable artifact is `B/CONCEPT_LEDGER.md`** — a 651-line audit tagging
every concept as reuse-from-Mathlib / thin wrapper / genuinely missing, with pinned Mathlib
declaration names. Its §2 (scheme language) and §4 (rational maps, dominance, unirationality)
answer most of "what should E's definitions actually be", and its §13 records what was
*missing* at this Mathlib revision so E does not re-discover the same gaps.

### Directly portable, no B-specific baggage

| From B | Gives E | Fixes |
|---|---|---|
| **`BConicBundleMultisections/ProjectiveSpace.lean`** (296 lines, **0 B-deps**) — `abbrev ProjectiveSpace (n) (R) : Scheme := Proj (MvPolynomial.homogeneousSubmodule (Fin (n+1)) R)` at line 41, plus `toSpec`, `StandardChartRing`, `standardChart`, `standardChartι`, `isAffineOpen_standardChart`, `standardAffineOpenCover` | ℙⁿ as a genuine `Scheme` — the drop-in replacement for `ℙ k ambient`. Set `n := 14`, `R := k`. Dimension-generic by design (`ProjectivePlane.lean` is just `abbrev ProjectivePlane R := ProjectiveSpace 2 R`) | D5 |
| `ProjectiveSpaceChartDominance.lean` (229 lines) — `ProjectiveSpace.irreducibleSpace`, `.isReduced`, `.isIntegral`, `.genericPoint`, `isDominant_standardChartι`, for `[CommRing R] [IsDomain R]`, arbitrary `n` | irreducibility/density needed to reason about ℙⁿ; documented in B as a Mathlib gap | D5, D9 |
| `Unirationality.lean` (265 lines, **0 B-deps**) — `lemma compHom_compHom` (line 36), `lemma isDominant_compHom` (line 46); also `UnirationalParametrization`, `HasUnirationalParametrization`, `IsUnirationalOver` | composition lemmas for `Scheme.RationalMap` missing from Mathlib; and the vocabulary E's `IsGUnirational` should be built from | D6, D9 |
| `GenericPointDominance.lean` — `isDominant_fromSpecFunctionField` | dominance of `Spec k(X) ⟶ X` for integral `X` | D9 |
| `PointedConicOpenDominance.lean:336–356` — `injective_of_isDominant_specMap`, `isDominant_specMap_of_injective` | detect dominance on an affine chart via a ring map | D9 |
| `IdealSheafDescent.lean` (142 lines, **0 B-deps**) — `comap_iInf_of_isOpenImmersion`, `le_comap_map_of_isPullback`, `finiteOpenClosure_comap_eq` | the machine that turns compatible per-chart ideals into one global ideal sheaf; reusable verbatim | D5 |
| `SchemeImageIntegral.lean`, `IntegralOpenCover.lean`, `IntegralFunctionFieldGluing.lean` | small self-contained generic scheme lemmas (1–5 each) | D5 |

### A recipe, not an API

B's bridge from explicit polynomial data to a `Scheme.RationalMap` is a two-stage pattern,
re-instantiated by hand each time rather than packaged:

* **Stage A** — algebra data → morphism into a closed subscheme, via
  `IsClosedImmersion.lift` + `lift_fac` (see `ResidualImageAlgebraPoint.lean:246`).
* **Stage B** — chart map → `Scheme.PartialMap` (with `domain := PrimeSpectrum.basicOpen denom`
  and a `dense_domain` proof from `IsDomain` + `IrreducibleSpace`) → `.toRationalMap`
  (see `ResidualImageRationalParam.lean:471–496`, `ResidualComponent.lean:122–172`).

E will inherit the pattern, not a callable function. Worth reading before designing E's
version.

### What B does NOT have

No group actions on schemes, and no complete-intersection Jacobian criterion. Both are
detailed in "Two things nobody has" at the end of this file — read that before scoping the
port, because they are the only parts that are not copy-and-adapt.

### Cutting V₁₄ out by several equations is not blocked

E needs Gr(2,6)'s Plücker quadrics **plus** the linear forms cutting ℙ(M) — a complete
intersection, not a hypersurface. B only ever cuts by one equation
(`ProjectiveHypersurfaceScheme.lean`: `projectiveZeroLocusIdeal`,
`projectiveZeroLocus`, `projectiveZeroLocusι`, `ker_projectiveZeroLocusι`, plus the affine
presentation `hypersurfaceChartIsoSpecAffineQuotient`), and by exactly two in one bespoke
file (`BiprojectiveTwoEquationAffine.lean`, literally `ideal F ⊔ ideal G`).

But `Scheme.IdealSheafData` is a `CompleteLattice` in Mathlib
(`Mathlib/AlgebraicGeometry/IdealSheaf/Basic.lean`, with `ideal_iSup`), so generalizing
`F ⊔ G` to `⨆ i, projectiveZeroLocusIdeal n k (Fs i)` over a finite family is a mechanical
extension, not new mathematics. **Do not import `BiprojectiveTwoEquationAffine.lean`** — it
drags in 111 modules / 47.9k lines of the (2,3) residual apparatus. Reimplement the `⊔`
pattern directly against `projectiveZeroLocusIdeal`.

### Smoothness: B has a full Jacobian criterion, but only for one equation

`BiprojectiveAffineJacobian.lean` (namespace `Hypersurface`) and
`BiprojectiveSmoothCriterion.lean` give **both directions**, fully proved, generic in the
polynomial and the index type, built on Mathlib's `Algebra.Extension.Cotangent` /
`RingHom.Smooth`:

* `exists_pderiv_ne_zero_at_of_smooth`, `pderiv_span_eq_top_of_smooth` (smooth ⟹ Jacobian)
* `smooth_of_pderiv_span_eq_top`, `smooth_of_exists_pderiv_ne_zero`, and
  `smooth_of_exists_pderiv_ne_zero_of_geometric` (Jacobian ⟹ smooth; the `_of_geometric`
  form lets the base field be arbitrary and checks nonvanishing over an algebraically closed
  extension — which is what E needs, since `k = ℚ(ζ₁₁)` is not closed)

**Caveat that matters for D5:** the proof rests on the conormal module `I/I²` being free of
rank one, generated by the class of `f` (`principalConormalEquiv`). V₁₄ is codimension > 1,
so this does **not** cover it. Reaching a complete-intersection Jacobian criterion (rank-`c`
free conormal module for a regular sequence, Jacobian *matrix* of rank `c`) means redoing
that argument — same technique, more work, and nobody has formalized it here. Budget for it.

`Standard/GenericSmoothness.lean` states Hartshorne III.10.7 as an honest `sorry` with a
survey of what Mathlib lacks — worth reading as a map, contributes no proof.

### Other generic lemmas worth lifting

| From B | What it gives |
|---|---|
| `DeterminantHomogeneous.lean` (45 lines, 0 B-deps) — `Matrix.det_isHomogeneous` | det of a matrix of degree-`d` homogeneous polys is homogeneous of degree `size·d`; a genuine Mathlib gap, directly relevant to Plücker-coordinate determinants |
| `ConicDiscriminantKernel.lean` — `exists_kernel_vector_no_common_root` | for any `m×m` matrix over `k[t]` with vanishing determinant, a nonzero kernel vector whose entries have no common root; documented as "nothing special to 3×3"; proved by minimal-degree argument, no `GCDMonoid` |
| `IntrinsicGoodLine.lean` — `span_pair_eq_iff_exists_gl2` | two independent pairs span the same 2-plane iff related by an invertible 2×2 matrix; Mathlib's `span_pair_*` family is about ideals, so this is missing there. Directly relevant — E reasons about R-stable 2-planes constantly |
| `MvPolynomialFractionFieldDivisibility.lean` — `dvd_of_map_dvd_map_of_isFractionRing` | Gauss-style descent: check divisibility after mapping to the fraction field |
| `UFDQuotientTorsionFree.lean` | UFD quotient torsion-freeness and domain descent — the denominator-clearing shape E's "reduce mod 23" arguments need |
| `AlgebraicIndependenceJacobian.lean` — `MvPolynomial.pderiv_aeval` | multivariate chain rule for `pderiv ∘ aeval`; docstring notes Mathlib has only the univariate `Derivation.apply_aeval_eq` |
| `BinaryResultant.lean` | fixed-degree (nominal-degree) resultant of two binary forms over any commutative ring, with `resultant_map` naturality and vanishing criteria including roots at infinity |
| `CubicFiberSingularLocus.lean` — `exists_defining_set_forms_no_common_zero` | for a finite family of homogeneous forms over any commutative ring, an explicit determinant certificate set detecting "no nontrivial common zero" under specialization — deliberately avoids scheme theory |

**What B does not have that E might have hoped for:** no exterior-power / Λ² infrastructure
at all (B works with plane conics, never Grassmannians), and everything under
`PointedConic*`, `IsotropicCone.lean`, `HomogeneousQuadraticEval.lean` is hardcoded to
`Fin 3` ternary quadratics — it does not transfer to the Plücker quadrics.

Also missing in B, so E must build them: nonemptiness of a zero locus for general `n`;
integrality of a projective hypersurface for general `n` (`IrreducibleProjectiveHypersurfaceIntegral.lean`
is hardcoded to `Fin 3`, though its supporting lemmas are generic); and any theorem
comparing the naive point-level zero locus (`ProjectiveHypersurfacePoints.lean`, which sits
on `Projectivization` and matches E's current style) with the scheme-theoretic
`projectiveZeroLocus`. That last bridge is exactly what E needs to connect its existing
`IsV14MPoint` work to a scheme — the ingredients are present in B
(`ker_projectiveZeroLocusι`, `ChartHomogenization.lean`) but never assembled.

### Import vs. port

Same toolchain and pinned Mathlib in both `lakefile.toml`s, so E could add B as a Lake
dependency and import directly. Measured transitive B-only dependency weight:

| File | B-deps | B-lines pulled in |
|---|---|---|
| `ProjectiveSpace.lean` | 0 | 0 |
| `IdealSheafDescent.lean` | 0 | 0 |
| `Unirationality.lean` | 0 | 0 |
| `DeterminantHomogeneous.lean` | 0 | 0 |
| `ProjectiveHypersurfaceScheme.lean` | 17 | 5216 |
| `BiprojectiveTwoEquationAffine.lean` | 111 | 47900 |

The zero-dependency files are drop-ins. `ProjectiveHypersurfaceScheme.lean` costs 5216 lines
of mostly-irrelevant biprojective/fiber code (pulled in transitively via
`ProjectiveSpaceClosedPoints.lean` → `BiprojectiveFiberEquationBaseChange.lean`); it
compiles fine but is not minimal. Selective port of ~2000 generic-`n` lines
(`ProjectiveSpace.lean` + the `namespace ProjectiveSpace` halves of `BiprojectiveChart.lean`,
`BiprojectiveOverlap.lean`, `BiprojectiveOverlapScheme.lean`, `BiprojectiveAffineChart.lean`,
plus `ChartHomogenization.lean` and `IdealSheafDescent.lean`) avoids the dead weight. Note
the single-ℙⁿ content is textually separate but not separately importable — every
biprojective file opens with a `namespace ProjectiveSpace` section and then builds the
product on top in the same file.

---

### D14. The base field narrows the published theorem, in two ways

Added 2026-08-18. See `FIELD_CRITERIA_2026-08-18.md` for the full accounting.

`noEquivariantRationalMap_from_ambient` fixes `k = V14SchemeModel.k = ℚ(ζ₁₁)` and
quantifies over `FaithfulLinearRep k G V`. That is weaker than the intended
statement in two independent ways:

1. A rational map over `ℂ` does not descend to `ℚ(ζ₁₁)`, so "no `ℚ(ζ₁₁)`-map" does
   not exclude a `ℂ`-map. The formalization proves the weaker direction.
2. `PSL(2,11)`'s two 12-dimensional irreducibles have character field `ℚ(√5)`, and
   `ℚ(√5) ⊄ ℚ(ζ₁₁)` (the only quadratic subfield there is `ℚ(√−11)`). They are
   faithful, and they are outside the theorem's scope.

**Partly addressed 2026-08-18.** Hypothesis (b), `V₁₄^{D₁₂} = ∅`, is now proved
over *every* field receiving a ring map from `ℚ(ζ₁₁)`
(`V14D12FixedPointExclusionOverField.no_centralizer_fixed_point_over`), and over
`ℂ` (`…Complex.no_centralizer_fixed_point_complex`). The four-piece matrix
certificate was shown to be base-change stable
(`D12CertificateBaseChange.lean`): the only field-dependent inputs are three
explicit scalars whose norms are `11⁶`, `11⁴`, `11⁴` after clearing the single
denominator 2. So the emptiness is ideal-theoretic, not point-counting, and no
large bad prime hides in it.

**Still open**: hypothesis (a) over a general field, and hence the headline
itself. `FIELD_CRITERIA_2026-08-18.md` lists the five remaining pieces. The
blocker is that the plane-cubic descent (`EllipticPolynomialConstancy`) runs on
`Polynomial.eq_C_of_derivative_eq_zero` and Mason–Stothers, so as formalized it
needs `CharZero`, not merely `char ≠ 2, 3`.

---

### D15. A `sorry`-skeleton challenge cannot pass Comparator on this statement

Evaluated `mattrobball/lean-stan` v0.2.2 (`cbab4e2985121ab3174d6a3b0fc5ba78dcd047af`)
as a replacement for the hand-written `V14Challenge.lean`: emit the statement's whole
trusted base into one Mathlib-only file with proofs replaced by `sorry`, and make that
the challenge. The build economics are excellent and both published statements match.
Comparator still rejects it, for a reason that is nothing to do with the emitter.

`Comparator/Compare.lean` compares each named theorem by `ConstantVal` alone, then
walks every constant reachable from its type and requires the challenge's and the
solution's full `ConstantInfo` — **values included** — to be equal;
`Comparator.runForUsedConsts` follows `info.value?`, so definition bodies are walked
and every theorem they name is compared as a proof term. This statement's vocabulary
is proof-carrying. In a skeleton those proofs are `sorryAx`; in the solution they are
real. Mismatch, reject. Listing them in `theorem_names` does not rescue it — inside
`Compare.loop` only `definition_names` gets type-only treatment, and
`definitionHoleMatches` demands a `.defnInfo`, which a theorem is not.

**Updated 2026-08-18.** The clearest instance used to be the coordinate choice:
`SchemeGeometry.ambientOf` unfolded to `PlusMinusCoords.ofRep`, whose body reads

```lean
let h := exists_plus_minus_projective_bases R sigma sigma_isInvolution (not_degenerates R)
```

so the walk reached `not_degenerates` and `exists_plus_minus_projective_bases`. That
one is now fixed at the source — the published theorems take the coordinates as a
parameter, so `ofRep` is no longer reachable (see MODULE_MIGRATION.md, "THE PUBLISHED
STATEMENTS CHANGED"). **It did not rescue the skeleton**: 38 mismatches became 36. The
rest are structural rather than incidental — `sigma_isInvolution` (passed to
`plusMinusAmbientBasis` inside `ambientFor`), `projectiveActionHom_one`/`_mul`/`_isOver`
(a `MatrixRepresentation` is a monoid hom), `projectiveZeroLocusFamilyι_isClosedImmersion`
and `invariantIdeal` (`ProjectiveGVariety.v14` is a closed subscheme, and the immersion
is a proof field), plus the Weil-representation homomorphism laws and seven
`Fact`/`CharZero` instances. A skeleton challenge needs vocabulary with no proof
fields at all, which this statement does not have and arguably should not.

Measured on this machine with the emitted file swapped in as `V14Challenge.lean`
(Mathlib cached, `LEAN_NUM_THREADS=8`):

| challenge | statements | reachable-constant walk | `lake build V14Challenge` |
|---|---|---|---|
| hand-written, before the restatement | match | 55029 constants, 0 mismatches | 3406 jobs, 230 s |
| stan skeleton, 193 decls / 24 modules / 1886 lines | match | 34702 constants, **38 mismatches** | 8656 jobs, 8 s |
| hand-written (HEAD, coordinates parameterized) | match | 54997 constants, 0 mismatches | 3406 jobs |
| stan skeleton, 189 decls / 24 modules / 1863 lines | match | 34695 constants, **36 mismatches** | 8656 jobs, 9 s |

Note that `scripts/check_module_invariants.sh` step 3 **passes** on the skeleton:
`Expr.eqv` and `levelParams` agree on both published theorems and the axiom set is
clean. Step 3 only models Comparator's statement match. Step 4
(`scripts/check_comparator_walk.lean`) was added for exactly this gap; it reports
`38 mismatches` on the skeleton and `0` at HEAD.

Two separate limitations of the emitter were also found and are worth reporting
upstream, but they are secondary to the above: `stan_boundary` is not module-system
aware (its final line filter drops any line starting with `@[expose]`, which in this
tree decapitates the declaration written on that same line, and it emits neither the
`module` header nor `public import`; 101 elaboration errors), and both entry points
take a single target, while the two published theorems have incomparable closures
(174 and 188 declarations, union 193; 189 after the 2026-08-18 restatement), so one
run cannot cover both. A local multi-target patch exists
(`/tmp/claude-502/lean-stan-module-system-and-multitarget.patch`) and is what the
two-target figures above were measured with; it is not upstream.

## Suggested order of work

1. **D3** (build coverage) — five minutes, and it is what allowed D2 to persist.
2. **D1 tier-1** (`decide` for the small computations) — mechanical, pure win.
3. **D2** (finish or revert `ResidualNotInM`) — currently blocks the whole M-cut route.
4. **D11, D12, D13, D4** (documentation and hygiene) — cheap, and they stop the tree from
   misrepresenting itself.
5. **D1 tier-2** (the 1320-element sweeps) — decide between a kernel-checkable
   reformulation and a structural proof. This must land before any rewire onto the M-cut
   carrier, or the taint moves onto the headline.
6. **D5/D6/D9** (rebuild the foundations on `Scheme` + Mathlib `RationalMap`, using B's
   `ProjectiveSpace` and the portable lemmas above) — the large one, but the blast radius is
   only `Definitions.lean` + `Foundations.lean` + the carriers. Suggested sequence: drop in
   `ProjectiveSpace.lean` and `IdealSheafDescent.lean` (zero-dependency); build V₁₄ as
   `⨆ i, projectiveZeroLocusIdeal 14 k (Fs i)` over Plücker quadrics + linear forms; then
   swap `GEquivariantMorphism` for Mathlib `Scheme.RationalMap` + an equivariance condition.
7. **D8, D10** (the actual V₁₄, and the writeup shape of Hypothesis (a)) — the mathematics
   that makes Corollary 6.1 the paper's corollary.

## Two things nobody has, and E must build regardless

* **A G-action on a scheme.** No `MulAction G X` for `X : Scheme`, no G-scheme notion, no
  equivariant morphisms, no fixed loci as closed subschemes — not in B (confirmed by grep
  across all 335 files; the only `SMul`/`MulAction` hits are `Algebra`-instance boilerplate
  on chart rings) and not in Mathlib. Everything that makes E's theorem *equivariant* is E's
  own work. B supplies only the non-equivariant scaffolding to build it on, and a template
  for how that scaffolding should look.
* **A complete-intersection Jacobian criterion.** See the smoothness section above: B's
  criterion is for one equation, V₁₄ is codimension > 1.

These two are the honest scope of the port. Everything else in the reuse section is
copy-and-adapt.
