/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.HesseNormalFormFlex
public import BConicBundleMultisections.WeierstrassResidualInfinitesimalCertificate

/-!
# Short Weierstrass normal form for a smooth plane cubic

The Hessian argument in `HesseNormalFormFlex` puts every smooth ternary cubic into general
Weierstrass support at a flex.  This file performs the remaining elementary linear changes of
coordinates: complete the square, translate the first coordinate to remove the quadratic term,
and rescale it by a cube root.  The result is the short equation

`-U^3 + V^2 W - A U W^2 - B W^3`.

Everything here is an explicit polynomial or matrix identity.  In particular, no abstract
plane-cubic/elliptic-curve comparison is used.
-/

@[expose] public section

open MvPolynomial
open scoped Matrix

namespace BConicBundleMultisections.ShortWeierstrassNormalForm

universe u

variable {k : Type u} [Field k] [CharZero k]

/-- The short Weierstrass ternary cubic used by the infinitesimal residual certificate. -/
noncomputable def shortWeierstrassCubic (A B : k) : MvPolynomial (Fin 3) k :=
  -(X 0) ^ 3 + (X 1) ^ 2 * X 2 - C A * X 0 * (X 2) ^ 2 - C B * (X 2) ^ 3

omit [CharZero k] in
/-- Evaluation of the short Weierstrass equation. -/
@[simp]
theorem eval_shortWeierstrassCubic (A B : k) (x : Fin 3 → k) :
    eval x (shortWeierstrassCubic A B) =
      -(x 0) ^ 3 + (x 1) ^ 2 * x 2 - A * x 0 * (x 2) ^ 2 - B * (x 2) ^ 3 := by
  simp [shortWeierstrassCubic]

omit [CharZero k] in
/-- The short Weierstrass equation is a homogeneous cubic. -/
theorem shortWeierstrassCubic_isHomogeneous (A B : k) :
    (shortWeierstrassCubic A B).IsHomogeneous 3 := by
  unfold shortWeierstrassCubic
  have hU : ((X (0 : Fin 3)) ^ 3 : MvPolynomial (Fin 3) k).IsHomogeneous 3 := by
    simpa using (isHomogeneous_X k (0 : Fin 3)).pow 3
  have hV : ((X (1 : Fin 3)) ^ 2 * X 2 : MvPolynomial (Fin 3) k).IsHomogeneous 3 := by
    simpa using ((isHomogeneous_X k (1 : Fin 3)).pow 2).mul
      (isHomogeneous_X k (2 : Fin 3))
  have hA : (C A * X (0 : Fin 3) * (X 2) ^ 2 : MvPolynomial (Fin 3) k).IsHomogeneous 3 := by
    simpa [add_assoc] using
      ((isHomogeneous_C (Fin 3) A).mul (isHomogeneous_X k (0 : Fin 3))).mul
        ((isHomogeneous_X k (2 : Fin 3)).pow 2)
  have hB : (C B * (X (2 : Fin 3)) ^ 3 : MvPolynomial (Fin 3) k).IsHomogeneous 3 := by
    simpa using (isHomogeneous_C (Fin 3) B).mul
      ((isHomogeneous_X k (2 : Fin 3)).pow 3)
  exact ((hU.neg.add hV).sub hA).sub hB

omit [CharZero k] in
@[simp]
theorem eval_pderiv_zero_shortWeierstrassCubic (A B : k) (x : Fin 3 → k) :
    eval x (pderiv 0 (shortWeierstrassCubic A B)) =
      -3 * (x 0) ^ 2 - A * (x 2) ^ 2 := by
  simp [shortWeierstrassCubic]
  ring

omit [CharZero k] in
@[simp]
theorem eval_pderiv_one_shortWeierstrassCubic (A B : k) (x : Fin 3 → k) :
    eval x (pderiv 1 (shortWeierstrassCubic A B)) =
      2 * x 1 * x 2 := by
  simp [shortWeierstrassCubic]
  ring

omit [CharZero k] in
@[simp]
theorem eval_pderiv_two_shortWeierstrassCubic (A B : k) (x : Fin 3 → k) :
    eval x (pderiv 2 (shortWeierstrassCubic A B)) =
      (x 1) ^ 2 - 2 * A * x 0 * x 2 - 3 * B * (x 2) ^ 2 := by
  simp [shortWeierstrassCubic]
  ring

