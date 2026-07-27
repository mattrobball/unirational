/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.Standard.G3G4FrameIncidence
public import BConicBundleMultisections.Standard.G3G4NonsingularLineSelectionEndpoint
public import BConicBundleMultisections.HesseResidualMapBridge

/-!
# Selecting a G3 frame on a prescribed open of a smooth cubic

This file discharges the frame-incidence principle isolated in
`G3G4NonsingularLineSelection`.  The only coordinate calculation needed is the covariance of the
residual line under the two elementary changes of basis used to move the first column of a good
frame to an intersection point of its line with the cubic.
-/

@[expose] public section

namespace BConicBundleMultisections.Standard

noncomputable section

universe u

open MvPolynomial
open _root_.MvPolynomial
open ResidualDivisor
open scoped Matrix

variable {K : Type u} [Field K] [Infinite K]

/-- Change the first line-basis vector from `p` to `s p + t q`, keeping `q` fixed. -/
def lineReframe (s t : K) : Matrix (Fin 3) (Fin 3) K :=
  !![s, 0, 0; t, 1, 0; 0, 0, 1]

/-- The inverse of `lineReframe`, when `s` is nonzero. -/
def lineReframeInv (s t : K) : Matrix (Fin 3) (Fin 3) K :=
  !![s⁻¹, 0, 0; -t * s⁻¹, 1, 0; 0, 0, 1]

theorem lineReframe_mul_inv (s t : K) (hs : s ≠ 0) :
    lineReframe s t * lineReframeInv s t = 1 := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [lineReframe, lineReframeInv, Matrix.mul_apply, Fin.sum_univ_three, hs]

/-- In the exceptional chart, change the first line-basis vector to `t q` and use `p` second. -/
def lineSwapReframe (t : K) : Matrix (Fin 3) (Fin 3) K :=
  !![0, 1, 0; t, 0, 0; 0, 0, 1]

/-- The inverse of `lineSwapReframe`, when `t` is nonzero. -/
def lineSwapReframeInv (t : K) : Matrix (Fin 3) (Fin 3) K :=
  !![0, t⁻¹, 0; 1, 0, 0; 0, 0, 1]

theorem lineSwapReframe_mul_inv (t : K) (ht : t ≠ 0) :
    lineSwapReframe t * lineSwapReframeInv t = 1 := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [lineSwapReframe, lineSwapReframeInv, Matrix.mul_apply, Fin.sum_univ_three, ht]

