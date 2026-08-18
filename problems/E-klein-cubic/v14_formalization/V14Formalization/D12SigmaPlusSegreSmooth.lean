/-
Copyright (c) 2026 V14Formalization contributors.
Released under Apache 2.0 license.
-/
module

public import V14Formalization.D12SigmaPlusSegreSmoothAsm
public import V14Formalization.D12SigmaPlusSegreSmoothPartial
public import V14Formalization.D12SigmaPlusSegreHomogeneous
public import V14Formalization.D12PolyZReflection
public import V14Formalization.D12SigmaPlusSegreFplusZ
public import Mathlib.Algebra.MvPolynomial.Funext
public import Mathlib.Algebra.MvPolynomial.PDeriv
public import Mathlib.Algebra.CharZero.Infinite

noncomputable section

open MvPolynomial
open V14Formalization.D12PolyZReflection

namespace V14Formalization.D12SigmaPlusSegreCore

theorem ofLadj_smul_rat (n : ℚ) (a b : Polynomial ℚ) :
    ofLadj (Polynomial.C n) 0 * ofLadj a b =
      ofLadj (Polynomial.C n * a) (Polynomial.C n * b) := by
  rw [ofLadj_mul]
  simp

private theorem poly_scale {p q : Polynomial ℚ} (h : ∀ r : ℚ, p.eval r = q.eval r) :
    p = q :=
  Polynomial.funext h

theorem Fplus_dU_c_200_eq :
    Fplus_dU_c_200 = (3 : Ki) * ofLadj Fplus_re_000 Fplus_im_000 := by
  rw [Fplus_dU_c_200_def, ← ofLadj_three, ofLadj_smul_rat]
  congr 1
  · refine poly_scale fun r => ?_
    simp [Fplus_dU_re_200_def, Fplus_re_000, interpQ, toPolyZ]
    ring
  · refine poly_scale fun r => ?_
    simp [Fplus_dU_im_200_def, Fplus_im_000, interpQ, toPolyZ]
    ring

theorem Fplus_dU_c_110_eq :
    Fplus_dU_c_110 = (2 : Ki) * ofLadj Fplus_re_001 Fplus_im_001 := by
  rw [Fplus_dU_c_110_def, ← ofLadj_two, ofLadj_smul_rat]
  congr 1
  · refine poly_scale fun r => ?_
    simp [Fplus_dU_re_110_def, Fplus_re_001, interpQ, toPolyZ]
    ring
  · refine poly_scale fun r => ?_
    simp [Fplus_dU_im_110_def, Fplus_im_001, interpQ, toPolyZ]
    ring

theorem Fplus_dU_c_101_eq :
    Fplus_dU_c_101 = (2 : Ki) * ofLadj Fplus_re_002 Fplus_im_002 := by
  rw [Fplus_dU_c_101_def, ← ofLadj_two, ofLadj_smul_rat]
  congr 1
  · refine poly_scale fun r => ?_
    simp [Fplus_dU_re_101_def, Fplus_re_002, interpQ, toPolyZ]
    ring
  · refine poly_scale fun r => ?_
    simp [Fplus_dU_im_101_def, Fplus_im_002, interpQ, toPolyZ]
    ring

theorem Fplus_dU_c_020_eq :
    Fplus_dU_c_020 = ofLadj Fplus_re_011 Fplus_im_011 := by
  rw [Fplus_dU_c_020_def, Fplus_dU_re_020_def, Fplus_dU_im_020_def,
    z_Fplus_re_011, z_Fplus_im_011]

theorem Fplus_dU_c_011_eq :
    Fplus_dU_c_011 = ofLadj Fplus_re_012 Fplus_im_012 := by
  rw [Fplus_dU_c_011_def, Fplus_dU_re_011_def, Fplus_dU_im_011_def,
    z_Fplus_re_012, z_Fplus_im_012]

