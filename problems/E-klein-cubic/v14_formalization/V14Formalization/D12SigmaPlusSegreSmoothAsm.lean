/-
Assemble Fplus chart identities and geometric smoothness.
-/
import V14Formalization.D12SigmaPlusSegreHomogeneous
import V14Formalization.D12SigmaPlusSegrePartials
import V14Formalization.D12SigmaPlusSegreBezoutData
import Mathlib.Algebra.MvPolynomial.PDeriv
import V14Formalization.D12SigmaPlusSegreSmoothCU_000
import V14Formalization.D12SigmaPlusSegreSmoothCU_002
import V14Formalization.D12SigmaPlusSegreSmoothCU_003
import V14Formalization.D12SigmaPlusSegreSmoothCU_004
import V14Formalization.D12SigmaPlusSegreSmoothCU_011
import V14Formalization.D12SigmaPlusSegreSmoothCU_012
import V14Formalization.D12SigmaPlusSegreSmoothCU_013
import V14Formalization.D12SigmaPlusSegreSmoothCU_020
import V14Formalization.D12SigmaPlusSegreSmoothCU_021
import V14Formalization.D12SigmaPlusSegreSmoothCU_022
import V14Formalization.D12SigmaPlusSegreSmoothCU_030
import V14Formalization.D12SigmaPlusSegreSmoothCU_031
import V14Formalization.D12SigmaPlusSegreSmoothCU_100
import V14Formalization.D12SigmaPlusSegreSmoothCU_101
import V14Formalization.D12SigmaPlusSegreSmoothCU_102
import V14Formalization.D12SigmaPlusSegreSmoothCU_103
import V14Formalization.D12SigmaPlusSegreSmoothCU_110
import V14Formalization.D12SigmaPlusSegreSmoothCU_111
import V14Formalization.D12SigmaPlusSegreSmoothCU_112
import V14Formalization.D12SigmaPlusSegreSmoothCU_120
import V14Formalization.D12SigmaPlusSegreSmoothCU_121
import V14Formalization.D12SigmaPlusSegreSmoothCU_200
import V14Formalization.D12SigmaPlusSegreSmoothCU_201
import V14Formalization.D12SigmaPlusSegreSmoothCU_202
import V14Formalization.D12SigmaPlusSegreSmoothCU_210
import V14Formalization.D12SigmaPlusSegreSmoothCU_211
import V14Formalization.D12SigmaPlusSegreSmoothCV_000
import V14Formalization.D12SigmaPlusSegreSmoothCV_002
import V14Formalization.D12SigmaPlusSegreSmoothCV_003
import V14Formalization.D12SigmaPlusSegreSmoothCV_004
import V14Formalization.D12SigmaPlusSegreSmoothCV_010
import V14Formalization.D12SigmaPlusSegreSmoothCV_011
import V14Formalization.D12SigmaPlusSegreSmoothCV_012
import V14Formalization.D12SigmaPlusSegreSmoothCV_013
import V14Formalization.D12SigmaPlusSegreSmoothCV_020
import V14Formalization.D12SigmaPlusSegreSmoothCV_021
import V14Formalization.D12SigmaPlusSegreSmoothCV_022
import V14Formalization.D12SigmaPlusSegreSmoothCV_101
import V14Formalization.D12SigmaPlusSegreSmoothCV_102
import V14Formalization.D12SigmaPlusSegreSmoothCV_103
import V14Formalization.D12SigmaPlusSegreSmoothCV_110
import V14Formalization.D12SigmaPlusSegreSmoothCV_111
import V14Formalization.D12SigmaPlusSegreSmoothCV_112
import V14Formalization.D12SigmaPlusSegreSmoothCV_120
import V14Formalization.D12SigmaPlusSegreSmoothCV_121
import V14Formalization.D12SigmaPlusSegreSmoothCV_200
import V14Formalization.D12SigmaPlusSegreSmoothCV_201
import V14Formalization.D12SigmaPlusSegreSmoothCV_202
import V14Formalization.D12SigmaPlusSegreSmoothCV_210
import V14Formalization.D12SigmaPlusSegreSmoothCV_211
import V14Formalization.D12SigmaPlusSegreSmoothCV_300
import V14Formalization.D12SigmaPlusSegreSmoothCV_301
import V14Formalization.D12SigmaPlusSegreSmoothCW_000
import V14Formalization.D12SigmaPlusSegreSmoothCW_001
import V14Formalization.D12SigmaPlusSegreSmoothCW_002
import V14Formalization.D12SigmaPlusSegreSmoothCW_011
import V14Formalization.D12SigmaPlusSegreSmoothCW_012
import V14Formalization.D12SigmaPlusSegreSmoothCW_020
import V14Formalization.D12SigmaPlusSegreSmoothCW_021
import V14Formalization.D12SigmaPlusSegreSmoothCW_022
import V14Formalization.D12SigmaPlusSegreSmoothCW_030
import V14Formalization.D12SigmaPlusSegreSmoothCW_031
import V14Formalization.D12SigmaPlusSegreSmoothCW_040
import V14Formalization.D12SigmaPlusSegreSmoothCW_101
import V14Formalization.D12SigmaPlusSegreSmoothCW_102
import V14Formalization.D12SigmaPlusSegreSmoothCW_110
import V14Formalization.D12SigmaPlusSegreSmoothCW_111
import V14Formalization.D12SigmaPlusSegreSmoothCW_112
import V14Formalization.D12SigmaPlusSegreSmoothCW_120
import V14Formalization.D12SigmaPlusSegreSmoothCW_121
import V14Formalization.D12SigmaPlusSegreSmoothCW_130
import V14Formalization.D12SigmaPlusSegreSmoothCW_200
import V14Formalization.D12SigmaPlusSegreSmoothCW_201
import V14Formalization.D12SigmaPlusSegreSmoothCW_210
import V14Formalization.D12SigmaPlusSegreSmoothCW_211
import V14Formalization.D12SigmaPlusSegreSmoothCW_220
import V14Formalization.D12SigmaPlusSegreSmoothCW_300
import V14Formalization.D12SigmaPlusSegreSmoothCW_310

