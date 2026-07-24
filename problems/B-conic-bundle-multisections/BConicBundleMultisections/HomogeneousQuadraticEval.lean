/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import Mathlib.Algebra.BigOperators.Fin
public import Mathlib.Algebra.MvPolynomial.Eval
public import Mathlib.Data.Finsupp.Basic
public import Mathlib.Data.Finsupp.Weight
public import Mathlib.RingTheory.MvPolynomial.Homogeneous
public import Mathlib.Tactic.IntervalCases
public import Mathlib.Tactic.Ring

/-!
# Evaluation of homogeneous ternary quadratics

For a homogeneous degree-2 polynomial in three variables, evaluation equals the
upper-triangular coefficient pairing used by residual/Tsen bookkeeping.
-/

@[expose] public section

namespace BConicBundleMultisections

noncomputable section

open MvPolynomial
open Finsupp

universe u

/-- Upper-triangular coefficient extraction for ternary quadratics. -/
def ternaryQuadraticCoeff
    {R : Type u} [CommRing R] (f : MvPolynomial (Fin 3) R) (i j : Fin 3) : R :=
  if i = j then f.coeff (single i 2)
  else if i < j then f.coeff (single i 1 + single j 1)
  else 0

private theorem weight_eq_sum (s : Fin 3 →₀ ℕ) :
    weight (1 : Fin 3 → ℕ) s = ∑ i : Fin 3, s i := by
  trans weight (fun _ : Fin 3 => (1 : ℕ)) s
  · rfl
  · rw [← degree_eq_weight_one (σ := Fin 3) (R := ℕ), degree_eq_sum]

private theorem eq_of_components (s : Fin 3 →₀ ℕ) {a0 a1 a2 : ℕ}
    (h0 : s 0 = a0) (h1 : s 1 = a1) (h2 : s 2 = a2) :
    s = single (0 : Fin 3) a0 + single 1 a1 + single 2 a2 := by
  ext ⟨i, hi⟩
  interval_cases i
  · simpa [add_apply, single_apply] using h0
  · simpa [add_apply, single_apply] using h1
  · simpa [add_apply, single_apply] using h2

private theorem degree_two_cases (s : Fin 3 →₀ ℕ)
    (h : ∑ i : Fin 3, s i = 2) :
    s = single (0 : Fin 3) 2 ∨ s = single (1 : Fin 3) 2 ∨ s = single (2 : Fin 3) 2 ∨
      s = single (0 : Fin 3) 1 + single 1 1 ∨
        s = single (0 : Fin 3) 1 + single 2 1 ∨
          s = single (1 : Fin 3) 1 + single 2 1 := by
  have hsum : s 0 + s 1 + s 2 = 2 := by
    rwa [Fin.sum_univ_three (fun i => s i)] at h
  have : s 0 ≤ 2 := by omega
  have : s 1 ≤ 2 := by omega
  have : s 2 ≤ 2 := by omega
  interval_cases h0 : s 0 <;> interval_cases h1 : s 1 <;> interval_cases h2 : s 2
  all_goals try omega
  · -- (0,0,2)
    refine Or.inr (Or.inr (Or.inl ?_))
    convert eq_of_components s h0 h1 h2 using 1
    ext ⟨i, hi⟩; interval_cases i <;> simp
  · -- (0,1,1)
    refine Or.inr (Or.inr (Or.inr (Or.inr (Or.inr ?_))))
    convert eq_of_components s h0 h1 h2 using 1
    ext ⟨i, hi⟩; interval_cases i <;> simp
  · -- (0,2,0)
    refine Or.inr (Or.inl ?_)
    convert eq_of_components s h0 h1 h2 using 1
    ext ⟨i, hi⟩; interval_cases i <;> simp
  · -- (1,0,1)
    refine Or.inr (Or.inr (Or.inr (Or.inr (Or.inl ?_))))
    convert eq_of_components s h0 h1 h2 using 1
    ext ⟨i, hi⟩; interval_cases i <;> simp
  · -- (1,1,0)
    refine Or.inr (Or.inr (Or.inr (Or.inl ?_)))
    convert eq_of_components s h0 h1 h2 using 1
    ext ⟨i, hi⟩; interval_cases i <;> simp
  · -- (2,0,0)
    refine Or.inl ?_
    convert eq_of_components s h0 h1 h2 using 1
    ext ⟨i, hi⟩; interval_cases i <;> simp

