/- PA split identity, row 8. Auto-generated. -/
import V14Formalization.D12PiecePASplitEntry8_0
import V14Formalization.D12PiecePASplitEntry8_1
import V14Formalization.D12PiecePASplitEntry8_2
import V14Formalization.D12PiecePASplitEntry8_3
import V14Formalization.D12PiecePASplitEntry8_4
import V14Formalization.D12PiecePASplitEntry8_5
import V14Formalization.D12PiecePASplitEntry8_6
import V14Formalization.D12PiecePASplitEntry8_7
import V14Formalization.D12PiecePASplitEntry8_8
import V14Formalization.D12PiecePASplitEntry8_9

noncomputable section
namespace V14Formalization.D12PiecePASplitRow8
open D12CyclotomicVec D12PiecePAData

theorem row_eq (j : Fin 10) :
    (matrixMul XVec AVec) (8 : Fin 10) j =
      matrixOne (Fin 10) (8 : Fin 10) j := by
  fin_cases j
  · exact D12PiecePASplitEntry8_0.entry_eq_matrixOne
  · exact D12PiecePASplitEntry8_1.entry_eq_matrixOne
  · exact D12PiecePASplitEntry8_2.entry_eq_matrixOne
  · exact D12PiecePASplitEntry8_3.entry_eq_matrixOne
  · exact D12PiecePASplitEntry8_4.entry_eq_matrixOne
  · exact D12PiecePASplitEntry8_5.entry_eq_matrixOne
  · exact D12PiecePASplitEntry8_6.entry_eq_matrixOne
  · exact D12PiecePASplitEntry8_7.entry_eq_matrixOne
  · exact D12PiecePASplitEntry8_8.entry_eq_matrixOne
  · exact D12PiecePASplitEntry8_9.entry_eq_matrixOne

end V14Formalization.D12PiecePASplitRow8
