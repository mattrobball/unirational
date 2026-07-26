/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.ChartHomogenization
public import BConicBundleMultisections.PlaneCubicResidualTransport
public import BConicBundleMultisections.SndConicDiscriminant

/-!
# The residual surface and the second conic discriminant

The second projection of a bidegree-`(2,3)` hypersurface is a conic bundle.  Its discriminant is
the degree-nine form `sndConicDiscriminant F` in the second homogeneous coordinates.  Along an
arbitrary line in the first plane, `residualYCoordsOn` gives the homogeneous second coordinates of
the tangent-residual surface as polynomials in two affine parameters.

This file packages the condition that this residual surface is not contained in the conic
discriminant.  The condition is literally that the pullback of the discriminant is a nonzero
polynomial.  We record two elementary but important consequences:

* over an infinite field it can be detected at one affine point;
* because the discriminant is homogeneous, it is unchanged by any nonzero common projective
  rescaling of the residual coordinates.

No dominance, dimension, or generic-point assertion is hidden in the definition.
-/

@[expose] public section

namespace BConicBundleMultisections

noncomputable section

universe u

open _root_.MvPolynomial

/-- Pull the second conic discriminant back along the tangent-residual coordinates attached to an
arbitrary line in the first projective plane. -/
def residualConicDiscriminantOn
    {K : Type u} [Field K]
    (p₀ q₀ r : Fin 3 → K) (N : Matrix (Fin 3) (Fin 3) K)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) K)
    (v : Fin 3 → Polynomial K) : affineTwoRing K :=
  aeval (residualYCoordsOn p₀ q₀ r N F v) (sndConicDiscriminant F)

/-- The tangent-residual surface attached to the chosen line is not contained in the discriminant
curve of the second conic projection. -/
def ResidualAvoidsConicDiscriminantOn
    {K : Type u} [Field K]
    (p₀ q₀ r : Fin 3 → K) (N : Matrix (Fin 3) (Fin 3) K)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) K)
    (v : Fin 3 → Polynomial K) : Prop :=
  residualConicDiscriminantOn p₀ q₀ r N F v ≠ 0

/-- A homogeneous relation on the residual coordinates cannot divide the conic discriminant
when the residual surface meets the discriminant complement.  This is the exact algebraic
noncontainment passed to the vertical-complete-intersection argument. -/
theorem not_dvd_sndConicDiscriminant_of_aeval_residualYCoordsOn_eq_zero
    {K : Type u} [Field K]
    (p₀ q₀ r : Fin 3 → K) (N : Matrix (Fin 3) (Fin 3) K)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) K)
    (v : Fin 3 → Polynomial K) (H : MvPolynomial (Fin 3) K)
    (hH : aeval (residualYCoordsOn p₀ q₀ r N F v) H = 0)
    (havoid : ResidualAvoidsConicDiscriminantOn p₀ q₀ r N F v) :
    ¬ H ∣ sndConicDiscriminant F := by
  rintro ⟨Q, hQ⟩
  apply havoid
  rw [residualConicDiscriminantOn, hQ, map_mul, hH, zero_mul]

/-- Evaluation of the pulled-back discriminant is ordinary evaluation of the homogeneous
discriminant at the evaluated residual coordinates. -/
theorem evalAffineTwoPoint_residualConicDiscriminantOn
    {K : Type u} [Field K]
    (p₀ q₀ r : Fin 3 → K) (N : Matrix (Fin 3) (Fin 3) K)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) K)
    (v : Fin 3 → Polynomial K) (t s : K) :
    evalAffineTwoPoint t s (residualConicDiscriminantOn p₀ q₀ r N F v) =
      eval (fun i ↦ evalAffineTwoPoint t s (residualYCoordsOn p₀ q₀ r N F v i))
        (sndConicDiscriminant F) := by
  change
    aeval (fun i : ULift (Fin 2) ↦ if i.down = 0 then t else s)
        (bind₁ (residualYCoordsOn p₀ q₀ r N F v) (sndConicDiscriminant F)) =
      aeval (fun i ↦
        aeval (fun j : ULift (Fin 2) ↦ if j.down = 0 then t else s)
          (residualYCoordsOn p₀ q₀ r N F v i))
        (sndConicDiscriminant F)
  exact aeval_bind₁ _ _ _

/-- A single residual point off the discriminant proves polynomial discriminant avoidance. -/
theorem residualAvoidsConicDiscriminantOn_of_exists_eval_ne_zero
    {K : Type u} [Field K]
    (p₀ q₀ r : Fin 3 → K) (N : Matrix (Fin 3) (Fin 3) K)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) K)
    (v : Fin 3 → Polynomial K)
    (h : ∃ t s : K,
      eval (fun i ↦ evalAffineTwoPoint t s (residualYCoordsOn p₀ q₀ r N F v i))
        (sndConicDiscriminant F) ≠ 0) :
    ResidualAvoidsConicDiscriminantOn p₀ q₀ r N F v := by
  rcases h with ⟨t, s, hts⟩
  intro hzero
  apply hts
  rw [← evalAffineTwoPoint_residualConicDiscriminantOn p₀ q₀ r N F v t s, hzero]
  exact map_zero _

/-- Over an infinite field, a nonzero pulled-back discriminant is nonzero at some affine point. -/
theorem exists_eval_ne_zero_of_residualAvoidsConicDiscriminantOn
    {K : Type u} [Field K] [Infinite K]
    (p₀ q₀ r : Fin 3 → K) (N : Matrix (Fin 3) (Fin 3) K)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) K)
    (v : Fin 3 → Polynomial K)
    (h : ResidualAvoidsConicDiscriminantOn p₀ q₀ r N F v) :
    ∃ t s : K,
      eval (fun i ↦ evalAffineTwoPoint t s (residualYCoordsOn p₀ q₀ r N F v i))
        (sndConicDiscriminant F) ≠ 0 := by
  rcases exists_eval_ne_zero_affineTwoRing
      (residualConicDiscriminantOn p₀ q₀ r N F v) h with ⟨t, s, hts⟩
  refine ⟨t, s, ?_⟩
  rw [← evalAffineTwoPoint_residualConicDiscriminantOn p₀ q₀ r N F v t s]
  exact hts

/-- The degree-nine discriminant picks up the ninth power under common rescaling. -/
theorem aeval_sndConicDiscriminant_smul
    {K S : Type u} [Field K] [CommSemiring S] [Algebra K S]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) K) (hF : IsBidegree23 F)
    (a : S) (y : Fin 3 → S) :
    aeval (fun i ↦ a * y i) (sndConicDiscriminant F) =
      a ^ 9 * aeval y (sndConicDiscriminant F) :=
  aeval_smul_point_of_isHomogeneous (sndConicDiscriminant_isHomogeneous F hF) a y

/-- In a domain, multiplying all homogeneous residual coordinates by a nonzero common factor
preserves discriminant avoidance. -/
theorem aeval_sndConicDiscriminant_ne_zero_iff_smul
    {K S : Type u} [Field K] [CommRing S] [IsDomain S] [Algebra K S]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) K) (hF : IsBidegree23 F)
    (a : S) (ha : a ≠ 0) (y : Fin 3 → S) :
    aeval (fun i ↦ a * y i) (sndConicDiscriminant F) ≠ 0 ↔
      aeval y (sndConicDiscriminant F) ≠ 0 := by
  rw [aeval_sndConicDiscriminant_smul F hF]
  exact mul_ne_zero_iff_left (pow_ne_zero 9 ha)

end

end BConicBundleMultisections
