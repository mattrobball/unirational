/- Sparse ambient image-basis matrix in the rational-vector model. -/
module

public import V14Formalization.D12PieceVecBase

noncomputable section
open Matrix
namespace V14Formalization.D12PieceAmbientVec
open D12CyclotomicVec D12PieceVecBase D12PolynomialData D12PolynomialEvaluation
def payloadSha256 : String := "76c6196f29afe1a8398af99502447f48ebeed4bcb3805fc5dbec693940bc04b0"

@[expose] public def BCell0_0 : Vec := constVec (1)

@[expose] public def BCell0_1 : Vec := constVec (0)

@[expose] public def BCell0_2 : Vec := constVec (0)

@[expose] public def BCell0_3 : Vec := constVec (0)

@[expose] public def BCell0_4 : Vec := constVec (0)

@[expose] public def BCell0_5 : Vec := constVec (0)

@[expose] public def BCell0_6 : Vec := constVec (0)

@[expose] public def BCell0_7 : Vec := constVec (0)

@[expose] public def BCell0_8 : Vec := constVec (0)

@[expose] public def BCell0_9 : Vec := constVec (0)

@[expose] public def BRow0 (j : Fin 10) : Vec :=
  match j.val with
  | 0 => BCell0_0
  | 1 => BCell0_1
  | 2 => BCell0_2
  | 3 => BCell0_3
  | 4 => BCell0_4
  | 5 => BCell0_5
  | 6 => BCell0_6
  | 7 => BCell0_7
  | 8 => BCell0_8
  | 9 => BCell0_9
  | _ => 0

@[expose] public def BCell1_0 : Vec := constVec (0)

@[expose] public def BCell1_1 : Vec := constVec (1)

@[expose] public def BCell1_2 : Vec := constVec (0)

@[expose] public def BCell1_3 : Vec := constVec (0)

@[expose] public def BCell1_4 : Vec := constVec (0)

@[expose] public def BCell1_5 : Vec := constVec (0)

@[expose] public def BCell1_6 : Vec := constVec (0)

@[expose] public def BCell1_7 : Vec := constVec (0)

@[expose] public def BCell1_8 : Vec := constVec (0)

@[expose] public def BCell1_9 : Vec := constVec (0)

@[expose] public def BRow1 (j : Fin 10) : Vec :=
  match j.val with
  | 0 => BCell1_0
  | 1 => BCell1_1
  | 2 => BCell1_2
  | 3 => BCell1_3
  | 4 => BCell1_4
  | 5 => BCell1_5
  | 6 => BCell1_6
  | 7 => BCell1_7
  | 8 => BCell1_8
  | 9 => BCell1_9
  | _ => 0

@[expose] public def BCell2_0 : Vec := constVec (0)

@[expose] public def BCell2_1 : Vec := constVec (0)

@[expose] public def BCell2_2 : Vec := constVec (1)

@[expose] public def BCell2_3 : Vec := constVec (0)

@[expose] public def BCell2_4 : Vec := constVec (0)

@[expose] public def BCell2_5 : Vec := constVec (0)

@[expose] public def BCell2_6 : Vec := constVec (0)

@[expose] public def BCell2_7 : Vec := constVec (0)

@[expose] public def BCell2_8 : Vec := constVec (0)

@[expose] public def BCell2_9 : Vec := constVec (0)

@[expose] public def BRow2 (j : Fin 10) : Vec :=
  match j.val with
  | 0 => BCell2_0
  | 1 => BCell2_1
  | 2 => BCell2_2
  | 3 => BCell2_3
  | 4 => BCell2_4
  | 5 => BCell2_5
  | 6 => BCell2_6
  | 7 => BCell2_7
  | 8 => BCell2_8
  | 9 => BCell2_9
  | _ => 0

@[expose] public def BCell3_0 : Vec := constVec (0)

@[expose] public def BCell3_1 : Vec := constVec (0)

@[expose] public def BCell3_2 : Vec := constVec (0)

@[expose] public def BCell3_3 : Vec := constVec (1)

@[expose] public def BCell3_4 : Vec := constVec (0)

@[expose] public def BCell3_5 : Vec := constVec (0)

