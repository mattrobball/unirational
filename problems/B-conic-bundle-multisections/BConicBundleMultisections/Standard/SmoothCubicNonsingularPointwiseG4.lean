/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.Standard.SmoothCubicPrincipalOpens
public import BConicBundleMultisections.Standard.G4StereoCertificateOpenness
public import BConicBundleMultisections.ResidualDiscriminantGenericConic

/-!
# Smooth-cubic tangent points with nonsingular conic fibre

This file specializes simultaneous principal-open avoidance on a smooth cubic to the actual
degree-nine conic discriminant.  It closes the pointwise geometric input to the prescribed-centre
Tsen construction: the tangent base point and its residual image both avoid the discriminant, and
the conic over the base point is therefore nonsingular.

No G3 assertion is made here.  Requiring the same tangent line to lie in the G3 open remains a
separate line-incidence problem.
-/

@[expose] public section

namespace BConicBundleMultisections.Standard

noncomputable section

universe u

open MvPolynomial
open _root_.MvPolynomial

/-- Avoiding the global second-conic discriminant makes the conic over a numerical base point
Jacobian-nonsingular. -/
theorem lineSpecializedConic_nonsingular_of_eval_sndConicDiscriminant_ne_zero
    {K : Type u} [Field K]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) K) (hF : IsBidegree23 F)
    (p q : Fin 3 → K)
    (hdisc : eval p (sndConicDiscriminant F) ≠ 0) :
    ∀ y : Fin 3 → K, y ≠ 0 → eval y (lineSpecializedConic p q F 0) = 0 →
      ∃ i : Fin 3,
        eval y (pderiv i (lineSpecializedConic p q F 0)) ≠ 0 := by
  let Q := lineSpecializedConic p q F 0
  have hQ : Q.IsHomogeneous 2 := lineSpecializedConic_isHomogeneous p q hF 0
  have hQeq : Q = sndConicAt F p := by
    dsimp only [Q]
    rw [lineSpecializedConic, linePointOf_zero, sndConicAt,
      Algebra.algebraMap_self, MvPolynomial.map_id]
  have hdet : (polarMatrix Q).det ≠ 0 := by
    rw [hQeq, det_polarMatrix_sndConicAt]
    simpa using hdisc
  intro y hy0 _hy
  exact exists_eval_pderiv_ne_zero_of_det_polarMatrix_ne_zero Q hQ hdet y hy0

/-- On a fixed smooth cubic fibre, simultaneous discriminant avoidance produces the complete
nonsingular pointwise-G4 witness consumed by the prescribed-centre Tsen construction.

The hypotheses `hproper` and `hxcoord` are precisely the two base choices not internal to the
smooth-cubic argument: the discriminant open must meet the cubic, and the selected first-block
point must avoid the one fixed omitted coordinate point of the affine stereographic chart. -/
theorem exists_nonsingularPointwiseG4Witness_on_smooth_cubic
    {K : Type u} [Field K] [CharZero K] [IsAlgClosed K]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) K) (hF : IsBidegree23 F)
    (x : Fin 3 → K) (hx0 : x ≠ 0)
    (hsmooth : IsSmoothPlaneCubic (specializeFirstCoordinates (n := 2) x F))
    (hxcoord : x 0 ≠ 0 ∨ x 2 ≠ 0)
    (hproper : ∃ y : Fin 3 → K,
      y ≠ 0 ∧
      eval y (specializeFirstCoordinates (n := 2) x F) = 0 ∧
      eval y (sndConicDiscriminant F) ≠ 0) :
    ∃ p q : Fin 3 → K, HasNonsingularPointwiseG4Witness F p q := by
  let g := specializeFirstCoordinates (n := 2) x F
  obtain ⟨p, q, hp0, hpg, hpdisc, hpq, hq, hresdisc⟩ :=
    exists_tangentResidual_base_and_image_avoid_homogeneous_target
      g hsmooth (sndConicDiscriminant F)
      (sndConicDiscriminant_isHomogeneous F hF) (by norm_num) hproper
  have hnonsing :=
    lineSpecializedConic_nonsingular_of_eval_sndConicDiscriminant_ne_zero
      F hF p q hpdisc
  refine ⟨p, q, x, hx0, hsmooth, hp0, ?_, hpq, hq, hresdisc, hnonsing, hxcoord⟩
  exact hpg

end

end BConicBundleMultisections.Standard
