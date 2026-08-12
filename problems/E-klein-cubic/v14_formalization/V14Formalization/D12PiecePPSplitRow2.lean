/- PP split identity row 2. Auto-generated. -/
import V14Formalization.D12PiecePPSplitEntry2_0
import V14Formalization.D12PiecePPSplitEntry2_1
import V14Formalization.D12PiecePPSplitEntry2_2
import V14Formalization.D12PiecePPSplitEntry2_3
import V14Formalization.D12PiecePPSplitEntry2_4
import V14Formalization.D12PiecePPSplitEntry2_5
import V14Formalization.D12PiecePPSplitEntry2_6
import V14Formalization.D12PiecePPSplitEntry2_7
import V14Formalization.D12PiecePPSplitEntry2_8
import V14Formalization.D12PiecePPSplitEntry2_9

noncomputable section
namespace V14Formalization.D12PiecePPSplitRow2
open D12CyclotomicVec D12PiecePPData

theorem row_eq (j : Fin 10) :
    (matrixMul XVec AVec + matrixMul KVec YVec)
      (2 : Fin 10) j = matrixOne (Fin 10) (2 : Fin 10) j := by
  fin_cases j
  · exact D12PiecePPSplitEntry2_0.entry_eq_matrixOne
  · exact D12PiecePPSplitEntry2_1.entry_eq_matrixOne
  · exact D12PiecePPSplitEntry2_2.entry_eq_matrixOne
  · exact D12PiecePPSplitEntry2_3.entry_eq_matrixOne
  · exact D12PiecePPSplitEntry2_4.entry_eq_matrixOne
  · exact D12PiecePPSplitEntry2_5.entry_eq_matrixOne
  · exact D12PiecePPSplitEntry2_6.entry_eq_matrixOne
  · exact D12PiecePPSplitEntry2_7.entry_eq_matrixOne
  · exact D12PiecePPSplitEntry2_8.entry_eq_matrixOne
  · exact D12PiecePPSplitEntry2_9.entry_eq_matrixOne

end V14Formalization.D12PiecePPSplitRow2
