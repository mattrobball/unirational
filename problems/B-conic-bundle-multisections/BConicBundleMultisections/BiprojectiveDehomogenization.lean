/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.BiprojectiveAffineChart
public import BConicBundleMultisections.BiprojectiveOverlap
public import Mathlib.RingTheory.Localization.FractionRing

/-!
# Injectivity of biprojective dehomogenization

This file evaluates functions on a standard chart of `ℙᵐ × ℙⁿ` in the fraction field of
the bigraded Cox ring.  If `F` has bidegree `(d, e)`, multiplying its chart equation by the
appropriate powers of the two distinguished homogeneous coordinates recovers `F` in that
fraction field.  Consequently, over a domain, dehomogenization on any standard chart is
injective on each fixed bihomogeneous component.
-/

@[expose] public section

open scoped TensorProduct

namespace BConicBundleMultisections

noncomputable section

universe u

attribute [local instance] MvPolynomial.gradedAlgebra

namespace BiprojectiveSpace

/-- The fraction field of the Cox polynomial ring of `ℙᵐ × ℙⁿ` over a domain. -/
private abbrev CoxFractionRing (m n : ℕ) (R : Type u) [CommRing R] :=
  FractionRing (MvPolynomial (BiprojectiveCoordinate m n) R)

/-- Rename the coordinates of the first factor and include its polynomial ring in the Cox
fraction field. -/
private def leftPolynomialToFraction (m n : ℕ) (R : Type u)
    [CommRing R] [IsDomain R] :
    MvPolynomial (Fin (m + 1)) R →ₐ[R] CoxFractionRing m n R :=
  (IsScalarTower.toAlgHom R
    (MvPolynomial (BiprojectiveCoordinate m n) R) (CoxFractionRing m n R)).comp
      (MvPolynomial.rename Sum.inl)

/-- `leftPolynomialToFraction` sends a variable to the corresponding first-block Cox
coordinate. -/
@[simp]
private theorem leftPolynomialToFraction_X (m n : ℕ) (R : Type u)
    [CommRing R] [IsDomain R] (l : Fin (m + 1)) :
    leftPolynomialToFraction m n R (MvPolynomial.X l) =
      algebraMap (MvPolynomial (BiprojectiveCoordinate m n) R) (CoxFractionRing m n R)
        (MvPolynomial.X (.inl l)) := by
  simp [leftPolynomialToFraction]

/-- Extend `leftPolynomialToFraction` across localization at a first-block coordinate. -/
private def leftAwayToFraction (m n : ℕ) (R : Type u) [CommRing R] [IsDomain R]
    (i : Fin (m + 1)) :
    Localization.Away (MvPolynomial.X i : MvPolynomial (Fin (m + 1)) R) →ₐ[R]
      CoxFractionRing m n R :=
  IsLocalization.liftAlgHom (f := leftPolynomialToFraction m n R) (by
    intro y
    obtain ⟨k, hk⟩ :=
      (Submonoid.mem_powers_iff (y : MvPolynomial (Fin (m + 1)) R)
        (MvPolynomial.X i)).mp y.property
    rw [← hk, map_pow]
    apply IsUnit.pow
    rw [isUnit_iff_ne_zero]
    rw [leftPolynomialToFraction_X]
    rw [← map_zero (algebraMap (MvPolynomial (BiprojectiveCoordinate m n) R)
      (CoxFractionRing m n R))]
    exact (IsFractionRing.injective
      (MvPolynomial (BiprojectiveCoordinate m n) R) (CoxFractionRing m n R)).ne
        (MvPolynomial.X_ne_zero (Sum.inl i)))

/-- Embed a degree-zero homogeneous chart ring into the corresponding ordinary localization. -/
private def leftChartVal (m : ℕ) (R : Type u) [CommRing R] (i : Fin (m + 1)) :
    ProjectiveSpace.StandardChartRing m R i →ₐ[R]
      Localization.Away (MvPolynomial.X i : MvPolynomial (Fin (m + 1)) R) where
  __ := algebraMap (ProjectiveSpace.StandardChartRing m R i)
    (Localization.Away (MvPolynomial.X i : MvPolynomial (Fin (m + 1)) R))
  commutes' r := by
    change (algebraMap (ProjectiveSpace.StandardChartRing m R i)
      (Localization.Away (MvPolynomial.X i : MvPolynomial (Fin (m + 1)) R)))
        ((algebraMap R (ProjectiveSpace.StandardChartRing m R i)) r) = _
    rfl

