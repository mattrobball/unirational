/-
Copyright (c) 2026 V14Formalization contributors.
Released under Apache 2.0 license.
-/
import V14Formalization.D12SigmaPlusSegreGeom
import V14Formalization.D12SigmaPlusSegreApplyN
import V14Formalization.D12SigmaPlusSegreDet000
import V14Formalization.D12SigmaPlusSegreDet001
import V14Formalization.D12SigmaPlusSegreDet002
import V14Formalization.D12SigmaPlusSegreDet011
import V14Formalization.D12SigmaPlusSegreDet012
import V14Formalization.D12SigmaPlusSegreDet022
import V14Formalization.D12SigmaPlusSegreDet111
import V14Formalization.D12SigmaPlusSegreDet112
import V14Formalization.D12SigmaPlusSegreDet122
import V14Formalization.D12SigmaPlusSegreDet222

noncomputable section

open Matrix MvPolynomial

namespace V14Formalization.D12SigmaPlusSegreCore

open V14Formalization.D12SigmaPlusQuadric6

theorem N_entry_0_6_eq_one : N_entry_0_6 = 1 := by
  rw [N_entry_0_6, N_re_0_6, N_im_0_6]
  simpa using ofLadj_one

theorem N_entry_1_7_eq_one : N_entry_1_7 = 1 := by
  rw [N_entry_1_7, N_re_1_7, N_im_1_7]
  simpa using ofLadj_one

theorem N_entry_2_8_eq_one : N_entry_2_8 = 1 := by
  rw [N_entry_2_8, N_re_2_8, N_im_2_8]
  simpa using ofLadj_one

theorem N_entry_0_7_eq_zero : N_entry_0_7 = 0 := by
  rw [N_entry_0_7, N_re_0_7, N_im_0_7]
  exact ofLadj_zero

theorem N_entry_0_8_eq_zero : N_entry_0_8 = 0 := by
  rw [N_entry_0_8, N_re_0_8, N_im_0_8]
  exact ofLadj_zero

theorem N_entry_1_6_eq_zero : N_entry_1_6 = 0 := by
  rw [N_entry_1_6, N_re_1_6, N_im_1_6]
  exact ofLadj_zero

theorem N_entry_1_8_eq_zero : N_entry_1_8 = 0 := by
  rw [N_entry_1_8, N_re_1_8, N_im_1_8]
  exact ofLadj_zero

theorem N_entry_2_6_eq_zero : N_entry_2_6 = 0 := by
  rw [N_entry_2_6, N_re_2_6, N_im_2_6]
  exact ofLadj_zero

theorem N_entry_2_7_eq_zero : N_entry_2_7 = 0 := by
  rw [N_entry_2_7, N_re_2_7, N_im_2_7]
  exact ofLadj_zero

theorem bilinearN_sum (a : Fin 3 → Ki) (r j : Fin 3) :
    bilinearN a r j =
      N r (crossIndex 0 j) * a 0 +
        N r (crossIndex 1 j) * a 1 +
          N r (crossIndex 2 j) * a 2 := by
  simp [bilinearN, Fin.sum_univ_succ, add_assoc]

theorem bilinearN_00 (a : Fin 3 → Ki) :
    bilinearN a 0 0 = N_entry_0_0 * a 0 + N_entry_0_3 * a 1 + a 2 := by
  rw [bilinearN_sum]
  simp [crossIndex, N_apply_0_0, N_apply_0_3, N_apply_0_6, N_entry_0_6_eq_one]

theorem bilinearN_01 (a : Fin 3 → Ki) :
    bilinearN a 0 1 = N_entry_0_1 * a 0 + N_entry_0_4 * a 1 := by
  rw [bilinearN_sum]
  simp [crossIndex, N_apply_0_1, N_apply_0_4, N_apply_0_7, N_entry_0_7_eq_zero]

theorem bilinearN_02 (a : Fin 3 → Ki) :
    bilinearN a 0 2 = N_entry_0_2 * a 0 + N_entry_0_5 * a 1 := by
  rw [bilinearN_sum]
  simp [crossIndex, N_apply_0_2, N_apply_0_5, N_apply_0_8, N_entry_0_8_eq_zero]

theorem bilinearN_10 (a : Fin 3 → Ki) :
    bilinearN a 1 0 = N_entry_1_0 * a 0 + N_entry_1_3 * a 1 := by
  rw [bilinearN_sum]
  simp [crossIndex, N_apply_1_0, N_apply_1_3, N_apply_1_6, N_entry_1_6_eq_zero]

