/- AA character-stack identification row 15. Auto-generated. -/
module

public import V14Formalization.D12PieceAAData

noncomputable section
namespace V14Formalization.D12PieceAAActionRow15
open D12CyclotomicVec D12PieceVecBase D12PieceAAData

theorem entry0 :
    AVec (15 : Fin 20) (0 : Fin 10) =
      characterStackVec RMVec SMVec (-1)
        (-1) (15 : Fin 20) (0 : Fin 10) := by
  change ACell15_0 = SMVec 5 0 - 0
  funext n
  fin_cases n <;>
    norm_num [ACell15_0, SMVec, SMVecRow5,
      D12PolynomialData.SM5c0, constVec, basis]

theorem entry1 :
    AVec (15 : Fin 20) (1 : Fin 10) =
      characterStackVec RMVec SMVec (-1)
        (-1) (15 : Fin 20) (1 : Fin 10) := by
  change ACell15_1 = SMVec 5 1 - 0
  funext n
  fin_cases n <;>
    norm_num [ACell15_1, SMVec, SMVecRow5,
      D12PolynomialData.SM5c1, constVec, basis]

theorem entry2 :
    AVec (15 : Fin 20) (2 : Fin 10) =
      characterStackVec RMVec SMVec (-1)
        (-1) (15 : Fin 20) (2 : Fin 10) := by
  change ACell15_2 = SMVec 5 2 - 0
  funext n
  fin_cases n <;>
    norm_num [ACell15_2, SMVec, SMVecRow5,
      D12PolynomialData.SM5c2, constVec, basis]

theorem entry3 :
    AVec (15 : Fin 20) (3 : Fin 10) =
      characterStackVec RMVec SMVec (-1)
        (-1) (15 : Fin 20) (3 : Fin 10) := by
  change ACell15_3 = SMVec 5 3 - 0
  funext n
  fin_cases n <;>
    norm_num [ACell15_3, SMVec, SMVecRow5,
      D12PolynomialData.SM5c3, constVec, basis]

theorem entry4 :
    AVec (15 : Fin 20) (4 : Fin 10) =
      characterStackVec RMVec SMVec (-1)
        (-1) (15 : Fin 20) (4 : Fin 10) := by
  change ACell15_4 = SMVec 5 4 - 0
  funext n
  fin_cases n <;>
    norm_num [ACell15_4, SMVec, SMVecRow5,
      D12PolynomialData.SM5c4, constVec, basis]

theorem entry5 :
    AVec (15 : Fin 20) (5 : Fin 10) =
      characterStackVec RMVec SMVec (-1)
        (-1) (15 : Fin 20) (5 : Fin 10) := by
  change ACell15_5 = SMVec 5 5 - constVec (-1)
  funext n
  fin_cases n <;>
    norm_num [ACell15_5, SMVec, SMVecRow5,
      D12PolynomialData.SM5c5, constVec, basis]

theorem entry6 :
    AVec (15 : Fin 20) (6 : Fin 10) =
      characterStackVec RMVec SMVec (-1)
        (-1) (15 : Fin 20) (6 : Fin 10) := by
  change ACell15_6 = SMVec 5 6 - 0
  funext n
  fin_cases n <;>
    norm_num [ACell15_6, SMVec, SMVecRow5,
      D12PolynomialData.SM5c6, constVec, basis]

theorem entry7 :
    AVec (15 : Fin 20) (7 : Fin 10) =
      characterStackVec RMVec SMVec (-1)
        (-1) (15 : Fin 20) (7 : Fin 10) := by
  change ACell15_7 = SMVec 5 7 - 0
  funext n
  fin_cases n <;>
    norm_num [ACell15_7, SMVec, SMVecRow5,
      D12PolynomialData.SM5c7, constVec, basis]

theorem entry8 :
    AVec (15 : Fin 20) (8 : Fin 10) =
      characterStackVec RMVec SMVec (-1)
        (-1) (15 : Fin 20) (8 : Fin 10) := by
  change ACell15_8 = SMVec 5 8 - 0
  funext n
  fin_cases n <;>
    norm_num [ACell15_8, SMVec, SMVecRow5,
      D12PolynomialData.SM5c8, constVec, basis]

theorem entry9 :
    AVec (15 : Fin 20) (9 : Fin 10) =
      characterStackVec RMVec SMVec (-1)
        (-1) (15 : Fin 20) (9 : Fin 10) := by
  change ACell15_9 = SMVec 5 9 - 0
  funext n
  fin_cases n <;>
    norm_num [ACell15_9, SMVec, SMVecRow5,
      D12PolynomialData.SM5c9, constVec, basis]

public theorem row_eq (j : Fin 10) :
    AVec (15 : Fin 20) j =
      characterStackVec RMVec SMVec (-1)
        (-1) (15 : Fin 20) j := by
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

end V14Formalization.D12PieceAAActionRow15
