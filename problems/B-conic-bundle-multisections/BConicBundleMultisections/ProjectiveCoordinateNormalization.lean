/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.MvPolynomialHomogeneousEvaluation

/-!
# Normalizing homogeneous coordinate representatives

A nonzero homogeneous-coordinate vector has a nonzero coordinate.  Scaling by the inverse of
that coordinate produces the canonical representative whose selected coordinate is one.  This
file records the construction and its compatibility with homogeneous polynomial evaluation.
-/

@[expose] public section

namespace BConicBundleMultisections

noncomputable section

universe u v

open _root_.MvPolynomial

variable {σ : Type v} {K : Type u} [Field K]

/-- Scale a homogeneous-coordinate vector so that its `i`-th coordinate becomes one whenever
that coordinate is nonzero. -/
def normalizeCoordinateRepresentative (x : σ → K) (i : σ) : σ → K :=
  (x i)⁻¹ • x

/-- The selected coordinate of a normalized representative is one. -/
theorem normalizeCoordinateRepresentative_apply
    (x : σ → K) (i : σ) (hi : x i ≠ 0) :
    normalizeCoordinateRepresentative x i i = 1 := by
  simp [normalizeCoordinateRepresentative, hi]

/-- Normalizing at a nonzero coordinate preserves nonzeroness of the representative. -/
theorem normalizeCoordinateRepresentative_ne_zero
    (x : σ → K) (i : σ) (hx : x ≠ 0) (hi : x i ≠ 0) :
    normalizeCoordinateRepresentative x i ≠ 0 := by
  intro h
  apply hx
  funext z
  have hz := congrFun h z
  simp only [normalizeCoordinateRepresentative, Pi.smul_apply, smul_eq_mul,
    Pi.zero_apply] at hz
  exact (mul_eq_zero.mp hz).resolve_left (inv_ne_zero hi)

/-- Every nonzero coordinate vector has a coordinate at which it can be normalized. -/
theorem exists_normalizing_coordinate (x : σ → K) (hx : x ≠ 0) :
    ∃ i : σ, x i ≠ 0 := by
  by_contra h
  push Not at h
  apply hx
  funext i
  exact h i

/-- Evaluation of a homogeneous polynomial at a normalized representative differs from its
original value by the expected nonzero scalar power. -/
theorem eval_normalizeCoordinateRepresentative_of_isHomogeneous
    {f : MvPolynomial σ K} {d : ℕ} (hf : f.IsHomogeneous d)
    (x : σ → K) (i : σ) :
    eval (normalizeCoordinateRepresentative x i) f =
      (x i)⁻¹ ^ d * eval x f := by
  rw [show normalizeCoordinateRepresentative x i =
      fun z ↦ (x i)⁻¹ * x z by
    funext z
    simp [normalizeCoordinateRepresentative]]
  exact eval_smul_point_of_isHomogeneous hf (x i)⁻¹ x

/-- A zero of a homogeneous polynomial remains a zero after coordinate normalization. -/
theorem eval_normalizeCoordinateRepresentative_eq_zero
    {f : MvPolynomial σ K} {d : ℕ} (hf : f.IsHomogeneous d)
    (x : σ → K) (i : σ) (hx : eval x f = 0) :
    eval (normalizeCoordinateRepresentative x i) f = 0 := by
  rw [eval_normalizeCoordinateRepresentative_of_isHomogeneous hf, hx, mul_zero]

end

end BConicBundleMultisections
