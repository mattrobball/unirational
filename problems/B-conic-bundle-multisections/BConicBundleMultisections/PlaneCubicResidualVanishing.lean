/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.PlaneCubicResidualIdentity
public import BConicBundleMultisections.PlaneCubicTangentForm
public import BConicBundleMultisections.ProjectiveTangentHyperplane
public import Mathlib.Algebra.MvPolynomial.PDeriv
public import Mathlib.Data.Finsupp.Basic
public import Mathlib.Algebra.Polynomial.Degree.SmallDegree
public import Mathlib.RingTheory.Localization.FractionRing
public import Mathlib.RingTheory.Polynomial.Resultant.Basic
public import Mathlib.Tactic.Ring

/-!
# Polar resultant vanishes at residual points of double contact on `W = 0`

Certificate identity (2.1) consequences for residual image: the polar resultant of a
homogeneous plane cubic vanishes at residual ambient points of double contact along the
coordinate line `{W = 0}`. Combined with `residual_identity_eval` and domain cancellation of
`W²`, this yields vanishing of the residual linear form (handled in
`ResidualImageAffineParam`).
-/

@[expose] public section

set_option maxHeartbeats 800000

open MvPolynomial Finsupp

namespace BConicBundleMultisections
namespace PlaneCubicResidual

noncomputable section

universe u

variable {R : Type u} [CommRing R]

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

/-! ### `pderiv` of the ten cubic monomials on the line `W = 0` -/

private theorem eval_pderiv0_eU3 (a : R) (p : Fin 3 → R) (hp0 : p 0 = 1) :
    eval p (pderiv 0 (monomial eU3 a)) = 3 * a := by
  rw [show eU3 = single (0 : Fin 3) 3 from rfl, pderiv_monomial_single,
    eval_monomial_single_pow]
  simp [hp0]; ring

private theorem eval_pderiv0_eU2V (a : R) (p : Fin 3 → R) (hp0 : p 0 = 1) :
    eval p (pderiv 0 (monomial eU2V a)) = 2 * a * p 1 := by
  simp only [eU2V, pderiv_monomial]
  have hsub : single (0 : Fin 3) 2 + single 1 1 - single 0 1 = single 0 1 + single 1 1 := by
    ext i; fin_cases i <;> simp [Finsupp.add_apply]
  have hcoe : (single (0 : Fin 3) 2 + single 1 1 : Fin 3 →₀ ℕ) 0 = 2 := by
    simp [Finsupp.add_apply]
  rw [hsub, hcoe, eval_monomial_two]; simp [hp0]; ring

private theorem eval_pderiv0_eUV2 (a : R) (p : Fin 3 → R) (hp0 : p 0 = 1) :
    eval p (pderiv 0 (monomial eUV2 a)) = a * (p 1) ^ 2 := by
  simp only [eUV2, pderiv_monomial]
  have hsub : single (0 : Fin 3) 1 + single 1 2 - single 0 1 = single 1 2 := by
    ext i; fin_cases i <;> simp [Finsupp.add_apply]
  have hcoe : (single (0 : Fin 3) 1 + single 1 2 : Fin 3 →₀ ℕ) 0 = 1 := by
    simp [Finsupp.add_apply]
  rw [hsub, hcoe, eval_monomial_single_pow]
  simp [hp0]

private theorem eval_pderiv0_eV3 (a : R) (p : Fin 3 → R) :
    eval p (pderiv 0 (monomial eV3 a)) = 0 := by
  simp only [eV3, pderiv_monomial]
  have hcoe : (single (1 : Fin 3) 3 : Fin 3 →₀ ℕ) 0 = 0 := by simp
  rw [hcoe]; simp

private theorem eval_pderiv0_eU2W (a : R) (p : Fin 3 → R) (hp0 : p 0 = 1) (hp2 : p 2 = 0) :
    eval p (pderiv 0 (monomial eU2W a)) = 0 := by
  simp only [eU2W, pderiv_monomial]
  have hsub : single (0 : Fin 3) 2 + single 2 1 - single 0 1 = single 0 1 + single 2 1 := by
    ext i; fin_cases i <;> simp [Finsupp.add_apply]
  have hcoe : (single (0 : Fin 3) 2 + single 2 1 : Fin 3 →₀ ℕ) 0 = 2 := by
    simp [Finsupp.add_apply]
  rw [hsub, hcoe, eval_monomial_two]; simp [hp0, hp2]

