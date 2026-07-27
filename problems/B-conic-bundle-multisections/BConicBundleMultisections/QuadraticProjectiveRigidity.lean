/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.GoodLineCondition
public import Mathlib.Algebra.MvPolynomial.Funext
public import Mathlib.Algebra.CharZero.Infinite

/-!
# Projective rigidity for a family of ternary quadratics

If two nonzero homogeneous quadratics have proportional gradients in the projective sense

`p * ∂ᵢq = q * ∂ᵢp`,

then they are scalar multiples.  The proof is elementary and avoids fraction-field derivations.
Choose `z` with `p(z) ≠ 0`, pair the gradient identities with an arbitrary direction `x`, and
apply the resulting polar identity at `z + x` and `z - x`.  Their difference is
`4 * (p(z)q(x) - q(z)p(x))`, so characteristic zero gives proportionality at every point.
-/

@[expose] public section

namespace BConicBundleMultisections

noncomputable section

universe u

open _root_.MvPolynomial

variable {k : Type u} [Field k] [CharZero k]

/-- Projectively equal gradients force two ternary quadratic forms to be scalar multiples. -/
theorem eq_C_mul_of_mul_pderiv_eq_mul_pderiv
    (p q : MvPolynomial (Fin 3) k)
    (hp : p.IsHomogeneous 2) (hq : q.IsHomogeneous 2) (hp0 : p ≠ 0)
    (hwedge : ∀ i : Fin 3, p * pderiv i q = q * pderiv i p) :
    ∃ c : k, q = C c * p := by
  haveI : Infinite k := inferInstance
  have hex : ∃ z : Fin 3 → k, eval z p ≠ 0 := by
    by_contra h
    push Not at h
    exact hp0 (hp.eq_zero_of_forall_eval_eq_zero h)
  obtain ⟨z, hzp⟩ := hex
  have hpolar (n w : Fin 3 → k) :
      eval n p * polarEval q n w = eval n q * polarEval p n w := by
    rw [polarEval_eq_sum_pderiv hq, polarEval_eq_sum_pderiv hp,
      Finset.mul_sum, Finset.mul_sum]
    apply Finset.sum_congr rfl
    intro i _
    have hi := congrArg (eval n) (hwedge i)
    simp only [map_mul] at hi
    calc
      eval n p * (w i * eval n (pderiv i q)) =
          w i * (eval n p * eval n (pderiv i q)) := by ring
      _ = w i * (eval n q * eval n (pderiv i p)) := by rw [hi]
      _ = eval n q * (w i * eval n (pderiv i p)) := by ring
  have hpoint (x : Fin 3 → k) :
      eval z p * eval x q = eval z q * eval x p := by
    have hplus := hpolar (fun i => (1 : k) * z i + 1 * x i) x
    rw [eval_linComb_of_isHomogeneous_two p hp 1 1 z x,
      eval_linComb_of_isHomogeneous_two q hq 1 1 z x,
      polarEval_linear_left hp 1 1 z x x,
      polarEval_linear_left hq 1 1 z x x,
      polarEval_self hp, polarEval_self hq] at hplus
    have hminus := hpolar (fun i => (1 : k) * z i + (-1) * x i) x
    rw [eval_linComb_of_isHomogeneous_two p hp 1 (-1) z x,
      eval_linComb_of_isHomogeneous_two q hq 1 (-1) z x,
      polarEval_linear_left hp 1 (-1) z x x,
      polarEval_linear_left hq 1 (-1) z x x,
      polarEval_self hp, polarEval_self hq] at hminus
    linear_combination (1 / 4 : k) * hplus - (1 / 4 : k) * hminus
  refine ⟨eval z q / eval z p, ?_⟩
  apply MvPolynomial.funext
  intro x
  simp only [map_mul, eval_C]
  rw [div_mul_eq_mul_div, eq_div_iff hzp]
  linear_combination hpoint x

end

end BConicBundleMultisections
