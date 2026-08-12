/-
Identify the emitted Bplus polynomial matrix with B_poly * Kplus_poly
and with the concrete plus carrier after evaluation.
-/
import V14Formalization.D12SigmaPlusSegreApply_BplusPoly
import V14Formalization.D12SigmaPlusQuadric6
import V14Formalization.D12SigmaCarrierConcrete
import V14Formalization.D12SigmaCarrierPolynomialCore

noncomputable section
open Matrix Polynomial
namespace V14Formalization.D12SigmaPlusSegreCore
open D12PolynomialData D12PolynomialEvaluation
open D12SigmaCarrierPolynomial D12SigmaPlusQuadric6

theorem B_mul_Kplus_poly_0_0 :
    (B_poly * Kplus_poly) (0 : Fin 15) (0 : Fin 6) =
      Bplus_poly_0_0 := by
  simp [Matrix.mul_apply, Fin.sum_univ_succ, B_poly, Kplus_poly,
    Kplus_poly_row0, Kplus_poly_row1, Kplus_poly_row2, Kplus_poly_row3, Kplus_poly_row4, Kplus_poly_row5, Kplus_poly_row6, Kplus_poly_row7, Kplus_poly_row8, Kplus_poly_row9, Bplus_poly_0_0]
  try ring

theorem B_mul_Kplus_poly_0_1 :
    (B_poly * Kplus_poly) (0 : Fin 15) (1 : Fin 6) =
      Bplus_poly_0_1 := by
  simp [Matrix.mul_apply, Fin.sum_univ_succ, B_poly, Kplus_poly,
    Kplus_poly_row0, Kplus_poly_row1, Kplus_poly_row2, Kplus_poly_row3, Kplus_poly_row4, Kplus_poly_row5, Kplus_poly_row6, Kplus_poly_row7, Kplus_poly_row8, Kplus_poly_row9, Bplus_poly_0_1]
  try ring

theorem B_mul_Kplus_poly_0_2 :
    (B_poly * Kplus_poly) (0 : Fin 15) (2 : Fin 6) =
      Bplus_poly_0_2 := by
  simp [Matrix.mul_apply, Fin.sum_univ_succ, B_poly, Kplus_poly,
    Kplus_poly_row0, Kplus_poly_row1, Kplus_poly_row2, Kplus_poly_row3, Kplus_poly_row4, Kplus_poly_row5, Kplus_poly_row6, Kplus_poly_row7, Kplus_poly_row8, Kplus_poly_row9, Bplus_poly_0_2]
  try ring

theorem B_mul_Kplus_poly_0_3 :
    (B_poly * Kplus_poly) (0 : Fin 15) (3 : Fin 6) =
      Bplus_poly_0_3 := by
  simp [Matrix.mul_apply, Fin.sum_univ_succ, B_poly, Kplus_poly,
    Kplus_poly_row0, Kplus_poly_row1, Kplus_poly_row2, Kplus_poly_row3, Kplus_poly_row4, Kplus_poly_row5, Kplus_poly_row6, Kplus_poly_row7, Kplus_poly_row8, Kplus_poly_row9, Bplus_poly_0_3]
  try ring

theorem B_mul_Kplus_poly_0_4 :
    (B_poly * Kplus_poly) (0 : Fin 15) (4 : Fin 6) =
      Bplus_poly_0_4 := by
  simp [Matrix.mul_apply, Fin.sum_univ_succ, B_poly, Kplus_poly,
    Kplus_poly_row0, Kplus_poly_row1, Kplus_poly_row2, Kplus_poly_row3, Kplus_poly_row4, Kplus_poly_row5, Kplus_poly_row6, Kplus_poly_row7, Kplus_poly_row8, Kplus_poly_row9, Bplus_poly_0_4]
  try ring

theorem B_mul_Kplus_poly_0_5 :
    (B_poly * Kplus_poly) (0 : Fin 15) (5 : Fin 6) =
      Bplus_poly_0_5 := by
  simp [Matrix.mul_apply, Fin.sum_univ_succ, B_poly, Kplus_poly,
    Kplus_poly_row0, Kplus_poly_row1, Kplus_poly_row2, Kplus_poly_row3, Kplus_poly_row4, Kplus_poly_row5, Kplus_poly_row6, Kplus_poly_row7, Kplus_poly_row8, Kplus_poly_row9, Bplus_poly_0_5]
  try ring

theorem B_mul_Kplus_poly_1_0 :
    (B_poly * Kplus_poly) (1 : Fin 15) (0 : Fin 6) =
      Bplus_poly_1_0 := by
  simp [Matrix.mul_apply, Fin.sum_univ_succ, B_poly, Kplus_poly,
    Kplus_poly_row0, Kplus_poly_row1, Kplus_poly_row2, Kplus_poly_row3, Kplus_poly_row4, Kplus_poly_row5, Kplus_poly_row6, Kplus_poly_row7, Kplus_poly_row8, Kplus_poly_row9, Bplus_poly_1_0]
  try ring

theorem B_mul_Kplus_poly_1_1 :
    (B_poly * Kplus_poly) (1 : Fin 15) (1 : Fin 6) =
      Bplus_poly_1_1 := by
  simp [Matrix.mul_apply, Fin.sum_univ_succ, B_poly, Kplus_poly,
    Kplus_poly_row0, Kplus_poly_row1, Kplus_poly_row2, Kplus_poly_row3, Kplus_poly_row4, Kplus_poly_row5, Kplus_poly_row6, Kplus_poly_row7, Kplus_poly_row8, Kplus_poly_row9, Bplus_poly_1_1]
  try ring

theorem B_mul_Kplus_poly_1_2 :
    (B_poly * Kplus_poly) (1 : Fin 15) (2 : Fin 6) =
      Bplus_poly_1_2 := by
  simp [Matrix.mul_apply, Fin.sum_univ_succ, B_poly, Kplus_poly,
    Kplus_poly_row0, Kplus_poly_row1, Kplus_poly_row2, Kplus_poly_row3, Kplus_poly_row4, Kplus_poly_row5, Kplus_poly_row6, Kplus_poly_row7, Kplus_poly_row8, Kplus_poly_row9, Bplus_poly_1_2]
  try ring

theorem B_mul_Kplus_poly_1_3 :
    (B_poly * Kplus_poly) (1 : Fin 15) (3 : Fin 6) =
      Bplus_poly_1_3 := by
  simp [Matrix.mul_apply, Fin.sum_univ_succ, B_poly, Kplus_poly,
    Kplus_poly_row0, Kplus_poly_row1, Kplus_poly_row2, Kplus_poly_row3, Kplus_poly_row4, Kplus_poly_row5, Kplus_poly_row6, Kplus_poly_row7, Kplus_poly_row8, Kplus_poly_row9, Bplus_poly_1_3]
  try ring

theorem B_mul_Kplus_poly_1_4 :
    (B_poly * Kplus_poly) (1 : Fin 15) (4 : Fin 6) =
      Bplus_poly_1_4 := by
  simp [Matrix.mul_apply, Fin.sum_univ_succ, B_poly, Kplus_poly,
    Kplus_poly_row0, Kplus_poly_row1, Kplus_poly_row2, Kplus_poly_row3, Kplus_poly_row4, Kplus_poly_row5, Kplus_poly_row6, Kplus_poly_row7, Kplus_poly_row8, Kplus_poly_row9, Bplus_poly_1_4]
  try ring

theorem B_mul_Kplus_poly_1_5 :
    (B_poly * Kplus_poly) (1 : Fin 15) (5 : Fin 6) =
      Bplus_poly_1_5 := by
  simp [Matrix.mul_apply, Fin.sum_univ_succ, B_poly, Kplus_poly,
    Kplus_poly_row0, Kplus_poly_row1, Kplus_poly_row2, Kplus_poly_row3, Kplus_poly_row4, Kplus_poly_row5, Kplus_poly_row6, Kplus_poly_row7, Kplus_poly_row8, Kplus_poly_row9, Bplus_poly_1_5]
  try ring

theorem B_mul_Kplus_poly_2_0 :
    (B_poly * Kplus_poly) (2 : Fin 15) (0 : Fin 6) =
      Bplus_poly_2_0 := by
  simp [Matrix.mul_apply, Fin.sum_univ_succ, B_poly, Kplus_poly,
    Kplus_poly_row0, Kplus_poly_row1, Kplus_poly_row2, Kplus_poly_row3, Kplus_poly_row4, Kplus_poly_row5, Kplus_poly_row6, Kplus_poly_row7, Kplus_poly_row8, Kplus_poly_row9, Bplus_poly_2_0]
  try ring