@[expose] public def BCell3_6 : Vec := constVec (0)

@[expose] public def BCell3_7 : Vec := constVec (0)

@[expose] public def BCell3_8 : Vec := constVec (0)

@[expose] public def BCell3_9 : Vec := constVec (0)

@[expose] public def BRow3 (j : Fin 10) : Vec :=
  match j.val with
  | 0 => BCell3_0
  | 1 => BCell3_1
  | 2 => BCell3_2
  | 3 => BCell3_3
  | 4 => BCell3_4
  | 5 => BCell3_5
  | 6 => BCell3_6
  | 7 => BCell3_7
  | 8 => BCell3_8
  | 9 => BCell3_9
  | _ => 0

@[expose] public def BCell4_0 : Vec := constVec (0)

@[expose] public def BCell4_1 : Vec := constVec (0)

@[expose] public def BCell4_2 : Vec := constVec (0)

@[expose] public def BCell4_3 : Vec := constVec (0)

@[expose] public def BCell4_4 : Vec := constVec (1)

@[expose] public def BCell4_5 : Vec := constVec (0)

@[expose] public def BCell4_6 : Vec := constVec (0)

@[expose] public def BCell4_7 : Vec := constVec (0)

@[expose] public def BCell4_8 : Vec := constVec (0)

@[expose] public def BCell4_9 : Vec := constVec (0)

@[expose] public def BRow4 (j : Fin 10) : Vec :=
  match j.val with
  | 0 => BCell4_0
  | 1 => BCell4_1
  | 2 => BCell4_2
  | 3 => BCell4_3
  | 4 => BCell4_4
  | 5 => BCell4_5
  | 6 => BCell4_6
  | 7 => BCell4_7
  | 8 => BCell4_8
  | 9 => BCell4_9
  | _ => 0

@[expose] public def BCell5_0 : Vec := constVec (0)

@[expose] public def BCell5_1 : Vec := constVec (0)

@[expose] public def BCell5_2 : Vec := constVec (0)

@[expose] public def BCell5_3 : Vec := constVec ((-1 / 2 : ℚ))

@[expose] public def BCell5_4 : Vec := constVec (0)

@[expose] public def BCell5_5 : Vec := constVec (0)

@[expose] public def BCell5_6 : Vec := constVec (0)

@[expose] public def BCell5_7 : Vec := constVec (0)

@[expose] public def BCell5_8 : Vec := constVec (0)

@[expose] public def BCell5_9 : Vec := constVec (0)

@[expose] public def BRow5 (j : Fin 10) : Vec :=
  match j.val with
  | 0 => BCell5_0
  | 1 => BCell5_1
  | 2 => BCell5_2
  | 3 => BCell5_3
  | 4 => BCell5_4
  | 5 => BCell5_5
  | 6 => BCell5_6
  | 7 => BCell5_7
  | 8 => BCell5_8
  | 9 => BCell5_9
  | _ => 0

@[expose] public def BCell6_0 : Vec := constVec (0)

@[expose] public def BCell6_1 : Vec := constVec (0)

@[expose] public def BCell6_2 : Vec := constVec (0)

@[expose] public def BCell6_3 : Vec := constVec (0)

@[expose] public def BCell6_4 : Vec := constVec (0)

@[expose] public def BCell6_5 : Vec := constVec (1)

@[expose] public def BCell6_6 : Vec := constVec (0)

@[expose] public def BCell6_7 : Vec := constVec (0)

@[expose] public def BCell6_8 : Vec := constVec (0)

@[expose] public def BCell6_9 : Vec := constVec (0)

@[expose] public def BRow6 (j : Fin 10) : Vec :=
  match j.val with
  | 0 => BCell6_0
  | 1 => BCell6_1
  | 2 => BCell6_2
  | 3 => BCell6_3
  | 4 => BCell6_4
  | 5 => BCell6_5
  | 6 => BCell6_6
  | 7 => BCell6_7
  | 8 => BCell6_8
  | 9 => BCell6_9
  | _ => 0

@[expose] public def BCell7_0 : Vec := constVec (0)

@[expose] public def BCell7_1 : Vec := constVec (0)

@[expose] public def BCell7_2 : Vec := constVec (0)

