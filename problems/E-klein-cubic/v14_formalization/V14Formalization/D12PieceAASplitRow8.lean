/- AA split identity row 8. Auto-generated. -/
import V14Formalization.D12PieceAASplitEntry8_0
import V14Formalization.D12PieceAASplitEntry8_1
import V14Formalization.D12PieceAASplitEntry8_2
import V14Formalization.D12PieceAASplitEntry8_3
import V14Formalization.D12PieceAASplitEntry8_4
import V14Formalization.D12PieceAASplitEntry8_5
import V14Formalization.D12PieceAASplitEntry8_6
import V14Formalization.D12PieceAASplitEntry8_7
import V14Formalization.D12PieceAASplitEntry8_8
import V14Formalization.D12PieceAASplitEntry8_9

noncomputable section
namespace V14Formalization.D12PieceAASplitRow8
open D12CyclotomicVec D12PieceAAData

theorem row_eq (j : Fin 10) :
    (matrixMul XVec AVec + matrixMul KVec YVec)
      (8 : Fin 10) j = matrixOne (Fin 10) (8 : Fin 10) j := by
  fin_cases j
  · exact D12PieceAASplitEntry8_0.entry_eq_matrixOne
  · exact D12PieceAASplitEntry8_1.entry_eq_matrixOne
  · exact D12PieceAASplitEntry8_2.entry_eq_matrixOne
  · exact D12PieceAASplitEntry8_3.entry_eq_matrixOne
  · exact D12PieceAASplitEntry8_4.entry_eq_matrixOne
  · exact D12PieceAASplitEntry8_5.entry_eq_matrixOne
  · exact D12PieceAASplitEntry8_6.entry_eq_matrixOne
  · exact D12PieceAASplitEntry8_7.entry_eq_matrixOne
  · exact D12PieceAASplitEntry8_8.entry_eq_matrixOne
  · exact D12PieceAASplitEntry8_9.entry_eq_matrixOne

end V14Formalization.D12PieceAASplitRow8
