/- PP split identity row 6. Auto-generated. -/
import V14Formalization.D12PiecePPSplitEntry6_0
import V14Formalization.D12PiecePPSplitEntry6_1
import V14Formalization.D12PiecePPSplitEntry6_2
import V14Formalization.D12PiecePPSplitEntry6_3
import V14Formalization.D12PiecePPSplitEntry6_4
import V14Formalization.D12PiecePPSplitEntry6_5
import V14Formalization.D12PiecePPSplitEntry6_6
import V14Formalization.D12PiecePPSplitEntry6_7
import V14Formalization.D12PiecePPSplitEntry6_8
import V14Formalization.D12PiecePPSplitEntry6_9

noncomputable section
namespace V14Formalization.D12PiecePPSplitRow6
open D12CyclotomicVec D12PiecePPData

theorem row_eq (j : Fin 10) :
    (matrixMul XVec AVec + matrixMul KVec YVec)
      (6 : Fin 10) j = matrixOne (Fin 10) (6 : Fin 10) j := by
  fin_cases j
  · exact D12PiecePPSplitEntry6_0.entry_eq_matrixOne
  · exact D12PiecePPSplitEntry6_1.entry_eq_matrixOne
  · exact D12PiecePPSplitEntry6_2.entry_eq_matrixOne
  · exact D12PiecePPSplitEntry6_3.entry_eq_matrixOne
  · exact D12PiecePPSplitEntry6_4.entry_eq_matrixOne
  · exact D12PiecePPSplitEntry6_5.entry_eq_matrixOne
  · exact D12PiecePPSplitEntry6_6.entry_eq_matrixOne
  · exact D12PiecePPSplitEntry6_7.entry_eq_matrixOne
  · exact D12PiecePPSplitEntry6_8.entry_eq_matrixOne
  · exact D12PiecePPSplitEntry6_9.entry_eq_matrixOne

end V14Formalization.D12PiecePPSplitRow6
