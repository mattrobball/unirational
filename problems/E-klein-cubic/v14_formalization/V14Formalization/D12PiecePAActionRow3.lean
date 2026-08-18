/- PA character-stack identification, row 3. Auto-generated. -/
module

public import V14Formalization.D12PiecePAData

noncomputable section
namespace V14Formalization.D12PiecePAActionRow3
open D12CyclotomicVec D12PieceVecBase D12PiecePAData

theorem entry0 :
    AVec (3 : Fin 20) (0 : Fin 10) =
      characterStackVec RMVec SMVec 1 (-1)
        (3 : Fin 20) (0 : Fin 10) := by
  rw [AVec_apply_3_0, characterStackVec_apply_3_0]
  funext n
  fin_cases n <;>
    norm_num [ACell3_0_def, RMVec, RMVecRow3,
      D12PolynomialData.RM3c0, constVec, basis]

theorem entry1 :
    AVec (3 : Fin 20) (1 : Fin 10) =
      characterStackVec RMVec SMVec 1 (-1)
        (3 : Fin 20) (1 : Fin 10) := by
  rw [AVec_apply_3_1, characterStackVec_apply_3_1]
  funext n
  fin_cases n <;>
    norm_num [ACell3_1_def, RMVec, RMVecRow3,
      D12PolynomialData.RM3c1, constVec, basis]

theorem entry2 :
    AVec (3 : Fin 20) (2 : Fin 10) =
      characterStackVec RMVec SMVec 1 (-1)
        (3 : Fin 20) (2 : Fin 10) := by
  rw [AVec_apply_3_2, characterStackVec_apply_3_2]
  funext n
  fin_cases n <;>
    norm_num [ACell3_2_def, RMVec, RMVecRow3,
      D12PolynomialData.RM3c2, constVec, basis]

theorem entry3 :
    AVec (3 : Fin 20) (3 : Fin 10) =
      characterStackVec RMVec SMVec 1 (-1)
        (3 : Fin 20) (3 : Fin 10) := by
  rw [AVec_apply_3_3, characterStackVec_apply_3_3]
  funext n
  fin_cases n <;>
    norm_num [ACell3_3_def, RMVec, RMVecRow3,
      D12PolynomialData.RM3c3, constVec, basis]

theorem entry4 :
    AVec (3 : Fin 20) (4 : Fin 10) =
      characterStackVec RMVec SMVec 1 (-1)
        (3 : Fin 20) (4 : Fin 10) := by
  rw [AVec_apply_3_4, characterStackVec_apply_3_4]
  funext n
  fin_cases n <;>
    norm_num [ACell3_4_def, RMVec, RMVecRow3,
      D12PolynomialData.RM3c4, constVec, basis]

theorem entry5 :
    AVec (3 : Fin 20) (5 : Fin 10) =
      characterStackVec RMVec SMVec 1 (-1)
        (3 : Fin 20) (5 : Fin 10) := by
  rw [AVec_apply_3_5, characterStackVec_apply_3_5]
  funext n
  fin_cases n <;>
    norm_num [ACell3_5_def, RMVec, RMVecRow3,
      D12PolynomialData.RM3c5, constVec, basis]

theorem entry6 :
    AVec (3 : Fin 20) (6 : Fin 10) =
      characterStackVec RMVec SMVec 1 (-1)
        (3 : Fin 20) (6 : Fin 10) := by
  rw [AVec_apply_3_6, characterStackVec_apply_3_6]
  funext n
  fin_cases n <;>
    norm_num [ACell3_6_def, RMVec, RMVecRow3,
      D12PolynomialData.RM3c6, constVec, basis]

theorem entry7 :
    AVec (3 : Fin 20) (7 : Fin 10) =
      characterStackVec RMVec SMVec 1 (-1)
        (3 : Fin 20) (7 : Fin 10) := by
  rw [AVec_apply_3_7, characterStackVec_apply_3_7]
  funext n
  fin_cases n <;>
    norm_num [ACell3_7_def, RMVec, RMVecRow3,
      D12PolynomialData.RM3c7, constVec, basis]

theorem entry8 :
    AVec (3 : Fin 20) (8 : Fin 10) =
      characterStackVec RMVec SMVec 1 (-1)
        (3 : Fin 20) (8 : Fin 10) := by
  rw [AVec_apply_3_8, characterStackVec_apply_3_8]
  funext n
  fin_cases n <;>
    norm_num [ACell3_8_def, RMVec, RMVecRow3,
      D12PolynomialData.RM3c8, constVec, basis]

theorem entry9 :
    AVec (3 : Fin 20) (9 : Fin 10) =
      characterStackVec RMVec SMVec 1 (-1)
        (3 : Fin 20) (9 : Fin 10) := by
  rw [AVec_apply_3_9, characterStackVec_apply_3_9]
  funext n
  fin_cases n <;>
    norm_num [ACell3_9_def, RMVec, RMVecRow3,
      D12PolynomialData.RM3c9, constVec, basis]

public theorem row_eq (j : Fin 10) :
    AVec (3 : Fin 20) j =
      characterStackVec RMVec SMVec 1 (-1) (3 : Fin 20) j := by
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

end V14Formalization.D12PiecePAActionRow3
