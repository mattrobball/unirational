/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.BiprojectiveSmoothCriterion
public import BConicBundleMultisections.MainTheorem

/-!
# An explicit smooth bidegree-`(2,3)` hypersurface in `ℙ² × ℙ²`

The headline theorem `smooth_bidegree23_hasUnirationalParametrization` carries a
`[Smooth (Bidegree23ZeroLocus.toSpec k F)]` instance hypothesis.  Nothing else in the development
produces such an instance, so nothing else in the development can tell whether the hypothesis is
satisfiable — and a vacuous theorem passes every `#print axioms` and every `sorry` census
unchanged.  This file removes that possibility: it exhibits a concrete `F`, proves it smooth, and
applies the headline theorem to it.

## The example, and why the obvious candidate fails

The obvious first try is the Fermat-type form `x₀²y₀³ + x₁²y₁³ + x₂²y₂³`.  **It is singular.**
Its six Cox partials are `2xᵢyᵢ³` and `3xᵢ²yᵢ²`; at `x = (1,0,0)`, `y = (0,1,0)` every one of them
vanishes, as does the form itself, and `([1:0:0], [0:1:0])` is an honest point of `ℙ² × ℙ²`.  The
same collapse happens for any "permutation" form `∑ᵢ xᵢ² y_{π i}³`: setting one `xᵢ = 1` and the
rest to `0` kills every term involving another `x`, and the surviving `y` can then be chosen to
kill what is left.

The fix is to couple every `x` to every `y`.  Take

```
F = ∑_{i,l} C_{i l} · xᵢ² · y_l³,     C = ⎡1 1 1⎤
                                          ⎢1 2 4⎥
                                          ⎣1 3 9⎦
```

the Vandermonde matrix of the nodes `1, 2, 3`.  Writing `uᵢ = xᵢ²` and `v_l = y_l³`, the gradient
of `F` vanishes exactly when `uᵢ · (C v)ᵢ = 0` for every `i` and `v_l · (Cᵀ u)_l = 0` for every
`l`, that is, when the support of `u` avoids the support of `C v` and the support of `v` avoids
that of `Cᵀ u`.  Every square submatrix of `C` is invertible, so this forces `u = 0` or `v = 0`,
i.e. `x = 0` or `y = 0`: no point of `ℙ² × ℙ²` is singular.

`gradient_eq_zero_imp` runs that argument as an explicit case analysis, organized by which of
`y₀, y₁, y₂` vanish.  Only characteristic zero and three Vandermonde solves are used.
-/

@[expose] public section

open CategoryTheory
open scoped AlgebraicGeometry

namespace BConicBundleMultisections

noncomputable section

universe u

-- `_root_` is needed: this project also has namespaces `BConicBundleMultisections.MvPolynomial`
-- and `BConicBundleMultisections.AlgebraicGeometry`, which would shadow the Mathlib ones here.
open _root_.AlgebraicGeometry _root_.MvPolynomial BiprojectiveSpace

namespace Bidegree23Example

variable (k : Type u) [Field k]

/-- An explicit bidegree-`(2,3)` form on `ℙ² × ℙ²`: `∑_{i,l} C_{i l} xᵢ² y_l³` with `C` the
Vandermonde matrix of the nodes `1, 2, 3`.  Every square submatrix of `C` is invertible, which is
what makes the zero locus smooth. -/
def F : MvPolynomial (BiprojectiveCoordinate 2 2) k :=
    C 1 * (X (Sum.inl 0) ^ 2 * X (Sum.inr 0) ^ 3)
  + C 1 * (X (Sum.inl 0) ^ 2 * X (Sum.inr 1) ^ 3)
  + C 1 * (X (Sum.inl 0) ^ 2 * X (Sum.inr 2) ^ 3)
  + C 1 * (X (Sum.inl 1) ^ 2 * X (Sum.inr 0) ^ 3)
  + C 2 * (X (Sum.inl 1) ^ 2 * X (Sum.inr 1) ^ 3)
  + C 4 * (X (Sum.inl 1) ^ 2 * X (Sum.inr 2) ^ 3)
  + C 1 * (X (Sum.inl 2) ^ 2 * X (Sum.inr 0) ^ 3)
  + C 3 * (X (Sum.inl 2) ^ 2 * X (Sum.inr 1) ^ 3)
  + C 9 * (X (Sum.inl 2) ^ 2 * X (Sum.inr 2) ^ 3)

