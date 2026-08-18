/- PP character-stack identification row 8. Auto-generated. -/
module

public import V14Formalization.D12PiecePPData

noncomputable section
namespace V14Formalization.D12PiecePPActionRow8
open D12CyclotomicVec D12PieceVecBase D12PiecePPData

theorem entry0 :
    AVec (8 : Fin 20) (0 : Fin 10) =
      characterStackVec RMVec SMVec (1)
        (1) (8 : Fin 20) (0 : Fin 10) := by
  rw [AVec_apply_8_0, characterStackVec_apply_8_0]
  funext n
  fin_cases n <;>
    norm_num [ACell8_0, RMVec, RMVecRow8,
      D12PolynomialData.RM8c0, constVec, basis]

theorem entry1 :
    AVec (8 : Fin 20) (1 : Fin 10) =
      characterStackVec RMVec SMVec (1)
        (1) (8 : Fin 20) (1 : Fin 10) := by
  rw [AVec_apply_8_1, characterStackVec_apply_8_1]
  funext n
  fin_cases n <;>
    norm_num [ACell8_1, RMVec, RMVecRow8,
      D12PolynomialData.RM8c1, constVec, basis]

theorem entry2 :
    AVec (8 : Fin 20) (2 : Fin 10) =
      characterStackVec RMVec SMVec (1)
        (1) (8 : Fin 20) (2 : Fin 10) := by
  rw [AVec_apply_8_2, characterStackVec_apply_8_2]
  funext n
  fin_cases n <;>
    norm_num [ACell8_2, RMVec, RMVecRow8,
      D12PolynomialData.RM8c2, constVec, basis]

theorem entry3 :
    AVec (8 : Fin 20) (3 : Fin 10) =
      characterStackVec RMVec SMVec (1)
        (1) (8 : Fin 20) (3 : Fin 10) := by
  rw [AVec_apply_8_3, characterStackVec_apply_8_3]
  funext n
  fin_cases n <;>
    norm_num [ACell8_3, RMVec, RMVecRow8,
      D12PolynomialData.RM8c3, constVec, basis]

theorem entry4 :
    AVec (8 : Fin 20) (4 : Fin 10) =
      characterStackVec RMVec SMVec (1)
        (1) (8 : Fin 20) (4 : Fin 10) := by
  rw [AVec_apply_8_4, characterStackVec_apply_8_4]
  funext n
  fin_cases n <;>
    norm_num [ACell8_4, RMVec, RMVecRow8,
      D12PolynomialData.RM8c4, constVec, basis]

theorem entry5 :
    AVec (8 : Fin 20) (5 : Fin 10) =
      characterStackVec RMVec SMVec (1)
        (1) (8 : Fin 20) (5 : Fin 10) := by
  rw [AVec_apply_8_5, characterStackVec_apply_8_5]
  funext n
  fin_cases n <;>
    norm_num [ACell8_5, RMVec, RMVecRow8,
      D12PolynomialData.RM8c5, constVec, basis]

theorem entry6 :
    AVec (8 : Fin 20) (6 : Fin 10) =
      characterStackVec RMVec SMVec (1)
        (1) (8 : Fin 20) (6 : Fin 10) := by
  rw [AVec_apply_8_6, characterStackVec_apply_8_6]
  funext n
  fin_cases n <;>
    norm_num [ACell8_6, RMVec, RMVecRow8,
      D12PolynomialData.RM8c6, constVec, basis]

theorem entry7 :
    AVec (8 : Fin 20) (7 : Fin 10) =
      characterStackVec RMVec SMVec (1)
        (1) (8 : Fin 20) (7 : Fin 10) := by
  rw [AVec_apply_8_7, characterStackVec_apply_8_7]
  funext n
  fin_cases n <;>
    norm_num [ACell8_7, RMVec, RMVecRow8,
      D12PolynomialData.RM8c7, constVec, basis]

theorem entry8 :
    AVec (8 : Fin 20) (8 : Fin 10) =
      characterStackVec RMVec SMVec (1)
        (1) (8 : Fin 20) (8 : Fin 10) := by
  rw [AVec_apply_8_8, characterStackVec_apply_8_8]
  funext n
  fin_cases n <;>
    norm_num [ACell8_8, RMVec, RMVecRow8,
      D12PolynomialData.RM8c8, constVec, basis]

theorem entry9 :
    AVec (8 : Fin 20) (9 : Fin 10) =
      characterStackVec RMVec SMVec (1)
        (1) (8 : Fin 20) (9 : Fin 10) := by
  rw [AVec_apply_8_9, characterStackVec_apply_8_9]
  funext n
  fin_cases n <;>
    norm_num [ACell8_9, RMVec, RMVecRow8,
      D12PolynomialData.RM8c9, constVec, basis]

public theorem row_eq (j : Fin 10) :
    AVec (8 : Fin 20) j =
      characterStackVec RMVec SMVec (1)
        (1) (8 : Fin 20) j := by
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

end V14Formalization.D12PiecePPActionRow8
