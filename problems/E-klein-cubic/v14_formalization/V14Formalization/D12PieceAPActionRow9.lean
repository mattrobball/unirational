/- AP character-stack identification row 9. Auto-generated. -/
import V14Formalization.D12PieceAPData

noncomputable section
namespace V14Formalization.D12PieceAPActionRow9
open D12CyclotomicVec D12PieceVecBase D12PieceAPData

theorem entry0 :
    AVec (9 : Fin 20) (0 : Fin 10) =
      characterStackVec RMVec SMVec (-1)
        (1) (9 : Fin 20) (0 : Fin 10) := by
  change ACell9_0 = RMVec 9 0 - 0
  funext n
  fin_cases n <;>
    norm_num [ACell9_0, RMVec, RMVecRow9,
      D12PolynomialData.RM9c0, constVec, basis]

theorem entry1 :
    AVec (9 : Fin 20) (1 : Fin 10) =
      characterStackVec RMVec SMVec (-1)
        (1) (9 : Fin 20) (1 : Fin 10) := by
  change ACell9_1 = RMVec 9 1 - 0
  funext n
  fin_cases n <;>
    norm_num [ACell9_1, RMVec, RMVecRow9,
      D12PolynomialData.RM9c1, constVec, basis]

theorem entry2 :
    AVec (9 : Fin 20) (2 : Fin 10) =
      characterStackVec RMVec SMVec (-1)
        (1) (9 : Fin 20) (2 : Fin 10) := by
  change ACell9_2 = RMVec 9 2 - 0
  funext n
  fin_cases n <;>
    norm_num [ACell9_2, RMVec, RMVecRow9,
      D12PolynomialData.RM9c2, constVec, basis]

theorem entry3 :
    AVec (9 : Fin 20) (3 : Fin 10) =
      characterStackVec RMVec SMVec (-1)
        (1) (9 : Fin 20) (3 : Fin 10) := by
  change ACell9_3 = RMVec 9 3 - 0
  funext n
  fin_cases n <;>
    norm_num [ACell9_3, RMVec, RMVecRow9,
      D12PolynomialData.RM9c3, constVec, basis]

theorem entry4 :
    AVec (9 : Fin 20) (4 : Fin 10) =
      characterStackVec RMVec SMVec (-1)
        (1) (9 : Fin 20) (4 : Fin 10) := by
  change ACell9_4 = RMVec 9 4 - 0
  funext n
  fin_cases n <;>
    norm_num [ACell9_4, RMVec, RMVecRow9,
      D12PolynomialData.RM9c4, constVec, basis]

theorem entry5 :
    AVec (9 : Fin 20) (5 : Fin 10) =
      characterStackVec RMVec SMVec (-1)
        (1) (9 : Fin 20) (5 : Fin 10) := by
  change ACell9_5 = RMVec 9 5 - 0
  funext n
  fin_cases n <;>
    norm_num [ACell9_5, RMVec, RMVecRow9,
      D12PolynomialData.RM9c5, constVec, basis]

theorem entry6 :
    AVec (9 : Fin 20) (6 : Fin 10) =
      characterStackVec RMVec SMVec (-1)
        (1) (9 : Fin 20) (6 : Fin 10) := by
  change ACell9_6 = RMVec 9 6 - 0
  funext n
  fin_cases n <;>
    norm_num [ACell9_6, RMVec, RMVecRow9,
      D12PolynomialData.RM9c6, constVec, basis]

theorem entry7 :
    AVec (9 : Fin 20) (7 : Fin 10) =
      characterStackVec RMVec SMVec (-1)
        (1) (9 : Fin 20) (7 : Fin 10) := by
  change ACell9_7 = RMVec 9 7 - 0
  funext n
  fin_cases n <;>
    norm_num [ACell9_7, RMVec, RMVecRow9,
      D12PolynomialData.RM9c7, constVec, basis]

theorem entry8 :
    AVec (9 : Fin 20) (8 : Fin 10) =
      characterStackVec RMVec SMVec (-1)
        (1) (9 : Fin 20) (8 : Fin 10) := by
  change ACell9_8 = RMVec 9 8 - 0
  funext n
  fin_cases n <;>
    norm_num [ACell9_8, RMVec, RMVecRow9,
      D12PolynomialData.RM9c8, constVec, basis]

theorem entry9 :
    AVec (9 : Fin 20) (9 : Fin 10) =
      characterStackVec RMVec SMVec (-1)
        (1) (9 : Fin 20) (9 : Fin 10) := by
  change ACell9_9 = RMVec 9 9 - constVec (-1)
  funext n
  fin_cases n <;>
    norm_num [ACell9_9, RMVec, RMVecRow9,
      D12PolynomialData.RM9c9, constVec, basis]

theorem row_eq (j : Fin 10) :
    AVec (9 : Fin 20) j =
      characterStackVec RMVec SMVec (-1)
        (1) (9 : Fin 20) j := by
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

end V14Formalization.D12PieceAPActionRow9
