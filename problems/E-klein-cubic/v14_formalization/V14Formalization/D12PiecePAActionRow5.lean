/- PA character-stack identification, row 5. Auto-generated. -/
module

public import V14Formalization.D12PiecePAData

noncomputable section
namespace V14Formalization.D12PiecePAActionRow5
open D12CyclotomicVec D12PieceVecBase D12PiecePAData

theorem entry0 :
    AVec (5 : Fin 20) (0 : Fin 10) =
      characterStackVec RMVec SMVec 1 (-1)
        (5 : Fin 20) (0 : Fin 10) := by
  change ACell5_0 = RMVec 5 0 - 0
  funext n
  fin_cases n <;>
    norm_num [ACell5_0, RMVec, RMVecRow5,
      D12PolynomialData.RM5c0, constVec, basis]

theorem entry1 :
    AVec (5 : Fin 20) (1 : Fin 10) =
      characterStackVec RMVec SMVec 1 (-1)
        (5 : Fin 20) (1 : Fin 10) := by
  change ACell5_1 = RMVec 5 1 - 0
  funext n
  fin_cases n <;>
    norm_num [ACell5_1, RMVec, RMVecRow5,
      D12PolynomialData.RM5c1, constVec, basis]

theorem entry2 :
    AVec (5 : Fin 20) (2 : Fin 10) =
      characterStackVec RMVec SMVec 1 (-1)
        (5 : Fin 20) (2 : Fin 10) := by
  change ACell5_2 = RMVec 5 2 - 0
  funext n
  fin_cases n <;>
    norm_num [ACell5_2, RMVec, RMVecRow5,
      D12PolynomialData.RM5c2, constVec, basis]

theorem entry3 :
    AVec (5 : Fin 20) (3 : Fin 10) =
      characterStackVec RMVec SMVec 1 (-1)
        (5 : Fin 20) (3 : Fin 10) := by
  change ACell5_3 = RMVec 5 3 - 0
  funext n
  fin_cases n <;>
    norm_num [ACell5_3, RMVec, RMVecRow5,
      D12PolynomialData.RM5c3, constVec, basis]

theorem entry4 :
    AVec (5 : Fin 20) (4 : Fin 10) =
      characterStackVec RMVec SMVec 1 (-1)
        (5 : Fin 20) (4 : Fin 10) := by
  change ACell5_4 = RMVec 5 4 - 0
  funext n
  fin_cases n <;>
    norm_num [ACell5_4, RMVec, RMVecRow5,
      D12PolynomialData.RM5c4, constVec, basis]

theorem entry5 :
    AVec (5 : Fin 20) (5 : Fin 10) =
      characterStackVec RMVec SMVec 1 (-1)
        (5 : Fin 20) (5 : Fin 10) := by
  change ACell5_5 = RMVec 5 5 - constVec 1
  funext n
  fin_cases n <;>
    norm_num [ACell5_5, RMVec, RMVecRow5,
      D12PolynomialData.RM5c5, constVec, basis]

theorem entry6 :
    AVec (5 : Fin 20) (6 : Fin 10) =
      characterStackVec RMVec SMVec 1 (-1)
        (5 : Fin 20) (6 : Fin 10) := by
  change ACell5_6 = RMVec 5 6 - 0
  funext n
  fin_cases n <;>
    norm_num [ACell5_6, RMVec, RMVecRow5,
      D12PolynomialData.RM5c6, constVec, basis]

theorem entry7 :
    AVec (5 : Fin 20) (7 : Fin 10) =
      characterStackVec RMVec SMVec 1 (-1)
        (5 : Fin 20) (7 : Fin 10) := by
  change ACell5_7 = RMVec 5 7 - 0
  funext n
  fin_cases n <;>
    norm_num [ACell5_7, RMVec, RMVecRow5,
      D12PolynomialData.RM5c7, constVec, basis]

theorem entry8 :
    AVec (5 : Fin 20) (8 : Fin 10) =
      characterStackVec RMVec SMVec 1 (-1)
        (5 : Fin 20) (8 : Fin 10) := by
  change ACell5_8 = RMVec 5 8 - 0
  funext n
  fin_cases n <;>
    norm_num [ACell5_8, RMVec, RMVecRow5,
      D12PolynomialData.RM5c8, constVec, basis]

theorem entry9 :
    AVec (5 : Fin 20) (9 : Fin 10) =
      characterStackVec RMVec SMVec 1 (-1)
        (5 : Fin 20) (9 : Fin 10) := by
  change ACell5_9 = RMVec 5 9 - 0
  funext n
  fin_cases n <;>
    norm_num [ACell5_9, RMVec, RMVecRow5,
      D12PolynomialData.RM5c9, constVec, basis]

public theorem row_eq (j : Fin 10) :
    AVec (5 : Fin 20) j =
      characterStackVec RMVec SMVec 1 (-1) (5 : Fin 20) j := by
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

end V14Formalization.D12PiecePAActionRow5
