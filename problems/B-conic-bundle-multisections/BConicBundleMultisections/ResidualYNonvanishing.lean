/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

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
   whose cubic fibre is singular form a proper closed subset of the parameter plane.  That is the
   whole of what generic smoothness has to supply, written on explicit polynomials rather than on
   schemes.
-/

@[expose] public section

open CategoryTheory
open scoped AlgebraicGeometry

namespace BConicBundleMultisections

noncomputable section

universe u

open AlgebraicGeometry MvPolynomial BiprojectiveSpace
open _root_.MvPolynomial

/--
**Obligation 1, narrowed: the singular stereo parameters are a proper closed subset.**

The stereographic parameterization of the vertical surface `S_L` over the coordinate line
`L = {Y₂ = 0}` sends a parameter pair `(t, s) ∈ 𝔸²` to the point
`x(t,s) = residualImageXCoords F v` of `ℙ²_x`, and `cubicFiberPullback F x` is the plane cubic
fibre of `ρ : X → ℙ²_x` over it, with coefficients in `k[t,s]`.  The claim is that there is a
nonzero `D ∈ k[t,s]` such that off `{D = 0}` that plane cubic is nonsingular: no nonzero `r` is a
zero of the cubic at which all three partial derivatives vanish.

*Why it is true.*  Two inputs, exactly the two the previous formulation of obligation 1 listed:

1. **Generic smoothness** (`certificates/all_smooth_tangent_residual_theorem.md` §1).  `X` is
   smooth and `char k = 0`, so the plane cubic fibre of `ρ` is nonsingular over a nonempty open
   subset of `ℙ²_x`; its complement, the discriminant locus, is cut out by the discriminant `Δ` of
   the ternary cubic, a form in `x` which is *not* identically zero.  `Δ ≢ 0` is the entire content
   of generic smoothness here, and it is what fails in positive characteristic.  This is the
   coordinate form of `Standard.exists_nonempty_open_smooth_restrict` (Hartshorne III.10.7); see
   that module for why the scheme-level form is not the one consumed.
2. **The stereographic image is not contained in the discriminant locus** — §4(1) of the source,
   where the line `L` is chosen off the conic discriminant so that `S_L` is integral.  Then
   `D := Δ(x(t,s)) ∈ k[t,s]` is nonzero and works.

*Why `char k = 0` is load-bearing.*  In characteristic `p` the singular locus of the fibration,
`Σ = {(x,y) : ∇_y F(x,y) = 0}`, is cut by `n+1 = 3` equations in the fourfold `ℙ² × ℙ²`, so
`dim Σ ≥ 1`; for every fibre to be singular one needs `Σ ∩ X → ℙ²_x` dominant, i.e.
`dim (Σ ∩ X) ≥ 2`, and smoothness of `X` then only requires `∇_x F ≠ 0` on that surface, which is
three further conditions on a two-dimensional locus — expected to be empty.  In characteristic `0`
Euler's identity in `y` forces `Σ ⊆ X`, and generic smoothness rules the configuration out; in
characteristic `p` it does not, and quasi-elliptic fibrations realize it.  So this statement must
not be asserted without `CharZero`.

*What is owed.*  Input 1 is borrowed and standard; input 2 is ours, and is the `X`-side of the
algebraic-independence question `PLAN.md` WP-1 faces on the `Y`-side (WP-2 step 2c).  Note that
input 2 cannot be strengthened to "the stereographic family is dominant onto `ℙ²_x`": `v` is an
*arbitrary* isotropic section of the conic bundle along `L`, and for a `v` lying in the line
`{x₂ = 0}` the stereographic direction `(1, s, 0)` is coplanar with it and the family degenerates
to a curve.  What is needed, and all that is needed, is that the family avoids the discriminant.
-/
theorem exists_ne_zero_nonsingular_stereo_cubicFiber_of_smooth
    {k : Type u} [Field k] [IsAlgClosed k] [CharZero k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)]
    (v : Fin 3 → Polynomial k) (hv0 : v ≠ 0)
    (hv : TernaryQuadraticPoly.eval (coordinateLineTernaryQuadraticPoly F) v = 0) :
    ∃ D : affineTwoRing k, D ≠ 0 ∧
      ∀ t s : k, evalAffineTwoPoint t s D ≠ 0 →
        ∀ r : Fin 3 → k, r ≠ 0 →
          eval r (map (evalAffineTwoPoint t s)
              (cubicFiberPullback F (residualImageXCoords F v))) = 0 →
            ∃ i : Fin 3,
              eval r (pderiv i (map (evalAffineTwoPoint t s)
                (cubicFiberPullback F (residualImageXCoords F v)))) ≠ 0 :=
  sorry

/--
**Obligation 1, in the shape the proved reduction consumes.**  Some stereographic specialization
of the residual cubic fibre is a nonsingular plane cubic whose residual-line endpoints are linearly
independent.

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
    (hv : TernaryQuadraticPoly.eval (coordinateLineTernaryQuadraticPoly F) v = 0) :
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
    exists_ne_zero_nonsingular_stereo_cubicFiber_of_smooth F hF hF0 v hv0 hv
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
    (hv : TernaryQuadraticPoly.eval (coordinateLineTernaryQuadraticPoly F) v = 0) :
    residualYCoords F v ≠ 0 :=
  residualYCoords_ne_zero_of_exists_nonsingular_stereo F hF v hv
    (exists_nonsingular_stereo_cubicFiber_of_smooth F hF hF0 v hv0 hv)

end

end BConicBundleMultisections
