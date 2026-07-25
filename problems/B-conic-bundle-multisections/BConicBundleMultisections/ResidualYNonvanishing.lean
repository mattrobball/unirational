/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.CubicFiberSingularLocus
public import BConicBundleMultisections.GoodLineCondition
public import BConicBundleMultisections.ResidualYCoordsPureT

/-!
# Obligation 1: residual `Y`-coordinates do not vanish

See `ResidualComponentAssembly.lean` for the inventory of obligations and `PLAN.md` WP-C.

## The route, and why it changed

`residualYCoords_ne_zero_of_smooth` is **derived**, from a single obligation: that *some*
stereographic specialization has a nonsingular cubic fibre with independent residual-line
endpoints.  The reduction is `residualYCoords_ne_zero_of_exists_nonsingular_stereo`
(`SpecializedConicFreeDir.lean:1692`), which is proved.

This is the source proof's route.  §1 of
`certificates/all_smooth_tangent_residual_theorem.md` establishes, by **generic smoothness** in
characteristic zero, that the generic fibre `C` of `ρ : X → ℙ²_x` is a *smooth* plane cubic; a
smooth plane cubic contains no line, so the tangent-residual construction is nondegenerate and the
residual point is a genuine point of `ℙ²_y`.

An earlier arrangement instead attempted a three-way case analysis on the residual tangent
direction at the coordinate-line point, splitting obligation 1 into four
(`exists_three_freeDir_polar_roots`, `residualImageXCoords_two_ne_zero`, and two branch lemmas).
That decomposition has been **withdrawn**.  It was built on the fixed coordinate line with no
genericity hypothesis, so two of its four pieces were statements the source proof does not make and
which are plausibly false; and its "crux" — whether a cubic can contain its own tangent line
identically in the parameters — cannot arise at all once the fibre is known to be smooth.  See
`PLAN.md`, "Correction: the missing good line".  The withdrawn material is in the git history.

## Two corrections to obligation 1, made here