theorem Fplus_dU_c_002_eq :
    Fplus_dU_c_002 = ofLadj Fplus_re_022 Fplus_im_022 := by
  rw [Fplus_dU_c_002_def, Fplus_dU_re_002_def, Fplus_dU_im_002_def,
    z_Fplus_re_022, z_Fplus_im_022]

public theorem eval_pderiv0 (a : Fin 3 → Ki) :
    eval a (pderiv 0 Fplus) =
      (3 : Ki) * ofLadj Fplus_re_000 Fplus_im_000 * a 0 ^ 2 +
        (2 : Ki) * ofLadj Fplus_re_001 Fplus_im_001 * (a 0 * a 1) +
          (2 : Ki) * ofLadj Fplus_re_002 Fplus_im_002 * (a 0 * a 2) +
            ofLadj Fplus_re_011 Fplus_im_011 * a 1 ^ 2 +
              ofLadj Fplus_re_012 Fplus_im_012 * (a 1 * a 2) +
                ofLadj Fplus_re_022 Fplus_im_022 * a 2 ^ 2 := by
  unfold Fplus
  simp [map_add, pderiv_C_mul, pderiv_mul, pderiv_X, pderiv_C, pderiv_pow,
    eval_add, eval_mul, eval_C, eval_X, eval_pow]
  ring

theorem eval_pderiv0_eq_dU (a : Fin 3 → Ki) :
    eval a (pderiv 0 Fplus) = eval a Fplus_dU := by
  rw [eval_pderiv0, eval_Fplus_dU, Fplus_dU_c_200_eq, Fplus_dU_c_110_eq,
    Fplus_dU_c_101_eq, Fplus_dU_c_020_eq, Fplus_dU_c_011_eq, Fplus_dU_c_002_eq]
  ring

public instance : CharZero Ki where
  cast_injective := by
    intro m n hmn
    have hK : ((m : GeometricV14Carrier.k) : Ki) = (n : GeometricV14Carrier.k) := by
      simpa using hmn
    have := (algebraMap GeometricV14Carrier.k Ki).injective hK
    exact Nat.cast_injective this

public instance : Infinite Ki := CharZero.infinite (M := Ki)

theorem pderiv_zero_Fplus : pderiv 0 Fplus = Fplus_dU :=
  MvPolynomial.funext eval_pderiv0_eq_dU

-- V and W partials, used for the other charts.
public theorem eval_pderiv1 (a : Fin 3 → Ki) :
    eval a (pderiv 1 Fplus) =
      ofLadj Fplus_re_001 Fplus_im_001 * a 0 ^ 2 +
        (2 : Ki) * ofLadj Fplus_re_011 Fplus_im_011 * (a 0 * a 1) +
          ofLadj Fplus_re_012 Fplus_im_012 * (a 0 * a 2) +
            (3 : Ki) * ofLadj Fplus_re_111 Fplus_im_111 * a 1 ^ 2 +
              (2 : Ki) * ofLadj Fplus_re_112 Fplus_im_112 * (a 1 * a 2) +
                ofLadj Fplus_re_122 Fplus_im_122 * a 2 ^ 2 := by
  unfold Fplus
  simp [map_add, pderiv_C_mul, pderiv_mul, pderiv_X, pderiv_C, pderiv_pow,
    eval_add, eval_mul, eval_C, eval_X, eval_pow]
  ring

public theorem eval_pderiv2 (a : Fin 3 → Ki) :
    eval a (pderiv 2 Fplus) =
      ofLadj Fplus_re_002 Fplus_im_002 * a 0 ^ 2 +
        ofLadj Fplus_re_012 Fplus_im_012 * (a 0 * a 1) +
          (2 : Ki) * ofLadj Fplus_re_022 Fplus_im_022 * (a 0 * a 2) +
            ofLadj Fplus_re_112 Fplus_im_112 * a 1 ^ 2 +
              (2 : Ki) * ofLadj Fplus_re_122 Fplus_im_122 * (a 1 * a 2) +
                (3 : Ki) * ofLadj Fplus_re_222 Fplus_im_222 * a 2 ^ 2 := by
  unfold Fplus
  simp [map_add, pderiv_C_mul, pderiv_mul, pderiv_X, pderiv_C, pderiv_pow,
    eval_add, eval_mul, eval_C, eval_X, eval_pow]
  ring