/-- Evaluate functions on a chart of the first factor in the biprojective Cox fraction field. -/
private def leftChartToFraction (m n : ℕ) (R : Type u) [CommRing R] [IsDomain R]
    (i : Fin (m + 1)) :
    ProjectiveSpace.StandardChartRing m R i →ₐ[R] CoxFractionRing m n R :=
  (leftAwayToFraction m n R i).comp (leftChartVal m R i)

/-- `leftChartVal` realizes a normalized homogeneous coordinate as an ordinary fraction. -/
private theorem leftChartVal_normalizedCoordinate
    (m : ℕ) (R : Type u) [CommRing R] (i l : Fin (m + 1)) :
    leftChartVal m R i (ProjectiveSpace.normalizedCoordinate m R i l) =
      IsLocalization.mk'
        (Localization.Away (MvPolynomial.X i : MvPolynomial (Fin (m + 1)) R))
        (MvPolynomial.X l : MvPolynomial (Fin (m + 1)) R)
        (⟨MvPolynomial.X i, Submonoid.mem_powers (MvPolynomial.X i)⟩ :
          Submonoid.powers (MvPolynomial.X i : MvPolynomial (Fin (m + 1)) R)) := by
  change HomogeneousLocalization.val
      (ProjectiveSpace.normalizedCoordinate m R i l) = _
  rw [ProjectiveSpace.normalizedCoordinate, HomogeneousLocalization.Away.val_mk]
  simp only [pow_one]
  rw [Localization.mk_eq_mk'_apply]

/-- The fraction-field value of a normalized coordinate from the first factor. -/
@[simp]
private theorem leftChartToFraction_normalizedCoordinate
    (m n : ℕ) (R : Type u) [CommRing R] [IsDomain R]
    (i l : Fin (m + 1)) :
    leftChartToFraction m n R i (ProjectiveSpace.normalizedCoordinate m R i l) =
      algebraMap (MvPolynomial (BiprojectiveCoordinate m n) R) (CoxFractionRing m n R)
          (MvPolynomial.X (.inl l)) /
        algebraMap (MvPolynomial (BiprojectiveCoordinate m n) R) (CoxFractionRing m n R)
          (MvPolynomial.X (.inl i)) := by
  rw [leftChartToFraction, AlgHom.comp_apply, leftChartVal_normalizedCoordinate]
  apply (IsLocalization.lift_mk'_spec _ _ _ _).2
  change leftPolynomialToFraction m n R (MvPolynomial.X l) =
    leftPolynomialToFraction m n R (MvPolynomial.X i) * _
  rw [leftPolynomialToFraction_X, leftPolynomialToFraction_X]
  field_simp

/-- Rename the coordinates of the second factor and include its polynomial ring in the Cox
fraction field. -/
private def rightPolynomialToFraction (m n : ℕ) (R : Type u)
    [CommRing R] [IsDomain R] :
    MvPolynomial (Fin (n + 1)) R →ₐ[R] CoxFractionRing m n R :=
  (IsScalarTower.toAlgHom R
    (MvPolynomial (BiprojectiveCoordinate m n) R) (CoxFractionRing m n R)).comp
      (MvPolynomial.rename Sum.inr)

/-- `rightPolynomialToFraction` sends a variable to the corresponding second-block Cox
coordinate. -/
@[simp]
private theorem rightPolynomialToFraction_X (m n : ℕ) (R : Type u)
    [CommRing R] [IsDomain R] (l : Fin (n + 1)) :
    rightPolynomialToFraction m n R (MvPolynomial.X l) =
      algebraMap (MvPolynomial (BiprojectiveCoordinate m n) R) (CoxFractionRing m n R)
        (MvPolynomial.X (.inr l)) := by
  simp [rightPolynomialToFraction]

/-- Extend `rightPolynomialToFraction` across localization at a second-block coordinate. -/
private def rightAwayToFraction (m n : ℕ) (R : Type u) [CommRing R] [IsDomain R]
    (j : Fin (n + 1)) :
    Localization.Away (MvPolynomial.X j : MvPolynomial (Fin (n + 1)) R) →ₐ[R]
      CoxFractionRing m n R :=
  IsLocalization.liftAlgHom (f := rightPolynomialToFraction m n R) (by
    intro y
    obtain ⟨k, hk⟩ :=
      (Submonoid.mem_powers_iff (y : MvPolynomial (Fin (n + 1)) R)
        (MvPolynomial.X j)).mp y.property
    rw [← hk, map_pow]
    apply IsUnit.pow
    rw [isUnit_iff_ne_zero]
    rw [rightPolynomialToFraction_X]
    rw [← map_zero (algebraMap (MvPolynomial (BiprojectiveCoordinate m n) R)
      (CoxFractionRing m n R))]
    exact (IsFractionRing.injective
      (MvPolynomial (BiprojectiveCoordinate m n) R) (CoxFractionRing m n R)).ne
        (MvPolynomial.X_ne_zero (Sum.inr j)))

/-- Evaluate functions on a chart of the second factor in the biprojective Cox fraction field. -/
private def rightChartToFraction (m n : ℕ) (R : Type u) [CommRing R] [IsDomain R]
    (j : Fin (n + 1)) :
    ProjectiveSpace.StandardChartRing n R j →ₐ[R] CoxFractionRing m n R :=
  (rightAwayToFraction m n R j).comp (leftChartVal n R j)

/-- The fraction-field value of a normalized coordinate from the second factor. -/
@[simp]
private theorem rightChartToFraction_normalizedCoordinate
    (m n : ℕ) (R : Type u) [CommRing R] [IsDomain R]
    (j l : Fin (n + 1)) :
    rightChartToFraction m n R j (ProjectiveSpace.normalizedCoordinate n R j l) =
      algebraMap (MvPolynomial (BiprojectiveCoordinate m n) R) (CoxFractionRing m n R)
          (MvPolynomial.X (.inr l)) /
        algebraMap (MvPolynomial (BiprojectiveCoordinate m n) R) (CoxFractionRing m n R)
          (MvPolynomial.X (.inr j)) := by
  rw [rightChartToFraction, AlgHom.comp_apply, leftChartVal_normalizedCoordinate]
  apply (IsLocalization.lift_mk'_spec _ _ _ _).2
  change rightPolynomialToFraction m n R (MvPolynomial.X l) =
    rightPolynomialToFraction m n R (MvPolynomial.X j) * _
  rw [rightPolynomialToFraction_X, rightPolynomialToFraction_X]
  field_simp

/-- Evaluation of functions on a biprojective standard chart in the fraction field of its Cox
ring. -/
private def chartToFraction (m n : ℕ) (R : Type u) [CommRing R] [IsDomain R]
    (i : Fin (m + 1)) (j : Fin (n + 1)) :
    StandardChartRing m n R i j →ₐ[R] CoxFractionRing m n R :=
  Algebra.TensorProduct.lift (leftChartToFraction m n R i)
    (rightChartToFraction m n R j) (fun _ _ ↦ Commute.all _ _)

/-- The fraction-field value of a normalized coordinate from the first projective factor. -/
private theorem chartToFraction_chartVariable_inl
    (m n : ℕ) (R : Type u) [CommRing R] [IsDomain R]
    (i l : Fin (m + 1)) (j : Fin (n + 1)) :
    chartToFraction m n R i j (chartVariable m n R i j (.inl l)) =
      algebraMap (MvPolynomial (BiprojectiveCoordinate m n) R) (CoxFractionRing m n R)
          (MvPolynomial.X (.inl l)) /
        algebraMap (MvPolynomial (BiprojectiveCoordinate m n) R) (CoxFractionRing m n R)
          (MvPolynomial.X (.inl i)) := by
  simp [chartToFraction, chartVariable]

/-- The fraction-field value of a normalized coordinate from the second projective factor. -/
private theorem chartToFraction_chartVariable_inr
    (m n : ℕ) (R : Type u) [CommRing R] [IsDomain R]
    (i : Fin (m + 1)) (j l : Fin (n + 1)) :
    chartToFraction m n R i j (chartVariable m n R i j (.inr l)) =
      algebraMap (MvPolynomial (BiprojectiveCoordinate m n) R) (CoxFractionRing m n R)
          (MvPolynomial.X (.inr l)) /
        algebraMap (MvPolynomial (BiprojectiveCoordinate m n) R) (CoxFractionRing m n R)
          (MvPolynomial.X (.inr j)) := by
  simp [chartToFraction, chartVariable]

/-- Evaluation in a chart followed by fraction-field evaluation agrees with direct evaluation
at the normalized homogeneous coordinates. -/
private theorem chartToFraction_chartEquation
    (m n : ℕ) (R : Type u) [CommRing R] [IsDomain R]
    (i : Fin (m + 1)) (j : Fin (n + 1))
    (F : MvPolynomial (BiprojectiveCoordinate m n) R) :
    chartToFraction m n R i j (chartEquation m n R i j F) =
      MvPolynomial.aeval
        (fun z ↦ chartToFraction m n R i j (chartVariable m n R i j z)) F := by
  unfold chartEquation chartEvaluation
  exact map_aeval_algHom (chartToFraction m n R i j) (chartVariable m n R i j) F

/-- Homogenizing the equation on one standard chart recovers the original bihomogeneous Cox
polynomial in the fraction field. -/
private theorem algebraMap_eq_scaling_mul_chartEquation
    (m n : ℕ) (R : Type u) [CommRing R] [IsDomain R]
    (i : Fin (m + 1)) (j : Fin (n + 1))
    {d e : ℕ} (F : MvPolynomial (BiprojectiveCoordinate m n) R)
    (hF : IsBihomogeneousOfBidegree d e F) :
    algebraMap (MvPolynomial (BiprojectiveCoordinate m n) R) (CoxFractionRing m n R) F =
      algebraMap (MvPolynomial (BiprojectiveCoordinate m n) R) (CoxFractionRing m n R)
          (MvPolynomial.X (.inl i)) ^ d *
        algebraMap (MvPolynomial (BiprojectiveCoordinate m n) R) (CoxFractionRing m n R)
          (MvPolynomial.X (.inr j)) ^ e *
        chartToFraction m n R i j (chartEquation m n R i j F) := by
  let x : BiprojectiveCoordinate m n → CoxFractionRing m n R := fun z ↦
    algebraMap (MvPolynomial (BiprojectiveCoordinate m n) R) (CoxFractionRing m n R)
      (MvPolynomial.X z)
  let y : BiprojectiveCoordinate m n → CoxFractionRing m n R := fun z ↦
    chartToFraction m n R i j (chartVariable m n R i j z)
  have hx : ∀ l, x (.inl l) = x (.inl i) * y (.inl l) := by
    intro l
    change algebraMap (MvPolynomial (BiprojectiveCoordinate m n) R)
        (CoxFractionRing m n R) (MvPolynomial.X (.inl l)) =
      algebraMap (MvPolynomial (BiprojectiveCoordinate m n) R)
          (CoxFractionRing m n R) (MvPolynomial.X (.inl i)) *
        chartToFraction m n R i j (chartVariable m n R i j (.inl l))
    rw [chartToFraction_chartVariable_inl]
    field_simp
  have hy : ∀ l, x (.inr l) = x (.inr j) * y (.inr l) := by
    intro l
    change algebraMap (MvPolynomial (BiprojectiveCoordinate m n) R)
        (CoxFractionRing m n R) (MvPolynomial.X (.inr l)) =
      algebraMap (MvPolynomial (BiprojectiveCoordinate m n) R)
          (CoxFractionRing m n R) (MvPolynomial.X (.inr j)) *
        chartToFraction m n R i j (chartVariable m n R i j (.inr l))
    rw [chartToFraction_chartVariable_inr]
    field_simp
  have hscale := aeval_eq_pow_mul_aeval_of_isBihomogeneous hF x y
    (x (.inl i)) (x (.inr j)) hx hy
  rw [← chartToFraction_chartEquation] at hscale
  have hxmap : MvPolynomial.aeval x =
      IsScalarTower.toAlgHom R (MvPolynomial (BiprojectiveCoordinate m n) R)
        (CoxFractionRing m n R) := by
    ext z
    simp [x]
  rw [hxmap] at hscale
  exact hscale

/-- On a fixed bihomogeneous component, dehomogenization on any standard biprojective chart is
injective. -/
theorem chartEquation_eq_zero_iff
    (m n : ℕ) (R : Type u) [CommRing R] [IsDomain R]
    (i : Fin (m + 1)) (j : Fin (n + 1))
    {d e : ℕ} (F : MvPolynomial (BiprojectiveCoordinate m n) R)
    (hF : IsBihomogeneousOfBidegree d e F) :
    chartEquation m n R i j F = 0 ↔ F = 0 := by
  constructor
  · intro h
    apply IsFractionRing.injective
      (MvPolynomial (BiprojectiveCoordinate m n) R) (CoxFractionRing m n R)
    rw [algebraMap_eq_scaling_mul_chartEquation m n R i j F hF, h, map_zero, mul_zero]
    simp
  · rintro rfl
    simp [chartEquation]

/-- A nonzero bihomogeneous Cox polynomial has a nonzero equation on every standard chart. -/
theorem chartEquation_ne_zero
    (m n : ℕ) (R : Type u) [CommRing R] [IsDomain R]
    (i : Fin (m + 1)) (j : Fin (n + 1))
    {d e : ℕ} (F : MvPolynomial (BiprojectiveCoordinate m n) R)
    (hF : IsBihomogeneousOfBidegree d e F) (hF0 : F ≠ 0) :
    chartEquation m n R i j F ≠ 0 :=
  fun h ↦ hF0 ((chartEquation_eq_zero_iff m n R i j F hF).mp h)

/-- On a fixed bihomogeneous component, the ordinary affine dehomogenization on any standard
biprojective chart vanishes exactly when the original Cox polynomial vanishes. -/
theorem affineChartEquation_eq_zero_iff
    (m n : ℕ) (R : Type u) [CommRing R] [IsDomain R]
    (i : Fin (m + 1)) (j : Fin (n + 1))
    {d e : ℕ} (F : MvPolynomial (BiprojectiveCoordinate m n) R)
    (hF : IsBihomogeneousOfBidegree d e F) :
    affineChartEquation m n R i j F = 0 ↔ F = 0 := by
  constructor
  · intro h
    apply (chartEquation_eq_zero_iff m n R i j F hF).mp
    apply (standardChartRingEquivMvPolynomial m n R i j).injective
    rw [map_zero, standardChartRingEquivMvPolynomial_chartEquation]
    exact h
  · intro h
    rw [← standardChartRingEquivMvPolynomial_chartEquation,
      (chartEquation_eq_zero_iff m n R i j F hF).mpr h, map_zero]

/-- A nonzero bihomogeneous Cox polynomial has a nonzero ordinary affine equation on every
standard chart. -/
theorem affineChartEquation_ne_zero
    (m n : ℕ) (R : Type u) [CommRing R] [IsDomain R]
    (i : Fin (m + 1)) (j : Fin (n + 1))
    {d e : ℕ} (F : MvPolynomial (BiprojectiveCoordinate m n) R)
    (hF : IsBihomogeneousOfBidegree d e F) (hF0 : F ≠ 0) :
    affineChartEquation m n R i j F ≠ 0 :=
  fun h ↦ hF0 ((affineChartEquation_eq_zero_iff m n R i j F hF).mp h)

end BiprojectiveSpace

end

end BConicBundleMultisections
