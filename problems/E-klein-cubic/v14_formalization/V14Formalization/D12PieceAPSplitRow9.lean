/- AP split identity row 9. Auto-generated. -/
import V14Formalization.D12PieceAPSplitEntry9_0
import V14Formalization.D12PieceAPSplitEntry9_1
import V14Formalization.D12PieceAPSplitEntry9_2
import V14Formalization.D12PieceAPSplitEntry9_3
import V14Formalization.D12PieceAPSplitEntry9_4
import V14Formalization.D12PieceAPSplitEntry9_5
import V14Formalization.D12PieceAPSplitEntry9_6
import V14Formalization.D12PieceAPSplitEntry9_7
import V14Formalization.D12PieceAPSplitEntry9_8
import V14Formalization.D12PieceAPSplitEntry9_9

noncomputable section
namespace V14Formalization.D12PieceAPSplitRow9
open D12CyclotomicVec D12PieceAPData

theorem row_eq (j : Fin 10) :
    (matrixMul XVec AVec + matrixMul KVec YVec)
      (9 : Fin 10) j = matrixOne (Fin 10) (9 : Fin 10) j := by
  fin_cases j
  · exact D12PieceAPSplitEntry9_0.entry_eq_matrixOne
  · exact D12PieceAPSplitEntry9_1.entry_eq_matrixOne
  · exact D12PieceAPSplitEntry9_2.entry_eq_matrixOne
  · exact D12PieceAPSplitEntry9_3.entry_eq_matrixOne
  · exact D12PieceAPSplitEntry9_4.entry_eq_matrixOne
  · exact D12PieceAPSplitEntry9_5.entry_eq_matrixOne
  · exact D12PieceAPSplitEntry9_6.entry_eq_matrixOne
  · exact D12PieceAPSplitEntry9_7.entry_eq_matrixOne
  · exact D12PieceAPSplitEntry9_8.entry_eq_matrixOne
  · exact D12PieceAPSplitEntry9_9.entry_eq_matrixOne

end V14Formalization.D12PieceAPSplitRow9