theorem Fplus_dV_c_200_eq :
    Fplus_dV_c_200 = ofLadj Fplus_re_001 Fplus_im_001 := by
  rw [Fplus_dV_c_200_def, Fplus_dV_re_200_def, Fplus_dV_im_200_def,
    z_Fplus_re_001, z_Fplus_im_001]

theorem Fplus_dV_c_110_eq :
    Fplus_dV_c_110 = (2 : Ki) * ofLadj Fplus_re_011 Fplus_im_011 := by
  rw [Fplus_dV_c_110_def, ← ofLadj_two, ofLadj_smul_rat]
  congr 1 <;> (refine poly_scale fun r => ?_; simp [Fplus_dV_re_110_def, Fplus_dV_im_110_def,
    Fplus_re_011, Fplus_im_011, interpQ, toPolyZ]; try ring)

theorem Fplus_dV_c_101_eq :
    Fplus_dV_c_101 = ofLadj Fplus_re_012 Fplus_im_012 := by
  rw [Fplus_dV_c_101_def, Fplus_dV_re_101_def, Fplus_dV_im_101_def,
    z_Fplus_re_012, z_Fplus_im_012]

theorem Fplus_dV_c_020_eq :
    Fplus_dV_c_020 = (3 : Ki) * ofLadj Fplus_re_111 Fplus_im_111 := by
  rw [Fplus_dV_c_020_def, ← ofLadj_three, ofLadj_smul_rat]
  congr 1 <;> (refine poly_scale fun r => ?_; simp [Fplus_dV_re_020_def, Fplus_dV_im_020_def,
    Fplus_re_111, Fplus_im_111, interpQ, toPolyZ]; try ring)

theorem Fplus_dV_c_011_eq :
    Fplus_dV_c_011 = (2 : Ki) * ofLadj Fplus_re_112 Fplus_im_112 := by
  rw [Fplus_dV_c_011_def, ← ofLadj_two, ofLadj_smul_rat]
  congr 1 <;> (refine poly_scale fun r => ?_; simp [Fplus_dV_re_011_def, Fplus_dV_im_011_def,
    Fplus_re_112, Fplus_im_112, interpQ, toPolyZ]; try ring)

theorem Fplus_dV_c_002_eq :
    Fplus_dV_c_002 = ofLadj Fplus_re_122 Fplus_im_122 := by
  rw [Fplus_dV_c_002_def, Fplus_dV_re_002_def, Fplus_dV_im_002_def,
    z_Fplus_re_122, z_Fplus_im_122]

theorem eval_pderiv1_eq_dV (a : Fin 3 → Ki) :
    eval a (pderiv 1 Fplus) = eval a Fplus_dV := by
  rw [eval_pderiv1, eval_Fplus_dV, Fplus_dV_c_200_eq, Fplus_dV_c_110_eq,
    Fplus_dV_c_101_eq, Fplus_dV_c_020_eq, Fplus_dV_c_011_eq, Fplus_dV_c_002_eq]
  ring

theorem pderiv_one_Fplus : pderiv 1 Fplus = Fplus_dV :=
  MvPolynomial.funext eval_pderiv1_eq_dV

theorem Fplus_dW_c_200_eq :
    Fplus_dW_c_200 = ofLadj Fplus_re_002 Fplus_im_002 := by
  rw [Fplus_dW_c_200_def, Fplus_dW_re_200_def, Fplus_dW_im_200_def,
    z_Fplus_re_002, z_Fplus_im_002]

theorem Fplus_dW_c_110_eq :
    Fplus_dW_c_110 = ofLadj Fplus_re_012 Fplus_im_012 := by
  rw [Fplus_dW_c_110_def, Fplus_dW_re_110_def, Fplus_dW_im_110_def,
    z_Fplus_re_012, z_Fplus_im_012]

