/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.BinaryCubicResidual
public import Mathlib.RingTheory.MvPolynomial.Homogeneous
public import Mathlib.LinearAlgebra.Matrix.NonsingularInverse

/-!
# Linear substitution of the variables of a polynomial

A matrix `M` acts on `MvPolynomial (Fin (n+1)) R` by substituting the linear form
`∑ l, M j l · X l` for each variable `X j`.  On values this is precomposition with `x ↦ M *ᵥ x`.

This is the polynomial half of `LinearCoordinateChange.lean`, split off so that results needing only
substitution do not depend on `Proj` and the graded machinery.  `LinearCoordinateChange` builds on
this to produce the induced automorphism of `ℙⁿ`.

The application is the multisection line: the source proof chooses `L` and only normalises it to
`{W = 0}` afterwards, and carrying a plane cubic into that frame is a substitution of exactly this
kind.  See `PlaneCubicResidualEquivariance` for why it suffices to transport the cubic rather than
the ambient scheme.
-/

@[expose] public section

namespace BConicBundleMultisections

noncomputable section

universe u

open MvPolynomial
open scoped Matrix

variable {R : Type u} [CommRing R]

/-- The linear forms substituted for the variables. -/
def linearSubst (n : ℕ) (M : Matrix (Fin (n + 1)) (Fin (n + 1)) R) :
    Fin (n + 1) → MvPolynomial (Fin (n + 1)) R :=
  fun j => ∑ l : Fin (n + 1), C (M j l) * X l

/-- Each substituted form is homogeneous of degree one. -/
theorem isHomogeneous_linearSubst (n : ℕ) (M : Matrix (Fin (n + 1)) (Fin (n + 1)) R)
    (j : Fin (n + 1)) : (linearSubst n M j).IsHomogeneous 1 := by
  refine IsHomogeneous.sum _ _ _ fun l _ => ?_
  simpa using (isHomogeneous_C _ (M j l)).mul (isHomogeneous_X _ l)

/-- Substituting by the identity matrix is the identity substitution. -/
@[simp]
theorem linearSubst_one (n : ℕ) :
    linearSubst n (1 : Matrix (Fin (n + 1)) (Fin (n + 1)) R) = X := by
  funext j
  simp [linearSubst, Matrix.one_apply]

/-- Evaluating a substituted variable applies the matrix to the point. -/
@[simp]
theorem eval_linearSubst (n : ℕ) (M : Matrix (Fin (n + 1)) (Fin (n + 1)) R)
    (x : Fin (n + 1) → R) (j : Fin (n + 1)) :
    eval x (linearSubst n M j) = (M *ᵥ x) j := by
  simp [linearSubst, Matrix.mulVec, dotProduct]

/-- **Substitution is precomposition with the matrix.**  This is the defining property: the
substituted polynomial takes at `x` the value the original takes at `M *ᵥ x`. -/
theorem eval_aeval_linearSubst (n : ℕ) (M : Matrix (Fin (n + 1)) (Fin (n + 1)) R)
    (G : MvPolynomial (Fin (n + 1)) R) (x : Fin (n + 1) → R) :
    eval x ((aeval (linearSubst n M) : MvPolynomial (Fin (n + 1)) R →ₐ[R] _) G)
      = eval (M *ᵥ x) G := by
  have hstep : eval x ((aeval (linearSubst n M) : MvPolynomial (Fin (n + 1)) R →ₐ[R] _) G)
      = eval (fun j => eval x (linearSubst n M j)) G := by
    induction G using MvPolynomial.induction_on with
    | C a => simp
    | add p q hp hq => simp [hp, hq]
    | mul_X p j hp => simp [hp]
  rw [hstep]
  exact congrArg (fun y => eval y G) (funext fun j => eval_linearSubst n M x j)

/-- Substituting linear forms preserves the degree of a homogeneous polynomial. -/
theorem isHomogeneous_aeval_linearSubst {n d : ℕ} (M : Matrix (Fin (n + 1)) (Fin (n + 1)) R)
    {G : MvPolynomial (Fin (n + 1)) R} (hG : G.IsHomogeneous d) :
    ((aeval (linearSubst n M) : MvPolynomial (Fin (n + 1)) R →ₐ[R] _) G).IsHomogeneous d := by
  simpa using hG.aeval (linearSubst n M) (isHomogeneous_linearSubst n M)

