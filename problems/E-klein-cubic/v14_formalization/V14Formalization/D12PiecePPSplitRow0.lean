/- PP split identity row 0. Auto-generated. -/
import V14Formalization.D12PiecePPSplitEntry0_0
import V14Formalization.D12PiecePPSplitEntry0_1
import V14Formalization.D12PiecePPSplitEntry0_2
import V14Formalization.D12PiecePPSplitEntry0_3
import V14Formalization.D12PiecePPSplitEntry0_4
import V14Formalization.D12PiecePPSplitEntry0_5
import V14Formalization.D12PiecePPSplitEntry0_6
import V14Formalization.D12PiecePPSplitEntry0_7
import V14Formalization.D12PiecePPSplitEntry0_8
import V14Formalization.D12PiecePPSplitEntry0_9

noncomputable section
namespace V14Formalization.D12PiecePPSplitRow0
open D12CyclotomicVec D12PiecePPData

theorem row_eq (j : Fin 10) :
    (matrixMul XVec AVec + matrixMul KVec YVec)
      (0 : Fin 10) j = matrixOne (Fin 10) (0 : Fin 10) j := by
  fin_cases j
  · exact D12PiecePPSplitEntry0_0.entry_eq_matrixOne
  · exact D12PiecePPSplitEntry0_1.entry_eq_matrixOne
  · exact D12PiecePPSplitEntry0_2.entry_eq_matrixOne
  · exact D12PiecePPSplitEntry0_3.entry_eq_matrixOne
  · exact D12PiecePPSplitEntry0_4.entry_eq_matrixOne
  · exact D12PiecePPSplitEntry0_5.entry_eq_matrixOne
  · exact D12PiecePPSplitEntry0_6.entry_eq_matrixOne
  · exact D12PiecePPSplitEntry0_7.entry_eq_matrixOne
  · exact D12PiecePPSplitEntry0_8.entry_eq_matrixOne
  · exact D12PiecePPSplitEntry0_9.entry_eq_matrixOne

end V14Formalization.D12PiecePPSplitRow0
