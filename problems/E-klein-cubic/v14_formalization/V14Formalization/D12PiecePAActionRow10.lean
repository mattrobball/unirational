/- PA character-stack identification, row 10. Auto-generated. -/
import V14Formalization.D12PiecePAData

noncomputable section
namespace V14Formalization.D12PiecePAActionRow10
open D12CyclotomicVec D12PieceVecBase D12PiecePAData

theorem entry0 :
    AVec (10 : Fin 20) (0 : Fin 10) =
      characterStackVec RMVec SMVec 1 (-1)
        (10 : Fin 20) (0 : Fin 10) := by
  change ACell10_0 = SMVec 0 0 - constVec (-1)
  funext n
  fin_cases n <;>
    norm_num [ACell10_0, SMVec, SMVecRow0,
      D12PolynomialData.SM0c0, constVec, basis]

theorem entry1 :
    AVec (10 : Fin 20) (1 : Fin 10) =
      characterStackVec RMVec SMVec 1 (-1)
        (10 : Fin 20) (1 : Fin 10) := by
  change ACell10_1 = SMVec 0 1 - 0
  funext n
  fin_cases n <;>
    norm_num [ACell10_1, SMVec, SMVecRow0,
      D12PolynomialData.SM0c1, constVec, basis]

theorem entry2 :
    AVec (10 : Fin 20) (2 : Fin 10) =
      characterStackVec RMVec SMVec 1 (-1)
        (10 : Fin 20) (2 : Fin 10) := by
  change ACell10_2 = SMVec 0 2 - 0
  funext n
  fin_cases n <;>
    norm_num [ACell10_2, SMVec, SMVecRow0,
      D12PolynomialData.SM0c2, constVec, basis]

theorem entry3 :
    AVec (10 : Fin 20) (3 : Fin 10) =
      characterStackVec RMVec SMVec 1 (-1)
        (10 : Fin 20) (3 : Fin 10) := by
  change ACell10_3 = SMVec 0 3 - 0
  funext n
  fin_cases n <;>
    norm_num [ACell10_3, SMVec, SMVecRow0,
      D12PolynomialData.SM0c3, constVec, basis]

theorem entry4 :
    AVec (10 : Fin 20) (4 : Fin 10) =
      characterStackVec RMVec SMVec 1 (-1)
        (10 : Fin 20) (4 : Fin 10) := by
  change ACell10_4 = SMVec 0 4 - 0
  funext n
  fin_cases n <;>
    norm_num [ACell10_4, SMVec, SMVecRow0,
      D12PolynomialData.SM0c4, constVec, basis]

theorem entry5 :
    AVec (10 : Fin 20) (5 : Fin 10) =
      characterStackVec RMVec SMVec 1 (-1)
        (10 : Fin 20) (5 : Fin 10) := by
  change ACell10_5 = SMVec 0 5 - 0
  funext n
  fin_cases n <;>
    norm_num [ACell10_5, SMVec, SMVecRow0,
      D12PolynomialData.SM0c5, constVec, basis]

theorem entry6 :
    AVec (10 : Fin 20) (6 : Fin 10) =
      characterStackVec RMVec SMVec 1 (-1)
        (10 : Fin 20) (6 : Fin 10) := by
  change ACell10_6 = SMVec 0 6 - 0
  funext n
  fin_cases n <;>
    norm_num [ACell10_6, SMVec, SMVecRow0,
      D12PolynomialData.SM0c6, constVec, basis]

theorem entry7 :
    AVec (10 : Fin 20) (7 : Fin 10) =
      characterStackVec RMVec SMVec 1 (-1)
        (10 : Fin 20) (7 : Fin 10) := by
  change ACell10_7 = SMVec 0 7 - 0
  funext n
  fin_cases n <;>
    norm_num [ACell10_7, SMVec, SMVecRow0,
      D12PolynomialData.SM0c7, constVec, basis]

theorem entry8 :
    AVec (10 : Fin 20) (8 : Fin 10) =
      characterStackVec RMVec SMVec 1 (-1)
        (10 : Fin 20) (8 : Fin 10) := by
  change ACell10_8 = SMVec 0 8 - 0
  funext n
  fin_cases n <;>
    norm_num [ACell10_8, SMVec, SMVecRow0,
      D12PolynomialData.SM0c8, constVec, basis]

theorem entry9 :
    AVec (10 : Fin 20) (9 : Fin 10) =
      characterStackVec RMVec SMVec 1 (-1)
        (10 : Fin 20) (9 : Fin 10) := by
  change ACell10_9 = SMVec 0 9 - 0
  funext n
  fin_cases n <;>
    norm_num [ACell10_9, SMVec, SMVecRow0,
      D12PolynomialData.SM0c9, constVec, basis]

theorem row_eq (j : Fin 10) :
    AVec (10 : Fin 20) j =
      characterStackVec RMVec SMVec 1 (-1) (10 : Fin 20) j := by
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

end V14Formalization.D12PiecePAActionRow10
