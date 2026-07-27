/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.BiprojectiveSmoothCriterion
public import BConicBundleMultisections.MainTheorem
public import BConicBundleMultisections.NeZeroTwoThree

/-!
# Explicit smooth bidegree-`(2,3)` hypersurfaces in `ℙ² × ℙ²`

The headline theorem `smooth_bidegree23_hasUnirationalParametrization` carries a
`[Smooth (Bidegree23ZeroLocus.toSpec k F)]` instance hypothesis.  Nothing else in the development
produces such an instance, so nothing else in the development can tell whether the hypothesis is
satisfiable — and a vacuous theorem passes every `#print axioms` and every `sorry` census
unchanged.  This file removes that possibility: it exhibits concrete equations, proves them
smooth, and applies the headline theorem.

## The family, and why the obvious candidate fails

The obvious first try is the Fermat-type form `x₀²y₀³ + x₁²y₁³ + x₂²y₂³`.  **It is singular.**
Its six Cox partials are `2xᵢyᵢ³` and `3xᵢ²yᵢ²`; at `x = (1,0,0)`, `y = (0,1,0)` every one of them
vanishes, as does the form itself, and `([1:0:0], [0:1:0])` is an honest point of `ℙ² × ℙ²`.  The
same collapse happens for any "permutation" form `∑ᵢ xᵢ² y_{π i}³`: setting one `xᵢ = 1` and the
rest to `0` kills every term involving another `x`, and the surviving `y` can then be chosen to
kill what is left.

The fix is to couple every `x` to every `y`.  `exampleForm M` is

```
∑_{i,l} M_{i l} · xᵢ² · y_l³
```

for a `3 × 3` coefficient matrix `M`.  Writing `uᵢ = xᵢ²` and `v_l = y_l³`, the gradient of
`exampleForm M` vanishes exactly when `uᵢ · (M v)ᵢ = 0` for every `i` and `v_l · (Mᵀ u)_l = 0` for
every `l`, that is, when the support of `u` avoids the support of `M v` and the support of `v`
avoids that of `Mᵀ u`.

## What the coefficient matrix must satisfy

`IsSmoothCoefficientMatrix M` records the three conditions the argument consumes:

* every entry of `M` is nonzero;
* every `2 × 2` minor of `M` is nonzero;
* `det M ≠ 0`.

Nineteen conditions in all, and none is decorative.  Organised by the support `T` of `v`:

* `|T| = 1`: the single column of `M` involved has no zero entry, so `u = 0`.
* `|T| = 2`: the two columns pin `u` to the line spanned by their cross product, whose three
  entries are the `2 × 2` minors on those two columns.  Either `u = 0`, or every `uᵢ ≠ 0` — and
  then all three rows of `M` bear on `v`, so `det M ≠ 0` forces `v = 0`.
* `|T| = 3`: `Mᵀ u = 0` with `det M ≠ 0`, so `u = 0`.

The conditions are also necessary, which is why they cannot be trimmed: if a `2 × 2` minor
`M_{il}M_{jm} − M_{im}M_{jl}` vanishes while the four entries do not, then `u = (M_{jl}, −M_{il})`
and `v = (M_{im}, −M_{il})` supported on `{i,j}` and `{l,m}` give a singular point; if `det M = 0`
while every `2 × 2` minor is nonzero, the kernel and cokernel of `M` are spanned by vectors of
cofactors, all nonzero.  (Only sufficiency is formalised here — that is the direction the witness
needs.)

Only `2 ≠ 0` and `3 ≠ 0` enter, from the factors `2xᵢ` and `3y_l²` in the Cox partials.

## The two witnesses

* `F` is the historical witness: `M` the Vandermonde matrix of the nodes `1, 2, 3`.  Its minor on
  rows `{1,2}` and columns `{0,2}` is `1·9 − 4·1 = 5`, so `F` needs `5 ≠ 0` on top of `2 ≠ 0` and
  `3 ≠ 0`.  That hypothesis is not an artefact: `not_smooth_F_of_ringChar_five` proves that in
  characteristic five the zero locus of `F` is *not* smooth, the singular point being
  `([0:1:2], [1:0:1])`.  `F` is what the rest of the development consumes.
* `universalForm` uses instead

  ```
  M = ⎡1 1 1⎤
      ⎢1 2 3⎥
      ⎣1 3 4⎦
  ```

  whose nineteen entries, minors and determinant are `±1, ±2, ±3, ±4` — every one a unit as soon
  as `2 ≠ 0` and `3 ≠ 0`.  So `exists_smooth_bidegree23` produces a smooth bidegree-`(2,3)` form
  over *every* algebraically closed field of characteristic prime to `6`, with no genericity
  argument and no appeal to the base field being infinite.  Characteristic five, which the
  Vandermonde witness cannot reach, is covered by
  `exists_smooth_bidegree23_of_ringChar_five`.
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

/-! ### The coupled family -/

section Family

variable {k}

