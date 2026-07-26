/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.Standard.ResidualLineMapDefinitions
public import BConicBundleMultisections.HesseProjectiveResidualRigidity
public import BConicBundleMultisections.HesseNormalForm
public import BConicBundleMultisections.PlaneCubicResidualLineMap

/-!
# From a common residual-line map to Hesse coefficient rigidity

This module supplies the exact bridge between the geometric projective equality in
`Standard.HasCommonResidualLineMap` and the finite coefficient certificate in
`HesseProjectiveResidualRigidity`.

The affine dual frames parametrize `W = sU + tV`.  Polynomial interpolation identifies the ten
coefficients after that coordinate change, so evaluating `residualLinearFormOn` at the three basis
vectors gives the universal ambient residual quartics.  For a Hesse cubic those values are the
three normalized Hesse quartics times `27 * (lambda^3 - 1)`.  Cross multiplication, together with
base-point-freeness at the affine origin, invokes projective rigidity and reconstructs the cubic.
-/

@[expose] public section

open MvPolynomial
open scoped Matrix

namespace BConicBundleMultisections.HesseResidualMapBridge

universe u v
variable {k : Type u} [Field k] [CharZero k]

def affineDualFrame (s t : k) : Matrix (Fin 3) (Fin 3) k :=
  !![1, 0, 0; 0, 1, 0; s, t, 1]

def affineDualFrameInv (s t : k) : Matrix (Fin 3) (Fin 3) k :=
  !![1, 0, 0; 0, 1, 0; -s, -t, 1]

omit [CharZero k] in
theorem affineDualFrame_mul_inv (s t : k) :
    affineDualFrame s t * affineDualFrameInv s t = 1 := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [affineDualFrame, affineDualFrameInv, Matrix.mul_apply, Fin.sum_univ_three]

theorem ternaryCubic_coefficients_eq_zero
    (a b c d e f h i j kk : k)
    (hz : ∀ U V W : k,
      a*U^3 + b*U^2*V + c*U*V^2 + d*V^3 +
        e*U^2*W + f*U*V*W + h*V^2*W + i*U*W^2 + j*V*W^2 + kk*W^3 = 0) :
    a = 0 ∧ b = 0 ∧ c = 0 ∧ d = 0 ∧ e = 0 ∧ f = 0 ∧ h = 0 ∧ i = 0 ∧ j = 0 ∧ kk = 0 := by
  have ha : a = 0 := by
    linear_combination (-1/6) * hz 0 0 1 + (1/2) * hz 1 0 1 +
      (-1/2) * hz 2 0 1 + (1/6) * hz 3 0 1
  have hb : b = 0 := by
    linear_combination (-1/2) * hz 0 0 1 + (1/2) * hz 0 1 1 +
      hz 1 0 1 - hz 1 1 1 + (-1/2) * hz 2 0 1 + (1/2) * hz 2 1 1
  have hc : c = 0 := by
    linear_combination (-1/2) * hz 0 0 1 + hz 0 1 1 + (-1/2) * hz 0 2 1 +
      (1/2) * hz 1 0 1 - hz 1 1 1 + (1/2) * hz 1 2 1
  have hd : d = 0 := by
    linear_combination (-1/6) * hz 0 0 1 + (1/2) * hz 0 1 1 +
      (-1/2) * hz 0 2 1 + (1/6) * hz 0 3 1
  have he : e = 0 := by
    linear_combination hz 0 0 1 + (-5/2) * hz 1 0 1 + 2 * hz 2 0 1 +
      (-1/2) * hz 3 0 1
  have hf : f = 0 := by
    linear_combination 2 * hz 0 0 1 + (-5/2) * hz 0 1 1 + (1/2) * hz 0 2 1 +
      (-5/2) * hz 1 0 1 + 3 * hz 1 1 1 + (-1/2) * hz 1 2 1 +
      (1/2) * hz 2 0 1 + (-1/2) * hz 2 1 1
  have hh : h = 0 := by
    linear_combination hz 0 0 1 + (-5/2) * hz 0 1 1 + 2 * hz 0 2 1 +
      (-1/2) * hz 0 3 1
  have hi : i = 0 := by
    linear_combination (-11/6) * hz 0 0 1 + 3 * hz 1 0 1 +
      (-3/2) * hz 2 0 1 + (1/3) * hz 3 0 1
  have hj : j = 0 := by
    linear_combination (-11/6) * hz 0 0 1 + 3 * hz 0 1 1 +
      (-3/2) * hz 0 2 1 + (1/3) * hz 0 3 1
  have hk : kk = 0 := by
    linear_combination hz 0 0 1
  exact ⟨ha, hb, hc, hd, he, hf, hh, hi, hj, hk⟩

