/- Complete AA split identity. Auto-generated structural assembly. -/
import V14Formalization.D12PieceAASplitRow0
import V14Formalization.D12PieceAASplitRow1
import V14Formalization.D12PieceAASplitRow2
import V14Formalization.D12PieceAASplitRow3
import V14Formalization.D12PieceAASplitRow4
import V14Formalization.D12PieceAASplitRow5
import V14Formalization.D12PieceAASplitRow6
import V14Formalization.D12PieceAASplitRow7
import V14Formalization.D12PieceAASplitRow8
import V14Formalization.D12PieceAASplitRow9

noncomputable section
namespace V14Formalization.D12PieceAASplit
open D12CyclotomicVec D12PieceAAData

theorem split_identity :
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