private theorem prod_off
    {R : Type u} [CommRing R] (k l : Fin 3) (hkl : k ≠ l) (x : Fin 3 → R) :
    ((single k 1 + single l 1 : Fin 3 →₀ ℕ).prod fun i e => x i ^ e) = x k * x l := by
  classical
  simp only [Finsupp.prod]
  have heq : (single k 1 + single l 1 : Fin 3 →₀ ℕ).support = ({k, l} : Finset (Fin 3)) := by
    ext i
    simp only [Finsupp.mem_support_iff, Finset.mem_insert, Finset.mem_singleton, add_apply,
      single_apply, ne_eq]
    constructor
    · intro h
      by_cases hik : i = k
      · exact Or.inl hik
      · by_cases hil : i = l
        · exact Or.inr hil
        · have hki : k ≠ i := Ne.symm hik
          have hli : l ≠ i := Ne.symm hil
          simp [hki, hli] at h
    · intro h
      rcases h with rfl | rfl <;> simp [hkl, Ne.symm hkl]
  rw [heq, Finset.prod_pair hkl]
  simp [add_apply, hkl, Ne.symm hkl, pow_one]

private theorem sum_ternaryQuadraticCoeff_eq
    {R : Type u} [CommRing R] (f : MvPolynomial (Fin 3) R) (x : Fin 3 → R) :
    (∑ i : Fin 3, ∑ j : Fin 3, ternaryQuadraticCoeff f i j * x i * x j) =
      f.coeff (single (0 : Fin 3) 2) * x 0 ^ 2 +
        f.coeff (single (1 : Fin 3) 2) * x 1 ^ 2 +
          f.coeff (single (2 : Fin 3) 2) * x 2 ^ 2 +
            f.coeff (single (0 : Fin 3) 1 + single 1 1) * x 0 * x 1 +
              f.coeff (single (0 : Fin 3) 1 + single 2 1) * x 0 * x 2 +
                f.coeff (single (1 : Fin 3) 1 + single 2 1) * x 1 * x 2 := by
  simp only [ternaryQuadraticCoeff, Fin.sum_univ_three]
  have h01 : (0 : Fin 3) < 1 := by decide
  have h02 : (0 : Fin 3) < 2 := by decide
  have h12 : (1 : Fin 3) < 2 := by decide
  have n10 : ¬(1 : Fin 3) < 0 := by decide
  have n20 : ¬(2 : Fin 3) < 0 := by decide
  have n21 : ¬(2 : Fin 3) < 1 := by decide
  have n10e : ¬(1 : Fin 3) = 0 := by decide
  have n20e : ¬(2 : Fin 3) = 0 := by decide
  have n21e : ¬(2 : Fin 3) = 1 := by decide
  have n01e : ¬(0 : Fin 3) = 1 := by decide
  have n02e : ¬(0 : Fin 3) = 2 := by decide
  have n12e : ¬(1 : Fin 3) = 2 := by decide
  simp [h01, h02, h12, n10, n20, n21, n10e, n20e, n21e, n01e, n02e, n12e]
  ring

private theorem ne_multiindex_of_apply
    (s t : Fin 3 →₀ ℕ) (i : Fin 3) (h : s i ≠ t i) : s ≠ t :=
  fun heq => h (congr_arg (fun u : Fin 3 →₀ ℕ => u i) heq)

