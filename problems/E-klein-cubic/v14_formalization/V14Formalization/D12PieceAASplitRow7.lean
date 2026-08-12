/- AA split identity row 7. Auto-generated. -/
import V14Formalization.D12PieceAASplitEntry7_0
import V14Formalization.D12PieceAASplitEntry7_1
import V14Formalization.D12PieceAASplitEntry7_2
import V14Formalization.D12PieceAASplitEntry7_3
import V14Formalization.D12PieceAASplitEntry7_4
import V14Formalization.D12PieceAASplitEntry7_5
import V14Formalization.D12PieceAASplitEntry7_6
import V14Formalization.D12PieceAASplitEntry7_7
import V14Formalization.D12PieceAASplitEntry7_8
import V14Formalization.D12PieceAASplitEntry7_9

noncomputable section
namespace V14Formalization.D12PieceAASplitRow7
open D12CyclotomicVec D12PieceAAData

theorem row_eq (j : Fin 10) :
    (matrixMul XVec AVec + matrixMul KVec YVec)
      (7 : Fin 10) j = matrixOne (Fin 10) (7 : Fin 10) j := by
  fin_cases j
  · exact D12PieceAASplitEntry7_0.entry_eq_matrixOne
  · exact D12PieceAASplitEntry7_1.entry_eq_matrixOne
  · exact D12PieceAASplitEntry7_2.entry_eq_matrixOne
  · exact D12PieceAASplitEntry7_3.entry_eq_matrixOne
  · exact D12PieceAASplitEntry7_4.entry_eq_matrixOne
  · exact D12PieceAASplitEntry7_5.entry_eq_matrixOne
  · exact D12PieceAASplitEntry7_6.entry_eq_matrixOne
  · exact D12PieceAASplitEntry7_7.entry_eq_matrixOne
  · exact D12PieceAASplitEntry7_8.entry_eq_matrixOne
  · exact D12PieceAASplitEntry7_9.entry_eq_matrixOne

end V14Formalization.D12PieceAASplitRow7