theorem B_mul_Kplus_poly_2_1 :
    (B_poly * Kplus_poly) (2 : Fin 15) (1 : Fin 6) =
      Bplus_poly_2_1 := by
  simp [Matrix.mul_apply, Fin.sum_univ_succ, B_poly, Kplus_poly,
    Kplus_poly_row0, Kplus_poly_row1, Kplus_poly_row2, Kplus_poly_row3, Kplus_poly_row4, Kplus_poly_row5, Kplus_poly_row6, Kplus_poly_row7, Kplus_poly_row8, Kplus_poly_row9, Bplus_poly_2_1]
  try ring

theorem B_mul_Kplus_poly_2_2 :
    (B_poly * Kplus_poly) (2 : Fin 15) (2 : Fin 6) =
      Bplus_poly_2_2 := by
  simp [Matrix.mul_apply, Fin.sum_univ_succ, B_poly, Kplus_poly,
    Kplus_poly_row0, Kplus_poly_row1, Kplus_poly_row2, Kplus_poly_row3, Kplus_poly_row4, Kplus_poly_row5, Kplus_poly_row6, Kplus_poly_row7, Kplus_poly_row8, Kplus_poly_row9, Bplus_poly_2_2]
  try ring

theorem B_mul_Kplus_poly_2_3 :
    (B_poly * Kplus_poly) (2 : Fin 15) (3 : Fin 6) =
      Bplus_poly_2_3 := by
  simp [Matrix.mul_apply, Fin.sum_univ_succ, B_poly, Kplus_poly,
    Kplus_poly_row0, Kplus_poly_row1, Kplus_poly_row2, Kplus_poly_row3, Kplus_poly_row4, Kplus_poly_row5, Kplus_poly_row6, Kplus_poly_row7, Kplus_poly_row8, Kplus_poly_row9, Bplus_poly_2_3]
  try ring

theorem B_mul_Kplus_poly_2_4 :
    (B_poly * Kplus_poly) (2 : Fin 15) (4 : Fin 6) =
      Bplus_poly_2_4 := by
  simp [Matrix.mul_apply, Fin.sum_univ_succ, B_poly, Kplus_poly,
    Kplus_poly_row0, Kplus_poly_row1, Kplus_poly_row2, Kplus_poly_row3, Kplus_poly_row4, Kplus_poly_row5, Kplus_poly_row6, Kplus_poly_row7, Kplus_poly_row8, Kplus_poly_row9, Bplus_poly_2_4]
  try ring

theorem B_mul_Kplus_poly_2_5 :
    (B_poly * Kplus_poly) (2 : Fin 15) (5 : Fin 6) =
      Bplus_poly_2_5 := by
  simp [Matrix.mul_apply, Fin.sum_univ_succ, B_poly, Kplus_poly,
    Kplus_poly_row0, Kplus_poly_row1, Kplus_poly_row2, Kplus_poly_row3, Kplus_poly_row4, Kplus_poly_row5, Kplus_poly_row6, Kplus_poly_row7, Kplus_poly_row8, Kplus_poly_row9, Bplus_poly_2_5]
  try ring

theorem B_mul_Kplus_poly_3_0 :
    (B_poly * Kplus_poly) (3 : Fin 15) (0 : Fin 6) =
      Bplus_poly_3_0 := by
  simp [Matrix.mul_apply, Fin.sum_univ_succ, B_poly, Kplus_poly,
    Kplus_poly_row0, Kplus_poly_row1, Kplus_poly_row2, Kplus_poly_row3, Kplus_poly_row4, Kplus_poly_row5, Kplus_poly_row6, Kplus_poly_row7, Kplus_poly_row8, Kplus_poly_row9, Bplus_poly_3_0]
  try ring

theorem B_mul_Kplus_poly_3_1 :
    (B_poly * Kplus_poly) (3 : Fin 15) (1 : Fin 6) =
      Bplus_poly_3_1 := by
  simp [Matrix.mul_apply, Fin.sum_univ_succ, B_poly, Kplus_poly,
    Kplus_poly_row0, Kplus_poly_row1, Kplus_poly_row2, Kplus_poly_row3, Kplus_poly_row4, Kplus_poly_row5, Kplus_poly_row6, Kplus_poly_row7, Kplus_poly_row8, Kplus_poly_row9, Bplus_poly_3_1]
  try ring

theorem B_mul_Kplus_poly_3_2 :
    (B_poly * Kplus_poly) (3 : Fin 15) (2 : Fin 6) =
      Bplus_poly_3_2 := by
  simp [Matrix.mul_apply, Fin.sum_univ_succ, B_poly, Kplus_poly,
    Kplus_poly_row0, Kplus_poly_row1, Kplus_poly_row2, Kplus_poly_row3, Kplus_poly_row4, Kplus_poly_row5, Kplus_poly_row6, Kplus_poly_row7, Kplus_poly_row8, Kplus_poly_row9, Bplus_poly_3_2]
  try ring

theorem B_mul_Kplus_poly_3_3 :
    (B_poly * Kplus_poly) (3 : Fin 15) (3 : Fin 6) =
      Bplus_poly_3_3 := by
  simp [Matrix.mul_apply, Fin.sum_univ_succ, B_poly, Kplus_poly,
    Kplus_poly_row0, Kplus_poly_row1, Kplus_poly_row2, Kplus_poly_row3, Kplus_poly_row4, Kplus_poly_row5, Kplus_poly_row6, Kplus_poly_row7, Kplus_poly_row8, Kplus_poly_row9, Bplus_poly_3_3]
  try ring

theorem B_mul_Kplus_poly_3_4 :
    (B_poly * Kplus_poly) (3 : Fin 15) (4 : Fin 6) =
      Bplus_poly_3_4 := by
  simp [Matrix.mul_apply, Fin.sum_univ_succ, B_poly, Kplus_poly,
    Kplus_poly_row0, Kplus_poly_row1, Kplus_poly_row2, Kplus_poly_row3, Kplus_poly_row4, Kplus_poly_row5, Kplus_poly_row6, Kplus_poly_row7, Kplus_poly_row8, Kplus_poly_row9, Bplus_poly_3_4]
  try ring

theorem B_mul_Kplus_poly_3_5 :
    (B_poly * Kplus_poly) (3 : Fin 15) (5 : Fin 6) =
      Bplus_poly_3_5 := by
  simp [Matrix.mul_apply, Fin.sum_univ_succ, B_poly, Kplus_poly,
    Kplus_poly_row0, Kplus_poly_row1, Kplus_poly_row2, Kplus_poly_row3, Kplus_poly_row4, Kplus_poly_row5, Kplus_poly_row6, Kplus_poly_row7, Kplus_poly_row8, Kplus_poly_row9, Bplus_poly_3_5]
  try ring

theorem B_mul_Kplus_poly_4_0 :
    (B_poly * Kplus_poly) (4 : Fin 15) (0 : Fin 6) =
      Bplus_poly_4_0 := by
  simp [Matrix.mul_apply, Fin.sum_univ_succ, B_poly, Kplus_poly,
    Kplus_poly_row0, Kplus_poly_row1, Kplus_poly_row2, Kplus_poly_row3, Kplus_poly_row4, Kplus_poly_row5, Kplus_poly_row6, Kplus_poly_row7, Kplus_poly_row8, Kplus_poly_row9, Bplus_poly_4_0]
  try ring

theorem B_mul_Kplus_poly_4_1 :
    (B_poly * Kplus_poly) (4 : Fin 15) (1 : Fin 6) =
      Bplus_poly_4_1 := by
  simp [Matrix.mul_apply, Fin.sum_univ_succ, B_poly, Kplus_poly,
    Kplus_poly_row0, Kplus_poly_row1, Kplus_poly_row2, Kplus_poly_row3, Kplus_poly_row4, Kplus_poly_row5, Kplus_poly_row6, Kplus_poly_row7, Kplus_poly_row8, Kplus_poly_row9, Bplus_poly_4_1]
  try ring

theorem B_mul_Kplus_poly_4_2 :
    (B_poly * Kplus_poly) (4 : Fin 15) (2 : Fin 6) =
      Bplus_poly_4_2 := by
  simp [Matrix.mul_apply, Fin.sum_univ_succ, B_poly, Kplus_poly,
    Kplus_poly_row0, Kplus_poly_row1, Kplus_poly_row2, Kplus_poly_row3, Kplus_poly_row4, Kplus_poly_row5, Kplus_poly_row6, Kplus_poly_row7, Kplus_poly_row8, Kplus_poly_row9, Bplus_poly_4_2]
  try ring

