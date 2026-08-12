/- PA split identity, row 6. Auto-generated. -/
import V14Formalization.D12PiecePASplitEntry6_0
import V14Formalization.D12PiecePASplitEntry6_1
import V14Formalization.D12PiecePASplitEntry6_2
import V14Formalization.D12PiecePASplitEntry6_3
import V14Formalization.D12PiecePASplitEntry6_4
import V14Formalization.D12PiecePASplitEntry6_5
import V14Formalization.D12PiecePASplitEntry6_6
import V14Formalization.D12PiecePASplitEntry6_7
import V14Formalization.D12PiecePASplitEntry6_8
import V14Formalization.D12PiecePASplitEntry6_9

noncomputable section
namespace V14Formalization.D12PiecePASplitRow6
open D12CyclotomicVec D12PiecePAData

theorem row_eq (j : Fin 10) :
    (matrixMul XVec AVec) (6 : Fin 10) j =
      matrixOne (Fin 10) (6 : Fin 10) j := by
  fin_cases j
  · exact D12PiecePASplitEntry6_0.entry_eq_matrixOne
  · exact D12PiecePASplitEntry6_1.entry_eq_matrixOne
  · exact D12PiecePASplitEntry6_2.entry_eq_matrixOne
  · exact D12PiecePASplitEntry6_3.entry_eq_matrixOne
  · exact D12PiecePASplitEntry6_4.entry_eq_matrixOne
  · exact D12PiecePASplitEntry6_5.entry_eq_matrixOne
  · exact D12PiecePASplitEntry6_6.entry_eq_matrixOne
  · exact D12PiecePASplitEntry6_7.entry_eq_matrixOne
  · exact D12PiecePASplitEntry6_8.entry_eq_matrixOne
  · exact D12PiecePASplitEntry6_9.entry_eq_matrixOne

end V14Formalization.D12PiecePASplitRow6
