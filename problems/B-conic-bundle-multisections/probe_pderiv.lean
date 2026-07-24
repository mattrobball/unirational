import BConicBundleMultisections.PlaneCubicResidualIdentity
import Mathlib.Algebra.MvPolynomial.PDeriv
import Mathlib.Tactic.Ring

open MvPolynomial Finsupp
open BConicBundleMultisections.PlaneCubicResidual

variable {R : Type*} [CommRing R]

example (a : R) (p : Fin 3 → R) (hp0 : p 0 = 1) :
    eval p (pderiv 0 (monomial eU3 a)) = 3 * a := by
  have he : eU3 = single 0 3 := rfl
  rw [he, pderiv_monomial_single]
  -- monomial (single 0 2) (a * 3)
  simp only [eval_monomial, Finsupp.prod_single_index (pow_zero _)]
  simp [hp0]
  ring

example (a : R) (p : Fin 3 → R) (hp0 : p 0 = 1) :
    eval p (monomial (single (0 : Fin 3) 1 + single 1 1) a) = a * p 0 * p 1 := by
  classical
  rw [eval_monomial]
  -- prod over support
  have hsup : (single (0 : Fin 3) 1 + single 1 1).support = {0, 1} := by
    ext i; simp [Finsupp.mem_support_iff, Finsupp.add_apply, single_apply]
    fin_cases i <;> simp
  -- Use prod_add_index
  rw [prod_add_index' (fun x => pow_zero (p x)) (fun x n m => pow_add (p x) n m)]
  simp [prod_single_index (pow_zero _), hp0]
  ring

example (a : R) (p : Fin 3 → R) (hp0 : p 0 = 1) :
    eval p (pderiv 0 (monomial eU2V a)) = 2 * a * p 1 := by
  simp only [eU2V, pderiv_monomial]
  have hsub : (single (0 : Fin 3) 2 + single 1 1 - single 0 1) = single 0 1 + single 1 1 := by
    ext i; fin_cases i <;> simp [Finsupp.add_apply]
  have hcoe : ((single (0 : Fin 3) 2 + single 1 1 : Fin 3 →₀ ℕ) 0) = 2 := by
    simp [Finsupp.add_apply]
  rw [hsub, hcoe]
  -- a * 2 as coeff
  change eval p (monomial (single 0 1 + single 1 1) (a * 2)) = 2 * a * p 1
  rw [eval_monomial, prod_add_index' (fun x => pow_zero (p x)) (fun x n m => pow_add (p x) n m)]
  simp [prod_single_index (pow_zero _), hp0]
  ring
