/- AA character-stack identification row 12. Auto-generated. -/
module

public import V14Formalization.D12PieceAAData

noncomputable section
namespace V14Formalization.D12PieceAAActionRow12
open D12CyclotomicVec D12PieceVecBase D12PieceAAData

theorem entry0 :
    AVec (12 : Fin 20) (0 : Fin 10) =
      characterStackVec RMVec SMVec (-1)
        (-1) (12 : Fin 20) (0 : Fin 10) := by
  rw [AVec_apply_12_0, characterStackVec_apply_12_0]
  refine vec_ext ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ <;>
    norm_num [ACell12_0_def, SMVec, SMVecRow2,
      D12PolynomialData.SM2c0, constVec, basis]

theorem entry1 :
    AVec (12 : Fin 20) (1 : Fin 10) =
      characterStackVec RMVec SMVec (-1)
        (-1) (12 : Fin 20) (1 : Fin 10) := by
  rw [AVec_apply_12_1, characterStackVec_apply_12_1]
  refine vec_ext ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ <;>
    norm_num [ACell12_1_def, SMVec, SMVecRow2,
      D12PolynomialData.SM2c1, constVec, basis]

theorem entry2 :
    AVec (12 : Fin 20) (2 : Fin 10) =
      characterStackVec RMVec SMVec (-1)
        (-1) (12 : Fin 20) (2 : Fin 10) := by
  rw [AVec_apply_12_2, characterStackVec_apply_12_2]
  refine vec_ext ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ <;>
    norm_num [ACell12_2_def, SMVec, SMVecRow2,
      D12PolynomialData.SM2c2, constVec, basis]

theorem entry3 :
    AVec (12 : Fin 20) (3 : Fin 10) =
      characterStackVec RMVec SMVec (-1)
        (-1) (12 : Fin 20) (3 : Fin 10) := by
  rw [AVec_apply_12_3, characterStackVec_apply_12_3]
  refine vec_ext ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ <;>
    norm_num [ACell12_3_def, SMVec, SMVecRow2,
      D12PolynomialData.SM2c3, constVec, basis]

theorem entry4 :
    AVec (12 : Fin 20) (4 : Fin 10) =
      characterStackVec RMVec SMVec (-1)
        (-1) (12 : Fin 20) (4 : Fin 10) := by
  rw [AVec_apply_12_4, characterStackVec_apply_12_4]
  refine vec_ext ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ <;>
    norm_num [ACell12_4_def, SMVec, SMVecRow2,
      D12PolynomialData.SM2c4, constVec, basis]

theorem entry5 :
    AVec (12 : Fin 20) (5 : Fin 10) =
      characterStackVec RMVec SMVec (-1)
        (-1) (12 : Fin 20) (5 : Fin 10) := by
  rw [AVec_apply_12_5, characterStackVec_apply_12_5]
  refine vec_ext ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ <;>
    norm_num [ACell12_5_def, SMVec, SMVecRow2,
      D12PolynomialData.SM2c5, constVec, basis]

theorem entry6 :
    AVec (12 : Fin 20) (6 : Fin 10) =
      characterStackVec RMVec SMVec (-1)
        (-1) (12 : Fin 20) (6 : Fin 10) := by
  rw [AVec_apply_12_6, characterStackVec_apply_12_6]
  refine vec_ext ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ <;>
    norm_num [ACell12_6_def, SMVec, SMVecRow2,
      D12PolynomialData.SM2c6, constVec, basis]

theorem entry7 :
    AVec (12 : Fin 20) (7 : Fin 10) =
      characterStackVec RMVec SMVec (-1)
        (-1) (12 : Fin 20) (7 : Fin 10) := by
  rw [AVec_apply_12_7, characterStackVec_apply_12_7]
  refine vec_ext ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ <;>
    norm_num [ACell12_7_def, SMVec, SMVecRow2,
      D12PolynomialData.SM2c7, constVec, basis]

theorem entry8 :
    AVec (12 : Fin 20) (8 : Fin 10) =
      characterStackVec RMVec SMVec (-1)
        (-1) (12 : Fin 20) (8 : Fin 10) := by
  rw [AVec_apply_12_8, characterStackVec_apply_12_8]
  refine vec_ext ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ <;>
    norm_num [ACell12_8_def, SMVec, SMVecRow2,
      D12PolynomialData.SM2c8, constVec, basis]

theorem entry9 :
    AVec (12 : Fin 20) (9 : Fin 10) =
      characterStackVec RMVec SMVec (-1)
        (-1) (12 : Fin 20) (9 : Fin 10) := by
  rw [AVec_apply_12_9, characterStackVec_apply_12_9]
  refine vec_ext ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ <;>
    norm_num [ACell12_9_def, SMVec, SMVecRow2,
      D12PolynomialData.SM2c9, constVec, basis]

public theorem row_eq (j : Fin 10) :
    AVec (12 : Fin 20) j =
      characterStackVec RMVec SMVec (-1)
        (-1) (12 : Fin 20) j := by
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

end V14Formalization.D12PieceAAActionRow12