1. **`CharZero` was missing.**  `exists_nonsingular_stereo_cubicFiber_of_smooth` asserts that some
   cubic fibre of `ρ` is *smooth*, which is generic smoothness for this fibration.  Generic
   smoothness is false in positive characteristic, and there is no dimension-theoretic obstruction
   to a smooth `X` over a field of characteristic `3` all of whose plane-cubic fibres are singular
   (see the obligation's docstring for the count).  The hypothesis is now carried; the call site
   `MainTheorem.lean:297` has it.

2. **The obligation was doing three jobs.**  Homogeneity of the specialized fibre, the linear
   independence of the residual-line endpoints, and the choice of a specialization point are now
   *proved* here, from a single remaining input:
   `exists_ne_zero_nonsingular_stereo_cubicFiber_of_smooth`, which says that the parameters `(t,s)`
   whose cubic fibre is singular form a proper closed subset of the parameter plane.

3. **That input was FALSE without a condition on `v`**, and generic smoothness is not what failed.
   In its unguarded form the obligation quantified over every legal Tsen section `v`, and when the
   conic family along the hardcoded line `L = {Y₂ = 0}` has a base point, taking `v` to *be* that
   base point makes the stereographic map constant, with a reducible — hence singular — cubic
   fibre.  An explicit linear system of smooth `F` realizing this is written out in the obligation's
   docstring, which also shows the same `F` and `v` made `residualYCoords_ne_zero_of_smooth` false.
   This is the hardcoded-line deviation (`PLAN.md` WP-G) biting, with a concrete witness rather than
   a suspicion.  The repair was to make the construction *choose* its section: `StereoNondegenerate`
   is threaded through the chain and `ResidualComponentAssembly.exists_residualChart_of_smooth`
   obtains its `v` from `exists_isotropic_stereoNondegenerate`.  The counterexample's `v` has
   vanishing polar, so it no longer applies.

## The remaining input, split in two

`exists_ne_zero_nonsingular_stereo_cubicFiber_of_smooth` is now *proved*, from two inputs that have
nothing to do with each other:

* `exists_defining_set_nonsingularCubicFiber` — the singular cubic fibres are a Zariski-closed
  subset of `𝔸³_x`.  Elimination theory; unconditionally true; no characteristic hypothesis, no
  smoothness of `X`, nothing about `L`.  **Now proved**, in `CubicFiberSingularLocus.lean`, as an
  instance of a general projective-elimination-on-points theorem stated for an arbitrary finite
  family of forms with coefficients in a commutative ring.
* `exists_stereo_param_nonsingularCubicFiber` — *some* stereo parameter pair has a nonsingular
  fibre, i.e. the stereographic image is not contained in the discriminant locus.  This is §4(1)
  together with §1 generic smoothness, and **it is the good-line condition**: it carries all the
  risk, and it is not to be attacked for the hardcoded coordinate line in isolation.

The split is the point.  A *single* discriminant `Δ` does not work: the two halves compose only if
`Δ` vanishes **exactly** on the singular locus, since a `Δ` satisfying merely
`Δ(x) ≠ 0 → nonsingular` is also satisfied by `Δ · X₂`, and the stereo family can sit inside
`{x₂ = 0}`.  Stating the first half with a *set* `S` and `V(S)` exactly the singular locus removes
that, at the cost of nothing: the derivation extracts its `Δ ∈ S` from the good parameter that the
second half supplies, rather than fixing one in advance.
-/

@[expose] public section

open CategoryTheory
open scoped AlgebraicGeometry

namespace BConicBundleMultisections

noncomputable section

universe u

open AlgebraicGeometry MvPolynomial BiprojectiveSpace
open _root_.MvPolynomial

/-- **The plane cubic fibre of `ρ : X → ℙ²_x` over the first-block point `x` is nonsingular.**

Nonsingularity in the form used throughout this development, and the form
`ResidualLineBasePointFree` consumes: no nonzero point of the cubic annihilates all three partial
derivatives.

For `F` of bidegree `(2, 3)` every monomial has `x`-degree exactly two, so the fibre over `x = 0` is
the zero polynomial and this predicate fails there; the locus it cuts out is a cone in `𝔸³_x` minus
the origin, i.e. a locus in `ℙ²_x`, which is where the source proof's discriminant lives. -/
def NonsingularCubicFiber {k : Type u} [CommRing k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (x : Fin 3 → k) : Prop :=
  ∀ r : Fin 3 → k, r ≠ 0 → eval r (specializeFirstCoordinates (n := 2) x F) = 0 →
    ∃ i : Fin 3, eval r (pderiv i (specializeFirstCoordinates (n := 2) x F)) ≠ 0

/-- **The stereographic map along `L` is non-constant.**

`stereoAlg Q v w = Q(w)·v − B(v,w)·w`.  When the polar `B(v, w)` vanishes identically the second
term disappears and the stereo point is a multiple of the fixed vector `v` — the image collapses to
the single point `[v]` of `ℙ²_x` and no longer sweeps a surface.  That happens exactly when `v` is a
base point of the conic family along `L`.

This is the non-degeneracy the obligations below were missing.  See the counterexample recorded on
`exists_ne_zero_nonsingular_stereo_cubicFiber_of_smooth`: for `a₀₁ = 0` and `a₁₁ = y₂·h`, the
section `v = (0,1,0)` is isotropic along `L` and makes this polar vanish. -/
def StereoNondegenerate {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (v : Fin 3 → Polynomial k) : Prop :=
  polarEval (specializedConicPullback F) (liftTsenSection v) affineTwoStereoDir ≠ 0

/--
**Some isotropic section is stereo-non-degenerate.**

*Status: derived*, in `GoodLineCondition.lean`, from one root:
`coordinateLineConicDiscriminant_ne_zero_of_smooth` — the generic conic along the line is smooth.
This was the repair the counterexample forced (the residual construction must *choose* its Tsen
section, not accept an arbitrary one), and it is now a consequence of a statement about the conic
family alone, with no reference to the stereo map.

*Why it is true, and what it really needs.*  Tsen supplies one isotropic section `v`.  If its polar
against `e₀` or `e₁` is nonzero, it is already good.  Otherwise isotropy forces `v₂ = 0`, and the
stereographic second intersection `stereoAlg Q v e₂` is good — unless the whole last row of the
polar matrix vanishes, which would put `v` in the radical.  So the *only* obstruction is a conic
whose isotropic sections all lie in its radical, and nondegeneracy of the polar matrix excludes
exactly that.  See `exists_isotropic_polarEval_ne_zero`.

*This is a genuine condition, not decoration.*  `specializedConicFreeDirForm_ne_zero_of_smooth`
(`Q(1, s, 0) ≠ 0`) does **not** suffice: over `k(t)` the rank-two conic `x₀² − t·x₁²` has its two
lines conjugate, so its only rational point is the vertex, every polar `B(v, ·)` vanishes, and yet
`Q(1, s, 0) = 1 − t s² ≠ 0`.  For such a conic family this statement is false.

*It is not refuted by the counterexample recorded below*, which kills the earlier `∀ v` form; this
one is `∃ v`, and on that family `v = (0, −a₂₂, a₁₂)` is isotropic with `s`-coefficient `a₁₂²`.

*And it is not a condition on `L`.*  For smooth `X` no line lies in the conic discriminant — see the
root's docstring — so the hardcoded coordinate line is as good as any.
-/
theorem exists_isotropic_stereoNondegenerate
    {k : Type u} [Field k] [IsAlgClosed k] [CharZero k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)] :
    ∃ v : Fin 3 → Polynomial k, v ≠ 0 ∧
      TernaryQuadraticPoly.eval (coordinateLineTernaryQuadraticPoly F) v = 0 ∧
      StereoNondegenerate F v :=
  exists_isotropic_stereoNondegenerate_of_disc_ne_zero F hF
    (coordinateLineConicDiscriminant_ne_zero_of_smooth F hF hF0)

/-- **Specializing the parameters commutes with pulling a form back along the stereo family.**

`aeval x Δ ∈ k[t,s]` is the pullback of a form `Δ` in the first-block coordinates along the
parameterization `x : 𝔸² → 𝔸³`; evaluating that pullback at `(t, s)` is evaluating `Δ` at the image
point.  This is what turns a form cutting out a locus in `ℙ²_x` into an element of `k[t,s]` cutting
out the bad parameters. -/
theorem evalAffineTwoPoint_aeval {k : Type u} [CommRing k] (t s : k)
    (x : Fin 3 → affineTwoRing k) (Δ : MvPolynomial (Fin 3) k) :
    evalAffineTwoPoint t s ((aeval x : MvPolynomial (Fin 3) k →ₐ[k] affineTwoRing k) Δ)
      = eval (fun i => evalAffineTwoPoint t s (x i)) Δ := by
  induction Δ using MvPolynomial.induction_on with
  | C a => simp [evalAffineTwoPoint, MvPolynomial.algebraMap_eq]
  | add p q hp hq => simp only [map_add, hp, hq]
  | mul_X p j hp => simp only [map_mul, aeval_X, eval_X, hp]

/--
**Input (i): the singular cubic fibres are a Zariski-closed subset of `𝔸³_x`.**

*Status: proved*, in `CubicFiberSingularLocus.lean`, by classical elimination theory.  This is the
half of the old fused obligation that is **unconditionally true**: no hypothesis on the
characteristic, no smoothness of `X`, and nothing whatever about the multisection line `L`.  The
general statement it instantiates —
`exists_defining_set_forms_no_common_zero`, projective elimination on points for an arbitrary finite
family of forms with coefficients in a commutative ring — is Mathlib-shaped and upstreamable.

*The statement.*  `S` is a set of polynomials in the first-block coordinates whose common zero locus
is *exactly* the locus of singular fibres: off `V(S)` the fibre is nonsingular, and on `V(S)` it is
singular.  Both directions are used below, and the **iff is the point**.  Suppose instead one fixed
a single `Δ` with only the implication `Δ(x) ≠ 0 → nonsingular`, and phrased the good-line half as
"`Δ` pulls back to a nonzero element of `k[t,s]`".  Then `Δ · X₂` also satisfies the implication
while the stereographic family can sit inside `{x₂ = 0}`, so the good-line half would be false for
that `Δ` and the two would not compose; only a genuine ternary-cubic discriminant, vanishing
*exactly* on the singular locus, would do.  With `V(S)` exactly the singular locus that disappears:
(ii) becomes a statement about the family alone — "some parameter has a nonsingular fibre" — and the
`Δ ∈ S` witnessing it is produced here rather than chosen in advance.  So what is required is
*closedness* of the singular locus, not a degree-twelve invariant.

*Why it is true.*  The incidence locus

```
Z = {(x, [r]) ∈ 𝔸³ × ℙ² : F(x, r) = 0 and ∇_r F(x, r) = 0}
```

is closed, being cut out by four forms bihomogeneous in `(x, r)` — this is where bidegree `(2,3)` is
used, and all that is used of it is that the fibre is a *form* in `r`.  Projective space is
complete, so the projection `𝔸³ × ℙ² → 𝔸³` is a closed map, and the singular locus is the image of
`Z`, hence closed.  Over an algebraically closed field a closed set is `V(I)` for `I` its ideal, and
`S := I` works; `S` may be taken finite by Hilbert's basis theorem, but finiteness is not used
downstream and is left out to keep the obligation as weak as possible.  The origin causes no
trouble: the fibre over `x = 0` is the zero polynomial, which is singular, and `0 ∈ V(S)`
accordingly.

*How it is proved, and why not with schemes.*  The properness route — `Z` closed in `𝔸³ × ℙ²`, `ℙ²`
complete, image closed — needs a bridge Mathlib does not have, even though it has the properness
itself (`Proj.toSpecZero` is `UniversallyClosed`): `Z` would have to be built as a closed subscheme
of a relative `Proj`, the fibres of `Proj (A[r]/J) → Spec A` computed, and a closed subset of
`Spec A` converted back into a condition on `k`-points.  The classical elimination proof needs none
of it and is what `CubicFiberSingularLocus.lean` formalises: for each degree `N` the products
`ν · fᵢ` span the degree-`N` part of the ideal iff some maximal minor of an explicit matrix — with
entries polynomial in `x` — is nonzero, and the Nullstellensatz says the ideal contains all
monomials of large degree exactly when the forms have no common zero off the origin.  `S` is the set
of those minors.  Mathlib has no multivariate resultant, and none is needed. -/
theorem exists_defining_set_nonsingularCubicFiber
    {k : Type u} [Field k] [IsAlgClosed k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F) :
    ∃ S : Set (MvPolynomial (Fin 3) k),
      ∀ x : Fin 3 → k, (∃ Δ ∈ S, eval x Δ ≠ 0) ↔ NonsingularCubicFiber F x :=
  exists_defining_set_nonsingular_cubicFiber_of_bidegree23 F hF

/--
**Input (ii): the stereographic image is not contained in the locus of singular fibres.**

*Status.* Obligation, and **all of the risk of the old fused statement now lives here**.  It is
§4(1) of `certificates/all_smooth_tangent_residual_theorem.md` together with §1 generic smoothness.
Unlike its former companion `exists_isotropic_stereoNondegenerate`, which is now *derived* from a
statement about the conic family alone, this one is **not** a consequence of the conic root: its
content is in `ℙ²_x`, about the cubic discriminant, and the conic root says nothing about it.

*What it says.*  Some single parameter pair `(t, s)` has a nonsingular cubic fibre over the
stereographic point `x(t, s) = residualImageXCoords F v`.  Equivalently: the stereographic family
does not lie inside the discriminant locus.  Nothing more is needed — input (i) upgrades one good
parameter to a Zariski-open set of them.

*Why it is true, and what a proof needs.*  Two ingredients.

1. **Generic smoothness** (§1).  `X` is smooth and `char k = 0`, so the plane cubic fibre of `ρ` is
   nonsingular over a nonempty open subset of `ℙ²_x`; the complement is the discriminant locus, a
   proper closed subset.  `CharZero` is load-bearing here and nowhere else in this chain: in
   characteristic `p`, Euler's identity in `y` degenerates and a fibration all of whose fibres are
   singular over a smooth total space is not excluded (quasi-elliptic fibrations in characteristics
   `2` and `3` realize this).  This is the coordinate form of
   `Standard.exists_nonempty_open_smooth_restrict` (Hartshorne III.10.7).
2. **The stereo image is not swallowed by that locus.**  This splits into two genuinely different
   cases, according to the Tsen section `v` the construction was handed.

   *Case `v₂ ≢ 0`.*  For fixed `t` the lines through `v(t)` meeting `{x₂ = 0}` are all the lines
   through `v(t)`, so `s ↦ x(t, s)` sweeps the whole conic `Q_t`; and the conics `Q_y`, `y ∈ L`, are
   not all proportional — if `Q_y = a(y)·Q₀` then the binary cubic `a|_L` has a root `y*`, and the
   whole fibre `ℙ²_x` over `y*` would lie in `X`, which smoothness forbids
   (`BiprojectiveNoWholeFiber`).  So the image is dense in `ℙ²_x` and (1) finishes.  In Lean this is
   `AlgebraicIndependenceJacobian.eq_zero_of_isHomogeneous_of_aeval_eq_zero` applied to
   `Y = residualImageXCoords F v` and a certificate `Δ` from input (i): a nonzero `3 × 3` Jacobian
   determinant `[Y, ∂Y/∂t, ∂Y/∂s]` gives `aeval Y Δ ≠ 0`, and `k` infinite then supplies `(t, s)`.
   That route needs the certificates of input (i) to be *homogeneous*, which they are — every entry
   of `famMatrix` is a coefficient of the fibre, hence a quadratic form in `x` — but this has not
   been proved.

   *Case `v₂ ≡ 0`.*  Then `v` and `w = (1, s, 0)` are coplanar, `x(t, s) = Q(w)·v − B(v,w)·w` stays
   in the line `{x₂ = 0} ⊂ ℙ²_x`, and the image is at most that line — dense in it by `hnd`, but
   never dense in `ℙ²_x`.  Here the Jacobian determinant *vanishes* and the route above cannot work.
   What is needed instead is that `{x₂ = 0}` is not contained in the cubic discriminant, which for
   smooth `X` follows by **the same argument as the conic root**
   (`GoodLineCondition.coordinateLineConicDiscriminant_ne_zero_of_smooth`) with the two factors
   exchanged: a line of singular fibres carries a section of singular points, differentiating along
   the line makes the other gradient a multiple of the line's equation, and that multiple is a form
   of positive degree on `ℙ¹`, hence has a zero — a singular point of `X`.

*The cheap repair, not taken here.*  Case `v₂ ≡ 0` disappears if the section is chosen with
`v₂ ≠ 0`, and the conic root already gives that: in the branch where `v₂ = 0` the vector
`stereoAlg Q v e₂` has last coordinate `−B(v, e₂) ≠ 0`, which is the same construction that proves
`exists_isotropic_stereoNondegenerate`.  So adding `v 2 ≠ 0` to that obligation's conclusion would
reduce this one to case `v₂ ≢ 0` alone.  It is **not** done here because the extra conjunct has to
be threaded through `ResidualComponentAssembly.exists_residualChart_of_smooth` and this module does
not own that file. -/
theorem exists_stereo_param_nonsingularCubicFiber
    {k : Type u} [Field k] [IsAlgClosed k] [CharZero k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)]
    (v : Fin 3 → Polynomial k) (hv0 : v ≠ 0)
    (hv : TernaryQuadraticPoly.eval (coordinateLineTernaryQuadraticPoly F) v = 0)
    (hnd : StereoNondegenerate F v) :
    ∃ t s : k,
      NonsingularCubicFiber F (fun i => evalAffineTwoPoint t s (residualImageXCoords F v i)) :=
  sorry

/-- **The split strengthened nothing: input (ii) is exactly the residue of the fused obligation.**

Read the hypothesis as the fused statement `exists_ne_zero_nonsingular_stereo_cubicFiber_of_smooth`.
It implies the second input, because `k` is infinite and so `D` has a non-root.  Together with the
derivation of the fused statement from the two inputs, this says the split is an *equivalence*
modulo the unconditionally true first input: nothing riskier than what was already assumed has been
introduced, and any refutation of input (ii) would refute the statement it replaces.  Stated with
the fused statement as an explicit hypothesis so that the two directions do not depend on each
other. -/
theorem exists_stereo_param_nonsingularCubicFiber_of_exists_ne_zero
    {k : Type u} [Field k] [IsAlgClosed k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (v : Fin 3 → Polynomial k)
    (h : ∃ D : affineTwoRing k, D ≠ 0 ∧
      ∀ t s : k, evalAffineTwoPoint t s D ≠ 0 →
        ∀ r : Fin 3 → k, r ≠ 0 →
          eval r (map (evalAffineTwoPoint t s)
              (cubicFiberPullback F (residualImageXCoords F v))) = 0 →
            ∃ i : Fin 3,
              eval r (pderiv i (map (evalAffineTwoPoint t s)
                (cubicFiberPullback F (residualImageXCoords F v)))) ≠ 0) :
    ∃ t s : k,
      NonsingularCubicFiber F (fun i => evalAffineTwoPoint t s (residualImageXCoords F v i)) := by
  classical
  obtain ⟨D, hD0, hD⟩ := h
  haveI : Infinite k := inferInstance
  obtain ⟨t, s, hts⟩ := exists_eval_ne_zero_affineTwoRing D hD0
  refine ⟨t, s, ?_⟩
  have hns := hD t s (by simpa [evalAffineTwoPoint] using hts)
  rwa [map_cubicFiberPullback_eq_specializeFirst] at hns

/--
**Obligation 1, narrowed: the singular stereo parameters are a proper closed subset.**

*Status: proved*, from two separately stated inputs, neither of which is this statement:

* `exists_defining_set_nonsingularCubicFiber` — the singular fibres are Zariski-closed in `𝔸³_x`
  (elimination theory, unconditionally true, nothing about `L`); and
* `exists_stereo_param_nonsingularCubicFiber` — *some* parameter pair has a nonsingular fibre
  (§4(1) generic choice of `L`, plus §1 generic smoothness).

The split matters because those two have different difficulty and different owners: the first is
Mathlib-shaped elimination theory, the second is the good-line condition `PLAN.md` WP-G.  Fused into
one statement neither could be attacked.  **All the risk sits in the second**; see its docstring for
what is and is not known.

*The derivation.*  Take `Δ ∈ S` not vanishing at the one good parameter point supplied by the
second input — this is where the *iff* in the first input is used, and it is the reason a bare
"`Δ ≠ 0` cuts out singular fibres" would not compose.  Then `D := Δ(x(t,s))`, the pullback of `Δ`
along the stereographic parameterization (`evalAffineTwoPoint_aeval`), is nonzero because it is
nonzero at that point, and wherever `D` is nonzero the other direction of the iff makes the fibre
nonsingular.  The identification of the specialized pullback fibre with the fibre over the
specialized point is `map_cubicFiberPullback_eq_specializeFirst`.

## Why the hypothesis `hnd` is there: the counterexample

Without `hnd` this statement is **false**, and the counterexample is worth keeping: it is what
forced `StereoNondegenerate` into the whole chain (commit `13a245c`, repaired in `d0dc40d`).  In
its unguarded form the statement quantified over *every* nonzero isotropic section `v` of the conic
bundle along the hardcoded coordinate line `L = {Y₂ = 0}`, and there are smooth `F` for which a
legal `v` makes the stereographic map **constant**.

*The counterexample.*  Write `F = Σ_{i ≤ j} a_{ij}(y) x_i x_j` with `a_{ij}` cubic in `y`, and take
the linear system

```
a₀₁ = 0,        a₁₁ = y₂ · h   (h a quadratic),      a₀₀, a₀₂, a₁₂, a₂₂ free.
```

Geometrically: every conic `Q_y = {x : F(x,y) = 0}`, `y ∈ L`, passes through the *fixed* point
`(0 : 1 : 0)` of `ℙ²_x` — the line `L` meets the locus over which the conic family has a base
point.  Then:

* `v := (0, 1, 0)`, constant, is a legal Tsen section: `Q_y(v) = a₁₁(y) = 0` for `y ∈ L`, and
  `v ≠ 0`.  So `hv0` and `hv` hold.
* The polar form vanishes: with `w := affineTwoStereoDir = (1, s, 0)`,
  `polarEval Q v w = a₀₁ + 2 a₁₁ s = 0` on `L`.  Hence
  `stereoAlg Q v w = Q(w) · v − polarEval Q v w · w = A(t) · (0,1,0)`, with
  `A(t) = a₀₀(1,t,0)`.  **`residualImageXCoords F v = (0, A(t), 0)`: the image is the single point
  `(0 : 1 : 0)`, independent of `s` and, projectively, of `t`.**
* The cubic fibre there is `specializeFirstCoordinates (0, A, 0) F = A² · a₁₁(y) = A² · y₂ · h(y)`
  — a line union a conic.  A line and a conic in `ℙ²` always meet, and at a common zero `r` of
  `y₂` and `h` one has `∇(y₂h)(r) = h(r)·e₂ + r₂·∇h(r) = 0`.  So the fibre is **singular for every
  `(t, s)`**, and when `A(t) = 0` it is the zero polynomial, which fails the condition too.

*Such an `F` is smooth.*  The base locus of the system is `{(0:1:0)} × L`, so by Bertini in
characteristic zero the generic member is smooth away from it; along it the gradient at
`((0,1,0), y)`, `y₂ = 0`, is `(0, 0, a₁₂(y); 0, 0, h(y))`, and `a₁₂|_L`, `h|_L` are a generic
binary cubic and a generic binary quadratic, which have no common zero.  So the generic member is
smooth everywhere.

*What the unguarded form killed.*  The same `F` and `v` make the unguarded
`exists_nonsingular_stereo_cubicFiber_of_smooth` false, and also
`residualYCoords_ne_zero_of_smooth`: with `p = (1,t,0)` and `∇G(p) = (0, 0, A²h(p))`, the
complementary direction is `q = p × ∇G(p) = (tA²h(p), −A²h(p), 0)`, so `p` and `q` both lie in
`{y₂ = 0}`, the whole residual line lies in `{y₂ = 0}`, and `G = A² y₂ h` restricts to `0` there;
`residualAmbientRep p q 0 = 0`, so `residualYCoords F v = 0`.

*Why `hnd` excludes it.*  For that `v` the polar `polarEval Q v w` vanishes identically, which is
the negation of `StereoNondegenerate F v`.  So the counterexample does not refute the statement as
it now stands, and the chooser `ResidualComponentAssembly.exists_residualChart_of_smooth` obtains a
non-degenerate section from `exists_isotropic_stereoNondegenerate`.  What the counterexample does
not settle is whether a *non-degenerate* section can still have its whole stereographic image
inside the discriminant locus for the hardcoded line; that is open, and it is exactly
`exists_stereo_param_nonsingularCubicFiber`.  Nothing here casts doubt on generic smoothness
itself.

## The geometry, for the record

The stereographic parameterization of the vertical surface `S_L` over the coordinate line
`L = {Y₂ = 0}` sends a parameter pair `(t, s) ∈ 𝔸²` to the point
`x(t,s) = residualImageXCoords F v` of `ℙ²_x`, and `cubicFiberPullback F x` is the plane cubic
fibre of `ρ : X → ℙ²_x` over it, with coefficients in `k[t,s]`.  The statement is that there is a
nonzero `D ∈ k[t,s]` such that off `{D = 0}` that plane cubic is nonsingular: no nonzero `r` is a
zero of the cubic at which all three partial derivatives vanish.

*Why `char k = 0` is load-bearing* — it is used in the second input and nowhere else in this
chain.  In characteristic `p` the singular locus of the fibration,
`Σ = {(x,y) : ∇_y F(x,y) = 0}`, is cut by `n+1 = 3` equations in the fourfold `ℙ² × ℙ²`, so
`dim Σ ≥ 1`; for every fibre to be singular one needs `Σ ∩ X → ℙ²_x` dominant, i.e.
`dim (Σ ∩ X) ≥ 2`, and smoothness of `X` then only requires `∇_x F ≠ 0` on that surface, which is
three further conditions on a two-dimensional locus — expected to be empty.  In characteristic `0`
Euler's identity in `y` forces `Σ ⊆ X` and generic smoothness rules the configuration out; in
characteristic `p` Euler gives `0 = 0` and it does not.  Quasi-elliptic fibrations — every fibre a
cuspidal cubic, total space smooth — are the standard realization of the phenomenon in
characteristics `2` and `3`.  So this statement must not be asserted without `CharZero`; no
counterexample of bidegree `(2,3)` is exhibited here, but nothing rules one out either.

*What is owed*, after this split and after `CubicFiberSingularLocus.lean`: only the good-line
condition, which is ours and is the `X`-side of the algebraic-independence question `PLAN.md` WP-1
faces on the `Y`-side (WP-2 step 2c).  Closedness of the singular locus — the other half — is
proved.
-/
theorem exists_ne_zero_nonsingular_stereo_cubicFiber_of_smooth
    {k : Type u} [Field k] [IsAlgClosed k] [CharZero k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)]
    (v : Fin 3 → Polynomial k) (hv0 : v ≠ 0)
    (hv : TernaryQuadraticPoly.eval (coordinateLineTernaryQuadraticPoly F) v = 0)
    (hnd : StereoNondegenerate F v) :
    ∃ D : affineTwoRing k, D ≠ 0 ∧
      ∀ t s : k, evalAffineTwoPoint t s D ≠ 0 →
        ∀ r : Fin 3 → k, r ≠ 0 →
          eval r (map (evalAffineTwoPoint t s)
              (cubicFiberPullback F (residualImageXCoords F v))) = 0 →
            ∃ i : Fin 3,
              eval r (pderiv i (map (evalAffineTwoPoint t s)
                (cubicFiberPullback F (residualImageXCoords F v)))) ≠ 0 := by
  classical
  obtain ⟨S, hS⟩ := exists_defining_set_nonsingularCubicFiber F hF
  obtain ⟨t₀, s₀, hgood⟩ :=
    exists_stereo_param_nonsingularCubicFiber F hF hF0 v hv0 hv hnd
  obtain ⟨Δ, hΔS, hΔ⟩ := (hS _).mpr hgood
  refine ⟨(aeval (residualImageXCoords F v) :
      MvPolynomial (Fin 3) k →ₐ[k] affineTwoRing k) Δ, ?_, ?_⟩
  · -- `D` is nonzero because it is nonzero at the good parameter pair.
    intro hzero
    exact hΔ (by rw [← evalAffineTwoPoint_aeval, hzero, map_zero])
  · -- Off `{D = 0}` the image point avoids `V(S)`, so its fibre is nonsingular.
    intro t s hts
    have hns : NonsingularCubicFiber F
        (fun i => evalAffineTwoPoint t s (residualImageXCoords F v i)) :=
      (hS _).mp ⟨Δ, hΔS, by rwa [← evalAffineTwoPoint_aeval]⟩
    rw [map_cubicFiberPullback_eq_specializeFirst]
    exact hns

/--
**Obligation 1, in the shape the proved reduction consumes.**  Some stereographic specialization
of the residual cubic fibre is a nonsingular plane cubic whose residual-line endpoints are linearly
independent.

Without `hnd` this statement is false, by the counterexample recorded on
`exists_ne_zero_nonsingular_stereo_cubicFiber_of_smooth`; read that docstring for what the
counterexample does and does not settle.  With `hnd` the derivation below rests, through that
statement, on `exists_defining_set_nonsingularCubicFiber` and
`exists_stereo_param_nonsingularCubicFiber` — the second of which is the open one.

*Status: proved*, from `exists_ne_zero_nonsingular_stereo_cubicFiber_of_smooth`.  Three of the four
things this statement asserts are discharged here and no longer stand as assumptions:

* *Homogeneity* of the specialized fibre is `cubicFiberPullback_isHomogeneous` transported along
  `MvPolynomial.map`.
* *Existence of a usable specialization*: the singular parameters lie in `{D = 0}` and the bad
  parameters for the linear independence lie in `{1 + t² = 0}`, so the product
  `D · (1 + t²) ∈ k[t,s]` is nonzero and, `k` being infinite, has a non-root.
* *Linear independence* of `ps` and `qs = ps × ∇Gs(ps)` is
  `linearIndependent_linePoint_complementary`, whose gradient hypothesis is supplied by
  nonsingularity of `Gs` at the coordinate-line point `ps = (1, t, 0)`, which lies on `Gs` by
  `eval_cubicFiber_coordinateLine_of_stereo`.  The exclusion `1 + t² ≠ 0` is genuinely needed: at
  `t² = -1` the vector `ps × ∇Gs(ps)` is proportional to `ps` whatever the gradient is.

`CharZero` is new; see the previous declaration.  It is not used in this proof — it is used in the
statement it consumes, and is required there.

*Why the statement has this shape.*  It is verbatim the hypothesis of the proved reduction
`residualYCoords_ne_zero_of_exists_nonsingular_stereo`, so discharging it closes obligation 1
outright with no further glue.
-/
theorem exists_nonsingular_stereo_cubicFiber_of_smooth
    {k : Type u} [Field k] [IsAlgClosed k] [CharZero k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)]
    (v : Fin 3 → Polynomial k) (hv0 : v ≠ 0)
    (hv : TernaryQuadraticPoly.eval (coordinateLineTernaryQuadraticPoly F) v = 0)
    (hnd : StereoNondegenerate F v) :
    ∃ t s : k,
      let x := residualImageXCoords F v
      let p := affineTwoCoordinateLineY k
      let G := cubicFiberPullback F x
      let q := complementaryTangentDir G p
      let phi := evalAffineTwoPoint t s
      let Gs := map phi G
      let ps := phi ∘ p
      let qs := complementaryTangentDir Gs ps
      Gs.IsHomogeneous 3 ∧
        (∀ r : Fin 3 → k, r ≠ 0 → eval r Gs = 0 →
          ∃ i : Fin 3, eval r (pderiv i Gs) ≠ 0) ∧
          LinearIndependent k ![ps, qs] := by
  classical
  obtain ⟨D, hD0, hDns⟩ :=
    exists_ne_zero_nonsingular_stereo_cubicFiber_of_smooth F hF hF0 v hv0 hv hnd
  set x := residualImageXCoords F v
  set p := affineTwoCoordinateLineY k
  set G := cubicFiberPullback F x
  have hGhom : G.IsHomogeneous 3 := cubicFiberPullback_isHomogeneous F hF x
  have hpG : eval p G = 0 := by
    simpa [x, G, residualImageXCoords] using eval_cubicFiber_coordinateLine_of_stereo F hF v hv
  have h1t : (1 + affineTwoCoord0 k ^ 2 : affineTwoRing k) ≠ 0 :=
    one_add_affineTwoCoord0_sq_ne_zero k
  set w : affineTwoRing k := D * (1 + affineTwoCoord0 k ^ 2)
  have hw : w ≠ 0 := mul_ne_zero hD0 h1t
  haveI : Infinite k := inferInstance
  obtain ⟨t, s, hts⟩ := exists_eval_ne_zero_affineTwoRing w hw
  set phi := evalAffineTwoPoint t s
  set Gs := map phi G
  set ps := phi ∘ p
  have hGshom : Gs.IsHomogeneous 3 := hGhom.map _
  have hps0 : ps 0 = 1 := by
    simp [ps, phi, evalAffineTwoPoint, p, affineTwoCoordinateLineY]
  have hps2 : ps 2 = 0 := by
    simp [ps, phi, evalAffineTwoPoint, p, affineTwoCoordinateLineY]
  have htps : 1 + ps 1 ^ 2 ≠ 0 := by
    intro h
    have hphi : phi (1 + affineTwoCoord0 k ^ 2) = 1 + t ^ 2 := by
      simp [phi, evalAffineTwoPoint, affineTwoCoord0]
    have hps1 : ps 1 = t := by
      simp [ps, phi, evalAffineTwoPoint, p, affineTwoCoordinateLineY, affineTwoCoord0]
    have hz : phi (1 + affineTwoCoord0 k ^ 2) = 0 := by simpa [hphi, hps1] using h
    have : phi w = 0 := by simp [w, map_mul, hz]
    exact hts (by simpa [phi, evalAffineTwoPoint] using this)
  have hD : phi D ≠ 0 := by
    intro h
    have : phi w = 0 := by simp [w, map_mul, h]
    exact hts (by simpa [phi, evalAffineTwoPoint] using this)
  have hns : ∀ r : Fin 3 → k, r ≠ 0 → eval r Gs = 0 →
      ∃ i : Fin 3, eval r (pderiv i Gs) ≠ 0 := hDns t s hD
  have hpsG : eval ps Gs = 0 := by
    have hcmp : eval ps Gs = phi (eval p G) := by
      calc
        eval ps Gs = eval₂ phi (phi ∘ p) G := by simp [ps, Gs, eval_map]
        _ = phi (eval p G) := (eval₂_comp phi p G).symm
    simp [hcmp, hpG]
  have hps_ne : ps ≠ 0 := by
    intro h
    exact one_ne_zero (α := k) (by simpa [hps0] using congrFun h 0)
  have hgrad_s : tangentGradient Gs ps ≠ 0 := by
    intro hg0
    obtain ⟨i, hi⟩ := hns ps hps_ne hpsG
    exact hi (by simpa [tangentGradient] using congrFun hg0 i)
  have hpq : LinearIndependent k ![ps, complementaryTangentDir Gs ps] :=
    linearIndependent_linePoint_complementary Gs hGshom ps hps0 hps2 htps hpsG hgrad_s
  exact ⟨t, s, hGshom, hns, hpq⟩

/-- **Obligation 1, discharged from the nonsingular-stereo obligation.**  The reduction is
`residualYCoords_ne_zero_of_exists_nonsingular_stereo`, which is proved: a nonsingular plane cubic
contains no line, so its restriction to the residual line is a nonzero binary cubic, and the
residual point is that binary cubic's third root.

`CharZero` is carried because the statement it rests on, generic smoothness for the plane-cubic
fibration, is false without it. -/
theorem residualYCoords_ne_zero_of_smooth
    {k : Type u} [Field k] [IsAlgClosed k] [CharZero k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)]
    (v : Fin 3 → Polynomial k) (hv0 : v ≠ 0)
    (hv : TernaryQuadraticPoly.eval (coordinateLineTernaryQuadraticPoly F) v = 0)
    (hnd : StereoNondegenerate F v) :
    residualYCoords F v ≠ 0 :=
  residualYCoords_ne_zero_of_exists_nonsingular_stereo F hF v hv
    (exists_nonsingular_stereo_cubicFiber_of_smooth F hF hF0 v hv0 hv hnd)

end

end BConicBundleMultisections
