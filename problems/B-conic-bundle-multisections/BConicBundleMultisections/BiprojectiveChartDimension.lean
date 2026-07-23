/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.BiprojectiveDehomogenization
public import BConicBundleMultisections.MvPolynomialDimension

/-!
# Krull dimension of standard biprojective charts

This file transports domain, Noetherian, and Krull-dimension results through the equivalence
between a standard chart of `ProjectiveSpace m R × ProjectiveSpace n R` and the polynomial ring
`MvPolynomial (Fin m ⊕ Fin n) R`.

It also proves that a nonzero nonunit chart equation generates a height-one ideal over a
Noetherian domain. Over a field, its quotient has Krull dimension exactly `m + n - 1` when
`0 < m + n`.

## Main results

* `BiprojectiveSpace.ringKrullDim_standardChartRing`: the dimension formula over a Noetherian
  base ring.
* `BiprojectiveSpace.height_span_chartEquation_eq_one`: a nonzero nonunit bihomogeneous chart
  equation generates a height-one ideal.
* `BiprojectiveSpace.ringKrullDim_quotient_chartEquation_eq_of_field`: the exact dimension of a
  hypersurface chart over a field.
-/

@[expose] public section

open scoped nonZeroDivisors

namespace BConicBundleMultisections

noncomputable section

universe u

namespace BiprojectiveSpace

variable (m n : ℕ) (R : Type u) [CommRing R]
variable (i : Fin (m + 1)) (j : Fin (n + 1))

/-- A standard biprojective chart over a domain is a domain. -/
instance [IsDomain R] : IsDomain (StandardChartRing m n R i j) :=
  (standardChartRingEquivMvPolynomial m n R i j).toRingEquiv.toMulEquiv.isDomain _

/-- A standard biprojective chart over a Noetherian ring is Noetherian. -/
instance [IsNoetherianRing R] : IsNoetherianRing (StandardChartRing m n R i j) :=
  isNoetherianRing_of_ringEquiv (MvPolynomial (Fin m ⊕ Fin n) R)
    (standardChartRingEquivMvPolynomial m n R i j).symm.toRingEquiv

/-- The Krull dimension of a standard biprojective chart is the dimension of the base plus the
dimensions of the two projective-space factors. -/
theorem ringKrullDim_standardChartRing [IsNoetherianRing R] :
    ringKrullDim (StandardChartRing m n R i j) =
      ringKrullDim R + (m + n : ℕ) := by
  rw [ringKrullDim_eq_of_ringEquiv
    (standardChartRingEquivMvPolynomial m n R i j).toRingEquiv,
    MvPolynomial.ringKrullDim_of_isNoetherianRing]
  simp

/-- A standard biprojective chart over a field has dimension `m + n`. -/
theorem ringKrullDim_standardChartRing_of_field
    (k : Type u) [Field k]
    (i : Fin (m + 1)) (j : Fin (n + 1)) :
    ringKrullDim (StandardChartRing m n k i j) = (m + n : ℕ) := by
  rw [ringKrullDim_standardChartRing, ringKrullDim_eq_zero_of_field]
  simp

/-- Every maximal ideal of a standard biprojective chart over a field has full height. -/
theorem height_eq_add_of_isMaximal_standardChartRing
    (k : Type u) [Field k]
    (i : Fin (m + 1)) (j : Fin (n + 1))
    (M : Ideal (StandardChartRing m n k i j)) [M.IsMaximal] :
    M.height = (m + n : ℕ) := by
  let e := (standardChartRingEquivMvPolynomial m n k i j).toRingEquiv
  have h := MvPolynomial.height_eq_natCard_of_isMaximal (M.map e)
  rw [e.height_map M] at h
  simpa using h

variable [IsDomain R]

/-- A nonzero element of a standard chart over a domain is a non-zero-divisor. -/
theorem mem_nonZeroDivisors_standardChartRing
    (f : StandardChartRing m n R i j) (hf : f ≠ 0) :
    f ∈ nonZeroDivisors (StandardChartRing m n R i j) :=
  mem_nonZeroDivisors_of_ne_zero hf

/-- A nonzero nonunit in a standard chart over a Noetherian domain generates a height-one
ideal. -/
theorem height_span_singleton_eq_one_standardChartRing
    [IsNoetherianRing R]
    (f : StandardChartRing m n R i j) (hf : f ≠ 0) (hfu : ¬ IsUnit f) :
    (Ideal.span {f}).height = 1 :=
  Ideal.height_span_singleton_eq_one_of_mem_nonZeroDivisors
    (mem_nonZeroDivisors_standardChartRing m n R i j f hf) hfu

/-- Quotienting a standard chart over a Noetherian domain by a nonzero element lowers its
dimension by at least one. -/
theorem ringKrullDim_quotient_span_singleton_add_one_le
    [IsNoetherianRing R]
    (f : StandardChartRing m n R i j) (hf : f ≠ 0) :
    ringKrullDim ((StandardChartRing m n R i j) ⧸ Ideal.span {f}) + 1 ≤
      ringKrullDim R + (m + n : ℕ) := by
  rw [← ringKrullDim_standardChartRing m n R i j]
  exact ringKrullDim_quotient_succ_le_of_nonZeroDivisor
    (mem_nonZeroDivisors_standardChartRing m n R i j f hf)

