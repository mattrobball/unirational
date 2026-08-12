/- Complete PA split identity. Auto-generated structural assembly. -/
import V14Formalization.D12PiecePASplitRow0
import V14Formalization.D12PiecePASplitRow1
import V14Formalization.D12PiecePASplitRow2
import V14Formalization.D12PiecePASplitRow3
import V14Formalization.D12PiecePASplitRow4
import V14Formalization.D12PiecePASplitRow5
import V14Formalization.D12PiecePASplitRow6
import V14Formalization.D12PiecePASplitRow7
import V14Formalization.D12PiecePASplitRow8
import V14Formalization.D12PiecePASplitRow9

noncomputable section
namespace V14Formalization.D12PiecePASplit
open D12CyclotomicVec D12PiecePAData

theorem split_identity : matrixMul XVec AVec = matrixOne (Fin 10) := by
  apply Matrix.ext
  intro i j
  fin_cases i
  · exact D12PiecePASplitRow0.row_eq j
  · exact D12PiecePASplitRow1.row_eq j
  · exact D12PiecePASplitRow2.row_eq j
  · exact D12PiecePASplitRow3.row_eq j
  · exact D12PiecePASplitRow4.row_eq j
  · exact D12PiecePASplitRow5.row_eq j
  · exact D12PiecePASplitRow6.row_eq j
  · exact D12PiecePASplitRow7.row_eq j
  · exact D12PiecePASplitRow8.row_eq j
  · exact D12PiecePASplitRow9.row_eq j

end V14Formalization.D12PiecePASplit