theorem B_mul_Kplus_poly_4_3 :
    (B_poly * Kplus_poly) (4 : Fin 15) (3 : Fin 6) =
      Bplus_poly_4_3 := by
  simp [Matrix.mul_apply, Fin.sum_univ_succ, B_poly, Kplus_poly,
    Kplus_poly_row0, Kplus_poly_row1, Kplus_poly_row2, Kplus_poly_row3, Kplus_poly_row4, Kplus_poly_row5, Kplus_poly_row6, Kplus_poly_row7, Kplus_poly_row8, Kplus_poly_row9, Bplus_poly_4_3]
  try ring

theorem B_mul_Kplus_poly_4_4 :
    (B_poly * Kplus_poly) (4 : Fin 15) (4 : Fin 6) =
      Bplus_poly_4_4 := by
  simp [Matrix.mul_apply, Fin.sum_univ_succ, B_poly, Kplus_poly,
    Kplus_poly_row0, Kplus_poly_row1, Kplus_poly_row2, Kplus_poly_row3, Kplus_poly_row4, Kplus_poly_row5, Kplus_poly_row6, Kplus_poly_row7, Kplus_poly_row8, Kplus_poly_row9, Bplus_poly_4_4]
  try ring

theorem B_mul_Kplus_poly_4_5 :
    (B_poly * Kplus_poly) (4 : Fin 15) (5 : Fin 6) =
      Bplus_poly_4_5 := by
  simp [Matrix.mul_apply, Fin.sum_univ_succ, B_poly, Kplus_poly,
    Kplus_poly_row0, Kplus_poly_row1, Kplus_poly_row2, Kplus_poly_row3, Kplus_poly_row4, Kplus_poly_row5, Kplus_poly_row6, Kplus_poly_row7, Kplus_poly_row8, Kplus_poly_row9, Bplus_poly_4_5]
  try ring

theorem B_mul_Kplus_poly_5_0 :
    (B_poly * Kplus_poly) (5 : Fin 15) (0 : Fin 6) =
      Bplus_poly_5_0 := by
  simp [Matrix.mul_apply, Fin.sum_univ_succ, B_poly, Kplus_poly,
    Kplus_poly_row0, Kplus_poly_row1, Kplus_poly_row2, Kplus_poly_row3, Kplus_poly_row4, Kplus_poly_row5, Kplus_poly_row6, Kplus_poly_row7, Kplus_poly_row8, Kplus_poly_row9, Bplus_poly_5_0]
  try ring

theorem B_mul_Kplus_poly_5_1 :
    (B_poly * Kplus_poly) (5 : Fin 15) (1 : Fin 6) =
      Bplus_poly_5_1 := by
  simp [Matrix.mul_apply, Fin.sum_univ_succ, B_poly, Kplus_poly,
    Kplus_poly_row0, Kplus_poly_row1, Kplus_poly_row2, Kplus_poly_row3, Kplus_poly_row4, Kplus_poly_row5, Kplus_poly_row6, Kplus_poly_row7, Kplus_poly_row8, Kplus_poly_row9, Bplus_poly_5_1]
  try ring

theorem B_mul_Kplus_poly_5_2 :
    (B_poly * Kplus_poly) (5 : Fin 15) (2 : Fin 6) =
      Bplus_poly_5_2 := by
  simp [Matrix.mul_apply, Fin.sum_univ_succ, B_poly, Kplus_poly,
    Kplus_poly_row0, Kplus_poly_row1, Kplus_poly_row2, Kplus_poly_row3, Kplus_poly_row4, Kplus_poly_row5, Kplus_poly_row6, Kplus_poly_row7, Kplus_poly_row8, Kplus_poly_row9, Bplus_poly_5_2]
  try ring

theorem B_mul_Kplus_poly_5_3 :
    (B_poly * Kplus_poly) (5 : Fin 15) (3 : Fin 6) =
      Bplus_poly_5_3 := by
  simp [Matrix.mul_apply, Fin.sum_univ_succ, B_poly, Kplus_poly,
    Kplus_poly_row0, Kplus_poly_row1, Kplus_poly_row2, Kplus_poly_row3, Kplus_poly_row4, Kplus_poly_row5, Kplus_poly_row6, Kplus_poly_row7, Kplus_poly_row8, Kplus_poly_row9, Bplus_poly_5_3]
  try ring

theorem B_mul_Kplus_poly_5_4 :
    (B_poly * Kplus_poly) (5 : Fin 15) (4 : Fin 6) =
      Bplus_poly_5_4 := by
  simp [Matrix.mul_apply, Fin.sum_univ_succ, B_poly, Kplus_poly,
    Kplus_poly_row0, Kplus_poly_row1, Kplus_poly_row2, Kplus_poly_row3, Kplus_poly_row4, Kplus_poly_row5, Kplus_poly_row6, Kplus_poly_row7, Kplus_poly_row8, Kplus_poly_row9, Bplus_poly_5_4]
  try ring

theorem B_mul_Kplus_poly_5_5 :
    (B_poly * Kplus_poly) (5 : Fin 15) (5 : Fin 6) =
      Bplus_poly_5_5 := by
  simp [Matrix.mul_apply, Fin.sum_univ_succ, B_poly, Kplus_poly,
    Kplus_poly_row0, Kplus_poly_row1, Kplus_poly_row2, Kplus_poly_row3, Kplus_poly_row4, Kplus_poly_row5, Kplus_poly_row6, Kplus_poly_row7, Kplus_poly_row8, Kplus_poly_row9, Bplus_poly_5_5]
  try ring

theorem B_mul_Kplus_poly_6_0 :
    (B_poly * Kplus_poly) (6 : Fin 15) (0 : Fin 6) =
      Bplus_poly_6_0 := by
  simp [Matrix.mul_apply, Fin.sum_univ_succ, B_poly, Kplus_poly,
    Kplus_poly_row0, Kplus_poly_row1, Kplus_poly_row2, Kplus_poly_row3, Kplus_poly_row4, Kplus_poly_row5, Kplus_poly_row6, Kplus_poly_row7, Kplus_poly_row8, Kplus_poly_row9, Bplus_poly_6_0]
  try ring

theorem B_mul_Kplus_poly_6_1 :
    (B_poly * Kplus_poly) (6 : Fin 15) (1 : Fin 6) =
      Bplus_poly_6_1 := by
  simp [Matrix.mul_apply, Fin.sum_univ_succ, B_poly, Kplus_poly,
    Kplus_poly_row0, Kplus_poly_row1, Kplus_poly_row2, Kplus_poly_row3, Kplus_poly_row4, Kplus_poly_row5, Kplus_poly_row6, Kplus_poly_row7, Kplus_poly_row8, Kplus_poly_row9, Bplus_poly_6_1]
  try ring

theorem B_mul_Kplus_poly_6_2 :
    (B_poly * Kplus_poly) (6 : Fin 15) (2 : Fin 6) =
      Bplus_poly_6_2 := by
  simp [Matrix.mul_apply, Fin.sum_univ_succ, B_poly, Kplus_poly,
    Kplus_poly_row0, Kplus_poly_row1, Kplus_poly_row2, Kplus_poly_row3, Kplus_poly_row4, Kplus_poly_row5, Kplus_poly_row6, Kplus_poly_row7, Kplus_poly_row8, Kplus_poly_row9, Bplus_poly_6_2]
  try ring

theorem B_mul_Kplus_poly_6_3 :
    (B_poly * Kplus_poly) (6 : Fin 15) (3 : Fin 6) =
      Bplus_poly_6_3 := by
  simp [Matrix.mul_apply, Fin.sum_univ_succ, B_poly, Kplus_poly,
    Kplus_poly_row0, Kplus_poly_row1, Kplus_poly_row2, Kplus_poly_row3, Kplus_poly_row4, Kplus_poly_row5, Kplus_poly_row6, Kplus_poly_row7, Kplus_poly_row8, Kplus_poly_row9, Bplus_poly_6_3]
  try ring

theorem B_mul_Kplus_poly_6_4 :
    (B_poly * Kplus_poly) (6 : Fin 15) (4 : Fin 6) =
      Bplus_poly_6_4 := by
  simp [Matrix.mul_apply, Fin.sum_univ_succ, B_poly, Kplus_poly,
    Kplus_poly_row0, Kplus_poly_row1, Kplus_poly_row2, Kplus_poly_row3, Kplus_poly_row4, Kplus_poly_row5, Kplus_poly_row6, Kplus_poly_row7, Kplus_poly_row8, Kplus_poly_row9, Bplus_poly_6_4]
  try ring

theorem B_mul_Kplus_poly_6_5 :
    (B_poly * Kplus_poly) (6 : Fin 15) (5 : Fin 6) =
      Bplus_poly_6_5 := by
  simp [Matrix.mul_apply, Fin.sum_univ_succ, B_poly, Kplus_poly,
    Kplus_poly_row0, Kplus_poly_row1, Kplus_poly_row2, Kplus_poly_row3, Kplus_poly_row4, Kplus_poly_row5, Kplus_poly_row6, Kplus_poly_row7, Kplus_poly_row8, Kplus_poly_row9, Bplus_poly_6_5]
  try ring

