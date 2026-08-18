/- PA character-stack identification, row 6. Auto-generated. -/
module

public import V14Formalization.D12PiecePAData

noncomputable section
namespace V14Formalization.D12PiecePAActionRow6
open D12CyclotomicVec D12PieceVecBase D12PiecePAData

theorem entry0 :
    AVec (6 : Fin 20) (0 : Fin 10) =
      characterStackVec RMVec SMVec 1 (-1)
        (6 : Fin 20) (0 : Fin 10) := by
  rw [AVec_apply_6_0, characterStackVec_apply_6_0]
  funext n
  fin_cases n <;>
    norm_num [ACell6_0_def, RMVec, RMVecRow6,
      D12PolynomialData.RM6c0, constVec, basis]

theorem entry1 :
    AVec (6 : Fin 20) (1 : Fin 10) =
      characterStackVec RMVec SMVec 1 (-1)
        (6 : Fin 20) (1 : Fin 10) := by
  rw [AVec_apply_6_1, characterStackVec_apply_6_1]
  funext n
  fin_cases n <;>
    norm_num [ACell6_1_def, RMVec, RMVecRow6,
      D12PolynomialData.RM6c1, constVec, basis]

theorem entry2 :
    AVec (6 : Fin 20) (2 : Fin 10) =
      characterStackVec RMVec SMVec 1 (-1)
        (6 : Fin 20) (2 : Fin 10) := by
  rw [AVec_apply_6_2, characterStackVec_apply_6_2]
  funext n
  fin_cases n <;>
    norm_num [ACell6_2_def, RMVec, RMVecRow6,
      D12PolynomialData.RM6c2, constVec, basis]

theorem entry3 :
    AVec (6 : Fin 20) (3 : Fin 10) =
      characterStackVec RMVec SMVec 1 (-1)
        (6 : Fin 20) (3 : Fin 10) := by
  rw [AVec_apply_6_3, characterStackVec_apply_6_3]
  funext n
  fin_cases n <;>
    norm_num [ACell6_3_def, RMVec, RMVecRow6,
      D12PolynomialData.RM6c3, constVec, basis]

theorem entry4 :
    AVec (6 : Fin 20) (4 : Fin 10) =
      characterStackVec RMVec SMVec 1 (-1)
        (6 : Fin 20) (4 : Fin 10) := by
  rw [AVec_apply_6_4, characterStackVec_apply_6_4]
  funext n
  fin_cases n <;>
    norm_num [ACell6_4_def, RMVec, RMVecRow6,
      D12PolynomialData.RM6c4, constVec, basis]

theorem entry5 :
    AVec (6 : Fin 20) (5 : Fin 10) =
      characterStackVec RMVec SMVec 1 (-1)
        (6 : Fin 20) (5 : Fin 10) := by
  rw [AVec_apply_6_5, characterStackVec_apply_6_5]
  funext n
  fin_cases n <;>
    norm_num [ACell6_5_def, RMVec, RMVecRow6,
      D12PolynomialData.RM6c5, constVec, basis]

theorem entry6 :
    AVec (6 : Fin 20) (6 : Fin 10) =
      characterStackVec RMVec SMVec 1 (-1)
        (6 : Fin 20) (6 : Fin 10) := by
  rw [AVec_apply_6_6, characterStackVec_apply_6_6]
  funext n
  fin_cases n <;>
    norm_num [ACell6_6_def, RMVec, RMVecRow6,
      D12PolynomialData.RM6c6, constVec, basis]

theorem entry7 :
    AVec (6 : Fin 20) (7 : Fin 10) =
      characterStackVec RMVec SMVec 1 (-1)
        (6 : Fin 20) (7 : Fin 10) := by
  rw [AVec_apply_6_7, characterStackVec_apply_6_7]
  funext n
  fin_cases n <;>
    norm_num [ACell6_7_def, RMVec, RMVecRow6,
      D12PolynomialData.RM6c7, constVec, basis]

theorem entry8 :
    AVec (6 : Fin 20) (8 : Fin 10) =
      characterStackVec RMVec SMVec 1 (-1)
        (6 : Fin 20) (8 : Fin 10) := by
  rw [AVec_apply_6_8, characterStackVec_apply_6_8]
  funext n
  fin_cases n <;>
    norm_num [ACell6_8_def, RMVec, RMVecRow6,
      D12PolynomialData.RM6c8, constVec, basis]

theorem entry9 :
    AVec (6 : Fin 20) (9 : Fin 10) =
      characterStackVec RMVec SMVec 1 (-1)
        (6 : Fin 20) (9 : Fin 10) := by
  rw [AVec_apply_6_9, characterStackVec_apply_6_9]
  funext n
  fin_cases n <;>
    norm_num [ACell6_9_def, RMVec, RMVecRow6,
      D12PolynomialData.RM6c9, constVec, basis]

public theorem row_eq (j : Fin 10) :
    AVec (6 : Fin 20) j =
      characterStackVec RMVec SMVec 1 (-1) (6 : Fin 20) j := by
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

end V14Formalization.D12PiecePAActionRow6
