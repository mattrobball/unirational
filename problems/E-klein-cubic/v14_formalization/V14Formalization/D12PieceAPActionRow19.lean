/- AP character-stack identification row 19. Auto-generated. -/
module

public import V14Formalization.D12PieceAPData

noncomputable section
namespace V14Formalization.D12PieceAPActionRow19
open D12CyclotomicVec D12PieceVecBase D12PieceAPData

theorem entry0 :
    AVec (19 : Fin 20) (0 : Fin 10) =
      characterStackVec RMVec SMVec (-1)
        (1) (19 : Fin 20) (0 : Fin 10) := by
  change ACell19_0 = SMVec 9 0 - 0
  funext n
  fin_cases n <;>
    norm_num [ACell19_0, SMVec, SMVecRow9,
      D12PolynomialData.SM9c0, constVec, basis]

theorem entry1 :
    AVec (19 : Fin 20) (1 : Fin 10) =
      characterStackVec RMVec SMVec (-1)
        (1) (19 : Fin 20) (1 : Fin 10) := by
  change ACell19_1 = SMVec 9 1 - 0
  funext n
  fin_cases n <;>
    norm_num [ACell19_1, SMVec, SMVecRow9,
      D12PolynomialData.SM9c1, constVec, basis]

theorem entry2 :
    AVec (19 : Fin 20) (2 : Fin 10) =
      characterStackVec RMVec SMVec (-1)
        (1) (19 : Fin 20) (2 : Fin 10) := by
  change ACell19_2 = SMVec 9 2 - 0
  funext n
  fin_cases n <;>
    norm_num [ACell19_2, SMVec, SMVecRow9,
      D12PolynomialData.SM9c2, constVec, basis]

theorem entry3 :
    AVec (19 : Fin 20) (3 : Fin 10) =
      characterStackVec RMVec SMVec (-1)
        (1) (19 : Fin 20) (3 : Fin 10) := by
  change ACell19_3 = SMVec 9 3 - 0
  funext n
  fin_cases n <;>
    norm_num [ACell19_3, SMVec, SMVecRow9,
      D12PolynomialData.SM9c3, constVec, basis]

theorem entry4 :
    AVec (19 : Fin 20) (4 : Fin 10) =
      characterStackVec RMVec SMVec (-1)
        (1) (19 : Fin 20) (4 : Fin 10) := by
  change ACell19_4 = SMVec 9 4 - 0
  funext n
  fin_cases n <;>
    norm_num [ACell19_4, SMVec, SMVecRow9,
      D12PolynomialData.SM9c4, constVec, basis]

theorem entry5 :
    AVec (19 : Fin 20) (5 : Fin 10) =
      characterStackVec RMVec SMVec (-1)
        (1) (19 : Fin 20) (5 : Fin 10) := by
  change ACell19_5 = SMVec 9 5 - 0
  funext n
  fin_cases n <;>
    norm_num [ACell19_5, SMVec, SMVecRow9,
      D12PolynomialData.SM9c5, constVec, basis]

theorem entry6 :
    AVec (19 : Fin 20) (6 : Fin 10) =
      characterStackVec RMVec SMVec (-1)
        (1) (19 : Fin 20) (6 : Fin 10) := by
  change ACell19_6 = SMVec 9 6 - 0
  funext n
  fin_cases n <;>
    norm_num [ACell19_6, SMVec, SMVecRow9,
      D12PolynomialData.SM9c6, constVec, basis]

theorem entry7 :
    AVec (19 : Fin 20) (7 : Fin 10) =
      characterStackVec RMVec SMVec (-1)
        (1) (19 : Fin 20) (7 : Fin 10) := by
  change ACell19_7 = SMVec 9 7 - 0
  funext n
  fin_cases n <;>
    norm_num [ACell19_7, SMVec, SMVecRow9,
      D12PolynomialData.SM9c7, constVec, basis]

theorem entry8 :
    AVec (19 : Fin 20) (8 : Fin 10) =
      characterStackVec RMVec SMVec (-1)
        (1) (19 : Fin 20) (8 : Fin 10) := by
  change ACell19_8 = SMVec 9 8 - 0
  funext n
  fin_cases n <;>
    norm_num [ACell19_8, SMVec, SMVecRow9,
      D12PolynomialData.SM9c8, constVec, basis]

theorem entry9 :
    AVec (19 : Fin 20) (9 : Fin 10) =
      characterStackVec RMVec SMVec (-1)
        (1) (19 : Fin 20) (9 : Fin 10) := by
  change ACell19_9 = SMVec 9 9 - constVec (1)
  funext n
  fin_cases n <;>
    norm_num [ACell19_9, SMVec, SMVecRow9,
      D12PolynomialData.SM9c9, constVec, basis]

public theorem row_eq (j : Fin 10) :
    AVec (19 : Fin 20) j =
      characterStackVec RMVec SMVec (-1)
        (1) (19 : Fin 20) j := by
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

end V14Formalization.D12PieceAPActionRow19