theorem B_mul_Kplus_poly_7_0 :
    (B_poly * Kplus_poly) (7 : Fin 15) (0 : Fin 6) =
      Bplus_poly_7_0 := by
  simp [Matrix.mul_apply, Fin.sum_univ_succ, B_poly, Kplus_poly,
    Kplus_poly_row0, Kplus_poly_row1, Kplus_poly_row2, Kplus_poly_row3, Kplus_poly_row4, Kplus_poly_row5, Kplus_poly_row6, Kplus_poly_row7, Kplus_poly_row8, Kplus_poly_row9, Bplus_poly_7_0]
  try ring

theorem B_mul_Kplus_poly_7_1 :
    (B_poly * Kplus_poly) (7 : Fin 15) (1 : Fin 6) =
      Bplus_poly_7_1 := by
  simp [Matrix.mul_apply, Fin.sum_univ_succ, B_poly, Kplus_poly,
    Kplus_poly_row0, Kplus_poly_row1, Kplus_poly_row2, Kplus_poly_row3, Kplus_poly_row4, Kplus_poly_row5, Kplus_poly_row6, Kplus_poly_row7, Kplus_poly_row8, Kplus_poly_row9, Bplus_poly_7_1]
  try ring

theorem B_mul_Kplus_poly_7_2 :
    (B_poly * Kplus_poly) (7 : Fin 15) (2 : Fin 6) =
      Bplus_poly_7_2 := by
  simp [Matrix.mul_apply, Fin.sum_univ_succ, B_poly, Kplus_poly,
    Kplus_poly_row0, Kplus_poly_row1, Kplus_poly_row2, Kplus_poly_row3, Kplus_poly_row4, Kplus_poly_row5, Kplus_poly_row6, Kplus_poly_row7, Kplus_poly_row8, Kplus_poly_row9, Bplus_poly_7_2]
  try ring

theorem B_mul_Kplus_poly_7_3 :
    (B_poly * Kplus_poly) (7 : Fin 15) (3 : Fin 6) =
      Bplus_poly_7_3 := by
  simp [Matrix.mul_apply, Fin.sum_univ_succ, B_poly, Kplus_poly,
    Kplus_poly_row0, Kplus_poly_row1, Kplus_poly_row2, Kplus_poly_row3, Kplus_poly_row4, Kplus_poly_row5, Kplus_poly_row6, Kplus_poly_row7, Kplus_poly_row8, Kplus_poly_row9, Bplus_poly_7_3]
  try ring

theorem B_mul_Kplus_poly_7_4 :
    (B_poly * Kplus_poly) (7 : Fin 15) (4 : Fin 6) =
      Bplus_poly_7_4 := by
  simp [Matrix.mul_apply, Fin.sum_univ_succ, B_poly, Kplus_poly,
    Kplus_poly_row0, Kplus_poly_row1, Kplus_poly_row2, Kplus_poly_row3, Kplus_poly_row4, Kplus_poly_row5, Kplus_poly_row6, Kplus_poly_row7, Kplus_poly_row8, Kplus_poly_row9, Bplus_poly_7_4]
  try ring

theorem B_mul_Kplus_poly_7_5 :
    (B_poly * Kplus_poly) (7 : Fin 15) (5 : Fin 6) =
      Bplus_poly_7_5 := by
  simp [Matrix.mul_apply, Fin.sum_univ_succ, B_poly, Kplus_poly,
    Kplus_poly_row0, Kplus_poly_row1, Kplus_poly_row2, Kplus_poly_row3, Kplus_poly_row4, Kplus_poly_row5, Kplus_poly_row6, Kplus_poly_row7, Kplus_poly_row8, Kplus_poly_row9, Bplus_poly_7_5]
  try ring

theorem B_mul_Kplus_poly_8_0 :
    (B_poly * Kplus_poly) (8 : Fin 15) (0 : Fin 6) =
      Bplus_poly_8_0 := by
  simp [Matrix.mul_apply, Fin.sum_univ_succ, B_poly, Kplus_poly,
    Kplus_poly_row0, Kplus_poly_row1, Kplus_poly_row2, Kplus_poly_row3, Kplus_poly_row4, Kplus_poly_row5, Kplus_poly_row6, Kplus_poly_row7, Kplus_poly_row8, Kplus_poly_row9, Bplus_poly_8_0]
  try ring

theorem B_mul_Kplus_poly_8_1 :
    (B_poly * Kplus_poly) (8 : Fin 15) (1 : Fin 6) =
      Bplus_poly_8_1 := by
  simp [Matrix.mul_apply, Fin.sum_univ_succ, B_poly, Kplus_poly,
    Kplus_poly_row0, Kplus_poly_row1, Kplus_poly_row2, Kplus_poly_row3, Kplus_poly_row4, Kplus_poly_row5, Kplus_poly_row6, Kplus_poly_row7, Kplus_poly_row8, Kplus_poly_row9, Bplus_poly_8_1]
  try ring

theorem B_mul_Kplus_poly_8_2 :
    (B_poly * Kplus_poly) (8 : Fin 15) (2 : Fin 6) =
      Bplus_poly_8_2 := by
  simp [Matrix.mul_apply, Fin.sum_univ_succ, B_poly, Kplus_poly,
    Kplus_poly_row0, Kplus_poly_row1, Kplus_poly_row2, Kplus_poly_row3, Kplus_poly_row4, Kplus_poly_row5, Kplus_poly_row6, Kplus_poly_row7, Kplus_poly_row8, Kplus_poly_row9, Bplus_poly_8_2]
  try ring

theorem B_mul_Kplus_poly_8_3 :
    (B_poly * Kplus_poly) (8 : Fin 15) (3 : Fin 6) =
      Bplus_poly_8_3 := by
  simp [Matrix.mul_apply, Fin.sum_univ_succ, B_poly, Kplus_poly,
    Kplus_poly_row0, Kplus_poly_row1, Kplus_poly_row2, Kplus_poly_row3, Kplus_poly_row4, Kplus_poly_row5, Kplus_poly_row6, Kplus_poly_row7, Kplus_poly_row8, Kplus_poly_row9, Bplus_poly_8_3]
  try ring

theorem B_mul_Kplus_poly_8_4 :
    (B_poly * Kplus_poly) (8 : Fin 15) (4 : Fin 6) =
      Bplus_poly_8_4 := by
  simp [Matrix.mul_apply, Fin.sum_univ_succ, B_poly, Kplus_poly,
    Kplus_poly_row0, Kplus_poly_row1, Kplus_poly_row2, Kplus_poly_row3, Kplus_poly_row4, Kplus_poly_row5, Kplus_poly_row6, Kplus_poly_row7, Kplus_poly_row8, Kplus_poly_row9, Bplus_poly_8_4]
  try ring

theorem B_mul_Kplus_poly_8_5 :
    (B_poly * Kplus_poly) (8 : Fin 15) (5 : Fin 6) =
      Bplus_poly_8_5 := by
  simp [Matrix.mul_apply, Fin.sum_univ_succ, B_poly, Kplus_poly,
    Kplus_poly_row0, Kplus_poly_row1, Kplus_poly_row2, Kplus_poly_row3, Kplus_poly_row4, Kplus_poly_row5, Kplus_poly_row6, Kplus_poly_row7, Kplus_poly_row8, Kplus_poly_row9, Bplus_poly_8_5]
  try ring

theorem B_mul_Kplus_poly_9_0 :
    (B_poly * Kplus_poly) (9 : Fin 15) (0 : Fin 6) =
      Bplus_poly_9_0 := by
  simp [Matrix.mul_apply, Fin.sum_univ_succ, B_poly, Kplus_poly,
    Kplus_poly_row0, Kplus_poly_row1, Kplus_poly_row2, Kplus_poly_row3, Kplus_poly_row4, Kplus_poly_row5, Kplus_poly_row6, Kplus_poly_row7, Kplus_poly_row8, Kplus_poly_row9, Bplus_poly_9_0]
  try ring

theorem B_mul_Kplus_poly_9_1 :
    (B_poly * Kplus_poly) (9 : Fin 15) (1 : Fin 6) =
      Bplus_poly_9_1 := by
  simp [Matrix.mul_apply, Fin.sum_univ_succ, B_poly, Kplus_poly,
    Kplus_poly_row0, Kplus_poly_row1, Kplus_poly_row2, Kplus_poly_row3, Kplus_poly_row4, Kplus_poly_row5, Kplus_poly_row6, Kplus_poly_row7, Kplus_poly_row8, Kplus_poly_row9, Bplus_poly_9_1]
  try ring

