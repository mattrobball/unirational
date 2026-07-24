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
**Obligation 1.**  Some stereographic specialization of the residual cubic fibre is a
nonsingular plane cubic whose residual-line endpoints are linearly independent.

*Status.* Expected true, and it is what the source proof asserts.  Two standard inputs give it.
Both are **ours to build** — this `sorry` is scaffolding so that the reduction can land now, not a
decision to assume them permanently:

1. **Generic smoothness** (`certificates/all_smooth_tangent_residual_theorem.md` §1): in
   characteristic zero, `X` smooth makes the generic fibre of `ρ : X → ℙ²_x` a smooth plane cubic.
   Mathlib has no generic smoothness for morphisms of schemes at the pinned revision.
2. **The stereographic image meets the locus where the fibre is smooth.**  §4(1) of the source gets
   this from `L` not lying in the conic discriminant, which makes `S_L` integral.

Given (1) and (2) a general `(t, s)` works, and linear independence of `ps, qs` is the statement
that the residual line is a genuine line — automatic at a smooth point of a smooth cubic.

*Why the statement has this shape.*  It is verbatim the hypothesis of the proved reduction
`residualYCoords_ne_zero_of_exists_nonsingular_stereo`, so discharging it closes obligation 1
outright with no further glue.

*What it replaces.*  Four obligations of the withdrawn fixed-line case analysis, two of which were
plausibly false.  That reduction is the point: what remains is a single recognizable consequence of
a standard theorem rather than a case split on an artefact of a dropped hypothesis.
-/
theorem exists_nonsingular_stereo_cubicFiber_of_smooth
    {k : Type u} [Field k] [IsAlgClosed k]
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
          LinearIndependent k ![ps, qs] :=
  sorry

/-- **Obligation 1, discharged from the nonsingular-stereo obligation.**  The reduction is
`residualYCoords_ne_zero_of_exists_nonsingular_stereo`, which is proved: a nonsingular plane cubic
contains no line, so its restriction to the residual line is a nonzero binary cubic, and the
residual point is that binary cubic's third root. -/
theorem residualYCoords_ne_zero_of_smooth
    {k : Type u} [Field k] [IsAlgClosed k]
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
