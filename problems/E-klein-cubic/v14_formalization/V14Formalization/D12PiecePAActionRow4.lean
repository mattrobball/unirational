/- PA character-stack identification, row 4. Auto-generated. -/
module

public import V14Formalization.D12PiecePAData

noncomputable section
namespace V14Formalization.D12PiecePAActionRow4
open D12CyclotomicVec D12PieceVecBase D12PiecePAData

theorem entry0 :
    AVec (4 : Fin 20) (0 : Fin 10) =
      characterStackVec RMVec SMVec 1 (-1)
        (4 : Fin 20) (0 : Fin 10) := by
  rw [AVec_apply_4_0, characterStackVec_apply_4_0]
  refine vec_ext ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ <;>
    norm_num [ACell4_0_def, RMVec, RMVecRow4,
      D12PolynomialData.RM4c0, constVec, basis]

theorem entry1 :
    AVec (4 : Fin 20) (1 : Fin 10) =
      characterStackVec RMVec SMVec 1 (-1)
        (4 : Fin 20) (1 : Fin 10) := by
  rw [AVec_apply_4_1, characterStackVec_apply_4_1]
  refine vec_ext ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ <;>
    norm_num [ACell4_1_def, RMVec, RMVecRow4,
      D12PolynomialData.RM4c1, constVec, basis]

theorem entry2 :
    AVec (4 : Fin 20) (2 : Fin 10) =
      characterStackVec RMVec SMVec 1 (-1)
        (4 : Fin 20) (2 : Fin 10) := by
  rw [AVec_apply_4_2, characterStackVec_apply_4_2]
  refine vec_ext ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ <;>
    norm_num [ACell4_2_def, RMVec, RMVecRow4,
      D12PolynomialData.RM4c2, constVec, basis]

theorem entry3 :
    AVec (4 : Fin 20) (3 : Fin 10) =
      characterStackVec RMVec SMVec 1 (-1)
        (4 : Fin 20) (3 : Fin 10) := by
  rw [AVec_apply_4_3, characterStackVec_apply_4_3]
  refine vec_ext ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ <;>
    norm_num [ACell4_3_def, RMVec, RMVecRow4,
      D12PolynomialData.RM4c3, constVec, basis]

theorem entry4 :
    AVec (4 : Fin 20) (4 : Fin 10) =
      characterStackVec RMVec SMVec 1 (-1)
        (4 : Fin 20) (4 : Fin 10) := by
  rw [AVec_apply_4_4, characterStackVec_apply_4_4]
  refine vec_ext ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ <;>
    norm_num [ACell4_4_def, RMVec, RMVecRow4,
      D12PolynomialData.RM4c4, constVec, basis]

theorem entry5 :
    AVec (4 : Fin 20) (5 : Fin 10) =
      characterStackVec RMVec SMVec 1 (-1)
        (4 : Fin 20) (5 : Fin 10) := by
  rw [AVec_apply_4_5, characterStackVec_apply_4_5]
  refine vec_ext ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ <;>
    norm_num [ACell4_5_def, RMVec, RMVecRow4,
      D12PolynomialData.RM4c5, constVec, basis]

theorem entry6 :
    AVec (4 : Fin 20) (6 : Fin 10) =
      characterStackVec RMVec SMVec 1 (-1)
        (4 : Fin 20) (6 : Fin 10) := by
  rw [AVec_apply_4_6, characterStackVec_apply_4_6]
  refine vec_ext ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ <;>
    norm_num [ACell4_6_def, RMVec, RMVecRow4,
      D12PolynomialData.RM4c6, constVec, basis]

theorem entry7 :
    AVec (4 : Fin 20) (7 : Fin 10) =
      characterStackVec RMVec SMVec 1 (-1)
        (4 : Fin 20) (7 : Fin 10) := by
  rw [AVec_apply_4_7, characterStackVec_apply_4_7]
  refine vec_ext ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ <;>
    norm_num [ACell4_7_def, RMVec, RMVecRow4,
      D12PolynomialData.RM4c7, constVec, basis]

theorem entry8 :
    AVec (4 : Fin 20) (8 : Fin 10) =
      characterStackVec RMVec SMVec 1 (-1)
        (4 : Fin 20) (8 : Fin 10) := by
  rw [AVec_apply_4_8, characterStackVec_apply_4_8]
  refine vec_ext ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ <;>
    norm_num [ACell4_8_def, RMVec, RMVecRow4,
      D12PolynomialData.RM4c8, constVec, basis]

theorem entry9 :
    AVec (4 : Fin 20) (9 : Fin 10) =
      characterStackVec RMVec SMVec 1 (-1)
        (4 : Fin 20) (9 : Fin 10) := by
  rw [AVec_apply_4_9, characterStackVec_apply_4_9]
  refine vec_ext ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ <;>
    norm_num [ACell4_9_def, RMVec, RMVecRow4,
      D12PolynomialData.RM4c9, constVec, basis]

public theorem row_eq (j : Fin 10) :
    AVec (4 : Fin 20) j =
      characterStackVec RMVec SMVec 1 (-1) (4 : Fin 20) j := by
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

end V14Formalization.D12PiecePAActionRow4