theorem B_mul_Kplus_poly_9_2 :
    (B_poly * Kplus_poly) (9 : Fin 15) (2 : Fin 6) =
      Bplus_poly_9_2 := by
  simp [Matrix.mul_apply, Fin.sum_univ_succ, B_poly, Kplus_poly,
    Kplus_poly_row0, Kplus_poly_row1, Kplus_poly_row2, Kplus_poly_row3, Kplus_poly_row4, Kplus_poly_row5, Kplus_poly_row6, Kplus_poly_row7, Kplus_poly_row8, Kplus_poly_row9, Bplus_poly_9_2]
  try ring

theorem B_mul_Kplus_poly_9_3 :
    (B_poly * Kplus_poly) (9 : Fin 15) (3 : Fin 6) =
      Bplus_poly_9_3 := by
  simp [Matrix.mul_apply, Fin.sum_univ_succ, B_poly, Kplus_poly,
    Kplus_poly_row0, Kplus_poly_row1, Kplus_poly_row2, Kplus_poly_row3, Kplus_poly_row4, Kplus_poly_row5, Kplus_poly_row6, Kplus_poly_row7, Kplus_poly_row8, Kplus_poly_row9, Bplus_poly_9_3]
  try ring

theorem B_mul_Kplus_poly_9_4 :
    (B_poly * Kplus_poly) (9 : Fin 15) (4 : Fin 6) =
      Bplus_poly_9_4 := by
  simp [Matrix.mul_apply, Fin.sum_univ_succ, B_poly, Kplus_poly,
    Kplus_poly_row0, Kplus_poly_row1, Kplus_poly_row2, Kplus_poly_row3, Kplus_poly_row4, Kplus_poly_row5, Kplus_poly_row6, Kplus_poly_row7, Kplus_poly_row8, Kplus_poly_row9, Bplus_poly_9_4]
  try ring

theorem B_mul_Kplus_poly_9_5 :
    (B_poly * Kplus_poly) (9 : Fin 15) (5 : Fin 6) =
      Bplus_poly_9_5 := by
  simp [Matrix.mul_apply, Fin.sum_univ_succ, B_poly, Kplus_poly,
    Kplus_poly_row0, Kplus_poly_row1, Kplus_poly_row2, Kplus_poly_row3, Kplus_poly_row4, Kplus_poly_row5, Kplus_poly_row6, Kplus_poly_row7, Kplus_poly_row8, Kplus_poly_row9, Bplus_poly_9_5]
  try ring

theorem B_mul_Kplus_poly_10_0 :
    (B_poly * Kplus_poly) (10 : Fin 15) (0 : Fin 6) =
      Bplus_poly_10_0 := by
  simp [Matrix.mul_apply, Fin.sum_univ_succ, B_poly, Kplus_poly,
    Kplus_poly_row0, Kplus_poly_row1, Kplus_poly_row2, Kplus_poly_row3, Kplus_poly_row4, Kplus_poly_row5, Kplus_poly_row6, Kplus_poly_row7, Kplus_poly_row8, Kplus_poly_row9, Bplus_poly_10_0]
  try ring

theorem B_mul_Kplus_poly_10_1 :
    (B_poly * Kplus_poly) (10 : Fin 15) (1 : Fin 6) =
      Bplus_poly_10_1 := by
  simp [Matrix.mul_apply, Fin.sum_univ_succ, B_poly, Kplus_poly,
    Kplus_poly_row0, Kplus_poly_row1, Kplus_poly_row2, Kplus_poly_row3, Kplus_poly_row4, Kplus_poly_row5, Kplus_poly_row6, Kplus_poly_row7, Kplus_poly_row8, Kplus_poly_row9, Bplus_poly_10_1]
  try ring

theorem B_mul_Kplus_poly_10_2 :
    (B_poly * Kplus_poly) (10 : Fin 15) (2 : Fin 6) =
      Bplus_poly_10_2 := by
  simp [Matrix.mul_apply, Fin.sum_univ_succ, B_poly, Kplus_poly,
    Kplus_poly_row0, Kplus_poly_row1, Kplus_poly_row2, Kplus_poly_row3, Kplus_poly_row4, Kplus_poly_row5, Kplus_poly_row6, Kplus_poly_row7, Kplus_poly_row8, Kplus_poly_row9, Bplus_poly_10_2]
  try ring

theorem B_mul_Kplus_poly_10_3 :
    (B_poly * Kplus_poly) (10 : Fin 15) (3 : Fin 6) =
      Bplus_poly_10_3 := by
  simp [Matrix.mul_apply, Fin.sum_univ_succ, B_poly, Kplus_poly,
    Kplus_poly_row0, Kplus_poly_row1, Kplus_poly_row2, Kplus_poly_row3, Kplus_poly_row4, Kplus_poly_row5, Kplus_poly_row6, Kplus_poly_row7, Kplus_poly_row8, Kplus_poly_row9, Bplus_poly_10_3]
  try ring

theorem B_mul_Kplus_poly_10_4 :
    (B_poly * Kplus_poly) (10 : Fin 15) (4 : Fin 6) =
      Bplus_poly_10_4 := by
  simp [Matrix.mul_apply, Fin.sum_univ_succ, B_poly, Kplus_poly,
    Kplus_poly_row0, Kplus_poly_row1, Kplus_poly_row2, Kplus_poly_row3, Kplus_poly_row4, Kplus_poly_row5, Kplus_poly_row6, Kplus_poly_row7, Kplus_poly_row8, Kplus_poly_row9, Bplus_poly_10_4]
  try ring

theorem B_mul_Kplus_poly_10_5 :
    (B_poly * Kplus_poly) (10 : Fin 15) (5 : Fin 6) =
      Bplus_poly_10_5 := by
  simp [Matrix.mul_apply, Fin.sum_univ_succ, B_poly, Kplus_poly,
    Kplus_poly_row0, Kplus_poly_row1, Kplus_poly_row2, Kplus_poly_row3, Kplus_poly_row4, Kplus_poly_row5, Kplus_poly_row6, Kplus_poly_row7, Kplus_poly_row8, Kplus_poly_row9, Bplus_poly_10_5]
  try ring

theorem B_mul_Kplus_poly_11_0 :
    (B_poly * Kplus_poly) (11 : Fin 15) (0 : Fin 6) =
      Bplus_poly_11_0 := by
  simp [Matrix.mul_apply, Fin.sum_univ_succ, B_poly, Kplus_poly,
    Kplus_poly_row0, Kplus_poly_row1, Kplus_poly_row2, Kplus_poly_row3, Kplus_poly_row4, Kplus_poly_row5, Kplus_poly_row6, Kplus_poly_row7, Kplus_poly_row8, Kplus_poly_row9, Bplus_poly_11_0]
  try ring

theorem B_mul_Kplus_poly_11_1 :
    (B_poly * Kplus_poly) (11 : Fin 15) (1 : Fin 6) =
      Bplus_poly_11_1 := by
  simp [Matrix.mul_apply, Fin.sum_univ_succ, B_poly, Kplus_poly,
    Kplus_poly_row0, Kplus_poly_row1, Kplus_poly_row2, Kplus_poly_row3, Kplus_poly_row4, Kplus_poly_row5, Kplus_poly_row6, Kplus_poly_row7, Kplus_poly_row8, Kplus_poly_row9, Bplus_poly_11_1]
  try ring

theorem B_mul_Kplus_poly_11_2 :
    (B_poly * Kplus_poly) (11 : Fin 15) (2 : Fin 6) =
      Bplus_poly_11_2 := by
  simp [Matrix.mul_apply, Fin.sum_univ_succ, B_poly, Kplus_poly,
    Kplus_poly_row0, Kplus_poly_row1, Kplus_poly_row2, Kplus_poly_row3, Kplus_poly_row4, Kplus_poly_row5, Kplus_poly_row6, Kplus_poly_row7, Kplus_poly_row8, Kplus_poly_row9, Bplus_poly_11_2]
  try ring

theorem B_mul_Kplus_poly_11_3 :
    (B_poly * Kplus_poly) (11 : Fin 15) (3 : Fin 6) =
      Bplus_poly_11_3 := by
  simp [Matrix.mul_apply, Fin.sum_univ_succ, B_poly, Kplus_poly,
    Kplus_poly_row0, Kplus_poly_row1, Kplus_poly_row2, Kplus_poly_row3, Kplus_poly_row4, Kplus_poly_row5, Kplus_poly_row6, Kplus_poly_row7, Kplus_poly_row8, Kplus_poly_row9, Bplus_poly_11_3]
  try ring

