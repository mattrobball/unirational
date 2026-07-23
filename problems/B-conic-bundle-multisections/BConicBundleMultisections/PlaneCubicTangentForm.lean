/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.MvPolynomialHomogeneousEvaluation
public import Mathlib.RingTheory.MvPolynomial.EulerIdentity

/-!
# Coordinate tangent forms of projective hypersurfaces

This file defines the linear form obtained by evaluating the partial derivatives of a
homogeneous polynomial at a point.  The construction is stated for an arbitrary finite set of
homogeneous coordinates; the specialization to tangent lines of plane cubics is kept separate
from this generic API.
-/

@[expose] public section

namespace BConicBundleMultisections

noncomputable section

universe u

open MvPolynomial

variable {σ : Type*} {R : Type u} [CommSemiring R]

variable [Fintype σ]

/-- The coordinate tangent form of `f` at `p`: its coefficient of `X i` is the value at `p` of
the partial derivative of `f` with respect to `X i`. -/
def tangentForm (f : MvPolynomial σ R) (p : σ → R) : MvPolynomial σ R :=
  ∑ i : σ, C (eval p (pderiv i f)) * X i

/-- Multiplying a polynomial by a scalar constant multiplies its tangent form by the same
constant. -/
theorem tangentForm_C_mul (r : R) (f : MvPolynomial σ R) (p : σ → R) :
    tangentForm (C r * f) p = C r * tangentForm f p := by
  classical
  unfold tangentForm
  rw [Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro i hi
  simp [Derivation.leibniz, mul_assoc]

/-- The tangent-form construction is compatible with scalar multiplication of its polynomial
argument. -/
theorem tangentForm_smul (r : R) (f : MvPolynomial σ R) (p : σ → R) :
    tangentForm (r • f) p = r • tangentForm f p := by
  rw [Algebra.smul_def, Algebra.smul_def]
  exact tangentForm_C_mul r f p

/-- The tangent-form construction is additive in its polynomial argument. -/
theorem tangentForm_add (f g : MvPolynomial σ R) (p : σ → R) :
    tangentForm (f + g) p = tangentForm f p + tangentForm g p := by
  classical
  simp only [tangentForm, map_add, add_mul, Finset.sum_add_distrib]

/-- The product rule for tangent forms.  Each scalar factor is embedded as a constant
polynomial so that the identity lives in the polynomial ring. -/
theorem tangentForm_mul (f g : MvPolynomial σ R) (p : σ → R) :
    tangentForm (f * g) p =
      C (eval p f) * tangentForm g p +
        C (eval p g) * tangentForm f p := by
  classical
  unfold tangentForm
  simp only [Derivation.leibniz, map_add, add_mul,
    Finset.sum_add_distrib, Finset.mul_sum]
  apply congrArg₂ (· + ·)
  · apply Finset.sum_congr rfl
    intro i hi
    simp [mul_comm, mul_left_comm]
  · apply Finset.sum_congr rfl
    intro i hi
    simp [mul_comm, mul_left_comm]

/-- The coefficient of `X i` in the tangent form is the `i`-th partial derivative evaluated at
the base point. -/
@[simp]
theorem coeff_tangentForm (f : MvPolynomial σ R) (p : σ → R) (i : σ) :
    coeff (Finsupp.single i 1) (tangentForm f p) = eval p (pderiv i f) := by
  classical
  rw [tangentForm, coeff_sum]
  simp

/-- The tangent form vanishes exactly when every coordinate partial derivative vanishes at the
base point. -/
theorem tangentForm_eq_zero_iff (f : MvPolynomial σ R) (p : σ → R) :
    tangentForm f p = 0 ↔ ∀ i : σ, eval p (pderiv i f) = 0 := by
  constructor
  · intro h i
    rw [← coeff_tangentForm f p i, h, coeff_zero]
  · intro h
    simp [tangentForm, h]

/-- Evaluating the tangent form is the dot product of the gradient at `p` with the new point. -/
@[simp]
theorem eval_tangentForm (f : MvPolynomial σ R) (p q : σ → R) :
    eval q (tangentForm f p) = ∑ i : σ, eval p (pderiv i f) * q i := by
  simp [tangentForm]

/-- The tangent form is linear in the point at which the resulting linear polynomial is
evaluated. -/
theorem eval_tangentForm_scale (f : MvPolynomial σ R) (p q : σ → R) (r : R) :
    eval (fun i ↦ r * q i) (tangentForm f p) =
      r * eval q (tangentForm f p) := by
  simp [eval_tangentForm, Finset.mul_sum, mul_assoc, mul_comm]

/-- A coordinate tangent form is homogeneous of degree one. -/
theorem tangentForm_isHomogeneous (f : MvPolynomial σ R) (p : σ → R) :
    (tangentForm f p).IsHomogeneous 1 := by
  apply (homogeneousSubmodule σ R 1).sum_mem
  intro i hi
  exact isHomogeneous_C_mul_X _ _

/-- Rescaling the base point of the tangent form of a degree-`d` homogeneous polynomial
multiplies the tangent form by the `(d - 1)`-st power of the scaling factor. -/
theorem tangentForm_smul_point {f : MvPolynomial σ R} {d : ℕ}
    (h : f.IsHomogeneous d) (r : R) (p : σ → R) :
    tangentForm f (r • p) = C (r ^ (d - 1)) * tangentForm f p := by
  rw [show r • p = fun i ↦ r * p i by ext i; simp]
  unfold tangentForm
  simp_rw [eval_smul_point_of_isHomogeneous h.pderiv]
  rw [Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro i hi
  simp [mul_assoc]

/-- In scalar-action notation, a tangent form is linear in the point where it is evaluated. -/
theorem eval_tangentForm_smul_target
    (f : MvPolynomial σ R) (p q : σ → R) (r : R) :
    eval (r • q) (tangentForm f p) = r * eval q (tangentForm f p) := by
  rw [show r • q = fun i ↦ r * q i by ext i; simp]
  simpa using
    eval_smul_point_of_isHomogeneous (tangentForm_isHomogeneous f p) r q

/-- Rescaling the base point by a unit does not change the zero locus of its tangent form. -/
theorem eval_tangentForm_smul_point_eq_zero_iff
    {f : MvPolynomial σ R} {d : ℕ}
    (h : f.IsHomogeneous d) (u : Rˣ) (p q : σ → R) :
    eval q (tangentForm f ((u : R) • p)) = 0 ↔
      eval q (tangentForm f p) = 0 := by
  rw [tangentForm_smul_point h, map_mul, eval_C]
  exact Units.mul_right_eq_zero (u ^ (d - 1))

/-- Euler's identity evaluated at `p`: the tangent form takes the value `d • f(p)` at `p` for a
homogeneous polynomial of degree `d`. -/
theorem eval_tangentForm_self {f : MvPolynomial σ R} {d : ℕ}
    (h : f.IsHomogeneous d) (p : σ → R) :
    eval p (tangentForm f p) = d • eval p f := by
  have hEuler := congrArg (eval p) h.sum_X_mul_pderiv
  simpa [mul_comm] using hEuler

/-- A point on a homogeneous hypersurface lies on its coordinate tangent hyperplane. -/
theorem eval_tangentForm_self_eq_zero {f : MvPolynomial σ R} {d : ℕ}
    (h : f.IsHomogeneous d) {p : σ → R} (hp : eval p f = 0) :
    eval p (tangentForm f p) = 0 := by
  rw [eval_tangentForm_self h, hp, nsmul_zero]

end

end BConicBundleMultisections
