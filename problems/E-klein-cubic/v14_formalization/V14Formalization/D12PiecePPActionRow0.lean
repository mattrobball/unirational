/- PP character-stack identification row 0. Auto-generated. -/
import V14Formalization.D12PiecePPData

noncomputable section
namespace V14Formalization.D12PiecePPActionRow0
open D12CyclotomicVec D12PieceVecBase D12PiecePPData

theorem entry0 :
    AVec (0 : Fin 20) (0 : Fin 10) =
      characterStackVec RMVec SMVec (1)
        (1) (0 : Fin 20) (0 : Fin 10) := by
  change ACell0_0 = RMVec 0 0 - constVec (1)
  funext n
  fin_cases n <;>
    norm_num [ACell0_0, RMVec, RMVecRow0,
      D12PolynomialData.RM0c0, constVec, basis]

theorem entry1 :
    AVec (0 : Fin 20) (1 : Fin 10) =
      characterStackVec RMVec SMVec (1)
        (1) (0 : Fin 20) (1 : Fin 10) := by
  change ACell0_1 = RMVec 0 1 - 0
  funext n
  fin_cases n <;>
    norm_num [ACell0_1, RMVec, RMVecRow0,
      D12PolynomialData.RM0c1, constVec, basis]

theorem entry2 :
    AVec (0 : Fin 20) (2 : Fin 10) =
      characterStackVec RMVec SMVec (1)
        (1) (0 : Fin 20) (2 : Fin 10) := by
  change ACell0_2 = RMVec 0 2 - 0
  funext n
  fin_cases n <;>
    norm_num [ACell0_2, RMVec, RMVecRow0,
      D12PolynomialData.RM0c2, constVec, basis]

theorem entry3 :
    AVec (0 : Fin 20) (3 : Fin 10) =
      characterStackVec RMVec SMVec (1)
        (1) (0 : Fin 20) (3 : Fin 10) := by
  change ACell0_3 = RMVec 0 3 - 0
  funext n
  fin_cases n <;>
    norm_num [ACell0_3, RMVec, RMVecRow0,
      D12PolynomialData.RM0c3, constVec, basis]

theorem entry4 :
    AVec (0 : Fin 20) (4 : Fin 10) =
      characterStackVec RMVec SMVec (1)
        (1) (0 : Fin 20) (4 : Fin 10) := by
  change ACell0_4 = RMVec 0 4 - 0
  funext n
  fin_cases n <;>
    norm_num [ACell0_4, RMVec, RMVecRow0,
      D12PolynomialData.RM0c4, constVec, basis]

theorem entry5 :
    AVec (0 : Fin 20) (5 : Fin 10) =
      characterStackVec RMVec SMVec (1)
        (1) (0 : Fin 20) (5 : Fin 10) := by
  change ACell0_5 = RMVec 0 5 - 0
  funext n
  fin_cases n <;>
    norm_num [ACell0_5, RMVec, RMVecRow0,
      D12PolynomialData.RM0c5, constVec, basis]

theorem entry6 :
    AVec (0 : Fin 20) (6 : Fin 10) =
      characterStackVec RMVec SMVec (1)
        (1) (0 : Fin 20) (6 : Fin 10) := by
  change ACell0_6 = RMVec 0 6 - 0
  funext n
  fin_cases n <;>
    norm_num [ACell0_6, RMVec, RMVecRow0,
      D12PolynomialData.RM0c6, constVec, basis]

theorem entry7 :
    AVec (0 : Fin 20) (7 : Fin 10) =
      characterStackVec RMVec SMVec (1)
        (1) (0 : Fin 20) (7 : Fin 10) := by
  change ACell0_7 = RMVec 0 7 - 0
  funext n
  fin_cases n <;>
    norm_num [ACell0_7, RMVec, RMVecRow0,
      D12PolynomialData.RM0c7, constVec, basis]

theorem entry8 :
    AVec (0 : Fin 20) (8 : Fin 10) =
      characterStackVec RMVec SMVec (1)
        (1) (0 : Fin 20) (8 : Fin 10) := by
  change ACell0_8 = RMVec 0 8 - 0
  funext n
  fin_cases n <;>
    norm_num [ACell0_8, RMVec, RMVecRow0,
      D12PolynomialData.RM0c8, constVec, basis]

theorem entry9 :
    AVec (0 : Fin 20) (9 : Fin 10) =
      characterStackVec RMVec SMVec (1)
        (1) (0 : Fin 20) (9 : Fin 10) := by
  change ACell0_9 = RMVec 0 9 - 0
  funext n
  fin_cases n <;>
    norm_num [ACell0_9, RMVec, RMVecRow0,
      D12PolynomialData.RM0c9, constVec, basis]

theorem row_eq (j : Fin 10) :
    AVec (0 : Fin 20) j =
      characterStackVec RMVec SMVec (1)
        (1) (0 : Fin 20) j := by
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

end V14Formalization.D12PiecePPActionRow0
