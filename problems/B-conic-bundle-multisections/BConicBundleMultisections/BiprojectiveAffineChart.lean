/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.BiprojectiveChart
public import Mathlib.RingTheory.TensorProduct.MvPolynomial

/-!
# Affine coordinates on standard projective charts

This file identifies the degree-zero homogeneous localization defining a standard chart of
projective n-space with the ordinary polynomial ring in n variables. Taking tensor products
gives the corresponding coordinate equivalence for standard charts of biprojective space.

The affine coordinates are indexed by Fin n; the homogeneous coordinates of projective
n-space are indexed by Fin (n + 1).
-/

@[expose] public section


open scoped TensorProduct

namespace BConicBundleMultisections

noncomputable section

universe u

attribute [local instance] MvPolynomial.gradedAlgebra

namespace ProjectiveSpace

private theorem homogeneous_aeval_scaling
    {σ R S : Type*} [CommSemiring R] [CommSemiring S] [Algebra R S]
    {p : MvPolynomial σ R} {d : ℕ} (hp : p.IsHomogeneous d)
    (x y : σ → S) (u : S) (hxy : ∀ z, x z = u * y z) :
    MvPolynomial.aeval x p = u ^ d * MvPolynomial.aeval y p := by
  classical
  rw [p.as_sum]
  simp only [map_sum, MvPolynomial.aeval_monomial]
  rw [Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro s hs
  have hprod : s.prod (fun z k ↦ x z ^ k) =
      u ^ s.degree * s.prod (fun z k ↦ y z ^ k) := by
    simp only [Finsupp.prod]
    simp_rw [hxy, mul_pow]
    rw [Finset.prod_mul_distrib]
    rw [Finset.prod_pow_eq_pow_sum]
    rfl
  have hsdeg : s.degree = d := by
    rw [Finsupp.degree_eq_weight_one]
    exact hp (MvPolynomial.mem_support_iff.mp hs)
  rw [hprod, hsdeg]
  ring

private theorem map_aeval_algHom
    {σ R A S : Type*} [CommSemiring R] [CommSemiring A] [CommSemiring S]
    [Algebra R A] [Algebra R S] (f : A →ₐ[R] S) (x : σ → A)
    (p : MvPolynomial σ R) :
    f (MvPolynomial.aeval x p) = MvPolynomial.aeval (fun z ↦ f (x z)) p := by
  change f.toRingHom (MvPolynomial.aeval x p) = _
  rw [MvPolynomial.map_aeval]
  rw [show f.toRingHom.comp (algebraMap R A) = algebraMap R S by
    ext r
    exact f.commutes r]
  rfl

/-- Dehomogenize on the standard chart indexed by `i`, sending `Xᵢ` to one and the remaining
homogeneous variables to the affine variables indexed by `Fin n`. -/
def chartDehomogenization (n : ℕ) (R : Type u) [CommRing R]
    (i : Fin (n + 1)) :
    MvPolynomial (Fin (n + 1)) R →ₐ[R] MvPolynomial (Fin n) R :=
  MvPolynomial.aeval (i.succAboveCases 1 fun r ↦ MvPolynomial.X r)

@[simp]
theorem chartDehomogenization_X_self (n : ℕ) (R : Type u) [CommRing R]
    (i : Fin (n + 1)) :
    chartDehomogenization n R i (MvPolynomial.X i) = 1 := by
  simp [chartDehomogenization]

@[simp]
theorem chartDehomogenization_X_succAbove (n : ℕ) (R : Type u) [CommRing R]
    (i : Fin (n + 1)) (r : Fin n) :
    chartDehomogenization n R i (MvPolynomial.X (i.succAbove r)) = MvPolynomial.X r := by
  simp [chartDehomogenization]

/-- Extend standard-chart dehomogenization across the ordinary localization away from `Xᵢ`. -/
def awayToMvPolynomial (n : ℕ) (R : Type u) [CommRing R]
    (i : Fin (n + 1)) :
    Localization.Away (MvPolynomial.X i : MvPolynomial (Fin (n + 1)) R) →ₐ[R]
      MvPolynomial (Fin n) R :=
  IsLocalization.Away.liftAlgHom (f := chartDehomogenization n R i) (MvPolynomial.X i)
    (by rw [chartDehomogenization_X_self]; exact isUnit_one)

/-- Forget the degree-zero condition and view a standard-chart function in the ordinary
localization away from its distinguished coordinate. -/
def standardChartVal (n : ℕ) (R : Type u) [CommRing R]
    (i : Fin (n + 1)) :
    StandardChartRing n R i →ₐ[R]
      Localization.Away (MvPolynomial.X i : MvPolynomial (Fin (n + 1)) R) where
  __ := algebraMap (StandardChartRing n R i)
    (Localization.Away (MvPolynomial.X i : MvPolynomial (Fin (n + 1)) R))
  commutes' r := by
    change (algebraMap (StandardChartRing n R i)
      (Localization.Away (MvPolynomial.X i : MvPolynomial (Fin (n + 1)) R)))
        ((algebraMap R (StandardChartRing n R i)) r) = _
    rfl

/-- Dehomogenize a regular function on a standard projective chart to an affine polynomial. -/
def standardChartToMvPolynomial (n : ℕ) (R : Type u) [CommRing R]
    (i : Fin (n + 1)) :
    StandardChartRing n R i →ₐ[R] MvPolynomial (Fin n) R :=
  (awayToMvPolynomial n R i).comp (standardChartVal n R i)

/-- Evaluate an affine polynomial at the normalized homogeneous coordinates of a standard
projective chart. -/
def mvPolynomialToStandardChart (n : ℕ) (R : Type u) [CommRing R]
    (i : Fin (n + 1)) :
    MvPolynomial (Fin n) R →ₐ[R] StandardChartRing n R i :=
  MvPolynomial.aeval fun r ↦ normalizedCoordinate n R i (i.succAbove r)

theorem standardChartVal_normalizedCoordinate (n : ℕ) (R : Type u) [CommRing R]
    (i l : Fin (n + 1)) :
    standardChartVal n R i (normalizedCoordinate n R i l) =
      IsLocalization.mk'
        (Localization.Away (MvPolynomial.X i : MvPolynomial (Fin (n + 1)) R))
        (MvPolynomial.X l : MvPolynomial (Fin (n + 1)) R)
        (⟨MvPolynomial.X i, Submonoid.mem_powers (MvPolynomial.X i)⟩ :
          Submonoid.powers (MvPolynomial.X i : MvPolynomial (Fin (n + 1)) R)) := by
  change HomogeneousLocalization.val (normalizedCoordinate n R i l) = _
  rw [normalizedCoordinate, HomogeneousLocalization.Away.val_mk]
  simp only [pow_one]
  rw [Localization.mk_eq_mk'_apply]

theorem standardChartVal_away_mk
    (n : ℕ) (R : Type u) [CommRing R] (i : Fin (n + 1))
    (d : ℕ) (p : MvPolynomial (Fin (n + 1)) R)
    (hp : p ∈ MvPolynomial.homogeneousSubmodule (Fin (n + 1)) R d) :
    standardChartVal n R i
        (HomogeneousLocalization.Away.mk
          (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) R)
          (MvPolynomial.isHomogeneous_X R i) d p (by simpa using hp)) =
      IsLocalization.mk'
        (Localization.Away (MvPolynomial.X i : MvPolynomial (Fin (n + 1)) R)) p
        (⟨MvPolynomial.X i ^ d, ⟨d, rfl⟩⟩ :
          Submonoid.powers (MvPolynomial.X i : MvPolynomial (Fin (n + 1)) R)) := by
  change HomogeneousLocalization.val
    (HomogeneousLocalization.Away.mk
      (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) R)
      (MvPolynomial.isHomogeneous_X R i) d p (by simpa using hp)) = _
  rw [HomogeneousLocalization.Away.val_mk]
  rw [Localization.mk_eq_mk'_apply]

theorem standardChartToMvPolynomial_away_mk
    (n : ℕ) (R : Type u) [CommRing R] (i : Fin (n + 1))
    (d : ℕ) (p : MvPolynomial (Fin (n + 1)) R)
    (hp : p ∈ MvPolynomial.homogeneousSubmodule (Fin (n + 1)) R d) :
    standardChartToMvPolynomial n R i
        (HomogeneousLocalization.Away.mk
          (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) R)
          (MvPolynomial.isHomogeneous_X R i) d p (by simpa using hp)) =
      chartDehomogenization n R i p := by
  rw [standardChartToMvPolynomial, AlgHom.comp_apply,
    standardChartVal_away_mk, awayToMvPolynomial,
    IsLocalization.Away.liftAlgHom_apply]
  · apply (IsLocalization.lift_mk'_spec _ _ _ _).2
    simp
  · exact hp

@[simp]
theorem standardChartToMvPolynomial_normalizedCoordinate_succAbove
    (n : ℕ) (R : Type u) [CommRing R] (i : Fin (n + 1)) (r : Fin n) :
    standardChartToMvPolynomial n R i (normalizedCoordinate n R i (i.succAbove r)) =
      MvPolynomial.X r := by
  rw [standardChartToMvPolynomial, AlgHom.comp_apply,
    standardChartVal_normalizedCoordinate]
  rw [awayToMvPolynomial, IsLocalization.Away.liftAlgHom_apply]
  apply (IsLocalization.lift_mk'_spec _ _ _ _).2
  simp

@[simp]
theorem standardChartToMvPolynomial_comp_mvPolynomialToStandardChart
    (n : ℕ) (R : Type u) [CommRing R] (i : Fin (n + 1)) :
    (standardChartToMvPolynomial n R i).comp (mvPolynomialToStandardChart n R i) =
      AlgHom.id R (MvPolynomial (Fin n) R) := by
  ext r
  simp [mvPolynomialToStandardChart]

theorem mvPolynomialToStandardChart_comp_chartDehomogenization
    (n : ℕ) (R : Type u) [CommRing R] (i : Fin (n + 1)) :
    (mvPolynomialToStandardChart n R i).comp (chartDehomogenization n R i) =
      MvPolynomial.aeval (fun l ↦ normalizedCoordinate n R i l) := by
  ext l
  rcases Fin.eq_self_or_eq_succAbove i l with rfl | ⟨r, rfl⟩
  · simp [mvPolynomialToStandardChart]
  · simp [mvPolynomialToStandardChart]

theorem mvPolynomialToStandardChart_chartDehomogenization_of_isHomogeneous
    (n : ℕ) (R : Type u) [CommRing R] (i : Fin (n + 1))
    {p : MvPolynomial (Fin (n + 1)) R} {d : ℕ} (hp : p.IsHomogeneous d) :
    mvPolynomialToStandardChart n R i (chartDehomogenization n R i p) =
      HomogeneousLocalization.Away.mk
        (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) R)
        (MvPolynomial.isHomogeneous_X R i) d p (by simpa using hp) := by
  rw [← AlgHom.comp_apply, mvPolynomialToStandardChart_comp_chartDehomogenization]
  apply HomogeneousLocalization.val_injective
  rw [HomogeneousLocalization.Away.val_mk]
  change standardChartVal n R i
    (MvPolynomial.aeval (fun l ↦ normalizedCoordinate n R i l) p) = _
  rw [map_aeval_algHom]
  rw [Localization.mk_eq_mk'_apply]
  apply IsLocalization.eq_mk'_iff_mul_eq.mpr
  let x : Fin (n + 1) →
      Localization.Away (MvPolynomial.X i : MvPolynomial (Fin (n + 1)) R) :=
    fun l ↦ algebraMap (MvPolynomial (Fin (n + 1)) R) _ (MvPolynomial.X l)
  let y : Fin (n + 1) →
      Localization.Away (MvPolynomial.X i : MvPolynomial (Fin (n + 1)) R) :=
    fun l ↦ standardChartVal n R i (normalizedCoordinate n R i l)
  have hxy : ∀ l, x l = x i * y l := by
    intro l
    change algebraMap (MvPolynomial (Fin (n + 1)) R) _ (MvPolynomial.X l) =
      algebraMap (MvPolynomial (Fin (n + 1)) R) _ (MvPolynomial.X i) *
        standardChartVal n R i (normalizedCoordinate n R i l)
    rw [standardChartVal_normalizedCoordinate]
    simpa only [mul_comm] using
      (IsLocalization.mk'_spec
        (S := Localization.Away (MvPolynomial.X i : MvPolynomial (Fin (n + 1)) R))
        (MvPolynomial.X l)
        (⟨MvPolynomial.X i, Submonoid.mem_powers (MvPolynomial.X i)⟩ :
          Submonoid.powers (MvPolynomial.X i : MvPolynomial (Fin (n + 1)) R))).symm
  have hscale := homogeneous_aeval_scaling hp x y (x i) hxy
  have hxmap : MvPolynomial.aeval x =
      IsScalarTower.toAlgHom R (MvPolynomial (Fin (n + 1)) R)
        (Localization.Away (MvPolynomial.X i : MvPolynomial (Fin (n + 1)) R)) := by
    ext l
    simp [x]
  rw [hxmap] at hscale
  change MvPolynomial.aeval y p *
      algebraMap (MvPolynomial (Fin (n + 1)) R) _ (MvPolynomial.X i ^ d) =
    algebraMap (MvPolynomial (Fin (n + 1)) R) _ p
  rw [map_pow]
  simpa [x, mul_comm] using hscale.symm

theorem mvPolynomialToStandardChart_standardChartToMvPolynomial
    (n : ℕ) (R : Type u) [CommRing R] (i : Fin (n + 1))
    (z : StandardChartRing n R i) :
    mvPolynomialToStandardChart n R i (standardChartToMvPolynomial n R i z) = z := by
  obtain ⟨d, p, hp, rfl⟩ :=
    HomogeneousLocalization.Away.mk_surjective
      (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) R)
      (MvPolynomial.isHomogeneous_X R i) z
  rw [standardChartToMvPolynomial_away_mk]
  · exact mvPolynomialToStandardChart_chartDehomogenization_of_isHomogeneous
      n R i (by simpa using hp)
  · simpa using hp

@[simp]
theorem mvPolynomialToStandardChart_comp_standardChartToMvPolynomial
    (n : ℕ) (R : Type u) [CommRing R] (i : Fin (n + 1)) :
    (mvPolynomialToStandardChart n R i).comp (standardChartToMvPolynomial n R i) =
      AlgHom.id R (StandardChartRing n R i) := by
  apply AlgHom.ext
  intro z
  exact mvPolynomialToStandardChart_standardChartToMvPolynomial n R i z

/-- The coordinate ring of a standard chart of projective `n`-space is the polynomial ring in
`n` affine coordinates. -/
noncomputable def standardChartRingEquivMvPolynomial
    (n : ℕ) (R : Type u) [CommRing R] (i : Fin (n + 1)) :
    StandardChartRing n R i ≃ₐ[R] MvPolynomial (Fin n) R :=
  AlgEquiv.ofAlgHom
    (standardChartToMvPolynomial n R i)
    (mvPolynomialToStandardChart n R i)
    (standardChartToMvPolynomial_comp_mvPolynomialToStandardChart n R i)
    (mvPolynomialToStandardChart_comp_standardChartToMvPolynomial n R i)

@[simp]
theorem standardChartRingEquivMvPolynomial_normalizedCoordinate_succAbove
    (n : ℕ) (R : Type u) [CommRing R] (i : Fin (n + 1)) (r : Fin n) :
    standardChartRingEquivMvPolynomial n R i
        (normalizedCoordinate n R i (i.succAbove r)) =
      MvPolynomial.X r := by
  exact standardChartToMvPolynomial_normalizedCoordinate_succAbove n R i r

end ProjectiveSpace

namespace BiprojectiveSpace

/-- The coordinate ring of a standard chart of biprojective `(m,n)`-space is the polynomial ring
in the two blocks of affine coordinates. -/
noncomputable def standardChartRingEquivMvPolynomial
    (m n : ℕ) (R : Type u) [CommRing R]
    (i : Fin (m + 1)) (j : Fin (n + 1)) :
    StandardChartRing m n R i j ≃ₐ[R] MvPolynomial (Fin m ⊕ Fin n) R :=
  (Algebra.TensorProduct.congr
      (ProjectiveSpace.standardChartRingEquivMvPolynomial m R i)
      (ProjectiveSpace.standardChartRingEquivMvPolynomial n R j)).trans
    (MvPolynomial.tensorEquivSum R (Fin m) (Fin n) R)

@[simp]
theorem standardChartRingEquivMvPolynomial_normalizedCoordinate_tmul_one
    (m n : ℕ) (R : Type u) [CommRing R]
    (i : Fin (m + 1)) (j : Fin (n + 1)) (r : Fin m) :
    standardChartRingEquivMvPolynomial m n R i j
        (ProjectiveSpace.normalizedCoordinate m R i (i.succAbove r) ⊗ₜ[R] 1) =
      MvPolynomial.X (.inl r) := by
  simp [standardChartRingEquivMvPolynomial]

@[simp]
theorem standardChartRingEquivMvPolynomial_one_tmul_normalizedCoordinate
    (m n : ℕ) (R : Type u) [CommRing R]
    (i : Fin (m + 1)) (j : Fin (n + 1)) (r : Fin n) :
    standardChartRingEquivMvPolynomial m n R i j
        (1 ⊗ₜ[R] ProjectiveSpace.normalizedCoordinate n R j (j.succAbove r)) =
      MvPolynomial.X (.inr r) := by
  simp [standardChartRingEquivMvPolynomial]

/-- The affine value of each homogeneous coordinate on the standard product chart `(i, j)`.
The distinguished coordinate in each block is one, and the others are the corresponding affine
variables. -/
def affineChartVariable (m n : ℕ) (R : Type u) [CommRing R]
    (i : Fin (m + 1)) (j : Fin (n + 1)) :
    BiprojectiveCoordinate m n → MvPolynomial (Fin m ⊕ Fin n) R
  | .inl l => i.succAboveCases 1 (fun r ↦ MvPolynomial.X (.inl r)) l
  | .inr l => j.succAboveCases 1 (fun r ↦ MvPolynomial.X (.inr r)) l

/-- The product-chart coordinate equivalence sends each normalized homogeneous coordinate to
its explicit affine value. -/
theorem standardChartRingEquivMvPolynomial_chartVariable
    (m n : ℕ) (R : Type u) [CommRing R]
    (i : Fin (m + 1)) (j : Fin (n + 1))
    (l : BiprojectiveCoordinate m n) :
    standardChartRingEquivMvPolynomial m n R i j
        (chartVariable m n R i j l) =
      affineChartVariable m n R i j l := by
  rcases l with l | l
  · rw [chartVariable_inl]
    rcases Fin.eq_self_or_eq_succAbove i l with rfl | ⟨r, rfl⟩
    · simp only [ProjectiveSpace.normalizedCoordinate_self]
      change standardChartRingEquivMvPolynomial m n R l j 1 = _
      simp [affineChartVariable]
    · simp [affineChartVariable]
  · rw [chartVariable_inr]
    rcases Fin.eq_self_or_eq_succAbove j l with rfl | ⟨r, rfl⟩
    · simp only [ProjectiveSpace.normalizedCoordinate_self]
      change standardChartRingEquivMvPolynomial m n R i l 1 = _
      simp [affineChartVariable]
    · simp [affineChartVariable]

/-- Evaluate a Cox-coordinate polynomial in the explicit affine coordinates on the standard
product chart `(i, j)`. -/
def affineChartEvaluation (m n : ℕ) (R : Type u) [CommRing R]
    (i : Fin (m + 1)) (j : Fin (n + 1)) :
    MvPolynomial (BiprojectiveCoordinate m n) R →ₐ[R]
      MvPolynomial (Fin m ⊕ Fin n) R :=
  MvPolynomial.aeval (affineChartVariable m n R i j)

/-- The ordinary affine polynomial defining a biprojective equation on the standard product
chart `(i, j)`. -/
def affineChartEquation (m n : ℕ) (R : Type u) [CommRing R]
    (i : Fin (m + 1)) (j : Fin (n + 1))
    (F : MvPolynomial (BiprojectiveCoordinate m n) R) :
    MvPolynomial (Fin m ⊕ Fin n) R :=
  affineChartEvaluation m n R i j F

/-- Transporting the chart equation through the product-chart coordinate equivalence gives its
explicit affine dehomogenization. -/
theorem standardChartRingEquivMvPolynomial_chartEquation
    (m n : ℕ) (R : Type u) [CommRing R]
    (i : Fin (m + 1)) (j : Fin (n + 1))
    (F : MvPolynomial (BiprojectiveCoordinate m n) R) :
    standardChartRingEquivMvPolynomial m n R i j
        (chartEquation m n R i j F) =
      affineChartEquation m n R i j F := by
  rw [chartEquation, chartEvaluation, affineChartEquation, affineChartEvaluation]
  change (standardChartRingEquivMvPolynomial m n R i j).toAlgHom
      (MvPolynomial.aeval (chartVariable m n R i j) F) = _
  rw [ProjectiveSpace.map_aeval_algHom]
  congr 1
  apply MvPolynomial.algHom_ext
  intro l
  simp only [MvPolynomial.aeval_X]
  exact standardChartRingEquivMvPolynomial_chartVariable m n R i j l

end BiprojectiveSpace

end

end BConicBundleMultisections