theorem B_mul_Kplus_poly_11_4 :
    (B_poly * Kplus_poly) (11 : Fin 15) (4 : Fin 6) =
      Bplus_poly_11_4 := by
  simp [Matrix.mul_apply, Fin.sum_univ_succ, B_poly, Kplus_poly,
    Kplus_poly_row0, Kplus_poly_row1, Kplus_poly_row2, Kplus_poly_row3, Kplus_poly_row4, Kplus_poly_row5, Kplus_poly_row6, Kplus_poly_row7, Kplus_poly_row8, Kplus_poly_row9, Bplus_poly_11_4]
  try ring

theorem B_mul_Kplus_poly_11_5 :
    (B_poly * Kplus_poly) (11 : Fin 15) (5 : Fin 6) =
      Bplus_poly_11_5 := by
  simp [Matrix.mul_apply, Fin.sum_univ_succ, B_poly, Kplus_poly,
    Kplus_poly_row0, Kplus_poly_row1, Kplus_poly_row2, Kplus_poly_row3, Kplus_poly_row4, Kplus_poly_row5, Kplus_poly_row6, Kplus_poly_row7, Kplus_poly_row8, Kplus_poly_row9, Bplus_poly_11_5]
  try ring

theorem B_mul_Kplus_poly_12_0 :
    (B_poly * Kplus_poly) (12 : Fin 15) (0 : Fin 6) =
      Bplus_poly_12_0 := by
  simp [Matrix.mul_apply, Fin.sum_univ_succ, B_poly, Kplus_poly,
    Kplus_poly_row0, Kplus_poly_row1, Kplus_poly_row2, Kplus_poly_row3, Kplus_poly_row4, Kplus_poly_row5, Kplus_poly_row6, Kplus_poly_row7, Kplus_poly_row8, Kplus_poly_row9, Bplus_poly_12_0]
  try ring

theorem B_mul_Kplus_poly_12_1 :
    (B_poly * Kplus_poly) (12 : Fin 15) (1 : Fin 6) =
      Bplus_poly_12_1 := by
  simp [Matrix.mul_apply, Fin.sum_univ_succ, B_poly, Kplus_poly,
    Kplus_poly_row0, Kplus_poly_row1, Kplus_poly_row2, Kplus_poly_row3, Kplus_poly_row4, Kplus_poly_row5, Kplus_poly_row6, Kplus_poly_row7, Kplus_poly_row8, Kplus_poly_row9, Bplus_poly_12_1]
  try ring

theorem B_mul_Kplus_poly_12_2 :
    (B_poly * Kplus_poly) (12 : Fin 15) (2 : Fin 6) =
      Bplus_poly_12_2 := by
  simp [Matrix.mul_apply, Fin.sum_univ_succ, B_poly, Kplus_poly,
    Kplus_poly_row0, Kplus_poly_row1, Kplus_poly_row2, Kplus_poly_row3, Kplus_poly_row4, Kplus_poly_row5, Kplus_poly_row6, Kplus_poly_row7, Kplus_poly_row8, Kplus_poly_row9, Bplus_poly_12_2]
  try ring

theorem B_mul_Kplus_poly_12_3 :
    (B_poly * Kplus_poly) (12 : Fin 15) (3 : Fin 6) =
      Bplus_poly_12_3 := by
  simp [Matrix.mul_apply, Fin.sum_univ_succ, B_poly, Kplus_poly,
    Kplus_poly_row0, Kplus_poly_row1, Kplus_poly_row2, Kplus_poly_row3, Kplus_poly_row4, Kplus_poly_row5, Kplus_poly_row6, Kplus_poly_row7, Kplus_poly_row8, Kplus_poly_row9, Bplus_poly_12_3]
  try ring

theorem B_mul_Kplus_poly_12_4 :
    (B_poly * Kplus_poly) (12 : Fin 15) (4 : Fin 6) =
      Bplus_poly_12_4 := by
  simp [Matrix.mul_apply, Fin.sum_univ_succ, B_poly, Kplus_poly,
    Kplus_poly_row0, Kplus_poly_row1, Kplus_poly_row2, Kplus_poly_row3, Kplus_poly_row4, Kplus_poly_row5, Kplus_poly_row6, Kplus_poly_row7, Kplus_poly_row8, Kplus_poly_row9, Bplus_poly_12_4]
  try ring

theorem B_mul_Kplus_poly_12_5 :
    (B_poly * Kplus_poly) (12 : Fin 15) (5 : Fin 6) =
      Bplus_poly_12_5 := by
  simp [Matrix.mul_apply, Fin.sum_univ_succ, B_poly, Kplus_poly,
    Kplus_poly_row0, Kplus_poly_row1, Kplus_poly_row2, Kplus_poly_row3, Kplus_poly_row4, Kplus_poly_row5, Kplus_poly_row6, Kplus_poly_row7, Kplus_poly_row8, Kplus_poly_row9, Bplus_poly_12_5]
  try ring

theorem B_mul_Kplus_poly_13_0 :
    (B_poly * Kplus_poly) (13 : Fin 15) (0 : Fin 6) =
      Bplus_poly_13_0 := by
  simp [Matrix.mul_apply, Fin.sum_univ_succ, B_poly, Kplus_poly,
    Kplus_poly_row0, Kplus_poly_row1, Kplus_poly_row2, Kplus_poly_row3, Kplus_poly_row4, Kplus_poly_row5, Kplus_poly_row6, Kplus_poly_row7, Kplus_poly_row8, Kplus_poly_row9, Bplus_poly_13_0]
  try ring

theorem B_mul_Kplus_poly_13_1 :
    (B_poly * Kplus_poly) (13 : Fin 15) (1 : Fin 6) =
      Bplus_poly_13_1 := by
  simp [Matrix.mul_apply, Fin.sum_univ_succ, B_poly, Kplus_poly,
    Kplus_poly_row0, Kplus_poly_row1, Kplus_poly_row2, Kplus_poly_row3, Kplus_poly_row4, Kplus_poly_row5, Kplus_poly_row6, Kplus_poly_row7, Kplus_poly_row8, Kplus_poly_row9, Bplus_poly_13_1]
  try ring

theorem B_mul_Kplus_poly_13_2 :
    (B_poly * Kplus_poly) (13 : Fin 15) (2 : Fin 6) =
      Bplus_poly_13_2 := by
  simp [Matrix.mul_apply, Fin.sum_univ_succ, B_poly, Kplus_poly,
    Kplus_poly_row0, Kplus_poly_row1, Kplus_poly_row2, Kplus_poly_row3, Kplus_poly_row4, Kplus_poly_row5, Kplus_poly_row6, Kplus_poly_row7, Kplus_poly_row8, Kplus_poly_row9, Bplus_poly_13_2]
  try ring

theorem B_mul_Kplus_poly_13_3 :
    (B_poly * Kplus_poly) (13 : Fin 15) (3 : Fin 6) =
      Bplus_poly_13_3 := by
  simp [Matrix.mul_apply, Fin.sum_univ_succ, B_poly, Kplus_poly,
    Kplus_poly_row0, Kplus_poly_row1, Kplus_poly_row2, Kplus_poly_row3, Kplus_poly_row4, Kplus_poly_row5, Kplus_poly_row6, Kplus_poly_row7, Kplus_poly_row8, Kplus_poly_row9, Bplus_poly_13_3]
  try ring

theorem B_mul_Kplus_poly_13_4 :
    (B_poly * Kplus_poly) (13 : Fin 15) (4 : Fin 6) =
      Bplus_poly_13_4 := by
  simp [Matrix.mul_apply, Fin.sum_univ_succ, B_poly, Kplus_poly,
    Kplus_poly_row0, Kplus_poly_row1, Kplus_poly_row2, Kplus_poly_row3, Kplus_poly_row4, Kplus_poly_row5, Kplus_poly_row6, Kplus_poly_row7, Kplus_poly_row8, Kplus_poly_row9, Bplus_poly_13_4]
  try ring

theorem B_mul_Kplus_poly_13_5 :
    (B_poly * Kplus_poly) (13 : Fin 15) (5 : Fin 6) =
      Bplus_poly_13_5 := by
  simp [Matrix.mul_apply, Fin.sum_univ_succ, B_poly, Kplus_poly,
    Kplus_poly_row0, Kplus_poly_row1, Kplus_poly_row2, Kplus_poly_row3, Kplus_poly_row4, Kplus_poly_row5, Kplus_poly_row6, Kplus_poly_row7, Kplus_poly_row8, Kplus_poly_row9, Bplus_poly_13_5]
  try ring