set_option maxRecDepth 10000 in
/-- Coefficients of a cubic after the triangular change of its first two coordinates. -/
theorem coefficients_lineReframe [NeZero (2 : K)] [NeZero (3 : K)]
    (G : MvPolynomial (Fin 3) K) (hG : G.IsHomogeneous 3) (s t : K) :
    let T := (aeval (linearSubst 2 (lineReframe s t)) :
      MvPolynomial (Fin 3) K →ₐ[K] _) G
    PlaneCubicResidual.coeffU3 T =
        PlaneCubicResidual.coeffU3 G * s ^ 3 +
          PlaneCubicResidual.coeffU2V G * s ^ 2 * t +
          PlaneCubicResidual.coeffUV2 G * s * t ^ 2 +
          PlaneCubicResidual.coeffV3 G * t ^ 3 ∧
    PlaneCubicResidual.coeffU2V T =
        PlaneCubicResidual.coeffU2V G * s ^ 2 +
          2 * PlaneCubicResidual.coeffUV2 G * s * t +
          3 * PlaneCubicResidual.coeffV3 G * t ^ 2 ∧
    PlaneCubicResidual.coeffUV2 T =
        PlaneCubicResidual.coeffUV2 G * s +
          3 * PlaneCubicResidual.coeffV3 G * t ∧
    PlaneCubicResidual.coeffV3 T = PlaneCubicResidual.coeffV3 G ∧
    PlaneCubicResidual.coeffU2W T =
        PlaneCubicResidual.coeffU2W G * s ^ 2 +
          PlaneCubicResidual.coeffUVW G * s * t +
          PlaneCubicResidual.coeffV2W G * t ^ 2 ∧
    PlaneCubicResidual.coeffUVW T =
        PlaneCubicResidual.coeffUVW G * s +
          2 * PlaneCubicResidual.coeffV2W G * t ∧
    PlaneCubicResidual.coeffV2W T = PlaneCubicResidual.coeffV2W G ∧
    PlaneCubicResidual.coeffUW2 T =
        PlaneCubicResidual.coeffUW2 G * s +
          PlaneCubicResidual.coeffVW2 G * t ∧
    PlaneCubicResidual.coeffVW2 T = PlaneCubicResidual.coeffVW2 G ∧
    PlaneCubicResidual.coeffW3 T = PlaneCubicResidual.coeffW3 G := by
  let T := (aeval (linearSubst 2 (lineReframe s t)) :
    MvPolynomial (Fin 3) K →ₐ[K] _) G
  have hT : T.IsHomogeneous 3 := isHomogeneous_aeval_linearSubst _ hG
  let A := PlaneCubicResidual.coeffU3 G * s ^ 3 +
    PlaneCubicResidual.coeffU2V G * s ^ 2 * t +
    PlaneCubicResidual.coeffUV2 G * s * t ^ 2 + PlaneCubicResidual.coeffV3 G * t ^ 3
  let B := PlaneCubicResidual.coeffU2V G * s ^ 2 +
    2 * PlaneCubicResidual.coeffUV2 G * s * t +
    3 * PlaneCubicResidual.coeffV3 G * t ^ 2
  let Cc := PlaneCubicResidual.coeffUV2 G * s + 3 * PlaneCubicResidual.coeffV3 G * t
  let D := PlaneCubicResidual.coeffV3 G
  let E := PlaneCubicResidual.coeffU2W G * s ^ 2 +
    PlaneCubicResidual.coeffUVW G * s * t + PlaneCubicResidual.coeffV2W G * t ^ 2
  let FF := PlaneCubicResidual.coeffUVW G * s + 2 * PlaneCubicResidual.coeffV2W G * t
  let HH := PlaneCubicResidual.coeffV2W G
  let I := PlaneCubicResidual.coeffUW2 G * s + PlaneCubicResidual.coeffVW2 G * t
  let J := PlaneCubicResidual.coeffVW2 G
  let KK := PlaneCubicResidual.coeffW3 G
  have hz : ∀ U V W : K,
      (PlaneCubicResidual.coeffU3 T - A) * U ^ 3 +
        (PlaneCubicResidual.coeffU2V T - B) * U ^ 2 * V +
        (PlaneCubicResidual.coeffUV2 T - Cc) * U * V ^ 2 +
        (PlaneCubicResidual.coeffV3 T - D) * V ^ 3 +
        (PlaneCubicResidual.coeffU2W T - E) * U ^ 2 * W +
        (PlaneCubicResidual.coeffUVW T - FF) * U * V * W +
        (PlaneCubicResidual.coeffV2W T - HH) * V ^ 2 * W +
        (PlaneCubicResidual.coeffUW2 T - I) * U * W ^ 2 +
        (PlaneCubicResidual.coeffVW2 T - J) * V * W ^ 2 +
        (PlaneCubicResidual.coeffW3 T - KK) * W ^ 3 = 0 := by
    intro U V W
    let z : Fin 3 → K := ![U, V, W]
    have hTv := PlaneCubicResidual.eval_eq_planeCubicValue hT z
    let w : Fin 3 → K := Matrix.mulVec (lineReframe s t) z
    have hGv := PlaneCubicResidual.eval_eq_planeCubicValue hG w
    have hsub := eval_aeval_linearSubst 2 (lineReframe s t) G z
    change eval z T = eval w G at hsub
    rw [hTv, hGv] at hsub
    simp [z, w, UniversalResidual.planeCubicValue, lineReframe, Matrix.mulVec,
      dotProduct, Fin.sum_univ_three] at hsub
    dsimp only [A, B, Cc, D, E, FF, HH, I, J, KK]
    linear_combination hsub
  obtain ⟨ha, hb, hc, hd, he, hf, hh, hi, hj, hk⟩ :=
    HesseResidualMapBridge.ternaryCubic_coefficients_eq_zero
      (PlaneCubicResidual.coeffU3 T - A)
      (PlaneCubicResidual.coeffU2V T - B)
      (PlaneCubicResidual.coeffUV2 T - Cc)
      (PlaneCubicResidual.coeffV3 T - D)
      (PlaneCubicResidual.coeffU2W T - E)
      (PlaneCubicResidual.coeffUVW T - FF)
      (PlaneCubicResidual.coeffV2W T - HH)
      (PlaneCubicResidual.coeffUW2 T - I)
      (PlaneCubicResidual.coeffVW2 T - J)
      (PlaneCubicResidual.coeffW3 T - KK) hz
  dsimp only [T, A, B, Cc, D, E, FF, HH, I, J, KK] at ha hb hc hd he hf hh hi hj hk ⊢
  exact ⟨sub_eq_zero.mp ha, sub_eq_zero.mp hb, sub_eq_zero.mp hc, sub_eq_zero.mp hd,
    sub_eq_zero.mp he, sub_eq_zero.mp hf, sub_eq_zero.mp hh, sub_eq_zero.mp hi,
    sub_eq_zero.mp hj, sub_eq_zero.mp hk⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 1000000 in
/-- The residual covariant has weight six under the triangular reparameterization of a line. -/
theorem residualLinearFormOn_lineReframe [NeZero (2 : K)] [NeZero (3 : K)]
    (G : MvPolynomial (Fin 3) K) (hG : G.IsHomogeneous 3)
    (s t : K) (hs : s ≠ 0) :
    residualLinearFormOn (lineReframe s t) (lineReframeInv s t) G =
      C (s ^ 6) * PlaneCubicResidual.residualLinearForm G := by
  obtain ⟨ha, hb, hc, hd, he, hf, hh, hi, hj, hk⟩ :=
    coefficients_lineReframe G hG s t
  apply MvPolynomial.funext
  intro y
  rw [eval_residualLinearFormOn, PlaneCubicResidual.eval_residualLinearForm,
    ha, hb, hc, hd, he, hf, hh, hi, hj, hk, map_mul, eval_C,
    PlaneCubicResidual.eval_residualLinearForm]
  simp [lineReframeInv, Matrix.mulVec, dotProduct, Fin.sum_univ_three]
  dsimp only [UniversalResidual.residualLinear, UniversalResidual.residualCoeffU,
    UniversalResidual.residualCoeffV, UniversalResidual.residualCoeffW]
  field_simp [hs]
  ring

