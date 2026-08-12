/- Complete AP split identity. Auto-generated structural assembly. -/
import V14Formalization.D12PieceAPSplitRow0
import V14Formalization.D12PieceAPSplitRow1
import V14Formalization.D12PieceAPSplitRow2
import V14Formalization.D12PieceAPSplitRow3
import V14Formalization.D12PieceAPSplitRow4
import V14Formalization.D12PieceAPSplitRow5
import V14Formalization.D12PieceAPSplitRow6
import V14Formalization.D12PieceAPSplitRow7
import V14Formalization.D12PieceAPSplitRow8
import V14Formalization.D12PieceAPSplitRow9

noncomputable section
namespace V14Formalization.D12PieceAPSplit
open D12CyclotomicVec D12PieceAPData

theorem split_identity :
    matrixMul XVec AVec + matrixMul KVec YVec = matrixOne (Fin 10) := by
  apply Matrix.ext
  intro i j
  fin_cases i
  · exact D12PieceAPSplitRow0.row_eq j
  · exact D12PieceAPSplitRow1.row_eq j
  · exact D12PieceAPSplitRow2.row_eq j
  · exact D12PieceAPSplitRow3.row_eq j
  · exact D12PieceAPSplitRow4.row_eq j
  · exact D12PieceAPSplitRow5.row_eq j
  · exact D12PieceAPSplitRow6.row_eq j
  · exact D12PieceAPSplitRow7.row_eq j
  · exact D12PieceAPSplitRow8.row_eq j
  · exact D12PieceAPSplitRow9.row_eq j

end V14Formalization.D12PieceAPSplit
