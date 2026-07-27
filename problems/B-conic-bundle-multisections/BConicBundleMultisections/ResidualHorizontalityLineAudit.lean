/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.PlaneCubicResidualTransport
public import BConicBundleMultisections.GoodLineConic
public import BConicBundleMultisections.StereoJacobian

/-!
# Audit lemmas for arbitrary-line residual horizontality

These lemmas record a missing nondegeneracy condition in
`ResidualHorizontalityLine.det_residualYCoordsOn_ne_zero`.

The stereographic direction is `w = (1,s,0)`.  If the Tsen section also has third coordinate zero,
then the entire stereo family stays in the fixed line `{x₂ = 0}`.  In particular its projective
Jacobian determinant vanishes identically.  A nonzero polar pairing does not prevent this: it only
prevents the *vector* produced by `stereoAlg` from being zero.  The established density and
Jacobian theorems in `StereoJacobian` therefore assume `v 2 != 0` in addition to polar
nonvanishing.
-/

@[expose] public section

namespace BConicBundleMultisections

noncomputable section

universe u

open AlgebraicGeometry MvPolynomial BiprojectiveSpace
open _root_.MvPolynomial
open scoped Matrix

variable {k : Type u} [Field k]

/-- If the chosen Tsen section lies on `{x₂ = 0}`, so does every point produced by the arbitrary
line stereographic formula.  This conclusion is independent of the polar pairing. -/
theorem stereoFirstCoordsOn_two_eq_zero_of_v_two_eq_zero
    (p₀ q₀ : Fin 3 → k)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (v : Fin 3 → Polynomial k) (hv2 : v 2 = 0) :
    stereoFirstCoordsOn p₀ q₀ F v 2 = 0 := by
  simp [stereoFirstCoordsOn, stereoAlg, liftTsenSection, liftPolyT, affineTwoStereoDir, hv2]

/-- Consequently the three homogeneous stereo coordinates and both of their parameter
derivatives have a zero third column, so their `3 x 3` projective Jacobian determinant is zero.

This is the formal obstruction explaining why all the nondegenerate stereo-Jacobian APIs require
`v 2 != 0`; `polarEval ... != 0` is not a substitute for it. -/
theorem det_stereoFirstCoordsOn_eq_zero_of_v_two_eq_zero
    (p₀ q₀ : Fin 3 → k)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (v : Fin 3 → Polynomial k) (hv2 : v 2 = 0) :
    (Matrix.of ![stereoFirstCoordsOn p₀ q₀ F v,
        fun a => pderiv (ULift.up 0) (stereoFirstCoordsOn p₀ q₀ F v a),
        fun a => pderiv (ULift.up 1) (stereoFirstCoordsOn p₀ q₀ F v a)]).det = 0 := by
  apply Matrix.det_eq_zero_of_column_eq_zero 2
  intro i
  have h2 := stereoFirstCoordsOn_two_eq_zero_of_v_two_eq_zero p₀ q₀ F v hv2
  fin_cases i
  · simpa using h2
  · simp [h2]
  · simp [h2]

/-! ### The polar hypothesis is redundant once `v 2 != 0`

The smoothness hypothesis makes the generic conic along every genuine line nondegenerate.  On a
nondegenerate conic, an isotropic point off the plane `{x₂ = 0}` cannot have polar line equal to
that plane: otherwise its polar against `e₀` and `e₁` would vanish, and isotropy would force its
polar against `e₂` to vanish as well.  Thus, in the hypotheses used by residual horizontality,
`hpolar` follows from `hv2`; it is useful as a named intermediate condition, but it is not an
independent assumption.
-/

