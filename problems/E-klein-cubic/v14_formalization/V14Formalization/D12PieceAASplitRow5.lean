/- AA split identity row 5. Auto-generated. -/
import V14Formalization.D12PieceAASplitEntry5_0
import V14Formalization.D12PieceAASplitEntry5_1
import V14Formalization.D12PieceAASplitEntry5_2
import V14Formalization.D12PieceAASplitEntry5_3
import V14Formalization.D12PieceAASplitEntry5_4
import V14Formalization.D12PieceAASplitEntry5_5
import V14Formalization.D12PieceAASplitEntry5_6
import V14Formalization.D12PieceAASplitEntry5_7
import V14Formalization.D12PieceAASplitEntry5_8
import V14Formalization.D12PieceAASplitEntry5_9

noncomputable section
namespace V14Formalization.D12PieceAASplitRow5
open D12CyclotomicVec D12PieceAAData

theorem row_eq (j : Fin 10) :
    (matrixMul XVec AVec + matrixMul KVec YVec)
      (5 : Fin 10) j = matrixOne (Fin 10) (5 : Fin 10) j := by
  fin_cases j
  · exact D12PieceAASplitEntry5_0.entry_eq_matrixOne
  · exact D12PieceAASplitEntry5_1.entry_eq_matrixOne
  · exact D12PieceAASplitEntry5_2.entry_eq_matrixOne
  · exact D12PieceAASplitEntry5_3.entry_eq_matrixOne
  · exact D12PieceAASplitEntry5_4.entry_eq_matrixOne
  · exact D12PieceAASplitEntry5_5.entry_eq_matrixOne
  · exact D12PieceAASplitEntry5_6.entry_eq_matrixOne
  · exact D12PieceAASplitEntry5_7.entry_eq_matrixOne
  · exact D12PieceAASplitEntry5_8.entry_eq_matrixOne
  · exact D12PieceAASplitEntry5_9.entry_eq_matrixOne

end V14Formalization.D12PieceAASplitRow5
