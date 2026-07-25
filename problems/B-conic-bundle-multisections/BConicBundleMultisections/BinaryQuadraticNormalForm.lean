/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.BinaryCubicResidual
public import BConicBundleMultisections.PointedConicAffineModel

/-!
# Binary polynomials of total degree at most two are general affine conics

A polynomial in two variables of total degree at most two is determined by six coefficients, and
is `PointedConic.affineConicPoly` in them:

`f = α x² + β x y + γ y² + δ x + ε y + ζ`,  `α = coeff (2,0) f`, …, `ζ = coeff (0,0) f`.

That is the whole content of this file.  It is the enumeration of the six exponent vectors
`(2,0), (1,1), (0,2), (1,0), (0,1), (0,0)` of `Fin 2 →₀ ℕ` of total degree at most two, together
with the observation that the coefficient at every other exponent vanishes.

## Main statements

* `eq_affineConicPoly_of_totalDegree_le_two`: the target.  `f.totalDegree ≤ 2` implies
  `f = PointedConic.affineConicPoly (coeff (binaryExponent 2 0) f) … (coeff 0 f)`.
* `totalDegree_le_two_iff_exists_affineConicPoly`: the same as a characterisation — a binary
  polynomial has total degree at most two iff it is *some* `affineConicPoly`.
* `eq_sum_monomial_of_support_sum_le_two` / `eq_sum_monomial_of_totalDegree_le_two`: the normal
  form as a bare sum of six `monomial`s, with no reference to `affineConicPoly`.  The first takes
  the degree bound in its support form `∀ d ∈ f.support, d 0 + d 1 ≤ 2`, which is what a caller
  holding a `degreeOf` or weighted-degree bound can supply most directly.
* `coeff_affineConicPoly_two_zero` and its five siblings: the six coefficients of
  `affineConicPoly α β γ δ ε ζ` are `α, β, γ, δ, ε, ζ`.  These are the inverse direction, and they
  pin the monomial convention down independently of the normal form.
* `totalDegree_le_two_iff`: the degree bound as a condition on the support.

## The exponent vectors

Exponents are written with `binaryExponent` of `BinaryCubicResidual.lean`:
`binaryExponent a b = Finsupp.single 0 a + Finsupp.single 1 b` is the exponent vector of `x^a y^b`
in the variables `X 0 = x`, `X 1 = y`.  So

`binaryExponent 2 0 ↦ x²`, `binaryExponent 1 1 ↦ x y`, `binaryExponent 0 2 ↦ y²`,
`binaryExponent 1 0 ↦ x`, `binaryExponent 0 1 ↦ y`, `binaryExponent 0 0 = 0 ↦ 1`,

matching `affineConicPoly α β γ δ ε ζ = C α * X 0 ^ 2 + C β * (X 0 * X 1) + C γ * X 1 ^ 2 +
C δ * X 0 + C ε * X 1 + C ζ`.  The constant coefficient is stated as `coeff 0 f` rather than
`coeff (binaryExponent 0 0) f`; `binaryExponent_zero_zero` identifies the two.

## Generality

Everything except the statements naming `affineConicPoly` is proved over a `CommSemiring`;
`affineConicPoly` is defined over a `CommRing`, so its statements are.
-/

@[expose] public section

open MvPolynomial

namespace BConicBundleMultisections

universe u

section CommSemiring

variable {R : Type u} [CommSemiring R]

/-! ### Exponent vectors in two variables -/

/-- The zero exponent vector is the exponent of the constant monomial `1 = x⁰ y⁰`. -/
theorem binaryExponent_zero_zero : binaryExponent 0 0 = (0 : Fin 2 →₀ ℕ) := by
  simp [binaryExponent]

