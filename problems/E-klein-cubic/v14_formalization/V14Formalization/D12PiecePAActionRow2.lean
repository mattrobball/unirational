/- PA character-stack identification, row 2. Auto-generated. -/
module

public import V14Formalization.D12PiecePAData

noncomputable section
namespace V14Formalization.D12PiecePAActionRow2
open D12CyclotomicVec D12PieceVecBase D12PiecePAData

theorem entry0 :
    AVec (2 : Fin 20) (0 : Fin 10) =
      characterStackVec RMVec SMVec 1 (-1)
        (2 : Fin 20) (0 : Fin 10) := by
  rw [AVec_apply_2_0, characterStackVec_apply_2_0]
  funext n
  fin_cases n <;>
    norm_num [ACell2_0_def, RMVec, RMVecRow2,
      D12PolynomialData.RM2c0, constVec, basis]

theorem entry1 :
    AVec (2 : Fin 20) (1 : Fin 10) =
      characterStackVec RMVec SMVec 1 (-1)
        (2 : Fin 20) (1 : Fin 10) := by
  rw [AVec_apply_2_1, characterStackVec_apply_2_1]
  funext n
  fin_cases n <;>
    norm_num [ACell2_1_def, RMVec, RMVecRow2,
      D12PolynomialData.RM2c1, constVec, basis]

theorem entry2 :
    AVec (2 : Fin 20) (2 : Fin 10) =
      characterStackVec RMVec SMVec 1 (-1)
        (2 : Fin 20) (2 : Fin 10) := by
  rw [AVec_apply_2_2, characterStackVec_apply_2_2]
  funext n
  fin_cases n <;>
    norm_num [ACell2_2_def, RMVec, RMVecRow2,
      D12PolynomialData.RM2c2, constVec, basis]

theorem entry3 :
    AVec (2 : Fin 20) (3 : Fin 10) =
      characterStackVec RMVec SMVec 1 (-1)
        (2 : Fin 20) (3 : Fin 10) := by
  rw [AVec_apply_2_3, characterStackVec_apply_2_3]
  funext n
  fin_cases n <;>
    norm_num [ACell2_3_def, RMVec, RMVecRow2,
      D12PolynomialData.RM2c3, constVec, basis]

theorem entry4 :
    AVec (2 : Fin 20) (4 : Fin 10) =
      characterStackVec RMVec SMVec 1 (-1)
        (2 : Fin 20) (4 : Fin 10) := by
  rw [AVec_apply_2_4, characterStackVec_apply_2_4]
  funext n
  fin_cases n <;>
    norm_num [ACell2_4_def, RMVec, RMVecRow2,
      D12PolynomialData.RM2c4, constVec, basis]

theorem entry5 :
    AVec (2 : Fin 20) (5 : Fin 10) =
      characterStackVec RMVec SMVec 1 (-1)
        (2 : Fin 20) (5 : Fin 10) := by
  rw [AVec_apply_2_5, characterStackVec_apply_2_5]
  funext n
  fin_cases n <;>
    norm_num [ACell2_5_def, RMVec, RMVecRow2,
      D12PolynomialData.RM2c5, constVec, basis]

theorem entry6 :
    AVec (2 : Fin 20) (6 : Fin 10) =
      characterStackVec RMVec SMVec 1 (-1)
        (2 : Fin 20) (6 : Fin 10) := by
  rw [AVec_apply_2_6, characterStackVec_apply_2_6]
  funext n
  fin_cases n <;>
    norm_num [ACell2_6_def, RMVec, RMVecRow2,
      D12PolynomialData.RM2c6, constVec, basis]

theorem entry7 :
    AVec (2 : Fin 20) (7 : Fin 10) =
      characterStackVec RMVec SMVec 1 (-1)
        (2 : Fin 20) (7 : Fin 10) := by
  rw [AVec_apply_2_7, characterStackVec_apply_2_7]
  funext n
  fin_cases n <;>
    norm_num [ACell2_7_def, RMVec, RMVecRow2,
      D12PolynomialData.RM2c7, constVec, basis]

theorem entry8 :
    AVec (2 : Fin 20) (8 : Fin 10) =
      characterStackVec RMVec SMVec 1 (-1)
        (2 : Fin 20) (8 : Fin 10) := by
  rw [AVec_apply_2_8, characterStackVec_apply_2_8]
  funext n
  fin_cases n <;>
    norm_num [ACell2_8_def, RMVec, RMVecRow2,
      D12PolynomialData.RM2c8, constVec, basis]

theorem entry9 :
    AVec (2 : Fin 20) (9 : Fin 10) =
      characterStackVec RMVec SMVec 1 (-1)
        (2 : Fin 20) (9 : Fin 10) := by
  rw [AVec_apply_2_9, characterStackVec_apply_2_9]
  funext n
  fin_cases n <;>
    norm_num [ACell2_9_def, RMVec, RMVecRow2,
      D12PolynomialData.RM2c9, constVec, basis]

public theorem row_eq (j : Fin 10) :
    AVec (2 : Fin 20) j =
      characterStackVec RMVec SMVec 1 (-1) (2 : Fin 20) j := by
  fin_cases j
  · exact entry0
  · exact entry1
  · exact entry2
  · exact entry3
  · exact entry4
  · exact entry5
  · exact entry6
  · exact entry7
  · exact entry8
  · exact entry9

end V14Formalization.D12PiecePAActionRow2
