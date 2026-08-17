/- PP literal action matrix equals its character stack. -/
module

public import V14Formalization.D12PiecePPActionRow0
public import V14Formalization.D12PiecePPActionRow1
public import V14Formalization.D12PiecePPActionRow2
public import V14Formalization.D12PiecePPActionRow3
public import V14Formalization.D12PiecePPActionRow4
public import V14Formalization.D12PiecePPActionRow5
public import V14Formalization.D12PiecePPActionRow6
public import V14Formalization.D12PiecePPActionRow7
public import V14Formalization.D12PiecePPActionRow8
public import V14Formalization.D12PiecePPActionRow9
public import V14Formalization.D12PiecePPActionRow10
public import V14Formalization.D12PiecePPActionRow11
public import V14Formalization.D12PiecePPActionRow12
public import V14Formalization.D12PiecePPActionRow13
public import V14Formalization.D12PiecePPActionRow14
public import V14Formalization.D12PiecePPActionRow15
public import V14Formalization.D12PiecePPActionRow16
public import V14Formalization.D12PiecePPActionRow17
public import V14Formalization.D12PiecePPActionRow18
public import V14Formalization.D12PiecePPActionRow19

noncomputable section
namespace V14Formalization.D12PiecePPAction
open D12PieceVecBase D12PiecePPData

public theorem action_matrix :
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
