/- PA split identity, row 9. Auto-generated. -/
import V14Formalization.D12PiecePASplitEntry9_0
import V14Formalization.D12PiecePASplitEntry9_1
import V14Formalization.D12PiecePASplitEntry9_2
import V14Formalization.D12PiecePASplitEntry9_3
import V14Formalization.D12PiecePASplitEntry9_4
import V14Formalization.D12PiecePASplitEntry9_5
import V14Formalization.D12PiecePASplitEntry9_6
import V14Formalization.D12PiecePASplitEntry9_7
import V14Formalization.D12PiecePASplitEntry9_8
import V14Formalization.D12PiecePASplitEntry9_9

noncomputable section
namespace V14Formalization.D12PiecePASplitRow9
open D12CyclotomicVec D12PiecePAData

theorem row_eq (j : Fin 10) :
    (matrixMul XVec AVec) (9 : Fin 10) j =
      matrixOne (Fin 10) (9 : Fin 10) j := by
  fin_cases j
  · exact D12PiecePASplitEntry9_0.entry_eq_matrixOne
  · exact D12PiecePASplitEntry9_1.entry_eq_matrixOne
  · exact D12PiecePASplitEntry9_2.entry_eq_matrixOne
  · exact D12PiecePASplitEntry9_3.entry_eq_matrixOne
  · exact D12PiecePASplitEntry9_4.entry_eq_matrixOne
  · exact D12PiecePASplitEntry9_5.entry_eq_matrixOne
  · exact D12PiecePASplitEntry9_6.entry_eq_matrixOne
  · exact D12PiecePASplitEntry9_7.entry_eq_matrixOne
  · exact D12PiecePASplitEntry9_8.entry_eq_matrixOne
  · exact D12PiecePASplitEntry9_9.entry_eq_matrixOne

end V14Formalization.D12PiecePASplitRow9