/-- Swap the two basis vectors spanning the coordinate line. -/
def lineBasisSwap : Matrix (Fin 3) (Fin 3) K :=
  !![0, 1, 0; 1, 0, 0; 0, 0, 1]

theorem lineBasisSwap_mul_self :
    (lineBasisSwap : Matrix (Fin 3) (Fin 3) K) * lineBasisSwap = 1 := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [lineBasisSwap, Matrix.mul_apply, Fin.sum_univ_three]

set_option maxRecDepth 10000 in
/-- Coefficients of a cubic after swapping its first two coordinates. -/
theorem coefficients_lineBasisSwap [NeZero (2 : K)] [NeZero (3 : K)]
    (G : MvPolynomial (Fin 3) K) (hG : G.IsHomogeneous 3) :
    let T := (aeval (linearSubst 2 (lineBasisSwap : Matrix (Fin 3) (Fin 3) K)) :
      MvPolynomial (Fin 3) K →ₐ[K] _) G
    PlaneCubicResidual.coeffU3 T = PlaneCubicResidual.coeffV3 G ∧
    PlaneCubicResidual.coeffU2V T = PlaneCubicResidual.coeffUV2 G ∧
    PlaneCubicResidual.coeffUV2 T = PlaneCubicResidual.coeffU2V G ∧
    PlaneCubicResidual.coeffV3 T = PlaneCubicResidual.coeffU3 G ∧
    PlaneCubicResidual.coeffU2W T = PlaneCubicResidual.coeffV2W G ∧
    PlaneCubicResidual.coeffUVW T = PlaneCubicResidual.coeffUVW G ∧
    PlaneCubicResidual.coeffV2W T = PlaneCubicResidual.coeffU2W G ∧
    PlaneCubicResidual.coeffUW2 T = PlaneCubicResidual.coeffVW2 G ∧
    PlaneCubicResidual.coeffVW2 T = PlaneCubicResidual.coeffUW2 G ∧
    PlaneCubicResidual.coeffW3 T = PlaneCubicResidual.coeffW3 G := by
  let T := (aeval (linearSubst 2 (lineBasisSwap : Matrix (Fin 3) (Fin 3) K)) :
    MvPolynomial (Fin 3) K →ₐ[K] _) G
  have hT : T.IsHomogeneous 3 := isHomogeneous_aeval_linearSubst _ hG
  have hz : ∀ U V W : K,
      (PlaneCubicResidual.coeffU3 T - PlaneCubicResidual.coeffV3 G) * U ^ 3 +
        (PlaneCubicResidual.coeffU2V T - PlaneCubicResidual.coeffUV2 G) * U ^ 2 * V +
        (PlaneCubicResidual.coeffUV2 T - PlaneCubicResidual.coeffU2V G) * U * V ^ 2 +
        (PlaneCubicResidual.coeffV3 T - PlaneCubicResidual.coeffU3 G) * V ^ 3 +
        (PlaneCubicResidual.coeffU2W T - PlaneCubicResidual.coeffV2W G) * U ^ 2 * W +
        (PlaneCubicResidual.coeffUVW T - PlaneCubicResidual.coeffUVW G) * U * V * W +
        (PlaneCubicResidual.coeffV2W T - PlaneCubicResidual.coeffU2W G) * V ^ 2 * W +
        (PlaneCubicResidual.coeffUW2 T - PlaneCubicResidual.coeffVW2 G) * U * W ^ 2 +
        (PlaneCubicResidual.coeffVW2 T - PlaneCubicResidual.coeffUW2 G) * V * W ^ 2 +
        (PlaneCubicResidual.coeffW3 T - PlaneCubicResidual.coeffW3 G) * W ^ 3 = 0 := by
    intro U V W
    let z : Fin 3 → K := ![U, V, W]
    have hTv := PlaneCubicResidual.eval_eq_planeCubicValue hT z
    let w : Fin 3 → K := Matrix.mulVec
      (lineBasisSwap : Matrix (Fin 3) (Fin 3) K) z
    have hGv := PlaneCubicResidual.eval_eq_planeCubicValue hG w
    have hsub := eval_aeval_linearSubst 2
      (lineBasisSwap : Matrix (Fin 3) (Fin 3) K) G z
    change eval z T = eval w G at hsub
    rw [hTv, hGv] at hsub
    simp [z, w, UniversalResidual.planeCubicValue, lineBasisSwap, Matrix.mulVec,
      dotProduct, Fin.sum_univ_three] at hsub
    linear_combination hsub
  obtain ⟨ha, hb, hc, hd, he, hf, hh, hi, hj, hk⟩ :=
    HesseResidualMapBridge.ternaryCubic_coefficients_eq_zero
      (PlaneCubicResidual.coeffU3 T - PlaneCubicResidual.coeffV3 G)
      (PlaneCubicResidual.coeffU2V T - PlaneCubicResidual.coeffUV2 G)
      (PlaneCubicResidual.coeffUV2 T - PlaneCubicResidual.coeffU2V G)
      (PlaneCubicResidual.coeffV3 T - PlaneCubicResidual.coeffU3 G)
      (PlaneCubicResidual.coeffU2W T - PlaneCubicResidual.coeffV2W G)
      (PlaneCubicResidual.coeffUVW T - PlaneCubicResidual.coeffUVW G)
      (PlaneCubicResidual.coeffV2W T - PlaneCubicResidual.coeffU2W G)
      (PlaneCubicResidual.coeffUW2 T - PlaneCubicResidual.coeffVW2 G)
      (PlaneCubicResidual.coeffVW2 T - PlaneCubicResidual.coeffUW2 G)
      (PlaneCubicResidual.coeffW3 T - PlaneCubicResidual.coeffW3 G) hz
  dsimp only [T] at ha hb hc hd he hf hh hi hj hk ⊢
  exact ⟨sub_eq_zero.mp ha, sub_eq_zero.mp hb, sub_eq_zero.mp hc, sub_eq_zero.mp hd,
    sub_eq_zero.mp he, sub_eq_zero.mp hf, sub_eq_zero.mp hh, sub_eq_zero.mp hi,
    sub_eq_zero.mp hj, sub_eq_zero.mp hk⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 1000000 in
