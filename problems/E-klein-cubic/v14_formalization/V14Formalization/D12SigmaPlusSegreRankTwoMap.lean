/-
Copyright (c) 2026 V14Formalization contributors.
Released under Apache 2.0 license.
-/
module

public import V14Formalization.D12SigmaPlusSegreRank
public import V14Formalization.D12SigmaPlusSegreFplusMap

/-!
# Rank exactly two at a smooth `Fplus` point, over any field receiving `Ki`

`D12SigmaPlusSegreRankTwo` proves this over `Ki = ℚ(ζ₁₁, i)` itself.  Nothing
in the argument uses `i`: the determinantal matrix `bilinearNOn φ a`, the
Taylor expansion of the cubic along a coordinate line, and the identification
of the linear coefficient with a partial derivative are all statements about
the image of the coefficients under an arbitrary ring map `φ : Ki →+* F`.
The one honest hypothesis is `Infinite F`, used to read a coefficient off a
polynomial function (`Polynomial.funext`); characteristic zero — which any `F`
receiving `Ki` has — gives it.
-/

noncomputable section

open Matrix MvPolynomial

namespace V14Formalization.D12SigmaPlusSegreCore

variable {F : Type*} [Field F] (φ : Ki →+* F)

/-! ### The mapped partial derivatives -/

public theorem eval_map_pderiv0 (a : Fin 3 → F) :
    eval a (pderiv 0 (map φ Fplus)) =
      (3 : F) * φ (ofLadj Fplus_re_000 Fplus_im_000) * a 0 ^ 2 +
        (2 : F) * φ (ofLadj Fplus_re_001 Fplus_im_001) * (a 0 * a 1) +
          (2 : F) * φ (ofLadj Fplus_re_002 Fplus_im_002) * (a 0 * a 2) +
            φ (ofLadj Fplus_re_011 Fplus_im_011) * a 1 ^ 2 +
              φ (ofLadj Fplus_re_012 Fplus_im_012) * (a 1 * a 2) +
                φ (ofLadj Fplus_re_022 Fplus_im_022) * a 2 ^ 2 := by
  rw [pderiv_map]
  unfold Fplus
  simp [map_add, pderiv_C_mul, pderiv_mul, pderiv_X, pderiv_C, pderiv_pow,
    eval_add, eval_mul, eval_C, eval_X, eval_pow, eval_map, map_mul, map_pow]
  ring

public theorem eval_map_pderiv1 (a : Fin 3 → F) :
    eval a (pderiv 1 (map φ Fplus)) =
      φ (ofLadj Fplus_re_001 Fplus_im_001) * a 0 ^ 2 +
        (2 : F) * φ (ofLadj Fplus_re_011 Fplus_im_011) * (a 0 * a 1) +
          φ (ofLadj Fplus_re_012 Fplus_im_012) * (a 0 * a 2) +
            (3 : F) * φ (ofLadj Fplus_re_111 Fplus_im_111) * a 1 ^ 2 +
              (2 : F) * φ (ofLadj Fplus_re_112 Fplus_im_112) * (a 1 * a 2) +
                φ (ofLadj Fplus_re_122 Fplus_im_122) * a 2 ^ 2 := by
  rw [pderiv_map]
  unfold Fplus
  simp [map_add, pderiv_C_mul, pderiv_mul, pderiv_X, pderiv_C, pderiv_pow,
    eval_add, eval_mul, eval_C, eval_X, eval_pow, eval_map, map_mul, map_pow]
  ring

