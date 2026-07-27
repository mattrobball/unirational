/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.BinaryCubicLineCoeff
public import BConicBundleMultisections.HesseNormalForm

/-!
# Exact tangent-residual point formula for a Hesse cubic

For the Hesse cubic

`U^3 + V^3 + W^3 - 3 * lam * U * V * W`,

the classical tangent-residual point map is represented by the quartics

`[U * (V^3 - W^3), V * (W^3 - U^3), W * (U^3 - V^3)]`.

This file checks that formula directly against the repository's binary-line residual
representative.  On the chart `W != 0`, use the tangent direction

`(-partial_V F, partial_U F, 0)`.

At a point of the Hesse cubic, the resulting `residualAmbientRep` is the displayed quartic triple
times the common scalar `-27 * (lam^3 - 1) * W^3`.  Thus the scalar is nonzero for a smooth Hesse
cubic on this chart.  The proof is a finite polynomial calculation; it does not use a group law or
identify the resulting morphism with `[-2]`.
-/

@[expose] public section

open MvPolynomial

namespace BConicBundleMultisections.HesseTangentResidualCertificate

noncomputable section

universe u

variable {R : Type u} [CommRing R]

/-- Quartic representative of the tangent-residual point map on a Hesse cubic. -/
def hesseTangentResidualRep (p : Fin 3 -> R) : Fin 3 -> R :=
  ![p 0 * (p 1 ^ 3 - p 2 ^ 3),
    p 1 * (p 2 ^ 3 - p 0 ^ 3),
    p 2 * (p 0 ^ 3 - p 1 ^ 3)]

/-- A tangent direction suited to the chart `p 2 != 0`: `(-partial_V F, partial_U F, 0)`. -/
def hesseChartTangentDir (lam : R) (p : Fin 3 -> R) : Fin 3 -> R :=
  ![-3 * (p 1 ^ 2 - lam * p 0 * p 2),
    3 * (p 0 ^ 2 - lam * p 1 * p 2),
    0]

/-- The quartic representative lies on the tangent line, as an unconditional polynomial
identity. -/
theorem tangentGradient_dot_hesseTangentResidualRep (lam : R) (p : Fin 3 -> R) :
    tangentGradient (HesseNormalForm.hesseCubic lam) p ⬝ᵥ
        hesseTangentResidualRep p = 0 := by
  simp [dotProduct, Fin.sum_univ_three, tangentGradient,
    HesseNormalForm.eval_pderiv_zero_hesseCubic,
    HesseNormalForm.eval_pderiv_one_hesseCubic,
    HesseNormalForm.eval_pderiv_two_hesseCubic,
    hesseTangentResidualRep]
  ring

/-- Substitution of the quartic tangent-residual representative preserves the Hesse cubic up to
the expected degree-nine factor. -/
theorem eval_hesseCubic_hesseTangentResidualRep (lam : R) (p : Fin 3 -> R) :
    eval (hesseTangentResidualRep p) (HesseNormalForm.hesseCubic lam) =
      (p 0 ^ 3 - p 1 ^ 3) * (p 1 ^ 3 - p 2 ^ 3) * (p 2 ^ 3 - p 0 ^ 3) *
        eval p (HesseNormalForm.hesseCubic lam) := by
  simp [HesseNormalForm.eval_hesseCubic, hesseTangentResidualRep]
  ring

/-- The two standard Hesse flexes are fixed projectively (with the displayed representatives).
These evaluations give a concrete nonconstancy witness for the quartic map. -/
theorem hesseTangentResidualRep_standard_flexes :
    hesseTangentResidualRep (![1, -1, 0] : Fin 3 -> R) = ![-1, 1, 0] ∧
      hesseTangentResidualRep (![1, 0, -1] : Fin 3 -> R) = ![1, 0, -1] := by
  constructor <;> funext i <;> fin_cases i <;> simp [hesseTangentResidualRep] <;> ring