/-- Each monomial `c · xᵢ² · y_l³` is bihomogeneous of bidegree `(2,3)`. -/
theorem isBidegree23_monomial {m n : ℕ} (i : Fin (m + 1)) (l : Fin (n + 1)) (c : k) :
    IsBihomogeneousOfBidegree (m := m) (n := n) 2 3
      (C c * (X (Sum.inl i) ^ 2 * X (Sum.inr l) ^ 3)) := by
  have hdeg : (2 : ℕ) • (bidegreeWeight (m := m) (n := n) (Sum.inl i)) +
      (3 : ℕ) • (bidegreeWeight (m := m) (n := n) (Sum.inr l)) = ((2 : ℕ), (3 : ℕ)) := rfl
  have h :=
    (((isWeightedHomogeneous_X k (bidegreeWeight (m := m) (n := n)) (Sum.inl i)).pow 2).mul
      ((isWeightedHomogeneous_X k (bidegreeWeight (m := m) (n := n)) (Sum.inr l)).pow 3)).C_mul c
  rwa [hdeg] at h

/-- The example form has bidegree `(2,3)`. -/
theorem isBidegree23_F : IsBidegree23 (F k) :=
  ((((((((isBidegree23_monomial k 0 0 1).add (isBidegree23_monomial k 0 1 1)).add
    (isBidegree23_monomial k 0 2 1)).add (isBidegree23_monomial k 1 0 1)).add
    (isBidegree23_monomial k 1 1 2)).add (isBidegree23_monomial k 1 2 4)).add
    (isBidegree23_monomial k 2 0 1)).add (isBidegree23_monomial k 2 1 3)).add
    (isBidegree23_monomial k 2 2 9)

/-- Value of the example form at a pair of coordinate vectors. -/
theorem eval_F (x y : Fin 3 → k) :
    eval (Sum.elim x y) (F k) =
      x 0 ^ 2 * (y 0 ^ 3 + y 1 ^ 3 + y 2 ^ 3)
        + x 1 ^ 2 * (y 0 ^ 3 + 2 * y 1 ^ 3 + 4 * y 2 ^ 3)
        + x 2 ^ 2 * (y 0 ^ 3 + 3 * y 1 ^ 3 + 9 * y 2 ^ 3) := by
  simp [F]; ring

/-- The `x₀`-partial of the example form. -/
theorem eval_pderiv_x0 (x y : Fin 3 → k) :
    eval (Sum.elim x y) (pderiv (Sum.inl 0) (F k)) =
      2 * x 0 * (y 0 ^ 3 + y 1 ^ 3 + y 2 ^ 3) := by
  simp [F]; ring

/-- The `x₁`-partial of the example form. -/
theorem eval_pderiv_x1 (x y : Fin 3 → k) :
    eval (Sum.elim x y) (pderiv (Sum.inl 1) (F k)) =
      2 * x 1 * (y 0 ^ 3 + 2 * y 1 ^ 3 + 4 * y 2 ^ 3) := by
  simp [F]; ring

/-- The `x₂`-partial of the example form. -/
theorem eval_pderiv_x2 (x y : Fin 3 → k) :
    eval (Sum.elim x y) (pderiv (Sum.inl 2) (F k)) =
      2 * x 2 * (y 0 ^ 3 + 3 * y 1 ^ 3 + 9 * y 2 ^ 3) := by
  simp [F]; ring

/-- The `y₀`-partial of the example form. -/
theorem eval_pderiv_y0 (x y : Fin 3 → k) :
    eval (Sum.elim x y) (pderiv (Sum.inr 0) (F k)) =
      3 * y 0 ^ 2 * (x 0 ^ 2 + x 1 ^ 2 + x 2 ^ 2) := by
  simp [F]; ring

/-- The `y₁`-partial of the example form. -/
theorem eval_pderiv_y1 (x y : Fin 3 → k) :
    eval (Sum.elim x y) (pderiv (Sum.inr 1) (F k)) =
      3 * y 1 ^ 2 * (x 0 ^ 2 + 2 * x 1 ^ 2 + 3 * x 2 ^ 2) := by
  simp [F]; ring