theorem Fplus_dW_c_101_eq :
    Fplus_dW_c_101 = (2 : Ki) * ofLadj Fplus_re_022 Fplus_im_022 := by
  rw [Fplus_dW_c_101_def, ← ofLadj_two, ofLadj_smul_rat]
  congr 1 <;> (refine poly_scale fun r => ?_; simp [Fplus_dW_re_101_def, Fplus_dW_im_101_def,
    Fplus_re_022, Fplus_im_022, interpQ, toPolyZ]; try ring)

theorem Fplus_dW_c_020_eq :
    Fplus_dW_c_020 = ofLadj Fplus_re_112 Fplus_im_112 := by
  rw [Fplus_dW_c_020_def, Fplus_dW_re_020_def, Fplus_dW_im_020_def,
    z_Fplus_re_112, z_Fplus_im_112]

theorem Fplus_dW_c_011_eq :
    Fplus_dW_c_011 = (2 : Ki) * ofLadj Fplus_re_122 Fplus_im_122 := by
  rw [Fplus_dW_c_011_def, ← ofLadj_two, ofLadj_smul_rat]
  congr 1 <;> (refine poly_scale fun r => ?_; simp [Fplus_dW_re_011_def, Fplus_dW_im_011_def,
    Fplus_re_122, Fplus_im_122, interpQ, toPolyZ]; try ring)

theorem Fplus_dW_c_002_eq :
    Fplus_dW_c_002 = (3 : Ki) * ofLadj Fplus_re_222 Fplus_im_222 := by
  rw [Fplus_dW_c_002_def, ← ofLadj_three, ofLadj_smul_rat]
  congr 1 <;> (refine poly_scale fun r => ?_; simp [Fplus_dW_re_002_def, Fplus_dW_im_002_def,
    Fplus_re_222, Fplus_im_222, interpQ, toPolyZ]; try ring)

theorem eval_pderiv2_eq_dW (a : Fin 3 → Ki) :
    eval a (pderiv 2 Fplus) = eval a Fplus_dW := by
  rw [eval_pderiv2, eval_Fplus_dW, Fplus_dW_c_200_eq, Fplus_dW_c_110_eq,
    Fplus_dW_c_101_eq, Fplus_dW_c_020_eq, Fplus_dW_c_011_eq, Fplus_dW_c_002_eq]
  ring

theorem pderiv_two_Fplus : pderiv 2 Fplus = Fplus_dW :=
  MvPolynomial.funext eval_pderiv2_eq_dW

theorem CU_poly_identity :
    CU_0 * Fplus_dU + CU_1 * Fplus_dV + CU_2 * Fplus_dW +
      CU_3 * (X 0 - 1) = 1 := by
  refine MvPolynomial.funext fun a => ?_
  simp [eval_mul, eval_add, eval_sub, eval_X]
  exact CU_eval_identity a

theorem CV_poly_identity :
    CV_0 * Fplus_dU + CV_1 * Fplus_dV + CV_2 * Fplus_dW +
      CV_3 * (X 1 - 1) = 1 := by
  refine MvPolynomial.funext fun a => ?_
  simp [eval_mul, eval_add, eval_sub, eval_X]
  exact CV_eval_identity a

theorem CW_poly_identity :
    CW_0 * Fplus_dU + CW_1 * Fplus_dV + CW_2 * Fplus_dW +
      CW_3 * (X 2 - 1) = 1 := by
  refine MvPolynomial.funext fun a => ?_
  simp [eval_mul, eval_add, eval_sub, eval_X]
  exact CW_eval_identity a

theorem chartU_nonsingular (a : Fin 3 → Ki) (h1 : a 0 = 1)
    (hF : eval a Fplus = 0)
    (h0 : eval a (pderiv 0 Fplus) = 0)
    (h1p : eval a (pderiv 1 Fplus) = 0)
    (h2 : eval a (pderiv 2 Fplus) = 0) : False := by
  have := CU_eval_identity a
  rw [pderiv_zero_Fplus] at h0
  rw [pderiv_one_Fplus] at h1p
  rw [pderiv_two_Fplus] at h2
  simp [h0, h1p, h2, h1] at this

