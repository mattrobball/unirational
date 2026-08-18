/- AP character-stack identification row 5. Auto-generated. -/
module

public import V14Formalization.D12PieceAPData

noncomputable section
namespace V14Formalization.D12PieceAPActionRow5
open D12CyclotomicVec D12PieceVecBase D12PieceAPData

theorem entry0 :
    AVec (5 : Fin 20) (0 : Fin 10) =
      characterStackVec RMVec SMVec (-1)
        (1) (5 : Fin 20) (0 : Fin 10) := by
  rw [AVec_apply_5_0, characterStackVec_apply_5_0]
  funext n
  fin_cases n <;>
    norm_num [ACell5_0_def, RMVec, RMVecRow5,
      D12PolynomialData.RM5c0, constVec, basis]

theorem entry1 :
    AVec (5 : Fin 20) (1 : Fin 10) =
      characterStackVec RMVec SMVec (-1)
        (1) (5 : Fin 20) (1 : Fin 10) := by
  rw [AVec_apply_5_1, characterStackVec_apply_5_1]
  funext n
  fin_cases n <;>
    norm_num [ACell5_1_def, RMVec, RMVecRow5,
      D12PolynomialData.RM5c1, constVec, basis]

theorem entry2 :
    AVec (5 : Fin 20) (2 : Fin 10) =
      characterStackVec RMVec SMVec (-1)
        (1) (5 : Fin 20) (2 : Fin 10) := by
  rw [AVec_apply_5_2, characterStackVec_apply_5_2]
  funext n
  fin_cases n <;>
    norm_num [ACell5_2_def, RMVec, RMVecRow5,
      D12PolynomialData.RM5c2, constVec, basis]

theorem entry3 :
    AVec (5 : Fin 20) (3 : Fin 10) =
      characterStackVec RMVec SMVec (-1)
        (1) (5 : Fin 20) (3 : Fin 10) := by
  rw [AVec_apply_5_3, characterStackVec_apply_5_3]
  funext n
  fin_cases n <;>
    norm_num [ACell5_3_def, RMVec, RMVecRow5,
      D12PolynomialData.RM5c3, constVec, basis]

theorem entry4 :
    AVec (5 : Fin 20) (4 : Fin 10) =
      characterStackVec RMVec SMVec (-1)
        (1) (5 : Fin 20) (4 : Fin 10) := by
  rw [AVec_apply_5_4, characterStackVec_apply_5_4]
  funext n
  fin_cases n <;>
    norm_num [ACell5_4_def, RMVec, RMVecRow5,
      D12PolynomialData.RM5c4, constVec, basis]

theorem entry5 :
    AVec (5 : Fin 20) (5 : Fin 10) =
      characterStackVec RMVec SMVec (-1)
        (1) (5 : Fin 20) (5 : Fin 10) := by
  rw [AVec_apply_5_5, characterStackVec_apply_5_5]
  funext n
  fin_cases n <;>
    norm_num [ACell5_5_def, RMVec, RMVecRow5,
      D12PolynomialData.RM5c5, constVec, basis]

theorem entry6 :
    AVec (5 : Fin 20) (6 : Fin 10) =
      characterStackVec RMVec SMVec (-1)
        (1) (5 : Fin 20) (6 : Fin 10) := by
  rw [AVec_apply_5_6, characterStackVec_apply_5_6]
  funext n
  fin_cases n <;>
    norm_num [ACell5_6_def, RMVec, RMVecRow5,
      D12PolynomialData.RM5c6, constVec, basis]

theorem entry7 :
    AVec (5 : Fin 20) (7 : Fin 10) =
      characterStackVec RMVec SMVec (-1)
        (1) (5 : Fin 20) (7 : Fin 10) := by
  rw [AVec_apply_5_7, characterStackVec_apply_5_7]
  funext n
  fin_cases n <;>
    norm_num [ACell5_7_def, RMVec, RMVecRow5,
      D12PolynomialData.RM5c7, constVec, basis]

theorem entry8 :
    AVec (5 : Fin 20) (8 : Fin 10) =
      characterStackVec RMVec SMVec (-1)
        (1) (5 : Fin 20) (8 : Fin 10) := by
  rw [AVec_apply_5_8, characterStackVec_apply_5_8]
  funext n
  fin_cases n <;>
    norm_num [ACell5_8_def, RMVec, RMVecRow5,
      D12PolynomialData.RM5c8, constVec, basis]

theorem entry9 :
    AVec (5 : Fin 20) (9 : Fin 10) =
      characterStackVec RMVec SMVec (-1)
        (1) (5 : Fin 20) (9 : Fin 10) := by
  rw [AVec_apply_5_9, characterStackVec_apply_5_9]
  funext n
  fin_cases n <;>
    norm_num [ACell5_9_def, RMVec, RMVecRow5,
      D12PolynomialData.RM5c9, constVec, basis]

public theorem row_eq (j : Fin 10) :
    AVec (5 : Fin 20) j =
      characterStackVec RMVec SMVec (-1)
        (1) (5 : Fin 20) j := by
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

end V14Formalization.D12PieceAPActionRow5
