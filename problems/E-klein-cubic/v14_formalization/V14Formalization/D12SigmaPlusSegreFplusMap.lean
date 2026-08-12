/-
Copyright (c) 2026 V14Formalization contributors.
Released under Apache 2.0 license.
-/
import V14Formalization.D12SigmaPlusSegrePoint
import V14Formalization.D12SigmaPlusSegreFplusDet

/-!
# Mapped evaluation: `Fplus` remains the determinantal cubic
-/

noncomputable section

open Matrix MvPolynomial
open V14Formalization.D12SigmaPlusQuadric6

namespace V14Formalization.D12SigmaPlusSegreCore

variable {F : Type*} [Field F] (φ : Ki →+* F)

theorem bilinearNOn_sum (a : Fin 3 → F) (r j : Fin 3) :
    bilinearNOn φ a r j =
      φ (N r (crossIndex 0 j)) * a 0 +
        φ (N r (crossIndex 1 j)) * a 1 +
          φ (N r (crossIndex 2 j)) * a 2 := by
  simp [bilinearNOn, Fin.sum_univ_succ, add_assoc]

theorem bilinearNOn_00 (a : Fin 3 → F) :
    bilinearNOn φ a 0 0 = φ N_entry_0_0 * a 0 + φ N_entry_0_3 * a 1 + a 2 := by
  rw [bilinearNOn_sum]
  simp [crossIndex, N_apply_0_0, N_apply_0_3, N_apply_0_6, N_entry_0_6_eq_one]

theorem bilinearNOn_01 (a : Fin 3 → F) :
    bilinearNOn φ a 0 1 = φ N_entry_0_1 * a 0 + φ N_entry_0_4 * a 1 := by
  rw [bilinearNOn_sum]
  simp [crossIndex, N_apply_0_1, N_apply_0_4, N_apply_0_7, N_entry_0_7_eq_zero]

theorem bilinearNOn_02 (a : Fin 3 → F) :
    bilinearNOn φ a 0 2 = φ N_entry_0_2 * a 0 + φ N_entry_0_5 * a 1 := by
  rw [bilinearNOn_sum]
  simp [crossIndex, N_apply_0_2, N_apply_0_5, N_apply_0_8, N_entry_0_8_eq_zero]

theorem bilinearNOn_10 (a : Fin 3 → F) :
    bilinearNOn φ a 1 0 = φ N_entry_1_0 * a 0 + φ N_entry_1_3 * a 1 := by
  rw [bilinearNOn_sum]
  simp [crossIndex, N_apply_1_0, N_apply_1_3, N_apply_1_6, N_entry_1_6_eq_zero]

theorem bilinearNOn_11 (a : Fin 3 → F) :
    bilinearNOn φ a 1 1 = φ N_entry_1_1 * a 0 + φ N_entry_1_4 * a 1 + a 2 := by
  rw [bilinearNOn_sum]
  simp [crossIndex, N_apply_1_1, N_apply_1_4, N_apply_1_7, N_entry_1_7_eq_one]

theorem bilinearNOn_12 (a : Fin 3 → F) :
    bilinearNOn φ a 1 2 = φ N_entry_1_2 * a 0 + φ N_entry_1_5 * a 1 := by
  rw [bilinearNOn_sum]
  simp [crossIndex, N_apply_1_2, N_apply_1_5, N_apply_1_8, N_entry_1_8_eq_zero]

theorem bilinearNOn_20 (a : Fin 3 → F) :
    bilinearNOn φ a 2 0 = φ N_entry_2_0 * a 0 + φ N_entry_2_3 * a 1 := by
  rw [bilinearNOn_sum]
  simp [crossIndex, N_apply_2_0, N_apply_2_3, N_apply_2_6, N_entry_2_6_eq_zero]

theorem bilinearNOn_21 (a : Fin 3 → F) :
    bilinearNOn φ a 2 1 = φ N_entry_2_1 * a 0 + φ N_entry_2_4 * a 1 := by
  rw [bilinearNOn_sum]
  simp [crossIndex, N_apply_2_1, N_apply_2_4, N_apply_2_7, N_entry_2_7_eq_zero]

theorem bilinearNOn_22 (a : Fin 3 → F) :
    bilinearNOn φ a 2 2 = φ N_entry_2_2 * a 0 + φ N_entry_2_5 * a 1 + a 2 := by
  rw [bilinearNOn_sum]
  simp [crossIndex, N_apply_2_2, N_apply_2_5, N_apply_2_8, N_entry_2_8_eq_one]