/-- The coupled bidegree-`(2,3)` form `∑_{i,l} M_{i l} xᵢ² y_l³` attached to a `3 × 3` coefficient
matrix `M`. -/
def exampleForm (M : Matrix (Fin 3) (Fin 3) k) : MvPolynomial (BiprojectiveCoordinate 2 2) k :=
    C (M 0 0) * (X (Sum.inl 0) ^ 2 * X (Sum.inr 0) ^ 3)
  + C (M 0 1) * (X (Sum.inl 0) ^ 2 * X (Sum.inr 1) ^ 3)
  + C (M 0 2) * (X (Sum.inl 0) ^ 2 * X (Sum.inr 2) ^ 3)
  + C (M 1 0) * (X (Sum.inl 1) ^ 2 * X (Sum.inr 0) ^ 3)
  + C (M 1 1) * (X (Sum.inl 1) ^ 2 * X (Sum.inr 1) ^ 3)
  + C (M 1 2) * (X (Sum.inl 1) ^ 2 * X (Sum.inr 2) ^ 3)
  + C (M 2 0) * (X (Sum.inl 2) ^ 2 * X (Sum.inr 0) ^ 3)
  + C (M 2 1) * (X (Sum.inl 2) ^ 2 * X (Sum.inr 1) ^ 3)
  + C (M 2 2) * (X (Sum.inl 2) ^ 2 * X (Sum.inr 2) ^ 3)

/-- Every member of the family has bidegree `(2,3)`. -/
theorem isBidegree23_exampleForm (M : Matrix (Fin 3) (Fin 3) k) :
    IsBidegree23 (exampleForm M) :=
  ((((((((isBidegree23_monomial k 0 0 _).add (isBidegree23_monomial k 0 1 _)).add
    (isBidegree23_monomial k 0 2 _)).add (isBidegree23_monomial k 1 0 _)).add
    (isBidegree23_monomial k 1 1 _)).add (isBidegree23_monomial k 1 2 _)).add
    (isBidegree23_monomial k 2 0 _)).add (isBidegree23_monomial k 2 1 _)).add
    (isBidegree23_monomial k 2 2 _)

/-- Value at a pair of coordinate vectors: `uᵀ M v` with `uᵢ = xᵢ²` and `v_l = y_l³`. -/
theorem eval_exampleForm (M : Matrix (Fin 3) (Fin 3) k) (x y : Fin 3 → k) :
    eval (Sum.elim x y) (exampleForm M) =
      x 0 ^ 2 * (M 0 0 * y 0 ^ 3 + M 0 1 * y 1 ^ 3 + M 0 2 * y 2 ^ 3)
        + x 1 ^ 2 * (M 1 0 * y 0 ^ 3 + M 1 1 * y 1 ^ 3 + M 1 2 * y 2 ^ 3)
        + x 2 ^ 2 * (M 2 0 * y 0 ^ 3 + M 2 1 * y 1 ^ 3 + M 2 2 * y 2 ^ 3) := by
  simp [exampleForm]; ring

/-- The `xᵢ`-partial: `2 xᵢ · (M v)ᵢ`. -/
theorem eval_pderiv_exampleForm_inl (M : Matrix (Fin 3) (Fin 3) k) (i : Fin 3) (x y : Fin 3 → k) :
    eval (Sum.elim x y) (pderiv (Sum.inl i) (exampleForm M)) =
      2 * x i * (M i 0 * y 0 ^ 3 + M i 1 * y 1 ^ 3 + M i 2 * y 2 ^ 3) := by
  fin_cases i <;> simp [exampleForm] <;> ring

/-- The `y_l`-partial: `3 y_l² · (Mᵀ u)_l`. -/
theorem eval_pderiv_exampleForm_inr (M : Matrix (Fin 3) (Fin 3) k) (l : Fin 3) (x y : Fin 3 → k) :
    eval (Sum.elim x y) (pderiv (Sum.inr l) (exampleForm M)) =
      3 * y l ^ 2 * (M 0 l * x 0 ^ 2 + M 1 l * x 1 ^ 2 + M 2 l * x 2 ^ 2) := by
  fin_cases l <;> simp [exampleForm] <;> ring

/-- A member of the family with `M₀₀ ≠ 0` is nonzero: it takes the value `M₀₀` at
`x = y = (1,0,0)`. -/
theorem exampleForm_ne_zero {M : Matrix (Fin 3) (Fin 3) k} (h : M 0 0 ≠ 0) :
    exampleForm M ≠ 0 := by
  intro hzero
  refine h ?_
  set p : Fin 3 → k := fun i => if i = 0 then 1 else 0 with hp
  have hp0 : p 0 = 1 := by simp [hp]
  have hp1 : p 1 = 0 := by simp [hp]
  have hp2 : p 2 = 0 := by simp [hp]
  have h1 : eval (Sum.elim p p) (exampleForm M) = M 0 0 := by
    rw [eval_exampleForm, hp0, hp1, hp2]; ring
  rw [hzero] at h1
  simpa using h1.symm

end Family

/-! ### The nondegeneracy conditions on the coefficient matrix -/

section Nondegeneracy

variable {k}

/-- **What the smoothness proof needs of the coefficient matrix.**  Every entry, every `2 × 2`
minor, and the determinant must be nonzero.  These are also necessary; see the module docstring. -/
structure IsSmoothCoefficientMatrix (M : Matrix (Fin 3) (Fin 3) k) : Prop where
  /-- No entry of `M` vanishes. -/
  entry_ne_zero : ∀ i l, M i l ≠ 0
  /-- No `2 × 2` minor of `M` vanishes. -/
  minor_ne_zero : ∀ i j l m, i < j → l < m → M i l * M j m - M i m * M j l ≠ 0
  /-- `M` is invertible. -/
  det_ne_zero : M.det ≠ 0