public theorem eval_map_pderiv2 (a : Fin 3 → F) :
    eval a (pderiv 2 (map φ Fplus)) =
      φ (ofLadj Fplus_re_002 Fplus_im_002) * a 0 ^ 2 +
        φ (ofLadj Fplus_re_012 Fplus_im_012) * (a 0 * a 1) +
          (2 : F) * φ (ofLadj Fplus_re_022 Fplus_im_022) * (a 0 * a 2) +
            φ (ofLadj Fplus_re_112 Fplus_im_112) * a 1 ^ 2 +
              (2 : F) * φ (ofLadj Fplus_re_122 Fplus_im_122) * (a 1 * a 2) +
                (3 : F) * φ (ofLadj Fplus_re_222 Fplus_im_222) * a 2 ^ 2 := by
  rw [pderiv_map]
  unfold Fplus
  simp [map_add, pderiv_C_mul, pderiv_mul, pderiv_X, pderiv_C, pderiv_pow,
    eval_add, eval_mul, eval_C, eval_X, eval_pow, eval_map, map_mul, map_pow]
  ring

/-! ### Taylor expansion along a coordinate line -/

private lemma single_shift_same (k : Fin 3) (a : Fin 3 → F) (t : F) :
    (a + t • (Pi.single k (1 : F) : Fin 3 → F)) k = a k + t := by
  simp

private lemma single_shift_ne {k j : Fin 3} (h : j ≠ k) (a : Fin 3 → F)
    (t : F) : (a + t • (Pi.single k (1 : F) : Fin 3 → F)) j = a j := by
  simp [Pi.single_eq_of_ne h]

theorem eval_map_Fplus_path0 (a : Fin 3 → F) (t : F) :
    eval (a + t • Pi.single (0 : Fin 3) (1 : F)) (map φ Fplus) =
      eval a (map φ Fplus) + t * eval a (pderiv 0 (map φ Fplus)) +
        t ^ 2 *
          (φ (ofLadj Fplus_re_000 Fplus_im_000) * ((3 : F) * a 0 + t) +
            φ (ofLadj Fplus_re_001 Fplus_im_001) * a 1 +
              φ (ofLadj Fplus_re_002 Fplus_im_002) * a 2) := by
  have h0 := single_shift_same (F := F) 0 a t
  have h1 := single_shift_ne (F := F) (show (1 : Fin 3) ≠ 0 by decide) a t
  have h2 := single_shift_ne (F := F) (show (2 : Fin 3) ≠ 0 by decide) a t
  rw [eval_map_Fplus, eval_map_Fplus, eval_map_pderiv0, h0, h1, h2]
  ring

theorem eval_map_Fplus_path1 (a : Fin 3 → F) (t : F) :
    eval (a + t • Pi.single (1 : Fin 3) (1 : F)) (map φ Fplus) =
      eval a (map φ Fplus) + t * eval a (pderiv 1 (map φ Fplus)) +
        t ^ 2 *
          (φ (ofLadj Fplus_re_111 Fplus_im_111) * ((3 : F) * a 1 + t) +
            φ (ofLadj Fplus_re_011 Fplus_im_011) * a 0 +
              φ (ofLadj Fplus_re_112 Fplus_im_112) * a 2) := by
  have h1 := single_shift_same (F := F) 1 a t
  have h0 := single_shift_ne (F := F) (show (0 : Fin 3) ≠ 1 by decide) a t
  have h2 := single_shift_ne (F := F) (show (2 : Fin 3) ≠ 1 by decide) a t
  rw [eval_map_Fplus, eval_map_Fplus, eval_map_pderiv1, h0, h1, h2]
  ring

theorem eval_map_Fplus_path2 (a : Fin 3 → F) (t : F) :
    eval (a + t • Pi.single (2 : Fin 3) (1 : F)) (map φ Fplus) =
      eval a (map φ Fplus) + t * eval a (pderiv 2 (map φ Fplus)) +
        t ^ 2 *
          (φ (ofLadj Fplus_re_222 Fplus_im_222) * ((3 : F) * a 2 + t) +
            φ (ofLadj Fplus_re_022 Fplus_im_022) * a 0 +
              φ (ofLadj Fplus_re_122 Fplus_im_122) * a 1) := by
  have h2 := single_shift_same (F := F) 2 a t
  have h0 := single_shift_ne (F := F) (show (0 : Fin 3) ≠ 2 by decide) a t
  have h1 := single_shift_ne (F := F) (show (1 : Fin 3) ≠ 2 by decide) a t
  rw [eval_map_Fplus, eval_map_Fplus, eval_map_pderiv2, h0, h1, h2]
  ring