noncomputable section
open MvPolynomial
namespace V14Formalization.D12SigmaPlusSegreCore

theorem eval_Fplus_dU (a : Fin 3 → Ki) :
    eval a Fplus_dU =
      Fplus_dU_c_002 * a 2 ^ 2 +
        Fplus_dU_c_011 * a 1 * a 2 +
        Fplus_dU_c_020 * a 1 ^ 2 +
        Fplus_dU_c_101 * a 0 * a 2 +
        Fplus_dU_c_110 * a 0 * a 1 +
          Fplus_dU_c_200 * a 0 ^ 2 := by
  unfold Fplus_dU
  simp [eval_add, eval_mul, eval_C, eval_X, eval_pow]

theorem eval_Fplus_dV (a : Fin 3 → Ki) :
    eval a Fplus_dV =
      Fplus_dV_c_002 * a 2 ^ 2 +
        Fplus_dV_c_011 * a 1 * a 2 +
        Fplus_dV_c_020 * a 1 ^ 2 +
        Fplus_dV_c_101 * a 0 * a 2 +
        Fplus_dV_c_110 * a 0 * a 1 +
          Fplus_dV_c_200 * a 0 ^ 2 := by
  unfold Fplus_dV
  simp [eval_add, eval_mul, eval_C, eval_X, eval_pow]

theorem eval_Fplus_dW (a : Fin 3 → Ki) :
    eval a Fplus_dW =
      Fplus_dW_c_002 * a 2 ^ 2 +
        Fplus_dW_c_011 * a 1 * a 2 +
        Fplus_dW_c_020 * a 1 ^ 2 +
        Fplus_dW_c_101 * a 0 * a 2 +
        Fplus_dW_c_110 * a 0 * a 1 +
          Fplus_dW_c_200 * a 0 ^ 2 := by
  unfold Fplus_dW
  simp [eval_add, eval_mul, eval_C, eval_X, eval_pow]

theorem eval_CU_0 (a : Fin 3 → Ki) :
    eval a CU_0 =
      CU_0_c_011 * a 1 * a 2 +
        CU_0_c_002 * a 2 ^ 2 +
        CU_0_c_010 * a 1 +
        CU_0_c_001 * a 2 +
          CU_0_c_000 * (1 : Ki) := by
  unfold CU_0
  simp [eval_add, eval_mul, eval_C, eval_X, eval_pow]

theorem eval_CU_1 (a : Fin 3 → Ki) :
    eval a CU_1 =
      CU_1_c_011 * a 1 * a 2 +
        CU_1_c_002 * a 2 ^ 2 +
        CU_1_c_010 * a 1 +
        CU_1_c_001 * a 2 +
          CU_1_c_000 * (1 : Ki) := by
  unfold CU_1
  simp [eval_add, eval_mul, eval_C, eval_X, eval_pow]