/-- Swapping the two spanning vectors does not change the ambient residual line. -/
theorem residualLinearFormOn_lineBasisSwap [NeZero (2 : K)] [NeZero (3 : K)]
    (G : MvPolynomial (Fin 3) K) (hG : G.IsHomogeneous 3) :
    residualLinearFormOn
        (lineBasisSwap : Matrix (Fin 3) (Fin 3) K) lineBasisSwap G =
      PlaneCubicResidual.residualLinearForm G := by
  obtain ⟨ha, hb, hc, hd, he, hf, hh, hi, hj, hk⟩ :=
    coefficients_lineBasisSwap G hG
  apply MvPolynomial.funext
  intro y
  rw [eval_residualLinearFormOn, PlaneCubicResidual.eval_residualLinearForm,
    ha, hb, hc, hd, he, hf, hh, hi, hj, hk,
    PlaneCubicResidual.eval_residualLinearForm]
  simp [lineBasisSwap, Matrix.mulVec, dotProduct, Fin.sum_univ_three]
  dsimp only [UniversalResidual.residualLinear, UniversalResidual.residualCoeffU,
    UniversalResidual.residualCoeffV, UniversalResidual.residualCoeffW]
  ring

/-! ## Covariance along an arbitrary framed line -/

/-- Reframing the two spanning vectors by the triangular matrix scales the transported residual
line by the sixth power of its determinant. -/
theorem residualLinearFormOn_mul_lineReframe [NeZero (2 : K)] [NeZero (3 : K)]
    (M N : Matrix (Fin 3) (Fin 3) K)
    (G : MvPolynomial (Fin 3) K) (hG : G.IsHomogeneous 3)
    (s t : K) (hs : s ≠ 0) :
    residualLinearFormOn (M * lineReframe s t) (lineReframeInv s t * N) G =
      C (s ^ 6) * residualLinearFormOn M N G := by
  let G₀ := (aeval (linearSubst 2 M) : MvPolynomial (Fin 3) K →ₐ[K] _) G
  have hG₀ : G₀.IsHomogeneous 3 := isHomogeneous_aeval_linearSubst M hG
  change
    (aeval (linearSubst 2 (lineReframeInv s t * N)) :
        MvPolynomial (Fin 3) K →ₐ[K] _)
        (PlaneCubicResidual.residualLinearForm
          ((aeval (linearSubst 2 (M * lineReframe s t)) :
            MvPolynomial (Fin 3) K →ₐ[K] _) G)) = _
  rw [← aeval_linearSubst_comp (lineReframe s t) M G]
  rw [← aeval_linearSubst_comp N (lineReframeInv s t)
    (PlaneCubicResidual.residualLinearForm
      ((aeval (linearSubst 2 (lineReframe s t)) :
        MvPolynomial (Fin 3) K →ₐ[K] _) G₀))]
  change (aeval (linearSubst 2 N) : MvPolynomial (Fin 3) K →ₐ[K] _)
      (residualLinearFormOn (lineReframe s t) (lineReframeInv s t) G₀) = _
  rw [residualLinearFormOn_lineReframe G₀ hG₀ s t hs, map_mul]
  simp [G₀, residualLinearFormOn, MvPolynomial.algebraMap_eq]