/-- Evaluation of a homogeneous degree-2 ternary polynomial equals its coefficient matrix form. -/
theorem eval_eq_ternaryQuadraticCoeff_sum
    {R : Type u} [CommRing R]
    {f : MvPolynomial (Fin 3) R} (hf : f.IsHomogeneous 2) (x : Fin 3 → R) :
    eval x f = ∑ i : Fin 3, ∑ j : Fin 3, ternaryQuadraticCoeff f i j * x i * x j := by
  classical
  rw [sum_ternaryQuadraticCoeff_eq]
  induction hf using IsWeightedHomogeneous.induction_on with
  | zero => simp
  | add f g _ _ ihf ihg =>
      simp only [eval_add, coeff_add, ihf, ihg]
      ring
  | monomial s a hs =>
      have hsum : ∑ i : Fin 3, s i = 2 := by
        have hw : weight (1 : Fin 3 → ℕ) s = 2 := by convert hs
        simpa [weight_eq_sum] using hw
      rcases degree_two_cases s hsum with rfl | rfl | rfl | rfl | rfl | rfl
      · have n1 : (single (0 : Fin 3) 2 : Fin 3 →₀ ℕ) ≠ single 1 2 :=
          ne_multiindex_of_apply _ _ 0 (by simp)
        have n2 : (single (0 : Fin 3) 2 : Fin 3 →₀ ℕ) ≠ single 2 2 :=
          ne_multiindex_of_apply _ _ 0 (by simp)
        have n3 : (single (0 : Fin 3) 2 : Fin 3 →₀ ℕ) ≠ single 0 1 + single 1 1 :=
          ne_multiindex_of_apply _ _ 0 (by simp [add_apply])
        have n4 : (single (0 : Fin 3) 2 : Fin 3 →₀ ℕ) ≠ single 0 1 + single 2 1 :=
          ne_multiindex_of_apply _ _ 0 (by simp [add_apply])
        have n5 : (single (0 : Fin 3) 2 : Fin 3 →₀ ℕ) ≠ single 1 1 + single 2 1 :=
          ne_multiindex_of_apply _ _ 0 (by simp [add_apply])
        simp [eval_monomial, prod_single_index, n1, n2, n3, n4, n5, pow_two]
      · have n0 : (single (1 : Fin 3) 2 : Fin 3 →₀ ℕ) ≠ single 0 2 :=
          ne_multiindex_of_apply _ _ 1 (by simp)
        have n2 : (single (1 : Fin 3) 2 : Fin 3 →₀ ℕ) ≠ single 2 2 :=
          ne_multiindex_of_apply _ _ 1 (by simp)
        have n3 : (single (1 : Fin 3) 2 : Fin 3 →₀ ℕ) ≠ single 0 1 + single 1 1 :=
          ne_multiindex_of_apply _ _ 1 (by simp [add_apply])
        have n4 : (single (1 : Fin 3) 2 : Fin 3 →₀ ℕ) ≠ single 0 1 + single 2 1 :=
          ne_multiindex_of_apply _ _ 1 (by simp [add_apply])
        have n5 : (single (1 : Fin 3) 2 : Fin 3 →₀ ℕ) ≠ single 1 1 + single 2 1 :=
          ne_multiindex_of_apply _ _ 1 (by simp [add_apply])
        simp [eval_monomial, prod_single_index, n0, n2, n3, n4, n5, pow_two]
      · have n0 : (single (2 : Fin 3) 2 : Fin 3 →₀ ℕ) ≠ single 0 2 :=
          ne_multiindex_of_apply _ _ 2 (by simp)
        have n1 : (single (2 : Fin 3) 2 : Fin 3 →₀ ℕ) ≠ single 1 2 :=
          ne_multiindex_of_apply _ _ 2 (by simp)
        have n3 : (single (2 : Fin 3) 2 : Fin 3 →₀ ℕ) ≠ single 0 1 + single 1 1 :=
          ne_multiindex_of_apply _ _ 2 (by simp [add_apply])
        have n4 : (single (2 : Fin 3) 2 : Fin 3 →₀ ℕ) ≠ single 0 1 + single 2 1 :=
          ne_multiindex_of_apply _ _ 2 (by simp [add_apply])
        have n5 : (single (2 : Fin 3) 2 : Fin 3 →₀ ℕ) ≠ single 1 1 + single 2 1 :=
          ne_multiindex_of_apply _ _ 2 (by simp [add_apply])
        simp [eval_monomial, prod_single_index, n0, n1, n3, n4, n5, pow_two]
      · have n0 : (single (0 : Fin 3) 1 + single 1 1 : Fin 3 →₀ ℕ) ≠ single 0 2 :=
          ne_multiindex_of_apply _ _ 0 (by simp [add_apply])
        have n1 : (single (0 : Fin 3) 1 + single 1 1 : Fin 3 →₀ ℕ) ≠ single 1 2 :=
          ne_multiindex_of_apply _ _ 0 (by simp [add_apply])
        have n2 : (single (0 : Fin 3) 1 + single 1 1 : Fin 3 →₀ ℕ) ≠ single 2 2 :=
          ne_multiindex_of_apply _ _ 0 (by simp [add_apply])
        have n4 : (single (0 : Fin 3) 1 + single 1 1 : Fin 3 →₀ ℕ) ≠ single 0 1 + single 2 1 :=
          ne_multiindex_of_apply _ _ 1 (by simp [add_apply])
        have n5 : (single (0 : Fin 3) 1 + single 1 1 : Fin 3 →₀ ℕ) ≠ single 1 1 + single 2 1 :=
          ne_multiindex_of_apply _ _ 0 (by simp [add_apply])
        rw [eval_monomial, prod_off 0 1 (by decide)]
        simp [n0, n1, n2, n4, n5]
        ring
      · have n0 : (single (0 : Fin 3) 1 + single 2 1 : Fin 3 →₀ ℕ) ≠ single 0 2 :=
          ne_multiindex_of_apply _ _ 0 (by simp [add_apply])
        have n1 : (single (0 : Fin 3) 1 + single 2 1 : Fin 3 →₀ ℕ) ≠ single 1 2 :=
          ne_multiindex_of_apply _ _ 0 (by simp [add_apply])
        have n2 : (single (0 : Fin 3) 1 + single 2 1 : Fin 3 →₀ ℕ) ≠ single 2 2 :=
          ne_multiindex_of_apply _ _ 0 (by simp [add_apply])
        have n3 : (single (0 : Fin 3) 1 + single 2 1 : Fin 3 →₀ ℕ) ≠ single 0 1 + single 1 1 :=
          ne_multiindex_of_apply _ _ 1 (by simp [add_apply])
        have n5 : (single (0 : Fin 3) 1 + single 2 1 : Fin 3 →₀ ℕ) ≠ single 1 1 + single 2 1 :=
          ne_multiindex_of_apply _ _ 0 (by simp [add_apply])
        rw [eval_monomial, prod_off 0 2 (by decide)]
        simp [n0, n1, n2, n3, n5]
        ring
      · have n0 : (single (1 : Fin 3) 1 + single 2 1 : Fin 3 →₀ ℕ) ≠ single 0 2 :=
          ne_multiindex_of_apply _ _ 1 (by simp [add_apply])
        have n1 : (single (1 : Fin 3) 1 + single 2 1 : Fin 3 →₀ ℕ) ≠ single 1 2 :=
          ne_multiindex_of_apply _ _ 1 (by simp [add_apply])
        have n2 : (single (1 : Fin 3) 1 + single 2 1 : Fin 3 →₀ ℕ) ≠ single 2 2 :=
          ne_multiindex_of_apply _ _ 1 (by simp [add_apply])
        have n3 : (single (1 : Fin 3) 1 + single 2 1 : Fin 3 →₀ ℕ) ≠ single 0 1 + single 1 1 :=
          ne_multiindex_of_apply _ _ 0 (by simp [add_apply])
        have n4 : (single (1 : Fin 3) 1 + single 2 1 : Fin 3 →₀ ℕ) ≠ single 0 1 + single 2 1 :=
          ne_multiindex_of_apply _ _ 0 (by simp [add_apply])
        rw [eval_monomial, prod_off 1 2 (by decide)]
        simp [n0, n1, n2, n3, n4]
        ring

