/- AA literal action matrix equals its character stack. -/
import V14Formalization.D12PieceAAActionRow0
import V14Formalization.D12PieceAAActionRow1
import V14Formalization.D12PieceAAActionRow2
import V14Formalization.D12PieceAAActionRow3
import V14Formalization.D12PieceAAActionRow4
import V14Formalization.D12PieceAAActionRow5
import V14Formalization.D12PieceAAActionRow6
import V14Formalization.D12PieceAAActionRow7
import V14Formalization.D12PieceAAActionRow8
import V14Formalization.D12PieceAAActionRow9
import V14Formalization.D12PieceAAActionRow10
import V14Formalization.D12PieceAAActionRow11
import V14Formalization.D12PieceAAActionRow12
import V14Formalization.D12PieceAAActionRow13
import V14Formalization.D12PieceAAActionRow14
import V14Formalization.D12PieceAAActionRow15
import V14Formalization.D12PieceAAActionRow16
import V14Formalization.D12PieceAAActionRow17
import V14Formalization.D12PieceAAActionRow18
import V14Formalization.D12PieceAAActionRow19

noncomputable section
namespace V14Formalization.D12PieceAAAction
open D12PieceVecBase D12PieceAAData

theorem action_matrix :
    AVec = characterStackVec RMVec SMVec (-1)
      (-1) := by
  apply Matrix.ext
  intro i j
  fin_cases i
  · exact D12PieceAAActionRow0.row_eq j
  · exact D12PieceAAActionRow1.row_eq j
  · exact D12PieceAAActionRow2.row_eq j
  · exact D12PieceAAActionRow3.row_eq j
  · exact D12PieceAAActionRow4.row_eq j
  · exact D12PieceAAActionRow5.row_eq j
  · exact D12PieceAAActionRow6.row_eq j
  · exact D12PieceAAActionRow7.row_eq j
  · exact D12PieceAAActionRow8.row_eq j
  · exact D12PieceAAActionRow9.row_eq j
  · exact D12PieceAAActionRow10.row_eq j
  · exact D12PieceAAActionRow11.row_eq j
  · exact D12PieceAAActionRow12.row_eq j
  · exact D12PieceAAActionRow13.row_eq j
  · exact D12PieceAAActionRow14.row_eq j
  · exact D12PieceAAActionRow15.row_eq j
  · exact D12PieceAAActionRow16.row_eq j
  · exact D12PieceAAActionRow17.row_eq j
  · exact D12PieceAAActionRow18.row_eq j
  · exact D12PieceAAActionRow19.row_eq j

end V14Formalization.D12PieceAAAction