private theorem eval_pderiv0_eUVW (a : R) (p : Fin 3 → R) (hp0 : p 0 = 1) (hp2 : p 2 = 0) :
    eval p (pderiv 0 (monomial eUVW a)) = 0 := by
  simp only [eUVW, pderiv_monomial]
  have hsub :
      single (0 : Fin 3) 1 + single 1 1 + single 2 1 - single 0 1 =
        single 1 1 + single 2 1 := by
    ext i; fin_cases i <;> simp [Finsupp.add_apply]
  have hcoe : (single (0 : Fin 3) 1 + single 1 1 + single 2 1 : Fin 3 →₀ ℕ) 0 = 1 := by
    simp [Finsupp.add_apply]
  rw [hsub, hcoe, eval_monomial_two]; simp [hp0, hp2]

private theorem eval_pderiv0_eV2W (a : R) (p : Fin 3 → R) :
    eval p (pderiv 0 (monomial eV2W a)) = 0 := by
  simp only [eV2W, pderiv_monomial]
  have hcoe : (single (1 : Fin 3) 2 + single 2 1 : Fin 3 →₀ ℕ) 0 = 0 := by
    simp [Finsupp.add_apply]
  rw [hcoe]; simp

private theorem eval_pderiv0_eUW2 (a : R) (p : Fin 3 → R) (hp0 : p 0 = 1) (hp2 : p 2 = 0) :
    eval p (pderiv 0 (monomial eUW2 a)) = 0 := by
  simp only [eUW2, pderiv_monomial]
  have hsub : single (0 : Fin 3) 1 + single 2 2 - single 0 1 = single 2 2 := by
    ext i; fin_cases i <;> simp [Finsupp.add_apply]
  have hcoe : (single (0 : Fin 3) 1 + single 2 2 : Fin 3 →₀ ℕ) 0 = 1 := by
    simp [Finsupp.add_apply]
  rw [hsub, hcoe, eval_monomial_single_pow]; simp [hp2]

private theorem eval_pderiv0_eVW2 (a : R) (p : Fin 3 → R) :
    eval p (pderiv 0 (monomial eVW2 a)) = 0 := by
  simp only [eVW2, pderiv_monomial]
  have hcoe : (single (1 : Fin 3) 1 + single 2 2 : Fin 3 →₀ ℕ) 0 = 0 := by
    simp [Finsupp.add_apply]
  rw [hcoe]; simp

private theorem eval_pderiv0_eW3 (a : R) (p : Fin 3 → R) :
    eval p (pderiv 0 (monomial eW3 a)) = 0 := by
  simp only [eW3, pderiv_monomial]
  have hcoe : (single (2 : Fin 3) 3 : Fin 3 →₀ ℕ) 0 = 0 := by simp
  rw [hcoe]; simp

private theorem eval_pderiv1_eU3 (a : R) (p : Fin 3 → R) :
    eval p (pderiv 1 (monomial eU3 a)) = 0 := by
  simp only [eU3, pderiv_monomial]
  have hcoe : (single (0 : Fin 3) 3 : Fin 3 →₀ ℕ) 1 = 0 := by simp
  rw [hcoe]; simp

private theorem eval_pderiv1_eU2V (a : R) (p : Fin 3 → R) (hp0 : p 0 = 1) :
    eval p (pderiv 1 (monomial eU2V a)) = a := by
  simp only [eU2V, pderiv_monomial]
  have hsub : single (0 : Fin 3) 2 + single 1 1 - single 1 1 = single 0 2 := by
    ext i; fin_cases i <;> simp [Finsupp.add_apply]
  have hcoe : (single (0 : Fin 3) 2 + single 1 1 : Fin 3 →₀ ℕ) 1 = 1 := by
    simp [Finsupp.add_apply]
  rw [hsub, hcoe, eval_monomial_single_pow]; simp [hp0]