/-- Swapping the two spanning vectors of an arbitrary frame leaves its transported residual line
unchanged. -/
theorem residualLinearFormOn_mul_lineBasisSwap [NeZero (2 : K)] [NeZero (3 : K)]
    (M N : Matrix (Fin 3) (Fin 3) K)
    (G : MvPolynomial (Fin 3) K) (hG : G.IsHomogeneous 3) :
    residualLinearFormOn
        (M * (lineBasisSwap : Matrix (Fin 3) (Fin 3) K)) (lineBasisSwap * N) G =
      residualLinearFormOn M N G := by
  let G₀ := (aeval (linearSubst 2 M) : MvPolynomial (Fin 3) K →ₐ[K] _) G
  have hG₀ : G₀.IsHomogeneous 3 := isHomogeneous_aeval_linearSubst M hG
  change
    (aeval (linearSubst 2 (lineBasisSwap * N)) :
        MvPolynomial (Fin 3) K →ₐ[K] _)
        (PlaneCubicResidual.residualLinearForm
          ((aeval (linearSubst 2 (M * lineBasisSwap)) :
            MvPolynomial (Fin 3) K →ₐ[K] _) G)) = _
  rw [← aeval_linearSubst_comp lineBasisSwap M G]
  rw [← aeval_linearSubst_comp N lineBasisSwap
    (PlaneCubicResidual.residualLinearForm
      ((aeval (linearSubst 2 lineBasisSwap) :
        MvPolynomial (Fin 3) K →ₐ[K] _) G₀))]
  change (aeval (linearSubst 2 N) : MvPolynomial (Fin 3) K →ₐ[K] _)
      (residualLinearFormOn lineBasisSwap lineBasisSwap G₀) = _
  rw [residualLinearFormOn_lineBasisSwap G₀ hG₀]
  rfl

/-- Evaluating a residual coefficient form at `x` reads the corresponding coordinate of the
residual line of the cubic fibre. -/
theorem eval_residualLineCoeffOn_eq_eval_residualLinearFormOn_basis
    (M N : Matrix (Fin 3) (Fin 3) K)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) K)
    (x : Fin 3 → K) (a : Fin 3) :
    eval x (residualLineCoeffOn M N F a) =
      eval (Pi.single a 1)
        (residualLinearFormOn M N (specializeFirstCoordinates (n := 2) x F)) := by
  have hsum := eval_residualEquationOn_eq_sum M N F x (Pi.single a 1)
  have hline := eval_residualEquationOn M N F x (Pi.single a 1)
  rw [hline] at hsum
  simpa [Pi.single_apply] using hsum.symm

/-- Coefficient forms inherit the sixth-power triangular covariance. -/
theorem residualLineCoeffOn_mul_lineReframe [NeZero (2 : K)] [NeZero (3 : K)]
    (M N : Matrix (Fin 3) (Fin 3) K)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) K) (hF : IsBidegree23 F)
    (s t : K) (hs : s ≠ 0) (a : Fin 3) :
    residualLineCoeffOn (M * lineReframe s t) (lineReframeInv s t * N) F a =
      C (s ^ 6) * residualLineCoeffOn M N F a := by
  apply MvPolynomial.funext
  intro x
  rw [eval_residualLineCoeffOn_eq_eval_residualLinearFormOn_basis,
    residualLinearFormOn_mul_lineReframe M N _
      (hF.specializeFirstCoordinates_isHomogeneous x) s t hs]
  simp only [map_mul, eval_C]
  rw [eval_residualLineCoeffOn_eq_eval_residualLinearFormOn_basis]

/-- Coefficient forms are unchanged when the two spanning vectors are swapped. -/
theorem residualLineCoeffOn_mul_lineBasisSwap [NeZero (2 : K)] [NeZero (3 : K)]
    (M N : Matrix (Fin 3) (Fin 3) K)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) K) (hF : IsBidegree23 F)
    (a : Fin 3) :
    residualLineCoeffOn
        (M * (lineBasisSwap : Matrix (Fin 3) (Fin 3) K)) (lineBasisSwap * N) F a =
      residualLineCoeffOn M N F a := by
  apply MvPolynomial.funext
  intro x
  rw [eval_residualLineCoeffOn_eq_eval_residualLinearFormOn_basis,
    eval_residualLineCoeffOn_eq_eval_residualLinearFormOn_basis,
    residualLinearFormOn_mul_lineBasisSwap M N _
      (hF.specializeFirstCoordinates_isHomogeneous x)]

/-- G3 is preserved when the first spanning vector is replaced by `s p + t q`, with `s ≠ 0`. -/
theorem residualLineNonconstantOn_mul_lineReframe [NeZero (2 : K)] [NeZero (3 : K)]
    (M N : Matrix (Fin 3) (Fin 3) K)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) K) (hF : IsBidegree23 F)
    (s t : K) (hs : s ≠ 0)
    (hG3 : ResidualLineNonconstantOn M N F) :
    ResidualLineNonconstantOn (M * lineReframe s t) (lineReframeInv s t * N) F := by
  obtain ⟨a, b, m, n, hminor⟩ :=
    (residualLineNonconstantOn_iff_exists_coeff_minor_ne_zero M N F).mp hG3
  apply residualLineNonconstantOn_of_coeff_minor_ne_zero _ _ F a b m n
  rw [residualLineCoeffOn_mul_lineReframe M N F hF s t hs a,
    residualLineCoeffOn_mul_lineReframe M N F hF s t hs b]
  simp only [coeff_C_mul]
  have hscale : (s ^ 6) ^ 2 ≠ 0 := pow_ne_zero 2 (pow_ne_zero 6 hs)
  rw [show
    s ^ 6 * coeff m (residualLineCoeffOn M N F a) *
          (s ^ 6 * coeff n (residualLineCoeffOn M N F b)) -
        s ^ 6 * coeff n (residualLineCoeffOn M N F a) *
          (s ^ 6 * coeff m (residualLineCoeffOn M N F b)) =
      (s ^ 6) ^ 2 *
        (coeff m (residualLineCoeffOn M N F a) *
            coeff n (residualLineCoeffOn M N F b) -
          coeff n (residualLineCoeffOn M N F a) *
            coeff m (residualLineCoeffOn M N F b)) by ring]
  exact mul_ne_zero hscale hminor

