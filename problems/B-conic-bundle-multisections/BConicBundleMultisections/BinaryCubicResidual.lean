/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.ProjectiveLineRestriction

/-!
# The residual linear factor of a binary cubic

This file gives a coefficient normal form for a homogeneous binary cubic. If the value and
the transverse derivative vanish at `[1 : 0]`, the cubic has an `X₁²` factor; its remaining
factor is the explicitly defined `binaryCubicResidualLinearForm`.

The final specialization applies this algebraic factorization to the restriction of a cubic
to a line with double contact at its first endpoint. This is only a polynomial-level double
contact statement. It does not assert that the residual linear form is nonzero, or that it
therefore determines a projective residual point.
-/

@[expose] public section

open MvPolynomial

namespace BConicBundleMultisections

noncomputable section

universe u v

variable {R : Type u} [CommSemiring R]

/-- The exponent vector `(a,b)` in two variables. -/
def binaryExponent (a b : ℕ) : Fin 2 →₀ ℕ :=
  Finsupp.single 0 a + Finsupp.single 1 b

@[simp]
theorem binaryExponent_zero (a b : ℕ) : binaryExponent a b 0 = a := by
  simp [binaryExponent]

@[simp]
theorem binaryExponent_one (a b : ℕ) : binaryExponent a b 1 = b := by
  simp [binaryExponent]

@[simp]
theorem binaryExponent_degree (a b : ℕ) :
    (binaryExponent a b).degree = a + b := by
  rw [Finsupp.degree_eq_sum]
  simp [Fin.sum_univ_two]

@[simp]
theorem binaryExponent_inj {a b c d : ℕ} :
    binaryExponent a b = binaryExponent c d ↔ a = c ∧ b = d := by
  constructor
  · intro h
    exact ⟨by simpa using congrArg (fun z : Fin 2 →₀ ℕ ↦ z 0) h,
      by simpa using congrArg (fun z : Fin 2 →₀ ℕ ↦ z 1) h⟩
  · rintro ⟨rfl, rfl⟩
    rfl

/-- The coefficient normal form of a homogeneous binary cubic. -/
theorem binaryCubic_eq_sum_monomials
    (f : MvPolynomial (Fin 2) R) (hf : f.IsHomogeneous 3) :
    f = monomial (binaryExponent 3 0) (coeff (binaryExponent 3 0) f) +
      monomial (binaryExponent 2 1) (coeff (binaryExponent 2 1) f) +
      monomial (binaryExponent 1 2) (coeff (binaryExponent 1 2) f) +
      monomial (binaryExponent 0 3) (coeff (binaryExponent 0 3) f) := by
  classical
  ext d
  by_cases hd : d.degree = 3
  · have hsum : d 0 + d 1 = 3 := by
      rw [Finsupp.degree_eq_sum, Fin.sum_univ_two] at hd
      exact hd
    have hcases : d 1 = 0 ∨ d 1 = 1 ∨ d 1 = 2 ∨ d 1 = 3 := by omega
    rcases hcases with h | h | h | h
    · have heq : d = binaryExponent 3 0 := by
        ext i
        fin_cases i
        · simp [binaryExponent]
          omega
        · simp [binaryExponent, h]
      subst d
      simp only [coeff_add, coeff_monomial, binaryExponent_inj]
      norm_num
    · have heq : d = binaryExponent 2 1 := by
        ext i
        fin_cases i
        · simp [binaryExponent]
          omega
        · simp [binaryExponent, h]
      subst d
      simp only [coeff_add, coeff_monomial, binaryExponent_inj]
      norm_num
    · have heq : d = binaryExponent 1 2 := by
        ext i
        fin_cases i
        · simp [binaryExponent]
          omega
        · simp [binaryExponent, h]
      subst d
      simp only [coeff_add, coeff_monomial, binaryExponent_inj]
      norm_num
    · have heq : d = binaryExponent 0 3 := by
        ext i
        fin_cases i
        · simp [binaryExponent]
          omega
        · simp [binaryExponent, h]
      subst d
      simp only [coeff_add, coeff_monomial, binaryExponent_inj]
      norm_num
  · rw [hf.coeff_eq_zero hd]
    symm
    apply IsHomogeneous.coeff_eq_zero _ hd
    exact (((isHomogeneous_monomial _ (binaryExponent_degree 3 0)).add
      (isHomogeneous_monomial _ (binaryExponent_degree 2 1))).add
      (isHomogeneous_monomial _ (binaryExponent_degree 1 2))).add
      (isHomogeneous_monomial _ (binaryExponent_degree 0 3))

/-- Evaluation at `[1 : 0]` extracts the `X₀³` coefficient of a homogeneous binary cubic. -/
theorem eval_binaryFirstEndpoint_binaryCubic
    (f : MvPolynomial (Fin 2) R) (hf : f.IsHomogeneous 3) :
    eval (binaryFirstEndpoint (R := R)) f = coeff (binaryExponent 3 0) f := by
  conv_lhs => rw [binaryCubic_eq_sum_monomials f hf]
  simp [binaryFirstEndpoint, eval_monomial, binaryExponent]

