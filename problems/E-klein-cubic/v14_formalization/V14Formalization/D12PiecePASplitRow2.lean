/- PA split identity, row 2. Auto-generated. -/
import V14Formalization.D12PiecePASplitEntry2_0
import V14Formalization.D12PiecePASplitEntry2_1
import V14Formalization.D12PiecePASplitEntry2_2
import V14Formalization.D12PiecePASplitEntry2_3
import V14Formalization.D12PiecePASplitEntry2_4
import V14Formalization.D12PiecePASplitEntry2_5
import V14Formalization.D12PiecePASplitEntry2_6
import V14Formalization.D12PiecePASplitEntry2_7
import V14Formalization.D12PiecePASplitEntry2_8
import V14Formalization.D12PiecePASplitEntry2_9

noncomputable section
namespace V14Formalization.D12PiecePASplitRow2
open D12CyclotomicVec D12PiecePAData

theorem row_eq (j : Fin 10) :
    (matrixMul XVec AVec) (2 : Fin 10) j =
      matrixOne (Fin 10) (2 : Fin 10) j := by
  fin_cases j
  · exact D12PiecePASplitEntry2_0.entry_eq_matrixOne
  · exact D12PiecePASplitEntry2_1.entry_eq_matrixOne
  · exact D12PiecePASplitEntry2_2.entry_eq_matrixOne
  · exact D12PiecePASplitEntry2_3.entry_eq_matrixOne
  · exact D12PiecePASplitEntry2_4.entry_eq_matrixOne
  · exact D12PiecePASplitEntry2_5.entry_eq_matrixOne
  · exact D12PiecePASplitEntry2_6.entry_eq_matrixOne
  · exact D12PiecePASplitEntry2_7.entry_eq_matrixOne
  · exact D12PiecePASplitEntry2_8.entry_eq_matrixOne
  · exact D12PiecePASplitEntry2_9.entry_eq_matrixOne

end V14Formalization.D12PiecePASplitRow2