/-- G3 is preserved by swapping the two spanning vectors. -/
theorem residualLineNonconstantOn_mul_lineBasisSwap [NeZero (2 : K)] [NeZero (3 : K)]
    (M N : Matrix (Fin 3) (Fin 3) K)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) K) (hF : IsBidegree23 F)
    (hG3 : ResidualLineNonconstantOn M N F) :
    ResidualLineNonconstantOn
      (M * (lineBasisSwap : Matrix (Fin 3) (Fin 3) K)) (lineBasisSwap * N) F := by
  obtain ⟨a, b, m, n, hminor⟩ :=
    (residualLineNonconstantOn_iff_exists_coeff_minor_ne_zero M N F).mp hG3
  apply residualLineNonconstantOn_of_coeff_minor_ne_zero _ _ F a b m n
  simpa only [residualLineCoeffOn_mul_lineBasisSwap M N F hF] using hminor

/-! ## Moving a good line frame to a point of the cubic -/

theorem linearIndependent_pair_of_lineFrame_right_inverse
    (p q r : Fin 3 → K) (N : Matrix (Fin 3) (Fin 3) K)
    (hMN : lineFrame p q r * N = 1) :
    LinearIndependent K ![p, q] := by
  let e₀ : Fin 3 → K := ![1, 0, 0]
  let e₁ : Fin 3 → K := ![0, 1, 0]
  have hNM : N * lineFrame p q r = 1 := mul_eq_one_comm.mp hMN
  have hNp : Matrix.mulVec N p = e₀ := by
    calc
      Matrix.mulVec N p = Matrix.mulVec N (Matrix.mulVec (lineFrame p q r) e₀) := by
        simp [e₀]
      _ = e₀ := by rw [Matrix.mulVec_mulVec, hNM, Matrix.one_mulVec]
  have hNq : Matrix.mulVec N q = e₁ := by
    calc
      Matrix.mulVec N q = Matrix.mulVec N (Matrix.mulVec (lineFrame p q r) e₁) := by
        simp [e₁]
      _ = e₁ := by rw [Matrix.mulVec_mulVec, hNM, Matrix.one_mulVec]
  rw [LinearIndependent.pair_iff]
  intro a b hab
  have hab' := congrArg (Matrix.mulVec N) hab
  simp only [Matrix.mulVec_add, Matrix.mulVec_smul, Matrix.mulVec_zero, hNp, hNq] at hab'
  have ha := congrFun hab' (0 : Fin 3)
  have hb := congrFun hab' (1 : Fin 3)
  constructor
  · simpa [e₀, e₁, Pi.smul_apply] using ha
  · simpa [e₀, e₁, Pi.smul_apply] using hb

theorem lineFrame_mul_lineReframe
    (p q r : Fin 3 → K) (s t : K) :
    lineFrame p q r * lineReframe s t =
      lineFrame (fun i ↦ s * p i + t * q i) q r := by
  ext i j
  fin_cases j <;>
    simp [lineFrame, lineReframe, Matrix.mul_apply, Fin.sum_univ_three] <;> ring

theorem lineFrame_mul_lineBasisSwap
    (p q r : Fin 3 → K) :
    lineFrame p q r * (lineBasisSwap : Matrix (Fin 3) (Fin 3) K) =
      lineFrame q p r := by
  ext i j
  fin_cases j <;>
    simp [lineFrame, lineBasisSwap, Matrix.mul_apply, Fin.sum_univ_three]