/-- Checklist form: the nine entries, the nine `2 × 2` minors in canonical index order, and the
determinant.  Only these nineteen scalars need checking. -/
theorem isSmoothCoefficientMatrix_mk {M : Matrix (Fin 3) (Fin 3) k}
    (e00 : M 0 0 ≠ 0) (e01 : M 0 1 ≠ 0) (e02 : M 0 2 ≠ 0)
    (e10 : M 1 0 ≠ 0) (e11 : M 1 1 ≠ 0) (e12 : M 1 2 ≠ 0)
    (e20 : M 2 0 ≠ 0) (e21 : M 2 1 ≠ 0) (e22 : M 2 2 ≠ 0)
    (m0101 : M 0 0 * M 1 1 - M 0 1 * M 1 0 ≠ 0)
    (m0102 : M 0 0 * M 1 2 - M 0 2 * M 1 0 ≠ 0)
    (m0112 : M 0 1 * M 1 2 - M 0 2 * M 1 1 ≠ 0)
    (m0201 : M 0 0 * M 2 1 - M 0 1 * M 2 0 ≠ 0)
    (m0202 : M 0 0 * M 2 2 - M 0 2 * M 2 0 ≠ 0)
    (m0212 : M 0 1 * M 2 2 - M 0 2 * M 2 1 ≠ 0)
    (m1201 : M 1 0 * M 2 1 - M 1 1 * M 2 0 ≠ 0)
    (m1202 : M 1 0 * M 2 2 - M 1 2 * M 2 0 ≠ 0)
    (m1212 : M 1 1 * M 2 2 - M 1 2 * M 2 1 ≠ 0)
    (hdet : M.det ≠ 0) :
    IsSmoothCoefficientMatrix M := by
  refine ⟨?_, ?_, hdet⟩
  · intro i l
    fin_cases i <;> fin_cases l <;> assumption
  · intro i j l m hij hlm
    fin_cases i <;> fin_cases j <;> fin_cases l <;> fin_cases m <;>
      first
        | exact absurd hij (by decide)
        | exact absurd hlm (by decide)
        | assumption

/-- The same checklist for a matrix written out entrywise. -/
theorem isSmoothCoefficientMatrix_of_entries {a b c d e f g h j : k}
    (ha : a ≠ 0) (hb : b ≠ 0) (hc : c ≠ 0)
    (hd : d ≠ 0) (he : e ≠ 0) (hf : f ≠ 0)
    (hg : g ≠ 0) (hh : h ≠ 0) (hj : j ≠ 0)
    (m0101 : a * e - b * d ≠ 0) (m0102 : a * f - c * d ≠ 0) (m0112 : b * f - c * e ≠ 0)
    (m0201 : a * h - b * g ≠ 0) (m0202 : a * j - c * g ≠ 0) (m0212 : b * j - c * h ≠ 0)
    (m1201 : d * h - e * g ≠ 0) (m1202 : d * j - f * g ≠ 0) (m1212 : e * j - f * h ≠ 0)
    (hdet : a * e * j - a * f * h - b * d * j + b * f * g + c * d * h - c * e * g ≠ 0) :
    IsSmoothCoefficientMatrix (!![a, b, c; d, e, f; g, h, j] : Matrix (Fin 3) (Fin 3) k) := by
  refine isSmoothCoefficientMatrix_mk (M := !![a, b, c; d, e, f; g, h, j])
    ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_
  · simpa using ha
  · simpa using hb
  · simpa using hc
  · simpa using hd
  · simpa using he
  · simpa using hf
  · simpa using hg
  · simpa using hh
  · simpa using hj
  · simpa using m0101
  · simpa using m0102
  · simpa using m0112
  · simpa using m0201
  · simpa using m0202
  · simpa using m0212
  · simpa using m1201
  · simpa using m1202
  · simpa using m1212
  · rw [Matrix.det_fin_three]
    simpa using hdet

end Nondegeneracy

/-! ### Linear algebra over an arbitrary field -/

section Algebra

variable {k}

/-- A `3 × 3` system with nonzero determinant has only the trivial solution.  The certificates are
the three rows of the adjugate. -/
private theorem solve3 {a b c d e f g h j z₀ z₁ z₂ : k}
    (hdet : a * (e * j - f * h) - b * (d * j - f * g) + c * (d * h - e * g) ≠ 0)
    (e₀ : a * z₀ + b * z₁ + c * z₂ = 0)
    (e₁ : d * z₀ + e * z₁ + f * z₂ = 0)
    (e₂ : g * z₀ + h * z₁ + j * z₂ = 0) :
    z₀ = 0 ∧ z₁ = 0 ∧ z₂ = 0 := by
  refine ⟨(mul_eq_zero.mp ?_).resolve_left hdet, (mul_eq_zero.mp ?_).resolve_left hdet,
    (mul_eq_zero.mp ?_).resolve_left hdet⟩
  · linear_combination (e * j - f * h) * e₀ - (b * j - c * h) * e₁ + (b * f - c * e) * e₂
  · linear_combination (-(d * j - f * g)) * e₀ + (a * j - c * g) * e₁ - (a * f - c * d) * e₂
  · linear_combination (d * h - e * g) * e₀ - (a * h - b * g) * e₁ + (a * e - b * d) * e₂