/-- Smoothness of a short Weierstrass cubic forces its classical discriminant factor to be
nonzero. -/
theorem discr_ne_zero_of_isSmoothPlaneCubic (A B : k)
    (hsmooth : Standard.IsSmoothPlaneCubic (shortWeierstrassCubic A B)) :
    WeierstrassResidualInfinitesimalCertificate.discr A B ≠ 0 := by
  intro hdisc
  by_cases hA : A = 0
  · have hB : B = 0 := by
      rw [WeierstrassResidualInfinitesimalCertificate.discr, hA] at hdisc
      norm_num at hdisc
      exact hdisc
    let x : Fin 3 → k := ![0, 0, 1]
    have hx0 : x ≠ 0 := by
      intro h
      have := congrFun h (2 : Fin 3)
      simp [x] at this
    have hxF : eval x (shortWeierstrassCubic A B) = 0 := by
      simp [x, hA, hB]
    obtain ⟨i, hi⟩ := hsmooth.2 x hx0 hxF
    apply hi
    fin_cases i <;> simp [x, hA, hB]
  · let r : k := -3 * B / (2 * A)
    have hrder : 3 * r ^ 2 + A = 0 := by
      dsimp [r]
      field_simp [hA]
      linear_combination hdisc
    have hrcubic : r ^ 3 + A * r + B = 0 := by
      dsimp [r]
      field_simp [hA]
      linear_combination -B * hdisc
    let x : Fin 3 → k := ![r, 0, 1]
    have hx0 : x ≠ 0 := by
      intro h
      have := congrFun h (2 : Fin 3)
      simp [x] at this
    have hxF : eval x (shortWeierstrassCubic A B) = 0 := by
      rw [eval_shortWeierstrassCubic]
      simp [x]
      linear_combination -hrcubic
    obtain ⟨i, hi⟩ := hsmooth.2 x hx0 hxF
    apply hi
    fin_cases i
    · simp [x]
      linear_combination -hrder
    · simp [x]
    · simp [x]
      linear_combination -3 * hrcubic + r * hrder

/-! ## Reduction of general Weierstrass support -/

/-- The coefficient left after completing the square in the second coordinate. -/
def squareReducedU2W (e f : k) : k := e - f ^ 2 / 4

/-- The coefficient left after completing the square in the second coordinate. -/
def squareReducedUW2 (f i j : k) : k := i - f * j / 2

/-- The coefficient left after completing the square in the second coordinate. -/
def squareReducedW3 (j k₀ : k) : k := k₀ - j ^ 2 / 4

/-- The `A` parameter after completing the square, translating `U`, and scaling `W`. -/
def reducedA (a e f i j : k) : k :=
  a * squareReducedUW2 f i j - (squareReducedU2W e f) ^ 2 / 3

/-- The `B` parameter after completing the square, translating `U`, and scaling `W`. -/
def reducedB (a e f i j k₀ : k) : k :=
  -a ^ 2 * squareReducedW3 j k₀ +
    a * squareReducedUW2 f i j * squareReducedU2W e f / 3 -
      2 * (squareReducedU2W e f) ^ 3 / 27

/-- Combined coordinate matrix for completing the square, translating `U`, and replacing
`W` by `-aW`. -/
def reductionMatrix (a e f j : k) : Matrix (Fin 3) (Fin 3) k :=
  !![1, 0, squareReducedU2W e f / 3;
     -f / 2, 1, -f * squareReducedU2W e f / 6 + a * j / 2;
     0, 0, -a]

/-- Explicit inverse of `reductionMatrix`. -/
def reductionMatrixInv (a e f j : k) : Matrix (Fin 3) (Fin 3) k :=
  !![1, 0, squareReducedU2W e f / (3 * a);
     f / 2, 1, j / 2;
     0, 0, -a⁻¹]

theorem reductionMatrix_mul_inv (a e f j : k) (ha : a ≠ 0) :
    reductionMatrix a e f j * reductionMatrixInv a e f j = 1 := by
  ext r s
  fin_cases r <;> fin_cases s <;>
    simp [reductionMatrix, reductionMatrixInv, Matrix.mul_apply, Fin.sum_univ_three,
      squareReducedU2W, ha] <;> field_simp [ha] <;> ring

theorem reductionMatrixInv_mul (a e f j : k) (ha : a ≠ 0) :
    reductionMatrixInv a e f j * reductionMatrix a e f j = 1 := by
  exact mul_eq_one_comm.mp (reductionMatrix_mul_inv a e f j ha)

