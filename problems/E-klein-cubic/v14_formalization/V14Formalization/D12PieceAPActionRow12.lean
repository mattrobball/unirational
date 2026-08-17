/- AP character-stack identification row 12. Auto-generated. -/
module

public import V14Formalization.D12PieceAPData

noncomputable section
namespace V14Formalization.D12PieceAPActionRow12
open D12CyclotomicVec D12PieceVecBase D12PieceAPData

theorem entry0 :
    AVec (12 : Fin 20) (0 : Fin 10) =
      characterStackVec RMVec SMVec (-1)
        (1) (12 : Fin 20) (0 : Fin 10) := by
  change ACell12_0 = SMVec 2 0 - 0
  funext n
  fin_cases n <;>
    norm_num [ACell12_0, SMVec, SMVecRow2,
      D12PolynomialData.SM2c0, constVec, basis]

theorem entry1 :
    AVec (12 : Fin 20) (1 : Fin 10) =
      characterStackVec RMVec SMVec (-1)
        (1) (12 : Fin 20) (1 : Fin 10) := by
  change ACell12_1 = SMVec 2 1 - 0
  funext n
  fin_cases n <;>
    norm_num [ACell12_1, SMVec, SMVecRow2,
      D12PolynomialData.SM2c1, constVec, basis]

theorem entry2 :
    AVec (12 : Fin 20) (2 : Fin 10) =
      characterStackVec RMVec SMVec (-1)
        (1) (12 : Fin 20) (2 : Fin 10) := by
  change ACell12_2 = SMVec 2 2 - constVec (1)
  funext n
  fin_cases n <;>
    norm_num [ACell12_2, SMVec, SMVecRow2,
      D12PolynomialData.SM2c2, constVec, basis]

theorem entry3 :
    AVec (12 : Fin 20) (3 : Fin 10) =
      characterStackVec RMVec SMVec (-1)
        (1) (12 : Fin 20) (3 : Fin 10) := by
  change ACell12_3 = SMVec 2 3 - 0
  funext n
  fin_cases n <;>
    norm_num [ACell12_3, SMVec, SMVecRow2,
      D12PolynomialData.SM2c3, constVec, basis]

theorem entry4 :
    AVec (12 : Fin 20) (4 : Fin 10) =
      characterStackVec RMVec SMVec (-1)
        (1) (12 : Fin 20) (4 : Fin 10) := by
  change ACell12_4 = SMVec 2 4 - 0
  funext n
  fin_cases n <;>
    norm_num [ACell12_4, SMVec, SMVecRow2,
      D12PolynomialData.SM2c4, constVec, basis]

theorem entry5 :
    AVec (12 : Fin 20) (5 : Fin 10) =
      characterStackVec RMVec SMVec (-1)
        (1) (12 : Fin 20) (5 : Fin 10) := by
  change ACell12_5 = SMVec 2 5 - 0
  funext n
  fin_cases n <;>
    norm_num [ACell12_5, SMVec, SMVecRow2,
      D12PolynomialData.SM2c5, constVec, basis]

theorem entry6 :
    AVec (12 : Fin 20) (6 : Fin 10) =
      characterStackVec RMVec SMVec (-1)
        (1) (12 : Fin 20) (6 : Fin 10) := by
  change ACell12_6 = SMVec 2 6 - 0
  funext n
  fin_cases n <;>
    norm_num [ACell12_6, SMVec, SMVecRow2,
      D12PolynomialData.SM2c6, constVec, basis]

theorem entry7 :
    AVec (12 : Fin 20) (7 : Fin 10) =
      characterStackVec RMVec SMVec (-1)
        (1) (12 : Fin 20) (7 : Fin 10) := by
  change ACell12_7 = SMVec 2 7 - 0
  funext n
  fin_cases n <;>
    norm_num [ACell12_7, SMVec, SMVecRow2,
      D12PolynomialData.SM2c7, constVec, basis]

theorem entry8 :
    AVec (12 : Fin 20) (8 : Fin 10) =
      characterStackVec RMVec SMVec (-1)
        (1) (12 : Fin 20) (8 : Fin 10) := by
  change ACell12_8 = SMVec 2 8 - 0
  funext n
  fin_cases n <;>
    norm_num [ACell12_8, SMVec, SMVecRow2,
      D12PolynomialData.SM2c8, constVec, basis]

theorem entry9 :
    AVec (12 : Fin 20) (9 : Fin 10) =
      characterStackVec RMVec SMVec (-1)
        (1) (12 : Fin 20) (9 : Fin 10) := by
  change ACell12_9 = SMVec 2 9 - 0
  funext n
  fin_cases n <;>
    norm_num [ACell12_9, SMVec, SMVecRow2,
      D12PolynomialData.SM2c9, constVec, basis]

public theorem row_eq (j : Fin 10) :
    AVec (12 : Fin 20) j =
      characterStackVec RMVec SMVec (-1)
        (1) (12 : Fin 20) j := by
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

end V14Formalization.D12PieceAPActionRow12
