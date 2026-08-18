/- PP character-stack identification row 7. Auto-generated. -/
module

public import V14Formalization.D12PiecePPData

noncomputable section
namespace V14Formalization.D12PiecePPActionRow7
open D12CyclotomicVec D12PieceVecBase D12PiecePPData

theorem entry0 :
    AVec (7 : Fin 20) (0 : Fin 10) =
      characterStackVec RMVec SMVec (1)
        (1) (7 : Fin 20) (0 : Fin 10) := by
  rw [AVec_apply_7_0, characterStackVec_apply_7_0]
  funext n
  fin_cases n <;>
    norm_num [ACell7_0, RMVec, RMVecRow7,
      D12PolynomialData.RM7c0, constVec, basis]

theorem entry1 :
    AVec (7 : Fin 20) (1 : Fin 10) =
      characterStackVec RMVec SMVec (1)
        (1) (7 : Fin 20) (1 : Fin 10) := by
  rw [AVec_apply_7_1, characterStackVec_apply_7_1]
  funext n
  fin_cases n <;>
    norm_num [ACell7_1, RMVec, RMVecRow7,
      D12PolynomialData.RM7c1, constVec, basis]

theorem entry2 :
    AVec (7 : Fin 20) (2 : Fin 10) =
      characterStackVec RMVec SMVec (1)
        (1) (7 : Fin 20) (2 : Fin 10) := by
  rw [AVec_apply_7_2, characterStackVec_apply_7_2]
  funext n
  fin_cases n <;>
    norm_num [ACell7_2, RMVec, RMVecRow7,
      D12PolynomialData.RM7c2, constVec, basis]

theorem entry3 :
    AVec (7 : Fin 20) (3 : Fin 10) =
      characterStackVec RMVec SMVec (1)
        (1) (7 : Fin 20) (3 : Fin 10) := by
  rw [AVec_apply_7_3, characterStackVec_apply_7_3]
  funext n
  fin_cases n <;>
    norm_num [ACell7_3, RMVec, RMVecRow7,
      D12PolynomialData.RM7c3, constVec, basis]

theorem entry4 :
    AVec (7 : Fin 20) (4 : Fin 10) =
      characterStackVec RMVec SMVec (1)
        (1) (7 : Fin 20) (4 : Fin 10) := by
  rw [AVec_apply_7_4, characterStackVec_apply_7_4]
  funext n
  fin_cases n <;>
    norm_num [ACell7_4, RMVec, RMVecRow7,
      D12PolynomialData.RM7c4, constVec, basis]

theorem entry5 :
    AVec (7 : Fin 20) (5 : Fin 10) =
      characterStackVec RMVec SMVec (1)
        (1) (7 : Fin 20) (5 : Fin 10) := by
  rw [AVec_apply_7_5, characterStackVec_apply_7_5]
  funext n
  fin_cases n <;>
    norm_num [ACell7_5, RMVec, RMVecRow7,
      D12PolynomialData.RM7c5, constVec, basis]

theorem entry6 :
    AVec (7 : Fin 20) (6 : Fin 10) =
      characterStackVec RMVec SMVec (1)
        (1) (7 : Fin 20) (6 : Fin 10) := by
  rw [AVec_apply_7_6, characterStackVec_apply_7_6]
  funext n
  fin_cases n <;>
    norm_num [ACell7_6, RMVec, RMVecRow7,
      D12PolynomialData.RM7c6, constVec, basis]

theorem entry7 :
    AVec (7 : Fin 20) (7 : Fin 10) =
      characterStackVec RMVec SMVec (1)
        (1) (7 : Fin 20) (7 : Fin 10) := by
  rw [AVec_apply_7_7, characterStackVec_apply_7_7]
  funext n
  fin_cases n <;>
    norm_num [ACell7_7, RMVec, RMVecRow7,
      D12PolynomialData.RM7c7, constVec, basis]

theorem entry8 :
    AVec (7 : Fin 20) (8 : Fin 10) =
      characterStackVec RMVec SMVec (1)
        (1) (7 : Fin 20) (8 : Fin 10) := by
  rw [AVec_apply_7_8, characterStackVec_apply_7_8]
  funext n
  fin_cases n <;>
    norm_num [ACell7_8, RMVec, RMVecRow7,
      D12PolynomialData.RM7c8, constVec, basis]

theorem entry9 :
    AVec (7 : Fin 20) (9 : Fin 10) =
      characterStackVec RMVec SMVec (1)
        (1) (7 : Fin 20) (9 : Fin 10) := by
  rw [AVec_apply_7_9, characterStackVec_apply_7_9]
  funext n
  fin_cases n <;>
    norm_num [ACell7_9, RMVec, RMVecRow7,
      D12PolynomialData.RM7c9, constVec, basis]

public theorem row_eq (j : Fin 10) :
    AVec (7 : Fin 20) j =
      characterStackVec RMVec SMVec (1)
        (1) (7 : Fin 20) j := by
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

end V14Formalization.D12PiecePPActionRow7
