/- AP character-stack identification row 0. Auto-generated. -/
module

public import V14Formalization.D12PieceAPData

noncomputable section
namespace V14Formalization.D12PieceAPActionRow0
open D12CyclotomicVec D12PieceVecBase D12PieceAPData

theorem entry0 :
    AVec (0 : Fin 20) (0 : Fin 10) =
      characterStackVec RMVec SMVec (-1)
        (1) (0 : Fin 20) (0 : Fin 10) := by
  rw [AVec_apply_0_0, characterStackVec_apply_0_0]
  funext n
  fin_cases n <;>
    norm_num [ACell0_0, RMVec, RMVecRow0,
      D12PolynomialData.RM0c0, constVec, basis]

theorem entry1 :
    AVec (0 : Fin 20) (1 : Fin 10) =
      characterStackVec RMVec SMVec (-1)
        (1) (0 : Fin 20) (1 : Fin 10) := by
  rw [AVec_apply_0_1, characterStackVec_apply_0_1]
  funext n
  fin_cases n <;>
    norm_num [ACell0_1, RMVec, RMVecRow0,
      D12PolynomialData.RM0c1, constVec, basis]

theorem entry2 :
    AVec (0 : Fin 20) (2 : Fin 10) =
      characterStackVec RMVec SMVec (-1)
        (1) (0 : Fin 20) (2 : Fin 10) := by
  rw [AVec_apply_0_2, characterStackVec_apply_0_2]
  funext n
  fin_cases n <;>
    norm_num [ACell0_2, RMVec, RMVecRow0,
      D12PolynomialData.RM0c2, constVec, basis]

theorem entry3 :
    AVec (0 : Fin 20) (3 : Fin 10) =
      characterStackVec RMVec SMVec (-1)
        (1) (0 : Fin 20) (3 : Fin 10) := by
  rw [AVec_apply_0_3, characterStackVec_apply_0_3]
  funext n
  fin_cases n <;>
    norm_num [ACell0_3, RMVec, RMVecRow0,
      D12PolynomialData.RM0c3, constVec, basis]

theorem entry4 :
    AVec (0 : Fin 20) (4 : Fin 10) =
      characterStackVec RMVec SMVec (-1)
        (1) (0 : Fin 20) (4 : Fin 10) := by
  rw [AVec_apply_0_4, characterStackVec_apply_0_4]
  funext n
  fin_cases n <;>
    norm_num [ACell0_4, RMVec, RMVecRow0,
      D12PolynomialData.RM0c4, constVec, basis]

theorem entry5 :
    AVec (0 : Fin 20) (5 : Fin 10) =
      characterStackVec RMVec SMVec (-1)
        (1) (0 : Fin 20) (5 : Fin 10) := by
  rw [AVec_apply_0_5, characterStackVec_apply_0_5]
  funext n
  fin_cases n <;>
    norm_num [ACell0_5, RMVec, RMVecRow0,
      D12PolynomialData.RM0c5, constVec, basis]

theorem entry6 :
    AVec (0 : Fin 20) (6 : Fin 10) =
      characterStackVec RMVec SMVec (-1)
        (1) (0 : Fin 20) (6 : Fin 10) := by
  rw [AVec_apply_0_6, characterStackVec_apply_0_6]
  funext n
  fin_cases n <;>
    norm_num [ACell0_6, RMVec, RMVecRow0,
      D12PolynomialData.RM0c6, constVec, basis]

theorem entry7 :
    AVec (0 : Fin 20) (7 : Fin 10) =
      characterStackVec RMVec SMVec (-1)
        (1) (0 : Fin 20) (7 : Fin 10) := by
  rw [AVec_apply_0_7, characterStackVec_apply_0_7]
  funext n
  fin_cases n <;>
    norm_num [ACell0_7, RMVec, RMVecRow0,
      D12PolynomialData.RM0c7, constVec, basis]

theorem entry8 :
    AVec (0 : Fin 20) (8 : Fin 10) =
      characterStackVec RMVec SMVec (-1)
        (1) (0 : Fin 20) (8 : Fin 10) := by
  rw [AVec_apply_0_8, characterStackVec_apply_0_8]
  funext n
  fin_cases n <;>
    norm_num [ACell0_8, RMVec, RMVecRow0,
      D12PolynomialData.RM0c8, constVec, basis]

theorem entry9 :
    AVec (0 : Fin 20) (9 : Fin 10) =
      characterStackVec RMVec SMVec (-1)
        (1) (0 : Fin 20) (9 : Fin 10) := by
  rw [AVec_apply_0_9, characterStackVec_apply_0_9]
  funext n
  fin_cases n <;>
    norm_num [ACell0_9, RMVec, RMVecRow0,
      D12PolynomialData.RM0c9, constVec, basis]

public theorem row_eq (j : Fin 10) :
    AVec (0 : Fin 20) j =
      characterStackVec RMVec SMVec (-1)
        (1) (0 : Fin 20) j := by
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

end V14Formalization.D12PieceAPActionRow0