/-- Two linear equations in three unknowns whose cross product `(bf−ce, cd−af, ae−bd)` has no zero
entry: the solution space is that line, so a solution either vanishes identically or has no zero
entry. -/
private theorem pair_kernel {a b c d e f z₀ z₁ z₂ : k}
    (e₀ : a * z₀ + b * z₁ + c * z₂ = 0)
    (e₁ : d * z₀ + e * z₁ + f * z₂ = 0)
    (k₀ : b * f - c * e ≠ 0) (k₁ : c * d - a * f ≠ 0) (k₂ : a * e - b * d ≠ 0) :
    (z₀ = 0 ∧ z₁ = 0 ∧ z₂ = 0) ∨ (z₀ ≠ 0 ∧ z₁ ≠ 0 ∧ z₂ ≠ 0) := by
  have h₀ : (a * e - b * d) * z₀ = (b * f - c * e) * z₂ := by linear_combination e * e₀ - b * e₁
  have h₁ : (a * e - b * d) * z₁ = (c * d - a * f) * z₂ := by linear_combination -d * e₀ + a * e₁
  rcases eq_or_ne z₂ 0 with hz | hz
  · refine Or.inl ⟨(mul_eq_zero.mp ?_).resolve_left k₂, (mul_eq_zero.mp ?_).resolve_left k₂, hz⟩
    · rw [h₀, hz]; ring
    · rw [h₁, hz]; ring
  · refine Or.inr ⟨fun hc => ?_, fun hc => ?_, hz⟩
    · exact (mul_eq_zero.mp (by rw [← h₀, hc]; ring : (b * f - c * e) * z₂ = 0)).elim k₀ hz
    · exact (mul_eq_zero.mp (by rw [← h₁, hc]; ring : (c * d - a * f) * z₂ = 0)).elim k₁ hz

/-- Coordinatewise vanishing gives vanishing of a vector in `Fin 3 → k`. -/
private theorem fin3_eq_zero {x : Fin 3 → k}
    (h0 : x 0 = 0) (h1 : x 1 = 0) (h2 : x 2 = 0) : x = 0 := by
  funext i
  fin_cases i
  · exact h0
  · exact h1
  · exact h2

