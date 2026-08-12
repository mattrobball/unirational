/- AP split identity row 8. Auto-generated. -/
import V14Formalization.D12PieceAPSplitEntry8_0
import V14Formalization.D12PieceAPSplitEntry8_1
import V14Formalization.D12PieceAPSplitEntry8_2
import V14Formalization.D12PieceAPSplitEntry8_3
import V14Formalization.D12PieceAPSplitEntry8_4
import V14Formalization.D12PieceAPSplitEntry8_5
import V14Formalization.D12PieceAPSplitEntry8_6
import V14Formalization.D12PieceAPSplitEntry8_7
import V14Formalization.D12PieceAPSplitEntry8_8
import V14Formalization.D12PieceAPSplitEntry8_9

noncomputable section
namespace V14Formalization.D12PieceAPSplitRow8
open D12CyclotomicVec D12PieceAPData

theorem row_eq (j : Fin 10) :
    (matrixMul XVec AVec + matrixMul KVec YVec)
      (8 : Fin 10) j = matrixOne (Fin 10) (8 : Fin 10) j := by
  fin_cases j
  · exact D12PieceAPSplitEntry8_0.entry_eq_matrixOne
  · exact D12PieceAPSplitEntry8_1.entry_eq_matrixOne
  · exact D12PieceAPSplitEntry8_2.entry_eq_matrixOne
  · exact D12PieceAPSplitEntry8_3.entry_eq_matrixOne
  · exact D12PieceAPSplitEntry8_4.entry_eq_matrixOne
  · exact D12PieceAPSplitEntry8_5.entry_eq_matrixOne
  · exact D12PieceAPSplitEntry8_6.entry_eq_matrixOne
  · exact D12PieceAPSplitEntry8_7.entry_eq_matrixOne
  · exact D12PieceAPSplitEntry8_8.entry_eq_matrixOne
  · exact D12PieceAPSplitEntry8_9.entry_eq_matrixOne

end V14Formalization.D12PieceAPSplitRow8