theorem eval_CU_2 (a : Fin 3 → Ki) :
    eval a CU_2 =
      CU_2_c_011 * a 1 * a 2 +
        CU_2_c_002 * a 2 ^ 2 +
        CU_2_c_010 * a 1 +
        CU_2_c_001 * a 2 +
          CU_2_c_000 * (1 : Ki) := by
  unfold CU_2
  simp [eval_add, eval_mul, eval_C, eval_X, eval_pow]

theorem eval_CU_3 (a : Fin 3 → Ki) :
    eval a CU_3 =
      CU_3_c_111 * a 0 * a 1 * a 2 +
        CU_3_c_021 * a 1 ^ 2 * a 2 +
        CU_3_c_102 * a 0 * a 2 ^ 2 +
        CU_3_c_012 * a 1 * a 2 ^ 2 +
        CU_3_c_003 * a 2 ^ 3 +
        CU_3_c_110 * a 0 * a 1 +
        CU_3_c_020 * a 1 ^ 2 +
        CU_3_c_101 * a 0 * a 2 +
        CU_3_c_011 * a 1 * a 2 +
        CU_3_c_002 * a 2 ^ 2 +
        CU_3_c_100 * a 0 +
          CU_3_c_000 * (1 : Ki) := by
  unfold CU_3
  simp [eval_add, eval_mul, eval_C, eval_X, eval_pow]

theorem eval_CV_0 (a : Fin 3 → Ki) :
    eval a CV_0 =
      CV_0_c_101 * a 0 * a 2 +
        CV_0_c_002 * a 2 ^ 2 +
        CV_0_c_100 * a 0 +
        CV_0_c_001 * a 2 +
          CV_0_c_000 * (1 : Ki) := by
  unfold CV_0
  simp [eval_add, eval_mul, eval_C, eval_X, eval_pow]

theorem eval_CV_1 (a : Fin 3 → Ki) :
    eval a CV_1 =
      CV_1_c_101 * a 0 * a 2 +
        CV_1_c_002 * a 2 ^ 2 +
        CV_1_c_100 * a 0 +
        CV_1_c_001 * a 2 +
          CV_1_c_000 * (1 : Ki) := by
  unfold CV_1
  simp [eval_add, eval_mul, eval_C, eval_X, eval_pow]

theorem eval_CV_2 (a : Fin 3 → Ki) :
    eval a CV_2 =
      CV_2_c_101 * a 0 * a 2 +
        CV_2_c_002 * a 2 ^ 2 +
        CV_2_c_100 * a 0 +
        CV_2_c_001 * a 2 +
          CV_2_c_000 * (1 : Ki) := by
  unfold CV_2
  simp [eval_add, eval_mul, eval_C, eval_X, eval_pow]

theorem eval_CV_3 (a : Fin 3 → Ki) :
    eval a CV_3 =
      CV_3_c_201 * a 0 ^ 2 * a 2 +
        CV_3_c_111 * a 0 * a 1 * a 2 +
        CV_3_c_102 * a 0 * a 2 ^ 2 +
        CV_3_c_012 * a 1 * a 2 ^ 2 +
        CV_3_c_003 * a 2 ^ 3 +
        CV_3_c_200 * a 0 ^ 2 +
        CV_3_c_110 * a 0 * a 1 +
        CV_3_c_101 * a 0 * a 2 +
        CV_3_c_011 * a 1 * a 2 +
        CV_3_c_002 * a 2 ^ 2 +
        CV_3_c_010 * a 1 +
          CV_3_c_000 * (1 : Ki) := by
  unfold CV_3
  simp [eval_add, eval_mul, eval_C, eval_X, eval_pow]

theorem eval_CW_0 (a : Fin 3 → Ki) :
    eval a CW_0 =
      CW_0_c_110 * a 0 * a 1 +
        CW_0_c_020 * a 1 ^ 2 +
        CW_0_c_100 * a 0 +
        CW_0_c_010 * a 1 +
          CW_0_c_000 * (1 : Ki) := by
  unfold CW_0
  simp [eval_add, eval_mul, eval_C, eval_X, eval_pow]

theorem eval_CW_1 (a : Fin 3 → Ki) :
    eval a CW_1 =
      CW_1_c_110 * a 0 * a 1 +
        CW_1_c_020 * a 1 ^ 2 +
        CW_1_c_100 * a 0 +
        CW_1_c_010 * a 1 +
          CW_1_c_000 * (1 : Ki) := by
  unfold CW_1
  simp [eval_add, eval_mul, eval_C, eval_X, eval_pow]