/-- The direct polynomial calculation reducing general Weierstrass support to the short equation.
The scalar `-a⁻¹` does not change the projective cubic. -/
theorem reduce_weierstrassSupport
    (g : MvPolynomial (Fin 3) k) (hg : g.IsHomogeneous 3)
    (hV3 : PlaneCubicResidual.coeffV3 g = 0)
    (hUV2 : PlaneCubicResidual.coeffUV2 g = 0)
    (hV2W : PlaneCubicResidual.coeffV2W g = 1)
    (hU2V : PlaneCubicResidual.coeffU2V g = 0)
    (ha : PlaneCubicResidual.coeffU3 g ≠ 0) :
    let a := PlaneCubicResidual.coeffU3 g
    let e := PlaneCubicResidual.coeffU2W g
    let f := PlaneCubicResidual.coeffUVW g
    let i := PlaneCubicResidual.coeffUW2 g
    let j := PlaneCubicResidual.coeffVW2 g
    let k₀ := PlaneCubicResidual.coeffW3 g
    C (-a⁻¹) *
        (aeval (linearSubst 2 (reductionMatrix a e f j)) :
          MvPolynomial (Fin 3) k →ₐ[k] _) g =
      shortWeierstrassCubic (reducedA a e f i j) (reducedB a e f i j k₀) := by
  dsimp only
  apply MvPolynomial.funext
  intro x
  rw [map_mul, eval_C, eval_aeval_linearSubst,
    PlaneCubicResidual.eval_eq_planeCubicValue hg,
    eval_shortWeierstrassCubic]
  simp [reductionMatrix, Matrix.mulVec, dotProduct, Fin.sum_univ_three]
  simp [UniversalResidual.planeCubicValue, hV3, hUV2, hV2W, hU2V,
    reducedA, reducedB, squareReducedU2W, squareReducedUW2, squareReducedW3]
  field_simp [ha]
  ring

omit [CharZero k] in
/-- Multiplying a smooth homogeneous equation by a nonzero scalar preserves the coordinate
Jacobian criterion. -/
theorem isSmoothPlaneCubic_C_mul (c : k) (hc : c ≠ 0)
    (g : MvPolynomial (Fin 3) k) (hg : Standard.IsSmoothPlaneCubic g) :
    Standard.IsSmoothPlaneCubic (C c * g) := by
  refine ⟨hg.1.C_mul c, ?_⟩
  intro x hx hzero
  have hxg : eval x g = 0 := by
    rw [map_mul, eval_C] at hzero
    exact (mul_eq_zero.mp hzero).resolve_left hc
  obtain ⟨i, hi⟩ := hg.2 x hx hxg
  refine ⟨i, ?_⟩
  rw [pderiv_C_mul, map_mul, eval_C]
  exact mul_ne_zero hc hi

/-- Composition law for the explicit linear substitutions. -/
theorem aeval_linearSubst_comp (P M : Matrix (Fin 3) (Fin 3) k)
    (g : MvPolynomial (Fin 3) k) :
    (aeval (linearSubst 2 P) : MvPolynomial (Fin 3) k →ₐ[k] _)
        ((aeval (linearSubst 2 M) : MvPolynomial (Fin 3) k →ₐ[k] _) g) =
      (aeval (linearSubst 2 (M * P)) : MvPolynomial (Fin 3) k →ₐ[k] _) g := by
  apply MvPolynomial.funext
  intro x
  rw [eval_aeval_linearSubst, eval_aeval_linearSubst, eval_aeval_linearSubst,
    Matrix.mulVec_mulVec]

