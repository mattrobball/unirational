/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import Mathlib.RingTheory.MvPolynomial.EulerIdentity

/-!
# Bigraded Cox polynomials for products of projective spaces

This file defines the two blocks of Cox coordinates for `ℙᵐ × ℙⁿ`, their standard bigrading,
and the predicate that a polynomial has a specified bidegree.  The coordinate blocks are indexed
by `Fin (m + 1)` and `Fin (n + 1)`, so `m` and `n` denote geometric dimensions.
-/

@[expose] public section

namespace BConicBundleMultisections

open Finsupp

/-- The two blocks of Cox coordinates for `ℙᵐ × ℙⁿ`. -/
abbrev BiprojectiveCoordinate (m n : ℕ) := Sum (Fin (m + 1)) (Fin (n + 1))

/-- The standard `ℕ × ℕ` weight of a Cox coordinate on `ℙᵐ × ℙⁿ`. -/
def bidegreeWeight {m n : ℕ} : BiprojectiveCoordinate m n → ℕ × ℕ
  | .inl _ => (1, 0)
  | .inr _ => (0, 1)

/-- A polynomial in the two blocks of Cox coordinates is bihomogeneous of bidegree `(a, b)`. -/
def IsBihomogeneousOfBidegree {m n : ℕ} {R : Type*} [CommSemiring R]
    (a b : ℕ) (F : MvPolynomial (BiprojectiveCoordinate m n) R) : Prop :=
  F.IsWeightedHomogeneous bidegreeWeight (a, b)

/-- The exact polynomial-level predicate for bidegree `(2, 3)`. -/
abbrev IsBidegree23 {m n : ℕ} {R : Type*} [CommSemiring R]
    (F : MvPolynomial (BiprojectiveCoordinate m n) R) : Prop :=
  IsBihomogeneousOfBidegree 2 3 F

/-- The ordinary grading that counts variables from the first Cox-coordinate block. -/
def leftDegreeWeight {m n : ℕ} : BiprojectiveCoordinate m n → ℕ
  | .inl _ => 1
  | .inr _ => 0

/-- The ordinary grading that counts variables from the second Cox-coordinate block. -/
def rightDegreeWeight {m n : ℕ} : BiprojectiveCoordinate m n → ℕ
  | .inl _ => 0
  | .inr _ => 1

/-- The first component of the bidegree weight is the ordinary degree in the first coordinate
block. -/
theorem fst_weight_bidegreeWeight {m n : ℕ}
    (d : BiprojectiveCoordinate m n →₀ ℕ) :
    (weight bidegreeWeight d).1 = weight leftDegreeWeight d := by
  classical
  simp only [weight_apply, Finsupp.sum, Prod.fst_sum]
  apply Finset.sum_congr rfl
  intro z hz
  cases z <;> rfl

/-- The second component of the bidegree weight is the ordinary degree in the second coordinate
block. -/
theorem snd_weight_bidegreeWeight {m n : ℕ}
    (d : BiprojectiveCoordinate m n →₀ ℕ) :
    (weight bidegreeWeight d).2 = weight rightDegreeWeight d := by
  classical
  simp only [weight_apply, Finsupp.sum, Prod.snd_sum]
  apply Finset.sum_congr rfl
  intro z hz
  cases z <;> rfl

/-- A bihomogeneous polynomial is homogeneous in the first coordinate block. -/
theorem IsBihomogeneousOfBidegree.isWeightedHomogeneous_left
    {m n a b : ℕ} {R : Type*} [CommSemiring R]
    {F : MvPolynomial (BiprojectiveCoordinate m n) R}
    (hF : IsBihomogeneousOfBidegree a b F) :
    F.IsWeightedHomogeneous leftDegreeWeight a := by
  intro d hd
  have h := congrArg Prod.fst (hF hd)
  simpa only [fst_weight_bidegreeWeight] using h

/-- A bihomogeneous polynomial is homogeneous in the second coordinate block. -/
theorem IsBihomogeneousOfBidegree.isWeightedHomogeneous_right
    {m n a b : ℕ} {R : Type*} [CommSemiring R]
    {F : MvPolynomial (BiprojectiveCoordinate m n) R}
    (hF : IsBihomogeneousOfBidegree a b F) :
    F.IsWeightedHomogeneous rightDegreeWeight b := by
  intro d hd
  have h := congrArg Prod.snd (hF hd)
  simpa only [snd_weight_bidegreeWeight] using h

/-- Euler's identity for the first coordinate block of a bihomogeneous polynomial. -/
theorem IsBihomogeneousOfBidegree.sum_inl_X_mul_pderiv
    {m n a b : ℕ} {R : Type*} [CommSemiring R]
    {F : MvPolynomial (BiprojectiveCoordinate m n) R}
    (hF : IsBihomogeneousOfBidegree a b F) :
    ∑ i : Fin (m + 1), MvPolynomial.X (.inl i) * MvPolynomial.pderiv (.inl i) F =
      a • F := by
  have h := hF.isWeightedHomogeneous_left.sum_weight_X_mul_pderiv
  rw [Fintype.sum_sum_type] at h
  simpa [leftDegreeWeight] using h

/-- Euler's identity for the second coordinate block of a bihomogeneous polynomial. -/
theorem IsBihomogeneousOfBidegree.sum_inr_X_mul_pderiv
    {m n a b : ℕ} {R : Type*} [CommSemiring R]
    {F : MvPolynomial (BiprojectiveCoordinate m n) R}
    (hF : IsBihomogeneousOfBidegree a b F) :
    ∑ j : Fin (n + 1), MvPolynomial.X (.inr j) * MvPolynomial.pderiv (.inr j) F =
      b • F := by
  have h := hF.isWeightedHomogeneous_right.sum_weight_X_mul_pderiv
  rw [Fintype.sum_sum_type] at h
  simpa [rightDegreeWeight] using h

end BConicBundleMultisections
