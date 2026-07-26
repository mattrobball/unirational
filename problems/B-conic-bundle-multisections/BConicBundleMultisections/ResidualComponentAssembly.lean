/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.PointedConicRationalFamilies
public import BConicBundleMultisections.ResidualComponentHorizontality
public import BConicBundleMultisections.ResidualYNonvanishing
public import BConicBundleMultisections.UnirationalTower

/-!
# Assembling the residual-component argument

This module turns the four outstanding obligations into the two inputs that `MainTheorem`
consumes.  It is also the inventory of what the tangent-residual proof of

> every smooth bidegree-`(2,3)` threefold in `ℙ² × ℙ²` over an algebraically closed field of
> characteristic zero is unirational

still owes.  Nothing here is assumed beyond those four; everything else is proved.

## Why the obligations are stated about the residual *component*

An earlier arrangement carried the whole argument on `residualImage F = V(F) ∩ V(q_F)` and
assumed a dimension-three parametrization of its base change.  That assumption is not merely
unproved: when the degree-ten coefficients of `q_F` acquire a common factor, `V(q_F)` gains a
vertical divisor, `residualImage F` gains components the residual map never meets, and the base
change `X ×_{ℙ²_y} residualImage F` inherits them (its conic fibres over those curves are
nonempty, `BiprojectiveFiberNonempty`).  Affine space is irreducible, so the closure of its image
under any rational map is irreducible, and no dominant rational map onto a reducible target
exists.  The assumption was therefore *false* in exactly the cases that make the theorem hard,
and any proof discharging it would have been unfillable.

The obligations are instead stated about `residualComponent F hF v hv i j` — the scheme-theoretic
image of the localized residual chart map, which is by construction the component the residual map
actually dominates.  Each is expected to be true.

## Non-vacuity

Every obligation is stated about the *concrete* schemes of this development rather than in
scheme-theoretic generality, deliberately.  In particular
`hasUnirationalParametrization3_of_component_tower` is the classical unirational tower step
`dim 2 + dim 1 = dim 3`; stated for arbitrary schemes it needs an argument that the target is
never base-changed, which is available but is better established as a separate general lemma than
smuggled into an obligation.

## The outstanding obligations

Each work package of `PLAN.md` owns one module, so the streams never contend for a file.
Obligations are ordinary declarations in the `BConicBundleMultisections` namespace, named for
their mathematical content: discharging one means deleting its `sorry`, with no call site
changing.

* `ResidualYNonvanishing` (WP-C) — obligation 1, *the load-bearing blocker*, now split by a
  three-way case analysis on the residual tangent direction:
  `exists_three_freeDir_polar_roots` (1a, elementary), `residualImageXCoords_two_ne_zero`
  (1b, a reindexing), `residualBinaryLine_ne_zero_of_singular_at_coordinateLinePoint`
  (1c, plausibly vacuous), and `residualBinaryLine_ne_zero_of_tangent_not_coordinateLine`
  (1d, **the crux**).  `residualYCoords_ne_zero_of_smooth` is derived from these, not assumed.
* `ResidualComponentHorizontality` (WP-B) — `isDominant_residualImagePointOfNormalizedLoc_toBase`.
  A concrete coordinate computation.
* `PointedConicRationalFamilies` (WP-D) — `isResidualComponentPointedConicRational_of_smooth`.
  Largest by volume, but classical.
* ~~`UnirationalTower` (WP-A)~~ — **closed**.  The general `m + 1` tower
  `hasUnirationalParametrization_succ_of_tower` and its residual-component instance are proved
  outright, along with `mapPartialMap` (the transport of a partial map along `𝔸(n; -)` that
  Mathlib lacks), `comp_hom_over`, `exists_isOver_representative` and
  `UnirationalParametrization.ofPartialMapOver`.

The invariant to preserve: `lake build 2>&1 | grep 'declaration uses `sorry`'` reports hits in
exactly those four modules.  Do not grep the sources for `sorry` — these docstrings discuss it.
-/

@[expose] public section

open CategoryTheory
open scoped AlgebraicGeometry

namespace BConicBundleMultisections

noncomputable section

universe u