/-- Every exponent vector in two variables is `binaryExponent` of its two values.  The six-element
enumeration below can therefore be carried out on the two natural numbers `d 0` and `d 1`, where
`omega` is available, rather than on `d` itself. -/
theorem binaryExponent_apply_apply (d : Fin 2 →₀ ℕ) : binaryExponent (d 0) (d 1) = d := by
  ext i
  fin_cases i <;> simp [binaryExponent]

/-- The `Finsupp.sum` whose supremum is `MvPolynomial.totalDegree`, read on `Fin 2`. -/
theorem finsupp_sum_fin_two (d : Fin 2 →₀ ℕ) : (d.sum fun _ e => e) = d 0 + d 1 := by
  rw [Finsupp.sum_fintype _ _ fun _ => rfl, Fin.sum_univ_two]

/-- **The degree bound as a support condition.**  A binary polynomial has total degree at most two
exactly when every exponent vector `d` occurring in it satisfies `d 0 + d 1 ≤ 2`. -/
theorem totalDegree_le_two_iff (f : MvPolynomial (Fin 2) R) :
    f.totalDegree ≤ 2 ↔ ∀ d ∈ f.support, d 0 + d 1 ≤ 2 := by
  constructor
  · intro hf d hd
    have h := MvPolynomial.le_totalDegree hd
    rw [finsupp_sum_fin_two] at h
    omega
  · intro h
    refine Finset.sup_le fun d hd => ?_
    rw [finsupp_sum_fin_two]
    exact h d hd

/-! ### The normal form as a sum of six monomials -/

/-- **The six-monomial normal form**, from the support hypothesis.

A binary polynomial all of whose exponent vectors `d` satisfy `d 0 + d 1 ≤ 2` is the sum of its
six monomials of degree at most two.  All the content of the file is here: the enumeration of the
six exponent vectors, and their pairwise distinctness. -/
theorem eq_sum_monomial_of_support_sum_le_two (f : MvPolynomial (Fin 2) R)
    (hf : ∀ d ∈ f.support, d 0 + d 1 ≤ 2) :
    f = monomial (binaryExponent 2 0) (coeff (binaryExponent 2 0) f) +
        monomial (binaryExponent 1 1) (coeff (binaryExponent 1 1) f) +
        monomial (binaryExponent 0 2) (coeff (binaryExponent 0 2) f) +
        monomial (binaryExponent 1 0) (coeff (binaryExponent 1 0) f) +
        monomial (binaryExponent 0 1) (coeff (binaryExponent 0 1) f) +
        monomial (binaryExponent 0 0) (coeff (binaryExponent 0 0) f) := by
  classical
  ext d
  obtain ⟨a, b, rfl⟩ : ∃ a b, d = binaryExponent a b :=
    ⟨d 0, d 1, (binaryExponent_apply_apply d).symm⟩
  simp only [coeff_add, coeff_monomial, binaryExponent_inj]
  by_cases hab : a + b ≤ 2
  · -- One of the six exponents: exactly one of the six conditions holds.
    have hcases : a = 2 ∧ b = 0 ∨ a = 1 ∧ b = 1 ∨ a = 0 ∧ b = 2 ∨
        a = 1 ∧ b = 0 ∨ a = 0 ∧ b = 1 ∨ a = 0 ∧ b = 0 := by omega
    rcases hcases with ⟨rfl, rfl⟩ | ⟨rfl, rfl⟩ | ⟨rfl, rfl⟩ | ⟨rfl, rfl⟩ | ⟨rfl, rfl⟩ |
      ⟨rfl, rfl⟩ <;> norm_num
  · -- Degree at least three: the coefficient vanishes, and all six conditions fail.
    have hzero : coeff (binaryExponent a b) f = 0 := by
      rw [← MvPolynomial.notMem_support_iff]
      intro hmem
      have := hf _ hmem
      simp only [binaryExponent_zero, binaryExponent_one] at this
      omega
    have hne : ∀ p q : ℕ, p + q ≤ 2 → ¬(p = a ∧ q = b) := by
      rintro p q hpq ⟨rfl, rfl⟩
      omega
    rw [hzero, if_neg (hne 2 0 (by norm_num)), if_neg (hne 1 1 (by norm_num)),
      if_neg (hne 0 2 (by norm_num)), if_neg (hne 1 0 (by norm_num)),
      if_neg (hne 0 1 (by norm_num)), if_neg (hne 0 0 (by norm_num))]
    simp

