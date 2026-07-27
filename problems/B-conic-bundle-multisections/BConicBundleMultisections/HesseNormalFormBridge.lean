/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.HesseNormalFormWeierstrass
public import BConicBundleMultisections.ShortWeierstrassNormalForm
public import BConicBundleMultisections.NeZeroTwoThree

/-!
# Projective Hesse normal form for smooth plane cubics

This file closes the projective-embedding bridge left open by the elementary `j`-parameter
calculation.  The proof has four checked pieces:

1. `ShortWeierstrassNormalForm.exists_shortWeierstrass_coordinates` carries an arbitrary smooth
   ternary cubic to a short Weierstrass cubic by inverse coordinate matrices and a nonzero scalar;
2. the nonzero short discriminant supplies Mathlib's `WeierstrassCurve.IsElliptic` instance;
3. `WeierstrassCurve.exists_variableChange_of_j_eq` compares it to the explicit Weierstrass model
   of a smooth Hesse cubic, and `variableChangeMatrix` realizes that abstract variable change as an
   invertible projective `3 × 3` matrix;
4. `weierstrassToHesseMatrix` returns from the explicit Weierstrass equation to the Hesse cubic.

The final theorem records both inverse matrix identities, the nonzero equation scalar, and the
exact polynomial equality needed by downstream residual-line rigidity arguments.
-/

@[expose] public section

open MvPolynomial
open scoped Matrix

namespace BConicBundleMultisections.HesseNormalForm

universe u

variable {k : Type u} [Field k] [Infinite k]

/-! ## Projectivizing Mathlib's Weierstrass variable changes -/

/-- The homogeneous projective matrix associated to the admissible Weierstrass variable change
`(X,Y) ↦ (u²X+r, u³Y+u²sX+t)`. -/
def variableChangeMatrix (D : WeierstrassCurve.VariableChange k) :
    Matrix (Fin 3) (Fin 3) k :=
  !![(D.u : k) ^ 2, 0, D.r;
     (D.u : k) ^ 2 * D.s, (D.u : k) ^ 3, D.t;
     0, 0, 1]

/-- The projective matrix of the inverse admissible variable change. -/
def variableChangeMatrixInv (D : WeierstrassCurve.VariableChange k) :
    Matrix (Fin 3) (Fin 3) k :=
  variableChangeMatrix D⁻¹

@[simp]
theorem variableChangeMatrix_mulVec_zero
    (D : WeierstrassCurve.VariableChange k) (r : Fin 3 → k) :
    (variableChangeMatrix D *ᵥ r) 0 = (D.u : k) ^ 2 * r 0 + D.r * r 2 := by
  simp [variableChangeMatrix, Matrix.mulVec, dotProduct, Fin.sum_univ_three]

@[simp]
theorem variableChangeMatrix_mulVec_one
    (D : WeierstrassCurve.VariableChange k) (r : Fin 3 → k) :
    (variableChangeMatrix D *ᵥ r) 1 =
      (D.u : k) ^ 2 * D.s * r 0 + (D.u : k) ^ 3 * r 1 + D.t * r 2 := by
  simp [variableChangeMatrix, Matrix.mulVec, dotProduct, Fin.sum_univ_three]

@[simp]
theorem variableChangeMatrix_mulVec_two
    (D : WeierstrassCurve.VariableChange k) (r : Fin 3 → k) :
    (variableChangeMatrix D *ᵥ r) 2 = r 2 := by
  simp [variableChangeMatrix, Matrix.mulVec, dotProduct, Fin.sum_univ_three]

/-- The projective variable-change matrix has the displayed right inverse. -/
theorem variableChangeMatrix_mul_inv (D : WeierstrassCurve.VariableChange k) :
    variableChangeMatrix D * variableChangeMatrixInv D = 1 := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [variableChangeMatrixInv, variableChangeMatrix,
      WeierstrassCurve.VariableChange.inv_def, Matrix.mul_apply, Fin.sum_univ_three]
  all_goals (field_simp; ring)

/-- The projective variable-change matrix has the displayed left inverse. -/
theorem variableChangeMatrix_inv_mul (D : WeierstrassCurve.VariableChange k) :
    variableChangeMatrixInv D * variableChangeMatrix D = 1 := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [variableChangeMatrixInv, variableChangeMatrix,
      WeierstrassCurve.VariableChange.inv_def, Matrix.mul_apply, Fin.sum_univ_three]
  all_goals (field_simp; ring)

