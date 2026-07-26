/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import Mathlib.RingTheory.MvPolynomial.WeightedHomogeneous

/-!
# Low weighted-degree components of products

Elementary component lemmas used to read the `y`-degree-one part of a bihomogeneous ideal
identity.  If one factor is homogeneous of weighted degree `d`, its product has no component below
`d`; at degree exactly `d`, only the degree-zero component of the other factor contributes.
-/

@[expose] public section

namespace BConicBundleMultisections

noncomputable section

open MvPolynomial

universe u v

variable {σ : Type u} {R : Type v} [CommRing R]

/-- Multiplication by a weighted-homogeneous polynomial of degree `d` creates no component in a
strictly smaller degree. -/
theorem weightedHomogeneousComponent_mul_right_eq_zero_of_lt
    (w : σ → ℕ) (A H : MvPolynomial σ R) (d n : ℕ)
    (hH : H.IsWeightedHomogeneous w d) (hnd : n < d) :
    weightedHomogeneousComponent w n (A * H) = 0 := by
  classical
  apply weightedHomogeneousComponent_eq_zero'
  intro m hm hmn
  have hc : coeff m (A * H) ≠ 0 := mem_support_iff.mp hm
  rw [coeff_mul] at hc
  obtain ⟨⟨a, b⟩, hab, hab0⟩ := Finset.exists_ne_zero_of_sum_ne_zero hc
  have ha0 : coeff a A ≠ 0 := by
    intro ha
    simp [ha] at hab0
  have hb0 : coeff b H ≠ 0 := by
    intro hb
    simp [hb] at hab0
  have hbdeg : Finsupp.weight w b = d := hH hb0
  have hmadd : m = a + b := by simpa [eq_comm] using hab
  have hmdeg : Finsupp.weight w m = Finsupp.weight w a + d := by
    rw [hmadd, map_add, hbdeg]
  omega

/-- In weighted degree exactly `d`, multiplication by a homogeneous degree-`d` polynomial sees
only the degree-zero component of the other factor. -/
theorem weightedHomogeneousComponent_mul_right_eq_zeroComponent_mul
    (w : σ → ℕ) (A H : MvPolynomial σ R) (d : ℕ)
    (hH : H.IsWeightedHomogeneous w d) :
    weightedHomogeneousComponent w d (A * H) =
      weightedHomogeneousComponent w 0 A * H := by
  classical
  ext m
  rw [coeff_weightedHomogeneousComponent, coeff_mul]
  by_cases hm : Finsupp.weight w m = d
  · rw [if_pos hm, coeff_mul]
    apply Finset.sum_congr rfl
    rintro ⟨a, b⟩ hab
    by_cases hb0 : coeff b H = 0
    · simp [hb0]
    have hbdeg : Finsupp.weight w b = d := hH hb0
    have habadd : a + b = m := by simpa using hab
    have hadeg : Finsupp.weight w a = 0 := by
      have hweights := congrArg (Finsupp.weight w) habadd
      rw [map_add, hbdeg, hm] at hweights
      omega
    rw [coeff_weightedHomogeneousComponent, if_pos hadeg]
  · rw [if_neg hm]
    have hprod :
        (weightedHomogeneousComponent w 0 A * H).IsWeightedHomogeneous w d := by
      have h0 := weightedHomogeneousComponent_isWeightedHomogeneous
        (w := w) 0 A
      simpa using h0.mul hH
    by_contra hc
    have hc' : coeff m (weightedHomogeneousComponent w 0 A * H) ≠ 0 :=
      fun hz => hc hz.symm
    exact hm (hprod hc')

end

end BConicBundleMultisections