set_option maxRecDepth 10000 in
theorem coefficients_affineDualFrame (G : MvPolynomial (Fin 3) k)
    (hG : G.IsHomogeneous 3) (s t : k) :
    let T := (aeval (linearSubst 2 (affineDualFrame s t)) :
      MvPolynomial (Fin 3) k →ₐ[k] _) G
    PlaneCubicResidual.coeffU3 T =
        HesseFullResidualRigidity.transportedA
          (PlaneCubicResidual.coeffU3 G) (PlaneCubicResidual.coeffU2W G)
          (PlaneCubicResidual.coeffUW2 G) (PlaneCubicResidual.coeffW3 G) s ∧
    PlaneCubicResidual.coeffU2V T =
        HesseFullResidualRigidity.transportedB
          (PlaneCubicResidual.coeffU2V G) (PlaneCubicResidual.coeffU2W G)
          (PlaneCubicResidual.coeffUVW G) (PlaneCubicResidual.coeffUW2 G)
          (PlaneCubicResidual.coeffVW2 G) (PlaneCubicResidual.coeffW3 G) s t ∧
    PlaneCubicResidual.coeffUV2 T =
        HesseFullResidualRigidity.transportedC
          (PlaneCubicResidual.coeffUV2 G) (PlaneCubicResidual.coeffUVW G)
          (PlaneCubicResidual.coeffV2W G) (PlaneCubicResidual.coeffUW2 G)
          (PlaneCubicResidual.coeffVW2 G) (PlaneCubicResidual.coeffW3 G) s t ∧
    PlaneCubicResidual.coeffV3 T =
        HesseFullResidualRigidity.transportedD
          (PlaneCubicResidual.coeffV3 G) (PlaneCubicResidual.coeffV2W G)
          (PlaneCubicResidual.coeffVW2 G) (PlaneCubicResidual.coeffW3 G) t ∧
    PlaneCubicResidual.coeffU2W T =
        HesseFullResidualRigidity.transportedE
          (PlaneCubicResidual.coeffU2W G) (PlaneCubicResidual.coeffUW2 G)
          (PlaneCubicResidual.coeffW3 G) s ∧
    PlaneCubicResidual.coeffUVW T =
        HesseFullResidualRigidity.transportedF
          (PlaneCubicResidual.coeffUVW G) (PlaneCubicResidual.coeffUW2 G)
          (PlaneCubicResidual.coeffVW2 G) (PlaneCubicResidual.coeffW3 G) s t ∧
    PlaneCubicResidual.coeffV2W T =
        HesseFullResidualRigidity.transportedH
          (PlaneCubicResidual.coeffV2W G) (PlaneCubicResidual.coeffVW2 G)
          (PlaneCubicResidual.coeffW3 G) t ∧
    PlaneCubicResidual.coeffUW2 T =
        HesseFullResidualRigidity.transportedI
          (PlaneCubicResidual.coeffUW2 G) (PlaneCubicResidual.coeffW3 G) s ∧
    PlaneCubicResidual.coeffVW2 T =
        HesseFullResidualRigidity.transportedJ
          (PlaneCubicResidual.coeffVW2 G) (PlaneCubicResidual.coeffW3 G) t ∧
    PlaneCubicResidual.coeffW3 T = PlaneCubicResidual.coeffW3 G := by
  let T := (aeval (linearSubst 2 (affineDualFrame s t)) :
      MvPolynomial (Fin 3) k →ₐ[k] _) G
  have hT : T.IsHomogeneous 3 := isHomogeneous_aeval_linearSubst _ hG
  let A := HesseFullResidualRigidity.transportedA
    (PlaneCubicResidual.coeffU3 G) (PlaneCubicResidual.coeffU2W G)
    (PlaneCubicResidual.coeffUW2 G) (PlaneCubicResidual.coeffW3 G) s
  let B := HesseFullResidualRigidity.transportedB
    (PlaneCubicResidual.coeffU2V G) (PlaneCubicResidual.coeffU2W G)
    (PlaneCubicResidual.coeffUVW G) (PlaneCubicResidual.coeffUW2 G)
    (PlaneCubicResidual.coeffVW2 G) (PlaneCubicResidual.coeffW3 G) s t
  let Cc := HesseFullResidualRigidity.transportedC
    (PlaneCubicResidual.coeffUV2 G) (PlaneCubicResidual.coeffUVW G)
    (PlaneCubicResidual.coeffV2W G) (PlaneCubicResidual.coeffUW2 G)
    (PlaneCubicResidual.coeffVW2 G) (PlaneCubicResidual.coeffW3 G) s t
  let D := HesseFullResidualRigidity.transportedD
    (PlaneCubicResidual.coeffV3 G) (PlaneCubicResidual.coeffV2W G)
    (PlaneCubicResidual.coeffVW2 G) (PlaneCubicResidual.coeffW3 G) t
  let E := HesseFullResidualRigidity.transportedE
    (PlaneCubicResidual.coeffU2W G) (PlaneCubicResidual.coeffUW2 G)
    (PlaneCubicResidual.coeffW3 G) s
  let F := HesseFullResidualRigidity.transportedF
    (PlaneCubicResidual.coeffUVW G) (PlaneCubicResidual.coeffUW2 G)
    (PlaneCubicResidual.coeffVW2 G) (PlaneCubicResidual.coeffW3 G) s t
  let H := HesseFullResidualRigidity.transportedH
    (PlaneCubicResidual.coeffV2W G) (PlaneCubicResidual.coeffVW2 G)
    (PlaneCubicResidual.coeffW3 G) t
  let I := HesseFullResidualRigidity.transportedI
    (PlaneCubicResidual.coeffUW2 G) (PlaneCubicResidual.coeffW3 G) s
  let J := HesseFullResidualRigidity.transportedJ
    (PlaneCubicResidual.coeffVW2 G) (PlaneCubicResidual.coeffW3 G) t
  let K := PlaneCubicResidual.coeffW3 G
  have hz : ∀ U V W : k,
      (PlaneCubicResidual.coeffU3 T - A)*U^3 +
        (PlaneCubicResidual.coeffU2V T - B)*U^2*V +
        (PlaneCubicResidual.coeffUV2 T - Cc)*U*V^2 +
        (PlaneCubicResidual.coeffV3 T - D)*V^3 +
        (PlaneCubicResidual.coeffU2W T - E)*U^2*W +
        (PlaneCubicResidual.coeffUVW T - F)*U*V*W +
        (PlaneCubicResidual.coeffV2W T - H)*V^2*W +
        (PlaneCubicResidual.coeffUW2 T - I)*U*W^2 +
        (PlaneCubicResidual.coeffVW2 T - J)*V*W^2 +
        (PlaneCubicResidual.coeffW3 T - K)*W^3 = 0 := by
    intro U V W
    let r : Fin 3 → k := ![U, V, W]
    have hTv := PlaneCubicResidual.eval_eq_planeCubicValue hT r
    have hGv := PlaneCubicResidual.eval_eq_planeCubicValue hG
      (affineDualFrame s t *ᵥ r)
    have hsub := eval_aeval_linearSubst 2 (affineDualFrame s t) G r
    change eval r T = eval (affineDualFrame s t *ᵥ r) G at hsub
    rw [hTv, hGv] at hsub
    simp [r, UniversalResidual.planeCubicValue, affineDualFrame, Matrix.mulVec,
      dotProduct, Fin.sum_univ_three] at hsub
    dsimp only [A, B, Cc, D, E, F, H, I, J, K,
      HesseFullResidualRigidity.transportedA,
      HesseFullResidualRigidity.transportedB,
      HesseFullResidualRigidity.transportedC,
      HesseFullResidualRigidity.transportedD,
      HesseFullResidualRigidity.transportedE,
      HesseFullResidualRigidity.transportedF,
      HesseFullResidualRigidity.transportedH,
      HesseFullResidualRigidity.transportedI,
      HesseFullResidualRigidity.transportedJ]
    linear_combination hsub
  obtain ⟨ha, hb, hc, hd, he, hf, hh, hi, hj, hk⟩ :=
    ternaryCubic_coefficients_eq_zero
      (PlaneCubicResidual.coeffU3 T - A)
      (PlaneCubicResidual.coeffU2V T - B)
      (PlaneCubicResidual.coeffUV2 T - Cc)
      (PlaneCubicResidual.coeffV3 T - D)
      (PlaneCubicResidual.coeffU2W T - E)
      (PlaneCubicResidual.coeffUVW T - F)
      (PlaneCubicResidual.coeffV2W T - H)
      (PlaneCubicResidual.coeffUW2 T - I)
      (PlaneCubicResidual.coeffVW2 T - J)
      (PlaneCubicResidual.coeffW3 T - K) hz
  dsimp only [T, A, B, Cc, D, E, F, H, I, J, K]
  exact ⟨sub_eq_zero.mp ha, sub_eq_zero.mp hb, sub_eq_zero.mp hc,
    sub_eq_zero.mp hd, sub_eq_zero.mp he, sub_eq_zero.mp hf,
    sub_eq_zero.mp hh, sub_eq_zero.mp hi, sub_eq_zero.mp hj,
    sub_eq_zero.mp hk⟩