/-- Mathlib's admissible change of Weierstrass coefficients is induced by the displayed projective
matrix.  The factor `u⁶` is the expected homogeneous equation scaling. -/
theorem aeval_variableChangeMatrix_weierstrassPolynomial [Infinite k]
    (D : WeierstrassCurve.VariableChange k) (W : WeierstrassCurve k) :
    (aeval (linearSubst 2 (variableChangeMatrix D)) :
        MvPolynomial (Fin 3) k →ₐ[k] _)
        (WeierstrassCurve.Projective.polynomial W) =
      C ((D.u : k) ^ 6) *
        WeierstrassCurve.Projective.polynomial (D • W) := by
  apply MvPolynomial.funext
  intro r
  rw [eval_aeval_linearSubst, WeierstrassCurve.Projective.eval_polynomial,
    map_mul, eval_C, WeierstrassCurve.Projective.eval_polynomial]
  have h0 := variableChangeMatrix_mulVec_zero D r
  have h1 := variableChangeMatrix_mulVec_one D r
  have h2 := variableChangeMatrix_mulVec_two D r
  rw [h0, h1, h2]
  simp only [WeierstrassCurve.variableChange_a₁, WeierstrassCurve.variableChange_a₂,
    WeierstrassCurve.variableChange_a₃, WeierstrassCurve.variableChange_a₄,
    WeierstrassCurve.variableChange_a₆, Units.val_inv_eq_inv_val]
  field_simp
  ring

/-! ## The short and Hesse Weierstrass endpoints -/

/-- The Mathlib Weierstrass equation whose projective polynomial is the local short cubic. -/
noncomputable def shortWeierstrassCurve (A B : k) : WeierstrassCurve k :=
  ⟨0, 0, 0, A, B⟩

/-- The locally defined short cubic is exactly Mathlib's projective Weierstrass polynomial. -/
theorem shortWeierstrassCubic_eq_projectivePolynomial [NeZero (2 : k)] [NeZero (3 : k)] (A B : k) :
    ShortWeierstrassNormalForm.shortWeierstrassCubic A B =
      WeierstrassCurve.Projective.polynomial (shortWeierstrassCurve A B) := by
  apply MvPolynomial.funext
  intro r
  rw [ShortWeierstrassNormalForm.eval_shortWeierstrassCubic,
    WeierstrassCurve.Projective.eval_polynomial]
  simp [shortWeierstrassCurve]
  ring

/-- The Mathlib discriminant of the short equation is `-16` times the local discriminant factor. -/
theorem shortWeierstrassCurve_discriminant (A B : k) :
    (shortWeierstrassCurve A B).Δ =
      -16 * WeierstrassResidualInfinitesimalCertificate.discr A B := by
  simp [shortWeierstrassCurve, WeierstrassCurve.Δ, WeierstrassCurve.b₂,
    WeierstrassCurve.b₄, WeierstrassCurve.b₆, WeierstrassCurve.b₈,
    WeierstrassResidualInfinitesimalCertificate.discr]
  ring

