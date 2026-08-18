/- AA character-stack identification row 11. Auto-generated. -/
module

public import V14Formalization.D12PieceAAData

noncomputable section
namespace V14Formalization.D12PieceAAActionRow11
open D12CyclotomicVec D12PieceVecBase D12PieceAAData

theorem entry0 :
    AVec (11 : Fin 20) (0 : Fin 10) =
      characterStackVec RMVec SMVec (-1)
        (-1) (11 : Fin 20) (0 : Fin 10) := by
  rw [AVec_apply_11_0, characterStackVec_apply_11_0]
  funext n
  fin_cases n <;>
    norm_num [ACell11_0_def, SMVec, SMVecRow1,
      D12PolynomialData.SM1c0, constVec, basis]

theorem entry1 :
    AVec (11 : Fin 20) (1 : Fin 10) =
      characterStackVec RMVec SMVec (-1)
        (-1) (11 : Fin 20) (1 : Fin 10) := by
  rw [AVec_apply_11_1, characterStackVec_apply_11_1]
  funext n
  fin_cases n <;>
    norm_num [ACell11_1_def, SMVec, SMVecRow1,
      D12PolynomialData.SM1c1, constVec, basis]

theorem entry2 :
    AVec (11 : Fin 20) (2 : Fin 10) =
      characterStackVec RMVec SMVec (-1)
        (-1) (11 : Fin 20) (2 : Fin 10) := by
  rw [AVec_apply_11_2, characterStackVec_apply_11_2]
  funext n
  fin_cases n <;>
    norm_num [ACell11_2_def, SMVec, SMVecRow1,
      D12PolynomialData.SM1c2, constVec, basis]

theorem entry3 :
    AVec (11 : Fin 20) (3 : Fin 10) =
      characterStackVec RMVec SMVec (-1)
        (-1) (11 : Fin 20) (3 : Fin 10) := by
  rw [AVec_apply_11_3, characterStackVec_apply_11_3]
  funext n
  fin_cases n <;>
    norm_num [ACell11_3_def, SMVec, SMVecRow1,
      D12PolynomialData.SM1c3, constVec, basis]

theorem entry4 :
    AVec (11 : Fin 20) (4 : Fin 10) =
      characterStackVec RMVec SMVec (-1)
        (-1) (11 : Fin 20) (4 : Fin 10) := by
  rw [AVec_apply_11_4, characterStackVec_apply_11_4]
  funext n
  fin_cases n <;>
    norm_num [ACell11_4_def, SMVec, SMVecRow1,
      D12PolynomialData.SM1c4, constVec, basis]

theorem entry5 :
    AVec (11 : Fin 20) (5 : Fin 10) =
      characterStackVec RMVec SMVec (-1)
        (-1) (11 : Fin 20) (5 : Fin 10) := by
  rw [AVec_apply_11_5, characterStackVec_apply_11_5]
  funext n
  fin_cases n <;>
    norm_num [ACell11_5_def, SMVec, SMVecRow1,
      D12PolynomialData.SM1c5, constVec, basis]

theorem entry6 :
    AVec (11 : Fin 20) (6 : Fin 10) =
      characterStackVec RMVec SMVec (-1)
        (-1) (11 : Fin 20) (6 : Fin 10) := by
  rw [AVec_apply_11_6, characterStackVec_apply_11_6]
  funext n
  fin_cases n <;>
    norm_num [ACell11_6_def, SMVec, SMVecRow1,
      D12PolynomialData.SM1c6, constVec, basis]

theorem entry7 :
    AVec (11 : Fin 20) (7 : Fin 10) =
      characterStackVec RMVec SMVec (-1)
        (-1) (11 : Fin 20) (7 : Fin 10) := by
  rw [AVec_apply_11_7, characterStackVec_apply_11_7]
  funext n
  fin_cases n <;>
    norm_num [ACell11_7_def, SMVec, SMVecRow1,
      D12PolynomialData.SM1c7, constVec, basis]

theorem entry8 :
    AVec (11 : Fin 20) (8 : Fin 10) =
      characterStackVec RMVec SMVec (-1)
        (-1) (11 : Fin 20) (8 : Fin 10) := by
  rw [AVec_apply_11_8, characterStackVec_apply_11_8]
  funext n
  fin_cases n <;>
    norm_num [ACell11_8_def, SMVec, SMVecRow1,
      D12PolynomialData.SM1c8, constVec, basis]

theorem entry9 :
    AVec (11 : Fin 20) (9 : Fin 10) =
      characterStackVec RMVec SMVec (-1)
        (-1) (11 : Fin 20) (9 : Fin 10) := by
  rw [AVec_apply_11_9, characterStackVec_apply_11_9]
  funext n
  fin_cases n <;>
    norm_num [ACell11_9_def, SMVec, SMVecRow1,
      D12PolynomialData.SM1c9, constVec, basis]

public theorem row_eq (j : Fin 10) :
    AVec (11 : Fin 20) j =
      characterStackVec RMVec SMVec (-1)
        (-1) (11 : Fin 20) j := by
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

end V14Formalization.D12PieceAAActionRow11
