/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.BigradedPolynomial
public import BConicBundleMultisections.ProjectiveSpace

/-!
# Equations on standard biprojective charts

This file evaluates Cox-coordinate polynomials on the standard affine charts of
`ProjectiveSpace m R ×[Spec R] ProjectiveSpace n R`.  On the chart indexed by `(i, j)`, the
homogeneous coordinates are normalized by `Xᵢ = 1` and `Yⱼ = 1` inside the two degree-zero
homogeneous localizations.  Here `i : Fin (m + 1)` and `j : Fin (n + 1)`.

The definitions are made over an arbitrary commutative ring.  Bihomogeneity is used later to
prove that the resulting principal ideals agree on chart overlaps.
-/

@[expose] public section

open scoped TensorProduct

namespace BConicBundleMultisections

noncomputable section

universe u

attribute [local instance] MvPolynomial.gradedAlgebra

namespace ProjectiveSpace

/-- The homogeneous coordinate `Xₗ`, divided by the distinguished chart coordinate `Xᵢ`. -/
def normalizedCoordinate (n : ℕ) (R : Type u) [CommRing R] (i l : Fin (n + 1)) :
    StandardChartRing n R i :=
  HomogeneousLocalization.Away.mk
    (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) R)
    (MvPolynomial.isHomogeneous_X R i) 1
    (MvPolynomial.X l)
    (by simpa using MvPolynomial.isHomogeneous_X R l)

@[simp]
theorem normalizedCoordinate_self (n : ℕ) (R : Type u) [CommRing R]
    (i : Fin (n + 1)) : normalizedCoordinate n R i i = 1 := by
  rw [HomogeneousLocalization.ext_iff_val]
  simp [normalizedCoordinate, HomogeneousLocalization.Away.val_mk,
    HomogeneousLocalization.val_one]

end ProjectiveSpace

namespace BiprojectiveSpace

/--
The value of a Cox coordinate on the standard product chart indexed by `(i, j)`.

Coordinates from the first projective-space factor enter the left tensor factor, and coordinates
from the second projective-space factor enter the right tensor factor.
-/
def chartVariable (m n : ℕ) (R : Type u) [CommRing R]
    (i : Fin (m + 1)) (j : Fin (n + 1)) :
    BiprojectiveCoordinate m n → StandardChartRing m n R i j
  | .inl l => ProjectiveSpace.normalizedCoordinate m R i l ⊗ₜ[R] 1
  | .inr l => 1 ⊗ₜ[R] ProjectiveSpace.normalizedCoordinate n R j l

@[simp]
theorem chartVariable_inl (m n : ℕ) (R : Type u) [CommRing R]
    (i l : Fin (m + 1)) (j : Fin (n + 1)) :
    chartVariable m n R i j (.inl l) =
      ProjectiveSpace.normalizedCoordinate m R i l ⊗ₜ[R] 1 :=
  rfl

@[simp]
theorem chartVariable_inr (m n : ℕ) (R : Type u) [CommRing R]
    (i : Fin (m + 1)) (j l : Fin (n + 1)) :
    chartVariable m n R i j (.inr l) =
      1 ⊗ₜ[R] ProjectiveSpace.normalizedCoordinate n R j l :=
  rfl

/-- Evaluation of Cox polynomials on the standard product chart indexed by `(i, j)`. -/
def chartEvaluation (m n : ℕ) (R : Type u) [CommRing R]
    (i : Fin (m + 1)) (j : Fin (n + 1)) :
    MvPolynomial (BiprojectiveCoordinate m n) R →ₐ[R] StandardChartRing m n R i j :=
  MvPolynomial.aeval (chartVariable m n R i j)

@[simp]
theorem chartEvaluation_X_inl (m n : ℕ) (R : Type u) [CommRing R]
    (i l : Fin (m + 1)) (j : Fin (n + 1)) :
    chartEvaluation m n R i j (MvPolynomial.X (.inl l)) =
      ProjectiveSpace.normalizedCoordinate m R i l ⊗ₜ[R] 1 := by
  simp [chartEvaluation]

@[simp]
theorem chartEvaluation_X_inr (m n : ℕ) (R : Type u) [CommRing R]
    (i : Fin (m + 1)) (j l : Fin (n + 1)) :
    chartEvaluation m n R i j (MvPolynomial.X (.inr l)) =
      1 ⊗ₜ[R] ProjectiveSpace.normalizedCoordinate n R j l := by
  simp [chartEvaluation]

/-- The regular function cut out by a Cox polynomial on a standard product chart. -/
def chartEquation (m n : ℕ) (R : Type u) [CommRing R]
    (i : Fin (m + 1)) (j : Fin (n + 1))
    (F : MvPolynomial (BiprojectiveCoordinate m n) R) : StandardChartRing m n R i j :=
  chartEvaluation m n R i j F

end BiprojectiveSpace

end

end BConicBundleMultisections