@[expose] public def BCell7_3 : Vec := constVec (0)

@[expose] public def BCell7_4 : Vec := constVec (0)

@[expose] public def BCell7_5 : Vec := constVec (0)

@[expose] public def BCell7_6 : Vec := constVec (1)

@[expose] public def BCell7_7 : Vec := constVec (0)

@[expose] public def BCell7_8 : Vec := constVec (0)

@[expose] public def BCell7_9 : Vec := constVec (0)

@[expose] public def BRow7 (j : Fin 10) : Vec :=
  match j.val with
  | 0 => BCell7_0
  | 1 => BCell7_1
  | 2 => BCell7_2
  | 3 => BCell7_3
  | 4 => BCell7_4
  | 5 => BCell7_5
  | 6 => BCell7_6
  | 7 => BCell7_7
  | 8 => BCell7_8
  | 9 => BCell7_9
  | _ => 0

@[expose] public def BCell8_0 : Vec := constVec (0)

@[expose] public def BCell8_1 : Vec := constVec ((1 / 2 : ℚ))

@[expose] public def BCell8_2 : Vec := constVec (0)

@[expose] public def BCell8_3 : Vec := constVec (0)

@[expose] public def BCell8_4 : Vec := constVec (0)

@[expose] public def BCell8_5 : Vec := constVec (0)

@[expose] public def BCell8_6 : Vec := constVec (0)

@[expose] public def BCell8_7 : Vec := constVec (0)

@[expose] public def BCell8_8 : Vec := constVec (0)

@[expose] public def BCell8_9 : Vec := constVec (0)

@[expose] public def BRow8 (j : Fin 10) : Vec :=
  match j.val with
  | 0 => BCell8_0
  | 1 => BCell8_1
  | 2 => BCell8_2
  | 3 => BCell8_3
  | 4 => BCell8_4
  | 5 => BCell8_5
  | 6 => BCell8_6
  | 7 => BCell8_7
  | 8 => BCell8_8
  | 9 => BCell8_9
  | _ => 0

@[expose] public def BCell9_0 : Vec := constVec (0)

@[expose] public def BCell9_1 : Vec := constVec (0)

@[expose] public def BCell9_2 : Vec := constVec (0)

@[expose] public def BCell9_3 : Vec := constVec (0)

@[expose] public def BCell9_4 : Vec := constVec (0)

@[expose] public def BCell9_5 : Vec := constVec (0)

@[expose] public def BCell9_6 : Vec := constVec (0)

@[expose] public def BCell9_7 : Vec := constVec (1)

@[expose] public def BCell9_8 : Vec := constVec (0)

@[expose] public def BCell9_9 : Vec := constVec (0)

@[expose] public def BRow9 (j : Fin 10) : Vec :=
  match j.val with
  | 0 => BCell9_0
  | 1 => BCell9_1
  | 2 => BCell9_2
  | 3 => BCell9_3
  | 4 => BCell9_4
  | 5 => BCell9_5
  | 6 => BCell9_6
  | 7 => BCell9_7
  | 8 => BCell9_8
  | 9 => BCell9_9
  | _ => 0

@[expose] public def BCell10_0 : Vec := constVec (0)

@[expose] public def BCell10_1 : Vec := constVec (0)

@[expose] public def BCell10_2 : Vec := constVec ((-1 / 2 : ℚ))

@[expose] public def BCell10_3 : Vec := constVec (0)

@[expose] public def BCell10_4 : Vec := constVec (0)

@[expose] public def BCell10_5 : Vec := constVec (0)

@[expose] public def BCell10_6 : Vec := constVec (0)

@[expose] public def BCell10_7 : Vec := constVec (0)

@[expose] public def BCell10_8 : Vec := constVec (0)

@[expose] public def BCell10_9 : Vec := constVec (0)

@[expose] public def BRow10 (j : Fin 10) : Vec :=
  match j.val with
  | 0 => BCell10_0
  | 1 => BCell10_1
  | 2 => BCell10_2
  | 3 => BCell10_3
  | 4 => BCell10_4
  | 5 => BCell10_5
  | 6 => BCell10_6
  | 7 => BCell10_7
  | 8 => BCell10_8
  | 9 => BCell10_9
  | _ => 0