/-- For a smooth total hypersurface, an isotropic section with nonzero third coordinate is
automatically nondegenerate against the stereographic direction. -/
theorem lineStereoPolarForm_ne_zero_of_smooth_of_two_ne_zero
    [NeZero (2 : k)] [NeZero (3 : k)]
    (p₀ q₀ r : Fin 3 → k) (N : Matrix (Fin 3) (Fin 3) k)
    (hMN : lineFrame p₀ q₀ r * N = 1)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)]
    (v : Fin 3 → Polynomial k)
    (hv : TernaryQuadraticPoly.eval (lineTernaryQuadraticPoly p₀ q₀ F) v = 0)
    (hv2 : v 2 ≠ 0) :
    lineStereoPolarForm p₀ q₀ F v ≠ 0 := by
  have hdisc : lineConicDiscriminant p₀ q₀ F ≠ 0 :=
    lineConicDiscriminant_ne_zero_of_smooth p₀ q₀ r N hMN F hF hF0
  have hQ : (lineSpecializedConicPoly p₀ q₀ F).IsHomogeneous 2 :=
    lineSpecializedConicPoly_isHomogeneous p₀ q₀ hF
  have hviso : eval v (lineSpecializedConicPoly p₀ q₀ F) = 0 := by
    rw [← ternaryQuadraticPoly_eval_line p₀ q₀ F hF]
    exact hv
  have hp := polarEval_ne_zero_of_isotropic_of_third_ne_zero hQ hdisc hviso hv2
  simpa only [lineStereoPolarForm] using
    (polarEval_lineStereoDir_ne_zero_of_polarEval_ne_zero p₀ q₀ F hF v hp)

/-! ### The complementary positive audit

The preceding obstruction is the only defect of the *source* parametrisation.  Once `v 2 != 0`
and the stereo polar is nonzero, the arbitrary-line stereo point really does sweep a surface in
`P^2_x`.  This does not prove residual horizontality: it deliberately isolates the remaining
content as a statement about the residual `y`-coordinates, not about a collapsed parametrisation
of the source.
-/

/-- The conic over an arbitrary line is literally the coordinate-line conic after carrying the
second block of the equation into the line frame. -/
theorem lineSpecializedConicPullback_eq_specializedConicPullback_secondBlockSubst
    (p₀ q₀ r : Fin 3 → k)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) :
    lineSpecializedConicPullback p₀ q₀ F =
      specializedConicPullback (secondBlockSubst (lineFrame p₀ q₀ r) F) := by
  rw [lineSpecializedConicPullback_eq_map,
    lineSpecializedConicPoly_eq_coordinateLine_secondBlockSubst,
    specializedConicPullback_eq_map_eval₂]

/-- Consequently the arbitrary-line stereo coordinates are the existing coordinate-line stereo
coordinates for the transported equation. -/
theorem stereoFirstCoordsOn_eq_stereoFirstCoords_secondBlockSubst
    (p₀ q₀ r : Fin 3 → k)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (v : Fin 3 → Polynomial k) :
    stereoFirstCoordsOn p₀ q₀ F v =
      stereoFirstCoords (secondBlockSubst (lineFrame p₀ q₀ r) F) v := by
  simp only [stereoFirstCoordsOn, stereoFirstCoords,
    lineSpecializedConicPullback_eq_specializedConicPullback_secondBlockSubst p₀ q₀ r F]

/-- **Positive audit: a nondegenerate arbitrary-line stereo family sweeps `P^2_x`.**