/-- Vanishing of the squares gives vanishing of a vector in `Fin 3 → k`. -/
private theorem fin3_eq_zero_of_sq {x : Fin 3 → k}
    (h0 : x 0 ^ 2 = 0) (h1 : x 1 ^ 2 = 0) (h2 : x 2 ^ 2 = 0) : x = 0 :=
  fin3_eq_zero (pow_eq_zero_iff (two_ne_zero' ℕ) |>.mp h0)
    (pow_eq_zero_iff (two_ne_zero' ℕ) |>.mp h1)
    (pow_eq_zero_iff (two_ne_zero' ℕ) |>.mp h2)

end Algebra

/-! ### Smoothness of the family -/

section Witness

variable {k} [NeZero (2 : k)] [NeZero (3 : k)]

/-- **The gradient of `exampleForm M` vanishes only on the two forbidden coordinate subspaces**,
as soon as `M` is nondegenerate.

This is exactly the hypothesis of `smooth_biprojectiveZeroLocusToSpec_of_gradient`.  The proof
splits on which of `y₀, y₁, y₂` vanish.

* All three zero: `y = 0`.
* Exactly one nonzero: the corresponding column of `M` has no zero entry, so every `x`-partial
  forces its `xᵢ` to vanish and `x = 0`.
* Exactly two nonzero: the two `y`-partials pin the `x`-squares to the line spanned by the cross
  product of the two columns, whose entries are `2 × 2` minors of `M` and so are nonzero.  Either
  the line degenerates to the origin and `x = 0`, or all three `xᵢ` are nonzero — and then all
  three `x`-partials give `M v = 0`, so `v = 0` and `y = 0`.
* All three nonzero: `Mᵀ u = 0` with `det M ≠ 0`, so `x = 0`. -/
theorem gradient_eq_zero_imp_exampleForm {M : Matrix (Fin 3) (Fin 3) k}
    (hM : IsSmoothCoefficientMatrix M) (x y : Fin 3 → k)
    (hgrad : ∀ z : BiprojectiveCoordinate 2 2,
      eval (Sum.elim x y) (pderiv z (exampleForm M)) = 0) :
    x = 0 ∨ y = 0 := by
  -- The six scalar gradient equations, split into disjunctions.
  have hA : ∀ i, x i = 0 ∨ M i 0 * y 0 ^ 3 + M i 1 * y 1 ^ 3 + M i 2 * y 2 ^ 3 = 0 := by
    intro i
    have h := hgrad (Sum.inl i)
    rw [eval_pderiv_exampleForm_inl] at h
    rcases mul_eq_zero.mp h with h' | h'
    · exact Or.inl ((mul_eq_zero.mp h').resolve_left two_ne_zero)
    · exact Or.inr h'
  have hB : ∀ l, y l = 0 ∨ M 0 l * x 0 ^ 2 + M 1 l * x 1 ^ 2 + M 2 l * x 2 ^ 2 = 0 := by
    intro l
    have h := hgrad (Sum.inr l)
    rw [eval_pderiv_exampleForm_inr] at h
    rcases mul_eq_zero.mp h with h' | h'
    · exact Or.inl (pow_eq_zero_iff (two_ne_zero' ℕ) |>.mp
        ((mul_eq_zero.mp h').resolve_left three_ne_zero))
    · exact Or.inr h'
  have hdetrow : M 0 0 * (M 1 1 * M 2 2 - M 1 2 * M 2 1)
      - M 0 1 * (M 1 0 * M 2 2 - M 1 2 * M 2 0)
      + M 0 2 * (M 1 0 * M 2 1 - M 1 1 * M 2 0) ≠ 0 := by
    have h := hM.det_ne_zero
    rw [Matrix.det_fin_three] at h
    exact fun hc => h (by linear_combination hc)
  have hdetcol : M 0 0 * (M 1 1 * M 2 2 - M 2 1 * M 1 2)
      - M 1 0 * (M 0 1 * M 2 2 - M 2 1 * M 0 2)
      + M 2 0 * (M 0 1 * M 1 2 - M 1 1 * M 0 2) ≠ 0 := by
    have h := hM.det_ne_zero
    rw [Matrix.det_fin_three] at h
    exact fun hc => h (by linear_combination hc)
  -- If all three `xᵢ` are nonzero, the `y`-cubes solve `M v = 0`, so `y = 0`.
  have hallx : x 0 ≠ 0 → x 1 ≠ 0 → x 2 ≠ 0 → y = 0 := by
    intro h0 h1 h2
    obtain ⟨p, q, r⟩ := solve3 hdetrow ((hA 0).resolve_left h0) ((hA 1).resolve_left h1)
      ((hA 2).resolve_left h2)
    exact fin3_eq_zero (pow_eq_zero_iff (three_ne_zero' ℕ) |>.mp p)
      (pow_eq_zero_iff (three_ne_zero' ℕ) |>.mp q)
      (pow_eq_zero_iff (three_ne_zero' ℕ) |>.mp r)
  -- If all three `y_l` are nonzero, the `x`-squares solve `Mᵀ u = 0`, so `x = 0`.
  have hally : y 0 ≠ 0 → y 1 ≠ 0 → y 2 ≠ 0 → x = 0 := by
    intro h0 h1 h2
    obtain ⟨s, t, w⟩ := solve3 hdetcol ((hB 0).resolve_left h0) ((hB 1).resolve_left h1)
      ((hB 2).resolve_left h2)
    exact fin3_eq_zero_of_sq s t w
  -- Exactly one `y_l` nonzero: the `l`-th column of `M` has no zero entry, so `x = 0`.
  have onecol : ∀ l : Fin 3, y l ≠ 0 →
      (∀ i : Fin 3, M i 0 * y 0 ^ 3 + M i 1 * y 1 ^ 3 + M i 2 * y 2 ^ 3 = M i l * y l ^ 3) →
      x = 0 := by
    intro l hyl hred
    have key : ∀ i : Fin 3, x i = 0 := by
      intro i
      refine (hA i).resolve_right fun hc => ?_
      have h : M i l * y l ^ 3 = 0 := by rw [← hred i]; exact hc
      exact (mul_eq_zero.mp h).elim (hM.entry_ne_zero i l) (pow_ne_zero 3 hyl)
    exact fin3_eq_zero (key 0) (key 1) (key 2)
  -- Exactly two `y_l` nonzero: the two columns pin the `x`-squares to a line whose direction
  -- vector is a triple of `2 × 2` minors, hence has no zero entry.
  have twocol : ∀ l m : Fin 3, l < m → y l ≠ 0 → y m ≠ 0 → x = 0 ∨ y = 0 := by
    intro l m hlm hyl hym
    have k₀ : M 1 l * M 2 m - M 2 l * M 1 m ≠ 0 := fun hc =>
      hM.minor_ne_zero 1 2 l m (by decide) hlm (by linear_combination hc)
    have k₁ : M 2 l * M 0 m - M 0 l * M 2 m ≠ 0 := fun hc =>
      hM.minor_ne_zero 0 2 l m (by decide) hlm (by linear_combination -hc)
    have k₂ : M 0 l * M 1 m - M 1 l * M 0 m ≠ 0 := fun hc =>
      hM.minor_ne_zero 0 1 l m (by decide) hlm (by linear_combination hc)
    rcases pair_kernel ((hB l).resolve_left hyl) ((hB m).resolve_left hym) k₀ k₁ k₂ with
      ⟨h0, h1, h2⟩ | ⟨h0, h1, h2⟩
    · exact Or.inl (fin3_eq_zero_of_sq h0 h1 h2)
    · exact Or.inr (hallx (fun hz => h0 (by rw [hz]; ring)) (fun hz => h1 (by rw [hz]; ring))
        (fun hz => h2 (by rw [hz]; ring)))
  rcases eq_or_ne (y 0) 0 with hy0 | hy0 <;> rcases eq_or_ne (y 1) 0 with hy1 | hy1 <;>
    rcases eq_or_ne (y 2) 0 with hy2 | hy2
  · exact Or.inr (fin3_eq_zero hy0 hy1 hy2)
  · exact Or.inl (onecol 2 hy2 fun i => by rw [hy0, hy1]; ring)
  · exact Or.inl (onecol 1 hy1 fun i => by rw [hy0, hy2]; ring)
  · exact twocol 1 2 (by decide) hy1 hy2
  · exact Or.inl (onecol 0 hy0 fun i => by rw [hy1, hy2]; ring)
  · exact twocol 0 2 (by decide) hy0 hy2
  · exact twocol 0 1 (by decide) hy0 hy1
  · exact Or.inl (hally hy0 hy1 hy2)

/-- **Smoothness of the family.**  Over an algebraically closed field in which `2 ≠ 0` and
`3 ≠ 0`, the biprojective zero locus of `exampleForm M` is smooth over the base whenever `M` is
nondegenerate. -/
theorem smooth_exampleForm [IsAlgClosed k] {M : Matrix (Fin 3) (Fin 3) k}
    (hM : IsSmoothCoefficientMatrix M) :
    Smooth (Bidegree23ZeroLocus.toSpec k (exampleForm M)) :=
  smooth_biprojectiveZeroLocusToSpec_of_gradient 2 2 k (exampleForm M)
    (isBidegree23_exampleForm M) (fun x y _ hz => gradient_eq_zero_imp_exampleForm hM x y hz)

end Witness

/-! ### The Vandermonde witness at the nodes `1, 2, 3` -/

section Vandermonde

/-- The Vandermonde matrix of the nodes `1, 2, 3`. -/
def vandermonde123 : Matrix (Fin 3) (Fin 3) k := !![1, 1, 1; 1, 2, 4; 1, 3, 9]

/-- The historical explicit witness: `∑_{i,l} C_{i l} xᵢ² y_l³` with `C` the Vandermonde matrix of
the nodes `1, 2, 3`. -/
def F : MvPolynomial (BiprojectiveCoordinate 2 2) k := exampleForm (vandermonde123 k)

/-- The example form has bidegree `(2,3)`. -/
theorem isBidegree23_F : IsBidegree23 (F k) := isBidegree23_exampleForm _

/-- Value of the example form at a pair of coordinate vectors. -/
theorem eval_F (x y : Fin 3 → k) :
    eval (Sum.elim x y) (F k) =
      x 0 ^ 2 * (y 0 ^ 3 + y 1 ^ 3 + y 2 ^ 3)
        + x 1 ^ 2 * (y 0 ^ 3 + 2 * y 1 ^ 3 + 4 * y 2 ^ 3)
        + x 2 ^ 2 * (y 0 ^ 3 + 3 * y 1 ^ 3 + 9 * y 2 ^ 3) := by
  simp only [F, eval_exampleForm]
  simp [vandermonde123]

/-- The `x₀`-partial of the example form. -/
theorem eval_pderiv_x0 (x y : Fin 3 → k) :
    eval (Sum.elim x y) (pderiv (Sum.inl 0) (F k)) =
      2 * x 0 * (y 0 ^ 3 + y 1 ^ 3 + y 2 ^ 3) := by
  rw [show F k = exampleForm (vandermonde123 k) from rfl, eval_pderiv_exampleForm_inl]
  simp [vandermonde123]

/-- The `x₁`-partial of the example form. -/
theorem eval_pderiv_x1 (x y : Fin 3 → k) :
    eval (Sum.elim x y) (pderiv (Sum.inl 1) (F k)) =
      2 * x 1 * (y 0 ^ 3 + 2 * y 1 ^ 3 + 4 * y 2 ^ 3) := by
  rw [show F k = exampleForm (vandermonde123 k) from rfl, eval_pderiv_exampleForm_inl]
  simp [vandermonde123]

/-- The `x₂`-partial of the example form. -/
theorem eval_pderiv_x2 (x y : Fin 3 → k) :
    eval (Sum.elim x y) (pderiv (Sum.inl 2) (F k)) =
      2 * x 2 * (y 0 ^ 3 + 3 * y 1 ^ 3 + 9 * y 2 ^ 3) := by
  rw [show F k = exampleForm (vandermonde123 k) from rfl, eval_pderiv_exampleForm_inl]
  simp [vandermonde123]

/-- The `y₀`-partial of the example form. -/
theorem eval_pderiv_y0 (x y : Fin 3 → k) :
    eval (Sum.elim x y) (pderiv (Sum.inr 0) (F k)) =
      3 * y 0 ^ 2 * (x 0 ^ 2 + x 1 ^ 2 + x 2 ^ 2) := by
  rw [show F k = exampleForm (vandermonde123 k) from rfl, eval_pderiv_exampleForm_inr]
  simp [vandermonde123]

/-- The `y₁`-partial of the example form. -/
theorem eval_pderiv_y1 (x y : Fin 3 → k) :
    eval (Sum.elim x y) (pderiv (Sum.inr 1) (F k)) =
      3 * y 1 ^ 2 * (x 0 ^ 2 + 2 * x 1 ^ 2 + 3 * x 2 ^ 2) := by
  rw [show F k = exampleForm (vandermonde123 k) from rfl, eval_pderiv_exampleForm_inr]
  simp [vandermonde123]

/-- The `y₂`-partial of the example form. -/
theorem eval_pderiv_y2 (x y : Fin 3 → k) :
    eval (Sum.elim x y) (pderiv (Sum.inr 2) (F k)) =
      3 * y 2 ^ 2 * (x 0 ^ 2 + 4 * x 1 ^ 2 + 9 * x 2 ^ 2) := by
  rw [show F k = exampleForm (vandermonde123 k) from rfl, eval_pderiv_exampleForm_inr]
  simp [vandermonde123]

/-- The example form is nonzero: it takes the value `1` at `x = y = (1,0,0)`. -/
theorem F_ne_zero : F k ≠ 0 :=
  exampleForm_ne_zero (by simp [vandermonde123])

variable {k}

/-- The Vandermonde matrix of `1, 2, 3` is nondegenerate exactly when `2`, `3` and `5` are
invertible: its nineteen scalars are `1, 2, 3, 4, 5, 6, 8, 9`, and `5` occurs once, as the minor
on rows `{1,2}` and columns `{0,2}`. -/
theorem isSmoothCoefficientMatrix_vandermonde123
    [NeZero (2 : k)] [NeZero (3 : k)] [NeZero (5 : k)] :
    IsSmoothCoefficientMatrix (vandermonde123 k) := by
  simp only [vandermonde123]
  refine isSmoothCoefficientMatrix_of_entries one_ne_zero one_ne_zero one_ne_zero
    one_ne_zero two_ne_zero four_ne_zero' one_ne_zero three_ne_zero nine_ne_zero'
    ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_
  · norm_num
  · norm_num; exact three_ne_zero
  · norm_num; exact two_ne_zero
  · norm_num; exact two_ne_zero
  · norm_num; exact eight_ne_zero'
  · norm_num; exact six_ne_zero'
  · norm_num
  -- the only place `5` is needed
  · norm_num; exact NeZero.ne (5 : k)
  · norm_num; exact six_ne_zero'
  · norm_num; exact two_ne_zero

variable (k)

/-- **The witness.**  Over an algebraically closed field in which `2`, `3` and `5` are invertible
the biprojective zero locus of `F` is smooth over the base.  This is what rules out the headline
theorem being vacuously true. -/
instance smooth_F [NeZero (2 : k)] [NeZero (3 : k)] [NeZero (5 : k)] [IsAlgClosed k] :
    Smooth (Bidegree23ZeroLocus.toSpec k (F k)) :=
  smooth_exampleForm isSmoothCoefficientMatrix_vandermonde123

/-- **The headline theorem applied to a genuine object.**  The zero locus of `F` in `ℙ² × ℙ²` is
a smooth bidegree-`(2,3)` threefold admitting a dominant rational map from `𝔸³`. -/
theorem hasUnirationalParametrization_F [IsAlgClosed k] [CharZero k] :
    HasUnirationalParametrization 3 (Bidegree23ZeroLocus.toSpec k (F k)) :=
  smooth_bidegree23_hasUnirationalParametrization k (F k) (isBidegree23_F k) (F_ne_zero k)

end Vandermonde

/-! ### A witness for every characteristic prime to `6`

The Vandermonde witness `F` dies in characteristic five, so on its own it leaves the
characteristic-five case of a characteristic-prime-to-`6` theorem unwitnessed.  The matrix below
repairs that: its nineteen entries, minors and determinant are `1, 2, 3, 4` and `−1` up to sign,
so it is nondegenerate over *any* field in which `2 ≠ 0` and `3 ≠ 0`. -/

section Universal

/-- A coefficient matrix that is nondegenerate as soon as `2 ≠ 0` and `3 ≠ 0`. -/
def universalMatrix : Matrix (Fin 3) (Fin 3) k := !![1, 1, 1; 1, 2, 3; 1, 3, 4]

/-- The coupled form of `universalMatrix`. -/
def universalForm : MvPolynomial (BiprojectiveCoordinate 2 2) k := exampleForm (universalMatrix k)

/-- `universalForm` has bidegree `(2,3)`. -/
theorem isBidegree23_universalForm : IsBidegree23 (universalForm k) := isBidegree23_exampleForm _

/-- Value of `universalForm` at a pair of coordinate vectors. -/
theorem eval_universalForm (x y : Fin 3 → k) :
    eval (Sum.elim x y) (universalForm k) =
      x 0 ^ 2 * (y 0 ^ 3 + y 1 ^ 3 + y 2 ^ 3)
        + x 1 ^ 2 * (y 0 ^ 3 + 2 * y 1 ^ 3 + 3 * y 2 ^ 3)
        + x 2 ^ 2 * (y 0 ^ 3 + 3 * y 1 ^ 3 + 4 * y 2 ^ 3) := by
  simp only [universalForm, eval_exampleForm]
  simp [universalMatrix]

/-- `universalForm` is nonzero. -/
theorem universalForm_ne_zero : universalForm k ≠ 0 :=
  exampleForm_ne_zero (by simp [universalMatrix])

variable {k}

/-- **`universalMatrix` is nondegenerate in every characteristic prime to `6`.**  Its nineteen
scalars are `1, 2, 3, 4` and `−1` up to sign, and `4 = 2 · 2`. -/
theorem isSmoothCoefficientMatrix_universalMatrix [NeZero (2 : k)] [NeZero (3 : k)] :
    IsSmoothCoefficientMatrix (universalMatrix k) := by
  simp only [universalMatrix]
  refine isSmoothCoefficientMatrix_of_entries one_ne_zero one_ne_zero one_ne_zero
    one_ne_zero two_ne_zero three_ne_zero one_ne_zero three_ne_zero four_ne_zero'
    ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_
  · norm_num
  · norm_num; exact two_ne_zero
  · norm_num
  · norm_num; exact two_ne_zero
  · norm_num; exact three_ne_zero
  · norm_num
  · norm_num
  · norm_num
  · norm_num
  · norm_num

variable (k)

/-- The zero locus of `universalForm` is smooth over the base, over any algebraically closed field
in which `2 ≠ 0` and `3 ≠ 0`. -/
theorem smooth_universalForm [NeZero (2 : k)] [NeZero (3 : k)] [IsAlgClosed k] :
    Smooth (Bidegree23ZeroLocus.toSpec k (universalForm k)) :=
  smooth_exampleForm isSmoothCoefficientMatrix_universalMatrix

/-- **Existence with no characteristic-zero hypothesis and no genericity argument.**  Over any
algebraically closed field in which `2 ≠ 0` and `3 ≠ 0` there is a nonzero bidegree-`(2,3)` form
whose biprojective zero locus is smooth over the base. -/
theorem exists_smooth_bidegree23 [NeZero (2 : k)] [NeZero (3 : k)] [IsAlgClosed k] :
    ∃ F : MvPolynomial (BiprojectiveCoordinate 2 2) k,
      IsBidegree23 F ∧ F ≠ 0 ∧ Smooth (Bidegree23ZeroLocus.toSpec k F) :=
  ⟨universalForm k, isBidegree23_universalForm k, universalForm_ne_zero k, smooth_universalForm k⟩

end Universal

/-! ### Characteristic five

The characteristic-five case is the one the Vandermonde witness cannot reach, so it is recorded
explicitly on both sides: the old coefficient matrix genuinely fails there, and the new one
genuinely works. -/

section CharFive

variable {k}

/-- **In characteristic five the Vandermonde matrix of the nodes `1, 2, 3` is not admissible.**
Its `2 × 2` minor on rows `{1,2}` and columns `{0,2}` is `1 · 9 − 4 · 1 = 5`. -/
theorem not_isSmoothCoefficientMatrix_vandermonde123 (h : ringChar k = 5) :
    ¬ IsSmoothCoefficientMatrix (vandermonde123 k) := by
  have h5 : (5 : k) = 0 := by
    rw [show (5 : k) = ((5 : ℕ) : k) by norm_cast, ringChar.spec, h]
  intro hM
  refine hM.minor_ne_zero 1 2 0 2 (by decide) (by decide) ?_
  have hminor : (vandermonde123 k) 1 0 * (vandermonde123 k) 2 2
      - (vandermonde123 k) 1 2 * (vandermonde123 k) 2 0 = 5 := by
    simp [vandermonde123]
    norm_num
  rw [hminor, h5]

variable (k)

/-- Representatives of `([0:1:2], [1:0:1])`, a singular point of `F` in characteristic five. -/
private def sx : Fin 3 → k := ![0, 1, 2]

/-- Second half of the singular point. -/
private def sy : Fin 3 → k := ![1, 0, 1]

/-- The representative `(0,1,0)`, used only to see that the chart equation is nonzero. -/
private def tx : Fin 3 → k := ![0, 1, 0]

/-- The representative `(1,0,0)`, used only to see that the chart equation is nonzero. -/
private def ty : Fin 3 → k := ![1, 0, 0]

/-- **The Vandermonde witness genuinely dies in characteristic five.**  Its zero locus is not
smooth over the base: at the honest point `([0:1:2], [1:0:1])` the form takes the value `45` and
its six Cox partials take the values `0, 10, 40, 15, 0, 120`, every one of them a multiple of `5`.
So the `[NeZero (5 : k)]` hypothesis on `smooth_F` is not an artefact of the proof, and the
characteristic-five case really does need a different coefficient matrix. -/
theorem not_smooth_F_of_ringChar_five (h : ringChar k = 5) :
    ¬ Smooth (Bidegree23ZeroLocus.toSpec k (F k)) := by
  have h5 : (5 : k) = 0 := by
    rw [show (5 : k) = ((5 : ℕ) : k) by norm_cast, ringChar.spec, h]
  have hx0 : sx k 0 = 0 := by simp [sx]
  have hx1 : sx k 1 = 1 := by simp [sx]
  have hx2 : sx k 2 = 2 := by simp [sx]
  have hy0 : sy k 0 = 1 := by simp [sy]
  have hy1 : sy k 1 = 0 := by simp [sy]
  have hy2 : sy k 2 = 1 := by simp [sy]
  intro hsmooth
  -- The chart `x₁ = 1`, `y₀ = 1` carries a nonzero equation, since `F(0,1,0; 1,0,0) = 1`.
  have hchart : affineChartEquation 2 2 k 1 0 (F k) ≠ 0 :=
    affineChartEquation_ne_zero_of_eval_ne_zero 2 2 k 1 0 (F k) (tx k) (ty k)
      (by simp [tx]) (by simp [ty]) (by rw [eval_F]; simp [tx, ty])
  have hzero : eval (Sum.elim (sx k) (sy k)) (F k) = 0 := by
    rw [eval_F, hx0, hx1, hx2, hy0, hy1, hy2]
    linear_combination (9 : k) * h5
  obtain ⟨z, hz⟩ := exists_pderiv_ne_zero_of_smooth 2 2 k (F k) (isBidegree23_F k) 1 0 hchart
    (sx k) (sy k) (by simp [sx]) (by simp [sy]) hzero
  refine hz ?_
  rcases z with i | l
  · fin_cases i
    · refine (eval_pderiv_x0 k (sx k) (sy k)).trans ?_
      rw [hx0]; ring
    · refine (eval_pderiv_x1 k (sx k) (sy k)).trans ?_
      rw [hx1, hy0, hy1, hy2]; linear_combination (2 : k) * h5
    · refine (eval_pderiv_x2 k (sx k) (sy k)).trans ?_
      rw [hx2, hy0, hy1, hy2]; linear_combination (8 : k) * h5
  · fin_cases l
    · refine (eval_pderiv_y0 k (sx k) (sy k)).trans ?_
      rw [hx0, hx1, hx2, hy0]; linear_combination (3 : k) * h5
    · refine (eval_pderiv_y1 k (sx k) (sy k)).trans ?_
      rw [hy1]; ring
    · refine (eval_pderiv_y2 k (sx k) (sy k)).trans ?_
      rw [hx0, hx1, hx2, hy2]; linear_combination (24 : k) * h5

/-- **The characteristic-five case is witnessed.**  In characteristic five `2 ≠ 0` and `3 ≠ 0`, so
`universalForm` applies — while `not_smooth_F_of_ringChar_five` shows that `F` does not. -/
theorem exists_smooth_bidegree23_of_ringChar_five [IsAlgClosed k] (h : ringChar k = 5) :
    ∃ F : MvPolynomial (BiprojectiveCoordinate 2 2) k,
      IsBidegree23 F ∧ F ≠ 0 ∧ Smooth (Bidegree23ZeroLocus.toSpec k F) := by
  have key : ∀ n : ℕ, ¬ (5 ∣ n) → ((n : k) ≠ 0) := by
    intro n hn hc
    exact hn (h ▸ (ringChar.spec k n).mp hc)
  haveI : NeZero (2 : k) := ⟨by simpa using key 2 (by decide)⟩
  haveI : NeZero (3 : k) := ⟨by simpa using key 3 (by decide)⟩
  exact exists_smooth_bidegree23 k

end CharFive

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
derivatives vanish.  This is what forced the coupled forms above. -/
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