theorem B_mul_Kplus_poly_14_0 :
    (B_poly * Kplus_poly) (14 : Fin 15) (0 : Fin 6) =
      Bplus_poly_14_0 := by
  simp [Matrix.mul_apply, Fin.sum_univ_succ, B_poly, Kplus_poly,
    Kplus_poly_row0, Kplus_poly_row1, Kplus_poly_row2, Kplus_poly_row3, Kplus_poly_row4, Kplus_poly_row5, Kplus_poly_row6, Kplus_poly_row7, Kplus_poly_row8, Kplus_poly_row9, Bplus_poly_14_0]
  try ring

theorem B_mul_Kplus_poly_14_1 :
    (B_poly * Kplus_poly) (14 : Fin 15) (1 : Fin 6) =
      Bplus_poly_14_1 := by
  simp [Matrix.mul_apply, Fin.sum_univ_succ, B_poly, Kplus_poly,
    Kplus_poly_row0, Kplus_poly_row1, Kplus_poly_row2, Kplus_poly_row3, Kplus_poly_row4, Kplus_poly_row5, Kplus_poly_row6, Kplus_poly_row7, Kplus_poly_row8, Kplus_poly_row9, Bplus_poly_14_1]
  try ring

theorem B_mul_Kplus_poly_14_2 :
    (B_poly * Kplus_poly) (14 : Fin 15) (2 : Fin 6) =
      Bplus_poly_14_2 := by
  simp [Matrix.mul_apply, Fin.sum_univ_succ, B_poly, Kplus_poly,
    Kplus_poly_row0, Kplus_poly_row1, Kplus_poly_row2, Kplus_poly_row3, Kplus_poly_row4, Kplus_poly_row5, Kplus_poly_row6, Kplus_poly_row7, Kplus_poly_row8, Kplus_poly_row9, Bplus_poly_14_2]
  try ring

theorem B_mul_Kplus_poly_14_3 :
    (B_poly * Kplus_poly) (14 : Fin 15) (3 : Fin 6) =
      Bplus_poly_14_3 := by
  simp [Matrix.mul_apply, Fin.sum_univ_succ, B_poly, Kplus_poly,
    Kplus_poly_row0, Kplus_poly_row1, Kplus_poly_row2, Kplus_poly_row3, Kplus_poly_row4, Kplus_poly_row5, Kplus_poly_row6, Kplus_poly_row7, Kplus_poly_row8, Kplus_poly_row9, Bplus_poly_14_3]
  try ring

theorem B_mul_Kplus_poly_14_4 :
    (B_poly * Kplus_poly) (14 : Fin 15) (4 : Fin 6) =
      Bplus_poly_14_4 := by
  simp [Matrix.mul_apply, Fin.sum_univ_succ, B_poly, Kplus_poly,
    Kplus_poly_row0, Kplus_poly_row1, Kplus_poly_row2, Kplus_poly_row3, Kplus_poly_row4, Kplus_poly_row5, Kplus_poly_row6, Kplus_poly_row7, Kplus_poly_row8, Kplus_poly_row9, Bplus_poly_14_4]
  try ring

theorem B_mul_Kplus_poly_14_5 :
    (B_poly * Kplus_poly) (14 : Fin 15) (5 : Fin 6) =
      Bplus_poly_14_5 := by
  simp [Matrix.mul_apply, Fin.sum_univ_succ, B_poly, Kplus_poly,
    Kplus_poly_row0, Kplus_poly_row1, Kplus_poly_row2, Kplus_poly_row3, Kplus_poly_row4, Kplus_poly_row5, Kplus_poly_row6, Kplus_poly_row7, Kplus_poly_row8, Kplus_poly_row9, Bplus_poly_14_5]
  try ring

theorem B_mul_Kplus_row0 (j : Fin 6) :
    (B_poly * Kplus_poly) (⟨0, by decide⟩ : Fin 15) j =
      Bplus_poly (⟨0, by decide⟩ : Fin 15) j := by
  fin_cases j <;>
    simp [Bplus_poly_apply_0_0, Bplus_poly_apply_0_1, Bplus_poly_apply_0_2, Bplus_poly_apply_0_3, Bplus_poly_apply_0_4, Bplus_poly_apply_0_5, B_mul_Kplus_poly_0_0, B_mul_Kplus_poly_0_1, B_mul_Kplus_poly_0_2, B_mul_Kplus_poly_0_3, B_mul_Kplus_poly_0_4, B_mul_Kplus_poly_0_5]

theorem B_mul_Kplus_row1 (j : Fin 6) :
    (B_poly * Kplus_poly) (⟨1, by decide⟩ : Fin 15) j =
      Bplus_poly (⟨1, by decide⟩ : Fin 15) j := by
  fin_cases j <;>
    simp [Bplus_poly_apply_1_0, Bplus_poly_apply_1_1, Bplus_poly_apply_1_2, Bplus_poly_apply_1_3, Bplus_poly_apply_1_4, Bplus_poly_apply_1_5, B_mul_Kplus_poly_1_0, B_mul_Kplus_poly_1_1, B_mul_Kplus_poly_1_2, B_mul_Kplus_poly_1_3, B_mul_Kplus_poly_1_4, B_mul_Kplus_poly_1_5]

theorem B_mul_Kplus_row2 (j : Fin 6) :
    (B_poly * Kplus_poly) (⟨2, by decide⟩ : Fin 15) j =
      Bplus_poly (⟨2, by decide⟩ : Fin 15) j := by
  fin_cases j <;>
    simp [Bplus_poly_apply_2_0, Bplus_poly_apply_2_1, Bplus_poly_apply_2_2, Bplus_poly_apply_2_3, Bplus_poly_apply_2_4, Bplus_poly_apply_2_5, B_mul_Kplus_poly_2_0, B_mul_Kplus_poly_2_1, B_mul_Kplus_poly_2_2, B_mul_Kplus_poly_2_3, B_mul_Kplus_poly_2_4, B_mul_Kplus_poly_2_5]

theorem B_mul_Kplus_row3 (j : Fin 6) :
    (B_poly * Kplus_poly) (⟨3, by decide⟩ : Fin 15) j =
      Bplus_poly (⟨3, by decide⟩ : Fin 15) j := by
  fin_cases j <;>
    simp [Bplus_poly_apply_3_0, Bplus_poly_apply_3_1, Bplus_poly_apply_3_2, Bplus_poly_apply_3_3, Bplus_poly_apply_3_4, Bplus_poly_apply_3_5, B_mul_Kplus_poly_3_0, B_mul_Kplus_poly_3_1, B_mul_Kplus_poly_3_2, B_mul_Kplus_poly_3_3, B_mul_Kplus_poly_3_4, B_mul_Kplus_poly_3_5]

theorem B_mul_Kplus_row4 (j : Fin 6) :
    (B_poly * Kplus_poly) (⟨4, by decide⟩ : Fin 15) j =
      Bplus_poly (⟨4, by decide⟩ : Fin 15) j := by
  fin_cases j <;>
    simp [Bplus_poly_apply_4_0, Bplus_poly_apply_4_1, Bplus_poly_apply_4_2, Bplus_poly_apply_4_3, Bplus_poly_apply_4_4, Bplus_poly_apply_4_5, B_mul_Kplus_poly_4_0, B_mul_Kplus_poly_4_1, B_mul_Kplus_poly_4_2, B_mul_Kplus_poly_4_3, B_mul_Kplus_poly_4_4, B_mul_Kplus_poly_4_5]

theorem B_mul_Kplus_row5 (j : Fin 6) :
    (B_poly * Kplus_poly) (⟨5, by decide⟩ : Fin 15) j =
      Bplus_poly (⟨5, by decide⟩ : Fin 15) j := by
  fin_cases j <;>
    simp [Bplus_poly_apply_5_0, Bplus_poly_apply_5_1, Bplus_poly_apply_5_2, Bplus_poly_apply_5_3, Bplus_poly_apply_5_4, Bplus_poly_apply_5_5, B_mul_Kplus_poly_5_0, B_mul_Kplus_poly_5_1, B_mul_Kplus_poly_5_2, B_mul_Kplus_poly_5_3, B_mul_Kplus_poly_5_4, B_mul_Kplus_poly_5_5]

theorem B_mul_Kplus_row6 (j : Fin 6) :
    (B_poly * Kplus_poly) (⟨6, by decide⟩ : Fin 15) j =
      Bplus_poly (⟨6, by decide⟩ : Fin 15) j := by
  fin_cases j <;>
    simp [Bplus_poly_apply_6_0, Bplus_poly_apply_6_1, Bplus_poly_apply_6_2, Bplus_poly_apply_6_3, Bplus_poly_apply_6_4, Bplus_poly_apply_6_5, B_mul_Kplus_poly_6_0, B_mul_Kplus_poly_6_1, B_mul_Kplus_poly_6_2, B_mul_Kplus_poly_6_3, B_mul_Kplus_poly_6_4, B_mul_Kplus_poly_6_5]