private theorem eval_pderiv1_eUV2 (a : R) (p : Fin 3 → R) (hp0 : p 0 = 1) :
    eval p (pderiv 1 (monomial eUV2 a)) = 2 * a * p 1 := by
  simp only [eUV2, pderiv_monomial]
  have hsub : single (0 : Fin 3) 1 + single 1 2 - single 1 1 = single 0 1 + single 1 1 := by
    ext i; fin_cases i <;> simp [Finsupp.add_apply]
  have hcoe : (single (0 : Fin 3) 1 + single 1 2 : Fin 3 →₀ ℕ) 1 = 2 := by
    simp [Finsupp.add_apply]
  rw [hsub, hcoe, eval_monomial_two]; simp [hp0]; ring

private theorem eval_pderiv1_eV3 (a : R) (p : Fin 3 → R) :
    eval p (pderiv 1 (monomial eV3 a)) = 3 * a * (p 1) ^ 2 := by
  rw [show eV3 = single (1 : Fin 3) 3 from rfl, pderiv_monomial_single,
    eval_monomial_single_pow]
  ring

private theorem eval_pderiv1_eU2W (a : R) (p : Fin 3 → R) :
    eval p (pderiv 1 (monomial eU2W a)) = 0 := by
  simp only [eU2W, pderiv_monomial]
  have hcoe : (single (0 : Fin 3) 2 + single 2 1 : Fin 3 →₀ ℕ) 1 = 0 := by
    simp [Finsupp.add_apply]
  rw [hcoe]; simp

private theorem eval_pderiv1_eUVW (a : R) (p : Fin 3 → R) (hp0 : p 0 = 1) (hp2 : p 2 = 0) :
    eval p (pderiv 1 (monomial eUVW a)) = 0 := by
  simp only [eUVW, pderiv_monomial]
  have hsub :
      single (0 : Fin 3) 1 + single 1 1 + single 2 1 - single 1 1 =
        single 0 1 + single 2 1 := by
    ext i; fin_cases i <;> simp [Finsupp.add_apply]
  have hcoe : (single (0 : Fin 3) 1 + single 1 1 + single 2 1 : Fin 3 →₀ ℕ) 1 = 1 := by
    simp [Finsupp.add_apply]
  rw [hsub, hcoe, eval_monomial_two]; simp [hp0, hp2]

private theorem eval_pderiv1_eV2W (a : R) (p : Fin 3 → R) (hp2 : p 2 = 0) :
    eval p (pderiv 1 (monomial eV2W a)) = 0 := by
  simp only [eV2W, pderiv_monomial]
  have hsub : single (1 : Fin 3) 2 + single 2 1 - single 1 1 = single 1 1 + single 2 1 := by
    ext i; fin_cases i <;> simp [Finsupp.add_apply]
  have hcoe : (single (1 : Fin 3) 2 + single 2 1 : Fin 3 →₀ ℕ) 1 = 2 := by
    simp [Finsupp.add_apply]
  rw [hsub, hcoe, eval_monomial_two]; simp [hp2]

private theorem eval_pderiv1_eUW2 (a : R) (p : Fin 3 → R) :
    eval p (pderiv 1 (monomial eUW2 a)) = 0 := by
  simp only [eUW2, pderiv_monomial]
  have hcoe : (single (0 : Fin 3) 1 + single 2 2 : Fin 3 →₀ ℕ) 1 = 0 := by
    simp [Finsupp.add_apply]
  rw [hcoe]; simp

private theorem eval_pderiv1_eVW2 (a : R) (p : Fin 3 → R) (hp2 : p 2 = 0) :
    eval p (pderiv 1 (monomial eVW2 a)) = 0 := by
  simp only [eVW2, pderiv_monomial]
  have hsub : single (1 : Fin 3) 1 + single 2 2 - single 1 1 = single 2 2 := by
    ext i; fin_cases i <;> simp [Finsupp.add_apply]
  have hcoe : (single (1 : Fin 3) 1 + single 2 2 : Fin 3 →₀ ℕ) 1 = 1 := by
    simp [Finsupp.add_apply]
  rw [hsub, hcoe, eval_monomial_single_pow]; simp [hp2]

