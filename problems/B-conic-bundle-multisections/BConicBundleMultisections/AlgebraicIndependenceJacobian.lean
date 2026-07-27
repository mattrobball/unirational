/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import Mathlib.RingTheory.MvPolynomial.EulerIdentity
public import Mathlib.LinearAlgebra.Matrix.Adjugate

/-!
# A Jacobian criterion for homogeneous relations

Three polynomials `Y₀, Y₁, Y₂` in two variables satisfy no nonzero homogeneous relation as soon as
one explicit `3 × 3` determinant is nonzero: the one whose rows are `Y` and its two partial
derivatives.

This is the concrete content of *horizontality* in `PLAN.md` WP-1.  The statement there — no nonzero
form vanishes on the residual `Y`-coordinates — is equivalent to algebraic independence of the two
ratios `Y_a / Y_j` in `k(t, s)`, and the classical criterion for that is a Jacobian.  Mathlib has no
Jacobian criterion for algebraic independence, so this file supplies the direction that is needed,
in homogeneous form, where it is short.

## The argument

If `Ψ` is homogeneous of degree `d` and vanishes on `Y`, then the vector
`v_a = Ψ_a(Y)` of evaluated partials is killed by three linear relations:

* Euler's identity `∑ a, X a * pderiv a Ψ = d • Ψ` evaluated at `Y` gives `∑ a, Y a * v a = 0`;
* differentiating `Ψ(Y) = 0` in each of the two variables gives `∑ a, v a * ∂(Y a) = 0`.

So `M *ᵥ v = 0` for the matrix `M` of the statement, and a nonzero determinant forces `v = 0` over a
domain.  Then every `pderiv a Ψ` vanishes on `Y` and is homogeneous of degree `d - 1`, so induction
gives `pderiv a Ψ = 0` for all `a`; Euler's identity again turns that into `d • Ψ = 0`, and
characteristic zero finishes it.

Characteristic zero is essential and enters exactly once, at that last step: in characteristic `p` a
`p`-th power has all partials zero without being constant.
-/

@[expose] public section

namespace BConicBundleMultisections

open MvPolynomial
open scoped Matrix

universe u v

variable {k : Type u} [CommRing k] {τ : Type v} [Fintype τ] [DecidableEq τ]

/-- **Chain rule**: differentiating a substituted polynomial.

`pderiv i (Ψ(Y)) = ∑ a, (∂Ψ/∂X_a)(Y) · ∂(Y_a)/∂i`.  Mathlib has this for univariate polynomials
(`Derivation.apply_aeval_eq`) but not in this multivariate form. -/
theorem pderiv_aeval {σ : Type*} [Fintype σ] [DecidableEq σ]
    (Y : σ → MvPolynomial τ k) (i : τ) (Ψ : MvPolynomial σ k) :
    pderiv i (aeval Y Ψ) = ∑ a : σ, aeval Y (pderiv a Ψ) * pderiv i (Y a) := by
  classical
  induction Ψ using MvPolynomial.induction_on with
  | C c => simp
  | add p q hp hq =>
      simp only [map_add, hp, hq, ← Finset.sum_add_distrib]
      exact Finset.sum_congr rfl fun a _ => by ring
  | mul_X p b hp =>
      have hleib : pderiv i (aeval Y (p * X b))
          = pderiv i (aeval Y p) * Y b + aeval Y p * pderiv i (Y b) := by
        simp [map_mul, mul_comm]
      rw [hleib, hp]
      symm
      calc ∑ a : σ, aeval Y (pderiv a (p * X b)) * pderiv i (Y a)
          = ∑ a : σ, (aeval Y (pderiv a p) * pderiv i (Y a) * Y b
              + (if a = b then aeval Y p * pderiv i (Y b) else 0)) := by
            refine Finset.sum_congr rfl fun a _ => ?_
            by_cases hab : a = b
            · subst hab; simp [Pi.single_apply]; ring
            · simp [Pi.single_apply, hab, Ne.symm hab]
              ring
        _ = (∑ a : σ, aeval Y (pderiv a p) * pderiv i (Y a)) * Y b
              + aeval Y p * pderiv i (Y b) := by
            rw [Finset.sum_add_distrib, Finset.sum_mul]
            simp

/-- **A nonzero Jacobian determinant rules out homogeneous relations.**