section Field

variable {K : Type u} [Field K] [NeZero (2 : K)] [NeZero (3 : K)]

/-- On a smooth Hesse cubic the three quartics defining the tangent-residual point map have no
projective common zero. -/
theorem hesseTangentResidualRep_ne_zero_of_hesseCubic
    (lam : K) (p : Fin 3 -> K) (hlam : lam ^ 3 ≠ 1) (hp0 : p ≠ 0)
    (hp : eval p (HesseNormalForm.hesseCubic lam) = 0) :
    hesseTangentResidualRep p ≠ 0 := by
  intro hzero
  have h0 : p 0 * (p 1 ^ 3 - p 2 ^ 3) = 0 := by
    simpa [hesseTangentResidualRep] using congrFun hzero (0 : Fin 3)
  have h1 : p 1 * (p 2 ^ 3 - p 0 ^ 3) = 0 := by
    simpa [hesseTangentResidualRep] using congrFun hzero (1 : Fin 3)
  have h2 : p 2 * (p 0 ^ 3 - p 1 ^ 3) = 0 := by
    simpa [hesseTangentResidualRep] using congrFun hzero (2 : Fin 3)
  have hp' : p 0 ^ 3 + p 1 ^ 3 + p 2 ^ 3 - 3 * lam * p 0 * p 1 * p 2 = 0 := by
    simpa only [HesseNormalForm.eval_hesseCubic] using hp
  have hx : p 0 ≠ 0 := by
    intro hx
    have hy_or_hz : p 1 = 0 ∨ p 2 = 0 := by
      have : p 1 * p 2 ^ 3 = 0 := by simpa [hx] using h1
      rcases mul_eq_zero.mp this with hy | hz
      · exact Or.inl hy
      · exact Or.inr (eq_zero_of_pow_eq_zero hz)
    rcases hy_or_hz with hy | hz
    · have hz3 : p 2 ^ 3 = 0 := by simpa [hx, hy] using hp'
      have hz0 : p 2 = 0 := eq_zero_of_pow_eq_zero hz3
      apply hp0
      funext i
      fin_cases i <;> simp [hx, hy, hz0]
    · have hy3 : p 1 ^ 3 = 0 := by simpa [hx, hz] using hp'
      have hy0 : p 1 = 0 := eq_zero_of_pow_eq_zero hy3
      apply hp0
      funext i
      fin_cases i <;> simp [hx, hy0, hz]
  have hy : p 1 ≠ 0 := by
    intro hy
    have hz : p 2 = 0 := by
      have : p 2 * p 0 ^ 3 = 0 := by simpa [hy] using h2
      exact (mul_eq_zero.mp this).resolve_right (pow_ne_zero 3 hx)
    have hx3 : p 0 ^ 3 = 0 := by simpa [hy, hz] using hp'
    exact hx (eq_zero_of_pow_eq_zero hx3)
  have hz : p 2 ≠ 0 := by
    intro hz
    have : p 1 * (-(p 0 ^ 3)) = 0 := by simpa [hz] using h1
    exact (mul_ne_zero hy (neg_ne_zero.mpr (pow_ne_zero 3 hx))) this
  have hyz : p 1 ^ 3 = p 2 ^ 3 :=
    sub_eq_zero.mp ((mul_eq_zero.mp h0).resolve_left hx)
  have hzx : p 2 ^ 3 = p 0 ^ 3 :=
    sub_eq_zero.mp ((mul_eq_zero.mp h1).resolve_left hy)
  have hxy : p 0 ^ 3 = p 1 ^ 3 :=
    sub_eq_zero.mp ((mul_eq_zero.mp h2).resolve_left hz)
  have hrel : p 0 ^ 3 = lam * p 0 * p 1 * p 2 := by
    have hthree : (3 : K) ≠ 0 := by norm_num
    apply (mul_left_cancel₀ hthree)
    rw [← hxy, hzx] at hp'
    linear_combination hp'
  have hprod : (lam * p 0 * p 1 * p 2) ^ 3 = lam ^ 3 * p 0 ^ 9 := by
    calc
      (lam * p 0 * p 1 * p 2) ^ 3 =
          lam ^ 3 * p 0 ^ 3 * p 1 ^ 3 * p 2 ^ 3 := by ring
      _ = lam ^ 3 * p 0 ^ 9 := by rw [← hxy, hzx]; ring
  have hpow : lam ^ 3 * p 0 ^ 9 = p 0 ^ 9 := by
    calc
      lam ^ 3 * p 0 ^ 9 = (lam * p 0 * p 1 * p 2) ^ 3 := hprod.symm
      _ = (p 0 ^ 3) ^ 3 := by rw [hrel]
      _ = p 0 ^ 9 := by ring
  have hfac : (lam ^ 3 - 1) * p 0 ^ 9 = 0 := by
    linear_combination hpow
  have hlam0 : lam ^ 3 - 1 = 0 :=
    (mul_eq_zero.mp hfac).resolve_right (pow_ne_zero 9 hx)
  exact hlam (sub_eq_zero.mp hlam0)