open AlgebraicGeometry MvPolynomial BiprojectiveSpace
open _root_.MvPolynomial

/-- The residual component base change is unirational in dimension three.

Combines the *proved* dimension-two unirationality of the component
(`hasUnirationalParametrization2_residualComponent`, whose dominance comes from Mathlib's
`IsDominant f.toImage`) with obligations 3 and 4. -/
theorem hasUnirationalParametrization3_residualComponentBaseChange
    {k : Type u} [Field k] [IsAlgClosed k] [CharZero k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)]
    (hgood : ResidualLineNonconstant F)
    (v : Fin 3 → Polynomial k) (hv0 : v ≠ 0)
    (hv : TernaryQuadraticPoly.eval (coordinateLineTernaryQuadraticPoly F) v = 0)
    (hv2 : v 2 ≠ 0)
    (hpolar : lineStereoPolarForm ![1, 0, 0] ![0, 1, 0] F v ≠ 0)
    (i j : Fin 3) (hdenom : residualChartDenom F v i j ≠ 0) :
    HasUnirationalParametrization 3
      ((residualComponentMultisection F hF v hv i j).baseChangeFst ≫
        biprojectiveZeroLocusToSpec 2 2 k F) :=
  hasUnirationalParametrization3_of_component_tower F hF v hv i j
    (hasUnirationalParametrization2_residualComponent F hF v hv i j hdenom)
    (hasUnirationalParametrization1_residualComponentBaseChangeSnd F hF v hv i j
      (isResidualComponentPointedConicRational_of_smooth
        F hF hF0 hgood v hv0 hv hv2 hpolar i j hdenom))

/-- A stereo-nondegenerate Tsen section, residual chart, and polar nondegeneracy for the coordinate
line, assuming that this particular line satisfies G3.

The section exists by Tsen + conic discriminant (`exists_isotropic_stereoNondegenerate`); the chart
exists from residual `X`/`Y` nonvanishing; polar is the same form as `StereoNondegenerate` on the
coordinate frame (`lineStereoPolarForm_coordinate`).

The G3 hypothesis is deliberately explicit.  It cannot be inferred from smoothness: the smooth
diagonal example has a constant residual line along `Y₂ = 0`.  The unconditioned theorem must use
the arbitrary line produced by `exists_good_line`. -/
theorem exists_residualChart_of_smooth_of_residualLineNonconstant
    {k : Type u} [Field k] [IsAlgClosed k] [CharZero k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)]
    (hgood : ResidualLineNonconstant F) :
    ∃ (v : Fin 3 → Polynomial k) (hv0 : v ≠ 0)
      (hv : TernaryQuadraticPoly.eval (coordinateLineTernaryQuadraticPoly F) v = 0)
      (hv2 : v 2 ≠ 0)
      (hpolar : lineStereoPolarForm ![1, 0, 0] ![0, 1, 0] F v ≠ 0)
      (i j : Fin 3) (_hdenom : residualChartDenom F v i j ≠ 0),
        ResidualLineNonconstant F := by
  -- The section must be CHOSEN, not taken arbitrarily: an isotropic `v` that is a base point of
  -- the conic family along `L` collapses the stereographic map to a point.  See the counterexample
  -- on `exists_ne_zero_nonsingular_stereo_cubicFiber_of_smooth`.
  obtain ⟨v, hv0, hv, hv2, hnd⟩ := exists_isotropic_stereoNondegenerate F hF hF0
  have hX : residualImageXCoords F v ≠ 0 :=
    residualImageXCoords_ne_zero_of_smooth F hF hF0 v hv0 hv
  have hY : residualYCoords F v ≠ 0 :=
    residualYCoords_ne_zero_of_smooth F hF hF0 v hv0 hv hv2 hnd
  obtain ⟨i, j, hdenom⟩ := exists_residualChartDenom_ne_zero F v hX hY
  have hpolar : lineStereoPolarForm ![1, 0, 0] ![0, 1, 0] F v ≠ 0 :=
    lineStereoPolarForm_coordinate_ne_zero_of F v hnd
  exact ⟨v, hv0, hv, hv2, hpolar, i, j, hdenom, hgood⟩

end

end BConicBundleMultisections