If the three rows `Y`, `∂Y/∂i₁`, `∂Y/∂i₂` are linearly independent — witnessed by a nonzero
determinant — then no nonzero homogeneous form vanishes on `Y`. -/
theorem eq_zero_of_isHomogeneous_of_aeval_eq_zero
    [IsDomain k] [NeZero (2 : k)] [NeZero (3 : k)]
    (Y : Fin 3 → MvPolynomial τ k) (i₁ i₂ : τ)
    (hdet : (Matrix.of ![Y, fun a => pderiv i₁ (Y a), fun a => pderiv i₂ (Y a)]).det ≠ 0)
    (d : ℕ) (Ψ : MvPolynomial (Fin 3) k) (hΨ : Ψ.IsHomogeneous d)
    (hvan : aeval Y Ψ = 0) : Ψ = 0 := by
  classical
  induction d using Nat.strong_induction_on generalizing Ψ with
  | _ d ih =>
    set M := Matrix.of ![Y, fun a => pderiv i₁ (Y a), fun a => pderiv i₂ (Y a)] with hM
    set v : Fin 3 → MvPolynomial τ k := fun a => aeval Y (pderiv a Ψ) with hv
    -- The three relations satisfied by the evaluated partials.
    have hrow0 : ∑ a : Fin 3, Y a * v a = 0 := by
      have := congrArg (aeval Y) hΨ.sum_X_mul_pderiv
      simpa [hv, hvan, map_sum, nsmul_eq_mul] using this
    have hrow1 : ∑ a : Fin 3, pderiv i₁ (Y a) * v a = 0 := by
      have h := pderiv_aeval Y i₁ Ψ
      rw [hvan, map_zero] at h
      rw [show (∑ a : Fin 3, pderiv i₁ (Y a) * v a)
          = ∑ a : Fin 3, v a * pderiv i₁ (Y a) from
        Finset.sum_congr rfl fun a _ => mul_comm _ _]
      exact h.symm
    have hrow2 : ∑ a : Fin 3, pderiv i₂ (Y a) * v a = 0 := by
      have h := pderiv_aeval Y i₂ Ψ
      rw [hvan, map_zero] at h
      rw [show (∑ a : Fin 3, pderiv i₂ (Y a) * v a)
          = ∑ a : Fin 3, v a * pderiv i₂ (Y a) from
        Finset.sum_congr rfl fun a _ => mul_comm _ _]
      exact h.symm
    have hMv : M *ᵥ v = 0 := by
      funext r
      fin_cases r <;>
        simp only [hM, Matrix.mulVec, dotProduct, Matrix.of_apply, Matrix.cons_val_zero,
          Matrix.cons_val_one, Matrix.head_cons, Matrix.cons_val_two, Matrix.tail_cons,
          Pi.zero_apply]
      · exact hrow0
      · exact hrow1
      · exact hrow2
    -- A nonzero determinant kills `v`.
    have hvzero : v = 0 := by
      have hadj : (M.det) • v = 0 := by
        have h := congrArg (fun w => M.adjugate *ᵥ w) hMv
        simp only [Matrix.mulVec_mulVec, Matrix.adjugate_mul, Matrix.mulVec_zero] at h
        rwa [Matrix.smul_mulVec, Matrix.one_mulVec] at h
      funext a
      have := congrFun hadj a
      simp only [Pi.smul_apply, Pi.zero_apply, smul_eq_mul] at this
      exact (mul_eq_zero.mp this).resolve_left hdet
    rcases Nat.eq_zero_or_pos d with hd | hd
    · -- Degree zero: `Ψ` is a constant, and it evaluates to zero.
      subst hd
      rw [← totalDegree_zero_iff_isHomogeneous, totalDegree_eq_zero_iff_eq_C] at hΨ
      rw [hΨ] at hvan ⊢
      simpa using hvan
    · -- Every partial vanishes on `Y` and has degree `d - 1`, so induction kills it.
      have hpart : ∀ a : Fin 3, pderiv a Ψ = 0 := fun a =>
        ih (d - 1) (by omega) _ hΨ.pderiv (congrFun hvzero a)
      -- Euler's identity turns that into `d • Ψ = 0`.
      have h := hΨ.sum_X_mul_pderiv
      simp only [hpart, mul_zero, Finset.sum_const_zero] at h
      have hcast : (d : MvPolynomial (Fin 3) k) ≠ 0 := Nat.cast_ne_zero.mpr (by omega)
      rw [nsmul_eq_mul] at h
      exact (mul_eq_zero.mp h.symm).resolve_left hcast

end BConicBundleMultisections
