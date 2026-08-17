/- PA literal action matrix equals the generic character stack. -/
module

public import V14Formalization.D12PiecePAActionRow0
public import V14Formalization.D12PiecePAActionRow1
public import V14Formalization.D12PiecePAActionRow2
public import V14Formalization.D12PiecePAActionRow3
public import V14Formalization.D12PiecePAActionRow4
public import V14Formalization.D12PiecePAActionRow5
public import V14Formalization.D12PiecePAActionRow6
public import V14Formalization.D12PiecePAActionRow7
public import V14Formalization.D12PiecePAActionRow8
public import V14Formalization.D12PiecePAActionRow9
public import V14Formalization.D12PiecePAActionRow10
public import V14Formalization.D12PiecePAActionRow11
public import V14Formalization.D12PiecePAActionRow12
public import V14Formalization.D12PiecePAActionRow13
public import V14Formalization.D12PiecePAActionRow14
public import V14Formalization.D12PiecePAActionRow15
public import V14Formalization.D12PiecePAActionRow16
public import V14Formalization.D12PiecePAActionRow17
public import V14Formalization.D12PiecePAActionRow18
public import V14Formalization.D12PiecePAActionRow19

noncomputable section
namespace V14Formalization.D12PiecePAAction
open D12PieceVecBase D12PiecePAData

public theorem action_matrix :
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
