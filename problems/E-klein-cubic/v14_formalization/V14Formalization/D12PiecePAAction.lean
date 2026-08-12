/- PA literal action matrix equals the generic character stack. -/
import V14Formalization.D12PiecePAActionRow0
import V14Formalization.D12PiecePAActionRow1
import V14Formalization.D12PiecePAActionRow2
import V14Formalization.D12PiecePAActionRow3
import V14Formalization.D12PiecePAActionRow4
import V14Formalization.D12PiecePAActionRow5
import V14Formalization.D12PiecePAActionRow6
import V14Formalization.D12PiecePAActionRow7
import V14Formalization.D12PiecePAActionRow8
import V14Formalization.D12PiecePAActionRow9
import V14Formalization.D12PiecePAActionRow10
import V14Formalization.D12PiecePAActionRow11
import V14Formalization.D12PiecePAActionRow12
import V14Formalization.D12PiecePAActionRow13
import V14Formalization.D12PiecePAActionRow14
import V14Formalization.D12PiecePAActionRow15
import V14Formalization.D12PiecePAActionRow16
import V14Formalization.D12PiecePAActionRow17
import V14Formalization.D12PiecePAActionRow18
import V14Formalization.D12PiecePAActionRow19

noncomputable section
namespace V14Formalization.D12PiecePAAction
open D12PieceVecBase D12PiecePAData

theorem action_matrix :
    AVec = characterStackVec RMVec SMVec 1 (-1) := by
  apply Matrix.ext
  intro i j
  fin_cases i
  · exact D12PiecePAActionRow0.row_eq j
  · exact D12PiecePAActionRow1.row_eq j
  · exact D12PiecePAActionRow2.row_eq j
  · exact D12PiecePAActionRow3.row_eq j
  · exact D12PiecePAActionRow4.row_eq j
  · exact D12PiecePAActionRow5.row_eq j
  · exact D12PiecePAActionRow6.row_eq j
  · exact D12PiecePAActionRow7.row_eq j
  · exact D12PiecePAActionRow8.row_eq j
  · exact D12PiecePAActionRow9.row_eq j
  · exact D12PiecePAActionRow10.row_eq j
  · exact D12PiecePAActionRow11.row_eq j
  · exact D12PiecePAActionRow12.row_eq j
  · exact D12PiecePAActionRow13.row_eq j
  · exact D12PiecePAActionRow14.row_eq j
  · exact D12PiecePAActionRow15.row_eq j
  · exact D12PiecePAActionRow16.row_eq j
  · exact D12PiecePAActionRow17.row_eq j
  · exact D12PiecePAActionRow18.row_eq j
  · exact D12PiecePAActionRow19.row_eq j

end V14Formalization.D12PiecePAAction
