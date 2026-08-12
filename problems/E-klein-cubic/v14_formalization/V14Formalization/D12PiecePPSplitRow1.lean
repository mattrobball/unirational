/- PP split identity row 1. Auto-generated. -/
import V14Formalization.D12PiecePPSplitEntry1_0
import V14Formalization.D12PiecePPSplitEntry1_1
import V14Formalization.D12PiecePPSplitEntry1_2
import V14Formalization.D12PiecePPSplitEntry1_3
import V14Formalization.D12PiecePPSplitEntry1_4
import V14Formalization.D12PiecePPSplitEntry1_5
import V14Formalization.D12PiecePPSplitEntry1_6
import V14Formalization.D12PiecePPSplitEntry1_7
import V14Formalization.D12PiecePPSplitEntry1_8
import V14Formalization.D12PiecePPSplitEntry1_9

noncomputable section
namespace V14Formalization.D12PiecePPSplitRow1
open D12CyclotomicVec D12PiecePPData

theorem row_eq (j : Fin 10) :
    (matrixMul XVec AVec + matrixMul KVec YVec)
      (1 : Fin 10) j = matrixOne (Fin 10) (1 : Fin 10) j := by
  fin_cases j
  · exact D12PiecePPSplitEntry1_0.entry_eq_matrixOne
  · exact D12PiecePPSplitEntry1_1.entry_eq_matrixOne
  · exact D12PiecePPSplitEntry1_2.entry_eq_matrixOne
  · exact D12PiecePPSplitEntry1_3.entry_eq_matrixOne
  · exact D12PiecePPSplitEntry1_4.entry_eq_matrixOne
  · exact D12PiecePPSplitEntry1_5.entry_eq_matrixOne
  · exact D12PiecePPSplitEntry1_6.entry_eq_matrixOne
  · exact D12PiecePPSplitEntry1_7.entry_eq_matrixOne
  · exact D12PiecePPSplitEntry1_8.entry_eq_matrixOne
  · exact D12PiecePPSplitEntry1_9.entry_eq_matrixOne

end V14Formalization.D12PiecePPSplitRow1
