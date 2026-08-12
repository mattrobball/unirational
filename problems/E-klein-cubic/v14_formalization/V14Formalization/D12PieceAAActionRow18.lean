/- AA character-stack identification row 18. Auto-generated. -/
import V14Formalization.D12PieceAAData

noncomputable section
namespace V14Formalization.D12PieceAAActionRow18
open D12CyclotomicVec D12PieceVecBase D12PieceAAData

theorem entry0 :
    AVec (18 : Fin 20) (0 : Fin 10) =
      characterStackVec RMVec SMVec (-1)
        (-1) (18 : Fin 20) (0 : Fin 10) := by
  change ACell18_0 = SMVec 8 0 - 0
  funext n
  fin_cases n <;>
    norm_num [ACell18_0, SMVec, SMVecRow8,
      D12PolynomialData.SM8c0, constVec, basis]

theorem entry1 :
    AVec (18 : Fin 20) (1 : Fin 10) =
      characterStackVec RMVec SMVec (-1)
        (-1) (18 : Fin 20) (1 : Fin 10) := by
  change ACell18_1 = SMVec 8 1 - 0
  funext n
  fin_cases n <;>
    norm_num [ACell18_1, SMVec, SMVecRow8,
      D12PolynomialData.SM8c1, constVec, basis]

theorem entry2 :
    AVec (18 : Fin 20) (2 : Fin 10) =
      characterStackVec RMVec SMVec (-1)
        (-1) (18 : Fin 20) (2 : Fin 10) := by
  change ACell18_2 = SMVec 8 2 - 0
  funext n
  fin_cases n <;>
    norm_num [ACell18_2, SMVec, SMVecRow8,
      D12PolynomialData.SM8c2, constVec, basis]

theorem entry3 :
    AVec (18 : Fin 20) (3 : Fin 10) =
      characterStackVec RMVec SMVec (-1)
        (-1) (18 : Fin 20) (3 : Fin 10) := by
  change ACell18_3 = SMVec 8 3 - 0
  funext n
  fin_cases n <;>
    norm_num [ACell18_3, SMVec, SMVecRow8,
      D12PolynomialData.SM8c3, constVec, basis]

theorem entry4 :
    AVec (18 : Fin 20) (4 : Fin 10) =
      characterStackVec RMVec SMVec (-1)
        (-1) (18 : Fin 20) (4 : Fin 10) := by
  change ACell18_4 = SMVec 8 4 - 0
  funext n
  fin_cases n <;>
    norm_num [ACell18_4, SMVec, SMVecRow8,
      D12PolynomialData.SM8c4, constVec, basis]

theorem entry5 :
    AVec (18 : Fin 20) (5 : Fin 10) =
      characterStackVec RMVec SMVec (-1)
        (-1) (18 : Fin 20) (5 : Fin 10) := by
  change ACell18_5 = SMVec 8 5 - 0
  funext n
  fin_cases n <;>
    norm_num [ACell18_5, SMVec, SMVecRow8,
      D12PolynomialData.SM8c5, constVec, basis]

theorem entry6 :
    AVec (18 : Fin 20) (6 : Fin 10) =
      characterStackVec RMVec SMVec (-1)
        (-1) (18 : Fin 20) (6 : Fin 10) := by
  change ACell18_6 = SMVec 8 6 - 0
  funext n
  fin_cases n <;>
    norm_num [ACell18_6, SMVec, SMVecRow8,
      D12PolynomialData.SM8c6, constVec, basis]

theorem entry7 :
    AVec (18 : Fin 20) (7 : Fin 10) =
      characterStackVec RMVec SMVec (-1)
        (-1) (18 : Fin 20) (7 : Fin 10) := by
  change ACell18_7 = SMVec 8 7 - 0
  funext n
  fin_cases n <;>
    norm_num [ACell18_7, SMVec, SMVecRow8,
      D12PolynomialData.SM8c7, constVec, basis]

theorem entry8 :
    AVec (18 : Fin 20) (8 : Fin 10) =
      characterStackVec RMVec SMVec (-1)
        (-1) (18 : Fin 20) (8 : Fin 10) := by
  change ACell18_8 = SMVec 8 8 - constVec (-1)
  funext n
  fin_cases n <;>
    norm_num [ACell18_8, SMVec, SMVecRow8,
      D12PolynomialData.SM8c8, constVec, basis]

theorem entry9 :
    AVec (18 : Fin 20) (9 : Fin 10) =
      characterStackVec RMVec SMVec (-1)
        (-1) (18 : Fin 20) (9 : Fin 10) := by
  change ACell18_9 = SMVec 8 9 - 0
  funext n
  fin_cases n <;>
    norm_num [ACell18_9, SMVec, SMVecRow8,
      D12PolynomialData.SM8c9, constVec, basis]

theorem row_eq (j : Fin 10) :
    AVec (18 : Fin 20) j =
      characterStackVec RMVec SMVec (-1)
        (-1) (18 : Fin 20) j := by
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

end V14Formalization.D12PieceAAActionRow18