/-- **The six-monomial normal form**, from the total-degree bound. -/
theorem eq_sum_monomial_of_totalDegree_le_two (f : MvPolynomial (Fin 2) R)
    (hf : f.totalDegree ≤ 2) :
    f = monomial (binaryExponent 2 0) (coeff (binaryExponent 2 0) f) +
        monomial (binaryExponent 1 1) (coeff (binaryExponent 1 1) f) +
        monomial (binaryExponent 0 2) (coeff (binaryExponent 0 2) f) +
        monomial (binaryExponent 1 0) (coeff (binaryExponent 1 0) f) +
        monomial (binaryExponent 0 1) (coeff (binaryExponent 0 1) f) +
        monomial (binaryExponent 0 0) (coeff (binaryExponent 0 0) f) :=
  eq_sum_monomial_of_support_sum_le_two f ((totalDegree_le_two_iff f).mp hf)

/-! ### The conic shape -/

/-- A monomial in two variables written as a coefficient times a power product. -/
theorem monomial_binaryExponent (a b : ℕ) (c : R) :
    monomial (binaryExponent a b) c = C c * X 0 ^ a * X 1 ^ b := by
  rw [X_pow_eq_monomial, X_pow_eq_monomial, C_mul_monomial, monomial_mul, mul_one, mul_one]
  rfl

/-- A monomial of exponent `binaryExponent a b` has total degree at most `a + b`. -/
theorem totalDegree_monomial_binaryExponent_le (a b : ℕ) (c : R) :
    (monomial (binaryExponent a b) c : MvPolynomial (Fin 2) R).totalDegree ≤ a + b := by
  refine Finset.sup_le fun d hd => ?_
  obtain rfl : d = binaryExponent a b := Finset.mem_singleton.mp (support_monomial_subset hd)
  rw [finsupp_sum_fin_two]
  simp

/-- The sum of the six monomials of degree at most two, written in conic shape.  The right-hand
side is the literal unfolding of `PointedConic.affineConicPoly α β γ δ ε ζ`. -/
theorem sum_monomial_eq_affineConic (α β γ δ ε ζ : R) :
    monomial (binaryExponent 2 0) α + monomial (binaryExponent 1 1) β +
        monomial (binaryExponent 0 2) γ + monomial (binaryExponent 1 0) δ +
        monomial (binaryExponent 0 1) ε + monomial (binaryExponent 0 0) ζ =
      C α * X 0 ^ 2 + C β * (X 0 * X 1) + C γ * X 1 ^ 2 + C δ * X 0 + C ε * X 1 + C ζ := by
  rw [monomial_binaryExponent, monomial_binaryExponent, monomial_binaryExponent,
    monomial_binaryExponent, monomial_binaryExponent, monomial_binaryExponent]
  ring

/-- **A binary polynomial of total degree at most two is the general affine conic in its six
coefficients**, stated without reference to `affineConicPoly`.

The right-hand side is the definition of `PointedConic.affineConicPoly` unfolded, so this and
`eq_affineConicPoly_of_totalDegree_le_two` are the same theorem. -/
theorem eq_affineConic_of_totalDegree_le_two (f : MvPolynomial (Fin 2) R)
    (hf : f.totalDegree ≤ 2) :
    f = C (coeff (binaryExponent 2 0) f) * X 0 ^ 2 +
        C (coeff (binaryExponent 1 1) f) * (X 0 * X 1) +
        C (coeff (binaryExponent 0 2) f) * X 1 ^ 2 +
        C (coeff (binaryExponent 1 0) f) * X 0 +
        C (coeff (binaryExponent 0 1) f) * X 1 +
        C (coeff 0 f) := by
  have h0 : coeff (0 : Fin 2 →₀ ℕ) f = coeff (binaryExponent 0 0) f := by
    rw [binaryExponent_zero_zero]
  rw [h0, ← sum_monomial_eq_affineConic]
  exact eq_sum_monomial_of_totalDegree_le_two f hf