/-- Every smooth cubic incidence contains a framed G3 point.  Start with any good line, intersect
it with the cubic, and use a swap followed by a triangular reframe to put that intersection point
in the first column. -/
theorem exists_G3_frame_point_on_isSmoothPlaneCubic
    [IsAlgClosed K] [NeZero (2 : K)] [NeZero (3 : K)]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) K)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [AlgebraicGeometry.Smooth
      (BiprojectiveSpace.biprojectiveZeroLocusToSpec 2 2 K F)]
    (g : MvPolynomial (Fin 3) K) (hsmooth : IsSmoothPlaneCubic g) :
    ∃ (p q r : Fin 3 → K) (N : Matrix (Fin 3) (Fin 3) K),
      lineFrame p q r * N = 1 ∧
      ResidualLineNonconstantOn (lineFrame p q r) N F ∧
      eval p g = 0 := by
  obtain ⟨p₀, q₀, r₀, N₀, hMN₀, hG3₀⟩ := exists_good_line F hF hF0
  have hpq₀ : LinearIndependent K ![p₀, q₀] :=
    linearIndependent_pair_of_lineFrame_right_inverse p₀ q₀ r₀ N₀ hMN₀
  let B := binaryLineRestriction p₀ q₀ g
  have hBhom : B.IsHomogeneous 3 := binaryLineRestriction_isHomogeneous hsmooth.1 p₀ q₀
  obtain ⟨v, hv0, hvB⟩ :=
    exists_nonzero_zero_binary_homogeneous B (by norm_num) hBhom
  let p := binarySpanLinearMap (K := K) p₀ q₀ v
  have hpg : eval p g = 0 := by
    rw [eval_binarySpanLinearMap_eq_eval_binaryLineRestriction]
    exact hvB
  by_cases hs : v 0 = 0
  · have ht : v 1 ≠ 0 := by
      intro ht
      apply hv0
      funext i
      fin_cases i <;> assumption
    let M₁ := lineFrame p₀ q₀ r₀ *
      (lineBasisSwap : Matrix (Fin 3) (Fin 3) K)
    let N₁ := lineBasisSwap * N₀
    have hMN₁ : M₁ * N₁ = 1 := by
      dsimp only [M₁, N₁]
      calc
        (lineFrame p₀ q₀ r₀ * lineBasisSwap) * (lineBasisSwap * N₀) =
            lineFrame p₀ q₀ r₀ * ((lineBasisSwap * lineBasisSwap) * N₀) := by
              simp only [Matrix.mul_assoc]
        _ = 1 := by rw [lineBasisSwap_mul_self, Matrix.one_mul, hMN₀]
    have hG3₁ : ResidualLineNonconstantOn M₁ N₁ F :=
      residualLineNonconstantOn_mul_lineBasisSwap
        (lineFrame p₀ q₀ r₀) N₀ F hF hG3₀
    let M₂ := M₁ * lineReframe (v 1) 0
    let N₂ := lineReframeInv (v 1) 0 * N₁
    have hMN₂ : M₂ * N₂ = 1 := by
      dsimp only [M₂, N₂]
      calc
        (M₁ * lineReframe (v 1) 0) * (lineReframeInv (v 1) 0 * N₁) =
            M₁ * ((lineReframe (v 1) 0 * lineReframeInv (v 1) 0) * N₁) := by
              simp only [Matrix.mul_assoc]
        _ = 1 := by rw [lineReframe_mul_inv _ _ ht, Matrix.one_mul, hMN₁]
    have hG3₂ : ResidualLineNonconstantOn M₂ N₂ F :=
      residualLineNonconstantOn_mul_lineReframe M₁ N₁ F hF (v 1) 0 ht hG3₁
    have hp : p = fun i ↦ v 1 * q₀ i := by
      funext i
      simp [p, binarySpanLinearMap_apply, hs, Pi.smul_apply, smul_eq_mul]
    have hM₂ : M₂ = lineFrame p p₀ r₀ := by
      dsimp only [M₂, M₁]
      rw [lineFrame_mul_lineBasisSwap,
        lineFrame_mul_lineReframe, hp]
      congr 2
      funext i
      ring
    refine ⟨p, p₀, r₀, N₂, ?_, ?_, hpg⟩
    · rw [← hM₂]
      exact hMN₂
    · rw [← hM₂]
      exact hG3₂
  · let M₁ := lineFrame p₀ q₀ r₀ * lineReframe (v 0) (v 1)
    let N₁ := lineReframeInv (v 0) (v 1) * N₀
    have hMN₁ : M₁ * N₁ = 1 := by
      dsimp only [M₁, N₁]
      calc
        (lineFrame p₀ q₀ r₀ * lineReframe (v 0) (v 1)) *
            (lineReframeInv (v 0) (v 1) * N₀) =
          lineFrame p₀ q₀ r₀ *
            ((lineReframe (v 0) (v 1) * lineReframeInv (v 0) (v 1)) * N₀) := by
              simp only [Matrix.mul_assoc]
        _ = 1 := by rw [lineReframe_mul_inv _ _ hs, Matrix.one_mul, hMN₀]
    have hG3₁ : ResidualLineNonconstantOn M₁ N₁ F :=
      residualLineNonconstantOn_mul_lineReframe
        (lineFrame p₀ q₀ r₀) N₀ F hF (v 0) (v 1) hs hG3₀
    have hp : p = fun i ↦ v 0 * p₀ i + v 1 * q₀ i := by
      funext i
      simp [p, binarySpanLinearMap_apply, Pi.smul_apply, smul_eq_mul]
    have hM₁ : M₁ = lineFrame p q₀ r₀ := by
      dsimp only [M₁]
      rw [lineFrame_mul_lineReframe, hp]
    refine ⟨p, q₀, r₀, N₁, ?_, ?_, hpg⟩
    · rw [← hM₁]
      exact hMN₁
    · rw [← hM₁]
      exact hG3₁

/-- The adjugate-cleared G3 principal open is nonempty on the frame incidence over every smooth
cubic. -/
theorem exists_genericG3MinorTarget_ne_zero_on_isSmoothPlaneCubic
    [IsAlgClosed K] [NeZero (2 : K)] [NeZero (3 : K)]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) K)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [AlgebraicGeometry.Smooth
      (BiprojectiveSpace.biprojectiveZeroLocusToSpec 2 2 K F)]
    (g : MvPolynomial (Fin 3) K) (hsmooth : IsSmoothPlaneCubic g) :
    ∃ (a b : Fin 3) (m n : Fin 3 →₀ ℕ) (z : FrameIncidenceCoordinate → K),
      eval z (frameIncidenceEquation g) = 0 ∧
      eval z (genericG3MinorTarget F a b m n) ≠ 0 := by
  obtain ⟨p, q, r, N, hMN, hG3, hpg⟩ :=
    exists_G3_frame_point_on_isSmoothPlaneCubic F hF hF0 g hsmooth
  exact exists_genericG3MinorTarget_ne_zero_at_G3_incidencePoint
    F g p q r N hMN hG3 hpg

