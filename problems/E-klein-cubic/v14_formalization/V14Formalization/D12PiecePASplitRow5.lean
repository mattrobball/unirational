/- PA split identity, row 5. Auto-generated. -/
import V14Formalization.D12PiecePASplitEntry5_0
import V14Formalization.D12PiecePASplitEntry5_1
import V14Formalization.D12PiecePASplitEntry5_2
import V14Formalization.D12PiecePASplitEntry5_3
import V14Formalization.D12PiecePASplitEntry5_4
import V14Formalization.D12PiecePASplitEntry5_5
import V14Formalization.D12PiecePASplitEntry5_6
import V14Formalization.D12PiecePASplitEntry5_7
import V14Formalization.D12PiecePASplitEntry5_8
import V14Formalization.D12PiecePASplitEntry5_9

noncomputable section
namespace V14Formalization.D12PiecePASplitRow5
open D12CyclotomicVec D12PiecePAData

theorem row_eq (j : Fin 10) :
    (matrixMul XVec AVec) (5 : Fin 10) j =
      matrixOne (Fin 10) (5 : Fin 10) j := by
  fin_cases j
  · exact D12PiecePASplitEntry5_0.entry_eq_matrixOne
  · exact D12PiecePASplitEntry5_1.entry_eq_matrixOne
  · exact D12PiecePASplitEntry5_2.entry_eq_matrixOne
  · exact D12PiecePASplitEntry5_3.entry_eq_matrixOne
  · exact D12PiecePASplitEntry5_4.entry_eq_matrixOne
  · exact D12PiecePASplitEntry5_5.entry_eq_matrixOne
  · exact D12PiecePASplitEntry5_6.entry_eq_matrixOne
  · exact D12PiecePASplitEntry5_7.entry_eq_matrixOne
  · exact D12PiecePASplitEntry5_8.entry_eq_matrixOne
  · exact D12PiecePASplitEntry5_9.entry_eq_matrixOne

end V14Formalization.D12PiecePASplitRow5
