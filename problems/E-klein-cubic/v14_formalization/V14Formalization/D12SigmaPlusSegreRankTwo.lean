/-
Copyright (c) 2026 V14Formalization contributors.
Released under Apache 2.0 license.
-/
module

public import V14Formalization.D12SigmaPlusSegreRank

/-!
# Rank exactly two at a smooth `Fplus` point
-/

noncomputable section

open Matrix MvPolynomial

namespace V14Formalization.D12SigmaPlusSegreCore

private lemma pow3_shift (x t : Ki) :
    (x + t) ^ 3 = x ^ 3 + (3 * x ^ 2) * t + (3 * x + t) * t ^ 2 := by
  ring

private lemma pow2_mul_shift (x t y : Ki) :
    (x + t) ^ 2 * y = x ^ 2 * y + (2 * x * y) * t + y * t ^ 2 := by
  ring

private lemma mul_pow2_shift (x t y : Ki) :
    y * (x + t) ^ 2 = y * x ^ 2 + (2 * y * x) * t + y * t ^ 2 := by
  ring

private lemma mul_shift (x t y : Ki) :
    (x + t) * y = x * y + y * t := by
  ring

private lemma shift0_apply (a : Fin 3 → Ki) (t : Ki) :
    (![a 0 + t, a 1, a 2] : Fin 3 → Ki) =
      a + t • Pi.single (0 : Fin 3) (1 : Ki) := by
  funext i
  fin_cases i <;>
    simp [Pi.add_apply, Pi.smul_apply, smul_eq_mul, Pi.single_eq_same,
      Pi.single_eq_of_ne]

private lemma shift1_apply (a : Fin 3 → Ki) (t : Ki) :
    (![a 0, a 1 + t, a 2] : Fin 3 → Ki) =
      a + t • Pi.single (1 : Fin 3) (1 : Ki) := by
  funext i
  fin_cases i <;>
    simp [Pi.add_apply, Pi.smul_apply, smul_eq_mul, Pi.single_eq_same,
      Pi.single_eq_of_ne]

private lemma shift2_apply (a : Fin 3 → Ki) (t : Ki) :
    (![a 0, a 1, a 2 + t] : Fin 3 → Ki) =
      a + t • Pi.single (2 : Fin 3) (1 : Ki) := by
  funext i
  fin_cases i <;>
    simp [Pi.add_apply, Pi.smul_apply, smul_eq_mul, Pi.single_eq_same,
      Pi.single_eq_of_ne]

theorem eval_Fplus_path0 (a : Fin 3 → Ki) (t : Ki) :
    eval (a + t • Pi.single (0 : Fin 3) (1 : Ki)) Fplus =
      eval a Fplus + t * eval a (pderiv 0 Fplus) +
        t ^ 2 *
          (ofLadj Fplus_re_000 Fplus_im_000 * ((3 : Ki) * a 0 + t) +
            ofLadj Fplus_re_001 Fplus_im_001 * a 1 +
              ofLadj Fplus_re_002 Fplus_im_002 * a 2) := by
  rw [← shift0_apply, eval_Fplus, eval_Fplus, eval_pderiv0]
  simp
  have hx := pow3_shift (a 0) t
  have hxy := pow2_mul_shift (a 0) t (a 1)
  have hxz := pow2_mul_shift (a 0) t (a 2)
  have hy2 := mul_shift (a 0) t (a 1 ^ 2)
  have hyz := mul_shift (a 0) t (a 1 * a 2)
  have hz2 := mul_shift (a 0) t (a 2 ^ 2)
  linear_combination
    ofLadj Fplus_re_000 Fplus_im_000 * hx +
      ofLadj Fplus_re_001 Fplus_im_001 * hxy +
        ofLadj Fplus_re_002 Fplus_im_002 * hxz +
          ofLadj Fplus_re_011 Fplus_im_011 * hy2 +
            ofLadj Fplus_re_012 Fplus_im_012 * hyz +
              ofLadj Fplus_re_022 Fplus_im_022 * hz2

