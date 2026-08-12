/- PA character-stack identification, row 17. Auto-generated. -/
import V14Formalization.D12PiecePAData

noncomputable section
namespace V14Formalization.D12PiecePAActionRow17
open D12CyclotomicVec D12PieceVecBase D12PiecePAData

theorem entry0 :
    AVec (17 : Fin 20) (0 : Fin 10) =
      characterStackVec RMVec SMVec 1 (-1)
        (17 : Fin 20) (0 : Fin 10) := by
  change ACell17_0 = SMVec 7 0 - 0
  funext n
  fin_cases n <;>
    norm_num [ACell17_0, SMVec, SMVecRow7,
      D12PolynomialData.SM7c0, constVec, basis]

theorem entry1 :
    AVec (17 : Fin 20) (1 : Fin 10) =
      characterStackVec RMVec SMVec 1 (-1)
        (17 : Fin 20) (1 : Fin 10) := by
  change ACell17_1 = SMVec 7 1 - 0
  funext n
  fin_cases n <;>
    norm_num [ACell17_1, SMVec, SMVecRow7,
      D12PolynomialData.SM7c1, constVec, basis]

theorem entry2 :
    AVec (17 : Fin 20) (2 : Fin 10) =
      characterStackVec RMVec SMVec 1 (-1)
        (17 : Fin 20) (2 : Fin 10) := by
  change ACell17_2 = SMVec 7 2 - 0
  funext n
  fin_cases n <;>
    norm_num [ACell17_2, SMVec, SMVecRow7,
      D12PolynomialData.SM7c2, constVec, basis]

theorem entry3 :
    AVec (17 : Fin 20) (3 : Fin 10) =
      characterStackVec RMVec SMVec 1 (-1)
        (17 : Fin 20) (3 : Fin 10) := by
  change ACell17_3 = SMVec 7 3 - 0
  funext n
  fin_cases n <;>
    norm_num [ACell17_3, SMVec, SMVecRow7,
      D12PolynomialData.SM7c3, constVec, basis]

theorem entry4 :
    AVec (17 : Fin 20) (4 : Fin 10) =
      characterStackVec RMVec SMVec 1 (-1)
        (17 : Fin 20) (4 : Fin 10) := by
  change ACell17_4 = SMVec 7 4 - 0
  funext n
  fin_cases n <;>
    norm_num [ACell17_4, SMVec, SMVecRow7,
      D12PolynomialData.SM7c4, constVec, basis]

theorem entry5 :
    AVec (17 : Fin 20) (5 : Fin 10) =
      characterStackVec RMVec SMVec 1 (-1)
        (17 : Fin 20) (5 : Fin 10) := by
  change ACell17_5 = SMVec 7 5 - 0
  funext n
  fin_cases n <;>
    norm_num [ACell17_5, SMVec, SMVecRow7,
      D12PolynomialData.SM7c5, constVec, basis]

theorem entry6 :
    AVec (17 : Fin 20) (6 : Fin 10) =
      characterStackVec RMVec SMVec 1 (-1)
        (17 : Fin 20) (6 : Fin 10) := by
  change ACell17_6 = SMVec 7 6 - 0
  funext n
  fin_cases n <;>
    norm_num [ACell17_6, SMVec, SMVecRow7,
      D12PolynomialData.SM7c6, constVec, basis]

theorem entry7 :
    AVec (17 : Fin 20) (7 : Fin 10) =
      characterStackVec RMVec SMVec 1 (-1)
        (17 : Fin 20) (7 : Fin 10) := by
  change ACell17_7 = SMVec 7 7 - constVec (-1)
  funext n
  fin_cases n <;>
    norm_num [ACell17_7, SMVec, SMVecRow7,
      D12PolynomialData.SM7c7, constVec, basis]

theorem entry8 :
    AVec (17 : Fin 20) (8 : Fin 10) =
      characterStackVec RMVec SMVec 1 (-1)
        (17 : Fin 20) (8 : Fin 10) := by
  change ACell17_8 = SMVec 7 8 - 0
  funext n
  fin_cases n <;>
    norm_num [ACell17_8, SMVec, SMVecRow7,
      D12PolynomialData.SM7c8, constVec, basis]

theorem entry9 :
    AVec (17 : Fin 20) (9 : Fin 10) =
      characterStackVec RMVec SMVec 1 (-1)
        (17 : Fin 20) (9 : Fin 10) := by
  change ACell17_9 = SMVec 7 9 - 0
  funext n
  fin_cases n <;>
    norm_num [ACell17_9, SMVec, SMVecRow7,
      D12PolynomialData.SM7c9, constVec, basis]

theorem row_eq (j : Fin 10) :
    AVec (17 : Fin 20) j =
      characterStackVec RMVec SMVec 1 (-1) (17 : Fin 20) j := by
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

end V14Formalization.D12PiecePAActionRow17
