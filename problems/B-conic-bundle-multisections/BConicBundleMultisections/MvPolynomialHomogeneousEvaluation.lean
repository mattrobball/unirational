/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import Mathlib.RingTheory.MvPolynomial.Homogeneous

/-!
# Evaluation of homogeneous multivariate polynomials under scaling

This file isolates the generic scaling identity for evaluating a homogeneous multivariate
polynomial.  It is used both by projective tangent constructions and by normalization of
homogeneous coordinate representatives.
-/

@[expose] public section

namespace BConicBundleMultisections

noncomputable section

universe u

open _root_.MvPolynomial

variable {σ : Type*} {R : Type u} [CommSemiring R]

/-- Evaluating a homogeneous polynomial at a uniformly rescaled point multiplies its value by
the corresponding power of the scaling factor. -/
theorem eval_smul_point_of_isHomogeneous {f : MvPolynomial σ R} {d : ℕ}
    (h : f.IsHomogeneous d) (r : R) (p : σ → R) :
    eval (fun i ↦ r * p i) f = r ^ d * eval p f := by
  induction h using IsWeightedHomogeneous.induction_on with
  | zero => simp
  | add f g hf hg ihf ihg => simp [ihf, ihg, mul_add]
  | monomial s a hs =>
      rw [eval_monomial, eval_monomial]
      simp_rw [mul_pow]
      rw [Finsupp.prod, Finset.prod_mul_distrib, Finset.prod_pow_eq_pow_sum]
      have hs' : s.degree = d := by
        rw [Finsupp.degree_eq_weight_one]
        exact hs
      rw [show ∑ x ∈ s.support, s x = d by exact hs']
      simp only [Finsupp.prod]
      ac_rfl

end

end BConicBundleMultisections
