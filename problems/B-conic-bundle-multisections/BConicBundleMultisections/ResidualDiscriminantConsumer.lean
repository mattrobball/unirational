/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.ConicProjectionFlat
public import BConicBundleMultisections.ResidualComponentOnAssembly
public import BConicBundleMultisections.ResidualDiscriminantHorizontality

/-!
# Consuming discriminant-based residual horizontality

This file carries the no-homogeneous-relation theorem furnished by the discriminant route through
the existing scheme-theoretic residual component and the clean pointed-conic open-chart consumer.
-/

@[expose] public section

open CategoryTheory
open scoped AlgebraicGeometry Matrix

namespace BConicBundleMultisections

noncomputable section

universe u

open AlgebraicGeometry BiprojectiveSpace
open _root_.MvPolynomial

/-- The discriminant membership package makes the raw residual target-coordinate triple nonzero. -/
theorem residualYCoordsOn_ne_zero_of_membershipAwayDiscriminant
    {k : Type u} [Field k] [Infinite k]
    (p₀ q₀ r : Fin 3 → k) (N : Matrix (Fin 3) (Fin 3) k)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (v : Fin 3 → Polynomial k)
    (hgood : ResidualLineNonconstantOn (lineFrame p₀ q₀ r) N F)
    (havoid : ResidualAvoidsConicDiscriminantOn p₀ q₀ r N F v)
    (hmembership :
      ResidualTargetRelationMembershipAwayDiscriminantOn p₀ q₀ r N F v) :
    residualYCoordsOn p₀ q₀ r N F v ≠ 0 := by
  intro hzero
  have hvan : aeval (residualYCoordsOn p₀ q₀ r N F v)
      (X (0 : Fin 3) : MvPolynomial (Fin 3) k) = 0 := by
    rw [hzero]
    simp
  have hXzero :=
    eq_zero_of_aeval_residualYCoordsOn_of_membershipAwayDiscriminant
      p₀ q₀ r N F hF v hgood havoid hmembership
      1 (X (0 : Fin 3)) (isHomogeneous_X k 0) hvan
  exact (X_ne_zero (R := k) (0 : Fin 3)) hXzero

/-- Some standard chart of the residual component is nonempty and dominates the conic-bundle
base under the discriminant membership package. -/
theorem exists_isDominant_residualComponentOnToBase_of_membershipAwayDiscriminant
    {k : Type u} [Field k] [IsAlgClosed k] [CharZero k]
    (p₀ q₀ r : Fin 3 → k) (N : Matrix (Fin 3) (Fin 3) k)
    (hMN : lineFrame p₀ q₀ r * N = 1)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (v : Fin 3 → Polynomial k)
    (hv : TernaryQuadraticPoly.eval (lineTernaryQuadraticPoly p₀ q₀ F) v = 0)
    (hpolar : lineStereoPolarForm p₀ q₀ F v ≠ 0)
    (hgood : ResidualLineNonconstantOn (lineFrame p₀ q₀ r) N F)
    (havoid : ResidualAvoidsConicDiscriminantOn p₀ q₀ r N F v)
    (hmembership :
      ResidualTargetRelationMembershipAwayDiscriminantOn p₀ q₀ r N F v) :
    ∃ i j : Fin 3,
      residualComponentOnDenom p₀ q₀ r N F v i j ≠ 0 ∧
      IsDominant (residualComponentOnToBase p₀ q₀ r N hMN F hF v hv i j) := by
  have hcore : ∀ (d : ℕ) (Psi : MvPolynomial (Fin 3) k),
      Psi.IsHomogeneous d →
        aeval (residualYCoordsOn p₀ q₀ r N F v) Psi = 0 → Psi = 0 :=
    fun d Psi hPsi hvan ↦
      eq_zero_of_aeval_residualYCoordsOn_of_membershipAwayDiscriminant
        p₀ q₀ r N F hF v hgood havoid hmembership d Psi hPsi hvan
  have hX : stereoFirstCoordsOn p₀ q₀ F v ≠ 0 :=
    stereoFirstCoordsOn_ne_zero_of_polar p₀ q₀ F hF v hv (by
      simpa [lineStereoPolarForm] using hpolar)
  have hY : residualYCoordsOn p₀ q₀ r N F v ≠ 0 :=
    residualYCoordsOn_ne_zero_of_membershipAwayDiscriminant
      p₀ q₀ r N F hF v hgood havoid hmembership
  obtain ⟨i, j, hdenom⟩ :=
    exists_residualComponentOnDenom_ne_zero p₀ q₀ r N F v hX hY
  refine ⟨i, j, hdenom, ?_⟩
  apply (isDominant_residualComponentOnToBase_iff
    p₀ q₀ r N hMN F hF v hv i j).mpr
  rw [residualZeroLocusPointOn_toBase]
  exact isDominant_pointOfNormalizedCoordinatesAlgebra 2 j _
    (ProjectiveSpace.isDominant_standardChartι 2 k j)
    (injective_standardChartEvalAlgebra_residualComponentOnYCoordsNorm
      p₀ q₀ r N F v i j hdenom hcore)

/-- Complete clean consumer: the discriminant membership package yields a three-dimensional
unirational parametrization of the original smooth bidegree-`(2,3)` zero locus. -/
theorem hasUnirationalParametrization3_biprojectiveZeroLocus_of_membershipAwayDiscriminant
    {k : Type u} [Field k] [IsAlgClosed k] [CharZero k]
    (p₀ q₀ r : Fin 3 → k) (N : Matrix (Fin 3) (Fin 3) k)
    (hMN : lineFrame p₀ q₀ r * N = 1)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)]
    (v : Fin 3 → Polynomial k)
    (hv : TernaryQuadraticPoly.eval (lineTernaryQuadraticPoly p₀ q₀ F) v = 0)
    (hpolar : lineStereoPolarForm p₀ q₀ F v ≠ 0)
    (hgood : ResidualLineNonconstantOn (lineFrame p₀ q₀ r) N F)
    (havoid : ResidualAvoidsConicDiscriminantOn p₀ q₀ r N F v)
    (hmembership :
      ResidualTargetRelationMembershipAwayDiscriminantOn p₀ q₀ r N F v) :
    HasUnirationalParametrization 3 (biprojectiveZeroLocusToSpec 2 2 k F) := by
  letI : Flat (biprojectiveZeroLocusSnd 2 2 k F) :=
    flat_biprojectiveZeroLocusSnd_of_smooth_bidegree23 F hF hF0
  obtain ⟨i, j, hdenom, hdom⟩ :=
    exists_isDominant_residualComponentOnToBase_of_membershipAwayDiscriminant
      p₀ q₀ r N hMN F hF v hv hpolar hgood havoid hmembership
  exact hasUnirationalParametrization3_biprojectiveZeroLocus_of_residualComponentOn_open
    p₀ q₀ r N hMN F hF v hv i j hF0 hdenom hdom

end

end BConicBundleMultisections