theorem eval_residualLinearFormOn_affineDualFrame_zero
    (G : MvPolynomial (Fin 3) k) (hG : G.IsHomogeneous 3) (s t : k) :
    eval ![1, 0, 0]
        (residualLinearFormOn (affineDualFrame s t) (affineDualFrameInv s t) G) =
      HesseFullResidualRigidity.ambientCoeffU
        (PlaneCubicResidual.coeffU3 G) (PlaneCubicResidual.coeffU2V G)
        (PlaneCubicResidual.coeffUV2 G) (PlaneCubicResidual.coeffV3 G)
        (PlaneCubicResidual.coeffU2W G) (PlaneCubicResidual.coeffUVW G)
        (PlaneCubicResidual.coeffV2W G) (PlaneCubicResidual.coeffUW2 G)
        (PlaneCubicResidual.coeffVW2 G) (PlaneCubicResidual.coeffW3 G) s t := by
  obtain ⟨ha, hb, hc, hd, he, hf, hh, hi, hj, hk⟩ :=
    coefficients_affineDualFrame G hG s t
  rw [eval_residualLinearFormOn, PlaneCubicResidual.eval_residualLinearForm]
  rw [ha, hb, hc, hd, he, hf, hh, hi, hj, hk]
  simp [affineDualFrameInv, Matrix.mulVec, dotProduct, Fin.sum_univ_three,
    UniversalResidual.residualLinear, HesseFullResidualRigidity.ambientCoeffU]
  ring

theorem eval_residualLinearFormOn_affineDualFrame_one
    (G : MvPolynomial (Fin 3) k) (hG : G.IsHomogeneous 3) (s t : k) :
    eval ![0, 1, 0]
        (residualLinearFormOn (affineDualFrame s t) (affineDualFrameInv s t) G) =
      HesseFullResidualRigidity.ambientCoeffV
        (PlaneCubicResidual.coeffU3 G) (PlaneCubicResidual.coeffU2V G)
        (PlaneCubicResidual.coeffUV2 G) (PlaneCubicResidual.coeffV3 G)
        (PlaneCubicResidual.coeffU2W G) (PlaneCubicResidual.coeffUVW G)
        (PlaneCubicResidual.coeffV2W G) (PlaneCubicResidual.coeffUW2 G)
        (PlaneCubicResidual.coeffVW2 G) (PlaneCubicResidual.coeffW3 G) s t := by
  obtain ⟨ha, hb, hc, hd, he, hf, hh, hi, hj, hk⟩ :=
    coefficients_affineDualFrame G hG s t
  rw [eval_residualLinearFormOn, PlaneCubicResidual.eval_residualLinearForm]
  rw [ha, hb, hc, hd, he, hf, hh, hi, hj, hk]
  simp [affineDualFrameInv, Matrix.mulVec, dotProduct, Fin.sum_univ_three,
    UniversalResidual.residualLinear, HesseFullResidualRigidity.ambientCoeffV]
  ring

