/- PP split identity row 3. Auto-generated. -/
import V14Formalization.D12PiecePPSplitEntry3_0
import V14Formalization.D12PiecePPSplitEntry3_1
import V14Formalization.D12PiecePPSplitEntry3_2
import V14Formalization.D12PiecePPSplitEntry3_3
import V14Formalization.D12PiecePPSplitEntry3_4
import V14Formalization.D12PiecePPSplitEntry3_5
import V14Formalization.D12PiecePPSplitEntry3_6
import V14Formalization.D12PiecePPSplitEntry3_7
import V14Formalization.D12PiecePPSplitEntry3_8
import V14Formalization.D12PiecePPSplitEntry3_9

noncomputable section
namespace V14Formalization.D12PiecePPSplitRow3
open D12CyclotomicVec D12PiecePPData

theorem row_eq (j : Fin 10) :
    (matrixMul XVec AVec + matrixMul KVec YVec)
      (3 : Fin 10) j = matrixOne (Fin 10) (3 : Fin 10) j := by
  fin_cases j
  · exact D12PiecePPSplitEntry3_0.entry_eq_matrixOne
  · exact D12PiecePPSplitEntry3_1.entry_eq_matrixOne
  · exact D12PiecePPSplitEntry3_2.entry_eq_matrixOne
  · exact D12PiecePPSplitEntry3_3.entry_eq_matrixOne
  · exact D12PiecePPSplitEntry3_4.entry_eq_matrixOne
  · exact D12PiecePPSplitEntry3_5.entry_eq_matrixOne
  · exact D12PiecePPSplitEntry3_6.entry_eq_matrixOne
  · exact D12PiecePPSplitEntry3_7.entry_eq_matrixOne
  · exact D12PiecePPSplitEntry3_8.entry_eq_matrixOne
  · exact D12PiecePPSplitEntry3_9.entry_eq_matrixOne

end V14Formalization.D12PiecePPSplitRow3
