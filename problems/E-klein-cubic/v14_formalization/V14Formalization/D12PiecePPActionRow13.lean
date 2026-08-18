/- PP character-stack identification row 13. Auto-generated. -/
module

public import V14Formalization.D12PiecePPData

noncomputable section
namespace V14Formalization.D12PiecePPActionRow13
open D12CyclotomicVec D12PieceVecBase D12PiecePPData

theorem entry0 :
    AVec (13 : Fin 20) (0 : Fin 10) =
      characterStackVec RMVec SMVec (1)
        (1) (13 : Fin 20) (0 : Fin 10) := by
  rw [AVec_apply_13_0, characterStackVec_apply_13_0]
  refine vec_ext ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ <;>
    norm_num [ACell13_0_def, SMVec, SMVecRow3,
      D12PolynomialData.SM3c0, constVec, basis]

theorem entry1 :
    AVec (13 : Fin 20) (1 : Fin 10) =
      characterStackVec RMVec SMVec (1)
        (1) (13 : Fin 20) (1 : Fin 10) := by
  rw [AVec_apply_13_1, characterStackVec_apply_13_1]
  refine vec_ext ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ <;>
    norm_num [ACell13_1_def, SMVec, SMVecRow3,
      D12PolynomialData.SM3c1, constVec, basis]

theorem entry2 :
    AVec (13 : Fin 20) (2 : Fin 10) =
      characterStackVec RMVec SMVec (1)
        (1) (13 : Fin 20) (2 : Fin 10) := by
  rw [AVec_apply_13_2, characterStackVec_apply_13_2]
  refine vec_ext ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ <;>
    norm_num [ACell13_2_def, SMVec, SMVecRow3,
      D12PolynomialData.SM3c2, constVec, basis]

theorem entry3 :
    AVec (13 : Fin 20) (3 : Fin 10) =
      characterStackVec RMVec SMVec (1)
        (1) (13 : Fin 20) (3 : Fin 10) := by
  rw [AVec_apply_13_3, characterStackVec_apply_13_3]
  refine vec_ext ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ <;>
    norm_num [ACell13_3_def, SMVec, SMVecRow3,
      D12PolynomialData.SM3c3, constVec, basis]

theorem entry4 :
    AVec (13 : Fin 20) (4 : Fin 10) =
      characterStackVec RMVec SMVec (1)
        (1) (13 : Fin 20) (4 : Fin 10) := by
  rw [AVec_apply_13_4, characterStackVec_apply_13_4]
  refine vec_ext ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ <;>
    norm_num [ACell13_4_def, SMVec, SMVecRow3,
      D12PolynomialData.SM3c4, constVec, basis]

theorem entry5 :
    AVec (13 : Fin 20) (5 : Fin 10) =
      characterStackVec RMVec SMVec (1)
        (1) (13 : Fin 20) (5 : Fin 10) := by
  rw [AVec_apply_13_5, characterStackVec_apply_13_5]
  refine vec_ext ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ <;>
    norm_num [ACell13_5_def, SMVec, SMVecRow3,
      D12PolynomialData.SM3c5, constVec, basis]

theorem entry6 :
    AVec (13 : Fin 20) (6 : Fin 10) =
      characterStackVec RMVec SMVec (1)
        (1) (13 : Fin 20) (6 : Fin 10) := by
  rw [AVec_apply_13_6, characterStackVec_apply_13_6]
  refine vec_ext ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ <;>
    norm_num [ACell13_6_def, SMVec, SMVecRow3,
      D12PolynomialData.SM3c6, constVec, basis]

theorem entry7 :
    AVec (13 : Fin 20) (7 : Fin 10) =
      characterStackVec RMVec SMVec (1)
        (1) (13 : Fin 20) (7 : Fin 10) := by
  rw [AVec_apply_13_7, characterStackVec_apply_13_7]
  refine vec_ext ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ <;>
    norm_num [ACell13_7_def, SMVec, SMVecRow3,
      D12PolynomialData.SM3c7, constVec, basis]

theorem entry8 :
    AVec (13 : Fin 20) (8 : Fin 10) =
      characterStackVec RMVec SMVec (1)
        (1) (13 : Fin 20) (8 : Fin 10) := by
  rw [AVec_apply_13_8, characterStackVec_apply_13_8]
  refine vec_ext ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ <;>
    norm_num [ACell13_8_def, SMVec, SMVecRow3,
      D12PolynomialData.SM3c8, constVec, basis]

theorem entry9 :
    AVec (13 : Fin 20) (9 : Fin 10) =
      characterStackVec RMVec SMVec (1)
        (1) (13 : Fin 20) (9 : Fin 10) := by
  rw [AVec_apply_13_9, characterStackVec_apply_13_9]
  refine vec_ext ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ <;>
    norm_num [ACell13_9_def, SMVec, SMVecRow3,
      D12PolynomialData.SM3c9, constVec, basis]

public theorem row_eq (j : Fin 10) :
    AVec (13 : Fin 20) j =
      characterStackVec RMVec SMVec (1)
        (1) (13 : Fin 20) j := by
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

end V14Formalization.D12PiecePPActionRow13
