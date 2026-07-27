/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.HesseNormalForm
public import Mathlib.Algebra.MvPolynomial.Funext
public import Mathlib.AlgebraicGeometry.EllipticCurve.Projective.Basic
public import BConicBundleMultisections.NeZeroTwoThree

/-!
# An explicit Weierstrass equation for a Hesse cubic

This file supplies one of the two projective-coordinate bridges needed by the Hesse-normal-form
argument.  At the flex `(0 : 1 : -1)` of the Hesse cubic, the matrix below sends the new variables
`(X,Y,Z)` to

`(U,V,W) = (uX, -lambda*uX + Y, -Y + Z)`.

If `(lambda^3 - 1) * u^3 = 3`, direct expansion identifies the transformed Hesse equation with
three times the displayed Weierstrass equation.  The inverse matrix, discriminant, and `j`-value
are all computed explicitly.
-/

@[expose] public section

open MvPolynomial
open scoped Matrix

namespace BConicBundleMultisections.HesseNormalForm

universe u

variable {k : Type u} [Field k]

/-- The coordinate matrix carrying the Hesse flex `(0 : 1 : -1)` to the point at infinity of a
Weierstrass equation. -/
def hesseToWeierstrassMatrix (lam scale : k) : Matrix (Fin 3) (Fin 3) k :=
  !![scale, 0, 0;
     -lam * scale, 1, 0;
     0, -1, 1]

/-- The inverse of `hesseToWeierstrassMatrix` when `scale` is nonzero. -/
def weierstrassToHesseMatrix (lam scale : k) : Matrix (Fin 3) (Fin 3) k :=
  !![scale⁻¹, 0, 0;
     lam, 1, 0;
     lam, 1, 1]

@[simp]
theorem hesseToWeierstrassMatrix_mulVec_zero (lam scale : k) (r : Fin 3 → k) :
    (hesseToWeierstrassMatrix lam scale *ᵥ r) 0 = scale * r 0 := by
  simp [hesseToWeierstrassMatrix, Matrix.mulVec, dotProduct, Fin.sum_univ_three]

@[simp]
theorem hesseToWeierstrassMatrix_mulVec_one (lam scale : k) (r : Fin 3 → k) :
    (hesseToWeierstrassMatrix lam scale *ᵥ r) 1 = -lam * scale * r 0 + r 1 := by
  simp [hesseToWeierstrassMatrix, Matrix.mulVec, dotProduct, Fin.sum_univ_three]

@[simp]
theorem hesseToWeierstrassMatrix_mulVec_two (lam scale : k) (r : Fin 3 → k) :
    (hesseToWeierstrassMatrix lam scale *ᵥ r) 2 = -r 1 + r 2 := by
  simp [hesseToWeierstrassMatrix, Matrix.mulVec, dotProduct, Fin.sum_univ_three]

theorem weierstrassToHesseMatrix_mul_hesseToWeierstrassMatrix
    (lam scale : k) (hscale : scale ≠ 0) :
    weierstrassToHesseMatrix lam scale * hesseToWeierstrassMatrix lam scale = 1 := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [weierstrassToHesseMatrix, hesseToWeierstrassMatrix, Matrix.mul_apply,
      Fin.sum_univ_three, hscale]

theorem hesseToWeierstrassMatrix_mul_weierstrassToHesseMatrix
    (lam scale : k) (hscale : scale ≠ 0) :
    hesseToWeierstrassMatrix lam scale * weierstrassToHesseMatrix lam scale = 1 := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [weierstrassToHesseMatrix, hesseToWeierstrassMatrix, Matrix.mul_apply,
      Fin.sum_univ_three, hscale]

/-- The Weierstrass coefficients obtained from the Hesse flex `(0 : 1 : -1)` and scale `u`. -/
def hesseWeierstrass (lam scale : k) : WeierstrassCurve k :=
  ⟨-lam * scale, -lam ^ 2 * scale ^ 2, -1, 0, -(1 / 3)⟩

variable [Infinite k] [NeZero (2 : k)] [NeZero (3 : k)]

/-- Direct polynomial identity between a Hesse cubic and its explicit Weierstrass equation. -/
theorem aeval_hesseToWeierstrassMatrix_hesseCubic
    (lam scale : k) (hscale : (lam ^ 3 - 1) * scale ^ 3 = 3) :
    (aeval (linearSubst 2 (hesseToWeierstrassMatrix lam scale)) :
        MvPolynomial (Fin 3) k →ₐ[k] _) (hesseCubic lam) =
      C 3 * WeierstrassCurve.Projective.polynomial (hesseWeierstrass lam scale) := by
  apply MvPolynomial.funext
  intro r
  rw [eval_aeval_linearSubst, eval_hesseCubic, map_mul, eval_C,
    WeierstrassCurve.Projective.eval_polynomial]
  simp [hesseToWeierstrassMatrix, Matrix.mulVec, dotProduct, Fin.sum_univ_three,
    hesseWeierstrass]
  norm_num
  linear_combination₆ (-(r 0) ^ 3) * hscale

