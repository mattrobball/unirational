/- AP split identity row 7. Auto-generated. -/
import V14Formalization.D12PieceAPSplitEntry7_0
import V14Formalization.D12PieceAPSplitEntry7_1
import V14Formalization.D12PieceAPSplitEntry7_2
import V14Formalization.D12PieceAPSplitEntry7_3
import V14Formalization.D12PieceAPSplitEntry7_4
import V14Formalization.D12PieceAPSplitEntry7_5
import V14Formalization.D12PieceAPSplitEntry7_6
import V14Formalization.D12PieceAPSplitEntry7_7
import V14Formalization.D12PieceAPSplitEntry7_8
import V14Formalization.D12PieceAPSplitEntry7_9

noncomputable section
namespace V14Formalization.D12PieceAPSplitRow7
open D12CyclotomicVec D12PieceAPData

theorem row_eq (j : Fin 10) :
    (matrixMul XVec AVec + matrixMul KVec YVec)
      (7 : Fin 10) j = matrixOne (Fin 10) (7 : Fin 10) j := by
  fin_cases j
  · exact D12PieceAPSplitEntry7_0.entry_eq_matrixOne
  · exact D12PieceAPSplitEntry7_1.entry_eq_matrixOne
  · exact D12PieceAPSplitEntry7_2.entry_eq_matrixOne
  · exact D12PieceAPSplitEntry7_3.entry_eq_matrixOne
  · exact D12PieceAPSplitEntry7_4.entry_eq_matrixOne
  · exact D12PieceAPSplitEntry7_5.entry_eq_matrixOne
  · exact D12PieceAPSplitEntry7_6.entry_eq_matrixOne
  · exact D12PieceAPSplitEntry7_7.entry_eq_matrixOne
  · exact D12PieceAPSplitEntry7_8.entry_eq_matrixOne
  · exact D12PieceAPSplitEntry7_9.entry_eq_matrixOne

end V14Formalization.D12PieceAPSplitRow7
