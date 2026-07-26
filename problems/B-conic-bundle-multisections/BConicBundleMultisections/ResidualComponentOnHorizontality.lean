/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.ResidualComponentHorizontality
public import BConicBundleMultisections.ResidualComponentOnMultisection
public import BConicBundleMultisections.ResidualHorizontalityLine

/-!
# Horizontality of the arbitrary-line residual component

This file is the scheme-level assembly of the arbitrary-line horizontality calculation in
`ResidualHorizontalityLine`.  It mirrors the coordinate-line reduction in
`ResidualComponentHorizontality`, but uses the intrinsic line-frame coordinates
`residualYCoordsOn` and the component `residualComponentOn`.

There is no new geometric input here.  The genuinely mathematical hypotheses remain visible:

* `hgood : ResidualLineNonconstantOn ...`, the source's moving-residual-line condition; and
* `hv2 : v 2 != 0`, which keeps the section off the fixed stereo-direction line; and
* `hpolar : lineStereoPolarForm ... != 0`, which prevents the stereographic parametrization from
  becoming the zero/scalar section.

After choosing a chart with nonzero denominator, localization and chart homogenization turn
`eq_zero_of_aeval_residualYCoordsOn_of_isHomogeneous` into dominance of the explicit localized
map to `P^2_y`.  Dominance then descends to the scheme-theoretic image.
-/

@[expose] public section

open CategoryTheory
open scoped AlgebraicGeometry Matrix

namespace BConicBundleMultisections

noncomputable section

universe u

open AlgebraicGeometry MvPolynomial BiprojectiveSpace
open _root_.MvPolynomial Localization

attribute [local instance] MvPolynomial.gradedAlgebra

/-! ### Homogeneous relations survive the arbitrary-line chart normalization -/

/-- Evaluating a form at the localized arbitrary-line second-block coordinates is localization
of its evaluation at the original polynomial coordinates. -/
theorem aeval_residualComponentOnYCoordsLoc
    {k : Type u} [Field k]
    (p₀ q₀ r : Fin 3 → k) (N : Matrix (Fin 3) (Fin 3) k)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (v : Fin 3 → Polynomial k) (i j : Fin 3)
    (Ψ : MvPolynomial (Fin 3) k) :
    aeval (residualComponentOnYCoordsLoc p₀ q₀ r N F v i j) Ψ =
      algebraMap (affineTwoRing k) (residualComponentOnLoc p₀ q₀ r N F v i j)
        (aeval (residualYCoordsOn p₀ q₀ r N F v) Ψ) := by
  induction Ψ using MvPolynomial.induction_on with
  | C a =>
      simp only [aeval_C, algebraMap_k_residualComponentOnLoc, algebraMap_eq]
  | add P Q hP hQ =>
      simp only [map_add, hP, hQ]
  | mul_X P z hP =>
      simp only [map_mul, aeval_X, hP, residualComponentOnYCoordsLoc]

/-- Dividing the arbitrary-line residual coordinates by a unit chart coordinate creates no new
homogeneous relation.  Injectivity of the localization map uses exactly `hdenom`. -/
theorem eq_zero_of_aeval_residualComponentOnYCoordsNorm_of_isHomogeneous
    {k : Type u} [Field k]
    (p₀ q₀ r : Fin 3 → k) (N : Matrix (Fin 3) (Fin 3) k)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (v : Fin 3 → Polynomial k) (i j : Fin 3)
    (hdenom : residualComponentOnDenom p₀ q₀ r N F v i j ≠ 0)
    (hcore : ∀ (d : ℕ) (Ψ : MvPolynomial (Fin 3) k), Ψ.IsHomogeneous d →
      aeval (residualYCoordsOn p₀ q₀ r N F v) Ψ = 0 → Ψ = 0)
    (d : ℕ) (Ψ : MvPolynomial (Fin 3) k) (hΨ : Ψ.IsHomogeneous d)
    (hvan : aeval (residualComponentOnYCoordsNorm p₀ q₀ r N F v i j) Ψ = 0) :
    Ψ = 0 := by
  have hunit := isUnit_residualComponentOnYCoordsLoc p₀ q₀ r N F v i j
  have hnorm : residualComponentOnYCoordsNorm p₀ q₀ r N F v i j =
      fun a ↦
        (↑hunit.unit⁻¹ : residualComponentOnLoc p₀ q₀ r N F v i j) *
          residualComponentOnYCoordsLoc p₀ q₀ r N F v i j a := rfl
  rw [hnorm, aeval_smul_point_of_isHomogeneous hΨ,
    aeval_residualComponentOnYCoordsLoc] at hvan
  have hscale : IsUnit
      ((↑hunit.unit⁻¹ : residualComponentOnLoc p₀ q₀ r N F v i j) ^ d) :=
    (Units.isUnit hunit.unit⁻¹).pow d
  have hloc : algebraMap (affineTwoRing k)
      (residualComponentOnLoc p₀ q₀ r N F v i j)
      (aeval (residualYCoordsOn p₀ q₀ r N F v) Ψ) = 0 :=
    (hscale.mul_right_eq_zero).mp hvan
  have hinj : Function.Injective
      (algebraMap (affineTwoRing k)
        (residualComponentOnLoc p₀ q₀ r N F v i j)) :=
    IsLocalization.injective
      (M := Submonoid.powers (residualComponentOnDenom p₀ q₀ r N F v i j))
      (residualComponentOnLoc p₀ q₀ r N F v i j)
      (powers_le_nonZeroDivisors_of_noZeroDivisors hdenom)
  exact hcore d Ψ hΨ (hinj (by rw [hloc, map_zero]))

