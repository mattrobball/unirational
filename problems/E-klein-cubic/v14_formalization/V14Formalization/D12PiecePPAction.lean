/- PP literal action matrix equals its character stack. -/
import V14Formalization.D12PiecePPActionRow0
import V14Formalization.D12PiecePPActionRow1
import V14Formalization.D12PiecePPActionRow2
import V14Formalization.D12PiecePPActionRow3
import V14Formalization.D12PiecePPActionRow4
import V14Formalization.D12PiecePPActionRow5
import V14Formalization.D12PiecePPActionRow6
import V14Formalization.D12PiecePPActionRow7
import V14Formalization.D12PiecePPActionRow8
import V14Formalization.D12PiecePPActionRow9
import V14Formalization.D12PiecePPActionRow10
import V14Formalization.D12PiecePPActionRow11
import V14Formalization.D12PiecePPActionRow12
import V14Formalization.D12PiecePPActionRow13
import V14Formalization.D12PiecePPActionRow14
import V14Formalization.D12PiecePPActionRow15
import V14Formalization.D12PiecePPActionRow16
import V14Formalization.D12PiecePPActionRow17
import V14Formalization.D12PiecePPActionRow18
import V14Formalization.D12PiecePPActionRow19

noncomputable section
namespace V14Formalization.D12PiecePPAction
open D12PieceVecBase D12PiecePPData

theorem action_matrix :
    AVec = characterStackVec RMVec SMVec (1)
      (1) := by
  apply Matrix.ext
  intro i j
  fin_cases i
  · exact D12PiecePPActionRow0.row_eq j
  · exact D12PiecePPActionRow1.row_eq j
  · exact D12PiecePPActionRow2.row_eq j
  · exact D12PiecePPActionRow3.row_eq j
  · exact D12PiecePPActionRow4.row_eq j
  · exact D12PiecePPActionRow5.row_eq j
  · exact D12PiecePPActionRow6.row_eq j
  · exact D12PiecePPActionRow7.row_eq j
  · exact D12PiecePPActionRow8.row_eq j
  · exact D12PiecePPActionRow9.row_eq j
  · exact D12PiecePPActionRow10.row_eq j
  · exact D12PiecePPActionRow11.row_eq j
  · exact D12PiecePPActionRow12.row_eq j
  · exact D12PiecePPActionRow13.row_eq j
  · exact D12PiecePPActionRow14.row_eq j
  · exact D12PiecePPActionRow15.row_eq j
  · exact D12PiecePPActionRow16.row_eq j
  · exact D12PiecePPActionRow17.row_eq j
  · exact D12PiecePPActionRow18.row_eq j
  · exact D12PiecePPActionRow19.row_eq j

end V14Formalization.D12PiecePPAction
