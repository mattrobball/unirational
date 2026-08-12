/- PA split identity, row 0. Auto-generated. -/
import V14Formalization.D12PiecePASplitEntry0_0
import V14Formalization.D12PiecePASplitEntry0_1
import V14Formalization.D12PiecePASplitEntry0_2
import V14Formalization.D12PiecePASplitEntry0_3
import V14Formalization.D12PiecePASplitEntry0_4
import V14Formalization.D12PiecePASplitEntry0_5
import V14Formalization.D12PiecePASplitEntry0_6
import V14Formalization.D12PiecePASplitEntry0_7
import V14Formalization.D12PiecePASplitEntry0_8
import V14Formalization.D12PiecePASplitEntry0_9

noncomputable section
namespace V14Formalization.D12PiecePASplitRow0
open D12CyclotomicVec D12PiecePAData

theorem row_eq (j : Fin 10) :
    (matrixMul XVec AVec) (0 : Fin 10) j =
      matrixOne (Fin 10) (0 : Fin 10) j := by
  fin_cases j
  · exact D12PiecePASplitEntry0_0.entry_eq_matrixOne
  · exact D12PiecePASplitEntry0_1.entry_eq_matrixOne
  · exact D12PiecePASplitEntry0_2.entry_eq_matrixOne
  · exact D12PiecePASplitEntry0_3.entry_eq_matrixOne
  · exact D12PiecePASplitEntry0_4.entry_eq_matrixOne
  · exact D12PiecePASplitEntry0_5.entry_eq_matrixOne
  · exact D12PiecePASplitEntry0_6.entry_eq_matrixOne
  · exact D12PiecePASplitEntry0_7.entry_eq_matrixOne
  · exact D12PiecePASplitEntry0_8.entry_eq_matrixOne
  · exact D12PiecePASplitEntry0_9.entry_eq_matrixOne

end V14Formalization.D12PiecePASplitRow0