theorem chartV_nonsingular (a : Fin 3 → Ki) (h1 : a 1 = 1)
    (h0 : eval a (pderiv 0 Fplus) = 0)
    (h1p : eval a (pderiv 1 Fplus) = 0)
    (h2 : eval a (pderiv 2 Fplus) = 0) : False := by
  have := CV_eval_identity a
  rw [pderiv_zero_Fplus] at h0
  rw [pderiv_one_Fplus] at h1p
  rw [pderiv_two_Fplus] at h2
  simp [h0, h1p, h2, h1] at this

theorem chartW_nonsingular (a : Fin 3 → Ki) (h1 : a 2 = 1)
    (h0 : eval a (pderiv 0 Fplus) = 0)
    (h1p : eval a (pderiv 1 Fplus) = 0)
    (h2 : eval a (pderiv 2 Fplus) = 0) : False := by
  have := CW_eval_identity a
  rw [pderiv_zero_Fplus] at h0
  rw [pderiv_one_Fplus] at h1p
  rw [pderiv_two_Fplus] at h2
  simp [h0, h1p, h2, h1] at this

theorem eval_Fplus_smul (s : Ki) (a : Fin 3 → Ki) :
    eval (fun i => s * a i) Fplus = s ^ 3 * eval a Fplus := by
  rw [eval_Fplus_explicit, eval_Fplus_explicit]
  ring

theorem eval_pderiv0_smul (s : Ki) (a : Fin 3 → Ki) :
    eval (fun j => s * a j) (pderiv 0 Fplus) =
      s ^ 2 * eval a (pderiv 0 Fplus) := by
  rw [eval_pderiv0, eval_pderiv0]
  ring

theorem eval_pderiv1_smul (s : Ki) (a : Fin 3 → Ki) :
    eval (fun j => s * a j) (pderiv 1 Fplus) =
      s ^ 2 * eval a (pderiv 1 Fplus) := by
  rw [eval_pderiv1, eval_pderiv1]
  ring

theorem eval_pderiv2_smul (s : Ki) (a : Fin 3 → Ki) :
    eval (fun j => s * a j) (pderiv 2 Fplus) =
      s ^ 2 * eval a (pderiv 2 Fplus) := by
  rw [eval_pderiv2, eval_pderiv2]
  ring