/-- General Weierstrass support reduces to a smooth short Weierstrass equation by an invertible
linear substitution and a nonzero scalar. -/
theorem exists_shortWeierstrass_of_weierstrassSupport
    [IsAlgClosed k] (g : MvPolynomial (Fin 3) k)
    (hsmooth : Standard.IsSmoothPlaneCubic g)
    (hV3 : PlaneCubicResidual.coeffV3 g = 0)
    (hUV2 : PlaneCubicResidual.coeffUV2 g = 0)
    (hV2W : PlaneCubicResidual.coeffV2W g = 1)
    (hU2V : PlaneCubicResidual.coeffU2V g = 0) :
    ∃ (P N : Matrix (Fin 3) (Fin 3) k) (A B c : k),
      P * N = 1 ∧ N * P = 1 ∧ c ≠ 0 ∧
        C c * (aeval (linearSubst 2 P) : MvPolynomial (Fin 3) k →ₐ[k] _) g =
          shortWeierstrassCubic A B ∧
        WeierstrassResidualInfinitesimalCertificate.discr A B ≠ 0 := by
  let a := PlaneCubicResidual.coeffU3 g
  let e := PlaneCubicResidual.coeffU2W g
  let f := PlaneCubicResidual.coeffUVW g
  let i := PlaneCubicResidual.coeffUW2 g
  let j := PlaneCubicResidual.coeffVW2 g
  let k₀ := PlaneCubicResidual.coeffW3 g
  have ha : a ≠ 0 := by
    dsimp [a]
    exact HesseNormalForm.coeffU3_ne_zero_of_smooth_of_lineSupport
      g hsmooth.1 hsmooth.2 hU2V hUV2 hV3
  let P := reductionMatrix a e f j
  let N := reductionMatrixInv a e f j
  let A := reducedA a e f i j
  let B := reducedB a e f i j k₀
  let c := -a⁻¹
  have hPN : P * N = 1 := reductionMatrix_mul_inv a e f j ha
  have hNP : N * P = 1 := reductionMatrixInv_mul a e f j ha
  have hc : c ≠ 0 := neg_ne_zero.mpr (inv_ne_zero ha)
  have heq :
      C c * (aeval (linearSubst 2 P) : MvPolynomial (Fin 3) k →ₐ[k] _) g =
        shortWeierstrassCubic A B := by
    simpa [a, e, f, i, j, k₀, P, A, B, c] using
      reduce_weierstrassSupport g hsmooth.1 hV3 hUV2 hV2W hU2V
        (HesseNormalForm.coeffU3_ne_zero_of_smooth_of_lineSupport
          g hsmooth.1 hsmooth.2 hU2V hUV2 hV3)
  have hPg : Standard.IsSmoothPlaneCubic
      ((aeval (linearSubst 2 P) : MvPolynomial (Fin 3) k →ₐ[k] _) g) :=
    ⟨isHomogeneous_aeval_linearSubst P hsmooth.1,
      nonsingular_aeval_linearSubst_of_nonsingular 2 P N hPN g hsmooth.2⟩
  have hshort : Standard.IsSmoothPlaneCubic (shortWeierstrassCubic A B) := by
    rw [← heq]
    exact isSmoothPlaneCubic_C_mul c hc _ hPg
  exact ⟨P, N, A, B, c, hPN, hNP, hc, heq,
    discr_ne_zero_of_isSmoothPlaneCubic A B hshort⟩

/-- Every smooth plane cubic over an algebraically closed characteristic-zero field admits a
faithful short Weierstrass coordinate model. -/
theorem exists_shortWeierstrass_coordinates
    [IsAlgClosed k] (g : MvPolynomial (Fin 3) k)
    (hsmooth : Standard.IsSmoothPlaneCubic g) :
    ∃ (M N : Matrix (Fin 3) (Fin 3) k) (A B c : k),
      M * N = 1 ∧ N * M = 1 ∧ c ≠ 0 ∧
        C c * (aeval (linearSubst 2 M) : MvPolynomial (Fin 3) k →ₐ[k] _) g =
          shortWeierstrassCubic A B ∧
        WeierstrassResidualInfinitesimalCertificate.discr A B ≠ 0 := by
  obtain ⟨M₀, N₀, hMN₀, hNM₀, hsupp, hV3, hUV2, hV2W, hU2V, _hU3⟩ :=
    HesseNormalForm.exists_weierstrassSupport_coordinates g hsmooth
  let g₀ :=
    (aeval (linearSubst 2 M₀) : MvPolynomial (Fin 3) k →ₐ[k] _) g
  obtain ⟨P, Q, A, B, c, hPQ, hQP, hc, heq, hdisc⟩ :=
    exists_shortWeierstrass_of_weierstrassSupport g₀ hsupp hV3 hUV2 hV2W hU2V
  refine ⟨M₀ * P, Q * N₀, A, B, c, ?_, ?_, hc, ?_, hdisc⟩
  · calc
      (M₀ * P) * (Q * N₀) = M₀ * ((P * Q) * N₀) := by simp [Matrix.mul_assoc]
      _ = 1 := by rw [hPQ, one_mul, hMN₀]
  · calc
      (Q * N₀) * (M₀ * P) = Q * ((N₀ * M₀) * P) := by simp [Matrix.mul_assoc]
      _ = 1 := by rw [hNM₀, one_mul, hQP]
  · rw [← heq]
    congr 1
    exact (aeval_linearSubst_comp P M₀ g).symm

end BConicBundleMultisections.ShortWeierstrassNormalForm