theorem B_mul_Kplus_row7 (j : Fin 6) :
    (B_poly * Kplus_poly) (⟨7, by decide⟩ : Fin 15) j =
      Bplus_poly (⟨7, by decide⟩ : Fin 15) j := by
  fin_cases j <;>
    simp [Bplus_poly_apply_7_0, Bplus_poly_apply_7_1, Bplus_poly_apply_7_2, Bplus_poly_apply_7_3, Bplus_poly_apply_7_4, Bplus_poly_apply_7_5, B_mul_Kplus_poly_7_0, B_mul_Kplus_poly_7_1, B_mul_Kplus_poly_7_2, B_mul_Kplus_poly_7_3, B_mul_Kplus_poly_7_4, B_mul_Kplus_poly_7_5]

theorem B_mul_Kplus_row8 (j : Fin 6) :
    (B_poly * Kplus_poly) (⟨8, by decide⟩ : Fin 15) j =
      Bplus_poly (⟨8, by decide⟩ : Fin 15) j := by
  fin_cases j <;>
    simp [Bplus_poly_apply_8_0, Bplus_poly_apply_8_1, Bplus_poly_apply_8_2, Bplus_poly_apply_8_3, Bplus_poly_apply_8_4, Bplus_poly_apply_8_5, B_mul_Kplus_poly_8_0, B_mul_Kplus_poly_8_1, B_mul_Kplus_poly_8_2, B_mul_Kplus_poly_8_3, B_mul_Kplus_poly_8_4, B_mul_Kplus_poly_8_5]

theorem B_mul_Kplus_row9 (j : Fin 6) :
    (B_poly * Kplus_poly) (⟨9, by decide⟩ : Fin 15) j =
      Bplus_poly (⟨9, by decide⟩ : Fin 15) j := by
  fin_cases j <;>
    simp [Bplus_poly_apply_9_0, Bplus_poly_apply_9_1, Bplus_poly_apply_9_2, Bplus_poly_apply_9_3, Bplus_poly_apply_9_4, Bplus_poly_apply_9_5, B_mul_Kplus_poly_9_0, B_mul_Kplus_poly_9_1, B_mul_Kplus_poly_9_2, B_mul_Kplus_poly_9_3, B_mul_Kplus_poly_9_4, B_mul_Kplus_poly_9_5]

theorem B_mul_Kplus_row10 (j : Fin 6) :
    (B_poly * Kplus_poly) (⟨10, by decide⟩ : Fin 15) j =
      Bplus_poly (⟨10, by decide⟩ : Fin 15) j := by
  fin_cases j <;>
    simp [Bplus_poly_apply_10_0, Bplus_poly_apply_10_1, Bplus_poly_apply_10_2, Bplus_poly_apply_10_3, Bplus_poly_apply_10_4, Bplus_poly_apply_10_5, B_mul_Kplus_poly_10_0, B_mul_Kplus_poly_10_1, B_mul_Kplus_poly_10_2, B_mul_Kplus_poly_10_3, B_mul_Kplus_poly_10_4, B_mul_Kplus_poly_10_5]

theorem B_mul_Kplus_row11 (j : Fin 6) :
    (B_poly * Kplus_poly) (⟨11, by decide⟩ : Fin 15) j =
      Bplus_poly (⟨11, by decide⟩ : Fin 15) j := by
  fin_cases j <;>
    simp [Bplus_poly_apply_11_0, Bplus_poly_apply_11_1, Bplus_poly_apply_11_2, Bplus_poly_apply_11_3, Bplus_poly_apply_11_4, Bplus_poly_apply_11_5, B_mul_Kplus_poly_11_0, B_mul_Kplus_poly_11_1, B_mul_Kplus_poly_11_2, B_mul_Kplus_poly_11_3, B_mul_Kplus_poly_11_4, B_mul_Kplus_poly_11_5]

theorem B_mul_Kplus_row12 (j : Fin 6) :
    (B_poly * Kplus_poly) (⟨12, by decide⟩ : Fin 15) j =
      Bplus_poly (⟨12, by decide⟩ : Fin 15) j := by
  fin_cases j <;>
    simp [Bplus_poly_apply_12_0, Bplus_poly_apply_12_1, Bplus_poly_apply_12_2, Bplus_poly_apply_12_3, Bplus_poly_apply_12_4, Bplus_poly_apply_12_5, B_mul_Kplus_poly_12_0, B_mul_Kplus_poly_12_1, B_mul_Kplus_poly_12_2, B_mul_Kplus_poly_12_3, B_mul_Kplus_poly_12_4, B_mul_Kplus_poly_12_5]

theorem B_mul_Kplus_row13 (j : Fin 6) :
    (B_poly * Kplus_poly) (⟨13, by decide⟩ : Fin 15) j =
      Bplus_poly (⟨13, by decide⟩ : Fin 15) j := by
  fin_cases j <;>
    simp [Bplus_poly_apply_13_0, Bplus_poly_apply_13_1, Bplus_poly_apply_13_2, Bplus_poly_apply_13_3, Bplus_poly_apply_13_4, Bplus_poly_apply_13_5, B_mul_Kplus_poly_13_0, B_mul_Kplus_poly_13_1, B_mul_Kplus_poly_13_2, B_mul_Kplus_poly_13_3, B_mul_Kplus_poly_13_4, B_mul_Kplus_poly_13_5]

theorem B_mul_Kplus_row14 (j : Fin 6) :
    (B_poly * Kplus_poly) (⟨14, by decide⟩ : Fin 15) j =
      Bplus_poly (⟨14, by decide⟩ : Fin 15) j := by
  fin_cases j <;>
    simp [Bplus_poly_apply_14_0, Bplus_poly_apply_14_1, Bplus_poly_apply_14_2, Bplus_poly_apply_14_3, Bplus_poly_apply_14_4, Bplus_poly_apply_14_5, B_mul_Kplus_poly_14_0, B_mul_Kplus_poly_14_1, B_mul_Kplus_poly_14_2, B_mul_Kplus_poly_14_3, B_mul_Kplus_poly_14_4, B_mul_Kplus_poly_14_5]

theorem B_mul_Kplus_poly : B_poly * Kplus_poly = Bplus_poly := by
  apply Matrix.ext
  intro i j
  fin_cases i
  · exact B_mul_Kplus_row0 j
  · exact B_mul_Kplus_row1 j
  · exact B_mul_Kplus_row2 j
  · exact B_mul_Kplus_row3 j
  · exact B_mul_Kplus_row4 j
  · exact B_mul_Kplus_row5 j
  · exact B_mul_Kplus_row6 j
  · exact B_mul_Kplus_row7 j
  · exact B_mul_Kplus_row8 j
  · exact B_mul_Kplus_row9 j
  · exact B_mul_Kplus_row10 j
  · exact B_mul_Kplus_row11 j
  · exact B_mul_Kplus_row12 j
  · exact B_mul_Kplus_row13 j
  · exact B_mul_Kplus_row14 j

theorem evalMatrixK_Bplus_poly :
    evalMatrixK Bplus_poly = D12SigmaCarrierConcrete.core.Bplus := by
  rw [← B_mul_Kplus_poly]
  change evalMatrixAt WeilRep.ζ (B_poly * Kplus_poly) = _
  rw [evalMatrixAt_mul]
  rfl

def BplusKi : Matrix (Fin 15) (Fin 6) Ki :=
  (D12SigmaCarrierConcrete.core.Bplus).map (algebraMap k Ki)

theorem BplusKi_eq_map_eval :
    BplusKi = (evalMatrixK Bplus_poly).map (algebraMap k Ki) := by
  rw [BplusKi, evalMatrixK_Bplus_poly]

theorem restrictedPluckerCoeffs_BplusKi_map (q : Fin 15) :
    restrictedPluckerCoeffs BplusKi q =
      fun m => algebraMap k Ki
        (restrictedPluckerCoeffs (evalMatrixK Bplus_poly) q m) := by
  rw [BplusKi_eq_map_eval]
  exact restrictedPluckerCoeffs_map (algebraMap k Ki)
    (evalMatrixK Bplus_poly) q

theorem restrictedPluckerCoeffs_evalMatrixK (q : Fin 15) :
    restrictedPluckerCoeffs (evalMatrixK Bplus_poly) q =
      fun m => ofPoly (restrictedPluckerCoeffs Bplus_poly q m) := by
  simpa [evalMatrixK, evalMatrixAt, ofPoly] using
    restrictedPluckerCoeffs_map (evalPolyAt WeilRep.ζ) Bplus_poly q

end V14Formalization.D12SigmaPlusSegreCore