theorem eval_residualLinearFormOn_affineDualFrame_two
    (G : MvPolynomial (Fin 3) k) (hG : G.IsHomogeneous 3) (s t : k) :
    eval ![0, 0, 1]
        (residualLinearFormOn (affineDualFrame s t) (affineDualFrameInv s t) G) =
      HesseFullResidualRigidity.ambientCoeffW
        (PlaneCubicResidual.coeffU3 G) (PlaneCubicResidual.coeffU2V G)
        (PlaneCubicResidual.coeffUV2 G) (PlaneCubicResidual.coeffV3 G)
        (PlaneCubicResidual.coeffU2W G) (PlaneCubicResidual.coeffUVW G)
        (PlaneCubicResidual.coeffV2W G) (PlaneCubicResidual.coeffUW2 G)
        (PlaneCubicResidual.coeffVW2 G) (PlaneCubicResidual.coeffW3 G) s t := by
  obtain ⟨ha, hb, hc, hd, he, hf, hh, hi, hj, hk⟩ :=
    coefficients_affineDualFrame G hG s t
  rw [eval_residualLinearFormOn, PlaneCubicResidual.eval_residualLinearForm]
  rw [ha, hb, hc, hd, he, hf, hh, hi, hj, hk]
  simp [affineDualFrameInv, Matrix.mulVec, dotProduct, Fin.sum_univ_three,
    UniversalResidual.residualLinear, HesseFullResidualRigidity.ambientCoeffW]

theorem hesseCubic_coefficients (lam : k) :
    PlaneCubicResidual.coeffU3 (HesseNormalForm.hesseCubic lam) = 1 ∧
    PlaneCubicResidual.coeffU2V (HesseNormalForm.hesseCubic lam) = 0 ∧
    PlaneCubicResidual.coeffUV2 (HesseNormalForm.hesseCubic lam) = 0 ∧
    PlaneCubicResidual.coeffV3 (HesseNormalForm.hesseCubic lam) = 1 ∧
    PlaneCubicResidual.coeffU2W (HesseNormalForm.hesseCubic lam) = 0 ∧
    PlaneCubicResidual.coeffUVW (HesseNormalForm.hesseCubic lam) = -3 * lam ∧
    PlaneCubicResidual.coeffV2W (HesseNormalForm.hesseCubic lam) = 0 ∧
    PlaneCubicResidual.coeffUW2 (HesseNormalForm.hesseCubic lam) = 0 ∧
    PlaneCubicResidual.coeffVW2 (HesseNormalForm.hesseCubic lam) = 0 ∧
    PlaneCubicResidual.coeffW3 (HesseNormalForm.hesseCubic lam) = 1 := by
  have hz : ∀ U V W : k,
      (PlaneCubicResidual.coeffU3 (HesseNormalForm.hesseCubic lam) - 1) * U^3 +
        PlaneCubicResidual.coeffU2V (HesseNormalForm.hesseCubic lam) * U^2*V +
        PlaneCubicResidual.coeffUV2 (HesseNormalForm.hesseCubic lam) * U*V^2 +
        (PlaneCubicResidual.coeffV3 (HesseNormalForm.hesseCubic lam) - 1) * V^3 +
        PlaneCubicResidual.coeffU2W (HesseNormalForm.hesseCubic lam) * U^2*W +
        (PlaneCubicResidual.coeffUVW (HesseNormalForm.hesseCubic lam) + 3*lam) * U*V*W +
        PlaneCubicResidual.coeffV2W (HesseNormalForm.hesseCubic lam) * V^2*W +
        PlaneCubicResidual.coeffUW2 (HesseNormalForm.hesseCubic lam) * U*W^2 +
        PlaneCubicResidual.coeffVW2 (HesseNormalForm.hesseCubic lam) * V*W^2 +
        (PlaneCubicResidual.coeffW3 (HesseNormalForm.hesseCubic lam) - 1) * W^3 = 0 := by
    intro U V W
    let r : Fin 3 → k := ![U, V, W]
    have hv := PlaneCubicResidual.eval_eq_planeCubicValue
      (HesseNormalForm.hesseCubic_isHomogeneous lam) r
    rw [HesseNormalForm.eval_hesseCubic] at hv
    simp [r, UniversalResidual.planeCubicValue] at hv
    linear_combination -hv
  obtain ⟨ha, hb, hc, hd, he, hf, hh, hi, hj, hk⟩ :=
    ternaryCubic_coefficients_eq_zero
      (PlaneCubicResidual.coeffU3 (HesseNormalForm.hesseCubic lam) - 1)
      (PlaneCubicResidual.coeffU2V (HesseNormalForm.hesseCubic lam))
      (PlaneCubicResidual.coeffUV2 (HesseNormalForm.hesseCubic lam))
      (PlaneCubicResidual.coeffV3 (HesseNormalForm.hesseCubic lam) - 1)
      (PlaneCubicResidual.coeffU2W (HesseNormalForm.hesseCubic lam))
      (PlaneCubicResidual.coeffUVW (HesseNormalForm.hesseCubic lam) + 3*lam)
      (PlaneCubicResidual.coeffV2W (HesseNormalForm.hesseCubic lam))
      (PlaneCubicResidual.coeffUW2 (HesseNormalForm.hesseCubic lam))
      (PlaneCubicResidual.coeffVW2 (HesseNormalForm.hesseCubic lam))
      (PlaneCubicResidual.coeffW3 (HesseNormalForm.hesseCubic lam) - 1) hz
  refine ⟨sub_eq_zero.mp ha, hb, hc, sub_eq_zero.mp hd, he, ?_, hh, hi, hj,
    sub_eq_zero.mp hk⟩
  simpa [mul_assoc] using eq_neg_of_add_eq_zero_left hf

