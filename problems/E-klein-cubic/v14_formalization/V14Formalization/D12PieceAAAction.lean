/- AA literal action matrix equals its character stack. -/
module

public import V14Formalization.D12PieceAAActionRow0
public import V14Formalization.D12PieceAAActionRow1
public import V14Formalization.D12PieceAAActionRow2
public import V14Formalization.D12PieceAAActionRow3
public import V14Formalization.D12PieceAAActionRow4
public import V14Formalization.D12PieceAAActionRow5
public import V14Formalization.D12PieceAAActionRow6
public import V14Formalization.D12PieceAAActionRow7
public import V14Formalization.D12PieceAAActionRow8
public import V14Formalization.D12PieceAAActionRow9
public import V14Formalization.D12PieceAAActionRow10
public import V14Formalization.D12PieceAAActionRow11
public import V14Formalization.D12PieceAAActionRow12
public import V14Formalization.D12PieceAAActionRow13
public import V14Formalization.D12PieceAAActionRow14
public import V14Formalization.D12PieceAAActionRow15
public import V14Formalization.D12PieceAAActionRow16
public import V14Formalization.D12PieceAAActionRow17
public import V14Formalization.D12PieceAAActionRow18
public import V14Formalization.D12PieceAAActionRow19

noncomputable section
namespace V14Formalization.D12PieceAAAction
open D12PieceVecBase D12PieceAAData

public theorem action_matrix :
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