/-- If the base has dimension zero, quotienting a positive-dimensional standard chart by a
nonzero element gives dimension at most `m + n - 1`. -/
theorem ringKrullDim_quotient_span_singleton_le
    [IsNoetherianRing R]
    (f : StandardChartRing m n R i j) (hf : f ≠ 0)
    (hR : ringKrullDim R = 0) (hmn : 0 < m + n) :
    ringKrullDim ((StandardChartRing m n R i j) ⧸ Ideal.span {f}) ≤
      (m + n - 1 : ℕ) := by
  have h := ringKrullDim_quotient_span_singleton_add_one_le m n R i j f hf
  rw [hR, zero_add] at h
  have hlt : ringKrullDim ((StandardChartRing m n R i j) ⧸ Ideal.span {f}) <
      (m + n : ℕ) := ENat.WithBot.add_one_le_natCast_iff.mp h
  have hone : 1 ≤ m + n := hmn
  rw [show m + n = (m + n - 1) + 1 by omega, Nat.cast_add, Nat.cast_one,
    ENat.WithBot.lt_add_one_iff] at hlt
  exact hlt

/-- Over a field, quotienting a positive-dimensional standard chart by a nonzero element gives
dimension at most `m + n - 1`. -/
theorem ringKrullDim_quotient_span_singleton_le_of_field
    (k : Type u) [Field k]
    (i : Fin (m + 1)) (j : Fin (n + 1))
    (f : StandardChartRing m n k i j) (hf : f ≠ 0) (hmn : 0 < m + n) :
    ringKrullDim ((StandardChartRing m n k i j) ⧸ Ideal.span {f}) ≤
      (m + n - 1 : ℕ) :=
  ringKrullDim_quotient_span_singleton_le m n k i j f hf
    (ringKrullDim_eq_zero_of_field k) hmn

/-- Over a field, quotienting a standard chart by a nonzero nonunit lowers Krull dimension by
exactly one, in successor form. -/
theorem ringKrullDim_quotient_span_singleton_add_one_eq_of_field
    (k : Type u) [Field k]
    (i : Fin (m + 1)) (j : Fin (n + 1))
    (f : StandardChartRing m n k i j) (hf : f ≠ 0) (hfu : ¬ IsUnit f) :
    ringKrullDim ((StandardChartRing m n k i j) ⧸ Ideal.span {f}) + 1 =
      (m + n : ℕ) := by
  obtain ⟨M, hM, hfM⟩ := Ideal.exists_le_maximal (Ideal.span {f})
    (Ideal.span_singleton_ne_top hfu)
  letI : M.IsMaximal := hM
  letI : M.IsPrime := hM.isPrime
  have hdim := ringKrullDim_standardChartRing_of_field m n k i j
  have hheight : (M.height : WithBot ℕ∞) =
      ringKrullDim (StandardChartRing m n k i j) := by
    rw [height_eq_add_of_isMaximal_standardChartRing m n k i j M, hdim]
    simp
  rw [← hdim]
  apply Module.ringKrullDim_quotient_add_one_of_mem_nonZeroDivisors (p := M)
    (mem_nonZeroDivisors_of_ne_zero hf) hheight
  exact hfM (Ideal.subset_span (Set.mem_singleton f))

/-- Over a field, quotienting a positive-dimensional standard chart by a nonzero nonunit lowers
Krull dimension by exactly one. -/
theorem ringKrullDim_quotient_span_singleton_eq_of_field
    (k : Type u) [Field k]
    (i : Fin (m + 1)) (j : Fin (n + 1))
    (f : StandardChartRing m n k i j) (hf : f ≠ 0) (hfu : ¬ IsUnit f)
    (hmn : 0 < m + n) :
    ringKrullDim ((StandardChartRing m n k i j) ⧸ Ideal.span {f}) =
      (m + n - 1 : ℕ) := by
  have h := ringKrullDim_quotient_span_singleton_add_one_eq_of_field
    m n k i j f hf hfu
  rw [show m + n = (m + n - 1) + 1 by omega,
    Nat.cast_add, Nat.cast_one] at h
  exact ENat.WithBot.add_one_cancel.mp h

/-- A nonzero bihomogeneous chart equation over a Noetherian domain cuts out a height-one
principal ideal, provided the chart equation is not a unit. -/
theorem height_span_chartEquation_eq_one
    [IsNoetherianRing R]
    {d e : ℕ} (F : MvPolynomial (BiprojectiveCoordinate m n) R)
    (hF : IsBihomogeneousOfBidegree d e F) (hF0 : F ≠ 0)
    (hunit : ¬ IsUnit (chartEquation m n R i j F)) :
    (Ideal.span {chartEquation m n R i j F}).height = 1 :=
  height_span_singleton_eq_one_standardChartRing m n R i j
    (chartEquation m n R i j F)
    (chartEquation_ne_zero m n R i j F hF hF0) hunit

/-- A nonzero nonunit bihomogeneous chart equation over a field has quotient dimension
`m + n - 1`. -/
theorem ringKrullDim_quotient_chartEquation_eq_of_field
    (k : Type u) [Field k]
    (i : Fin (m + 1)) (j : Fin (n + 1))
    {d e : ℕ} (F : MvPolynomial (BiprojectiveCoordinate m n) k)
    (hF : IsBihomogeneousOfBidegree d e F) (hF0 : F ≠ 0)
    (hunit : ¬ IsUnit (chartEquation m n k i j F))
    (hmn : 0 < m + n) :
    ringKrullDim
        ((StandardChartRing m n k i j) ⧸ Ideal.span {chartEquation m n k i j F}) =
      (m + n - 1 : ℕ) :=
  ringKrullDim_quotient_span_singleton_eq_of_field m n k i j
    (chartEquation m n k i j F)
    (chartEquation_ne_zero m n k i j F hF hF0) hunit hmn

end BiprojectiveSpace

end

end BConicBundleMultisections
