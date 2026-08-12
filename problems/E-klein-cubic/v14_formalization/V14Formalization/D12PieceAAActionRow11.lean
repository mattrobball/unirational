/- AA character-stack identification row 11. Auto-generated. -/
import V14Formalization.D12PieceAAData

noncomputable section
namespace V14Formalization.D12PieceAAActionRow11
open D12CyclotomicVec D12PieceVecBase D12PieceAAData

theorem entry0 :
    AVec (11 : Fin 20) (0 : Fin 10) =
      characterStackVec RMVec SMVec (-1)
        (-1) (11 : Fin 20) (0 : Fin 10) := by
  change ACell11_0 = SMVec 1 0 - 0
  funext n
  fin_cases n <;>
    norm_num [ACell11_0, SMVec, SMVecRow1,
      D12PolynomialData.SM1c0, constVec, basis]

theorem entry1 :
    AVec (11 : Fin 20) (1 : Fin 10) =
      characterStackVec RMVec SMVec (-1)
        (-1) (11 : Fin 20) (1 : Fin 10) := by
  change ACell11_1 = SMVec 1 1 - constVec (-1)
  funext n
  fin_cases n <;>
    norm_num [ACell11_1, SMVec, SMVecRow1,
      D12PolynomialData.SM1c1, constVec, basis]

theorem entry2 :
    AVec (11 : Fin 20) (2 : Fin 10) =
      characterStackVec RMVec SMVec (-1)
        (-1) (11 : Fin 20) (2 : Fin 10) := by
  change ACell11_2 = SMVec 1 2 - 0
  funext n
  fin_cases n <;>
    norm_num [ACell11_2, SMVec, SMVecRow1,
      D12PolynomialData.SM1c2, constVec, basis]

theorem entry3 :
    AVec (11 : Fin 20) (3 : Fin 10) =
      characterStackVec RMVec SMVec (-1)
        (-1) (11 : Fin 20) (3 : Fin 10) := by
  change ACell11_3 = SMVec 1 3 - 0
  funext n
  fin_cases n <;>
    norm_num [ACell11_3, SMVec, SMVecRow1,
      D12PolynomialData.SM1c3, constVec, basis]

theorem entry4 :
    AVec (11 : Fin 20) (4 : Fin 10) =
      characterStackVec RMVec SMVec (-1)
        (-1) (11 : Fin 20) (4 : Fin 10) := by
  change ACell11_4 = SMVec 1 4 - 0
  funext n
  fin_cases n <;>
    norm_num [ACell11_4, SMVec, SMVecRow1,
      D12PolynomialData.SM1c4, constVec, basis]

theorem entry5 :
    AVec (11 : Fin 20) (5 : Fin 10) =
      characterStackVec RMVec SMVec (-1)
        (-1) (11 : Fin 20) (5 : Fin 10) := by
  change ACell11_5 = SMVec 1 5 - 0
  funext n
  fin_cases n <;>
    norm_num [ACell11_5, SMVec, SMVecRow1,
      D12PolynomialData.SM1c5, constVec, basis]

theorem entry6 :
    AVec (11 : Fin 20) (6 : Fin 10) =
      characterStackVec RMVec SMVec (-1)
        (-1) (11 : Fin 20) (6 : Fin 10) := by
  change ACell11_6 = SMVec 1 6 - 0
  funext n
  fin_cases n <;>
    norm_num [ACell11_6, SMVec, SMVecRow1,
      D12PolynomialData.SM1c6, constVec, basis]

theorem entry7 :
    AVec (11 : Fin 20) (7 : Fin 10) =
      characterStackVec RMVec SMVec (-1)
        (-1) (11 : Fin 20) (7 : Fin 10) := by
  change ACell11_7 = SMVec 1 7 - 0
  funext n
  fin_cases n <;>
    norm_num [ACell11_7, SMVec, SMVecRow1,
      D12PolynomialData.SM1c7, constVec, basis]

theorem entry8 :
    AVec (11 : Fin 20) (8 : Fin 10) =
      characterStackVec RMVec SMVec (-1)
        (-1) (11 : Fin 20) (8 : Fin 10) := by
  change ACell11_8 = SMVec 1 8 - 0
  funext n
  fin_cases n <;>
    norm_num [ACell11_8, SMVec, SMVecRow1,
      D12PolynomialData.SM1c8, constVec, basis]

theorem entry9 :
    AVec (11 : Fin 20) (9 : Fin 10) =
      characterStackVec RMVec SMVec (-1)
        (-1) (11 : Fin 20) (9 : Fin 10) := by
  change ACell11_9 = SMVec 1 9 - 0
  funext n
  fin_cases n <;>
    norm_num [ACell11_9, SMVec, SMVecRow1,
      D12PolynomialData.SM1c9, constVec, basis]

theorem row_eq (j : Fin 10) :
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