/-- Same proposition as `Standard.IsSmoothPlaneCubic Fplus`. -/
public theorem Fplus_isSmoothPlaneCubic :
    Fplus.IsHomogeneous 3 ∧
      ∀ r : Fin 3 → Ki, r ≠ 0 → eval r Fplus = 0 →
        ∃ i : Fin 3, eval r (pderiv i Fplus) ≠ 0 := by
  refine ⟨Fplus_isHomogeneous, ?_⟩
  intro r hr hF
  by_contra hnone
  push_neg at hnone
  have h0 := hnone 0
  have h1 := hnone 1
  have h2 := hnone 2
  obtain ⟨i, hi⟩ : ∃ i, r i ≠ 0 := by
    by_contra h
    push_neg at h
    exact hr (funext h)
  let s := r i
  have hs : s ≠ 0 := hi
  let a : Fin 3 → Ki := fun j => s⁻¹ * r j
  have ha : a i = 1 := by
    simp [a, s, inv_mul_cancel₀ hs]
  have hFa : eval a Fplus = 0 := by
    have := eval_Fplus_smul s a
    have hsa : (fun j => s * a j) = r := by
      funext j
      simp [a, s, mul_inv_cancel_left₀ hs]
    rw [hsa] at this
    have hs3 : s ^ 3 ≠ 0 := pow_ne_zero 3 hs
    exact (mul_eq_zero.mp ((this.symm.trans hF))).resolve_left hs3
  have hp0 : eval a (pderiv 0 Fplus) = 0 := by
    have := eval_pderiv0_smul s a
    have hsa : (fun j => s * a j) = r := by
      funext j
      simp [a, s, mul_inv_cancel_left₀ hs]
    rw [hsa] at this
    have hs2 : s ^ 2 ≠ 0 := pow_ne_zero 2 hs
    exact (mul_eq_zero.mp ((this.symm.trans h0))).resolve_left hs2
  have hp1 : eval a (pderiv 1 Fplus) = 0 := by
    have := eval_pderiv1_smul s a
    have hsa : (fun j => s * a j) = r := by
      funext j
      simp [a, s, mul_inv_cancel_left₀ hs]
    rw [hsa] at this
    have hs2 : s ^ 2 ≠ 0 := pow_ne_zero 2 hs
    exact (mul_eq_zero.mp ((this.symm.trans h1))).resolve_left hs2
  have hp2 : eval a (pderiv 2 Fplus) = 0 := by
    have := eval_pderiv2_smul s a
    have hsa : (fun j => s * a j) = r := by
      funext j
      simp [a, s, mul_inv_cancel_left₀ hs]
    rw [hsa] at this
    have hs2 : s ^ 2 ≠ 0 := pow_ne_zero 2 hs
    exact (mul_eq_zero.mp ((this.symm.trans h2))).resolve_left hs2
  fin_cases i
  · exact chartU_nonsingular a ha hFa hp0 hp1 hp2
  · exact chartV_nonsingular a ha hp0 hp1 hp2
  · exact chartW_nonsingular a ha hp0 hp1 hp2

theorem eval_map_CU_identity {L : Type*} [CommRing L] (f : Ki →+* L)
    (a : Fin 3 → L) :
    eval a (map f CU_0) * eval a (map f Fplus_dU) +
        eval a (map f CU_1) * eval a (map f Fplus_dV) +
          eval a (map f CU_2) * eval a (map f Fplus_dW) +
            eval a (map f CU_3) * (a 0 - 1) = 1 := by
  simpa [eval_add, eval_mul, eval_sub, eval_X, eval_map, map_add,
    map_mul, map_sub, map_one] using
    congrArg (eval a) (congrArg (map f) CU_poly_identity)

theorem eval_map_CV_identity {L : Type*} [CommRing L] (f : Ki →+* L)
    (a : Fin 3 → L) :
    eval a (map f CV_0) * eval a (map f Fplus_dU) +
        eval a (map f CV_1) * eval a (map f Fplus_dV) +
          eval a (map f CV_2) * eval a (map f Fplus_dW) +
            eval a (map f CV_3) * (a 1 - 1) = 1 := by
  simpa [eval_add, eval_mul, eval_sub, eval_X, eval_map, map_add,
    map_mul, map_sub, map_one] using
    congrArg (eval a) (congrArg (map f) CV_poly_identity)

theorem eval_map_CW_identity {L : Type*} [CommRing L] (f : Ki →+* L)
    (a : Fin 3 → L) :
    eval a (map f CW_0) * eval a (map f Fplus_dU) +
        eval a (map f CW_1) * eval a (map f Fplus_dV) +
          eval a (map f CW_2) * eval a (map f Fplus_dW) +
            eval a (map f CW_3) * (a 2 - 1) = 1 := by
  simpa [eval_add, eval_mul, eval_sub, eval_X, eval_map, map_add,
    map_mul, map_sub, map_one] using
    congrArg (eval a) (congrArg (map f) CW_poly_identity)

