/- AP character-stack identification row 1. Auto-generated. -/
module

public import V14Formalization.D12PieceAPData

noncomputable section
namespace V14Formalization.D12PieceAPActionRow1
open D12CyclotomicVec D12PieceVecBase D12PieceAPData

theorem entry0 :
    AVec (1 : Fin 20) (0 : Fin 10) =
      characterStackVec RMVec SMVec (-1)
        (1) (1 : Fin 20) (0 : Fin 10) := by
  change ACell1_0 = RMVec 1 0 - 0
  funext n
  fin_cases n <;>
    norm_num [ACell1_0, RMVec, RMVecRow1,
      D12PolynomialData.RM1c0, constVec, basis]

theorem entry1 :
    AVec (1 : Fin 20) (1 : Fin 10) =
      characterStackVec RMVec SMVec (-1)
        (1) (1 : Fin 20) (1 : Fin 10) := by
  change ACell1_1 = RMVec 1 1 - constVec (-1)
  funext n
  fin_cases n <;>
    norm_num [ACell1_1, RMVec, RMVecRow1,
      D12PolynomialData.RM1c1, constVec, basis]

theorem entry2 :
    AVec (1 : Fin 20) (2 : Fin 10) =
      characterStackVec RMVec SMVec (-1)
        (1) (1 : Fin 20) (2 : Fin 10) := by
  change ACell1_2 = RMVec 1 2 - 0
  funext n
  fin_cases n <;>
    norm_num [ACell1_2, RMVec, RMVecRow1,
      D12PolynomialData.RM1c2, constVec, basis]

theorem entry3 :
    AVec (1 : Fin 20) (3 : Fin 10) =
      characterStackVec RMVec SMVec (-1)
        (1) (1 : Fin 20) (3 : Fin 10) := by
  change ACell1_3 = RMVec 1 3 - 0
  funext n
  fin_cases n <;>
    norm_num [ACell1_3, RMVec, RMVecRow1,
      D12PolynomialData.RM1c3, constVec, basis]

theorem entry4 :
    AVec (1 : Fin 20) (4 : Fin 10) =
      characterStackVec RMVec SMVec (-1)
        (1) (1 : Fin 20) (4 : Fin 10) := by
  change ACell1_4 = RMVec 1 4 - 0
  funext n
  fin_cases n <;>
    norm_num [ACell1_4, RMVec, RMVecRow1,
      D12PolynomialData.RM1c4, constVec, basis]

theorem entry5 :
    AVec (1 : Fin 20) (5 : Fin 10) =
      characterStackVec RMVec SMVec (-1)
        (1) (1 : Fin 20) (5 : Fin 10) := by
  change ACell1_5 = RMVec 1 5 - 0
  funext n
  fin_cases n <;>
    norm_num [ACell1_5, RMVec, RMVecRow1,
      D12PolynomialData.RM1c5, constVec, basis]

theorem entry6 :
    AVec (1 : Fin 20) (6 : Fin 10) =
      characterStackVec RMVec SMVec (-1)
        (1) (1 : Fin 20) (6 : Fin 10) := by
  change ACell1_6 = RMVec 1 6 - 0
  funext n
  fin_cases n <;>
    norm_num [ACell1_6, RMVec, RMVecRow1,
      D12PolynomialData.RM1c6, constVec, basis]

theorem entry7 :
    AVec (1 : Fin 20) (7 : Fin 10) =
      characterStackVec RMVec SMVec (-1)
        (1) (1 : Fin 20) (7 : Fin 10) := by
  change ACell1_7 = RMVec 1 7 - 0
  funext n
  fin_cases n <;>
    norm_num [ACell1_7, RMVec, RMVecRow1,
      D12PolynomialData.RM1c7, constVec, basis]

theorem entry8 :
    AVec (1 : Fin 20) (8 : Fin 10) =
      characterStackVec RMVec SMVec (-1)
        (1) (1 : Fin 20) (8 : Fin 10) := by
  change ACell1_8 = RMVec 1 8 - 0
  funext n
  fin_cases n <;>
    norm_num [ACell1_8, RMVec, RMVecRow1,
      D12PolynomialData.RM1c8, constVec, basis]

theorem entry9 :
    AVec (1 : Fin 20) (9 : Fin 10) =
      characterStackVec RMVec SMVec (-1)
        (1) (1 : Fin 20) (9 : Fin 10) := by
  change ACell1_9 = RMVec 1 9 - 0
  funext n
  fin_cases n <;>
    norm_num [ACell1_9, RMVec, RMVecRow1,
      D12PolynomialData.RM1c9, constVec, basis]

public theorem row_eq (j : Fin 10) :
    AVec (1 : Fin 20) j =
      characterStackVec RMVec SMVec (-1)
        (1) (1 : Fin 20) j := by
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

end V14Formalization.D12PieceAPActionRow1