theorem bilinearN_11 (a : Fin 3 → Ki) :
    bilinearN a 1 1 = N_entry_1_1 * a 0 + N_entry_1_4 * a 1 + a 2 := by
  rw [bilinearN_sum]
  simp [crossIndex, N_apply_1_1, N_apply_1_4, N_apply_1_7, N_entry_1_7_eq_one]

theorem bilinearN_12 (a : Fin 3 → Ki) :
    bilinearN a 1 2 = N_entry_1_2 * a 0 + N_entry_1_5 * a 1 := by
  rw [bilinearN_sum]
  simp [crossIndex, N_apply_1_2, N_apply_1_5, N_apply_1_8, N_entry_1_8_eq_zero]

theorem bilinearN_20 (a : Fin 3 → Ki) :
    bilinearN a 2 0 = N_entry_2_0 * a 0 + N_entry_2_3 * a 1 := by
  rw [bilinearN_sum]
  simp [crossIndex, N_apply_2_0, N_apply_2_3, N_apply_2_6, N_entry_2_6_eq_zero]

theorem bilinearN_21 (a : Fin 3 → Ki) :
    bilinearN a 2 1 = N_entry_2_1 * a 0 + N_entry_2_4 * a 1 := by
  rw [bilinearN_sum]
  simp [crossIndex, N_apply_2_1, N_apply_2_4, N_apply_2_7, N_entry_2_7_eq_zero]

theorem bilinearN_22 (a : Fin 3 → Ki) :
    bilinearN a 2 2 = N_entry_2_2 * a 0 + N_entry_2_5 * a 1 + a 2 := by
  rw [bilinearN_sum]
  simp [crossIndex, N_apply_2_2, N_apply_2_5, N_apply_2_8, N_entry_2_8_eq_one]

theorem det_bilinearN_collect (a : Fin 3 → Ki) :
    Matrix.det (bilinearN a) =
      detCoeff_000 * a 0 ^ 3 +
        detCoeff_001 * (a 0 ^ 2 * a 1) +
          detCoeff_002 * (a 0 ^ 2 * a 2) +
            detCoeff_011 * (a 0 * a 1 ^ 2) +
              detCoeff_012 * (a 0 * a 1 * a 2) +
                detCoeff_022 * (a 0 * a 2 ^ 2) +
                  detCoeff_111 * a 1 ^ 3 +
                    detCoeff_112 * (a 1 ^ 2 * a 2) +
                      detCoeff_122 * (a 1 * a 2 ^ 2) +
                        detCoeff_222 * a 2 ^ 3 := by
  rw [Matrix.det_fin_three, bilinearN_00, bilinearN_01, bilinearN_02,
    bilinearN_10, bilinearN_11, bilinearN_12, bilinearN_20, bilinearN_21,
    bilinearN_22]
  unfold detCoeff_000 detCoeff_001 detCoeff_002 detCoeff_011 detCoeff_012
    detCoeff_022 detCoeff_111 detCoeff_112 detCoeff_122 detCoeff_222
  ring

theorem eval_Fplus (a : Fin 3 → Ki) :
    MvPolynomial.eval a Fplus =
      ofLadj Fplus_re_000 Fplus_im_000 * a 0 ^ 3 +
        ofLadj Fplus_re_001 Fplus_im_001 * (a 0 ^ 2 * a 1) +
          ofLadj Fplus_re_002 Fplus_im_002 * (a 0 ^ 2 * a 2) +
            ofLadj Fplus_re_011 Fplus_im_011 * (a 0 * a 1 ^ 2) +
              ofLadj Fplus_re_012 Fplus_im_012 * (a 0 * a 1 * a 2) +
                ofLadj Fplus_re_022 Fplus_im_022 * (a 0 * a 2 ^ 2) +
                  ofLadj Fplus_re_111 Fplus_im_111 * a 1 ^ 3 +
                    ofLadj Fplus_re_112 Fplus_im_112 * (a 1 ^ 2 * a 2) +
                      ofLadj Fplus_re_122 Fplus_im_122 * (a 1 * a 2 ^ 2) +
                        ofLadj Fplus_re_222 Fplus_im_222 * a 2 ^ 3 := by
  unfold Fplus
  simp [eval_add, eval_mul, eval_C, eval_X, eval_pow]

theorem eval_Fplus_eq_det (a : Fin 3 → Ki) :
    MvPolynomial.eval a Fplus = Matrix.det (bilinearN a) := by
  rw [eval_Fplus, det_bilinearN_collect]
  simp only [detCoeff_000_eq, detCoeff_001_eq, detCoeff_002_eq, detCoeff_011_eq,
    detCoeff_012_eq, detCoeff_022_eq, detCoeff_111_eq, detCoeff_112_eq,
    detCoeff_122_eq, detCoeff_222_eq]

end V14Formalization.D12SigmaPlusSegreCore