/-! ### Ring-level stereographic second intersection -/

/-- Polar form of a homogeneous ternary quadratic: `B(p,w) = Q(p+w) - Q(p) - Q(w)`. -/
def polarEval {R : Type u} [CommRing R]
    (f : MvPolynomial (Fin 3) R) (p w : Fin 3 → R) : R :=
  eval (fun j => p j + w j) f - eval p f - eval w f

/-- Algebraic stereo second-intersection: `Q(w) · p − B(p,w) · w`.

Works over any commutative ring (no `Field`/`QuadraticForm` required). -/
def stereoAlg {R : Type u} [CommRing R]
    (f : MvPolynomial (Fin 3) R) (p w : Fin 3 → R) : Fin 3 → R :=
  fun i => eval w f * p i - polarEval f p w * w i

theorem polarEval_eq_coeff_sum {R : Type u} [CommRing R]
    (f : MvPolynomial (Fin 3) R) (hf : f.IsHomogeneous 2)
    (p w : Fin 3 → R) :
    polarEval f p w =
      ∑ i : Fin 3, ∑ j : Fin 3,
        ternaryQuadraticCoeff f i j * (p i * w j + w i * p j) := by
  have hp := eval_eq_ternaryQuadraticCoeff_sum hf p
  have hw := eval_eq_ternaryQuadraticCoeff_sum hf w
  have hpw := eval_eq_ternaryQuadraticCoeff_sum hf (fun j => p j + w j)
  simp only [polarEval, hp, hw, hpw, Fin.sum_univ_three]
  ring