theorem eval_CW_2 (a : Fin 3 → Ki) :
    eval a CW_2 =
      CW_2_c_110 * a 0 * a 1 +
        CW_2_c_020 * a 1 ^ 2 +
        CW_2_c_100 * a 0 +
        CW_2_c_010 * a 1 +
          CW_2_c_000 * (1 : Ki) := by
  unfold CW_2
  simp [eval_add, eval_mul, eval_C, eval_X, eval_pow]

theorem eval_CW_3 (a : Fin 3 → Ki) :
    eval a CW_3 =
      CW_3_c_210 * a 0 ^ 2 * a 1 +
        CW_3_c_120 * a 0 * a 1 ^ 2 +
        CW_3_c_030 * a 1 ^ 3 +
        CW_3_c_111 * a 0 * a 1 * a 2 +
        CW_3_c_021 * a 1 ^ 2 * a 2 +
        CW_3_c_200 * a 0 ^ 2 +
        CW_3_c_110 * a 0 * a 1 +
        CW_3_c_020 * a 1 ^ 2 +
        CW_3_c_101 * a 0 * a 2 +
        CW_3_c_011 * a 1 * a 2 +
        CW_3_c_001 * a 2 +
          CW_3_c_000 * (1 : Ki) := by
  unfold CW_3
  simp [eval_add, eval_mul, eval_C, eval_X, eval_pow]

theorem CU_collect (a : Fin 3 → Ki) :
    eval a CU_0 * eval a Fplus_dU +
        eval a CU_1 * eval a Fplus_dV +
          eval a CU_2 * eval a Fplus_dW +
            eval a CU_3 * (a 0 - 1) =
      CU_coeff_000 * (1 : Ki) +
        CU_coeff_002 * a 2 ^ 2 +
        CU_coeff_003 * a 2 ^ 3 +
        CU_coeff_004 * a 2 ^ 4 +
        CU_coeff_011 * a 1 * a 2 +
        CU_coeff_012 * a 1 * a 2 ^ 2 +
        CU_coeff_013 * a 1 * a 2 ^ 3 +
        CU_coeff_020 * a 1 ^ 2 +
        CU_coeff_021 * a 1 ^ 2 * a 2 +
        CU_coeff_022 * a 1 ^ 2 * a 2 ^ 2 +
        CU_coeff_030 * a 1 ^ 3 +
        CU_coeff_031 * a 1 ^ 3 * a 2 +
        CU_coeff_100 * a 0 +
        CU_coeff_101 * a 0 * a 2 +
        CU_coeff_102 * a 0 * a 2 ^ 2 +
        CU_coeff_103 * a 0 * a 2 ^ 3 +
        CU_coeff_110 * a 0 * a 1 +
        CU_coeff_111 * a 0 * a 1 * a 2 +
        CU_coeff_112 * a 0 * a 1 * a 2 ^ 2 +
        CU_coeff_120 * a 0 * a 1 ^ 2 +
        CU_coeff_121 * a 0 * a 1 ^ 2 * a 2 +
        CU_coeff_200 * a 0 ^ 2 +
        CU_coeff_201 * a 0 ^ 2 * a 2 +
        CU_coeff_202 * a 0 ^ 2 * a 2 ^ 2 +
        CU_coeff_210 * a 0 ^ 2 * a 1 +
        CU_coeff_211 * a 0 ^ 2 * a 1 * a 2 := by
  rw [eval_CU_0, eval_CU_1, eval_CU_2, eval_CU_3,
    eval_Fplus_dU, eval_Fplus_dV, eval_Fplus_dW]
  unfold CU_coeff_000 CU_coeff_002 CU_coeff_003 CU_coeff_004 CU_coeff_011 CU_coeff_012 CU_coeff_013 CU_coeff_020 CU_coeff_021 CU_coeff_022 CU_coeff_030 CU_coeff_031 CU_coeff_100 CU_coeff_101 CU_coeff_102 CU_coeff_103 CU_coeff_110 CU_coeff_111 CU_coeff_112 CU_coeff_120 CU_coeff_121 CU_coeff_200 CU_coeff_201 CU_coeff_202 CU_coeff_210 CU_coeff_211
  ring

