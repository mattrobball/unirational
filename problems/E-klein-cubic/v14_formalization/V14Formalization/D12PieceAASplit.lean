/- Complete AA split identity. Auto-generated structural assembly. -/
module

public import V14Formalization.D12PieceAASplitRow0
public import V14Formalization.D12PieceAASplitRow1
public import V14Formalization.D12PieceAASplitRow2
public import V14Formalization.D12PieceAASplitRow3
public import V14Formalization.D12PieceAASplitRow4
public import V14Formalization.D12PieceAASplitRow5
public import V14Formalization.D12PieceAASplitRow6
public import V14Formalization.D12PieceAASplitRow7
public import V14Formalization.D12PieceAASplitRow8
public import V14Formalization.D12PieceAASplitRow9

noncomputable section
namespace V14Formalization.D12PieceAASplit
open D12CyclotomicVec D12PieceAAData

public theorem split_identity :
    matrixMul XVec AVec + matrixMul KVec YVec = matrixOne (Fin 10) := by
  apply Matrix.ext
  intro i j
  fin_cases i
  · exact D12PieceAASplitRow0.row_eq j
  · exact D12PieceAASplitRow1.row_eq j
  · exact D12PieceAASplitRow2.row_eq j
  · exact D12PieceAASplitRow3.row_eq j
  · exact D12PieceAASplitRow4.row_eq j
  · exact D12PieceAASplitRow5.row_eq j
  · exact D12PieceAASplitRow6.row_eq j
  · exact D12PieceAASplitRow7.row_eq j
  · exact D12PieceAASplitRow8.row_eq j
  · exact D12PieceAASplitRow9.row_eq j

end V14Formalization.D12PieceAASplit