@[expose] public def BCell11_0 : Vec := constVec (0)

@[expose] public def BCell11_1 : Vec := constVec (0)

@[expose] public def BCell11_2 : Vec := constVec (0)

@[expose] public def BCell11_3 : Vec := constVec (0)

@[expose] public def BCell11_4 : Vec := constVec (0)

@[expose] public def BCell11_5 : Vec := constVec (0)

@[expose] public def BCell11_6 : Vec := constVec (0)

@[expose] public def BCell11_7 : Vec := constVec (0)

@[expose] public def BCell11_8 : Vec := constVec (1)

@[expose] public def BCell11_9 : Vec := constVec (0)

@[expose] public def BRow11 (j : Fin 10) : Vec :=
  match j.val with
  | 0 => BCell11_0
  | 1 => BCell11_1
  | 2 => BCell11_2
  | 3 => BCell11_3
  | 4 => BCell11_4
  | 5 => BCell11_5
  | 6 => BCell11_6
  | 7 => BCell11_7
  | 8 => BCell11_8
  | 9 => BCell11_9
  | _ => 0

@[expose] public def BCell12_0 : Vec := constVec (0)

@[expose] public def BCell12_1 : Vec := constVec (0)

@[expose] public def BCell12_2 : Vec := constVec (0)

@[expose] public def BCell12_3 : Vec := constVec (0)

@[expose] public def BCell12_4 : Vec := constVec ((1 / 2 : ℚ))

@[expose] public def BCell12_5 : Vec := constVec (0)

@[expose] public def BCell12_6 : Vec := constVec (0)

@[expose] public def BCell12_7 : Vec := constVec (0)

@[expose] public def BCell12_8 : Vec := constVec (0)

@[expose] public def BCell12_9 : Vec := constVec (0)

@[expose] public def BRow12 (j : Fin 10) : Vec :=
  match j.val with
  | 0 => BCell12_0
  | 1 => BCell12_1
  | 2 => BCell12_2
  | 3 => BCell12_3
  | 4 => BCell12_4
  | 5 => BCell12_5
  | 6 => BCell12_6
  | 7 => BCell12_7
  | 8 => BCell12_8
  | 9 => BCell12_9
  | _ => 0

@[expose] public def BCell13_0 : Vec := constVec ((-1 / 2 : ℚ))

@[expose] public def BCell13_1 : Vec := constVec (0)

@[expose] public def BCell13_2 : Vec := constVec (0)

@[expose] public def BCell13_3 : Vec := constVec (0)

@[expose] public def BCell13_4 : Vec := constVec (0)

@[expose] public def BCell13_5 : Vec := constVec (0)

@[expose] public def BCell13_6 : Vec := constVec (0)

@[expose] public def BCell13_7 : Vec := constVec (0)

@[expose] public def BCell13_8 : Vec := constVec (0)

@[expose] public def BCell13_9 : Vec := constVec (0)

@[expose] public def BRow13 (j : Fin 10) : Vec :=
  match j.val with
  | 0 => BCell13_0
  | 1 => BCell13_1
  | 2 => BCell13_2
  | 3 => BCell13_3
  | 4 => BCell13_4
  | 5 => BCell13_5
  | 6 => BCell13_6
  | 7 => BCell13_7
  | 8 => BCell13_8
  | 9 => BCell13_9
  | _ => 0

@[expose] public def BCell14_0 : Vec := constVec (0)

@[expose] public def BCell14_1 : Vec := constVec (0)

@[expose] public def BCell14_2 : Vec := constVec (0)

@[expose] public def BCell14_3 : Vec := constVec (0)

@[expose] public def BCell14_4 : Vec := constVec (0)

@[expose] public def BCell14_5 : Vec := constVec (0)

@[expose] public def BCell14_6 : Vec := constVec (0)

@[expose] public def BCell14_7 : Vec := constVec (0)

@[expose] public def BCell14_8 : Vec := constVec (0)

@[expose] public def BCell14_9 : Vec := constVec (1)