/-- The `y₂`-partial of the example form. -/
theorem eval_pderiv_y2 (x y : Fin 3 → k) :
    eval (Sum.elim x y) (pderiv (Sum.inr 2) (F k)) =
      3 * y 2 ^ 2 * (x 0 ^ 2 + 4 * x 1 ^ 2 + 9 * x 2 ^ 2) := by
  simp [F]; ring

/-- The example form is nonzero: it takes the value `1` at `x = y = (1,0,0)`. -/
theorem F_ne_zero : F k ≠ 0 := by
  intro h
  set p : Fin 3 → k := fun i => if i = 0 then 1 else 0 with hp
  have hp0 : p 0 = 1 := by simp [hp]
  have hp1 : p 1 = 0 := by simp [hp]
  have hp2 : p 2 = 0 := by simp [hp]
  have h1 : eval (Sum.elim p p) (F k) = 1 := by
    rw [eval_F, hp0, hp1, hp2]; ring
  rw [h] at h1
  simp at h1

section Algebra

variable {k} [NeZero (2 : k)] [NeZero (3 : k)]

/-- The Vandermonde system of the nodes `1, 2, 3` in the `y`-cubes has only the trivial
solution. -/
private theorem solveA {p q r : k}
    (h0 : p + q + r = 0) (h1 : p + 2 * q + 4 * r = 0) (h2 : p + 3 * q + 9 * r = 0) :
    p = 0 ∧ q = 0 ∧ r = 0 := by
  have hr2 : (2 : k) * r = 0 := by linear_combination h0 - 2 * h1 + h2
  have hr : r = 0 := (mul_eq_zero.mp hr2).resolve_left two_ne_zero
  have hq : q = 0 := by linear_combination h1 - h0 - 3 * hr
  have hp : p = 0 := by linear_combination h0 - hq - hr
  exact ⟨hp, hq, hr⟩

/-- The transposed Vandermonde system in the `x`-squares has only the trivial solution. -/
private theorem solveB {s t w : k}
    (h0 : s + t + w = 0) (h1 : s + 2 * t + 3 * w = 0) (h2 : s + 4 * t + 9 * w = 0) :
    s = 0 ∧ t = 0 ∧ w = 0 := by
  have hw2 : (2 : k) * w = 0 := by linear_combination 2 * h0 - 3 * h1 + h2
  have hw : w = 0 := (mul_eq_zero.mp hw2).resolve_left two_ne_zero
  have ht : t = 0 := by linear_combination h1 - h0 - 2 * hw
  have hs : s = 0 := by linear_combination h0 - ht - hw
  exact ⟨hs, ht, hw⟩

omit [NeZero (2 : k)] [NeZero (3 : k)] in
/-- Coordinatewise vanishing gives vanishing of a vector in `Fin 3 → k`. -/
private theorem fin3_eq_zero {x : Fin 3 → k}
    (h0 : x 0 = 0) (h1 : x 1 = 0) (h2 : x 2 = 0) : x = 0 := by
  funext i
  fin_cases i
  · exact h0
  · exact h1
  · exact h2