theorem eval_Fplus_path1 (a : Fin 3 → Ki) (t : Ki) :
    eval (a + t • Pi.single (1 : Fin 3) (1 : Ki)) Fplus =
      eval a Fplus + t * eval a (pderiv 1 Fplus) +
        t ^ 2 *
          (ofLadj Fplus_re_111 Fplus_im_111 * ((3 : Ki) * a 1 + t) +
            ofLadj Fplus_re_011 Fplus_im_011 * a 0 +
              ofLadj Fplus_re_112 Fplus_im_112 * a 2) := by
  rw [← shift1_apply, eval_Fplus, eval_Fplus, eval_pderiv1]
  simp
  have hy := pow3_shift (a 1) t
  have h0y2 := mul_pow2_shift (a 1) t (a 0)
  have hy2z := pow2_mul_shift (a 1) t (a 2)
  have h0y := mul_shift (a 1) t (a 0 ^ 2)
  have h0yz := mul_shift (a 1) t (a 0 * a 2)
  have hyz2 := mul_shift (a 1) t (a 2 ^ 2)
  linear_combination
    ofLadj Fplus_re_111 Fplus_im_111 * hy +
      ofLadj Fplus_re_011 Fplus_im_011 * h0y2 +
        ofLadj Fplus_re_112 Fplus_im_112 * hy2z +
          ofLadj Fplus_re_001 Fplus_im_001 * h0y +
            ofLadj Fplus_re_012 Fplus_im_012 * h0yz +
              ofLadj Fplus_re_122 Fplus_im_122 * hyz2

theorem eval_Fplus_path2 (a : Fin 3 → Ki) (t : Ki) :
    eval (a + t • Pi.single (2 : Fin 3) (1 : Ki)) Fplus =
      eval a Fplus + t * eval a (pderiv 2 Fplus) +
        t ^ 2 *
          (ofLadj Fplus_re_222 Fplus_im_222 * ((3 : Ki) * a 2 + t) +
            ofLadj Fplus_re_022 Fplus_im_022 * a 0 +
              ofLadj Fplus_re_122 Fplus_im_122 * a 1) := by
  rw [← shift2_apply, eval_Fplus, eval_Fplus, eval_pderiv2]
  simp
  have hz := pow3_shift (a 2) t
  have h0z2 := mul_pow2_shift (a 2) t (a 0)
  have h1z2 := mul_pow2_shift (a 2) t (a 1)
  have h0z := mul_shift (a 2) t (a 0 ^ 2)
  have h01z := mul_shift (a 2) t (a 0 * a 1)
  have h1z := mul_shift (a 2) t (a 1 ^ 2)
  linear_combination
    ofLadj Fplus_re_222 Fplus_im_222 * hz +
      ofLadj Fplus_re_022 Fplus_im_022 * h0z2 +
        ofLadj Fplus_re_122 Fplus_im_122 * h1z2 +
          ofLadj Fplus_re_002 Fplus_im_002 * h0z +
            ofLadj Fplus_re_012 Fplus_im_012 * h01z +
              ofLadj Fplus_re_112 Fplus_im_112 * h1z

private theorem linear_coeff_of_cubic
    (A α β γ δ : Ki)
    (h : ∀ t : Ki, A * t + (α + β * t) * t ^ 2 = (γ + δ * t) * t ^ 2) :
    A = 0 := by
  have hp :
      (Polynomial.C A * Polynomial.X +
          Polynomial.C α * Polynomial.X ^ 2 +
            Polynomial.C β * Polynomial.X ^ 3) =
        Polynomial.C γ * Polynomial.X ^ 2 +
          Polynomial.C δ * Polynomial.X ^ 3 := by
    refine Polynomial.funext fun t => ?_
    have ht := h t
    simp [mul_add, add_mul, pow_two, pow_three] at ht ⊢
    linear_combination ht
  simpa using congrArg (fun p : Polynomial Ki => p.coeff 1) hp

