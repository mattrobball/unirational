/- PA split identity, row 4. Auto-generated. -/
import V14Formalization.D12PiecePASplitEntry4_0
import V14Formalization.D12PiecePASplitEntry4_1
import V14Formalization.D12PiecePASplitEntry4_2
import V14Formalization.D12PiecePASplitEntry4_3
import V14Formalization.D12PiecePASplitEntry4_4
import V14Formalization.D12PiecePASplitEntry4_5
import V14Formalization.D12PiecePASplitEntry4_6
import V14Formalization.D12PiecePASplitEntry4_7
import V14Formalization.D12PiecePASplitEntry4_8
import V14Formalization.D12PiecePASplitEntry4_9

noncomputable section
namespace V14Formalization.D12PiecePASplitRow4
open D12CyclotomicVec D12PiecePAData

theorem row_eq (j : Fin 10) :
    (matrixMul XVec AVec) (4 : Fin 10) j =
      matrixOne (Fin 10) (4 : Fin 10) j := by
  fin_cases j
  · exact D12PiecePASplitEntry4_0.entry_eq_matrixOne
  · exact D12PiecePASplitEntry4_1.entry_eq_matrixOne
  · exact D12PiecePASplitEntry4_2.entry_eq_matrixOne
  · exact D12PiecePASplitEntry4_3.entry_eq_matrixOne
  · exact D12PiecePASplitEntry4_4.entry_eq_matrixOne
  · exact D12PiecePASplitEntry4_5.entry_eq_matrixOne
  · exact D12PiecePASplitEntry4_6.entry_eq_matrixOne
  · exact D12PiecePASplitEntry4_7.entry_eq_matrixOne
  · exact D12PiecePASplitEntry4_8.entry_eq_matrixOne
  · exact D12PiecePASplitEntry4_9.entry_eq_matrixOne

end V14Formalization.D12PiecePASplitRow4