/-! ## The unconditional incidence principle -/

/-- A smooth bidegree-`(2,3)` hypersurface satisfies the frame-incidence principle used by the
nonsingular G3--G4 line-selection endpoint. -/
theorem g3FrameMeetsEveryNonemptyPrincipalOpenOnSmoothCubic_of_smooth
    [IsAlgClosed K] [NeZero (2 : K)] [NeZero (3 : K)]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) K)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [AlgebraicGeometry.Smooth
      (BiprojectiveSpace.biprojectiveZeroLocusToSpec 2 2 K F)] :
    G3FrameMeetsEveryNonemptyPrincipalOpenOnSmoothCubic F := by
  intro g H d hsmooth _hH _hd hHopen
  obtain ⟨a, b, m, n, zG3, hzG3g, hzG3⟩ :=
    exists_genericG3MinorTarget_ne_zero_on_isSmoothPlaneCubic
      F hF hF0 g hsmooth
  have hprime := isPrime_span_frameIncidenceEquation_of_isSmoothPlaneCubic g hsmooth
  have hdetOpen : ∃ z : FrameIncidenceCoordinate → K,
      eval z (frameIncidenceEquation g) = 0 ∧
      eval z (genericLineFrameDet (K := K)) ≠ 0 :=
    exists_frameIncidencePoint_det_ne_zero g
      ⟨hHopen.choose, hHopen.choose_spec.1, hHopen.choose_spec.2.1⟩
  have hfirstOpen : ∃ z : FrameIncidenceCoordinate → K,
      eval z (frameIncidenceEquation g) = 0 ∧
      eval z (frameFirstColumnTarget H) ≠ 0 :=
    exists_frameIncidencePoint_firstColumnTarget_ne_zero g H
      ⟨hHopen.choose, hHopen.choose_spec.2.1, hHopen.choose_spec.2.2⟩
  obtain ⟨z, hzg, hzdet, hzminor, hzH, _hzdet'⟩ :=
    exists_affine_point_off_four_targets_of_prime_hypersurface
      (frameIncidenceEquation g)
      (genericLineFrameDet (K := K))
      (genericG3MinorTarget F a b m n)
      (frameFirstColumnTarget H)
      (genericLineFrameDet (K := K))
      hprime hdetOpen ⟨zG3, hzG3g, hzG3⟩ hfirstOpen hdetOpen
  let p := framePointOfCoordinate z
  let q := frameDirectionOfCoordinate z
  let r := frameCompletionOfCoordinate z
  obtain ⟨N, hMN, hG3⟩ :=
    exists_inverse_residualLineNonconstantOn_of_genericG3MinorTarget_ne_zero
      F a b m n z hzdet hzminor
  have hzcoord : frameCoordinatePoint p q r = z := frameCoordinatePoint_ofCoordinate z
  have hpg : eval p g = 0 := by
    rw [← eval_frameIncidenceEquation g p q r, hzcoord]
    exact hzg
  have hpH : eval p H ≠ 0 := by
    rw [← eval_frameFirstColumnTarget H p q r, hzcoord]
    exact hzH
  have hp0 : p ≠ 0 := by
    intro hp
    have hdetM : (lineFrame p q r).det ≠ 0 := Matrix.det_ne_zero_of_right_inverse hMN
    apply hdetM
    apply Matrix.det_eq_zero_of_column_eq_zero 0
    intro i
    simp [lineFrame, hp]
  exact ⟨p, q, r, N, hMN, hG3, hp0, hpg, hpH⟩

/-- Unconditional certificate-rich G3--G4 line-section endpoint for every smooth bidegree-`(2,3)`
hypersurface. -/
theorem exists_actualG3G4LineSection_via_frameIncidence
    [IsAlgClosed K] [NeZero (2 : K)] [NeZero (3 : K)]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) K)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [AlgebraicGeometry.Smooth
      (BiprojectiveSpace.biprojectiveZeroLocusToSpec 2 2 K F)] :
    ∃ (p q r : Fin 3 → K) (N : Matrix (Fin 3) (Fin 3) K)
        (x : Fin 3 → K) (v : Fin 3 → Polynomial K) (u : Fin 3 → K),
      HasActualG3G4LineSection F p q r N v ∧
      TsenSectionRealizesCenterAt v 0 u ∧
      pointwiseG4StereoCertificateAt p q F v 0 x ≠ 0 ∧
      pointwiseG4StereoCertificatePoly p q F v x ≠ 0 :=
  exists_actualG3G4LineSection_of_incidenceOpen F hF hF0
    (g3FrameMeetsEveryNonemptyPrincipalOpenOnSmoothCubic_of_smooth F hF hF0)

end

end BConicBundleMultisections.Standard