/-- The general affine conic has total degree at most two. -/
theorem totalDegree_affineConic_le_two (α β γ δ ε ζ : R) :
    (C α * X 0 ^ 2 + C β * (X 0 * X 1) + C γ * X 1 ^ 2 + C δ * X 0 + C ε * X 1 + C ζ :
      MvPolynomial (Fin 2) R).totalDegree ≤ 2 := by
  have h : ∀ (a b : ℕ) (c : R), a + b ≤ 2 →
      (monomial (binaryExponent a b) c : MvPolynomial (Fin 2) R).totalDegree ≤ 2 :=
    fun a b c hab => (totalDegree_monomial_binaryExponent_le a b c).trans hab
  rw [← sum_monomial_eq_affineConic]
  refine (totalDegree_add _ _).trans (max_le ?_ (h 0 0 ζ (by norm_num)))
  refine (totalDegree_add _ _).trans (max_le ?_ (h 0 1 ε (by norm_num)))
  refine (totalDegree_add _ _).trans (max_le ?_ (h 1 0 δ (by norm_num)))
  refine (totalDegree_add _ _).trans (max_le ?_ (h 0 2 γ (by norm_num)))
  exact (totalDegree_add _ _).trans (max_le (h 2 0 α (by norm_num)) (h 1 1 β (by norm_num)))

end CommSemiring

/-! ### The statements naming `affineConicPoly`

`PointedConic.affineConicPoly` is defined over a `CommRing`, so these are.  The bridge from the
`C`/`X` statements above is definitional: `affineConicPoly α β γ δ ε ζ` *is*
`C α * X 0 ^ 2 + C β * (X 0 * X 1) + C γ * X 1 ^ 2 + C δ * X 0 + C ε * X 1 + C ζ`. -/

section CommRing

variable {A : Type u} [CommRing A]

/-- The general affine conic as a sum of six monomials. -/
theorem affineConicPoly_eq_sum_monomial (α β γ δ ε ζ : A) :
    PointedConic.affineConicPoly α β γ δ ε ζ =
      monomial (binaryExponent 2 0) α + monomial (binaryExponent 1 1) β +
        monomial (binaryExponent 0 2) γ + monomial (binaryExponent 1 0) δ +
        monomial (binaryExponent 0 1) ε + monomial (binaryExponent 0 0) ζ :=
  (sum_monomial_eq_affineConic α β γ δ ε ζ).symm

/-- The `x²` coefficient of the general affine conic is `α`. -/
@[simp]
theorem coeff_affineConicPoly_two_zero (α β γ δ ε ζ : A) :
    coeff (binaryExponent 2 0) (PointedConic.affineConicPoly α β γ δ ε ζ) = α := by
  classical
  rw [affineConicPoly_eq_sum_monomial]
  simp only [coeff_add, coeff_monomial, binaryExponent_inj]
  norm_num

/-- The `x y` coefficient of the general affine conic is `β`. -/
@[simp]
theorem coeff_affineConicPoly_one_one (α β γ δ ε ζ : A) :
    coeff (binaryExponent 1 1) (PointedConic.affineConicPoly α β γ δ ε ζ) = β := by
  classical
  rw [affineConicPoly_eq_sum_monomial]
  simp only [coeff_add, coeff_monomial, binaryExponent_inj]
  norm_num

