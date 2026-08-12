/- Complete PP split identity. Auto-generated structural assembly. -/
import V14Formalization.D12PiecePPSplitRow0
import V14Formalization.D12PiecePPSplitRow1
import V14Formalization.D12PiecePPSplitRow2
import V14Formalization.D12PiecePPSplitRow3
import V14Formalization.D12PiecePPSplitRow4
import V14Formalization.D12PiecePPSplitRow5
import V14Formalization.D12PiecePPSplitRow6
import V14Formalization.D12PiecePPSplitRow7
import V14Formalization.D12PiecePPSplitRow8
import V14Formalization.D12PiecePPSplitRow9

noncomputable section
namespace V14Formalization.D12PiecePPSplit
open D12CyclotomicVec D12PiecePPData

theorem split_identity :
    matrixMul XVec AVec + matrixMul KVec YVec = matrixOne (Fin 10) := by
  apply Matrix.ext
  intro i j
  fin_cases i
  · exact D12PiecePPSplitRow0.row_eq j
  · exact D12PiecePPSplitRow1.row_eq j
  · exact D12PiecePPSplitRow2.row_eq j
  · exact D12PiecePPSplitRow3.row_eq j
  · exact D12PiecePPSplitRow4.row_eq j
  · exact D12PiecePPSplitRow5.row_eq j
  · exact D12PiecePPSplitRow6.row_eq j
  · exact D12PiecePPSplitRow7.row_eq j
  · exact D12PiecePPSplitRow8.row_eq j
  · exact D12PiecePPSplitRow9.row_eq j

end V14Formalization.D12PiecePPSplit
