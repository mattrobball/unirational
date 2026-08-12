/- AP split identity row 3. Auto-generated. -/
import V14Formalization.D12PieceAPSplitEntry3_0
import V14Formalization.D12PieceAPSplitEntry3_1
import V14Formalization.D12PieceAPSplitEntry3_2
import V14Formalization.D12PieceAPSplitEntry3_3
import V14Formalization.D12PieceAPSplitEntry3_4
import V14Formalization.D12PieceAPSplitEntry3_5
import V14Formalization.D12PieceAPSplitEntry3_6
import V14Formalization.D12PieceAPSplitEntry3_7
import V14Formalization.D12PieceAPSplitEntry3_8
import V14Formalization.D12PieceAPSplitEntry3_9

noncomputable section
namespace V14Formalization.D12PieceAPSplitRow3
open D12CyclotomicVec D12PieceAPData

theorem row_eq (j : Fin 10) :
    (matrixMul XVec AVec + matrixMul KVec YVec)
      (3 : Fin 10) j = matrixOne (Fin 10) (3 : Fin 10) j := by
  fin_cases j
  · exact D12PieceAPSplitEntry3_0.entry_eq_matrixOne
  · exact D12PieceAPSplitEntry3_1.entry_eq_matrixOne
  · exact D12PieceAPSplitEntry3_2.entry_eq_matrixOne
  · exact D12PieceAPSplitEntry3_3.entry_eq_matrixOne
  · exact D12PieceAPSplitEntry3_4.entry_eq_matrixOne
  · exact D12PieceAPSplitEntry3_5.entry_eq_matrixOne
  · exact D12PieceAPSplitEntry3_6.entry_eq_matrixOne
  · exact D12PieceAPSplitEntry3_7.entry_eq_matrixOne
  · exact D12PieceAPSplitEntry3_8.entry_eq_matrixOne
  · exact D12PieceAPSplitEntry3_9.entry_eq_matrixOne

end V14Formalization.D12PieceAPSplitRow3