@[expose] public def BRow14 (j : Fin 10) : Vec :=
  match j.val with
  | 0 => BCell14_0
  | 1 => BCell14_1
  | 2 => BCell14_2
  | 3 => BCell14_3
  | 4 => BCell14_4
  | 5 => BCell14_5
  | 6 => BCell14_6
  | 7 => BCell14_7
  | 8 => BCell14_8
  | 9 => BCell14_9
  | _ => 0

@[expose] public def BVec : Matrix (Fin 15) (Fin 10) Vec :=
  fun i j => match i.val with
  | 0 => BRow0 j
  | 1 => BRow1 j
  | 2 => BRow2 j
  | 3 => BRow3 j
  | 4 => BRow4 j
  | 5 => BRow5 j
  | 6 => BRow6 j
  | 7 => BRow7 j
  | 8 => BRow8 j
  | 9 => BRow9 j
  | 10 => BRow10 j
  | 11 => BRow11 j
  | 12 => BRow12 j
  | 13 => BRow13 j
  | 14 => BRow14 j
  | _ => 0

theorem eval_BRow0 (j : Fin 10) :
    D12CyclotomicVec.eval (BRow0 j) = evalK (B_poly (0 : Fin 15) j) := by
  fin_cases j <;>
    simp [BRow0, BCell0_0, BCell0_1, BCell0_2, BCell0_3, BCell0_4, BCell0_5, BCell0_6, BCell0_7, BCell0_8, BCell0_9, B_poly, evalK, evalPolyAt]

theorem eval_BRow1 (j : Fin 10) :
    D12CyclotomicVec.eval (BRow1 j) = evalK (B_poly (1 : Fin 15) j) := by
  fin_cases j <;>
    simp [BRow1, BCell1_0, BCell1_1, BCell1_2, BCell1_3, BCell1_4, BCell1_5, BCell1_6, BCell1_7, BCell1_8, BCell1_9, B_poly, evalK, evalPolyAt]

theorem eval_BRow2 (j : Fin 10) :
    D12CyclotomicVec.eval (BRow2 j) = evalK (B_poly (2 : Fin 15) j) := by
  fin_cases j <;>
    simp [BRow2, BCell2_0, BCell2_1, BCell2_2, BCell2_3, BCell2_4, BCell2_5, BCell2_6, BCell2_7, BCell2_8, BCell2_9, B_poly, evalK, evalPolyAt]

theorem eval_BRow3 (j : Fin 10) :
    D12CyclotomicVec.eval (BRow3 j) = evalK (B_poly (3 : Fin 15) j) := by
  fin_cases j <;>
    simp [BRow3, BCell3_0, BCell3_1, BCell3_2, BCell3_3, BCell3_4, BCell3_5, BCell3_6, BCell3_7, BCell3_8, BCell3_9, B_poly, evalK, evalPolyAt]

theorem eval_BRow4 (j : Fin 10) :
    D12CyclotomicVec.eval (BRow4 j) = evalK (B_poly (4 : Fin 15) j) := by
  fin_cases j <;>
    simp [BRow4, BCell4_0, BCell4_1, BCell4_2, BCell4_3, BCell4_4, BCell4_5, BCell4_6, BCell4_7, BCell4_8, BCell4_9, B_poly, evalK, evalPolyAt]

theorem eval_BRow5 (j : Fin 10) :
    D12CyclotomicVec.eval (BRow5 j) = evalK (B_poly (5 : Fin 15) j) := by
  fin_cases j <;>
    simp [BRow5, BCell5_0, BCell5_1, BCell5_2, BCell5_3, BCell5_4, BCell5_5, BCell5_6, BCell5_7, BCell5_8, BCell5_9, B_poly, evalK, evalPolyAt]

theorem eval_BRow6 (j : Fin 10) :
    D12CyclotomicVec.eval (BRow6 j) = evalK (B_poly (6 : Fin 15) j) := by
  fin_cases j <;>
    simp [BRow6, BCell6_0, BCell6_1, BCell6_2, BCell6_3, BCell6_4, BCell6_5, BCell6_6, BCell6_7, BCell6_8, BCell6_9, B_poly, evalK, evalPolyAt]