/-- A nonzero local short discriminant makes the corresponding Mathlib equation elliptic. -/
theorem shortWeierstrassCurve_isElliptic [NeZero (2 : k)] [NeZero (3 : k)]
    (A B : k) (hdisc : WeierstrassResidualInfinitesimalCertificate.discr A B ≠ 0) :
    (shortWeierstrassCurve A B).IsElliptic := by
  rw [WeierstrassCurve.isElliptic_iff, shortWeierstrassCurve_discriminant]
  exact (isUnit_iff_ne_zero).2
    (mul_ne_zero (neg_ne_zero.mpr sixteen_ne_zero') hdisc)

/-- Applying the inverse explicit Hesse-to-Weierstrass matrix to its Weierstrass polynomial
recovers one third of the Hesse equation. -/
theorem aeval_weierstrassToHesseMatrix_hesseWeierstrassPolynomial
    [NeZero (2 : k)] [NeZero (3 : k)] (lam scale : k) (hscale : (lam ^ 3 - 1) * scale ^ 3 = 3) :
    (aeval (linearSubst 2 (weierstrassToHesseMatrix lam scale)) :
        MvPolynomial (Fin 3) k →ₐ[k] _)
        (WeierstrassCurve.Projective.polynomial (hesseWeierstrass lam scale)) =
      C (1 / 3) * hesseCubic lam := by
  have hscale0 : scale ≠ 0 := by
    intro hs
    rw [hs, zero_pow (by norm_num : 3 ≠ 0), mul_zero] at hscale
    exact three_ne_zero hscale.symm
  apply MvPolynomial.funext
  intro r
  rw [eval_aeval_linearSubst, WeierstrassCurve.Projective.eval_polynomial,
    map_mul, eval_C, eval_hesseCubic]
  simp [weierstrassToHesseMatrix, Matrix.mulVec, dotProduct, Fin.sum_univ_three,
    hesseWeierstrass]
  field_simp [hscale0]
  linear_combination r 0 ^ 3 * hscale

/-! ## Full projective Hesse normal form -/

/-- Every smooth ternary cubic over an algebraically closed characteristic-zero field is carried
to a nonzero scalar multiple of a smooth Hesse cubic by an explicitly invertible projective linear
coordinate change.

The matrices `M` and `N` are returned with both multiplication identities so consumers do not need
to recover invertibility from a determinant. -/
theorem exists_hesseNormalForm_coordinates [NeZero (2 : k)] [NeZero (3 : k)] [IsAlgClosed k]
    (f : MvPolynomial (Fin 3) k) (hsmooth : Standard.IsSmoothPlaneCubic f) :
    ∃ (lam c : k) (M N : Matrix (Fin 3) (Fin 3) k),
      lam ^ 3 ≠ 1 ∧ c ≠ 0 ∧ M * N = 1 ∧ N * M = 1 ∧
        (aeval (linearSubst 2 M) : MvPolynomial (Fin 3) k →ₐ[k] _) f =
          C c * hesseCubic lam := by
  obtain ⟨M₀, N₀, A, B, c₀, hMN₀, hNM₀, hc₀, heq₀, hdisc⟩ :=
    ShortWeierstrassNormalForm.exists_shortWeierstrass_coordinates f hsmooth
  let E : WeierstrassCurve k := shortWeierstrassCurve A B
  letI hE : E.IsElliptic := shortWeierstrassCurve_isElliptic A B hdisc
  have heqE :
      C c₀ * (aeval (linearSubst 2 M₀) : MvPolynomial (Fin 3) k →ₐ[k] _) f =
        WeierstrassCurve.Projective.polynomial E := by
    rw [← shortWeierstrassCubic_eq_projectivePolynomial A B]
    exact heq₀
  obtain ⟨lam, hlam, hj⟩ := exists_hesseParameter_jValue_eq E.j
  obtain ⟨scale, hscale0, hscale, hH, hHj⟩ :=
    exists_hesseWeierstrassModel lam hlam
  let H : WeierstrassCurve k := hesseWeierstrass lam scale
  letI hHE : H.IsElliptic := hH
  have hjEH : E.j = H.j := hj.symm.trans hHj.symm
  obtain ⟨D, hDE⟩ := E.exists_variableChange_of_j_eq H hjEH
  let P : Matrix (Fin 3) (Fin 3) k := variableChangeMatrix D
  let Q : Matrix (Fin 3) (Fin 3) k := variableChangeMatrixInv D
  let R : Matrix (Fin 3) (Fin 3) k := weierstrassToHesseMatrix lam scale
  let S : Matrix (Fin 3) (Fin 3) k := hesseToWeierstrassMatrix lam scale
  let M : Matrix (Fin 3) (Fin 3) k := M₀ * P * R
  let N : Matrix (Fin 3) (Fin 3) k := S * Q * N₀
  let c : k := c₀⁻¹ * (D.u : k) ^ 6 / 3
  have hPQ : P * Q = 1 := variableChangeMatrix_mul_inv D
  have hQP : Q * P = 1 := variableChangeMatrix_inv_mul D
  have hRS : R * S = 1 :=
    weierstrassToHesseMatrix_mul_hesseToWeierstrassMatrix lam scale hscale0
  have hSR : S * R = 1 :=
    hesseToWeierstrassMatrix_mul_weierstrassToHesseMatrix lam scale hscale0
  have hDpoly :
      (aeval (linearSubst 2 P) : MvPolynomial (Fin 3) k →ₐ[k] _)
          (WeierstrassCurve.Projective.polynomial E) =
        C ((D.u : k) ^ 6) * WeierstrassCurve.Projective.polynomial H := by
    simpa [P, H, hDE] using aeval_variableChangeMatrix_weierstrassPolynomial D E
  have hRpoly :
      (aeval (linearSubst 2 R) : MvPolynomial (Fin 3) k →ₐ[k] _)
          (WeierstrassCurve.Projective.polynomial H) =
        C (1 / 3) * hesseCubic lam := by
    simpa [R, H] using
      aeval_weierstrassToHesseMatrix_hesseWeierstrassPolynomial lam scale hscale
  have hc : c ≠ 0 := by
    exact div_ne_zero (mul_ne_zero (inv_ne_zero hc₀)
      (pow_ne_zero 6 (Units.ne_zero D.u))) three_ne_zero
  have hpoly :
      (aeval (linearSubst 2 M) : MvPolynomial (Fin 3) k →ₐ[k] _) f =
        C c * hesseCubic lam := by
    apply MvPolynomial.funext
    intro x
    rw [map_mul, eval_C]
    have hMr : M *ᵥ x = M₀ *ᵥ (P *ᵥ (R *ᵥ x)) := by
      calc
        M *ᵥ x = (M₀ * P) *ᵥ (R *ᵥ x) := by
          change (M₀ * P * R) *ᵥ x = (M₀ * P) *ᵥ (R *ᵥ x)
          exact (Matrix.mulVec_mulVec x (M₀ * P) R).symm
        _ = M₀ *ᵥ (P *ᵥ (R *ᵥ x)) := by
          exact (Matrix.mulVec_mulVec (R *ᵥ x) M₀ P).symm
    rw [eval_aeval_linearSubst, hMr]
    have h₀ := congrArg (eval (P *ᵥ (R *ᵥ x))) heqE
    simp only [map_mul, eval_C, eval_aeval_linearSubst] at h₀
    have h₁ := congrArg (eval (R *ᵥ x)) hDpoly
    simp only [eval_aeval_linearSubst, map_mul, eval_C] at h₁
    have h₂ := congrArg (eval x) hRpoly
    simp only [eval_aeval_linearSubst, map_mul, eval_C] at h₂
    calc
      (eval (M₀ *ᵥ (P *ᵥ (R *ᵥ x)))) f =
          c₀⁻¹ * (c₀ * eval (M₀ *ᵥ (P *ᵥ (R *ᵥ x))) f) := by
            field_simp
      _ = c₀⁻¹ * eval (P *ᵥ (R *ᵥ x))
          (WeierstrassCurve.Projective.polynomial E) := by rw [h₀]
      _ = c₀⁻¹ * ((D.u : k) ^ 6 * eval (R *ᵥ x)
          (WeierstrassCurve.Projective.polynomial H)) := by rw [h₁]
      _ = c₀⁻¹ * ((D.u : k) ^ 6 * ((1 / 3) * eval x (hesseCubic lam))) := by
        rw [h₂]
      _ = c * eval x (hesseCubic lam) := by simp [c]; ring
  refine ⟨lam, c, M, N, hlam, hc, ?_, ?_, hpoly⟩
  · change (M₀ * P * R) * (S * Q * N₀) = 1
    calc
      _ = M₀ * (P * ((R * S) * Q)) * N₀ := by simp only [Matrix.mul_assoc]
      _ = M₀ * (P * Q) * N₀ := by rw [hRS, Matrix.one_mul]
      _ = M₀ * N₀ := by rw [hPQ, Matrix.mul_one]
      _ = 1 := hMN₀
  · change (S * Q * N₀) * (M₀ * P * R) = 1
    calc
      _ = S * (Q * ((N₀ * M₀) * P)) * R := by simp only [Matrix.mul_assoc]
      _ = S * (Q * P) * R := by rw [hNM₀, Matrix.one_mul]
      _ = S * R := by rw [hQP, Matrix.mul_one]
      _ = 1 := hSR

end BConicBundleMultisections.HesseNormalForm