omit [NeZero (2 : k)] [NeZero (3 : k)] in
/-- Vanishing of the squares gives vanishing of a vector in `Fin 3 → k`. -/
private theorem fin3_eq_zero_of_sq {x : Fin 3 → k}
    (h0 : x 0 ^ 2 = 0) (h1 : x 1 ^ 2 = 0) (h2 : x 2 ^ 2 = 0) : x = 0 :=
  fin3_eq_zero (pow_eq_zero_iff (two_ne_zero' ℕ) |>.mp h0)
    (pow_eq_zero_iff (two_ne_zero' ℕ) |>.mp h1)
    (pow_eq_zero_iff (two_ne_zero' ℕ) |>.mp h2)

/-- Splitting `2ab = 0` in characteristic zero. -/
private theorem two_mul_mul_eq_zero {a b : k} (h : 2 * a * b = 0) : a = 0 ∨ b = 0 := by
  rcases mul_eq_zero.mp h with h' | h'
  · exact Or.inl ((mul_eq_zero.mp h').resolve_left two_ne_zero)
  · exact Or.inr h'

/-- Splitting `3a²b = 0` in characteristic zero. -/
private theorem three_sq_mul_eq_zero {a b : k} (h : 3 * a ^ 2 * b = 0) : a = 0 ∨ b = 0 := by
  rcases mul_eq_zero.mp h with h' | h'
  · exact Or.inl (pow_eq_zero_iff (two_ne_zero' ℕ) |>.mp
      ((mul_eq_zero.mp h').resolve_left (by norm_num)))
  · exact Or.inr h'

end Algebra

section Witness

variable {k} [NeZero (2 : k)] [NeZero (3 : k)]

/-- **The gradient of the example form vanishes only on the two forbidden coordinate
subspaces.**

This is exactly the hypothesis of `smooth_biprojectiveZeroLocusToSpec_of_gradient`, verified for
`F`.  The proof splits on which of `y₀, y₁, y₂` vanish.

* All three nonzero: the three `y`-partials give the full transposed Vandermonde system in the
  `x`-squares, forcing `x = 0`.
* Exactly one nonzero: each of the three `x`-partials has a nonzero cofactor, because the
  corresponding column of `C` has no zero entry; again `x = 0`.
* Exactly two nonzero: two of the `y`-partials pin the `x`-squares to a line through the origin.
  Either the line degenerates to the origin and `x = 0`, or all three `xᵢ` are nonzero — and then
  the three `x`-partials give the full Vandermonde system in the `y`-cubes, forcing `y = 0`,
  contradicting the case assumption. -/
theorem gradient_eq_zero_imp (x y : Fin 3 → k)
    (h : ∀ z : BiprojectiveCoordinate 2 2,
      eval (Sum.elim x y) (pderiv z (F k)) = 0) :
    x = 0 ∨ y = 0 := by
  -- The six scalar gradient equations, split into disjunctions.
  have hA0 : x 0 = 0 ∨ y 0 ^ 3 + y 1 ^ 3 + y 2 ^ 3 = 0 :=
    two_mul_mul_eq_zero (by rw [← eval_pderiv_x0]; exact h _)
  have hA1 : x 1 = 0 ∨ y 0 ^ 3 + 2 * y 1 ^ 3 + 4 * y 2 ^ 3 = 0 :=
    two_mul_mul_eq_zero (by rw [← eval_pderiv_x1]; exact h _)
  have hA2 : x 2 = 0 ∨ y 0 ^ 3 + 3 * y 1 ^ 3 + 9 * y 2 ^ 3 = 0 :=
    two_mul_mul_eq_zero (by rw [← eval_pderiv_x2]; exact h _)
  have hB0 : y 0 = 0 ∨ x 0 ^ 2 + x 1 ^ 2 + x 2 ^ 2 = 0 :=
    three_sq_mul_eq_zero (by rw [← eval_pderiv_y0]; exact h _)
  have hB1 : y 1 = 0 ∨ x 0 ^ 2 + 2 * x 1 ^ 2 + 3 * x 2 ^ 2 = 0 :=
    three_sq_mul_eq_zero (by rw [← eval_pderiv_y1]; exact h _)
  have hB2 : y 2 = 0 ∨ x 0 ^ 2 + 4 * x 1 ^ 2 + 9 * x 2 ^ 2 = 0 :=
    three_sq_mul_eq_zero (by rw [← eval_pderiv_y2]; exact h _)
  -- If all three `xᵢ` are nonzero, the `y`-cubes solve the Vandermonde system, so `y = 0`.
  have hallx : x 0 ≠ 0 → x 1 ≠ 0 → x 2 ≠ 0 →
      y 0 ^ 3 = 0 ∧ y 1 ^ 3 = 0 ∧ y 2 ^ 3 = 0 := fun h0 h1 h2 =>
    solveA (hA0.resolve_left h0) (hA1.resolve_left h1) (hA2.resolve_left h2)
  rcases eq_or_ne (y 0) 0 with hy0 | hy0
  · rcases eq_or_ne (y 1) 0 with hy1 | hy1
    · rcases eq_or_ne (y 2) 0 with hy2 | hy2
      · -- `y = 0`.
        exact Or.inr (fin3_eq_zero hy0 hy1 hy2)
      · -- only `y₂ ≠ 0`: the third column `(1,4,9)` of `C` has no zero entry.
        have hp : y 0 ^ 3 = 0 := by rw [hy0]; ring
        have hq : y 1 ^ 3 = 0 := by rw [hy1]; ring
        have hr : y 2 ^ 3 ≠ 0 := pow_ne_zero 3 hy2
        refine Or.inl (fin3_eq_zero (hA0.resolve_right ?_) (hA1.resolve_right ?_)
          (hA2.resolve_right ?_))
        · exact fun hc => hr (by linear_combination hc - hp - hq)
        · exact fun hc => hr (by linear_combination (hc - hp - 2 * hq) / 4)
        · exact fun hc => hr (by linear_combination (hc - hp - 3 * hq) / 9)
    · rcases eq_or_ne (y 2) 0 with hy2 | hy2
      · -- only `y₁ ≠ 0`: the second column `(1,2,3)` of `C` has no zero entry.
        have hp : y 0 ^ 3 = 0 := by rw [hy0]; ring
        have hr : y 2 ^ 3 = 0 := by rw [hy2]; ring
        have hq : y 1 ^ 3 ≠ 0 := pow_ne_zero 3 hy1
        refine Or.inl (fin3_eq_zero (hA0.resolve_right ?_) (hA1.resolve_right ?_)
          (hA2.resolve_right ?_))
        · exact fun hc => hq (by linear_combination hc - hp - hr)
        · exact fun hc => hq (by linear_combination (hc - hp - 4 * hr) / 2)
        · exact fun hc => hq (by linear_combination (hc - hp - 9 * hr) / 3)
      · -- `y₁ ≠ 0` and `y₂ ≠ 0`: rows `1` and `2` of `Cᵀ` pin the `x`-squares to a line.
        have hb1 := hB1.resolve_left hy1
        have hb2 := hB2.resolve_left hy2
        rcases eq_or_ne (x 2) 0 with hx2 | hx2
        · have hw : x 2 ^ 2 = 0 := by rw [hx2]; ring
          have ht : x 1 ^ 2 = 0 := by linear_combination (hb2 - hb1 - 6 * hw) / 2
          have hs : x 0 ^ 2 = 0 := by linear_combination hb1 - 2 * ht - 3 * hw
          exact Or.inl (fin3_eq_zero_of_sq hs ht hw)
        · have hw : x 2 ^ 2 ≠ 0 := pow_ne_zero 2 hx2
          have hs : x 0 ^ 2 = 3 * x 2 ^ 2 := by linear_combination 2 * hb1 - hb2
          have ht : x 1 ^ 2 = -3 * x 2 ^ 2 := by linear_combination (hb2 - hb1) / 2
          have hx0 : x 0 ≠ 0 := by
            intro hz
            have hz2 : x 0 ^ 2 = 0 := by rw [hz]; ring
            exact hw (by linear_combination (hz2 - hs) / 3)
          have hx1 : x 1 ≠ 0 := by
            intro hz
            have hz2 : x 1 ^ 2 = 0 := by rw [hz]; ring
            exact hw (by linear_combination (ht - hz2) / 3)
          exact absurd (hallx hx0 hx1 hx2).2.1 (pow_ne_zero 3 hy1)
  · rcases eq_or_ne (y 1) 0 with hy1 | hy1
    · rcases eq_or_ne (y 2) 0 with hy2 | hy2
      · -- only `y₀ ≠ 0`: the first column `(1,1,1)` of `C` has no zero entry.
        have hq : y 1 ^ 3 = 0 := by rw [hy1]; ring
        have hr : y 2 ^ 3 = 0 := by rw [hy2]; ring
        have hp : y 0 ^ 3 ≠ 0 := pow_ne_zero 3 hy0
        refine Or.inl (fin3_eq_zero (hA0.resolve_right ?_) (hA1.resolve_right ?_)
          (hA2.resolve_right ?_))
        · exact fun hc => hp (by linear_combination hc - hq - hr)
        · exact fun hc => hp (by linear_combination hc - 2 * hq - 4 * hr)
        · exact fun hc => hp (by linear_combination hc - 3 * hq - 9 * hr)
      · -- `y₀ ≠ 0` and `y₂ ≠ 0`.
        have hb0 := hB0.resolve_left hy0
        have hb2 := hB2.resolve_left hy2
        rcases eq_or_ne (x 2) 0 with hx2 | hx2
        · have hw : x 2 ^ 2 = 0 := by rw [hx2]; ring
          have ht : x 1 ^ 2 = 0 := by linear_combination (hb2 - hb0 - 8 * hw) / 3
          have hs : x 0 ^ 2 = 0 := by linear_combination hb0 - ht - hw
          exact Or.inl (fin3_eq_zero_of_sq hs ht hw)
        · have hw : x 2 ^ 2 ≠ 0 := pow_ne_zero 2 hx2
          have hs : 3 * x 0 ^ 2 = 5 * x 2 ^ 2 := by linear_combination 4 * hb0 - hb2
          have ht : 3 * x 1 ^ 2 = -8 * x 2 ^ 2 := by linear_combination hb2 - hb0
          have hx0 : x 0 ≠ 0 := by
            intro hz
            have hz2 : x 0 ^ 2 = 0 := by rw [hz]; ring
            exact hw (by linear_combination (3 * hz2 - hs) / 5)
          have hx1 : x 1 ≠ 0 := by
            intro hz
            have hz2 : x 1 ^ 2 = 0 := by rw [hz]; ring
            exact hw (by linear_combination (ht - 3 * hz2) / 8)
          exact absurd (hallx hx0 hx1 hx2).1 (pow_ne_zero 3 hy0)
    · rcases eq_or_ne (y 2) 0 with hy2 | hy2
      · -- `y₀ ≠ 0` and `y₁ ≠ 0`.
        have hb0 := hB0.resolve_left hy0
        have hb1 := hB1.resolve_left hy1
        rcases eq_or_ne (x 2) 0 with hx2 | hx2
        · have hw : x 2 ^ 2 = 0 := by rw [hx2]; ring
          have ht : x 1 ^ 2 = 0 := by linear_combination hb1 - hb0 - 2 * hw
          have hs : x 0 ^ 2 = 0 := by linear_combination hb0 - ht - hw
          exact Or.inl (fin3_eq_zero_of_sq hs ht hw)
        · have hw : x 2 ^ 2 ≠ 0 := pow_ne_zero 2 hx2
          have hs : x 0 ^ 2 = x 2 ^ 2 := by linear_combination 2 * hb0 - hb1
          have ht : x 1 ^ 2 = -2 * x 2 ^ 2 := by linear_combination hb1 - hb0
          have hx0 : x 0 ≠ 0 := by
            intro hz
            have hz2 : x 0 ^ 2 = 0 := by rw [hz]; ring
            exact hw (by linear_combination hz2 - hs)
          have hx1 : x 1 ≠ 0 := by
            intro hz
            have hz2 : x 1 ^ 2 = 0 := by rw [hz]; ring
            exact hw (by linear_combination (ht - hz2) / 2)
          exact absurd (hallx hx0 hx1 hx2).1 (pow_ne_zero 3 hy0)
      · -- all three `y`-coordinates nonzero: the full transposed Vandermonde system.
        obtain ⟨hs, ht, hw⟩ :=
          solveB (hB0.resolve_left hy0) (hB1.resolve_left hy1) (hB2.resolve_left hy2)
        exact Or.inl (fin3_eq_zero_of_sq hs ht hw)

variable (k)

/-- **The witness.**  Over an algebraically closed field of characteristic zero the biprojective
zero locus of `F` is smooth over the base.  This is the first — and so far only — proved `Smooth`
instance for a concrete bidegree-`(2,3)` equation in this development, so it is what rules out the
headline theorem being vacuously true. -/
instance smooth_F [IsAlgClosed k] :
    Smooth (Bidegree23ZeroLocus.toSpec k (F k)) :=
  smooth_biprojectiveZeroLocusToSpec_of_gradient 2 2 k (F k) (isBidegree23_F k)
    (fun x y _ hz => gradient_eq_zero_imp x y hz)

/-- **The headline theorem applied to a genuine object.**  The zero locus of `F` in `ℙ² × ℙ²` is
a smooth bidegree-`(2,3)` threefold admitting a dominant rational map from `𝔸³`. -/
theorem hasUnirationalParametrization_F [IsAlgClosed k] :
    HasUnirationalParametrization 3 (Bidegree23ZeroLocus.toSpec k (F k)) :=
  smooth_bidegree23_hasUnirationalParametrization k (F k) (isBidegree23_F k) (F_ne_zero k)

end Witness

/-! ### The Fermat candidate, and why it is not a witness

The claim in this file's header that `x₀²y₀³ + x₁²y₁³ + x₂²y₂³` is singular is not left as prose:
`not_smooth_fermatF` proves that its biprojective zero locus is *not* smooth over the base.  The
witness point is `([1:0:0], [0:1:0])`, seen in the standard chart `x₀ = 1`, `y₁ = 1`. -/

section Fermat

/-- The Fermat-type bidegree-`(2,3)` form, written with explicit unit coefficients so that
`isBidegree23_monomial` applies verbatim.  It is the obvious first candidate for a smooth example
and it is **singular**; see `not_smooth_fermatF`. -/
def fermatF : MvPolynomial (BiprojectiveCoordinate 2 2) k :=
    C 1 * (X (Sum.inl 0) ^ 2 * X (Sum.inr 0) ^ 3)
  + C 1 * (X (Sum.inl 1) ^ 2 * X (Sum.inr 1) ^ 3)
  + C 1 * (X (Sum.inl 2) ^ 2 * X (Sum.inr 2) ^ 3)

/-- The Fermat-type form has bidegree `(2,3)`. -/
theorem isBidegree23_fermatF : IsBidegree23 (fermatF k) :=
  ((isBidegree23_monomial k 0 0 1).add (isBidegree23_monomial k 1 1 1)).add
    (isBidegree23_monomial k 2 2 1)

/-- Value of the Fermat-type form at a pair of coordinate vectors. -/
theorem eval_fermatF (x y : Fin 3 → k) :
    eval (Sum.elim x y) (fermatF k) =
      x 0 ^ 2 * y 0 ^ 3 + x 1 ^ 2 * y 1 ^ 3 + x 2 ^ 2 * y 2 ^ 3 := by
  simp [fermatF]

/-- The representative `(1,0,0)` of the singular point's first coordinate. -/
private def px : Fin 3 → k := fun i => if i = 0 then 1 else 0

/-- The representative `(0,1,0)` of the singular point's second coordinate. -/
private def py : Fin 3 → k := fun i => if i = 1 then 1 else 0

/-- The representative `(1,1,0)`, used only to see that the chart equation is nonzero. -/
private def pz : Fin 3 → k := fun i => if i = 2 then 0 else 1

private theorem px_zero : px k 0 = 1 := by simp [px]

private theorem py_one : py k 1 = 1 := by simp [py]

private theorem pz_one : pz k 1 = 1 := by simp [pz]

/-- The Fermat-type form vanishes at `([1:0:0], [0:1:0])`. -/
private theorem eval_fermatF_px_py : eval (Sum.elim (px k) (py k)) (fermatF k) = 0 := by
  simp [fermatF, px, py]

/-- The Fermat-type form does not vanish at `([1:0:0], [1:1:0])`, which is in the same chart. -/
private theorem eval_fermatF_px_pz : eval (Sum.elim (px k) (pz k)) (fermatF k) = 1 := by
  simp [fermatF, px, pz]

/-- All six Cox partial derivatives of the Fermat-type form vanish at `([1:0:0], [0:1:0])`. -/
private theorem eval_pderiv_fermatF_px_py (z : BiprojectiveCoordinate 2 2) :
    eval (Sum.elim (px k) (py k)) (pderiv z (fermatF k)) = 0 := by
  rcases z with l | l <;> fin_cases l <;> simp [fermatF, px, py]

/-- **The Fermat-type candidate is singular.**  Its zero locus in `ℙ² × ℙ²` is not smooth over
the base: at the honest point `([1:0:0], [0:1:0])` the form and all six of its Cox partial
derivatives vanish.  This is what forced the coupled Vandermonde form `F` above. -/
theorem not_smooth_fermatF : ¬ Smooth (Bidegree23ZeroLocus.toSpec k (fermatF k)) := by
  intro hsmooth
  -- The chart `x₀ = 1`, `y₁ = 1` carries a nonzero equation, since `F(1,0,0; 1,1,0) = 1`.
  have hchart : affineChartEquation 2 2 k 0 1 (fermatF k) ≠ 0 :=
    affineChartEquation_ne_zero_of_eval_ne_zero 2 2 k 0 1 (fermatF k) (px k) (pz k)
      (px_zero k) (pz_one k) (by rw [eval_fermatF_px_pz]; exact one_ne_zero)
  obtain ⟨z, hz⟩ := exists_pderiv_ne_zero_of_smooth 2 2 k (fermatF k) (isBidegree23_fermatF k)
    0 1 hchart (px k) (py k) (px_zero k) (py_one k) (eval_fermatF_px_py k)
  exact hz (eval_pderiv_fermatF_px_py k z)

end Fermat

end Bidegree23Example

end

end BConicBundleMultisections