theorem eval_BRow7 (j : Fin 10) :
    D12CyclotomicVec.eval (BRow7 j) = evalK (B_poly (7 : Fin 15) j) := by
  fin_cases j <;>
    simp [BRow7, BCell7_0, BCell7_1, BCell7_2, BCell7_3, BCell7_4, BCell7_5, BCell7_6, BCell7_7, BCell7_8, BCell7_9, B_poly, evalK, evalPolyAt]

theorem eval_BRow8 (j : Fin 10) :
    D12CyclotomicVec.eval (BRow8 j) = evalK (B_poly (8 : Fin 15) j) := by
  fin_cases j <;>
    simp [BRow8, BCell8_0, BCell8_1, BCell8_2, BCell8_3, BCell8_4, BCell8_5, BCell8_6, BCell8_7, BCell8_8, BCell8_9, B_poly, evalK, evalPolyAt]

theorem eval_BRow9 (j : Fin 10) :
    D12CyclotomicVec.eval (BRow9 j) = evalK (B_poly (9 : Fin 15) j) := by
  fin_cases j <;>
    simp [BRow9, BCell9_0, BCell9_1, BCell9_2, BCell9_3, BCell9_4, BCell9_5, BCell9_6, BCell9_7, BCell9_8, BCell9_9, B_poly, evalK, evalPolyAt]

theorem eval_BRow10 (j : Fin 10) :
    D12CyclotomicVec.eval (BRow10 j) = evalK (B_poly (10 : Fin 15) j) := by
  fin_cases j <;>
    simp [BRow10, BCell10_0, BCell10_1, BCell10_2, BCell10_3, BCell10_4, BCell10_5, BCell10_6, BCell10_7, BCell10_8, BCell10_9, B_poly, evalK, evalPolyAt]

theorem eval_BRow11 (j : Fin 10) :
    D12CyclotomicVec.eval (BRow11 j) = evalK (B_poly (11 : Fin 15) j) := by
  fin_cases j <;>
    simp [BRow11, BCell11_0, BCell11_1, BCell11_2, BCell11_3, BCell11_4, BCell11_5, BCell11_6, BCell11_7, BCell11_8, BCell11_9, B_poly, evalK, evalPolyAt]

theorem eval_BRow12 (j : Fin 10) :
    D12CyclotomicVec.eval (BRow12 j) = evalK (B_poly (12 : Fin 15) j) := by
  fin_cases j <;>
    simp [BRow12, BCell12_0, BCell12_1, BCell12_2, BCell12_3, BCell12_4, BCell12_5, BCell12_6, BCell12_7, BCell12_8, BCell12_9, B_poly, evalK, evalPolyAt]

theorem eval_BRow13 (j : Fin 10) :
    D12CyclotomicVec.eval (BRow13 j) = evalK (B_poly (13 : Fin 15) j) := by
  fin_cases j <;>
    simp [BRow13, BCell13_0, BCell13_1, BCell13_2, BCell13_3, BCell13_4, BCell13_5, BCell13_6, BCell13_7, BCell13_8, BCell13_9, B_poly, evalK, evalPolyAt]

theorem eval_BRow14 (j : Fin 10) :
    D12CyclotomicVec.eval (BRow14 j) = evalK (B_poly (14 : Fin 15) j) := by
  fin_cases j <;>
    simp [BRow14, BCell14_0, BCell14_1, BCell14_2, BCell14_3, BCell14_4, BCell14_5, BCell14_6, BCell14_7, BCell14_8, BCell14_9, B_poly, evalK, evalPolyAt]

public theorem evalMatrix_BVec : evalMatrix BVec = evalMatrixK B_poly := by
  ext i j
  fin_cases i
  · exact eval_BRow0 j
  · exact eval_BRow1 j
  · exact eval_BRow2 j
  · exact eval_BRow3 j
  · exact eval_BRow4 j
  · exact eval_BRow5 j
  · exact eval_BRow6 j
  · exact eval_BRow7 j
  · exact eval_BRow8 j
  · exact eval_BRow9 j
  · exact eval_BRow10 j
  · exact eval_BRow11 j
  · exact eval_BRow12 j
  · exact eval_BRow13 j
  · exact eval_BRow14 j

end V14Formalization.D12PieceAmbientVec