theorem eval_residualLinearFormOn_affineDualFrame_hesse_zero (lam s t : k) :
    eval ![1, 0, 0]
        (residualLinearFormOn (affineDualFrame s t) (affineDualFrameInv s t)
          (HesseNormalForm.hesseCubic lam)) =
      27 * (lam ^ 3 - 1) * HesseFullResidualRigidity.hesseQuarticU lam s t := by
  rw [eval_residualLinearFormOn_affineDualFrame_zero _
    (HesseNormalForm.hesseCubic_isHomogeneous lam)]
  obtain ⟨ha, hb, hc, hd, he, hf, hh, hi, hj, hk⟩ := hesseCubic_coefficients lam
  rw [ha, hb, hc, hd, he, hf, hh, hi, hj, hk]
  dsimp only [HesseFullResidualRigidity.ambientCoeffU,
    HesseFullResidualRigidity.transportedA, HesseFullResidualRigidity.transportedB,
    HesseFullResidualRigidity.transportedC, HesseFullResidualRigidity.transportedD,
    HesseFullResidualRigidity.transportedE, HesseFullResidualRigidity.transportedF,
    HesseFullResidualRigidity.transportedH, HesseFullResidualRigidity.transportedI,
    HesseFullResidualRigidity.hesseQuarticU]
  convert (HesseResidualCertificate.residualCoeffU_sub_smul_residualCoeffW lam s t) using 1 <;>
    simp only [HesseResidualCertificate.ambientCoeffU,
      HesseResidualCertificate.A, HesseResidualCertificate.B,
      HesseResidualCertificate.C, HesseResidualCertificate.D,
      HesseResidualCertificate.E, HesseResidualCertificate.F,
      HesseResidualCertificate.H, HesseResidualCertificate.I,
      HesseResidualCertificate.K] <;> ring

theorem eval_residualLinearFormOn_affineDualFrame_hesse_one (lam s t : k) :
    eval ![0, 1, 0]
        (residualLinearFormOn (affineDualFrame s t) (affineDualFrameInv s t)
          (HesseNormalForm.hesseCubic lam)) =
      27 * (lam ^ 3 - 1) * HesseFullResidualRigidity.hesseQuarticV lam s t := by
  rw [eval_residualLinearFormOn_affineDualFrame_one _
    (HesseNormalForm.hesseCubic_isHomogeneous lam)]
  obtain ⟨ha, hb, hc, hd, he, hf, hh, hi, hj, hk⟩ := hesseCubic_coefficients lam
  rw [ha, hb, hc, hd, he, hf, hh, hi, hj, hk]
  dsimp only [HesseFullResidualRigidity.ambientCoeffV,
    HesseFullResidualRigidity.transportedA, HesseFullResidualRigidity.transportedB,
    HesseFullResidualRigidity.transportedC, HesseFullResidualRigidity.transportedD,
    HesseFullResidualRigidity.transportedE, HesseFullResidualRigidity.transportedF,
    HesseFullResidualRigidity.transportedH, HesseFullResidualRigidity.transportedJ,
    HesseFullResidualRigidity.hesseQuarticV]
  convert (HesseResidualCertificate.residualCoeffV_sub_tmul_residualCoeffW lam s t) using 1 <;>
    simp only [HesseResidualCertificate.ambientCoeffV,
      HesseResidualCertificate.A, HesseResidualCertificate.B,
      HesseResidualCertificate.C, HesseResidualCertificate.D,
      HesseResidualCertificate.E, HesseResidualCertificate.F,
      HesseResidualCertificate.H, HesseResidualCertificate.J,
      HesseResidualCertificate.K] <;> ring

theorem eval_residualLinearFormOn_affineDualFrame_hesse_two (lam s t : k) :
    eval ![0, 0, 1]
        (residualLinearFormOn (affineDualFrame s t) (affineDualFrameInv s t)
          (HesseNormalForm.hesseCubic lam)) =
      27 * (lam ^ 3 - 1) * HesseFullResidualRigidity.hesseQuarticW lam s t := by
  rw [eval_residualLinearFormOn_affineDualFrame_two _
    (HesseNormalForm.hesseCubic_isHomogeneous lam)]
  obtain ⟨ha, hb, hc, hd, he, hf, hh, hi, hj, hk⟩ := hesseCubic_coefficients lam
  rw [ha, hb, hc, hd, he, hf, hh, hi, hj, hk]
  dsimp only [HesseFullResidualRigidity.ambientCoeffW,
    HesseFullResidualRigidity.transportedA, HesseFullResidualRigidity.transportedB,
    HesseFullResidualRigidity.transportedC, HesseFullResidualRigidity.transportedD,
    HesseFullResidualRigidity.transportedE, HesseFullResidualRigidity.transportedF,
    HesseFullResidualRigidity.transportedH,
    HesseFullResidualRigidity.hesseQuarticW]
  convert (HesseResidualCertificate.residualCoeffW_eq lam s t) using 1 <;>
    simp only [HesseResidualCertificate.ambientCoeffW,
      HesseResidualCertificate.A, HesseResidualCertificate.B,
      HesseResidualCertificate.C, HesseResidualCertificate.D,
      HesseResidualCertificate.E, HesseResidualCertificate.F,
      HesseResidualCertificate.H, HesseResidualCertificate.K] <;> ring