theorem det_bilinearNOn_collect (a : Fin 3 → F) :
    det (bilinearNOn φ a) =
      φ detCoeff_000 * a 0 ^ 3 +
        φ detCoeff_001 * (a 0 ^ 2 * a 1) +
          φ detCoeff_002 * (a 0 ^ 2 * a 2) +
            φ detCoeff_011 * (a 0 * a 1 ^ 2) +
              φ detCoeff_012 * (a 0 * a 1 * a 2) +
                φ detCoeff_022 * (a 0 * a 2 ^ 2) +
                  φ detCoeff_111 * a 1 ^ 3 +
                    φ detCoeff_112 * (a 1 ^ 2 * a 2) +
                      φ detCoeff_122 * (a 1 * a 2 ^ 2) +
                        φ detCoeff_222 * a 2 ^ 3 := by
  rw [det_fin_three, bilinearNOn_00, bilinearNOn_01, bilinearNOn_02,
    bilinearNOn_10, bilinearNOn_11, bilinearNOn_12, bilinearNOn_20,
    bilinearNOn_21, bilinearNOn_22]
  unfold detCoeff_000 detCoeff_001 detCoeff_002 detCoeff_011 detCoeff_012
    detCoeff_022 detCoeff_111 detCoeff_112 detCoeff_122 detCoeff_222
  simp [map_add, map_sub, map_mul]
  ring

theorem eval_map_Fplus (a : Fin 3 → F) :
    eval a (map φ Fplus) =
      φ (ofLadj Fplus_re_000 Fplus_im_000) * a 0 ^ 3 +
        φ (ofLadj Fplus_re_001 Fplus_im_001) * (a 0 ^ 2 * a 1) +
          φ (ofLadj Fplus_re_002 Fplus_im_002) * (a 0 ^ 2 * a 2) +
            φ (ofLadj Fplus_re_011 Fplus_im_011) * (a 0 * a 1 ^ 2) +
              φ (ofLadj Fplus_re_012 Fplus_im_012) * (a 0 * a 1 * a 2) +
                φ (ofLadj Fplus_re_022 Fplus_im_022) * (a 0 * a 2 ^ 2) +
                  φ (ofLadj Fplus_re_111 Fplus_im_111) * a 1 ^ 3 +
                    φ (ofLadj Fplus_re_112 Fplus_im_112) * (a 1 ^ 2 * a 2) +
                      φ (ofLadj Fplus_re_122 Fplus_im_122) * (a 1 * a 2 ^ 2) +
                        φ (ofLadj Fplus_re_222 Fplus_im_222) * a 2 ^ 3 := by
  unfold Fplus
  simp [eval_map, eval_add, eval_mul, eval_C, eval_X, eval_pow, map_add,
    map_mul, map_pow]

theorem eval_map_Fplus_eq_det (a : Fin 3 → F) :
    eval a (map φ Fplus) = det (bilinearNOn φ a) := by
  rw [eval_map_Fplus, det_bilinearNOn_collect]
  simp only [detCoeff_000_eq, detCoeff_001_eq, detCoeff_002_eq, detCoeff_011_eq,
    detCoeff_012_eq, detCoeff_022_eq, detCoeff_111_eq, detCoeff_112_eq,
    detCoeff_122_eq, detCoeff_222_eq]

theorem bilinearNOn_smul (c : F) (a : Fin 3 → F) :
    bilinearNOn φ (c • a) = c • bilinearNOn φ a := by
  ext r j
  simp [bilinearNOn, Pi.smul_apply, smul_eq_mul, mul_left_comm, Finset.mul_sum]

theorem bilinearNOn_map_of_base (a0 : Fin 3 → Ki) :
    bilinearNOn φ (fun i => φ (a0 i)) = (bilinearN a0).map φ := by
  ext r j
  simp [bilinearNOn, bilinearN, map_sum, map_mul, Matrix.map_apply]

theorem segrVecOn_smul (c d : F) (a b : Fin 3 → F) :
    segrVecOn (c • a) (d • b) = (c * d) • segrVecOn a b := by
  funext p
  simp [segrVecOn, Pi.smul_apply, smul_eq_mul]
  ring

theorem segrVecOn_map (a b : Fin 3 → Ki) :
    segrVecOn (fun i => φ (a i)) (fun i => φ (b i)) =
      fun p => φ (segrVecOn a b p) := by
  funext p
  simp [segrVecOn, map_mul]

theorem L_map_mulVec_map (z : Fin 9 → Ki) :
    ((D12SigmaPlusSegreCore.L).map φ).mulVec (fun p => φ (z p)) =
      fun i => φ ((D12SigmaPlusSegreCore.L).mulVec z i) := by
  funext i
  simp [Matrix.mulVec, Matrix.map_apply, dotProduct, map_sum, map_mul]

end V14Formalization.D12SigmaPlusSegreCore
