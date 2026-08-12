/- PP character-stack identification row 4. Auto-generated. -/
import V14Formalization.D12PiecePPData

noncomputable section
namespace V14Formalization.D12PiecePPActionRow4
open D12CyclotomicVec D12PieceVecBase D12PiecePPData

theorem entry0 :
    AVec (4 : Fin 20) (0 : Fin 10) =
      characterStackVec RMVec SMVec (1)
        (1) (4 : Fin 20) (0 : Fin 10) := by
  change ACell4_0 = RMVec 4 0 - 0
  funext n
  fin_cases n <;>
    norm_num [ACell4_0, RMVec, RMVecRow4,
      D12PolynomialData.RM4c0, constVec, basis]

theorem entry1 :
    AVec (4 : Fin 20) (1 : Fin 10) =
      characterStackVec RMVec SMVec (1)
        (1) (4 : Fin 20) (1 : Fin 10) := by
  change ACell4_1 = RMVec 4 1 - 0
  funext n
  fin_cases n <;>
    norm_num [ACell4_1, RMVec, RMVecRow4,
      D12PolynomialData.RM4c1, constVec, basis]

theorem entry2 :
    AVec (4 : Fin 20) (2 : Fin 10) =
      characterStackVec RMVec SMVec (1)
        (1) (4 : Fin 20) (2 : Fin 10) := by
  change ACell4_2 = RMVec 4 2 - 0
  funext n
  fin_cases n <;>
    norm_num [ACell4_2, RMVec, RMVecRow4,
      D12PolynomialData.RM4c2, constVec, basis]

theorem entry3 :
    AVec (4 : Fin 20) (3 : Fin 10) =
      characterStackVec RMVec SMVec (1)
        (1) (4 : Fin 20) (3 : Fin 10) := by
  change ACell4_3 = RMVec 4 3 - 0
  funext n
  fin_cases n <;>
    norm_num [ACell4_3, RMVec, RMVecRow4,
      D12PolynomialData.RM4c3, constVec, basis]

theorem entry4 :
    AVec (4 : Fin 20) (4 : Fin 10) =
      characterStackVec RMVec SMVec (1)
        (1) (4 : Fin 20) (4 : Fin 10) := by
  change ACell4_4 = RMVec 4 4 - constVec (1)
  funext n
  fin_cases n <;>
    norm_num [ACell4_4, RMVec, RMVecRow4,
      D12PolynomialData.RM4c4, constVec, basis]

theorem entry5 :
    AVec (4 : Fin 20) (5 : Fin 10) =
      characterStackVec RMVec SMVec (1)
        (1) (4 : Fin 20) (5 : Fin 10) := by
  change ACell4_5 = RMVec 4 5 - 0
  funext n
  fin_cases n <;>
    norm_num [ACell4_5, RMVec, RMVecRow4,
      D12PolynomialData.RM4c5, constVec, basis]

theorem entry6 :
    AVec (4 : Fin 20) (6 : Fin 10) =
      characterStackVec RMVec SMVec (1)
        (1) (4 : Fin 20) (6 : Fin 10) := by
  change ACell4_6 = RMVec 4 6 - 0
  funext n
  fin_cases n <;>
    norm_num [ACell4_6, RMVec, RMVecRow4,
      D12PolynomialData.RM4c6, constVec, basis]

theorem entry7 :
    AVec (4 : Fin 20) (7 : Fin 10) =
      characterStackVec RMVec SMVec (1)
        (1) (4 : Fin 20) (7 : Fin 10) := by
  change ACell4_7 = RMVec 4 7 - 0
  funext n
  fin_cases n <;>
    norm_num [ACell4_7, RMVec, RMVecRow4,
      D12PolynomialData.RM4c7, constVec, basis]

theorem entry8 :
    AVec (4 : Fin 20) (8 : Fin 10) =
      characterStackVec RMVec SMVec (1)
        (1) (4 : Fin 20) (8 : Fin 10) := by
  change ACell4_8 = RMVec 4 8 - 0
  funext n
  fin_cases n <;>
    norm_num [ACell4_8, RMVec, RMVecRow4,
      D12PolynomialData.RM4c8, constVec, basis]

theorem entry9 :
    AVec (4 : Fin 20) (9 : Fin 10) =
      characterStackVec RMVec SMVec (1)
        (1) (4 : Fin 20) (9 : Fin 10) := by
  change ACell4_9 = RMVec 4 9 - 0
  funext n
  fin_cases n <;>
    norm_num [ACell4_9, RMVec, RMVecRow4,
      D12PolynomialData.RM4c9, constVec, basis]

theorem row_eq (j : Fin 10) :
    AVec (4 : Fin 20) j =
      characterStackVec RMVec SMVec (1)
        (1) (4 : Fin 20) j := by
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

end V14Formalization.D12PiecePPActionRow4