theorem eq_C_mul_hesse_of_coefficients (G : MvPolynomial (Fin 3) k)
    (hG : G.IsHomogeneous 3) (lam : k)
    (hshape :
      PlaneCubicResidual.coeffU2V G = 0 ∧
      PlaneCubicResidual.coeffUV2 G = 0 ∧
      PlaneCubicResidual.coeffU2W G = 0 ∧
      PlaneCubicResidual.coeffV2W G = 0 ∧
      PlaneCubicResidual.coeffUW2 G = 0 ∧
      PlaneCubicResidual.coeffVW2 G = 0 ∧
      PlaneCubicResidual.coeffV3 G = PlaneCubicResidual.coeffU3 G ∧
      PlaneCubicResidual.coeffW3 G = PlaneCubicResidual.coeffU3 G ∧
      PlaneCubicResidual.coeffUVW G = -3 * lam * PlaneCubicResidual.coeffU3 G) :
    G = C (PlaneCubicResidual.coeffU3 G) * HesseNormalForm.hesseCubic lam := by
  obtain ⟨hb, hc, he, hh, hi, hj, hd, hk, hf⟩ := hshape
  let a := PlaneCubicResidual.coeffU3 G
  change G = C a * HesseNormalForm.hesseCubic lam
  conv_lhs => rw [PlaneCubicResidual.planeCubic_eq_sum_monomials G hG]
  conv_rhs => rw [PlaneCubicResidual.planeCubic_eq_sum_monomials
    (HesseNormalForm.hesseCubic lam) (HesseNormalForm.hesseCubic_isHomogeneous lam)]
  obtain ⟨hha, hhb, hhc, hhd, hhe, hhf, hhh, hhi, hhj, hhk⟩ :=
    hesseCubic_coefficients lam
  rw [hb, hc, he, hh, hi, hj, hd, hk, hf,
    hha, hhb, hhc, hhd, hhe, hhf, hhh, hhi, hhj, hhk]
  simp only [monomial_zero, add_zero]
  dsimp only [a]
  simp only [mul_add, C_mul_monomial, mul_one]
  congr 1 <;> ring

omit [CharZero k] in
theorem residualLinearForm_C_mul (r : k) (G : MvPolynomial (Fin 3) k) :
    PlaneCubicResidual.residualLinearForm (C r * G) =
      C (r ^ 5) * PlaneCubicResidual.residualLinearForm G := by
  simp only [PlaneCubicResidual.residualLinearForm, PlaneCubicResidual.coeffU3,
    PlaneCubicResidual.coeffU2V, PlaneCubicResidual.coeffUV2,
    PlaneCubicResidual.coeffV3, PlaneCubicResidual.coeffU2W,
    PlaneCubicResidual.coeffUVW, PlaneCubicResidual.coeffV2W,
    PlaneCubicResidual.coeffUW2, PlaneCubicResidual.coeffVW2,
    PlaneCubicResidual.coeffW3, coeff_C_mul]
  rw [PlaneCubicResidual.residualCoeffU_smul,
    PlaneCubicResidual.residualCoeffV_smul,
    PlaneCubicResidual.residualCoeffW_smul]
  simp only [map_mul, map_pow]
  ring

omit [CharZero k] in
theorem residualLinearFormOn_C_mul (M N : Matrix (Fin 3) (Fin 3) k)
    (r : k) (G : MvPolynomial (Fin 3) k) :
    residualLinearFormOn M N (C r * G) = C (r ^ 5) * residualLinearFormOn M N G := by
  simp only [residualLinearFormOn, map_mul]
  rw [aeval_C]
  simp only [MvPolynomial.algebraMap_eq]
  rw [residualLinearForm_C_mul]
  simp only [map_mul]
  rw [aeval_C]
  simp only [MvPolynomial.algebraMap_eq]

omit [CharZero k] in
theorem hasCommonResidualLineMap_C_mul {ι : Type v}
    (g : ι → MvPolynomial (Fin 3) k) (r : k)
    (hcommon : Standard.HasCommonResidualLineMap g) :
    Standard.HasCommonResidualLineMap (fun q => C r * g q) := by
  intro M N hMN
  obtain ⟨ell, hell⟩ := hcommon M N hMN
  refine ⟨ell, fun q => ?_⟩
  obtain ⟨a, ha⟩ := hell q
  refine ⟨r ^ 5 * a, ?_⟩
  rw [residualLinearFormOn_C_mul, ha]
  simp only [C_mul, mul_assoc]

omit [CharZero k] in
theorem residualLineMapBasepointFree_C_mul (G : MvPolynomial (Fin 3) k)
    (r : k) (hr : r ≠ 0) (hbpf : Standard.ResidualLineMapBasepointFree G) :
    Standard.ResidualLineMapBasepointFree (C r * G) := by
  intro M N hMN
  rw [residualLinearFormOn_C_mul]
  exact mul_ne_zero (MvPolynomial.C_ne_zero.mpr (pow_ne_zero 5 hr)) (hbpf M N hMN)