private theorem eval_pderiv1_eW3 (a : R) (p : Fin 3 → R) :
    eval p (pderiv 1 (monomial eW3 a)) = 0 := by
  simp only [eW3, pderiv_monomial]
  have hcoe : (single (2 : Fin 3) 3 : Fin 3 →₀ ℕ) 1 = 0 := by simp
  rw [hcoe]; simp

private theorem eval_pderiv2_eU3 (a : R) (p : Fin 3 → R) :
    eval p (pderiv 2 (monomial eU3 a)) = 0 := by
  simp only [eU3, pderiv_monomial]
  have hcoe : (single (0 : Fin 3) 3 : Fin 3 →₀ ℕ) 2 = 0 := by simp
  rw [hcoe]; simp

private theorem eval_pderiv2_eU2V (a : R) (p : Fin 3 → R) :
    eval p (pderiv 2 (monomial eU2V a)) = 0 := by
  simp only [eU2V, pderiv_monomial]
  have hcoe : (single (0 : Fin 3) 2 + single 1 1 : Fin 3 →₀ ℕ) 2 = 0 := by
    simp [Finsupp.add_apply]
  rw [hcoe]; simp

private theorem eval_pderiv2_eUV2 (a : R) (p : Fin 3 → R) :
    eval p (pderiv 2 (monomial eUV2 a)) = 0 := by
  simp only [eUV2, pderiv_monomial]
  have hcoe : (single (0 : Fin 3) 1 + single 1 2 : Fin 3 →₀ ℕ) 2 = 0 := by
    simp [Finsupp.add_apply]
  rw [hcoe]; simp

private theorem eval_pderiv2_eV3 (a : R) (p : Fin 3 → R) :
    eval p (pderiv 2 (monomial eV3 a)) = 0 := by
  simp only [eV3, pderiv_monomial]
  have hcoe : (single (1 : Fin 3) 3 : Fin 3 →₀ ℕ) 2 = 0 := by simp
  rw [hcoe]; simp

private theorem eval_pderiv2_eU2W (a : R) (p : Fin 3 → R) (hp0 : p 0 = 1) :
    eval p (pderiv 2 (monomial eU2W a)) = a := by
  simp only [eU2W, pderiv_monomial]
  have hsub : single (0 : Fin 3) 2 + single 2 1 - single 2 1 = single 0 2 := by
    ext i; fin_cases i <;> simp [Finsupp.add_apply]
  have hcoe : (single (0 : Fin 3) 2 + single 2 1 : Fin 3 →₀ ℕ) 2 = 1 := by
    simp [Finsupp.add_apply]
  rw [hsub, hcoe, eval_monomial_single_pow]; simp [hp0]

private theorem eval_pderiv2_eUVW (a : R) (p : Fin 3 → R) (hp0 : p 0 = 1) :
    eval p (pderiv 2 (monomial eUVW a)) = a * p 1 := by
  simp only [eUVW, pderiv_monomial]
  have hsub :
      single (0 : Fin 3) 1 + single 1 1 + single 2 1 - single 2 1 =
        single 0 1 + single 1 1 := by
    ext i; fin_cases i <;> simp [Finsupp.add_apply]
  have hcoe : (single (0 : Fin 3) 1 + single 1 1 + single 2 1 : Fin 3 →₀ ℕ) 2 = 1 := by
    simp [Finsupp.add_apply]
  rw [hsub, hcoe, eval_monomial_two]; simp [hp0]

private theorem eval_pderiv2_eV2W (a : R) (p : Fin 3 → R) :
    eval p (pderiv 2 (monomial eV2W a)) = a * (p 1) ^ 2 := by
  simp only [eV2W, pderiv_monomial]
  have hsub : single (1 : Fin 3) 2 + single 2 1 - single 2 1 = single 1 2 := by
    ext i; fin_cases i <;> simp [Finsupp.add_apply]
  have hcoe : (single (1 : Fin 3) 2 + single 2 1 : Fin 3 →₀ ℕ) 2 = 1 := by
    simp [Finsupp.add_apply]
  rw [hsub, hcoe, eval_monomial_single_pow]; ring