/-- No homogeneous relation among `residualYCoordsOn` makes the standard-chart evaluation at its
localized normalization injective. -/
theorem injective_standardChartEvalAlgebra_residualComponentOnYCoordsNorm
    {k : Type u} [Field k]
    (p₀ q₀ r : Fin 3 → k) (N : Matrix (Fin 3) (Fin 3) k)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (v : Fin 3 → Polynomial k) (i j : Fin 3)
    (hdenom : residualComponentOnDenom p₀ q₀ r N F v i j ≠ 0)
    (hcore : ∀ (d : ℕ) (Ψ : MvPolynomial (Fin 3) k), Ψ.IsHomogeneous d →
      aeval (residualYCoordsOn p₀ q₀ r N F v) Ψ = 0 → Ψ = 0) :
    Function.Injective
      (ProjectiveSpace.standardChartEvalAlgebra (R := k) 2 j
        (residualComponentOnYCoordsNorm p₀ q₀ r N F v i j)) := by
  have haff : Function.Injective
      (aeval (ProjectiveSpace.affineCoordinates j
        (residualComponentOnYCoordsNorm p₀ q₀ r N F v i j)) :
          MvPolynomial (Fin 2) k →ₐ[k] residualComponentOnLoc p₀ q₀ r N F v i j) :=
    ProjectiveSpace.injective_aeval_affineCoordinates (R := k) j
      (residualComponentOnYCoordsNorm p₀ q₀ r N F v i j)
      (residualComponentOnYCoordsNorm_apply p₀ q₀ r N F v i j)
      (fun d Ψ hΨ hvan ↦
        eq_zero_of_aeval_residualComponentOnYCoordsNorm_of_isHomogeneous
          p₀ q₀ r N F v i j hdenom hcore d Ψ hΨ hvan)
  intro a b hab
  exact (ProjectiveSpace.standardChartRingEquivMvPolynomial 2 k j).injective (haff hab)

/-! ### The explicit map and the scheme-theoretic image dominate the base -/

/-- The arbitrary-line localized zero-locus point followed by the second projection is exactly
the projective point of its normalized second-block coordinates. -/
theorem residualZeroLocusPointOn_toBase
    {k : Type u} [Field k]
    (p₀ q₀ r : Fin 3 → k) (N : Matrix (Fin 3) (Fin 3) k)
    (hMN : lineFrame p₀ q₀ r * N = 1)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (v : Fin 3 → Polynomial k)
    (hv : TernaryQuadraticPoly.eval (lineTernaryQuadraticPoly p₀ q₀ F) v = 0)
    (i j : Fin 3) :
    residualZeroLocusPointOn p₀ q₀ r N hMN F hF v hv i j ≫
        biprojectiveZeroLocusSnd 2 2 k F =
      ProjectiveSpace.pointOfNormalizedCoordinatesAlgebra (R := k) 2 j
        (residualComponentOnYCoordsNorm p₀ q₀ r N F v i j) := by
  unfold biprojectiveZeroLocusSnd
  rw [← Category.assoc, residualZeroLocusPointOn_ι]
  exact biprojectiveChartPointOfNormalizedAlgebra_comp_standardChartι_snd
    (R := k) (S := residualComponentOnLoc p₀ q₀ r N F v i j)
    2 2 i j
    (residualComponentOnXCoordsNorm p₀ q₀ r N F v i j)
    (residualComponentOnYCoordsNorm p₀ q₀ r N F v i j)