theorem CU_eval_identity (a : Fin 3 → Ki) :
    eval a CU_0 * eval a Fplus_dU +
        eval a CU_1 * eval a Fplus_dV +
          eval a CU_2 * eval a Fplus_dW +
            eval a CU_3 * (a 0 - 1) = 1 := by
  rw [CU_collect]
  simp only [CU_coeff_000_eq, CU_coeff_002_eq, CU_coeff_003_eq, CU_coeff_004_eq, CU_coeff_011_eq, CU_coeff_012_eq, CU_coeff_013_eq, CU_coeff_020_eq, CU_coeff_021_eq, CU_coeff_022_eq, CU_coeff_030_eq, CU_coeff_031_eq, CU_coeff_100_eq, CU_coeff_101_eq, CU_coeff_102_eq, CU_coeff_103_eq, CU_coeff_110_eq, CU_coeff_111_eq, CU_coeff_112_eq, CU_coeff_120_eq, CU_coeff_121_eq, CU_coeff_200_eq, CU_coeff_201_eq, CU_coeff_202_eq, CU_coeff_210_eq, CU_coeff_211_eq]
  ring

theorem CV_collect (a : Fin 3 → Ki) :
    eval a CV_0 * eval a Fplus_dU +
        eval a CV_1 * eval a Fplus_dV +
          eval a CV_2 * eval a Fplus_dW +
            eval a CV_3 * (a 1 - 1) =
      CV_coeff_000 * (1 : Ki) +
        CV_coeff_002 * a 2 ^ 2 +
        CV_coeff_003 * a 2 ^ 3 +
        CV_coeff_004 * a 2 ^ 4 +
        CV_coeff_010 * a 1 +
        CV_coeff_011 * a 1 * a 2 +
        CV_coeff_012 * a 1 * a 2 ^ 2 +
        CV_coeff_013 * a 1 * a 2 ^ 3 +
        CV_coeff_020 * a 1 ^ 2 +
        CV_coeff_021 * a 1 ^ 2 * a 2 +
        CV_coeff_022 * a 1 ^ 2 * a 2 ^ 2 +
        CV_coeff_101 * a 0 * a 2 +
        CV_coeff_102 * a 0 * a 2 ^ 2 +
        CV_coeff_103 * a 0 * a 2 ^ 3 +
        CV_coeff_110 * a 0 * a 1 +
        CV_coeff_111 * a 0 * a 1 * a 2 +
        CV_coeff_112 * a 0 * a 1 * a 2 ^ 2 +
        CV_coeff_120 * a 0 * a 1 ^ 2 +
        CV_coeff_121 * a 0 * a 1 ^ 2 * a 2 +
        CV_coeff_200 * a 0 ^ 2 +
        CV_coeff_201 * a 0 ^ 2 * a 2 +
        CV_coeff_202 * a 0 ^ 2 * a 2 ^ 2 +
        CV_coeff_210 * a 0 ^ 2 * a 1 +
        CV_coeff_211 * a 0 ^ 2 * a 1 * a 2 +
        CV_coeff_300 * a 0 ^ 3 +
        CV_coeff_301 * a 0 ^ 3 * a 2 := by
  rw [eval_CV_0, eval_CV_1, eval_CV_2, eval_CV_3,
    eval_Fplus_dU, eval_Fplus_dV, eval_Fplus_dW]
  unfold CV_coeff_000 CV_coeff_002 CV_coeff_003 CV_coeff_004 CV_coeff_010 CV_coeff_011 CV_coeff_012 CV_coeff_013 CV_coeff_020 CV_coeff_021 CV_coeff_022 CV_coeff_101 CV_coeff_102 CV_coeff_103 CV_coeff_110 CV_coeff_111 CV_coeff_112 CV_coeff_120 CV_coeff_121 CV_coeff_200 CV_coeff_201 CV_coeff_202 CV_coeff_210 CV_coeff_211 CV_coeff_300 CV_coeff_301
  ring

theorem CV_eval_identity (a : Fin 3 → Ki) :
    eval a CV_0 * eval a Fplus_dU +
        eval a CV_1 * eval a Fplus_dV +
          eval a CV_2 * eval a Fplus_dW +
            eval a CV_3 * (a 1 - 1) = 1 := by
  rw [CV_collect]
  simp only [CV_coeff_000_eq, CV_coeff_002_eq, CV_coeff_003_eq, CV_coeff_004_eq, CV_coeff_010_eq, CV_coeff_011_eq, CV_coeff_012_eq, CV_coeff_013_eq, CV_coeff_020_eq, CV_coeff_021_eq, CV_coeff_022_eq, CV_coeff_101_eq, CV_coeff_102_eq, CV_coeff_103_eq, CV_coeff_110_eq, CV_coeff_111_eq, CV_coeff_112_eq, CV_coeff_120_eq, CV_coeff_121_eq, CV_coeff_200_eq, CV_coeff_201_eq, CV_coeff_202_eq, CV_coeff_210_eq, CV_coeff_211_eq, CV_coeff_300_eq, CV_coeff_301_eq]
  ring