theorem eval_pderiv_eq_zero_of_adjugate_eq_zero
    (a : Fin 3 → Ki) (k : Fin 3)
    (hadj : (bilinearN a).adjugate = 0)
    (hdet : (bilinearN a).det = 0) :
    eval a (pderiv k Fplus) = 0 := by
  let B := bilinearN (Pi.single k (1 : Ki))
  have hexp (t : Ki) :
      det (bilinearN a + t • B) =
        t ^ 2 * ∑ i : Fin 3, ∑ j : Fin 3, adjugate B j i * bilinearN a i j +
          t ^ 3 * det B := by
    rw [det_add_smul_expansion, hdet, hadj]
    simp
  have hF : eval a Fplus = 0 := (eval_Fplus_eq_det a).trans hdet
  have hf_sq (t : Ki) :
      eval (a + t • Pi.single k (1 : Ki)) Fplus =
        t ^ 2 *
          (∑ i : Fin 3, ∑ j : Fin 3, adjugate B j i * bilinearN a i j +
            t * det B) := by
    rw [eval_Fplus_add_smul a (Pi.single k 1) t, hexp]
    ring
  fin_cases k
  · refine linear_coeff_of_cubic (eval a (pderiv 0 Fplus))
      (ofLadj Fplus_re_000 Fplus_im_000 * ((3 : Ki) * a 0) +
        ofLadj Fplus_re_001 Fplus_im_001 * a 1 +
          ofLadj Fplus_re_002 Fplus_im_002 * a 2)
      (ofLadj Fplus_re_000 Fplus_im_000)
      (∑ i : Fin 3, ∑ j : Fin 3, adjugate B j i * bilinearN a i j) B.det ?_
    intro t
    have hL := eval_Fplus_path0 a t
    have hR := hf_sq t
    simp [hF, add_mul, mul_add] at hL hR ⊢
    linear_combination hL.symm + hR
  · refine linear_coeff_of_cubic (eval a (pderiv 1 Fplus))
      (ofLadj Fplus_re_111 Fplus_im_111 * ((3 : Ki) * a 1) +
        ofLadj Fplus_re_011 Fplus_im_011 * a 0 +
          ofLadj Fplus_re_112 Fplus_im_112 * a 2)
      (ofLadj Fplus_re_111 Fplus_im_111)
      (∑ i : Fin 3, ∑ j : Fin 3, adjugate B j i * bilinearN a i j) B.det ?_
    intro t
    have hL := eval_Fplus_path1 a t
    have hR := hf_sq t
    simp [hF, add_mul, mul_add] at hL hR ⊢
    linear_combination hL.symm + hR
  · refine linear_coeff_of_cubic (eval a (pderiv 2 Fplus))
      (ofLadj Fplus_re_222 Fplus_im_222 * ((3 : Ki) * a 2) +
        ofLadj Fplus_re_022 Fplus_im_022 * a 0 +
          ofLadj Fplus_re_122 Fplus_im_122 * a 1)
      (ofLadj Fplus_re_222 Fplus_im_222)
      (∑ i : Fin 3, ∑ j : Fin 3, adjugate B j i * bilinearN a i j) B.det ?_
    intro t
    have hL := eval_Fplus_path2 a t
    have hR := hf_sq t
    simp [hF, add_mul, mul_add] at hL hR ⊢
    linear_combination hL.symm + hR

theorem eval_pderiv_eq_zero_of_rank_le_one
    (a : Fin 3 → Ki) (h : (bilinearN a).rank ≤ 1) (k : Fin 3) :
    eval a (pderiv k Fplus) = 0 :=
  eval_pderiv_eq_zero_of_adjugate_eq_zero a k
    (adjugate_eq_zero_of_rank_le_one _ h)
    (det_eq_zero_of_rank_lt_card _ (lt_of_le_of_lt h (by decide)))

public theorem smooth_detCubic_rank_eq_two
    (a : Fin 3 → Ki) (ha : a ≠ 0)
    (hF : eval a Fplus = 0) :
    (bilinearN a).rank = 2 := by
  have hle : (bilinearN a).rank ≤ 2 := rank_le_two_of_Fplus a hF
  refine le_antisymm hle ?_
  by_contra hlt
  have hle1 : (bilinearN a).rank ≤ 1 := Nat.lt_succ_iff.mp (lt_of_not_ge hlt)
  obtain ⟨i, hi⟩ := Fplus_isSmoothPlaneCubic.2 a ha hF
  exact hi (eval_pderiv_eq_zero_of_rank_le_one a hle1 i)

end V14Formalization.D12SigmaPlusSegreCore