/-- The discriminant of the explicit Weierstrass equation is its scale cubed. -/
theorem hesseWeierstrass_discriminant
    (lam scale : k) (hscale : (lam ^ 3 - 1) * scale ^ 3 = 3) :
    (hesseWeierstrass lam scale).Δ = scale ^ 3 := by
  simp [hesseWeierstrass, WeierstrassCurve.Δ, WeierstrassCurve.b₂,
    WeierstrassCurve.b₄, WeierstrassCurve.b₆, WeierstrassCurve.b₈]
  linear_combination₆ hscale

/-- The `c₄` invariant of the explicit Weierstrass equation. -/
theorem hesseWeierstrass_c₄
    (lam scale : k) (hscale : (lam ^ 3 - 1) * scale ^ 3 = 3) :
    (hesseWeierstrass lam scale).c₄ = lam * scale ^ 4 * (lam ^ 3 + 8) := by
  simp [hesseWeierstrass, WeierstrassCurve.c₄, WeierstrassCurve.b₂,
    WeierstrassCurve.b₄]
  linear_combination 8 * lam * scale * hscale

/-- A nonzero Hesse scale produces an elliptic Weierstrass equation. -/
theorem hesseWeierstrass_isElliptic
    (lam scale : k) (hscale : (lam ^ 3 - 1) * scale ^ 3 = 3) :
    (hesseWeierstrass lam scale).IsElliptic := by
  rw [WeierstrassCurve.isElliptic_iff, hesseWeierstrass_discriminant lam scale hscale]
  apply (isUnit_iff_ne_zero).2
  intro hz
  rw [hz, mul_zero] at hscale
  exact three_ne_zero hscale.symm

/-- The `j`-invariant computed from the explicit Hesse-to-Weierstrass coordinate change. -/
theorem hesseWeierstrass_j
    (lam scale : k) (hscale : (lam ^ 3 - 1) * scale ^ 3 = 3) :
    letI := hesseWeierstrass_isElliptic lam scale hscale
    (hesseWeierstrass lam scale).j = hesseJValue lam := by
  letI := hesseWeierstrass_isElliptic lam scale hscale
  rw [WeierstrassCurve.j, Units.val_inv_eq_inv_val,
    (hesseWeierstrass lam scale).coe_Δ',
    hesseWeierstrass_discriminant lam scale hscale,
    hesseWeierstrass_c₄ lam scale hscale]
  have hscale0 : scale ≠ 0 := by
    intro hz
    rw [hz, zero_pow (by norm_num : 3 ≠ 0), mul_zero] at hscale
    exact three_ne_zero hscale.symm
  have hlam0 : lam ^ 3 - 1 ≠ 0 := by
    intro hlam
    rw [hlam, zero_mul] at hscale
    exact three_ne_zero hscale.symm
  rw [hesseJValue, inv_mul_eq_div, div_eq_div_iff (pow_ne_zero 3 hscale0)
    (pow_ne_zero 3 hlam0)]
  have hscaleCubed : (lam ^ 3 - 1) ^ 3 * scale ^ 9 = 27 := by
    calc
      (lam ^ 3 - 1) ^ 3 * scale ^ 9 = ((lam ^ 3 - 1) * scale ^ 3) ^ 3 := by ring
      _ = 3 ^ 3 := by rw [hscale]
      _ = 27 := by norm_num
  linear_combination lam ^ 3 * scale ^ 3 * (lam ^ 3 + 8) ^ 3 * hscaleCubed

/-- Over an algebraically closed field, every smooth Hesse parameter admits the required nonzero
scale and hence an explicit projective Weierstrass equation with the Hesse `j`-value. -/
theorem exists_hesseWeierstrassModel [IsAlgClosed k] (lam : k) (hlam : lam ^ 3 ≠ 1) :
    ∃ scale : k,
      scale ≠ 0 ∧
      (lam ^ 3 - 1) * scale ^ 3 = 3 ∧
      ∃ hE : (hesseWeierstrass lam scale).IsElliptic,
        @WeierstrassCurve.j k _ (hesseWeierstrass lam scale) hE = hesseJValue lam := by
  obtain ⟨scale, hscaleCube⟩ :=
    IsAlgClosed.exists_pow_nat_eq (3 / (lam ^ 3 - 1)) (by norm_num : 0 < 3)
  have hlam0 : lam ^ 3 - 1 ≠ 0 := sub_ne_zero.mpr hlam
  have hscale : (lam ^ 3 - 1) * scale ^ 3 = 3 := by
    rw [hscaleCube]
    exact mul_div_cancel₀ 3 hlam0
  have hscale0 : scale ≠ 0 := by
    intro hz
    rw [hz, zero_pow (by norm_num : 3 ≠ 0), mul_zero] at hscale
    exact three_ne_zero hscale.symm
  refine ⟨scale, hscale0, hscale, hesseWeierstrass_isElliptic lam scale hscale, ?_⟩
  exact hesseWeierstrass_j lam scale hscale

end BConicBundleMultisections.HesseNormalForm