/-! ### The determinantal side -/

/-- `bilinearNOn` along a composite `ψ ∘ φ` at a vector pulled back from `F`
is the `ψ`-image of `bilinearNOn φ`.  This is `bilinearNOn_map_of_base` with
the base `Ki` replaced by an arbitrary intermediate field. -/
public theorem bilinearNOn_comp_of_base {F' : Type*} [Field F']
    (ψ : F →+* F') (a0 : Fin 3 → F) :
    bilinearNOn (ψ.comp φ) (fun i => ψ (a0 i)) = (bilinearNOn φ a0).map ψ := by
  ext r j
  simp [bilinearNOn, map_sum, map_mul, Matrix.map_apply]

/-- `segrVecOn` commutes with any ring map, not only with maps out of `Ki`. -/
public theorem segrVecOn_map_of_ringHom {F' : Type*} [Field F']
    (ψ : F →+* F') (a b : Fin 3 → F) :
    segrVecOn (fun i => ψ (a i)) (fun i => ψ (b i)) =
      fun p => ψ (segrVecOn a b p) := by
  funext p
  simp [segrVecOn, map_mul]

public theorem bilinearNOn_add (a b : Fin 3 → F) :
    bilinearNOn φ (a + b) = bilinearNOn φ a + bilinearNOn φ b := by
  ext r j
  simp [bilinearNOn, Pi.add_apply, mul_add, Finset.sum_add_distrib]

public theorem eval_map_Fplus_add_smul (a d : Fin 3 → F) (t : F) :
    eval (a + t • d) (map φ Fplus) =
      det (bilinearNOn φ a + t • bilinearNOn φ d) := by
  rw [eval_map_Fplus_eq_det, bilinearNOn_add, bilinearNOn_smul]

/-! ### Rank exactly two -/

private theorem linear_coeff_of_cubic_map [Infinite F]
    (A α β γ δ : F)
    (h : ∀ t : F, A * t + (α + β * t) * t ^ 2 = (γ + δ * t) * t ^ 2) :
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
  simpa using congrArg (fun p : Polynomial F => p.coeff 1) hp

theorem eval_map_pderiv_eq_zero_of_adjugate_eq_zero [Infinite F]
    (a : Fin 3 → F) (k : Fin 3)
    (hadj : (bilinearNOn φ a).adjugate = 0)
    (hdet : (bilinearNOn φ a).det = 0) :
    eval a (pderiv k (map φ Fplus)) = 0 := by
  let B := bilinearNOn φ (Pi.single k (1 : F))
  have hexp (t : F) :
      det (bilinearNOn φ a + t • B) =
        t ^ 2 * ∑ i : Fin 3, ∑ j : Fin 3, adjugate B j i * bilinearNOn φ a i j +
          t ^ 3 * det B := by
    rw [det_add_smul_expansion, hdet, hadj]
    simp
  have hF : eval a (map φ Fplus) = 0 := (eval_map_Fplus_eq_det φ a).trans hdet
  have hf_sq (t : F) :
      eval (a + t • Pi.single k (1 : F)) (map φ Fplus) =
        t ^ 2 *
          (∑ i : Fin 3, ∑ j : Fin 3, adjugate B j i * bilinearNOn φ a i j +
            t * det B) := by
    rw [eval_map_Fplus_add_smul φ a (Pi.single k 1) t, hexp]
    ring
  fin_cases k
  · refine linear_coeff_of_cubic_map (eval a (pderiv 0 (map φ Fplus)))
      (φ (ofLadj Fplus_re_000 Fplus_im_000) * ((3 : F) * a 0) +
        φ (ofLadj Fplus_re_001 Fplus_im_001) * a 1 +
          φ (ofLadj Fplus_re_002 Fplus_im_002) * a 2)
      (φ (ofLadj Fplus_re_000 Fplus_im_000))
      (∑ i : Fin 3, ∑ j : Fin 3, adjugate B j i * bilinearNOn φ a i j) B.det ?_
    intro t
    have hL := eval_map_Fplus_path0 φ a t
    have hR := hf_sq t
    simp [hF, add_mul, mul_add] at hL hR ⊢
    linear_combination hL.symm + hR
  · refine linear_coeff_of_cubic_map (eval a (pderiv 1 (map φ Fplus)))
      (φ (ofLadj Fplus_re_111 Fplus_im_111) * ((3 : F) * a 1) +
        φ (ofLadj Fplus_re_011 Fplus_im_011) * a 0 +
          φ (ofLadj Fplus_re_112 Fplus_im_112) * a 2)
      (φ (ofLadj Fplus_re_111 Fplus_im_111))
      (∑ i : Fin 3, ∑ j : Fin 3, adjugate B j i * bilinearNOn φ a i j) B.det ?_
    intro t
    have hL := eval_map_Fplus_path1 φ a t
    have hR := hf_sq t
    simp [hF, add_mul, mul_add] at hL hR ⊢
    linear_combination hL.symm + hR
  · refine linear_coeff_of_cubic_map (eval a (pderiv 2 (map φ Fplus)))
      (φ (ofLadj Fplus_re_222 Fplus_im_222) * ((3 : F) * a 2) +
        φ (ofLadj Fplus_re_022 Fplus_im_022) * a 0 +
          φ (ofLadj Fplus_re_122 Fplus_im_122) * a 1)
      (φ (ofLadj Fplus_re_222 Fplus_im_222))
      (∑ i : Fin 3, ∑ j : Fin 3, adjugate B j i * bilinearNOn φ a i j) B.det ?_
    intro t
    have hL := eval_map_Fplus_path2 φ a t
    have hR := hf_sq t
    simp [hF, add_mul, mul_add] at hL hR ⊢
    linear_combination hL.symm + hR

theorem eval_map_pderiv_eq_zero_of_rank_le_one [Infinite F]
    (a : Fin 3 → F) (h : (bilinearNOn φ a).rank ≤ 1) (k : Fin 3) :
    eval a (pderiv k (map φ Fplus)) = 0 :=
  eval_map_pderiv_eq_zero_of_adjugate_eq_zero φ a k
    (adjugate_eq_zero_of_rank_le_one _ h)
    (det_eq_zero_of_rank_lt_card _ (lt_of_le_of_lt h (by decide)))

public theorem rank_le_two_of_map_Fplus (a : Fin 3 → F)
    (hF : eval a (map φ Fplus) = 0) :
    (bilinearNOn φ a).rank ≤ 2 :=
  rank_le_two_of_det_eq_zero _ ((eval_map_Fplus_eq_det φ a).symm.trans hF)

/-- Rank exactly two at a nonzero point of the mapped determinantal cubic,
over any field receiving `Ki`.  `smooth_detCubic_rank_eq_two` is the
`RingHom.id Ki` case. -/
public theorem smooth_detCubic_rank_eq_two_map [Infinite F]
    (a : Fin 3 → F) (ha : a ≠ 0)
    (hF : eval a (map φ Fplus) = 0) :
    (bilinearNOn φ a).rank = 2 := by
  have hle : (bilinearNOn φ a).rank ≤ 2 := rank_le_two_of_map_Fplus φ a hF
  refine le_antisymm hle ?_
  by_contra hlt
  have hle1 : (bilinearNOn φ a).rank ≤ 1 := Nat.lt_succ_iff.mp (lt_of_not_ge hlt)
  obtain ⟨i, hi⟩ := (Fplus_isSmoothPlaneCubic_map φ).2 a ha hF
  exact hi (eval_map_pderiv_eq_zero_of_rank_le_one φ a hle1 i)

end V14Formalization.D12SigmaPlusSegreCore
