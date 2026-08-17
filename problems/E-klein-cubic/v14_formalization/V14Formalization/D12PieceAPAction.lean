/- AP literal action matrix equals its character stack. -/
module

public import V14Formalization.D12PieceAPActionRow0
public import V14Formalization.D12PieceAPActionRow1
public import V14Formalization.D12PieceAPActionRow2
public import V14Formalization.D12PieceAPActionRow3
public import V14Formalization.D12PieceAPActionRow4
public import V14Formalization.D12PieceAPActionRow5
public import V14Formalization.D12PieceAPActionRow6
public import V14Formalization.D12PieceAPActionRow7
public import V14Formalization.D12PieceAPActionRow8
public import V14Formalization.D12PieceAPActionRow9
public import V14Formalization.D12PieceAPActionRow10
public import V14Formalization.D12PieceAPActionRow11
public import V14Formalization.D12PieceAPActionRow12
public import V14Formalization.D12PieceAPActionRow13
public import V14Formalization.D12PieceAPActionRow14
public import V14Formalization.D12PieceAPActionRow15
public import V14Formalization.D12PieceAPActionRow16
public import V14Formalization.D12PieceAPActionRow17
public import V14Formalization.D12PieceAPActionRow18
public import V14Formalization.D12PieceAPActionRow19

noncomputable section
namespace V14Formalization.D12PieceAPAction
open D12PieceVecBase D12PieceAPData

public theorem action_matrix :
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