/-- The explicit localized arbitrary-line residual map dominates `P^2_y` under exactly the
general-line Jacobian hypotheses and a nonzero chart denominator. -/
theorem isDominant_residualZeroLocusPointOn_toBase
    {k : Type u} [Field k] [IsAlgClosed k] [CharZero k]
    (p₀ q₀ r : Fin 3 → k) (N : Matrix (Fin 3) (Fin 3) k)
    (hMN : lineFrame p₀ q₀ r * N = 1)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)]
    (hgood : ResidualLineNonconstantOn (lineFrame p₀ q₀ r) N F)
    (v : Fin 3 → Polynomial k) (hv0 : v ≠ 0)
    (hv : TernaryQuadraticPoly.eval (lineTernaryQuadraticPoly p₀ q₀ F) v = 0)
    (hv2 : v 2 ≠ 0)
    (hpolar : lineStereoPolarForm p₀ q₀ F v ≠ 0)
    (i j : Fin 3)
    (hdenom : residualComponentOnDenom p₀ q₀ r N F v i j ≠ 0) :
    IsDominant
      (residualZeroLocusPointOn p₀ q₀ r N hMN F hF v hv i j ≫
        biprojectiveZeroLocusSnd 2 2 k F) := by
  rw [residualZeroLocusPointOn_toBase]
  exact isDominant_pointOfNormalizedCoordinatesAlgebra 2 j _
    (ProjectiveSpace.isDominant_standardChartι 2 k j)
    (injective_standardChartEvalAlgebra_residualComponentOnYCoordsNorm
      p₀ q₀ r N F v i j hdenom
      (fun d Ψ hΨ hvan ↦
        eq_zero_of_aeval_residualYCoordsOn_of_isHomogeneous
          p₀ q₀ r N hMN F hF hF0 hgood v hv0 hv hv2 hpolar d Ψ hΨ hvan))

/-- The scheme-theoretic arbitrary-line residual component dominates the conic-bundle base. -/
theorem isDominant_residualComponentOnToBase
    {k : Type u} [Field k] [IsAlgClosed k] [CharZero k]
    (p₀ q₀ r : Fin 3 → k) (N : Matrix (Fin 3) (Fin 3) k)
    (hMN : lineFrame p₀ q₀ r * N = 1)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)]
    (hgood : ResidualLineNonconstantOn (lineFrame p₀ q₀ r) N F)
    (v : Fin 3 → Polynomial k) (hv0 : v ≠ 0)
    (hv : TernaryQuadraticPoly.eval (lineTernaryQuadraticPoly p₀ q₀ F) v = 0)
    (hv2 : v 2 ≠ 0)
    (hpolar : lineStereoPolarForm p₀ q₀ F v ≠ 0)
    (i j : Fin 3)
    (hdenom : residualComponentOnDenom p₀ q₀ r N F v i j ≠ 0) :
    IsDominant (residualComponentOnToBase p₀ q₀ r N hMN F hF v hv i j) :=
  (isDominant_residualComponentOnToBase_iff p₀ q₀ r N hMN F hF v hv i j).mpr
    (isDominant_residualZeroLocusPointOn_toBase
      p₀ q₀ r N hMN F hF hF0 hgood v hv0 hv hv2 hpolar i j hdenom)

/-- Under the same hypotheses, some standard chart realizes a horizontal arbitrary-line
residual component.  This packages the nonvanishing consequences of the determinant and polar
conditions without adding any hypothesis. -/
theorem exists_isDominant_residualComponentOnToBase
    {k : Type u} [Field k] [IsAlgClosed k] [CharZero k]
    (p₀ q₀ r : Fin 3 → k) (N : Matrix (Fin 3) (Fin 3) k)
    (hMN : lineFrame p₀ q₀ r * N = 1)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)]
    (hgood : ResidualLineNonconstantOn (lineFrame p₀ q₀ r) N F)
    (v : Fin 3 → Polynomial k) (hv0 : v ≠ 0)
    (hv : TernaryQuadraticPoly.eval (lineTernaryQuadraticPoly p₀ q₀ F) v = 0)
    (hv2 : v 2 ≠ 0)
    (hpolar : lineStereoPolarForm p₀ q₀ F v ≠ 0) :
    ∃ i j : Fin 3,
      residualComponentOnDenom p₀ q₀ r N F v i j ≠ 0 ∧
      IsDominant (residualComponentOnToBase p₀ q₀ r N hMN F hF v hv i j) := by
  have hX : stereoFirstCoordsOn p₀ q₀ F v ≠ 0 :=
    stereoFirstCoordsOn_ne_zero_of_polar p₀ q₀ F hF v hv (by
      simpa [lineStereoPolarForm] using hpolar)
  have hY : residualYCoordsOn p₀ q₀ r N F v ≠ 0 :=
    residualYCoordsOn_ne_zero_of_good_line
      p₀ q₀ r N hMN F hF hF0 hgood v hv0 hv hv2 hpolar
  obtain ⟨i, j, hdenom⟩ :=
    exists_residualComponentOnDenom_ne_zero p₀ q₀ r N F v hX hY
  exact ⟨i, j, hdenom,
    isDominant_residualComponentOnToBase
      p₀ q₀ r N hMN F hF hF0 hgood v hv0 hv hv2 hpolar i j hdenom⟩

end

end BConicBundleMultisections