theorem CW_collect (a : Fin 3 → Ki) :
    eval a CW_0 * eval a Fplus_dU +
        eval a CW_1 * eval a Fplus_dV +
          eval a CW_2 * eval a Fplus_dW +
            eval a CW_3 * (a 2 - 1) =
      CW_coeff_000 * (1 : Ki) +
        CW_coeff_001 * a 2 +
        CW_coeff_002 * a 2 ^ 2 +
        CW_coeff_011 * a 1 * a 2 +
        CW_coeff_012 * a 1 * a 2 ^ 2 +
        CW_coeff_020 * a 1 ^ 2 +
        CW_coeff_021 * a 1 ^ 2 * a 2 +
        CW_coeff_022 * a 1 ^ 2 * a 2 ^ 2 +
        CW_coeff_030 * a 1 ^ 3 +
        CW_coeff_031 * a 1 ^ 3 * a 2 +
        CW_coeff_040 * a 1 ^ 4 +
        CW_coeff_101 * a 0 * a 2 +
        CW_coeff_102 * a 0 * a 2 ^ 2 +
        CW_coeff_110 * a 0 * a 1 +
        CW_coeff_111 * a 0 * a 1 * a 2 +
        CW_coeff_112 * a 0 * a 1 * a 2 ^ 2 +
        CW_coeff_120 * a 0 * a 1 ^ 2 +
        CW_coeff_121 * a 0 * a 1 ^ 2 * a 2 +
        CW_coeff_130 * a 0 * a 1 ^ 3 +
        CW_coeff_200 * a 0 ^ 2 +
        CW_coeff_201 * a 0 ^ 2 * a 2 +
        CW_coeff_210 * a 0 ^ 2 * a 1 +
        CW_coeff_211 * a 0 ^ 2 * a 1 * a 2 +
        CW_coeff_220 * a 0 ^ 2 * a 1 ^ 2 +
        CW_coeff_300 * a 0 ^ 3 +
        CW_coeff_310 * a 0 ^ 3 * a 1 := by
  rw [eval_CW_0, eval_CW_1, eval_CW_2, eval_CW_3,
    eval_Fplus_dU, eval_Fplus_dV, eval_Fplus_dW]
  unfold CW_coeff_000 CW_coeff_001 CW_coeff_002 CW_coeff_011 CW_coeff_012 CW_coeff_020 CW_coeff_021 CW_coeff_022 CW_coeff_030 CW_coeff_031 CW_coeff_040 CW_coeff_101 CW_coeff_102 CW_coeff_110 CW_coeff_111 CW_coeff_112 CW_coeff_120 CW_coeff_121 CW_coeff_130 CW_coeff_200 CW_coeff_201 CW_coeff_210 CW_coeff_211 CW_coeff_220 CW_coeff_300 CW_coeff_310
  ring

theorem CW_eval_identity (a : Fin 3 → Ki) :
    eval a CW_0 * eval a Fplus_dU +
        eval a CW_1 * eval a Fplus_dV +
          eval a CW_2 * eval a Fplus_dW +
            eval a CW_3 * (a 2 - 1) = 1 := by
  rw [CW_collect]
  simp only [CW_coeff_000_eq, CW_coeff_001_eq, CW_coeff_002_eq, CW_coeff_011_eq, CW_coeff_012_eq, CW_coeff_020_eq, CW_coeff_021_eq, CW_coeff_022_eq, CW_coeff_030_eq, CW_coeff_031_eq, CW_coeff_040_eq, CW_coeff_101_eq, CW_coeff_102_eq, CW_coeff_110_eq, CW_coeff_111_eq, CW_coeff_112_eq, CW_coeff_120_eq, CW_coeff_121_eq, CW_coeff_130_eq, CW_coeff_200_eq, CW_coeff_201_eq, CW_coeff_210_eq, CW_coeff_211_eq, CW_coeff_220_eq, CW_coeff_300_eq, CW_coeff_310_eq]
  ring

end V14Formalization.D12SigmaPlusSegreCore