private theorem eval_pderiv2_eUW2 (a : R) (p : Fin 3 → R) (hp0 : p 0 = 1) (hp2 : p 2 = 0) :
    eval p (pderiv 2 (monomial eUW2 a)) = 0 := by
  simp only [eUW2, pderiv_monomial]
  have hsub : single (0 : Fin 3) 1 + single 2 2 - single 2 1 = single 0 1 + single 2 1 := by
    ext i; fin_cases i <;> simp [Finsupp.add_apply]
  have hcoe : (single (0 : Fin 3) 1 + single 2 2 : Fin 3 →₀ ℕ) 2 = 2 := by
    simp [Finsupp.add_apply]
  rw [hsub, hcoe, eval_monomial_two]; simp [hp0, hp2]

private theorem eval_pderiv2_eVW2 (a : R) (p : Fin 3 → R) (hp2 : p 2 = 0) :
    eval p (pderiv 2 (monomial eVW2 a)) = 0 := by
  simp only [eVW2, pderiv_monomial]
  have hsub : single (1 : Fin 3) 1 + single 2 2 - single 2 1 = single 1 1 + single 2 1 := by
    ext i; fin_cases i <;> simp [Finsupp.add_apply]
  have hcoe : (single (1 : Fin 3) 1 + single 2 2 : Fin 3 →₀ ℕ) 2 = 2 := by
    simp [Finsupp.add_apply]
  rw [hsub, hcoe, eval_monomial_two]; simp [hp2]

private theorem eval_pderiv2_eW3 (a : R) (p : Fin 3 → R) (hp2 : p 2 = 0) :
    eval p (pderiv 2 (monomial eW3 a)) = 0 := by
  rw [show eW3 = single (2 : Fin 3) 3 from rfl, pderiv_monomial_single,
    eval_monomial_single_pow]
  simp [hp2]

/-- Partials of a homogeneous plane cubic at a normalized point of `{W = 0}`. -/
theorem eval_pderiv_on_line
    (G : MvPolynomial (Fin 3) R) (hG : G.IsHomogeneous 3)
    (p : Fin 3 → R) (hp0 : p 0 = 1) (hp2 : p 2 = 0) :
    eval p (pderiv 0 G) =
      3 * coeffU3 G + 2 * coeffU2V G * p 1 + coeffUV2 G * (p 1) ^ 2 ∧
    eval p (pderiv 1 G) =
      coeffU2V G + 2 * coeffUV2 G * p 1 + 3 * coeffV3 G * (p 1) ^ 2 ∧
    eval p (pderiv 2 G) =
      coeffU2W G + coeffUVW G * p 1 + coeffV2W G * (p 1) ^ 2 := by
  have hGsum := planeCubic_eq_sum_monomials G hG
  -- Rewrite only the left-hand evaluations so `coeffU* G` stays on the original cubic
  refine ⟨?_, ?_, ?_⟩
  · conv_lhs => rw [hGsum]
    simp only [map_add]
    rw [eval_pderiv0_eU3 _ p hp0, eval_pderiv0_eU2V _ p hp0, eval_pderiv0_eUV2 _ p hp0,
      eval_pderiv0_eV3, eval_pderiv0_eU2W _ p hp0 hp2, eval_pderiv0_eUVW _ p hp0 hp2,
      eval_pderiv0_eV2W, eval_pderiv0_eUW2 _ p hp0 hp2, eval_pderiv0_eVW2,
      eval_pderiv0_eW3]
    ring
  · conv_lhs => rw [hGsum]
    simp only [map_add]
    rw [eval_pderiv1_eU3, eval_pderiv1_eU2V _ p hp0, eval_pderiv1_eUV2 _ p hp0,
      eval_pderiv1_eV3, eval_pderiv1_eU2W, eval_pderiv1_eUVW _ p hp0 hp2,
      eval_pderiv1_eV2W _ p hp2, eval_pderiv1_eUW2, eval_pderiv1_eVW2 _ p hp2,
      eval_pderiv1_eW3]
    ring
  · conv_lhs => rw [hGsum]
    simp only [map_add]
    rw [eval_pderiv2_eU3, eval_pderiv2_eU2V, eval_pderiv2_eUV2, eval_pderiv2_eV3,
      eval_pderiv2_eU2W _ p hp0, eval_pderiv2_eUVW _ p hp0, eval_pderiv2_eV2W,
      eval_pderiv2_eUW2 _ p hp0 hp2, eval_pderiv2_eVW2 _ p hp2, eval_pderiv2_eW3 _ p hp2]
    ring