/-- Evaluation of the stereo image: `Q(stereo) = Q(w)² · Q(p)`. -/
theorem eval_stereoAlg {R : Type u} [CommRing R]
    (f : MvPolynomial (Fin 3) R) (hf : f.IsHomogeneous 2)
    (p w : Fin 3 → R) :
    eval (stereoAlg f p w) f =
      eval w f * eval w f * eval p f := by
  let α := eval w f
  let β := -polarEval f p w
  have hvec : stereoAlg f p w = fun i => α * p i + β * w i := by
    funext i
    simp only [stereoAlg, α, β]
    ring
  rw [hvec]
  have hp := eval_eq_ternaryQuadraticCoeff_sum hf p
  have hw := eval_eq_ternaryQuadraticCoeff_sum hf w
  have hαβ := eval_eq_ternaryQuadraticCoeff_sum hf (fun i => α * p i + β * w i)
  have hpol := polarEval_eq_coeff_sum f hf p w
  rw [hαβ]
  have hexpand :
      (∑ i : Fin 3, ∑ j : Fin 3,
          ternaryQuadraticCoeff f i j * (α * p i + β * w i) * (α * p j + β * w j)) =
        α * α * (∑ i : Fin 3, ∑ j : Fin 3, ternaryQuadraticCoeff f i j * p i * p j) +
          α * β * (∑ i : Fin 3, ∑ j : Fin 3,
            ternaryQuadraticCoeff f i j * (p i * w j + w i * p j)) +
            β * β * (∑ i : Fin 3, ∑ j : Fin 3, ternaryQuadraticCoeff f i j * w i * w j) := by
    simp only [Fin.sum_univ_three]
    ring
  rw [hexpand, ← hp, ← hw, ← hpol]
  simp only [α, β]
  ring

/-- Stereo lands on the isotropic cone when the base point is isotropic. -/
theorem stereoAlg_isotropic {R : Type u} [CommRing R]
    (f : MvPolynomial (Fin 3) R) (hf : f.IsHomogeneous 2)
    (p w : Fin 3 → R) (hp : eval p f = 0) :
    eval (stereoAlg f p w) f = 0 := by
  rw [eval_stereoAlg f hf p w, hp, mul_zero]

end

end BConicBundleMultisections
