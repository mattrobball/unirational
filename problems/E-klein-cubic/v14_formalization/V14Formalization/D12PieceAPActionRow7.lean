/- AP character-stack identification row 7. Auto-generated. -/
module

public import V14Formalization.D12PieceAPData

noncomputable section
namespace V14Formalization.D12PieceAPActionRow7
open D12CyclotomicVec D12PieceVecBase D12PieceAPData

theorem entry0 :
    AVec (7 : Fin 20) (0 : Fin 10) =
      characterStackVec RMVec SMVec (-1)
        (1) (7 : Fin 20) (0 : Fin 10) := by
  change ACell7_0 = RMVec 7 0 - 0
  funext n
  fin_cases n <;>
    norm_num [ACell7_0, RMVec, RMVecRow7,
      D12PolynomialData.RM7c0, constVec, basis]

theorem entry1 :
    AVec (7 : Fin 20) (1 : Fin 10) =
      characterStackVec RMVec SMVec (-1)
        (1) (7 : Fin 20) (1 : Fin 10) := by
  change ACell7_1 = RMVec 7 1 - 0
  funext n
  fin_cases n <;>
    norm_num [ACell7_1, RMVec, RMVecRow7,
      D12PolynomialData.RM7c1, constVec, basis]

theorem entry2 :
    AVec (7 : Fin 20) (2 : Fin 10) =
      characterStackVec RMVec SMVec (-1)
        (1) (7 : Fin 20) (2 : Fin 10) := by
  change ACell7_2 = RMVec 7 2 - 0
  funext n
  fin_cases n <;>
    norm_num [ACell7_2, RMVec, RMVecRow7,
      D12PolynomialData.RM7c2, constVec, basis]

theorem entry3 :
    AVec (7 : Fin 20) (3 : Fin 10) =
      characterStackVec RMVec SMVec (-1)
        (1) (7 : Fin 20) (3 : Fin 10) := by
  change ACell7_3 = RMVec 7 3 - 0
  funext n
  fin_cases n <;>
    norm_num [ACell7_3, RMVec, RMVecRow7,
      D12PolynomialData.RM7c3, constVec, basis]

theorem entry4 :
    AVec (7 : Fin 20) (4 : Fin 10) =
      characterStackVec RMVec SMVec (-1)
        (1) (7 : Fin 20) (4 : Fin 10) := by
  change ACell7_4 = RMVec 7 4 - 0
  funext n
  fin_cases n <;>
    norm_num [ACell7_4, RMVec, RMVecRow7,
      D12PolynomialData.RM7c4, constVec, basis]

theorem entry5 :
    AVec (7 : Fin 20) (5 : Fin 10) =
      characterStackVec RMVec SMVec (-1)
        (1) (7 : Fin 20) (5 : Fin 10) := by
  change ACell7_5 = RMVec 7 5 - 0
  funext n
  fin_cases n <;>
    norm_num [ACell7_5, RMVec, RMVecRow7,
      D12PolynomialData.RM7c5, constVec, basis]

theorem entry6 :
    AVec (7 : Fin 20) (6 : Fin 10) =
      characterStackVec RMVec SMVec (-1)
        (1) (7 : Fin 20) (6 : Fin 10) := by
  change ACell7_6 = RMVec 7 6 - 0
  funext n
  fin_cases n <;>
    norm_num [ACell7_6, RMVec, RMVecRow7,
      D12PolynomialData.RM7c6, constVec, basis]

theorem entry7 :
    AVec (7 : Fin 20) (7 : Fin 10) =
      characterStackVec RMVec SMVec (-1)
        (1) (7 : Fin 20) (7 : Fin 10) := by
  change ACell7_7 = RMVec 7 7 - constVec (-1)
  funext n
  fin_cases n <;>
    norm_num [ACell7_7, RMVec, RMVecRow7,
      D12PolynomialData.RM7c7, constVec, basis]

theorem entry8 :
    AVec (7 : Fin 20) (8 : Fin 10) =
      characterStackVec RMVec SMVec (-1)
        (1) (7 : Fin 20) (8 : Fin 10) := by
  change ACell7_8 = RMVec 7 8 - 0
  funext n
  fin_cases n <;>
    norm_num [ACell7_8, RMVec, RMVecRow7,
      D12PolynomialData.RM7c8, constVec, basis]

theorem entry9 :
    AVec (7 : Fin 20) (9 : Fin 10) =
      characterStackVec RMVec SMVec (-1)
        (1) (7 : Fin 20) (9 : Fin 10) := by
  change ACell7_9 = RMVec 7 9 - 0
  funext n
  fin_cases n <;>
    norm_num [ACell7_9, RMVec, RMVecRow7,
      D12PolynomialData.RM7c9, constVec, basis]

public theorem row_eq (j : Fin 10) :
    AVec (7 : Fin 20) j =
      characterStackVec RMVec SMVec (-1)
        (1) (7 : Fin 20) j := by
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

end V14Formalization.D12PieceAPActionRow7
