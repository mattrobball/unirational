/- PA character-stack identification, row 14. Auto-generated. -/
module

public import V14Formalization.D12PiecePAData

noncomputable section
namespace V14Formalization.D12PiecePAActionRow14
open D12CyclotomicVec D12PieceVecBase D12PiecePAData

theorem entry0 :
    AVec (14 : Fin 20) (0 : Fin 10) =
      characterStackVec RMVec SMVec 1 (-1)
        (14 : Fin 20) (0 : Fin 10) := by
  rw [AVec_apply_14_0, characterStackVec_apply_14_0]
  funext n
  fin_cases n <;>
    norm_num [ACell14_0, SMVec, SMVecRow4,
      D12PolynomialData.SM4c0, constVec, basis]

theorem entry1 :
    AVec (14 : Fin 20) (1 : Fin 10) =
      characterStackVec RMVec SMVec 1 (-1)
        (14 : Fin 20) (1 : Fin 10) := by
  rw [AVec_apply_14_1, characterStackVec_apply_14_1]
  funext n
  fin_cases n <;>
    norm_num [ACell14_1, SMVec, SMVecRow4,
      D12PolynomialData.SM4c1, constVec, basis]

theorem entry2 :
    AVec (14 : Fin 20) (2 : Fin 10) =
      characterStackVec RMVec SMVec 1 (-1)
        (14 : Fin 20) (2 : Fin 10) := by
  rw [AVec_apply_14_2, characterStackVec_apply_14_2]
  funext n
  fin_cases n <;>
    norm_num [ACell14_2, SMVec, SMVecRow4,
      D12PolynomialData.SM4c2, constVec, basis]

theorem entry3 :
    AVec (14 : Fin 20) (3 : Fin 10) =
      characterStackVec RMVec SMVec 1 (-1)
        (14 : Fin 20) (3 : Fin 10) := by
  rw [AVec_apply_14_3, characterStackVec_apply_14_3]
  funext n
  fin_cases n <;>
    norm_num [ACell14_3, SMVec, SMVecRow4,
      D12PolynomialData.SM4c3, constVec, basis]

theorem entry4 :
    AVec (14 : Fin 20) (4 : Fin 10) =
      characterStackVec RMVec SMVec 1 (-1)
        (14 : Fin 20) (4 : Fin 10) := by
  rw [AVec_apply_14_4, characterStackVec_apply_14_4]
  funext n
  fin_cases n <;>
    norm_num [ACell14_4, SMVec, SMVecRow4,
      D12PolynomialData.SM4c4, constVec, basis]

theorem entry5 :
    AVec (14 : Fin 20) (5 : Fin 10) =
      characterStackVec RMVec SMVec 1 (-1)
        (14 : Fin 20) (5 : Fin 10) := by
  rw [AVec_apply_14_5, characterStackVec_apply_14_5]
  funext n
  fin_cases n <;>
    norm_num [ACell14_5, SMVec, SMVecRow4,
      D12PolynomialData.SM4c5, constVec, basis]

theorem entry6 :
    AVec (14 : Fin 20) (6 : Fin 10) =
      characterStackVec RMVec SMVec 1 (-1)
        (14 : Fin 20) (6 : Fin 10) := by
  rw [AVec_apply_14_6, characterStackVec_apply_14_6]
  funext n
  fin_cases n <;>
    norm_num [ACell14_6, SMVec, SMVecRow4,
      D12PolynomialData.SM4c6, constVec, basis]

theorem entry7 :
    AVec (14 : Fin 20) (7 : Fin 10) =
      characterStackVec RMVec SMVec 1 (-1)
        (14 : Fin 20) (7 : Fin 10) := by
  rw [AVec_apply_14_7, characterStackVec_apply_14_7]
  funext n
  fin_cases n <;>
    norm_num [ACell14_7, SMVec, SMVecRow4,
      D12PolynomialData.SM4c7, constVec, basis]

theorem entry8 :
    AVec (14 : Fin 20) (8 : Fin 10) =
      characterStackVec RMVec SMVec 1 (-1)
        (14 : Fin 20) (8 : Fin 10) := by
  rw [AVec_apply_14_8, characterStackVec_apply_14_8]
  funext n
  fin_cases n <;>
    norm_num [ACell14_8, SMVec, SMVecRow4,
      D12PolynomialData.SM4c8, constVec, basis]

theorem entry9 :
    AVec (14 : Fin 20) (9 : Fin 10) =
      characterStackVec RMVec SMVec 1 (-1)
        (14 : Fin 20) (9 : Fin 10) := by
  rw [AVec_apply_14_9, characterStackVec_apply_14_9]
  funext n
  fin_cases n <;>
    norm_num [ACell14_9, SMVec, SMVecRow4,
      D12PolynomialData.SM4c9, constVec, basis]

public theorem row_eq (j : Fin 10) :
    AVec (14 : Fin 20) j =
      characterStackVec RMVec SMVec 1 (-1) (14 : Fin 20) j := by
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

end V14Formalization.D12PiecePAActionRow14