/-! ### Restriction to a line commutes with substitution -/

/-- **Restricting the substituted polynomial to a line is restricting the original to the image
line.**

Both sides send the binary point `(s, t)` to the value of `G` at `M *ᵥ (s·p + t·q)`.  This is what
lets the residual construction be run in a frame where the multisection line is `{W = 0}`: restrict
there, and the answer is the restriction along the original line. -/
theorem binaryLineRestriction_aeval_linearSubst (n : ℕ)
    (M : Matrix (Fin (n + 1)) (Fin (n + 1)) R) (p q : Fin (n + 1) → R)
    (G : MvPolynomial (Fin (n + 1)) R) :
    binaryLineRestriction p q
        ((aeval (linearSubst n M) : MvPolynomial (Fin (n + 1)) R →ₐ[R] _) G)
      = binaryLineRestriction (M *ᵥ p) (M *ᵥ q) G := by
  classical
  have hvar : ∀ j : Fin (n + 1),
      binaryLineRestriction p q (linearSubst n M j)
        = C ((M *ᵥ p) j) * X 0 + C ((M *ᵥ q) j) * X 1 := by
    intro j
    simp only [linearSubst, map_sum, map_mul, binaryLineRestriction_C, binaryLineRestriction_X,
      Matrix.mulVec, dotProduct, map_sum]
    simp only [mul_add, ← mul_assoc, Finset.sum_add_distrib, ← Finset.sum_mul]
  suffices h : (binaryLineRestriction p q).comp
      (aeval (linearSubst n M) : MvPolynomial (Fin (n + 1)) R →ₐ[R] _)
      = binaryLineRestriction (M *ᵥ p) (M *ᵥ q) from DFunLike.congr_fun h G
  refine MvPolynomial.algHom_ext fun j => ?_
  simpa using hvar j

/-- Substituting one linear change into another composes the matrices. -/
theorem aeval_linearSubst_linearSubst (n : ℕ) (M N : Matrix (Fin (n + 1)) (Fin (n + 1)) R)
    (i : Fin (n + 1)) :
    (aeval (linearSubst n M) : MvPolynomial (Fin (n + 1)) R →ₐ[R] _) (linearSubst n N i)
      = linearSubst n (N * M) i := by
  classical
  simp only [linearSubst, map_sum, map_mul, aeval_C, aeval_X, Finset.mul_sum,
    MvPolynomial.algebraMap_eq]
  rw [Finset.sum_comm]
  refine Finset.sum_congr rfl fun l _ => ?_
  rw [Matrix.mul_apply, map_sum, Finset.sum_mul]
  exact Finset.sum_congr rfl fun x _ => by rw [← mul_assoc, ← C_mul]

/-- The image of the linear form built from a left inverse of `M` is the variable `X i`. -/
theorem aeval_linearSubst_inverse_row (n : ℕ) (M N : Matrix (Fin (n + 1)) (Fin (n + 1)) R)
    (h : N * M = 1) (i : Fin (n + 1)) :
    (aeval (linearSubst n M) : MvPolynomial (Fin (n + 1)) R →ₐ[R] _)
        (∑ j : Fin (n + 1), C (N i j) * X j) = X i := by
  classical
  have step1 : (aeval (linearSubst n M) : MvPolynomial (Fin (n + 1)) R →ₐ[R] _)
      (∑ j : Fin (n + 1), C (N i j) * X j)
      = ∑ l : Fin (n + 1), C ((N * M) i l) * X l := by
    simp only [map_sum, map_mul, aeval_C, aeval_X, linearSubst, Finset.mul_sum,
      MvPolynomial.algebraMap_eq]
    rw [Finset.sum_comm]
    refine Finset.sum_congr rfl fun l _ => ?_
    rw [Matrix.mul_apply, map_sum, Finset.sum_mul]
    exact Finset.sum_congr rfl fun x _ => by rw [← mul_assoc, ← C_mul]
  rw [step1, h]
  simp [Matrix.one_apply]

end

end BConicBundleMultisections
