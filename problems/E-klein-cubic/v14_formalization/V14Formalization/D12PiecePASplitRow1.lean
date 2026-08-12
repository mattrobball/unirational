/- PA split identity, row 1. Auto-generated. -/
import V14Formalization.D12PiecePASplitEntry1_0
import V14Formalization.D12PiecePASplitEntry1_1
import V14Formalization.D12PiecePASplitEntry1_2
import V14Formalization.D12PiecePASplitEntry1_3
import V14Formalization.D12PiecePASplitEntry1_4
import V14Formalization.D12PiecePASplitEntry1_5
import V14Formalization.D12PiecePASplitEntry1_6
import V14Formalization.D12PiecePASplitEntry1_7
import V14Formalization.D12PiecePASplitEntry1_8
import V14Formalization.D12PiecePASplitEntry1_9

noncomputable section
namespace V14Formalization.D12PiecePASplitRow1
open D12CyclotomicVec D12PiecePAData

theorem row_eq (j : Fin 10) :
    (matrixMul XVec AVec) (1 : Fin 10) j =
      matrixOne (Fin 10) (1 : Fin 10) j := by
  fin_cases j
  · exact D12PiecePASplitEntry1_0.entry_eq_matrixOne
  · exact D12PiecePASplitEntry1_1.entry_eq_matrixOne
  · exact D12PiecePASplitEntry1_2.entry_eq_matrixOne
  · exact D12PiecePASplitEntry1_3.entry_eq_matrixOne
  · exact D12PiecePASplitEntry1_4.entry_eq_matrixOne
  · exact D12PiecePASplitEntry1_5.entry_eq_matrixOne
  · exact D12PiecePASplitEntry1_6.entry_eq_matrixOne
  · exact D12PiecePASplitEntry1_7.entry_eq_matrixOne
  · exact D12PiecePASplitEntry1_8.entry_eq_matrixOne
  · exact D12PiecePASplitEntry1_9.entry_eq_matrixOne

end V14Formalization.D12PiecePASplitRow1