This is the arbitrary-line transport of `stereoJacobianDet_ne_zero_of_smooth`.  It formally rules
out a source-side explanation for the open residual determinant: under `hv2` and `hpolar`, the
matrix `[x, d_t x, d_s x]` is nonsingular.  The still-open matrix
`[y_res, d_t y_res, d_s y_res]` therefore contains the genuine horizontal-divisor content of
Section 4 of the certificate. -/
theorem det_stereoFirstCoordsOn_ne_zero_of_smooth
    [NeZero (2 : k)] [NeZero (3 : k)]
    (p₀ q₀ r : Fin 3 → k) (N : Matrix (Fin 3) (Fin 3) k)
    (hMN : lineFrame p₀ q₀ r * N = 1)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)]
    (v : Fin 3 → Polynomial k) (hv0 : v ≠ 0)
    (hv : TernaryQuadraticPoly.eval (lineTernaryQuadraticPoly p₀ q₀ F) v = 0)
    (hv2 : v 2 ≠ 0)
    (hpolar : polarEval (lineSpecializedConicPullback p₀ q₀ F)
      (liftTsenSection v) affineTwoStereoDir ≠ 0) :
    (Matrix.of ![stereoFirstCoordsOn p₀ q₀ F v,
        fun a => pderiv (ULift.up 0) (stereoFirstCoordsOn p₀ q₀ F v a),
        fun a => pderiv (ULift.up 1) (stereoFirstCoordsOn p₀ q₀ F v a)]).det ≠ 0 := by
  let M := lineFrame p₀ q₀ r
  let F' := secondBlockSubst M F
  have hF' : IsBidegree23 F' := isBidegree23_secondBlockSubst M hF
  have hF'0 : F' ≠ 0 := secondBlockSubst_ne_zero_of_inverse M N hMN hF0
  letI : Smooth (biprojectiveZeroLocusToSpec 2 2 k F') :=
    smooth_secondBlockSubst_of_smooth M N hMN F hF hF0
  have hQ : coordinateLineTernaryQuadraticPoly F' =
      lineTernaryQuadraticPoly p₀ q₀ F := by
    funext i j
    simp only [coordinateLineTernaryQuadraticPoly, lineTernaryQuadraticPoly, F']
    rw [← lineSpecializedConicPoly_eq_coordinateLine_secondBlockSubst p₀ q₀ r F]
  have hv' : TernaryQuadraticPoly.eval (coordinateLineTernaryQuadraticPoly F') v = 0 := by
    rw [hQ]
    exact hv
  have hpolar' : polarEval (specializedConicPullback F')
      (liftTsenSection v) affineTwoStereoDir ≠ 0 := by
    rw [← lineSpecializedConicPullback_eq_specializedConicPullback_secondBlockSubst p₀ q₀ r F]
    exact hpolar
  have hdet := stereoJacobianDet_ne_zero_of_smooth F' hF' hF'0 v hv0 hv' hv2 hpolar'
  have hx : stereoFirstCoordsOn p₀ q₀ F v = stereoFirstCoords F' v :=
    stereoFirstCoordsOn_eq_stereoFirstCoords_secondBlockSubst p₀ q₀ r F v
  simpa only [stereoJacobianDet, residualImageXCoords, hx] using hdet

/-- **Minimal positive audit.**  Under smoothness, isotropy and `v 2 != 0` alone, the arbitrary-line
stereo coordinates sweep `P²_x`.  The nonzero-vector and polar hypotheses in the preceding API are
both consequences of the nonzero third coordinate. -/
theorem det_stereoFirstCoordsOn_ne_zero_of_smooth_of_two_ne_zero
    [NeZero (2 : k)] [NeZero (3 : k)]
    (p₀ q₀ r : Fin 3 → k) (N : Matrix (Fin 3) (Fin 3) k)
    (hMN : lineFrame p₀ q₀ r * N = 1)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)]
    (v : Fin 3 → Polynomial k)
    (hv : TernaryQuadraticPoly.eval (lineTernaryQuadraticPoly p₀ q₀ F) v = 0)
    (hv2 : v 2 ≠ 0) :
    (Matrix.of ![stereoFirstCoordsOn p₀ q₀ F v,
        fun a => pderiv (ULift.up 0) (stereoFirstCoordsOn p₀ q₀ F v a),
        fun a => pderiv (ULift.up 1) (stereoFirstCoordsOn p₀ q₀ F v a)]).det ≠ 0 := by
  have hv0 : v ≠ 0 := fun hzero => hv2 (by rw [hzero]; rfl)
  have hpolar : lineStereoPolarForm p₀ q₀ F v ≠ 0 :=
    lineStereoPolarForm_ne_zero_of_smooth_of_two_ne_zero
      p₀ q₀ r N hMN F hF hF0 v hv hv2
  exact det_stereoFirstCoordsOn_ne_zero_of_smooth
    p₀ q₀ r N hMN F hF hF0 v hv0 hv hv2 hpolar

end

end BConicBundleMultisections
