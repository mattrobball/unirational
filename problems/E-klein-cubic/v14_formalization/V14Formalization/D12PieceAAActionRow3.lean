/- AA character-stack identification row 3. Auto-generated. -/
module

public import V14Formalization.D12PieceAAData

noncomputable section
namespace V14Formalization.D12PieceAAActionRow3
open D12CyclotomicVec D12PieceVecBase D12PieceAAData

theorem entry0 :
    AVec (3 : Fin 20) (0 : Fin 10) =
      characterStackVec RMVec SMVec (-1)
        (-1) (3 : Fin 20) (0 : Fin 10) := by
  change ACell3_0 = RMVec 3 0 - 0
  funext n
  fin_cases n <;>
    norm_num [ACell3_0, RMVec, RMVecRow3,
      D12PolynomialData.RM3c0, constVec, basis]

theorem entry1 :
    AVec (3 : Fin 20) (1 : Fin 10) =
      characterStackVec RMVec SMVec (-1)
        (-1) (3 : Fin 20) (1 : Fin 10) := by
  change ACell3_1 = RMVec 3 1 - 0
  funext n
  fin_cases n <;>
    norm_num [ACell3_1, RMVec, RMVecRow3,
      D12PolynomialData.RM3c1, constVec, basis]

theorem entry2 :
    AVec (3 : Fin 20) (2 : Fin 10) =
      characterStackVec RMVec SMVec (-1)
        (-1) (3 : Fin 20) (2 : Fin 10) := by
  change ACell3_2 = RMVec 3 2 - 0
  funext n
  fin_cases n <;>
    norm_num [ACell3_2, RMVec, RMVecRow3,
      D12PolynomialData.RM3c2, constVec, basis]

theorem entry3 :
    AVec (3 : Fin 20) (3 : Fin 10) =
      characterStackVec RMVec SMVec (-1)
        (-1) (3 : Fin 20) (3 : Fin 10) := by
  change ACell3_3 = RMVec 3 3 - constVec (-1)
  funext n
  fin_cases n <;>
    norm_num [ACell3_3, RMVec, RMVecRow3,
      D12PolynomialData.RM3c3, constVec, basis]

theorem entry4 :
    AVec (3 : Fin 20) (4 : Fin 10) =
      characterStackVec RMVec SMVec (-1)
        (-1) (3 : Fin 20) (4 : Fin 10) := by
  change ACell3_4 = RMVec 3 4 - 0
  funext n
  fin_cases n <;>
    norm_num [ACell3_4, RMVec, RMVecRow3,
      D12PolynomialData.RM3c4, constVec, basis]

theorem entry5 :
    AVec (3 : Fin 20) (5 : Fin 10) =
      characterStackVec RMVec SMVec (-1)
        (-1) (3 : Fin 20) (5 : Fin 10) := by
  change ACell3_5 = RMVec 3 5 - 0
  funext n
  fin_cases n <;>
    norm_num [ACell3_5, RMVec, RMVecRow3,
      D12PolynomialData.RM3c5, constVec, basis]

theorem entry6 :
    AVec (3 : Fin 20) (6 : Fin 10) =
      characterStackVec RMVec SMVec (-1)
        (-1) (3 : Fin 20) (6 : Fin 10) := by
  change ACell3_6 = RMVec 3 6 - 0
  funext n
  fin_cases n <;>
    norm_num [ACell3_6, RMVec, RMVecRow3,
      D12PolynomialData.RM3c6, constVec, basis]

theorem entry7 :
    AVec (3 : Fin 20) (7 : Fin 10) =
      characterStackVec RMVec SMVec (-1)
        (-1) (3 : Fin 20) (7 : Fin 10) := by
  change ACell3_7 = RMVec 3 7 - 0
  funext n
  fin_cases n <;>
    norm_num [ACell3_7, RMVec, RMVecRow3,
      D12PolynomialData.RM3c7, constVec, basis]

theorem entry8 :
    AVec (3 : Fin 20) (8 : Fin 10) =
      characterStackVec RMVec SMVec (-1)
        (-1) (3 : Fin 20) (8 : Fin 10) := by
  change ACell3_8 = RMVec 3 8 - 0
  funext n
  fin_cases n <;>
    norm_num [ACell3_8, RMVec, RMVecRow3,
      D12PolynomialData.RM3c8, constVec, basis]

theorem entry9 :
    AVec (3 : Fin 20) (9 : Fin 10) =
      characterStackVec RMVec SMVec (-1)
        (-1) (3 : Fin 20) (9 : Fin 10) := by
  change ACell3_9 = RMVec 3 9 - 0
  funext n
  fin_cases n <;>
    norm_num [ACell3_9, RMVec, RMVecRow3,
      D12PolynomialData.RM3c9, constVec, basis]

public theorem row_eq (j : Fin 10) :
    AVec (3 : Fin 20) j =
      characterStackVec RMVec SMVec (-1)
        (-1) (3 : Fin 20) j := by
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

end V14Formalization.D12PieceAAActionRow3
