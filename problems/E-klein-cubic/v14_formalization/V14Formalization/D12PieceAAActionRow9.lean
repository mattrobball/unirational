/- AA character-stack identification row 9. Auto-generated. -/
module

public import V14Formalization.D12PieceAAData

noncomputable section
namespace V14Formalization.D12PieceAAActionRow9
open D12CyclotomicVec D12PieceVecBase D12PieceAAData

theorem entry0 :
    AVec (9 : Fin 20) (0 : Fin 10) =
      characterStackVec RMVec SMVec (-1)
        (-1) (9 : Fin 20) (0 : Fin 10) := by
  rw [AVec_apply_9_0, characterStackVec_apply_9_0]
  refine vec_ext ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ <;>
    norm_num [ACell9_0_def, RMVec, RMVecRow9,
      D12PolynomialData.RM9c0, constVec, basis]

theorem entry1 :
    AVec (9 : Fin 20) (1 : Fin 10) =
      characterStackVec RMVec SMVec (-1)
        (-1) (9 : Fin 20) (1 : Fin 10) := by
  rw [AVec_apply_9_1, characterStackVec_apply_9_1]
  refine vec_ext ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ <;>
    norm_num [ACell9_1_def, RMVec, RMVecRow9,
      D12PolynomialData.RM9c1, constVec, basis]

theorem entry2 :
    AVec (9 : Fin 20) (2 : Fin 10) =
      characterStackVec RMVec SMVec (-1)
        (-1) (9 : Fin 20) (2 : Fin 10) := by
  rw [AVec_apply_9_2, characterStackVec_apply_9_2]
  refine vec_ext ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ <;>
    norm_num [ACell9_2_def, RMVec, RMVecRow9,
      D12PolynomialData.RM9c2, constVec, basis]

theorem entry3 :
    AVec (9 : Fin 20) (3 : Fin 10) =
      characterStackVec RMVec SMVec (-1)
        (-1) (9 : Fin 20) (3 : Fin 10) := by
  rw [AVec_apply_9_3, characterStackVec_apply_9_3]
  refine vec_ext ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ <;>
    norm_num [ACell9_3_def, RMVec, RMVecRow9,
      D12PolynomialData.RM9c3, constVec, basis]

theorem entry4 :
    AVec (9 : Fin 20) (4 : Fin 10) =
      characterStackVec RMVec SMVec (-1)
        (-1) (9 : Fin 20) (4 : Fin 10) := by
  rw [AVec_apply_9_4, characterStackVec_apply_9_4]
  refine vec_ext ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ <;>
    norm_num [ACell9_4_def, RMVec, RMVecRow9,
      D12PolynomialData.RM9c4, constVec, basis]

theorem entry5 :
    AVec (9 : Fin 20) (5 : Fin 10) =
      characterStackVec RMVec SMVec (-1)
        (-1) (9 : Fin 20) (5 : Fin 10) := by
  rw [AVec_apply_9_5, characterStackVec_apply_9_5]
  refine vec_ext ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ <;>
    norm_num [ACell9_5_def, RMVec, RMVecRow9,
      D12PolynomialData.RM9c5, constVec, basis]

theorem entry6 :
    AVec (9 : Fin 20) (6 : Fin 10) =
      characterStackVec RMVec SMVec (-1)
        (-1) (9 : Fin 20) (6 : Fin 10) := by
  rw [AVec_apply_9_6, characterStackVec_apply_9_6]
  refine vec_ext ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ <;>
    norm_num [ACell9_6_def, RMVec, RMVecRow9,
      D12PolynomialData.RM9c6, constVec, basis]

theorem entry7 :
    AVec (9 : Fin 20) (7 : Fin 10) =
      characterStackVec RMVec SMVec (-1)
        (-1) (9 : Fin 20) (7 : Fin 10) := by
  rw [AVec_apply_9_7, characterStackVec_apply_9_7]
  refine vec_ext ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ <;>
    norm_num [ACell9_7_def, RMVec, RMVecRow9,
      D12PolynomialData.RM9c7, constVec, basis]

theorem entry8 :
    AVec (9 : Fin 20) (8 : Fin 10) =
      characterStackVec RMVec SMVec (-1)
        (-1) (9 : Fin 20) (8 : Fin 10) := by
  rw [AVec_apply_9_8, characterStackVec_apply_9_8]
  refine vec_ext ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ <;>
    norm_num [ACell9_8_def, RMVec, RMVecRow9,
      D12PolynomialData.RM9c8, constVec, basis]

theorem entry9 :
    AVec (9 : Fin 20) (9 : Fin 10) =
      characterStackVec RMVec SMVec (-1)
        (-1) (9 : Fin 20) (9 : Fin 10) := by
  rw [AVec_apply_9_9, characterStackVec_apply_9_9]
  refine vec_ext ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ <;>
    norm_num [ACell9_9_def, RMVec, RMVecRow9,
      D12PolynomialData.RM9c9, constVec, basis]

public theorem row_eq (j : Fin 10) :
    AVec (9 : Fin 20) j =
      characterStackVec RMVec SMVec (-1)
        (-1) (9 : Fin 20) j := by
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

end V14Formalization.D12PieceAAActionRow9
