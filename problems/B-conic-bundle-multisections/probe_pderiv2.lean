import BConicBundleMultisections.PlaneCubicResidualIdentity
import Mathlib.Algebra.MvPolynomial.PDeriv
import Mathlib.Tactic.Ring

open MvPolynomial Finsupp
open BConicBundleMultisections.PlaneCubicResidual

variable {R : Type*} [CommRing R]

private theorem eval_monomial_single_pow (a : R) (p : Fin 3 → R) (i : Fin 3) (n : ℕ) :
    eval p (monomial (single i n) a) = a * p i ^ n := by
  simp [eval_monomial, Finsupp.prod_single_index (pow_zero _)]

private theorem eval_monomial_two (a : R) (p : Fin 3 → R) (i j : Fin 3) (n m : ℕ) :
    eval p (monomial (single i n + single j m) a) = a * p i ^ n * p j ^ m := by
  classical
  rw [eval_monomial,
    prod_add_index' (fun x => pow_zero (p x)) (fun x n m => pow_add (p x) n m)]
  simp [prod_single_index (pow_zero _)]
  ring

example (a : R) (p : Fin 3 → R) (hp0 : p 0 = 1) :
    eval p (pderiv 0 (monomial eU3 a)) = 3 * a := by
  have he : eU3 = single 0 3 := rfl
  rw [he, pderiv_monomial_single, eval_monomial_single_pow]
  simp [hp0]; ring

example (a : R) (p : Fin 3 → R) (hp0 : p 0 = 1) :
    eval p (pderiv 0 (monomial eU2V a)) = 2 * a * p 1 := by
  simp only [eU2V, pderiv_monomial]
  have hsub : single (0 : Fin 3) 2 + single 1 1 - single 0 1 = single 0 1 + single 1 1 := by
    ext i; fin_cases i <;> simp [Finsupp.add_apply]
  have hcoe : (single (0 : Fin 3) 2 + single 1 1 : Fin 3 →₀ ℕ) 0 = 2 := by
    simp [Finsupp.add_apply]
  rw [hsub, hcoe, eval_monomial_two]
  simp [hp0]; ring

example (a : R) (p : Fin 3 → R) (hp0 : p 0 = 1) (hp2 : p 2 = 0) :
    eval p (pderiv 0 (monomial eU2W a)) = 0 := by
  simp only [eU2W, pderiv_monomial]
  have hsub : single (0 : Fin 3) 2 + single 2 1 - single 0 1 = single 0 1 + single 2 1 := by
    ext i; fin_cases i <;> simp [Finsupp.add_apply]
  have hcoe : (single (0 : Fin 3) 2 + single 2 1 : Fin 3 →₀ ℕ) 0 = 2 := by
    simp [Finsupp.add_apply]
  rw [hsub, hcoe, eval_monomial_two]
  simp [hp0, hp2]

example (a : R) (p : Fin 3 → R) :
    eval p (pderiv 0 (monomial eV3 a)) = 0 := by
  simp only [eV3, pderiv_monomial]
  -- eV3 0 = 0 so coeff is a * 0 = 0
  have hcoe : (single (1 : Fin 3) 3 : Fin 3 →₀ ℕ) 0 = 0 := by simp
  rw [hcoe]
  simp
