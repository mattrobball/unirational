/- PP character-stack identification row 2. Auto-generated. -/
module

public import V14Formalization.D12PiecePPData

noncomputable section
namespace V14Formalization.D12PiecePPActionRow2
open D12CyclotomicVec D12PieceVecBase D12PiecePPData

theorem entry0 :
    AVec (2 : Fin 20) (0 : Fin 10) =
      characterStackVec RMVec SMVec (1)
        (1) (2 : Fin 20) (0 : Fin 10) := by
  change ACell2_0 = RMVec 2 0 - 0
  funext n
  fin_cases n <;>
    norm_num [ACell2_0, RMVec, RMVecRow2,
      D12PolynomialData.RM2c0, constVec, basis]

theorem entry1 :
    AVec (2 : Fin 20) (1 : Fin 10) =
      characterStackVec RMVec SMVec (1)
        (1) (2 : Fin 20) (1 : Fin 10) := by
  change ACell2_1 = RMVec 2 1 - 0
  funext n
  fin_cases n <;>
    norm_num [ACell2_1, RMVec, RMVecRow2,
      D12PolynomialData.RM2c1, constVec, basis]

theorem entry2 :
    AVec (2 : Fin 20) (2 : Fin 10) =
      characterStackVec RMVec SMVec (1)
        (1) (2 : Fin 20) (2 : Fin 10) := by
  change ACell2_2 = RMVec 2 2 - constVec (1)
  funext n
  fin_cases n <;>
    norm_num [ACell2_2, RMVec, RMVecRow2,
      D12PolynomialData.RM2c2, constVec, basis]

theorem entry3 :
    AVec (2 : Fin 20) (3 : Fin 10) =
      characterStackVec RMVec SMVec (1)
        (1) (2 : Fin 20) (3 : Fin 10) := by
  change ACell2_3 = RMVec 2 3 - 0
  funext n
  fin_cases n <;>
    norm_num [ACell2_3, RMVec, RMVecRow2,
      D12PolynomialData.RM2c3, constVec, basis]

theorem entry4 :
    AVec (2 : Fin 20) (4 : Fin 10) =
      characterStackVec RMVec SMVec (1)
        (1) (2 : Fin 20) (4 : Fin 10) := by
  change ACell2_4 = RMVec 2 4 - 0
  funext n
  fin_cases n <;>
    norm_num [ACell2_4, RMVec, RMVecRow2,
      D12PolynomialData.RM2c4, constVec, basis]

theorem entry5 :
    AVec (2 : Fin 20) (5 : Fin 10) =
      characterStackVec RMVec SMVec (1)
        (1) (2 : Fin 20) (5 : Fin 10) := by
  change ACell2_5 = RMVec 2 5 - 0
  funext n
  fin_cases n <;>
    norm_num [ACell2_5, RMVec, RMVecRow2,
      D12PolynomialData.RM2c5, constVec, basis]

theorem entry6 :
    AVec (2 : Fin 20) (6 : Fin 10) =
      characterStackVec RMVec SMVec (1)
        (1) (2 : Fin 20) (6 : Fin 10) := by
  change ACell2_6 = RMVec 2 6 - 0
  funext n
  fin_cases n <;>
    norm_num [ACell2_6, RMVec, RMVecRow2,
      D12PolynomialData.RM2c6, constVec, basis]

theorem entry7 :
    AVec (2 : Fin 20) (7 : Fin 10) =
      characterStackVec RMVec SMVec (1)
        (1) (2 : Fin 20) (7 : Fin 10) := by
  change ACell2_7 = RMVec 2 7 - 0
  funext n
  fin_cases n <;>
    norm_num [ACell2_7, RMVec, RMVecRow2,
      D12PolynomialData.RM2c7, constVec, basis]

theorem entry8 :
    AVec (2 : Fin 20) (8 : Fin 10) =
      characterStackVec RMVec SMVec (1)
        (1) (2 : Fin 20) (8 : Fin 10) := by
  change ACell2_8 = RMVec 2 8 - 0
  funext n
  fin_cases n <;>
    norm_num [ACell2_8, RMVec, RMVecRow2,
      D12PolynomialData.RM2c8, constVec, basis]

theorem entry9 :
    AVec (2 : Fin 20) (9 : Fin 10) =
      characterStackVec RMVec SMVec (1)
        (1) (2 : Fin 20) (9 : Fin 10) := by
  change ACell2_9 = RMVec 2 9 - 0
  funext n
  fin_cases n <;>
    norm_num [ACell2_9, RMVec, RMVecRow2,
      D12PolynomialData.RM2c9, constVec, basis]

public theorem row_eq (j : Fin 10) :
    AVec (2 : Fin 20) j =
      characterStackVec RMVec SMVec (1)
        (1) (2 : Fin 20) j := by
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

end V14Formalization.D12PiecePPActionRow2
