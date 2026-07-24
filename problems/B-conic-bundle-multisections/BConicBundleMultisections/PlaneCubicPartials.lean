/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.PlaneCubicResidualIdentity
public import Mathlib.Algebra.MvPolynomial.PDeriv
public import Mathlib.Tactic.Ring

/-!
# Partials of a homogeneous plane cubic at a general point

Explicit formulas for `∂G/∂U` and `∂G/∂V` of a degree-3 homogeneous plane cubic.
-/

@[expose] public section

open MvPolynomial
open Finsupp

namespace BConicBundleMultisections
namespace PlaneCubicResidual

variable {R : Type*} [CommRing R]

private theorem eval_monomial_single_pow (a : R) (p : Fin 3 → R) (i : Fin 3) (n : ℕ) :
    eval p (monomial (single i n) a) = a * p i ^ n := by
  simp [eval_monomial]

private theorem eval_monomial_two (a : R) (p : Fin 3 → R) (i j : Fin 3) (n m : ℕ) :
    eval p (monomial (single i n + single j m) a) = a * p i ^ n * p j ^ m := by
  classical
  rw [eval_monomial,
    prod_add_index' (fun x => pow_zero (p x)) (fun x n m => pow_add (p x) n m)]
  simp
  ring

private theorem eval_monomial_three (a : R) (p : Fin 3 → R) :
    eval p (monomial (single (0 : Fin 3) 1 + single 1 1 + single 2 1) a) =
      a * p 0 * p 1 * p 2 := by
  classical
  rw [eval_monomial,
    prod_add_index' (fun x => pow_zero (p x)) (fun x n m => pow_add (p x) n m),
    prod_add_index' (fun x => pow_zero (p x)) (fun x n m => pow_add (p x) n m)]
  simp
  ring

/-- `∂G/∂U` of a homogeneous plane cubic at a general point. -/
theorem eval_pderiv0_planeCubic
    (G : MvPolynomial (Fin 3) R) (hG : G.IsHomogeneous 3) (q : Fin 3 → R) :
    eval q (pderiv 0 G) =
      3 * coeffU3 G * q 0 ^ 2 + 2 * coeffU2V G * q 0 * q 1 + coeffUV2 G * q 1 ^ 2 +
        q 2 * (2 * coeffU2W G * q 0 + coeffUVW G * q 1) + q 2 ^ 2 * coeffUW2 G := by
  have hsum := planeCubic_eq_sum_monomials G hG
  conv_lhs => rw [hsum]
  simp only [map_add]
  have hU3 : eval q (pderiv 0 (monomial eU3 (coeffU3 G))) = 3 * coeffU3 G * q 0 ^ 2 := by
    rw [show eU3 = single (0 : Fin 3) 3 from rfl, pderiv_monomial_single,
      eval_monomial_single_pow]
    ring
  have hU2V : eval q (pderiv 0 (monomial eU2V (coeffU2V G))) =
      2 * coeffU2V G * q 0 * q 1 := by
    simp only [eU2V, pderiv_monomial]
    have hsub : single (0 : Fin 3) 2 + single 1 1 - single 0 1 =
        single 0 1 + single 1 1 := by
      ext i; fin_cases i <;> simp [Finsupp.add_apply]
    have hcoe : (single (0 : Fin 3) 2 + single 1 1 : Fin 3 →₀ ℕ) 0 = 2 := by
      simp [Finsupp.add_apply]
    rw [hsub, hcoe, eval_monomial_two]; ring
  have hUV2 : eval q (pderiv 0 (monomial eUV2 (coeffUV2 G))) =
      coeffUV2 G * q 1 ^ 2 := by
    simp only [eUV2, pderiv_monomial]
    have hsub : single (0 : Fin 3) 1 + single 1 2 - single 0 1 = single 1 2 := by
      ext i; fin_cases i <;> simp [Finsupp.add_apply]
    have hcoe : (single (0 : Fin 3) 1 + single 1 2 : Fin 3 →₀ ℕ) 0 = 1 := by
      simp [Finsupp.add_apply]
    rw [hsub, hcoe, eval_monomial_single_pow]; ring
  have hV3 : eval q (pderiv 0 (monomial eV3 (coeffV3 G))) = 0 := by
    simp only [eV3, pderiv_monomial]
    have hcoe : (single (1 : Fin 3) 3 : Fin 3 →₀ ℕ) 0 = 0 := by simp
    rw [hcoe]; simp
  have hU2W : eval q (pderiv 0 (monomial eU2W (coeffU2W G))) =
      2 * coeffU2W G * q 0 * q 2 := by
    simp only [eU2W, pderiv_monomial]
    have hsub : single (0 : Fin 3) 2 + single 2 1 - single 0 1 =
        single 0 1 + single 2 1 := by
      ext i; fin_cases i <;> simp [Finsupp.add_apply]
    have hcoe : (single (0 : Fin 3) 2 + single 2 1 : Fin 3 →₀ ℕ) 0 = 2 := by
      simp [Finsupp.add_apply]
    rw [hsub, hcoe, eval_monomial_two]; ring
  have hUVW : eval q (pderiv 0 (monomial eUVW (coeffUVW G))) =
      coeffUVW G * q 1 * q 2 := by
    simp only [eUVW, pderiv_monomial]
    have hsub :
        single (0 : Fin 3) 1 + single 1 1 + single 2 1 - single 0 1 =
          single 1 1 + single 2 1 := by
      ext i; fin_cases i <;> simp [Finsupp.add_apply]
    have hcoe : (single (0 : Fin 3) 1 + single 1 1 + single 2 1 : Fin 3 →₀ ℕ) 0 = 1 := by
      simp [Finsupp.add_apply]
    rw [hsub, hcoe, eval_monomial_two]; ring
  have hV2W : eval q (pderiv 0 (monomial eV2W (coeffV2W G))) = 0 := by
    simp only [eV2W, pderiv_monomial]
    have hcoe : (single (1 : Fin 3) 2 + single 2 1 : Fin 3 →₀ ℕ) 0 = 0 := by
      simp [Finsupp.add_apply]
    rw [hcoe]; simp
  have hUW2 : eval q (pderiv 0 (monomial eUW2 (coeffUW2 G))) =
      coeffUW2 G * q 2 ^ 2 := by
    simp only [eUW2, pderiv_monomial]
    have hsub : single (0 : Fin 3) 1 + single 2 2 - single 0 1 = single 2 2 := by
      ext i; fin_cases i <;> simp [Finsupp.add_apply]
    have hcoe : (single (0 : Fin 3) 1 + single 2 2 : Fin 3 →₀ ℕ) 0 = 1 := by
      simp [Finsupp.add_apply]
    rw [hsub, hcoe, eval_monomial_single_pow]; ring
  have hVW2 : eval q (pderiv 0 (monomial eVW2 (coeffVW2 G))) = 0 := by
    simp only [eVW2, pderiv_monomial]
    have hcoe : (single (1 : Fin 3) 1 + single 2 2 : Fin 3 →₀ ℕ) 0 = 0 := by
      simp [Finsupp.add_apply]
    rw [hcoe]; simp
  have hW3 : eval q (pderiv 0 (monomial eW3 (coeffW3 G))) = 0 := by
    simp only [eW3, pderiv_monomial]
    have hcoe : (single (2 : Fin 3) 3 : Fin 3 →₀ ℕ) 0 = 0 := by simp
    rw [hcoe]; simp
  simp only [hU3, hU2V, hUV2, hV3, hU2W, hUVW, hV2W, hUW2, hVW2, hW3]
  ring

/-- `∂G/∂V` of a homogeneous plane cubic at a general point. -/
theorem eval_pderiv1_planeCubic
    (G : MvPolynomial (Fin 3) R) (hG : G.IsHomogeneous 3) (q : Fin 3 → R) :
    eval q (pderiv 1 G) =
      coeffU2V G * q 0 ^ 2 + 2 * coeffUV2 G * q 0 * q 1 + 3 * coeffV3 G * q 1 ^ 2 +
        q 2 * (coeffUVW G * q 0 + 2 * coeffV2W G * q 1) + q 2 ^ 2 * coeffVW2 G := by
  have hsum := planeCubic_eq_sum_monomials G hG
  conv_lhs => rw [hsum]
  simp only [map_add]
  have hU3 : eval q (pderiv 1 (monomial eU3 (coeffU3 G))) = 0 := by
    simp only [eU3, pderiv_monomial]
    have hcoe : (single (0 : Fin 3) 3 : Fin 3 →₀ ℕ) 1 = 0 := by simp
    rw [hcoe]; simp
  have hU2V : eval q (pderiv 1 (monomial eU2V (coeffU2V G))) =
      coeffU2V G * q 0 ^ 2 := by
    simp only [eU2V, pderiv_monomial]
    have hsub : single (0 : Fin 3) 2 + single 1 1 - single 1 1 = single 0 2 := by
      ext i; fin_cases i <;> simp [Finsupp.add_apply]
    have hcoe : (single (0 : Fin 3) 2 + single 1 1 : Fin 3 →₀ ℕ) 1 = 1 := by
      simp [Finsupp.add_apply]
    rw [hsub, hcoe, eval_monomial_single_pow]; ring
  have hUV2 : eval q (pderiv 1 (monomial eUV2 (coeffUV2 G))) =
      2 * coeffUV2 G * q 0 * q 1 := by
    simp only [eUV2, pderiv_monomial]
    have hsub : single (0 : Fin 3) 1 + single 1 2 - single 1 1 =
        single 0 1 + single 1 1 := by
      ext i; fin_cases i <;> simp [Finsupp.add_apply]
    have hcoe : (single (0 : Fin 3) 1 + single 1 2 : Fin 3 →₀ ℕ) 1 = 2 := by
      simp [Finsupp.add_apply]
    rw [hsub, hcoe, eval_monomial_two]; ring
  have hV3 : eval q (pderiv 1 (monomial eV3 (coeffV3 G))) =
      3 * coeffV3 G * q 1 ^ 2 := by
    rw [show eV3 = single (1 : Fin 3) 3 from rfl, pderiv_monomial_single,
      eval_monomial_single_pow]
    ring
  have hU2W : eval q (pderiv 1 (monomial eU2W (coeffU2W G))) = 0 := by
    simp only [eU2W, pderiv_monomial]
    have hcoe : (single (0 : Fin 3) 2 + single 2 1 : Fin 3 →₀ ℕ) 1 = 0 := by
      simp [Finsupp.add_apply]
    rw [hcoe]; simp
  have hUVW : eval q (pderiv 1 (monomial eUVW (coeffUVW G))) =
      coeffUVW G * q 0 * q 2 := by
    simp only [eUVW, pderiv_monomial]
    have hsub :
        single (0 : Fin 3) 1 + single 1 1 + single 2 1 - single 1 1 =
          single 0 1 + single 2 1 := by
      ext i; fin_cases i <;> simp [Finsupp.add_apply]
    have hcoe : (single (0 : Fin 3) 1 + single 1 1 + single 2 1 : Fin 3 →₀ ℕ) 1 = 1 := by
      simp [Finsupp.add_apply]
    rw [hsub, hcoe, eval_monomial_two]; ring
  have hV2W : eval q (pderiv 1 (monomial eV2W (coeffV2W G))) =
      2 * coeffV2W G * q 1 * q 2 := by
    simp only [eV2W, pderiv_monomial]
    have hsub : single (1 : Fin 3) 2 + single 2 1 - single 1 1 =
        single 1 1 + single 2 1 := by
      ext i; fin_cases i <;> simp [Finsupp.add_apply]
    have hcoe : (single (1 : Fin 3) 2 + single 2 1 : Fin 3 →₀ ℕ) 1 = 2 := by
      simp [Finsupp.add_apply]
    rw [hsub, hcoe, eval_monomial_two]; ring
  have hUW2 : eval q (pderiv 1 (monomial eUW2 (coeffUW2 G))) = 0 := by
    simp only [eUW2, pderiv_monomial]
    have hcoe : (single (0 : Fin 3) 1 + single 2 2 : Fin 3 →₀ ℕ) 1 = 0 := by
      simp [Finsupp.add_apply]
    rw [hcoe]; simp
  have hVW2 : eval q (pderiv 1 (monomial eVW2 (coeffVW2 G))) =
      coeffVW2 G * q 2 ^ 2 := by
    simp only [eVW2, pderiv_monomial]
    have hsub : single (1 : Fin 3) 1 + single 2 2 - single 1 1 = single 2 2 := by
      ext i; fin_cases i <;> simp [Finsupp.add_apply]
    have hcoe : (single (1 : Fin 3) 1 + single 2 2 : Fin 3 →₀ ℕ) 1 = 1 := by
      simp [Finsupp.add_apply]
    rw [hsub, hcoe, eval_monomial_single_pow]; ring
  have hW3 : eval q (pderiv 1 (monomial eW3 (coeffW3 G))) = 0 := by
    simp only [eW3, pderiv_monomial]
    have hcoe : (single (2 : Fin 3) 3 : Fin 3 →₀ ℕ) 1 = 0 := by simp
    rw [hcoe]; simp
  simp only [hU3, hU2V, hUV2, hV3, hU2W, hUVW, hV2W, hUW2, hVW2, hW3]
  ring

end PlaneCubicResidual
end BConicBundleMultisections
