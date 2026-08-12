/- AP literal action matrix equals its character stack. -/
import V14Formalization.D12PieceAPActionRow0
import V14Formalization.D12PieceAPActionRow1
import V14Formalization.D12PieceAPActionRow2
import V14Formalization.D12PieceAPActionRow3
import V14Formalization.D12PieceAPActionRow4
import V14Formalization.D12PieceAPActionRow5
import V14Formalization.D12PieceAPActionRow6
import V14Formalization.D12PieceAPActionRow7
import V14Formalization.D12PieceAPActionRow8
import V14Formalization.D12PieceAPActionRow9
import V14Formalization.D12PieceAPActionRow10
import V14Formalization.D12PieceAPActionRow11
import V14Formalization.D12PieceAPActionRow12
import V14Formalization.D12PieceAPActionRow13
import V14Formalization.D12PieceAPActionRow14
import V14Formalization.D12PieceAPActionRow15
import V14Formalization.D12PieceAPActionRow16
import V14Formalization.D12PieceAPActionRow17
import V14Formalization.D12PieceAPActionRow18
import V14Formalization.D12PieceAPActionRow19

noncomputable section
namespace V14Formalization.D12PieceAPAction
open D12PieceVecBase D12PieceAPData

theorem action_matrix :
    AVec = characterStackVec RMVec SMVec (-1)
      (1) := by
  apply Matrix.ext
  intro i j
  fin_cases i
  · exact D12PieceAPActionRow0.row_eq j
  · exact D12PieceAPActionRow1.row_eq j
  · exact D12PieceAPActionRow2.row_eq j
  · exact D12PieceAPActionRow3.row_eq j
  · exact D12PieceAPActionRow4.row_eq j
  · exact D12PieceAPActionRow5.row_eq j
  · exact D12PieceAPActionRow6.row_eq j
  · exact D12PieceAPActionRow7.row_eq j
  · exact D12PieceAPActionRow8.row_eq j
  · exact D12PieceAPActionRow9.row_eq j
  · exact D12PieceAPActionRow10.row_eq j
  · exact D12PieceAPActionRow11.row_eq j
  · exact D12PieceAPActionRow12.row_eq j
  · exact D12PieceAPActionRow13.row_eq j
  · exact D12PieceAPActionRow14.row_eq j
  · exact D12PieceAPActionRow15.row_eq j
  · exact D12PieceAPActionRow16.row_eq j
  · exact D12PieceAPActionRow17.row_eq j
  · exact D12PieceAPActionRow18.row_eq j
  · exact D12PieceAPActionRow19.row_eq j

end V14Formalization.D12PieceAPAction