/-- A base-point-free cubic with the same projective residual-line map as a smooth Hesse cubic is
itself a scalar multiple of that Hesse cubic. -/
theorem eq_C_mul_hesse_of_hasCommonResidualLineMap {ι : Type v}
    (g : ι → MvPolynomial (Fin 3) k)
    (hgHom : ∀ q, (g q).IsHomogeneous 3)
    (hbpf : ∀ q, Standard.ResidualLineMapBasepointFree (g q))
    (hcommon : Standard.HasCommonResidualLineMap g)
    (i₀ i : ι) (lam : k) (hi₀ : g i₀ = HesseNormalForm.hesseCubic lam)
    (hlam : lam ^ 3 ≠ 1) :
    g i = C (PlaneCubicResidual.coeffU3 (g i)) * HesseNormalForm.hesseCubic lam := by
  have hscale : (27 : k) * (lam ^ 3 - 1) ≠ 0 :=
    mul_ne_zero (by norm_num) (sub_ne_zero.mpr hlam)
  have hU : ∀ s t,
      HesseFullResidualRigidity.ambientCoeffU
          (PlaneCubicResidual.coeffU3 (g i)) (PlaneCubicResidual.coeffU2V (g i))
          (PlaneCubicResidual.coeffUV2 (g i)) (PlaneCubicResidual.coeffV3 (g i))
          (PlaneCubicResidual.coeffU2W (g i)) (PlaneCubicResidual.coeffUVW (g i))
          (PlaneCubicResidual.coeffV2W (g i)) (PlaneCubicResidual.coeffUW2 (g i))
          (PlaneCubicResidual.coeffVW2 (g i)) (PlaneCubicResidual.coeffW3 (g i)) s t *
        HesseFullResidualRigidity.hesseQuarticW lam s t =
      HesseFullResidualRigidity.ambientCoeffW
          (PlaneCubicResidual.coeffU3 (g i)) (PlaneCubicResidual.coeffU2V (g i))
          (PlaneCubicResidual.coeffUV2 (g i)) (PlaneCubicResidual.coeffV3 (g i))
          (PlaneCubicResidual.coeffU2W (g i)) (PlaneCubicResidual.coeffUVW (g i))
          (PlaneCubicResidual.coeffV2W (g i)) (PlaneCubicResidual.coeffUW2 (g i))
          (PlaneCubicResidual.coeffVW2 (g i)) (PlaneCubicResidual.coeffW3 (g i)) s t *
        HesseFullResidualRigidity.hesseQuarticU lam s t := by
    intro s t
    obtain ⟨ell, hell⟩ := hcommon (affineDualFrame s t) (affineDualFrameInv s t)
      (affineDualFrame_mul_inv s t)
    obtain ⟨alpha, halpha⟩ := hell i
    obtain ⟨beta, hbeta⟩ := hell i₀
    rw [hi₀] at hbeta
    have hcross :
        eval ![1, 0, 0]
            (residualLinearFormOn (affineDualFrame s t) (affineDualFrameInv s t) (g i)) *
          eval ![0, 0, 1]
            (residualLinearFormOn (affineDualFrame s t) (affineDualFrameInv s t)
              (HesseNormalForm.hesseCubic lam)) =
        eval ![0, 0, 1]
            (residualLinearFormOn (affineDualFrame s t) (affineDualFrameInv s t) (g i)) *
          eval ![1, 0, 0]
            (residualLinearFormOn (affineDualFrame s t) (affineDualFrameInv s t)
              (HesseNormalForm.hesseCubic lam)) := by
      rw [halpha, hbeta]
      simp only [eval_mul, eval_C]
      ring
    have hcross' :
        HesseFullResidualRigidity.ambientCoeffU
            (PlaneCubicResidual.coeffU3 (g i)) (PlaneCubicResidual.coeffU2V (g i))
            (PlaneCubicResidual.coeffUV2 (g i)) (PlaneCubicResidual.coeffV3 (g i))
            (PlaneCubicResidual.coeffU2W (g i)) (PlaneCubicResidual.coeffUVW (g i))
            (PlaneCubicResidual.coeffV2W (g i)) (PlaneCubicResidual.coeffUW2 (g i))
            (PlaneCubicResidual.coeffVW2 (g i)) (PlaneCubicResidual.coeffW3 (g i)) s t *
          ((27 : k) * (lam ^ 3 - 1) * HesseFullResidualRigidity.hesseQuarticW lam s t) =
        HesseFullResidualRigidity.ambientCoeffW
            (PlaneCubicResidual.coeffU3 (g i)) (PlaneCubicResidual.coeffU2V (g i))
            (PlaneCubicResidual.coeffUV2 (g i)) (PlaneCubicResidual.coeffV3 (g i))
            (PlaneCubicResidual.coeffU2W (g i)) (PlaneCubicResidual.coeffUVW (g i))
            (PlaneCubicResidual.coeffV2W (g i)) (PlaneCubicResidual.coeffUW2 (g i))
            (PlaneCubicResidual.coeffVW2 (g i)) (PlaneCubicResidual.coeffW3 (g i)) s t *
          ((27 : k) * (lam ^ 3 - 1) * HesseFullResidualRigidity.hesseQuarticU lam s t) := by
      simpa only [eval_residualLinearFormOn_affineDualFrame_zero _ (hgHom i),
        eval_residualLinearFormOn_affineDualFrame_two _ (hgHom i),
        eval_residualLinearFormOn_affineDualFrame_hesse_zero,
        eval_residualLinearFormOn_affineDualFrame_hesse_two] using hcross
    apply mul_left_cancel₀ hscale
    linear_combination hcross'
  have hV : ∀ s t,
      HesseFullResidualRigidity.ambientCoeffV
          (PlaneCubicResidual.coeffU3 (g i)) (PlaneCubicResidual.coeffU2V (g i))
          (PlaneCubicResidual.coeffUV2 (g i)) (PlaneCubicResidual.coeffV3 (g i))
          (PlaneCubicResidual.coeffU2W (g i)) (PlaneCubicResidual.coeffUVW (g i))
          (PlaneCubicResidual.coeffV2W (g i)) (PlaneCubicResidual.coeffUW2 (g i))
          (PlaneCubicResidual.coeffVW2 (g i)) (PlaneCubicResidual.coeffW3 (g i)) s t *
        HesseFullResidualRigidity.hesseQuarticW lam s t =
      HesseFullResidualRigidity.ambientCoeffW
          (PlaneCubicResidual.coeffU3 (g i)) (PlaneCubicResidual.coeffU2V (g i))
          (PlaneCubicResidual.coeffUV2 (g i)) (PlaneCubicResidual.coeffV3 (g i))
          (PlaneCubicResidual.coeffU2W (g i)) (PlaneCubicResidual.coeffUVW (g i))
          (PlaneCubicResidual.coeffV2W (g i)) (PlaneCubicResidual.coeffUW2 (g i))
          (PlaneCubicResidual.coeffVW2 (g i)) (PlaneCubicResidual.coeffW3 (g i)) s t *
        HesseFullResidualRigidity.hesseQuarticV lam s t := by
    intro s t
    obtain ⟨ell, hell⟩ := hcommon (affineDualFrame s t) (affineDualFrameInv s t)
      (affineDualFrame_mul_inv s t)
    obtain ⟨alpha, halpha⟩ := hell i
    obtain ⟨beta, hbeta⟩ := hell i₀
    rw [hi₀] at hbeta
    have hcross :
        eval ![0, 1, 0]
            (residualLinearFormOn (affineDualFrame s t) (affineDualFrameInv s t) (g i)) *
          eval ![0, 0, 1]
            (residualLinearFormOn (affineDualFrame s t) (affineDualFrameInv s t)
              (HesseNormalForm.hesseCubic lam)) =
        eval ![0, 0, 1]
            (residualLinearFormOn (affineDualFrame s t) (affineDualFrameInv s t) (g i)) *
          eval ![0, 1, 0]
            (residualLinearFormOn (affineDualFrame s t) (affineDualFrameInv s t)
              (HesseNormalForm.hesseCubic lam)) := by
      rw [halpha, hbeta]
      simp only [eval_mul, eval_C]
      ring
    have hcross' :
        HesseFullResidualRigidity.ambientCoeffV
            (PlaneCubicResidual.coeffU3 (g i)) (PlaneCubicResidual.coeffU2V (g i))
            (PlaneCubicResidual.coeffUV2 (g i)) (PlaneCubicResidual.coeffV3 (g i))
            (PlaneCubicResidual.coeffU2W (g i)) (PlaneCubicResidual.coeffUVW (g i))
            (PlaneCubicResidual.coeffV2W (g i)) (PlaneCubicResidual.coeffUW2 (g i))
            (PlaneCubicResidual.coeffVW2 (g i)) (PlaneCubicResidual.coeffW3 (g i)) s t *
          ((27 : k) * (lam ^ 3 - 1) * HesseFullResidualRigidity.hesseQuarticW lam s t) =
        HesseFullResidualRigidity.ambientCoeffW
            (PlaneCubicResidual.coeffU3 (g i)) (PlaneCubicResidual.coeffU2V (g i))
            (PlaneCubicResidual.coeffUV2 (g i)) (PlaneCubicResidual.coeffV3 (g i))
            (PlaneCubicResidual.coeffU2W (g i)) (PlaneCubicResidual.coeffUVW (g i))
            (PlaneCubicResidual.coeffV2W (g i)) (PlaneCubicResidual.coeffUW2 (g i))
            (PlaneCubicResidual.coeffVW2 (g i)) (PlaneCubicResidual.coeffW3 (g i)) s t *
          ((27 : k) * (lam ^ 3 - 1) * HesseFullResidualRigidity.hesseQuarticV lam s t) := by
      simpa only [eval_residualLinearFormOn_affineDualFrame_one _ (hgHom i),
        eval_residualLinearFormOn_affineDualFrame_two _ (hgHom i),
        eval_residualLinearFormOn_affineDualFrame_hesse_one,
        eval_residualLinearFormOn_affineDualFrame_hesse_two] using hcross
    apply mul_left_cancel₀ hscale
    linear_combination hcross'
  have hW0 :
      HesseFullResidualRigidity.ambientCoeffW
          (PlaneCubicResidual.coeffU3 (g i)) (PlaneCubicResidual.coeffU2V (g i))
          (PlaneCubicResidual.coeffUV2 (g i)) (PlaneCubicResidual.coeffV3 (g i))
          (PlaneCubicResidual.coeffU2W (g i)) (PlaneCubicResidual.coeffUVW (g i))
          (PlaneCubicResidual.coeffV2W (g i)) (PlaneCubicResidual.coeffUW2 (g i))
          (PlaneCubicResidual.coeffVW2 (g i)) (PlaneCubicResidual.coeffW3 (g i)) 0 0 ≠ 0 := by
    obtain ⟨ell, hell⟩ := hcommon (affineDualFrame 0 0) (affineDualFrameInv 0 0)
      (affineDualFrame_mul_inv 0 0)
    obtain ⟨alpha, halpha⟩ := hell i
    obtain ⟨beta, hbeta⟩ := hell i₀
    rw [hi₀] at hbeta
    have halpha0 : alpha ≠ 0 := by
      intro ha
      apply hbpf i (affineDualFrame 0 0) (affineDualFrameInv 0 0)
        (affineDualFrame_mul_inv 0 0)
      rw [halpha, ha]
      simp
    have hHval :
        eval ![0, 0, 1]
            (residualLinearFormOn (affineDualFrame 0 0) (affineDualFrameInv 0 0)
              (HesseNormalForm.hesseCubic lam)) ≠ 0 := by
      rw [eval_residualLinearFormOn_affineDualFrame_hesse_two]
      simpa [HesseFullResidualRigidity.hesseQuarticW] using hscale
    have hellval : eval ![0, 0, 1] ell ≠ 0 := by
      intro hz
      apply hHval
      rw [hbeta]
      simp [hz]
    have hGval :
        eval ![0, 0, 1]
            (residualLinearFormOn (affineDualFrame 0 0) (affineDualFrameInv 0 0) (g i)) ≠ 0 := by
      rw [halpha]
      simpa only [eval_mul, eval_C] using mul_ne_zero halpha0 hellval
    simpa only [eval_residualLinearFormOn_affineDualFrame_two _ (hgHom i)] using hGval
  exact eq_C_mul_hesse_of_coefficients (g i) (hgHom i) lam
    (HesseProjectiveResidualRigidity.eq_hesse_of_projective_fullResidual_eq_at_origin
      (PlaneCubicResidual.coeffU3 (g i)) (PlaneCubicResidual.coeffU2V (g i))
      (PlaneCubicResidual.coeffUV2 (g i)) (PlaneCubicResidual.coeffV3 (g i))
      (PlaneCubicResidual.coeffU2W (g i)) (PlaneCubicResidual.coeffUVW (g i))
      (PlaneCubicResidual.coeffV2W (g i)) (PlaneCubicResidual.coeffUW2 (g i))
      (PlaneCubicResidual.coeffVW2 (g i)) (PlaneCubicResidual.coeffW3 (g i)) lam hW0 hU hV)

end BConicBundleMultisections.HesseResidualMapBridge