/-- The `y²` coefficient of the general affine conic is `γ`. -/
@[simp]
theorem coeff_affineConicPoly_zero_two (α β γ δ ε ζ : A) :
    coeff (binaryExponent 0 2) (PointedConic.affineConicPoly α β γ δ ε ζ) = γ := by
  classical
  rw [affineConicPoly_eq_sum_monomial]
  simp only [coeff_add, coeff_monomial, binaryExponent_inj]
  norm_num

/-- The `x` coefficient of the general affine conic is `δ`. -/
@[simp]
theorem coeff_affineConicPoly_one_zero (α β γ δ ε ζ : A) :
    coeff (binaryExponent 1 0) (PointedConic.affineConicPoly α β γ δ ε ζ) = δ := by
  classical
  rw [affineConicPoly_eq_sum_monomial]
  simp only [coeff_add, coeff_monomial, binaryExponent_inj]
  norm_num

/-- The `y` coefficient of the general affine conic is `ε`. -/
@[simp]
theorem coeff_affineConicPoly_zero_one (α β γ δ ε ζ : A) :
    coeff (binaryExponent 0 1) (PointedConic.affineConicPoly α β γ δ ε ζ) = ε := by
  classical
  rw [affineConicPoly_eq_sum_monomial]
  simp only [coeff_add, coeff_monomial, binaryExponent_inj]
  norm_num

/-- The constant coefficient of the general affine conic is `ζ`. -/
@[simp]
theorem coeff_affineConicPoly_zero (α β γ δ ε ζ : A) :
    coeff 0 (PointedConic.affineConicPoly α β γ δ ε ζ) = ζ := by
  classical
  rw [show (0 : Fin 2 →₀ ℕ) = binaryExponent 0 0 from binaryExponent_zero_zero.symm,
    affineConicPoly_eq_sum_monomial]
  simp only [coeff_add, coeff_monomial, binaryExponent_inj]
  norm_num

/-- **A polynomial in two variables of total degree at most two is exactly the general affine
conic in its six coefficients.**

This is the statement `PointedConicRationalFamilies.exists_conicChart_openImmersion` needs in
order to put the dehomogenized chart equation into `affineConicPoly` shape.  The coefficients
really are recovered: `coeff_affineConicPoly_two_zero` and its five siblings say that the six
coefficients of `affineConicPoly α β γ δ ε ζ` are `α, β, γ, δ, ε, ζ`. -/
theorem eq_affineConicPoly_of_totalDegree_le_two (f : MvPolynomial (Fin 2) A)
    (hf : f.totalDegree ≤ 2) :
    f = PointedConic.affineConicPoly (coeff (binaryExponent 2 0) f)
      (coeff (binaryExponent 1 1) f) (coeff (binaryExponent 0 2) f)
      (coeff (binaryExponent 1 0) f) (coeff (binaryExponent 0 1) f) (coeff 0 f) :=
  eq_affineConic_of_totalDegree_le_two f hf

/-- The general affine conic has total degree at most two. -/
theorem totalDegree_affineConicPoly_le_two (α β γ δ ε ζ : A) :
    (PointedConic.affineConicPoly α β γ δ ε ζ).totalDegree ≤ 2 :=
  totalDegree_affineConic_le_two α β γ δ ε ζ

/-- **Total degree at most two characterises the general affine conic.** -/
theorem totalDegree_le_two_iff_exists_affineConicPoly (f : MvPolynomial (Fin 2) A) :
    f.totalDegree ≤ 2 ↔ ∃ α β γ δ ε ζ : A, f = PointedConic.affineConicPoly α β γ δ ε ζ := by
  refine ⟨fun hf => ⟨_, _, _, _, _, _, eq_affineConicPoly_of_totalDegree_le_two f hf⟩, ?_⟩
  rintro ⟨α, β, γ, δ, ε, ζ, rfl⟩
  exact totalDegree_affineConicPoly_le_two α β γ δ ε ζ

end CommRing

end BConicBundleMultisections