/-- At `[1 : 0]`, differentiation in the second binary coordinate extracts the
`X₀²X₁` coefficient of a homogeneous binary cubic. -/
theorem eval_pderiv_one_binaryFirstEndpoint_binaryCubic
    (f : MvPolynomial (Fin 2) R) (hf : f.IsHomogeneous 3) :
    eval (binaryFirstEndpoint (R := R)) (pderiv (1 : Fin 2) f) =
      coeff (binaryExponent 2 1) f := by
  conv_lhs => rw [binaryCubic_eq_sum_monomials f hf]
  simp [binaryFirstEndpoint, eval_monomial, binaryExponent]

/-- The linear factor left after removing an `X₁²` factor from a homogeneous binary cubic. -/
def binaryCubicResidualLinearForm (f : MvPolynomial (Fin 2) R) :
    MvPolynomial (Fin 2) R :=
  C (coeff (binaryExponent 1 2) f) * X 0 +
    C (coeff (binaryExponent 0 3) f) * X 1

/-- The residual linear form is homogeneous of degree one. -/
theorem binaryCubicResidualLinearForm_isHomogeneous (f : MvPolynomial (Fin 2) R) :
    (binaryCubicResidualLinearForm f).IsHomogeneous 1 := by
  exact (isHomogeneous_C_mul_X (coeff (binaryExponent 1 2) f) (0 : Fin 2)).add
    (isHomogeneous_C_mul_X (coeff (binaryExponent 0 3) f) (1 : Fin 2))

/-- If the `X₀³` and `X₀²X₁` coefficients of a homogeneous binary cubic vanish, then
the cubic is `X₁²` times its residual linear form. -/
theorem binaryCubic_eq_X_one_sq_mul
    (f : MvPolynomial (Fin 2) R) (hf : f.IsHomogeneous 3)
    (h30 : coeff (binaryExponent 3 0) f = 0)
    (h21 : coeff (binaryExponent 2 1) f = 0) :
    f = X 1 ^ 2 * binaryCubicResidualLinearForm f := by
  classical
  have hfactor :
      X (R := R) 1 ^ 2 * binaryCubicResidualLinearForm f =
        monomial (binaryExponent 1 2) (coeff (binaryExponent 1 2) f) +
          monomial (binaryExponent 0 3) (coeff (binaryExponent 0 3) f) := by
    have h12 : Finsupp.single (1 : Fin 2) 2 + Finsupp.single 0 1 =
        binaryExponent 1 2 := by
      ext i
      fin_cases i <;> simp [binaryExponent]
    have h03 : Finsupp.single (1 : Fin 2) 2 + Finsupp.single 1 1 =
        binaryExponent 0 3 := by
      ext i
      fin_cases i <;> simp [binaryExponent]
    rw [binaryCubicResidualLinearForm, mul_add, X_pow_eq_monomial, C_mul_X_eq_monomial,
      C_mul_X_eq_monomial, monomial_mul, monomial_mul, one_mul, one_mul, h12, h03]
  conv_lhs =>
    rw [binaryCubic_eq_sum_monomials f hf, h30, h21, monomial_zero,
      monomial_zero, zero_add, zero_add]
  exact hfactor.symm

/-- Endpoint value and transverse-derivative vanishing give the polynomial factorization
`f = X₁² * binaryCubicResidualLinearForm f`. -/
theorem binaryCubic_eq_X_one_sq_mul_of_endpoint_vanishing
    (f : MvPolynomial (Fin 2) R) (hf : f.IsHomogeneous 3)
    (hvalue : eval (binaryFirstEndpoint (R := R)) f = 0)
    (hderiv : eval (binaryFirstEndpoint (R := R)) (pderiv (1 : Fin 2) f) = 0) :
    f = X 1 ^ 2 * binaryCubicResidualLinearForm f := by
  apply binaryCubic_eq_X_one_sq_mul f hf
  · rw [← eval_binaryFirstEndpoint_binaryCubic f hf]
    exact hvalue
  · rw [← eval_pderiv_one_binaryFirstEndpoint_binaryCubic f hf]
    exact hderiv

variable {σ : Type v} [Fintype σ]

/-- A cubic restricted to a line through a point in a tangent direction has the expected
`X₁²` factor. This theorem makes no claim that the residual linear form is nonzero. -/
theorem binaryLineRestriction_eq_X_one_sq_mul_residualLinearForm
    (f : MvPolynomial σ R) (hf : f.IsHomogeneous 3) (p q : σ → R)
    (hp : eval p f = 0) (hq : q ∈ tangentHyperplaneCone f p) :
    binaryLineRestriction p q f = X 1 ^ 2 *
      binaryCubicResidualLinearForm (binaryLineRestriction p q f) := by
  apply binaryCubic_eq_X_one_sq_mul_of_endpoint_vanishing
    (binaryLineRestriction p q f) (binaryLineRestriction_isHomogeneous hf p q)
  · exact (binaryLineRestriction_double_contact_first f p q hp hq).1
  · exact (binaryLineRestriction_double_contact_first f p q hp hq).2

end

end BConicBundleMultisections
