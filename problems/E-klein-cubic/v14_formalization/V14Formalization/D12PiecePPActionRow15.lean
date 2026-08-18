/- PP character-stack identification row 15. Auto-generated. -/
module

public import V14Formalization.D12PiecePPData

noncomputable section
namespace V14Formalization.D12PiecePPActionRow15
open D12CyclotomicVec D12PieceVecBase D12PiecePPData

theorem entry0 :
    AVec (15 : Fin 20) (0 : Fin 10) =
      characterStackVec RMVec SMVec (1)
        (1) (15 : Fin 20) (0 : Fin 10) := by
  rw [AVec_apply_15_0, characterStackVec_apply_15_0]
  refine vec_ext ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ <;>
    norm_num [ACell15_0_def, SMVec, SMVecRow5,
      D12PolynomialData.SM5c0, constVec, basis]

theorem entry1 :
    AVec (15 : Fin 20) (1 : Fin 10) =
      characterStackVec RMVec SMVec (1)
        (1) (15 : Fin 20) (1 : Fin 10) := by
  rw [AVec_apply_15_1, characterStackVec_apply_15_1]
  refine vec_ext ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ <;>
    norm_num [ACell15_1_def, SMVec, SMVecRow5,
      D12PolynomialData.SM5c1, constVec, basis]

theorem entry2 :
    AVec (15 : Fin 20) (2 : Fin 10) =
      characterStackVec RMVec SMVec (1)
        (1) (15 : Fin 20) (2 : Fin 10) := by
  rw [AVec_apply_15_2, characterStackVec_apply_15_2]
  refine vec_ext ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ <;>
    norm_num [ACell15_2_def, SMVec, SMVecRow5,
      D12PolynomialData.SM5c2, constVec, basis]

theorem entry3 :
    AVec (15 : Fin 20) (3 : Fin 10) =
      characterStackVec RMVec SMVec (1)
        (1) (15 : Fin 20) (3 : Fin 10) := by
  rw [AVec_apply_15_3, characterStackVec_apply_15_3]
  refine vec_ext ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ <;>
    norm_num [ACell15_3_def, SMVec, SMVecRow5,
      D12PolynomialData.SM5c3, constVec, basis]

theorem entry4 :
    AVec (15 : Fin 20) (4 : Fin 10) =
      characterStackVec RMVec SMVec (1)
        (1) (15 : Fin 20) (4 : Fin 10) := by
  rw [AVec_apply_15_4, characterStackVec_apply_15_4]
  refine vec_ext ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ <;>
    norm_num [ACell15_4_def, SMVec, SMVecRow5,
      D12PolynomialData.SM5c4, constVec, basis]

theorem entry5 :
    AVec (15 : Fin 20) (5 : Fin 10) =
      characterStackVec RMVec SMVec (1)
        (1) (15 : Fin 20) (5 : Fin 10) := by
  rw [AVec_apply_15_5, characterStackVec_apply_15_5]
  refine vec_ext ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ <;>
    norm_num [ACell15_5_def, SMVec, SMVecRow5,
      D12PolynomialData.SM5c5, constVec, basis]

theorem entry6 :
    AVec (15 : Fin 20) (6 : Fin 10) =
      characterStackVec RMVec SMVec (1)
        (1) (15 : Fin 20) (6 : Fin 10) := by
  rw [AVec_apply_15_6, characterStackVec_apply_15_6]
  refine vec_ext ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ <;>
    norm_num [ACell15_6_def, SMVec, SMVecRow5,
      D12PolynomialData.SM5c6, constVec, basis]

theorem entry7 :
    AVec (15 : Fin 20) (7 : Fin 10) =
      characterStackVec RMVec SMVec (1)
        (1) (15 : Fin 20) (7 : Fin 10) := by
  rw [AVec_apply_15_7, characterStackVec_apply_15_7]
  refine vec_ext ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ <;>
    norm_num [ACell15_7_def, SMVec, SMVecRow5,
      D12PolynomialData.SM5c7, constVec, basis]

theorem entry8 :
    AVec (15 : Fin 20) (8 : Fin 10) =
      characterStackVec RMVec SMVec (1)
        (1) (15 : Fin 20) (8 : Fin 10) := by
  rw [AVec_apply_15_8, characterStackVec_apply_15_8]
  refine vec_ext ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ <;>
    norm_num [ACell15_8_def, SMVec, SMVecRow5,
      D12PolynomialData.SM5c8, constVec, basis]

theorem entry9 :
    AVec (15 : Fin 20) (9 : Fin 10) =
      characterStackVec RMVec SMVec (1)
        (1) (15 : Fin 20) (9 : Fin 10) := by
  rw [AVec_apply_15_9, characterStackVec_apply_15_9]
  refine vec_ext ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ <;>
    norm_num [ACell15_9_def, SMVec, SMVecRow5,
      D12PolynomialData.SM5c9, constVec, basis]

public theorem row_eq (j : Fin 10) :
    AVec (15 : Fin 20) j =
      characterStackVec RMVec SMVec (1)
        (1) (15 : Fin 20) j := by
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

end V14Formalization.D12PiecePPActionRow15