/-- Smoothness after any coefficient homomorphism, by evaluating the
mapped Nullstellensatz identities. -/
public theorem Fplus_isSmoothPlaneCubic_map {L : Type*} [Field L] [Infinite L]
    (f : Ki →+* L) :
    (map f Fplus).IsHomogeneous 3 ∧
      ∀ r : Fin 3 → L, r ≠ 0 → eval r (map f Fplus) = 0 →
        ∃ i : Fin 3, eval r (pderiv i (map f Fplus)) ≠ 0 := by
  refine ⟨Fplus_isHomogeneous.map _, ?_⟩
  intro r hr hF
  by_contra hnone
  push_neg at hnone
  obtain ⟨i, hi⟩ : ∃ i, r i ≠ 0 := by
    by_contra h
    push_neg at h
    exact hr (funext h)
  have hpU : pderiv 0 (map f Fplus) = map f Fplus_dU := by
    rw [pderiv_map, pderiv_zero_Fplus]
  have hpV : pderiv 1 (map f Fplus) = map f Fplus_dV := by
    rw [pderiv_map, pderiv_one_Fplus]
  have hpW : pderiv 2 (map f Fplus) = map f Fplus_dW := by
    rw [pderiv_map, pderiv_two_Fplus]
  fin_cases i
  · have := eval_map_CU_identity f r
    have hr0 : r 0 ≠ 0 := hi
    -- specialize the identity after scaling so the first coordinate is 1
    let a : Fin 3 → L := fun j => (r 0)⁻¹ * r j
    have ha0 : a 0 = 1 := by simp [a, inv_mul_cancel₀ hr0]
    have hsa : (fun j => r 0 * a j) = r := by
      funext j; simp [a, mul_inv_cancel_left₀ hr0]
    have hUe := eval_map_CU_identity f a
    have h0 : eval a (map f Fplus_dU) = 0 := by
      have hsmul :
          eval (fun j => r 0 * a j) (map f Fplus_dU) =
            (r 0) ^ 2 * eval a (map f Fplus_dU) := by
        simp [Fplus_dU_def, map_add, map_mul, eval_add, eval_mul, eval_C, eval_X,
          eval_pow]
        ring
      rw [hsa] at hsmul
      have := hnone 0
      rw [hpU] at this
      have hs2 : (r 0) ^ 2 ≠ 0 := pow_ne_zero 2 hr0
      exact (mul_eq_zero.mp (hsmul.symm.trans this)).resolve_left hs2
    have h1 : eval a (map f Fplus_dV) = 0 := by
      have hsmul :
          eval (fun j => r 0 * a j) (map f Fplus_dV) =
            (r 0) ^ 2 * eval a (map f Fplus_dV) := by
        simp [Fplus_dV_def, map_add, map_mul, eval_add, eval_mul, eval_C, eval_X,
          eval_pow]
        ring
      rw [hsa] at hsmul
      have this := hnone 1
      rw [hpV] at this
      have hs2 : (r 0) ^ 2 ≠ 0 := pow_ne_zero 2 hr0
      exact (mul_eq_zero.mp (hsmul.symm.trans this)).resolve_left hs2
    have h2 : eval a (map f Fplus_dW) = 0 := by
      have hsmul :
          eval (fun j => r 0 * a j) (map f Fplus_dW) =
            (r 0) ^ 2 * eval a (map f Fplus_dW) := by
        simp [Fplus_dW_def, map_add, map_mul, eval_add, eval_mul, eval_C, eval_X,
          eval_pow]
        ring
      rw [hsa] at hsmul
      have this := hnone 2
      rw [hpW] at this
      have hs2 : (r 0) ^ 2 ≠ 0 := pow_ne_zero 2 hr0
      exact (mul_eq_zero.mp (hsmul.symm.trans this)).resolve_left hs2
    simp [h0, h1, h2, ha0] at hUe
  · have hr1 : r 1 ≠ 0 := hi
    let a : Fin 3 → L := fun j => (r 1)⁻¹ * r j
    have ha1 : a 1 = 1 := by simp [a, inv_mul_cancel₀ hr1]
    have hsa : (fun j => r 1 * a j) = r := by
      funext j; simp [a, mul_inv_cancel_left₀ hr1]
    have hVe := eval_map_CV_identity f a
    have h0 : eval a (map f Fplus_dU) = 0 := by
      have hsmul :
          eval (fun j => r 1 * a j) (map f Fplus_dU) =
            (r 1) ^ 2 * eval a (map f Fplus_dU) := by
        simp [Fplus_dU_def, map_add, map_mul, eval_add, eval_mul, eval_C, eval_X,
          eval_pow]; ring
      rw [hsa] at hsmul
      have this := hnone 0
      rw [hpU] at this
      exact (mul_eq_zero.mp (hsmul.symm.trans this)).resolve_left
        (pow_ne_zero 2 hr1)
    have h1 : eval a (map f Fplus_dV) = 0 := by
      have hsmul :
          eval (fun j => r 1 * a j) (map f Fplus_dV) =
            (r 1) ^ 2 * eval a (map f Fplus_dV) := by
        simp [Fplus_dV_def, map_add, map_mul, eval_add, eval_mul, eval_C, eval_X,
          eval_pow]; ring
      rw [hsa] at hsmul
      have this := hnone 1
      rw [hpV] at this
      exact (mul_eq_zero.mp (hsmul.symm.trans this)).resolve_left
        (pow_ne_zero 2 hr1)
    have h2 : eval a (map f Fplus_dW) = 0 := by
      have hsmul :
          eval (fun j => r 1 * a j) (map f Fplus_dW) =
            (r 1) ^ 2 * eval a (map f Fplus_dW) := by
        simp [Fplus_dW_def, map_add, map_mul, eval_add, eval_mul, eval_C, eval_X,
          eval_pow]; ring
      rw [hsa] at hsmul
      have this := hnone 2
      rw [hpW] at this
      exact (mul_eq_zero.mp (hsmul.symm.trans this)).resolve_left
        (pow_ne_zero 2 hr1)
    simp [h0, h1, h2, ha1] at hVe
  · have hr2 : r 2 ≠ 0 := hi
    let a : Fin 3 → L := fun j => (r 2)⁻¹ * r j
    have ha2 : a 2 = 1 := by simp [a, inv_mul_cancel₀ hr2]
    have hsa : (fun j => r 2 * a j) = r := by
      funext j; simp [a, mul_inv_cancel_left₀ hr2]
    have hWe := eval_map_CW_identity f a
    have h0 : eval a (map f Fplus_dU) = 0 := by
      have hsmul :
          eval (fun j => r 2 * a j) (map f Fplus_dU) =
            (r 2) ^ 2 * eval a (map f Fplus_dU) := by
        simp [Fplus_dU_def, map_add, map_mul, eval_add, eval_mul, eval_C, eval_X,
          eval_pow]; ring
      rw [hsa] at hsmul
      have this := hnone 0
      rw [hpU] at this
      exact (mul_eq_zero.mp (hsmul.symm.trans this)).resolve_left
        (pow_ne_zero 2 hr2)
    have h1 : eval a (map f Fplus_dV) = 0 := by
      have hsmul :
          eval (fun j => r 2 * a j) (map f Fplus_dV) =
            (r 2) ^ 2 * eval a (map f Fplus_dV) := by
        simp [Fplus_dV_def, map_add, map_mul, eval_add, eval_mul, eval_C, eval_X,
          eval_pow]; ring
      rw [hsa] at hsmul
      have this := hnone 1
      rw [hpV] at this
      exact (mul_eq_zero.mp (hsmul.symm.trans this)).resolve_left
        (pow_ne_zero 2 hr2)
    have h2 : eval a (map f Fplus_dW) = 0 := by
      have hsmul :
          eval (fun j => r 2 * a j) (map f Fplus_dW) =
            (r 2) ^ 2 * eval a (map f Fplus_dW) := by
        simp [Fplus_dW_def, map_add, map_mul, eval_add, eval_mul, eval_C, eval_X,
          eval_pow]; ring
      rw [hsa] at hsmul
      have this := hnone 2
      rw [hpW] at this
      exact (mul_eq_zero.mp (hsmul.symm.trans this)).resolve_left
        (pow_ne_zero 2 hr2)
    simp [h0, h1, h2, ha2] at hWe

end V14Formalization.D12SigmaPlusSegreCore
