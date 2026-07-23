/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.ProjectiveTangentHyperplane

/-!
# Restricting homogeneous polynomials to projective lines

This file substitutes the binary linear combination `s • p + t • q` into a multivariate
polynomial. It records preservation of homogeneous degree, evaluation at the two endpoints,
and the first-order tangent-contact identity at `[1 : 0]`.
-/

@[expose] public section

open MvPolynomial

namespace BConicBundleMultisections

noncomputable section

universe u v

variable {σ : Type v} {R : Type u} [CommSemiring R]

/-- The restriction of a multivariate polynomial to the two-dimensional linear span of
`p` and `q`. The binary coordinates `(s,t)` represent the point `s • p + t • q`. -/
def binaryLineRestriction (p q : σ → R) :
    MvPolynomial σ R →ₐ[R] MvPolynomial (Fin 2) R :=
  aeval fun i ↦ C (p i) * X 0 + C (q i) * X 1

/-- Restriction to a line preserves constants. -/
theorem binaryLineRestriction_C (r : R) (p q : σ → R) :
    binaryLineRestriction p q (C r) = C r := by
  simp [binaryLineRestriction]

/-- A source coordinate restricts to the corresponding binary linear form. -/
@[simp]
theorem binaryLineRestriction_X (i : σ) (p q : σ → R) :
    binaryLineRestriction p q (X i) = C (p i) * X 0 + C (q i) * X 1 := by
  simp [binaryLineRestriction]

/-- Restriction to a line preserves the homogeneous degree. -/
theorem binaryLineRestriction_isHomogeneous {f : MvPolynomial σ R} {d : ℕ}
    (hf : f.IsHomogeneous d) (p q : σ → R) :
    (binaryLineRestriction p q f).IsHomogeneous d := by
  unfold binaryLineRestriction
  simpa only [one_mul] using hf.aeval
    (fun i ↦ C (p i) * X (0 : Fin 2) + C (q i) * X (1 : Fin 2))
    (fun i ↦ (isHomogeneous_C_mul_X (p i) (0 : Fin 2)).add
      (isHomogeneous_C_mul_X (q i) (1 : Fin 2)))

/-- The binary coordinate point `[1 : 0]`. -/
def binaryFirstEndpoint : Fin 2 → R := ![1, 0]

/-- The binary coordinate point `[0 : 1]`. -/
def binarySecondEndpoint : Fin 2 → R := ![0, 1]

/-- Evaluation of a binary line restriction substitutes the corresponding linear
combination of `p` and `q`. -/
theorem eval_binaryLineRestriction (x : Fin 2 → R) (f : MvPolynomial σ R)
    (p q : σ → R) :
    eval x (binaryLineRestriction p q f) =
      eval (fun i ↦ p i * x 0 + q i * x 1) f := by
  unfold binaryLineRestriction
  change eval x (eval₂ C (fun i ↦ C (p i) * X 0 + C (q i) * X 1) f) = _
  rw [eval_eval₂]
  rw [show (eval x).comp C = RingHom.id R by
    ext r
    simp]
  calc
    eval₂ (RingHom.id R)
        (fun i ↦ eval x (C (p i) * X 0 + C (q i) * X 1)) f =
        eval₂ (RingHom.id R) (fun i ↦ p i * x 0 + q i * x 1) f := by
          apply eval₂_congr
          intro i c hi hc
          simp
    _ = eval (fun i ↦ p i * x 0 + q i * x 1) f := eval₂_id f

/-- At `[1 : 0]`, the binary line restriction evaluates at `p`. -/
@[simp]
theorem eval_binaryLineRestriction_first (f : MvPolynomial σ R) (p q : σ → R) :
    eval (binaryFirstEndpoint (R := R)) (binaryLineRestriction p q f) = eval p f := by
  rw [eval_binaryLineRestriction]
  rw [show (fun i ↦ p i * binaryFirstEndpoint (R := R) 0 +
      q i * binaryFirstEndpoint (R := R) 1) = p by
    funext i
    simp [binaryFirstEndpoint]]

/-- At `[0 : 1]`, the binary line restriction evaluates at `q`. -/
@[simp]
theorem eval_binaryLineRestriction_second (f : MvPolynomial σ R) (p q : σ → R) :
    eval (binarySecondEndpoint (R := R)) (binaryLineRestriction p q f) = eval q f := by
  rw [eval_binaryLineRestriction]
  rw [show (fun i ↦ p i * binarySecondEndpoint (R := R) 0 +
      q i * binarySecondEndpoint (R := R) 1) = q by
    funext i
    simp [binarySecondEndpoint]]

variable [Fintype σ]

/-- Differentiating in the second binary coordinate and evaluating at `[1 : 0]`
computes the directional derivative of `f` at `p` in the direction `q`. -/
theorem eval_pderiv_one_binaryLineRestriction_first
    (f : MvPolynomial σ R) (p q : σ → R) :
    eval (binaryFirstEndpoint (R := R))
        (pderiv (1 : Fin 2) (binaryLineRestriction p q f)) =
      eval q (tangentForm f p) := by
  classical
  induction f using MvPolynomial.induction_on with
  | C a => simp [binaryLineRestriction, tangentForm]
  | add f g hf hg => simp [tangentForm_add, hf, hg]
  | mul_X f i hf =>
      have hX : tangentForm (X i) p = X i := by
        unfold tangentForm
        rw [Finset.sum_eq_single i]
        · simp
        · intro x hx hxi
          simp [Ne.symm hxi]
        · simp
      rw [map_mul, binaryLineRestriction_X,
        tangentForm_mul f (X i) p, hX]
      simp only [Derivation.leibniz, smul_eq_mul, map_add, map_mul, pderiv_X,
        Pi.single_apply, Fin.isValue, ↓reduceIte, mul_one,
        eval_C, eval_X, binaryFirstEndpoint, Matrix.cons_val_one,
        Matrix.cons_val_zero, mul_zero, add_zero]
      have hval : eval ![1, 0] (binaryLineRestriction p q f) = eval p f := by
        simpa [binaryFirstEndpoint] using eval_binaryLineRestriction_first f p q
      have hderiv : eval ![1, 0]
          (pderiv (1 : Fin 2) (binaryLineRestriction p q f)) =
          eval q (tangentForm f p) := by
        simpa [binaryFirstEndpoint] using hf
      rw [hval, hderiv, eval_tangentForm]
      simp [mul_comm]

/-- If `p` lies on `f` and `q` lies in the coordinate tangent hyperplane at `p`, then the
binary restriction has vanishing value and vanishing first derivative at `[1 : 0]`. -/
theorem binaryLineRestriction_double_contact_first
    (f : MvPolynomial σ R) (p q : σ → R)
    (hp : eval p f = 0) (hq : q ∈ tangentHyperplaneCone f p) :
    eval (binaryFirstEndpoint (R := R)) (binaryLineRestriction p q f) = 0 ∧
      eval (binaryFirstEndpoint (R := R))
        (pderiv (1 : Fin 2) (binaryLineRestriction p q f)) = 0 := by
  constructor
  · simpa using hp
  · rw [eval_pderiv_one_binaryLineRestriction_first]
    exact hq

end

end BConicBundleMultisections
