/- AP character-stack identification row 13. Auto-generated. -/
import V14Formalization.D12PieceAPData

noncomputable section
namespace V14Formalization.D12PieceAPActionRow13
open D12CyclotomicVec D12PieceVecBase D12PieceAPData

theorem entry0 :
    AVec (13 : Fin 20) (0 : Fin 10) =
      characterStackVec RMVec SMVec (-1)
        (1) (13 : Fin 20) (0 : Fin 10) := by
  change ACell13_0 = SMVec 3 0 - 0
  funext n
  fin_cases n <;>
    norm_num [ACell13_0, SMVec, SMVecRow3,
      D12PolynomialData.SM3c0, constVec, basis]

theorem entry1 :
    AVec (13 : Fin 20) (1 : Fin 10) =
      characterStackVec RMVec SMVec (-1)
        (1) (13 : Fin 20) (1 : Fin 10) := by
  change ACell13_1 = SMVec 3 1 - 0
  funext n
  fin_cases n <;>
    norm_num [ACell13_1, SMVec, SMVecRow3,
      D12PolynomialData.SM3c1, constVec, basis]

theorem entry2 :
    AVec (13 : Fin 20) (2 : Fin 10) =
      characterStackVec RMVec SMVec (-1)
        (1) (13 : Fin 20) (2 : Fin 10) := by
  change ACell13_2 = SMVec 3 2 - 0
  funext n
  fin_cases n <;>
    norm_num [ACell13_2, SMVec, SMVecRow3,
      D12PolynomialData.SM3c2, constVec, basis]

theorem entry3 :
    AVec (13 : Fin 20) (3 : Fin 10) =
      characterStackVec RMVec SMVec (-1)
        (1) (13 : Fin 20) (3 : Fin 10) := by
  change ACell13_3 = SMVec 3 3 - constVec (1)
  funext n
  fin_cases n <;>
    norm_num [ACell13_3, SMVec, SMVecRow3,
      D12PolynomialData.SM3c3, constVec, basis]

theorem entry4 :
    AVec (13 : Fin 20) (4 : Fin 10) =
      characterStackVec RMVec SMVec (-1)
        (1) (13 : Fin 20) (4 : Fin 10) := by
  change ACell13_4 = SMVec 3 4 - 0
  funext n
  fin_cases n <;>
    norm_num [ACell13_4, SMVec, SMVecRow3,
      D12PolynomialData.SM3c4, constVec, basis]

theorem entry5 :
    AVec (13 : Fin 20) (5 : Fin 10) =
      characterStackVec RMVec SMVec (-1)
        (1) (13 : Fin 20) (5 : Fin 10) := by
  change ACell13_5 = SMVec 3 5 - 0
  funext n
  fin_cases n <;>
    norm_num [ACell13_5, SMVec, SMVecRow3,
      D12PolynomialData.SM3c5, constVec, basis]

theorem entry6 :
    AVec (13 : Fin 20) (6 : Fin 10) =
      characterStackVec RMVec SMVec (-1)
        (1) (13 : Fin 20) (6 : Fin 10) := by
  change ACell13_6 = SMVec 3 6 - 0
  funext n
  fin_cases n <;>
    norm_num [ACell13_6, SMVec, SMVecRow3,
      D12PolynomialData.SM3c6, constVec, basis]

theorem entry7 :
    AVec (13 : Fin 20) (7 : Fin 10) =
      characterStackVec RMVec SMVec (-1)
        (1) (13 : Fin 20) (7 : Fin 10) := by
  change ACell13_7 = SMVec 3 7 - 0
  funext n
  fin_cases n <;>
    norm_num [ACell13_7, SMVec, SMVecRow3,
      D12PolynomialData.SM3c7, constVec, basis]

theorem entry8 :
    AVec (13 : Fin 20) (8 : Fin 10) =
      characterStackVec RMVec SMVec (-1)
        (1) (13 : Fin 20) (8 : Fin 10) := by
  change ACell13_8 = SMVec 3 8 - 0
  funext n
  fin_cases n <;>
    norm_num [ACell13_8, SMVec, SMVecRow3,
      D12PolynomialData.SM3c8, constVec, basis]

theorem entry9 :
    AVec (13 : Fin 20) (9 : Fin 10) =
      characterStackVec RMVec SMVec (-1)
        (1) (13 : Fin 20) (9 : Fin 10) := by
  change ACell13_9 = SMVec 3 9 - 0
  funext n
  fin_cases n <;>
    norm_num [ACell13_9, SMVec, SMVecRow3,
      D12PolynomialData.SM3c9, constVec, basis]

theorem row_eq (j : Fin 10) :
    AVec (13 : Fin 20) j =
      characterStackVec RMVec SMVec (-1)
        (1) (13 : Fin 20) j := by
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

end V14Formalization.D12PieceAPActionRow13