end Field

/-- On the chart `p 2 != 0`, the binary-line residual construction gives the classical Hesse
quartic point map, with an explicit common scalar.

The hypotheses `lam^3 != 1` and `p 2 != 0` are not needed for the polynomial equality itself;
they are exactly what makes its displayed scalar nonzero over a field. -/
theorem residualAmbientRep_eq_smul_hesseTangentResidualRep
    (lam : R) (p : Fin 3 -> R)
    (hp : eval p (HesseNormalForm.hesseCubic lam) = 0) :
    residualAmbientRep p (hesseChartTangentDir lam p)
        (binaryLineRestriction p (hesseChartTangentDir lam p)
          (HesseNormalForm.hesseCubic lam)) =
      fun i => (-27 * (lam ^ 3 - 1) * p 2 ^ 3) * hesseTangentResidualRep p i := by
  let G := HesseNormalForm.hesseCubic lam
  let q := hesseChartTangentDir lam p
  let e := (lam * p 2 + p 0 + p 1) *
    (lam ^ 2 * p 2 ^ 2 - lam * p 0 * p 2 - lam * p 1 * p 2 +
      p 0 ^ 2 - p 0 * p 1 + p 1 ^ 2)
  let fbin := binaryLineRestriction p q G
  have hG : G.IsHomogeneous 3 := HesseNormalForm.hesseCubic_isHomogeneous lam
  have halpha : residualBinaryRep fbin 0 = -eval q G := by
    simp only [residualBinaryRep, Matrix.cons_val_zero]
    rw [coeff03_of_binaryLineRestriction G hG p q]
  have hbeta : residualBinaryRep fbin 1 =
      ∑ i : Fin 3, p i * eval q (pderiv i G) := by
    have hrep : residualBinaryRep fbin 1 = coeff (binaryExponent 1 2) fbin := by
      simp [residualBinaryRep]
    rw [hrep, coeff12_of_binaryLineRestriction G hG p q]
  have heval : eval q G = 27 * (p 0 ^ 3 - p 1 ^ 3) * e := by
    simp [G, q, HesseNormalForm.eval_hesseCubic, hesseChartTangentDir, e]
    ring
  have hpolar : (∑ i : Fin 3, p i * eval q (pderiv i G)) = 27 * p 0 * p 1 * e := by
    simp [Fin.sum_univ_three, G, q,
      HesseNormalForm.eval_pderiv_zero_hesseCubic,
      HesseNormalForm.eval_pderiv_one_hesseCubic,
      HesseNormalForm.eval_pderiv_two_hesseCubic,
      hesseChartTangentDir, e]
    ring
  have he : e = (lam ^ 3 - 1) * p 2 ^ 3 := by
    calc
      e = eval p (HesseNormalForm.hesseCubic lam) + (lam ^ 3 - 1) * p 2 ^ 3 := by
        simp only [e, HesseNormalForm.eval_hesseCubic]
        ring
      _ = (lam ^ 3 - 1) * p 2 ^ 3 := by rw [hp, zero_add]
  have hp' : p 0 ^ 3 + p 1 ^ 3 + p 2 ^ 3 - 3 * lam * p 0 * p 1 * p 2 = 0 := by
    simpa only [HesseNormalForm.eval_hesseCubic] using hp
  have hx : p 0 ^ 3 + 2 * p 1 ^ 3 - 3 * lam * p 0 * p 1 * p 2 =
      p 1 ^ 3 - p 2 ^ 3 := by
    linear_combination hp'
  have hy : 3 * lam * p 0 * p 1 * p 2 - 2 * p 0 ^ 3 - p 1 ^ 3 =
      p 2 ^ 3 - p 0 ^ 3 := by
    linear_combination -hp'
  funext i
  simp only [residualAmbientRep]
  rw [halpha, hbeta, heval, hpolar]
  fin_cases i
  · simp [hesseChartTangentDir, hesseTangentResidualRep]
    calc
      _ = -27 * e * p 0 *
          (p 0 ^ 3 + 2 * p 1 ^ 3 - 3 * lam * p 0 * p 1 * p 2) := by ring
      _ = -27 * e * (p 0 * (p 1 ^ 3 - p 2 ^ 3)) := by rw [hx]; ring
      _ = -(27 * (lam ^ 3 - 1) * p 2 ^ 3 * (p 0 * (p 1 ^ 3 - p 2 ^ 3))) := by
        rw [he]
        calc
          -27 * ((lam ^ 3 - 1) * p 2 ^ 3) * (p 0 * (p 1 ^ 3 - p 2 ^ 3)) =
              -27 * (((lam ^ 3 - 1) * p 2 ^ 3) * (p 0 * (p 1 ^ 3 - p 2 ^ 3))) := by
                ac_rfl
          _ = -(27 * (((lam ^ 3 - 1) * p 2 ^ 3) *
                (p 0 * (p 1 ^ 3 - p 2 ^ 3)))) := neg_mul _ _
          _ = -(27 * (lam ^ 3 - 1) * p 2 ^ 3 *
                (p 0 * (p 1 ^ 3 - p 2 ^ 3))) := by congr 1; ac_rfl
  · simp [hesseChartTangentDir, hesseTangentResidualRep]
    calc
      _ = -27 * e * p 1 *
          (3 * lam * p 0 * p 1 * p 2 - 2 * p 0 ^ 3 - p 1 ^ 3) := by ring
      _ = -27 * e * (p 1 * (p 2 ^ 3 - p 0 ^ 3)) := by rw [hy]; ring
      _ = -(27 * (lam ^ 3 - 1) * p 2 ^ 3 * (p 1 * (p 2 ^ 3 - p 0 ^ 3))) := by
        rw [he]
        calc
          -27 * ((lam ^ 3 - 1) * p 2 ^ 3) * (p 1 * (p 2 ^ 3 - p 0 ^ 3)) =
              -27 * (((lam ^ 3 - 1) * p 2 ^ 3) * (p 1 * (p 2 ^ 3 - p 0 ^ 3))) := by
                ac_rfl
          _ = -(27 * (((lam ^ 3 - 1) * p 2 ^ 3) *
                (p 1 * (p 2 ^ 3 - p 0 ^ 3)))) := neg_mul _ _
          _ = -(27 * (lam ^ 3 - 1) * p 2 ^ 3 *
                (p 1 * (p 2 ^ 3 - p 0 ^ 3))) := by congr 1; ac_rfl
  · simp [hesseChartTangentDir, hesseTangentResidualRep]
    rw [he]
    ring

end

end BConicBundleMultisections.HesseTangentResidualCertificate
