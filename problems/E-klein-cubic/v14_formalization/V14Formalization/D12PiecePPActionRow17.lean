/- PP character-stack identification row 17. Auto-generated. -/
module

public import V14Formalization.D12PiecePPData

noncomputable section
namespace V14Formalization.D12PiecePPActionRow17
open D12CyclotomicVec D12PieceVecBase D12PiecePPData

theorem entry0 :
    AVec (17 : Fin 20) (0 : Fin 10) =
      characterStackVec RMVec SMVec (1)
        (1) (17 : Fin 20) (0 : Fin 10) := by
  rw [AVec_apply_17_0, characterStackVec_apply_17_0]
  funext n
  fin_cases n <;>
    norm_num [ACell17_0, SMVec, SMVecRow7,
      D12PolynomialData.SM7c0, constVec, basis]

theorem entry1 :
    AVec (17 : Fin 20) (1 : Fin 10) =
      characterStackVec RMVec SMVec (1)
        (1) (17 : Fin 20) (1 : Fin 10) := by
  rw [AVec_apply_17_1, characterStackVec_apply_17_1]
  funext n
  fin_cases n <;>
    norm_num [ACell17_1, SMVec, SMVecRow7,
      D12PolynomialData.SM7c1, constVec, basis]

theorem entry2 :
    AVec (17 : Fin 20) (2 : Fin 10) =
      characterStackVec RMVec SMVec (1)
        (1) (17 : Fin 20) (2 : Fin 10) := by
  rw [AVec_apply_17_2, characterStackVec_apply_17_2]
  funext n
  fin_cases n <;>
    norm_num [ACell17_2, SMVec, SMVecRow7,
      D12PolynomialData.SM7c2, constVec, basis]

theorem entry3 :
    AVec (17 : Fin 20) (3 : Fin 10) =
      characterStackVec RMVec SMVec (1)
        (1) (17 : Fin 20) (3 : Fin 10) := by
  rw [AVec_apply_17_3, characterStackVec_apply_17_3]
  funext n
  fin_cases n <;>
    norm_num [ACell17_3, SMVec, SMVecRow7,
      D12PolynomialData.SM7c3, constVec, basis]

theorem entry4 :
    AVec (17 : Fin 20) (4 : Fin 10) =
      characterStackVec RMVec SMVec (1)
        (1) (17 : Fin 20) (4 : Fin 10) := by
  rw [AVec_apply_17_4, characterStackVec_apply_17_4]
  funext n
  fin_cases n <;>
    norm_num [ACell17_4, SMVec, SMVecRow7,
      D12PolynomialData.SM7c4, constVec, basis]

theorem entry5 :
    AVec (17 : Fin 20) (5 : Fin 10) =
      characterStackVec RMVec SMVec (1)
        (1) (17 : Fin 20) (5 : Fin 10) := by
  rw [AVec_apply_17_5, characterStackVec_apply_17_5]
  funext n
  fin_cases n <;>
    norm_num [ACell17_5, SMVec, SMVecRow7,
      D12PolynomialData.SM7c5, constVec, basis]

theorem entry6 :
    AVec (17 : Fin 20) (6 : Fin 10) =
      characterStackVec RMVec SMVec (1)
        (1) (17 : Fin 20) (6 : Fin 10) := by
  rw [AVec_apply_17_6, characterStackVec_apply_17_6]
  funext n
  fin_cases n <;>
    norm_num [ACell17_6, SMVec, SMVecRow7,
      D12PolynomialData.SM7c6, constVec, basis]

theorem entry7 :
    AVec (17 : Fin 20) (7 : Fin 10) =
      characterStackVec RMVec SMVec (1)
        (1) (17 : Fin 20) (7 : Fin 10) := by
  rw [AVec_apply_17_7, characterStackVec_apply_17_7]
  funext n
  fin_cases n <;>
    norm_num [ACell17_7, SMVec, SMVecRow7,
      D12PolynomialData.SM7c7, constVec, basis]

theorem entry8 :
    AVec (17 : Fin 20) (8 : Fin 10) =
      characterStackVec RMVec SMVec (1)
        (1) (17 : Fin 20) (8 : Fin 10) := by
  rw [AVec_apply_17_8, characterStackVec_apply_17_8]
  funext n
  fin_cases n <;>
    norm_num [ACell17_8, SMVec, SMVecRow7,
      D12PolynomialData.SM7c8, constVec, basis]

theorem entry9 :
    AVec (17 : Fin 20) (9 : Fin 10) =
      characterStackVec RMVec SMVec (1)
        (1) (17 : Fin 20) (9 : Fin 10) := by
  rw [AVec_apply_17_9, characterStackVec_apply_17_9]
  funext n
  fin_cases n <;>
    norm_num [ACell17_9, SMVec, SMVecRow7,
      D12PolynomialData.SM7c9, constVec, basis]

public theorem row_eq (j : Fin 10) :
    AVec (17 : Fin 20) j =
      characterStackVec RMVec SMVec (1)
        (1) (17 : Fin 20) j := by
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

end V14Formalization.D12PiecePPActionRow17
