/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.AlgebraicIndependenceJacobian
public import BConicBundleMultisections.HomogeneousQuadraticEval

/-!
# The gradient of a ternary quadratic is its polar form

`polarEval Q p w = Q(p + w) − Q(p) − Q(w)` is the polar of a ternary quadratic.  This module proves
the identity that makes it the *gradient*:

```
polarEval Q n w = ∑ i, w i * (∂Q/∂xᵢ)(n) ,
```

and in particular `(∂Q/∂xᵢ)(n) = polarEval Q n eᵢ`.  `HomogeneousQuadraticEval` has the value
formula `eval_eq_ternaryQuadraticCoeff_sum` and the polar formula `polarEval_eq_coeff_sum`, but no
gradient formula; this is the quadric analogue of `PlaneCubicPartials`, and it is what identifies a
kernel vector of the polar matrix with a *singular point* of the conic.

Nothing beyond a commutative ring is used, so the statements are upstreamable as they stand.

## The proof

Substituting `xⱼ ↦ C nⱼ + C wⱼ · X` into `Q` gives, by the two coefficient formulas, the univariate
quadratic

```
Q(n) + polarEval Q n w · X + Q(w) · X² ,
```

whose derivative at `X = 0` is `polarEval Q n w`.  By the multivariate chain rule `pderiv_aeval` of
`AlgebraicIndependenceJacobian.lean` that same derivative is `∑ i, wᵢ · (∂Q/∂xᵢ)(n)`.  So no case
analysis on monomials is needed: the coefficient formulas do the work.
-/

@[expose] public section

namespace BConicBundleMultisections

noncomputable section

universe u

open MvPolynomial

variable {R : Type u} [CommRing R]

/-- Evaluating a substituted polynomial is evaluating at the evaluated substitutions. -/
private theorem eval_aeval_finOne (Y : Fin 3 → MvPolynomial (Fin 1) R) (x : Fin 1 → R)
    (p : MvPolynomial (Fin 3) R) :
    eval x ((aeval Y : MvPolynomial (Fin 3) R →ₐ[R] _) p)
      = eval (fun j => eval x (Y j)) p := by
  induction p using MvPolynomial.induction_on with
  | C a => simp
  | add p q hp hq => simp [hp, hq]
  | mul_X p j hp => simp [hp]

/-- A change of coefficient ring acts on the upper-triangular quadratic coefficients. -/
private theorem ternaryQuadraticCoeff_map' {S : Type u} [CommRing S] (φ : R →+* S)
    (f : MvPolynomial (Fin 3) R) (i j : Fin 3) :
    ternaryQuadraticCoeff (map φ f) i j = φ (ternaryQuadraticCoeff f i j) := by
  simp only [ternaryQuadraticCoeff, coeff_map]
  split_ifs <;> simp

/-- **The polar form is the gradient paired with the direction.** -/
theorem polarEval_eq_sum_pderiv {Q : MvPolynomial (Fin 3) R} (hQ : Q.IsHomogeneous 2)
    (n w : Fin 3 → R) :
    polarEval Q n w = ∑ i : Fin 3, w i * eval n (pderiv i Q) := by
  classical
  set Y : Fin 3 → MvPolynomial (Fin 1) R := fun j => C (n j) + C (w j) * X 0 with hY
  set A := (aeval Y : MvPolynomial (Fin 3) R →ₐ[R] MvPolynomial (Fin 1) R) with hA
  -- the substituted polynomial is an explicit univariate quadratic
  have hsub : A Q = C (eval n Q) + C (polarEval Q n w) * X 0 + C (eval w Q) * X 0 ^ 2 := by
    have hae : A Q = eval Y (map (C : R →+* MvPolynomial (Fin 1) R) Q) := by
      rw [eval_map]
      rfl
    rw [hae, eval_eq_ternaryQuadraticCoeff_sum (hQ.map _)]
    simp only [ternaryQuadraticCoeff_map', hY]
    rw [eval_eq_ternaryQuadraticCoeff_sum hQ n, eval_eq_ternaryQuadraticCoeff_sum hQ w,
      polarEval_eq_coeff_sum Q hQ]
    simp only [Fin.sum_univ_three, map_add, map_mul, C_add, C_mul]
    ring
  -- the chain rule for the same substitution
  have hchain : pderiv 0 (A Q) = ∑ a : Fin 3, A (pderiv a Q) * C (w a) := by
    rw [hA, pderiv_aeval Y 0 Q]
    refine Finset.sum_congr rfl fun a _ => ?_
    congr 1
    rw [hY]
    simp
  -- evaluating the substitution at `X = 0` returns to the point `n`
  have h0 : ∀ p : MvPolynomial (Fin 3) R,
      eval (fun _ : Fin 1 => (0 : R)) (A p) = eval n p := by
    have hpt : (fun j => eval (fun _ : Fin 1 => (0 : R)) (Y j)) = n := by
      funext j
      simp [hY]
    intro p
    rw [hA, eval_aeval_finOne, hpt]
  have hL : eval (fun _ : Fin 1 => (0 : R)) (pderiv 0 (A Q)) = polarEval Q n w := by
    rw [hsub]
    simp
  have hR : eval (fun _ : Fin 1 => (0 : R)) (∑ a : Fin 3, A (pderiv a Q) * C (w a))
      = ∑ a : Fin 3, eval n (pderiv a Q) * w a := by
    rw [map_sum]
    exact Finset.sum_congr rfl fun a _ => by rw [map_mul, h0, eval_C]
  rw [← hL, hchain, hR]
  exact Finset.sum_congr rfl fun a _ => mul_comm _ _

/-- **The gradient of a ternary quadratic**: the `i`-th partial derivative at `n` is the polar form
against the `i`-th basis vector. -/
theorem eval_pderiv_eq_polarEval_single {Q : MvPolynomial (Fin 3) R} (hQ : Q.IsHomogeneous 2)
    (n : Fin 3 → R) (i : Fin 3) :
    eval n (pderiv i Q) = polarEval Q n (Pi.single i 1) := by
  classical
  rw [polarEval_eq_sum_pderiv hQ]
  rw [Finset.sum_eq_single i (fun b _ hb => by simp [Pi.single_apply, hb]) (by simp)]
  simp

end

end BConicBundleMultisections