/-- Polar form on the coordinate line equals the tangent pairing. -/
theorem polar_on_line_eq_tangent
    (G : MvPolynomial (Fin 3) R) (hG : G.IsHomogeneous 3)
    (p y : Fin 3 → R) (hp0 : p 0 = 1) (hp2 : p 2 = 0) :
    UniversalResidual.polarQuadA (coeffU3 G) (coeffU2V G) (coeffU2W G) (y 0) (y 1) (y 2) +
      UniversalResidual.polarQuadB (coeffU2V G) (coeffUV2 G) (coeffUVW G)
        (y 0) (y 1) (y 2) * p 1 +
      UniversalResidual.polarQuadC (coeffUV2 G) (coeffV3 G) (coeffV2W G)
        (y 0) (y 1) (y 2) * (p 1) ^ 2 =
      eval y (tangentForm G p) := by
  obtain ⟨h0, h1, h2⟩ := eval_pderiv_on_line G hG p hp0 hp2
  simp only [eval_tangentForm, Fin.sum_univ_three, UniversalResidual.polarQuadA,
    UniversalResidual.polarQuadB, UniversalResidual.polarQuadC, h0, h1, h2]
  ring


/-- Polar resultant vanishes at residual points of double contact on `{W = 0}`.

The dehomogenized cubic `g` and the polar quadratic along the residual point share the
root corresponding to the line point `p`. Injectivity of `R → Frac(R)` upgrades vanishing of
the default residual over the fraction field to the fixed-degree `(3, 2)` polar resultant. -/
theorem polarResultant_eq_zero_of_line_residual
    [IsDomain R]
    (G : MvPolynomial (Fin 3) R) (hG : G.IsHomogeneous 3)
    (p y : Fin 3 → R) (hp0 : p 0 = 1) (hp2 : p 2 = 0)
    (hp : eval p G = 0) (hy_tan : eval y (tangentForm G p) = 0) :
    UniversalResidual.polarResultant
        (coeffU3 G) (coeffU2V G) (coeffUV2 G) (coeffV3 G)
        (coeffU2W G) (coeffUVW G) (coeffV2W G) (y 0) (y 1) (y 2) = 0 := by
  classical
  set a := coeffU3 G
  set b := coeffU2V G
  set c := coeffUV2 G
  set d := coeffV3 G
  set e := coeffU2W G
  set fc := coeffUVW G
  set hh := coeffV2W G
  have hg_at_p : a + b * p 1 + c * (p 1) ^ 2 + d * (p 1) ^ 3 = 0 := by
    have hval := eval_eq_planeCubicValue hG p
    simp only [hp, UniversalResidual.planeCubicValue, hp2, mul_zero, zero_mul, add_zero,
      hp0, mul_one] at hval
    simpa [a, b, c, d, pow_two, pow_three, mul_assoc] using hval.symm
  have hpolar_at_p :
      UniversalResidual.polarQuadA a b e (y 0) (y 1) (y 2) +
        UniversalResidual.polarQuadB b c fc (y 0) (y 1) (y 2) * p 1 +
        UniversalResidual.polarQuadC c d hh (y 0) (y 1) (y 2) * (p 1) ^ 2 = 0 := by
    have h := polar_on_line_eq_tangent G hG p y hp0 hp2
    simpa [a, b, c, d, e, fc, hh, hy_tan] using h
  set φ := algebraMap R (FractionRing R)
  set A := UniversalResidual.polarQuadA a b e (y 0) (y 1) (y 2)
  set B := UniversalResidual.polarQuadB b c fc (y 0) (y 1) (y 2)
  set C0 := UniversalResidual.polarQuadC c d hh (y 0) (y 1) (y 2)
  -- Resultant of mapped forms over `Frac(R)` vanishes
  have hresK :
      Polynomial.resultant
          (Polynomial.C (φ a) * Polynomial.X ^ 3 + Polynomial.C (φ b) * Polynomial.X ^ 2 +
            Polynomial.C (φ c) * Polynomial.X + Polynomial.C (φ d))
          (Polynomial.C (φ A) * Polynomial.X ^ 2 + Polynomial.C (φ B) * Polynomial.X +
            Polynomial.C (φ C0))
          3 2 = 0 := by
    set gK :=
      Polynomial.C (φ a) * Polynomial.X ^ 3 + Polynomial.C (φ b) * Polynomial.X ^ 2 +
        Polynomial.C (φ c) * Polynomial.X + Polynomial.C (φ d)
    set pK :=
      Polynomial.C (φ A) * Polynomial.X ^ 2 + Polynomial.C (φ B) * Polynomial.X +
        Polynomial.C (φ C0)
    have hnatg : gK.natDegree ≤ 3 := by
      simpa [gK] using
        (Polynomial.natDegree_cubic_le (R := FractionRing R) (a := φ a) (b := φ b)
          (c := φ c) (d := φ d))
    have hnatp : pK.natDegree ≤ 2 := by
      simpa [pK] using
        (Polynomial.natDegree_quadratic_le (R := FractionRing R) (a := φ A) (b := φ B)
          (c := φ C0))
    set t := p 1
    by_cases ht : φ t = 0
    · -- Infinity: leading coefficients vanish ⇒ pad with zero leading polar coeff
      have ha0 : φ a = 0 := by
        have h := congrArg φ hg_at_p
        simp [map_add, map_mul, map_pow, ht, mul_zero, add_zero, pow_two, pow_three] at h
        exact h
      have hA0 : φ A = 0 := by
        have h := congrArg φ hpolar_at_p
        simp [map_add, map_mul, map_pow, ht, mul_zero, add_zero, pow_two] at h
        exact h
      have hg_le2 : gK.natDegree ≤ 2 := by
        have heq : gK =
            Polynomial.C (φ b) * Polynomial.X ^ 2 + Polynomial.C (φ c) * Polynomial.X +
              Polynomial.C (φ d) := by
          simp [gK, ha0]
        rw [heq]
        simpa using
          (Polynomial.natDegree_quadratic_le (R := FractionRing R) (a := φ b) (b := φ c)
            (c := φ d))
      have hp_lead : pK.coeff 2 = 0 := by
        simp [pK, hA0]
      have hform :
          Polynomial.resultant gK pK (2 + 1) 2 =
            (-1) ^ (2 * 1) * pK.coeff 2 ^ 1 * Polynomial.resultant gK pK 2 2 :=
        Polynomial.resultant_add_left_deg (f := gK) (g := pK) (m := 2) (n := 2) (k := 1) hg_le2
      simpa [show (3 : ℕ) = 2 + 1 from rfl, hform, hp_lead]
    · -- Affine common root `t⁻¹`
      have ht' : φ t ≠ 0 := ht
      have hr : gK.eval (φ t)⁻¹ = 0 := by
        have hnum :
            (φ t) ^ 3 * gK.eval (φ t)⁻¹ =
              φ a + φ b * φ t + φ c * (φ t) ^ 2 + φ d * (φ t) ^ 3 := by
          simp [gK, Polynomial.eval_add, Polynomial.eval_mul, Polynomial.eval_C,
            Polynomial.eval_pow, Polynomial.eval_X]
          field_simp [ht']
        have hsrc : φ a + φ b * φ t + φ c * (φ t) ^ 2 + φ d * (φ t) ^ 3 = 0 := by
          have h := congrArg φ hg_at_p
          simpa [map_add, map_mul, map_pow, map_zero] using h
        exact (mul_eq_zero.mp (hnum.trans hsrc)).resolve_left (pow_ne_zero 3 ht')
      have hrP : pK.eval (φ t)⁻¹ = 0 := by
        have hnum :
            (φ t) ^ 2 * pK.eval (φ t)⁻¹ = φ A + φ B * φ t + φ C0 * (φ t) ^ 2 := by
          simp [pK, Polynomial.eval_add, Polynomial.eval_mul, Polynomial.eval_C,
            Polynomial.eval_pow, Polynomial.eval_X]
          field_simp [ht']
        have hsrc : φ A + φ B * φ t + φ C0 * (φ t) ^ 2 = 0 := by
          have h := congrArg φ hpolar_at_p
          simpa [map_add, map_mul, map_pow, map_zero] using h
        exact (mul_eq_zero.mp (hnum.trans hsrc)).resolve_left (pow_ne_zero 2 ht')
      by_cases hg0 : gK = 0
      · -- `resultant 0 pK 3 2 = 0^2 * ... = 0`
        rw [hg0, Polynomial.resultant_zero_left]
        simp
      · have hnc : ¬ IsCoprime gK pK := by
          intro h
          obtain ⟨u, v, huv⟩ := h
          have := congrArg (Polynomial.eval (φ t)⁻¹) huv
          simp [hr, hrP] at this
        have hres0 : Polynomial.resultant gK pK = 0 := by
          rw [Polynomial.resultant_eq_zero_iff]
          exact ⟨Or.inl hg0, hnc⟩
        have h1 : Polynomial.resultant gK pK 3 pK.natDegree = 0 := by
          have hpad :=
            Polynomial.resultant_add_left_deg (f := gK) (g := pK) (m := gK.natDegree)
              (n := pK.natDegree) (k := 3 - gK.natDegree) le_rfl
          have heq : gK.natDegree + (3 - gK.natDegree) = 3 := Nat.add_sub_of_le hnatg
          rw [← heq, hpad, hres0]; ring
        have h2 : Polynomial.resultant gK pK 3 2 = 0 := by
          have hpad :=
            Polynomial.resultant_add_right_deg (f := gK) (g := pK) (m := 3) (n := pK.natDegree)
              (k := 2 - pK.natDegree) le_rfl
          have heq : pK.natDegree + (2 - pK.natDegree) = 2 := Nat.add_sub_of_le hnatp
          rw [← heq, hpad, h1, mul_zero]
        exact h2
  -- Lift from Frac(R) to R by injectivity of the algebra map
  have hφ_inj : Function.Injective φ := IsFractionRing.injective R (FractionRing R)
  apply hφ_inj
  -- Goal: `φ (polarResultant ...) = φ 0`
  rw [map_zero, UniversalResidual.polarResultant_eq_resultant]
  -- Rephrase residual using the set aliases `A,B,C0` (defeq to polarQuad*)
  change
    φ
        (Polynomial.resultant
          (Polynomial.C a * Polynomial.X ^ 3 + Polynomial.C b * Polynomial.X ^ 2 +
            Polynomial.C c * Polynomial.X + Polynomial.C d)
          (Polynomial.C A * Polynomial.X ^ 2 + Polynomial.C B * Polynomial.X + Polynomial.C C0)
          3 2) =
      0
  -- `resultant_map_map`: residual of maps = image of residual
  rw [← Polynomial.resultant_map_map
    (f := Polynomial.C a * Polynomial.X ^ 3 + Polynomial.C b * Polynomial.X ^ 2 +
      Polynomial.C c * Polynomial.X + Polynomial.C d)
    (g := Polynomial.C A * Polynomial.X ^ 2 + Polynomial.C B * Polynomial.X + Polynomial.C C0)
    (m := 3) (n := 2) φ]
  -- Evaluate the coefficient-wise maps
  have hmaps :
      (Polynomial.C a * Polynomial.X ^ 3 + Polynomial.C b * Polynomial.X ^ 2 +
            Polynomial.C c * Polynomial.X + Polynomial.C d).map φ =
        Polynomial.C (φ a) * Polynomial.X ^ 3 + Polynomial.C (φ b) * Polynomial.X ^ 2 +
          Polynomial.C (φ c) * Polynomial.X + Polynomial.C (φ d) := by
    simp [Polynomial.map_add, Polynomial.map_mul, Polynomial.map_pow, Polynomial.map_C,
      Polynomial.map_X]
  have hmapt :
      (Polynomial.C A * Polynomial.X ^ 2 + Polynomial.C B * Polynomial.X +
            Polynomial.C C0).map φ =
        Polynomial.C (φ A) * Polynomial.X ^ 2 + Polynomial.C (φ B) * Polynomial.X +
          Polynomial.C (φ C0) := by
    simp [Polynomial.map_add, Polynomial.map_mul, Polynomial.map_pow, Polynomial.map_C,
      Polynomial.map_X]
  rw [hmaps, hmapt, hresK]

end
end PlaneCubicResidual
end BConicBundleMultisections
