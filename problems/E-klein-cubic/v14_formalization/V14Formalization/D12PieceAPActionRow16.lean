/- AP character-stack identification row 16. Auto-generated. -/
module

public import V14Formalization.D12PieceAPData

noncomputable section
namespace V14Formalization.D12PieceAPActionRow16
open D12CyclotomicVec D12PieceVecBase D12PieceAPData

theorem entry0 :
    AVec (16 : Fin 20) (0 : Fin 10) =
      characterStackVec RMVec SMVec (-1)
        (1) (16 : Fin 20) (0 : Fin 10) := by
  change ACell16_0 = SMVec 6 0 - 0
  funext n
  fin_cases n <;>
    norm_num [ACell16_0, SMVec, SMVecRow6,
      D12PolynomialData.SM6c0, constVec, basis]

theorem entry1 :
    AVec (16 : Fin 20) (1 : Fin 10) =
      characterStackVec RMVec SMVec (-1)
        (1) (16 : Fin 20) (1 : Fin 10) := by
  change ACell16_1 = SMVec 6 1 - 0
  funext n
  fin_cases n <;>
    norm_num [ACell16_1, SMVec, SMVecRow6,
      D12PolynomialData.SM6c1, constVec, basis]

theorem entry2 :
    AVec (16 : Fin 20) (2 : Fin 10) =
      characterStackVec RMVec SMVec (-1)
        (1) (16 : Fin 20) (2 : Fin 10) := by
  change ACell16_2 = SMVec 6 2 - 0
  funext n
  fin_cases n <;>
    norm_num [ACell16_2, SMVec, SMVecRow6,
      D12PolynomialData.SM6c2, constVec, basis]

theorem entry3 :
    AVec (16 : Fin 20) (3 : Fin 10) =
      characterStackVec RMVec SMVec (-1)
        (1) (16 : Fin 20) (3 : Fin 10) := by
  change ACell16_3 = SMVec 6 3 - 0
  funext n
  fin_cases n <;>
    norm_num [ACell16_3, SMVec, SMVecRow6,
      D12PolynomialData.SM6c3, constVec, basis]

theorem entry4 :
    AVec (16 : Fin 20) (4 : Fin 10) =
      characterStackVec RMVec SMVec (-1)
        (1) (16 : Fin 20) (4 : Fin 10) := by
  change ACell16_4 = SMVec 6 4 - 0
  funext n
  fin_cases n <;>
    norm_num [ACell16_4, SMVec, SMVecRow6,
      D12PolynomialData.SM6c4, constVec, basis]

theorem entry5 :
    AVec (16 : Fin 20) (5 : Fin 10) =
      characterStackVec RMVec SMVec (-1)
        (1) (16 : Fin 20) (5 : Fin 10) := by
  change ACell16_5 = SMVec 6 5 - 0
  funext n
  fin_cases n <;>
    norm_num [ACell16_5, SMVec, SMVecRow6,
      D12PolynomialData.SM6c5, constVec, basis]

theorem entry6 :
    AVec (16 : Fin 20) (6 : Fin 10) =
      characterStackVec RMVec SMVec (-1)
        (1) (16 : Fin 20) (6 : Fin 10) := by
  change ACell16_6 = SMVec 6 6 - constVec (1)
  funext n
  fin_cases n <;>
    norm_num [ACell16_6, SMVec, SMVecRow6,
      D12PolynomialData.SM6c6, constVec, basis]

theorem entry7 :
    AVec (16 : Fin 20) (7 : Fin 10) =
      characterStackVec RMVec SMVec (-1)
        (1) (16 : Fin 20) (7 : Fin 10) := by
  change ACell16_7 = SMVec 6 7 - 0
  funext n
  fin_cases n <;>
    norm_num [ACell16_7, SMVec, SMVecRow6,
      D12PolynomialData.SM6c7, constVec, basis]

theorem entry8 :
    AVec (16 : Fin 20) (8 : Fin 10) =
      characterStackVec RMVec SMVec (-1)
        (1) (16 : Fin 20) (8 : Fin 10) := by
  change ACell16_8 = SMVec 6 8 - 0
  funext n
  fin_cases n <;>
    norm_num [ACell16_8, SMVec, SMVecRow6,
      D12PolynomialData.SM6c8, constVec, basis]

theorem entry9 :
    AVec (16 : Fin 20) (9 : Fin 10) =
      characterStackVec RMVec SMVec (-1)
        (1) (16 : Fin 20) (9 : Fin 10) := by
  change ACell16_9 = SMVec 6 9 - 0
  funext n
  fin_cases n <;>
    norm_num [ACell16_9, SMVec, SMVecRow6,
      D12PolynomialData.SM6c9, constVec, basis]

public theorem row_eq (j : Fin 10) :
    AVec (16 : Fin 20) j =
      characterStackVec RMVec SMVec (-1)
        (1) (16 : Fin 20) j := by
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

end V14Formalization.D12PieceAPActionRow16
