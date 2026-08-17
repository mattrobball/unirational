/- Determinant of the normalized PP Plucker coefficient matrix. -/
module

public import V14Formalization.D12PiecePPPluckerBase

noncomputable section
open Matrix
namespace V14Formalization.D12PiecePPDeterminant
open D12CyclotomicVec D12PiecePPPluckerBase
def payloadSha256 : String := "76c6196f29afe1a8398af99502447f48ebeed4bcb3805fc5dbec693940bc04b0"

def detPair0 : Vec := mul CCell0_0 CCell1_1

def detPair0Value (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (3 / 2 : ℚ)
  | 1 => 0
  | 2 => -2
  | 3 => 0
  | 4 => (3 / 2 : ℚ)
  | 5 => -2
  | 6 => -2
  | 7 => (3 / 2 : ℚ)
  | 8 => 0
  | 9 => -2
  | _ => 0

theorem detPair0_apply_0 :
    detPair0 (0 : Fin 10) = detPair0Value (0 : Fin 10) := by
  norm_num [detPair0, detPair0Value, CCell0_0, CCell1_1,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem detPair0_apply_1 :
    detPair0 (1 : Fin 10) = detPair0Value (1 : Fin 10) := by
  norm_num [detPair0, detPair0Value, CCell0_0, CCell1_1,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem detPair0_apply_2 :
    detPair0 (2 : Fin 10) = detPair0Value (2 : Fin 10) := by
  norm_num [detPair0, detPair0Value, CCell0_0, CCell1_1,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem detPair0_apply_3 :
    detPair0 (3 : Fin 10) = detPair0Value (3 : Fin 10) := by
  norm_num [detPair0, detPair0Value, CCell0_0, CCell1_1,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem detPair0_apply_4 :
    detPair0 (4 : Fin 10) = detPair0Value (4 : Fin 10) := by
  norm_num [detPair0, detPair0Value, CCell0_0, CCell1_1,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem detPair0_apply_5 :
    detPair0 (5 : Fin 10) = detPair0Value (5 : Fin 10) := by
  norm_num [detPair0, detPair0Value, CCell0_0, CCell1_1,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem detPair0_apply_6 :
    detPair0 (6 : Fin 10) = detPair0Value (6 : Fin 10) := by
  norm_num [detPair0, detPair0Value, CCell0_0, CCell1_1,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem detPair0_apply_7 :
    detPair0 (7 : Fin 10) = detPair0Value (7 : Fin 10) := by
  norm_num [detPair0, detPair0Value, CCell0_0, CCell1_1,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem detPair0_apply_8 :
    detPair0 (8 : Fin 10) = detPair0Value (8 : Fin 10) := by
  norm_num [detPair0, detPair0Value, CCell0_0, CCell1_1,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem detPair0_apply_9 :
    detPair0 (9 : Fin 10) = detPair0Value (9 : Fin 10) := by
  norm_num [detPair0, detPair0Value, CCell0_0, CCell1_1,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem detPair0_eq : detPair0 = detPair0Value := by
  funext n
  fin_cases n
  · exact detPair0_apply_0
  · exact detPair0_apply_1
  · exact detPair0_apply_2
  · exact detPair0_apply_3
  · exact detPair0_apply_4
  · exact detPair0_apply_5
  · exact detPair0_apply_6
  · exact detPair0_apply_7
  · exact detPair0_apply_8
  · exact detPair0_apply_9

def detTriple0 : Vec := mul detPair0Value CCell2_2

def detTriple0Value (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (-147 / 4 : ℚ)
  | 1 => 0
  | 2 => (51 / 2 : ℚ)
  | 3 => (-39 / 2 : ℚ)
  | 4 => (-65 / 2 : ℚ)
  | 5 => (33 / 2 : ℚ)
  | 6 => (33 / 2 : ℚ)
  | 7 => (-65 / 2 : ℚ)
  | 8 => (-39 / 2 : ℚ)
  | 9 => (51 / 2 : ℚ)
  | _ => 0

theorem detTriple0_apply_0 :
    detTriple0 (0 : Fin 10) = detTriple0Value (0 : Fin 10) := by
  norm_num [detTriple0, detTriple0Value, detPair0Value, CCell2_2,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem detTriple0_apply_1 :
    detTriple0 (1 : Fin 10) = detTriple0Value (1 : Fin 10) := by
  norm_num [detTriple0, detTriple0Value, detPair0Value, CCell2_2,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem detTriple0_apply_2 :
    detTriple0 (2 : Fin 10) = detTriple0Value (2 : Fin 10) := by
  norm_num [detTriple0, detTriple0Value, detPair0Value, CCell2_2,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem detTriple0_apply_3 :
    detTriple0 (3 : Fin 10) = detTriple0Value (3 : Fin 10) := by
  norm_num [detTriple0, detTriple0Value, detPair0Value, CCell2_2,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem detTriple0_apply_4 :
    detTriple0 (4 : Fin 10) = detTriple0Value (4 : Fin 10) := by
  norm_num [detTriple0, detTriple0Value, detPair0Value, CCell2_2,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem detTriple0_apply_5 :
    detTriple0 (5 : Fin 10) = detTriple0Value (5 : Fin 10) := by
  norm_num [detTriple0, detTriple0Value, detPair0Value, CCell2_2,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem detTriple0_apply_6 :
    detTriple0 (6 : Fin 10) = detTriple0Value (6 : Fin 10) := by
  norm_num [detTriple0, detTriple0Value, detPair0Value, CCell2_2,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem detTriple0_apply_7 :
    detTriple0 (7 : Fin 10) = detTriple0Value (7 : Fin 10) := by
  norm_num [detTriple0, detTriple0Value, detPair0Value, CCell2_2,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem detTriple0_apply_8 :
    detTriple0 (8 : Fin 10) = detTriple0Value (8 : Fin 10) := by
  norm_num [detTriple0, detTriple0Value, detPair0Value, CCell2_2,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem detTriple0_apply_9 :
    detTriple0 (9 : Fin 10) = detTriple0Value (9 : Fin 10) := by
  norm_num [detTriple0, detTriple0Value, detPair0Value, CCell2_2,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem detTriple0_eq : detTriple0 = detTriple0Value := by
  funext n
  fin_cases n
  · exact detTriple0_apply_0
  · exact detTriple0_apply_1
  · exact detTriple0_apply_2
  · exact detTriple0_apply_3
  · exact detTriple0_apply_4
  · exact detTriple0_apply_5
  · exact detTriple0_apply_6
  · exact detTriple0_apply_7
  · exact detTriple0_apply_8
  · exact detTriple0_apply_9

theorem detTriple0_actual :
    mul (mul CCell0_0 CCell1_1) CCell2_2 = detTriple0Value := by
  calc
    _ = mul detPair0Value CCell2_2 :=
      congrArg (fun v => mul v CCell2_2) detPair0_eq
    _ = _ := detTriple0_eq

theorem eval_detTriple0 :
    eval CCell0_0 * eval CCell1_1 * eval CCell2_2 =
      eval detTriple0Value := by
  calc
    _ = eval (mul (mul CCell0_0 CCell1_1) CCell2_2) := by
      simp only [eval_mul]
    _ = _ := congrArg eval detTriple0_actual

def detPair1 : Vec := mul CCell0_0 CCell1_2

def detPair1Value (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (3 / 2 : ℚ)
  | 1 => 0
  | 2 => (-3 / 4 : ℚ)
  | 3 => (5 / 4 : ℚ)
  | 4 => (5 / 4 : ℚ)
  | 5 => -1
  | 6 => -1
  | 7 => (5 / 4 : ℚ)
  | 8 => (5 / 4 : ℚ)
  | 9 => (-3 / 4 : ℚ)
  | _ => 0

theorem detPair1_apply_0 :
    detPair1 (0 : Fin 10) = detPair1Value (0 : Fin 10) := by
  norm_num [detPair1, detPair1Value, CCell0_0, CCell1_2,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem detPair1_apply_1 :
    detPair1 (1 : Fin 10) = detPair1Value (1 : Fin 10) := by
  norm_num [detPair1, detPair1Value, CCell0_0, CCell1_2,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem detPair1_apply_2 :
    detPair1 (2 : Fin 10) = detPair1Value (2 : Fin 10) := by
  norm_num [detPair1, detPair1Value, CCell0_0, CCell1_2,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem detPair1_apply_3 :
    detPair1 (3 : Fin 10) = detPair1Value (3 : Fin 10) := by
  norm_num [detPair1, detPair1Value, CCell0_0, CCell1_2,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem detPair1_apply_4 :
    detPair1 (4 : Fin 10) = detPair1Value (4 : Fin 10) := by
  norm_num [detPair1, detPair1Value, CCell0_0, CCell1_2,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem detPair1_apply_5 :
    detPair1 (5 : Fin 10) = detPair1Value (5 : Fin 10) := by
  norm_num [detPair1, detPair1Value, CCell0_0, CCell1_2,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem detPair1_apply_6 :
    detPair1 (6 : Fin 10) = detPair1Value (6 : Fin 10) := by
  norm_num [detPair1, detPair1Value, CCell0_0, CCell1_2,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem detPair1_apply_7 :
    detPair1 (7 : Fin 10) = detPair1Value (7 : Fin 10) := by
  norm_num [detPair1, detPair1Value, CCell0_0, CCell1_2,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem detPair1_apply_8 :
    detPair1 (8 : Fin 10) = detPair1Value (8 : Fin 10) := by
  norm_num [detPair1, detPair1Value, CCell0_0, CCell1_2,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem detPair1_apply_9 :
    detPair1 (9 : Fin 10) = detPair1Value (9 : Fin 10) := by
  norm_num [detPair1, detPair1Value, CCell0_0, CCell1_2,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem detPair1_eq : detPair1 = detPair1Value := by
  funext n
  fin_cases n
  · exact detPair1_apply_0
  · exact detPair1_apply_1
  · exact detPair1_apply_2
  · exact detPair1_apply_3
  · exact detPair1_apply_4
  · exact detPair1_apply_5
  · exact detPair1_apply_6
  · exact detPair1_apply_7
  · exact detPair1_apply_8
  · exact detPair1_apply_9

def detTriple1 : Vec := mul detPair1Value CCell2_1

def detTriple1Value (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (-19 / 2 : ℚ)
  | 1 => 0
  | 2 => (15 / 4 : ℚ)
  | 3 => (-51 / 4 : ℚ)
  | 4 => (-27 / 2 : ℚ)
  | 5 => 8
  | 6 => 8
  | 7 => (-27 / 2 : ℚ)
  | 8 => (-51 / 4 : ℚ)
  | 9 => (15 / 4 : ℚ)
  | _ => 0

theorem detTriple1_apply_0 :
    detTriple1 (0 : Fin 10) = detTriple1Value (0 : Fin 10) := by
  norm_num [detTriple1, detTriple1Value, detPair1Value, CCell2_1,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem detTriple1_apply_1 :
    detTriple1 (1 : Fin 10) = detTriple1Value (1 : Fin 10) := by
  norm_num [detTriple1, detTriple1Value, detPair1Value, CCell2_1,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem detTriple1_apply_2 :
    detTriple1 (2 : Fin 10) = detTriple1Value (2 : Fin 10) := by
  norm_num [detTriple1, detTriple1Value, detPair1Value, CCell2_1,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem detTriple1_apply_3 :
    detTriple1 (3 : Fin 10) = detTriple1Value (3 : Fin 10) := by
  norm_num [detTriple1, detTriple1Value, detPair1Value, CCell2_1,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem detTriple1_apply_4 :
    detTriple1 (4 : Fin 10) = detTriple1Value (4 : Fin 10) := by
  norm_num [detTriple1, detTriple1Value, detPair1Value, CCell2_1,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem detTriple1_apply_5 :
    detTriple1 (5 : Fin 10) = detTriple1Value (5 : Fin 10) := by
  norm_num [detTriple1, detTriple1Value, detPair1Value, CCell2_1,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem detTriple1_apply_6 :
    detTriple1 (6 : Fin 10) = detTriple1Value (6 : Fin 10) := by
  norm_num [detTriple1, detTriple1Value, detPair1Value, CCell2_1,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem detTriple1_apply_7 :
    detTriple1 (7 : Fin 10) = detTriple1Value (7 : Fin 10) := by
  norm_num [detTriple1, detTriple1Value, detPair1Value, CCell2_1,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem detTriple1_apply_8 :
    detTriple1 (8 : Fin 10) = detTriple1Value (8 : Fin 10) := by
  norm_num [detTriple1, detTriple1Value, detPair1Value, CCell2_1,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem detTriple1_apply_9 :
    detTriple1 (9 : Fin 10) = detTriple1Value (9 : Fin 10) := by
  norm_num [detTriple1, detTriple1Value, detPair1Value, CCell2_1,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem detTriple1_eq : detTriple1 = detTriple1Value := by
  funext n
  fin_cases n
  · exact detTriple1_apply_0
  · exact detTriple1_apply_1
  · exact detTriple1_apply_2
  · exact detTriple1_apply_3
  · exact detTriple1_apply_4
  · exact detTriple1_apply_5
  · exact detTriple1_apply_6
  · exact detTriple1_apply_7
  · exact detTriple1_apply_8
  · exact detTriple1_apply_9

theorem detTriple1_actual :
    mul (mul CCell0_0 CCell1_2) CCell2_1 = detTriple1Value := by
  calc
    _ = mul detPair1Value CCell2_1 :=
      congrArg (fun v => mul v CCell2_1) detPair1_eq
    _ = _ := detTriple1_eq

theorem eval_detTriple1 :
    eval CCell0_0 * eval CCell1_2 * eval CCell2_1 =
      eval detTriple1Value := by
  calc
    _ = eval (mul (mul CCell0_0 CCell1_2) CCell2_1) := by
      simp only [eval_mul]
    _ = _ := congrArg eval detTriple1_actual

def detPair2 : Vec := mul CCell0_1 CCell1_0

def detPair2Value (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (7 / 2 : ℚ)
  | 1 => 0
  | 2 => (-7 / 2 : ℚ)
  | 3 => (1 / 2 : ℚ)
  | 4 => (5 / 2 : ℚ)
  | 5 => (-9 / 2 : ℚ)
  | 6 => (-9 / 2 : ℚ)
  | 7 => (5 / 2 : ℚ)
  | 8 => (1 / 2 : ℚ)
  | 9 => (-7 / 2 : ℚ)
  | _ => 0

theorem detPair2_apply_0 :
    detPair2 (0 : Fin 10) = detPair2Value (0 : Fin 10) := by
  norm_num [detPair2, detPair2Value, CCell0_1, CCell1_0,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem detPair2_apply_1 :
    detPair2 (1 : Fin 10) = detPair2Value (1 : Fin 10) := by
  norm_num [detPair2, detPair2Value, CCell0_1, CCell1_0,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem detPair2_apply_2 :
    detPair2 (2 : Fin 10) = detPair2Value (2 : Fin 10) := by
  norm_num [detPair2, detPair2Value, CCell0_1, CCell1_0,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem detPair2_apply_3 :
    detPair2 (3 : Fin 10) = detPair2Value (3 : Fin 10) := by
  norm_num [detPair2, detPair2Value, CCell0_1, CCell1_0,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem detPair2_apply_4 :
    detPair2 (4 : Fin 10) = detPair2Value (4 : Fin 10) := by
  norm_num [detPair2, detPair2Value, CCell0_1, CCell1_0,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem detPair2_apply_5 :
    detPair2 (5 : Fin 10) = detPair2Value (5 : Fin 10) := by
  norm_num [detPair2, detPair2Value, CCell0_1, CCell1_0,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem detPair2_apply_6 :
    detPair2 (6 : Fin 10) = detPair2Value (6 : Fin 10) := by
  norm_num [detPair2, detPair2Value, CCell0_1, CCell1_0,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem detPair2_apply_7 :
    detPair2 (7 : Fin 10) = detPair2Value (7 : Fin 10) := by
  norm_num [detPair2, detPair2Value, CCell0_1, CCell1_0,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem detPair2_apply_8 :
    detPair2 (8 : Fin 10) = detPair2Value (8 : Fin 10) := by
  norm_num [detPair2, detPair2Value, CCell0_1, CCell1_0,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem detPair2_apply_9 :
    detPair2 (9 : Fin 10) = detPair2Value (9 : Fin 10) := by
  norm_num [detPair2, detPair2Value, CCell0_1, CCell1_0,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem detPair2_eq : detPair2 = detPair2Value := by
  funext n
  fin_cases n
  · exact detPair2_apply_0
  · exact detPair2_apply_1
  · exact detPair2_apply_2
  · exact detPair2_apply_3
  · exact detPair2_apply_4
  · exact detPair2_apply_5
  · exact detPair2_apply_6
  · exact detPair2_apply_7
  · exact detPair2_apply_8
  · exact detPair2_apply_9

def detTriple2 : Vec := mul detPair2Value CCell2_2

def detTriple2Value (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => -75
  | 1 => 0
  | 2 => 55
  | 3 => (-131 / 4 : ℚ)
  | 4 => (-249 / 4 : ℚ)
  | 5 => (61 / 2 : ℚ)
  | 6 => (61 / 2 : ℚ)
  | 7 => (-249 / 4 : ℚ)
  | 8 => (-131 / 4 : ℚ)
  | 9 => 55
  | _ => 0

theorem detTriple2_apply_0 :
    detTriple2 (0 : Fin 10) = detTriple2Value (0 : Fin 10) := by
  norm_num [detTriple2, detTriple2Value, detPair2Value, CCell2_2,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem detTriple2_apply_1 :
    detTriple2 (1 : Fin 10) = detTriple2Value (1 : Fin 10) := by
  norm_num [detTriple2, detTriple2Value, detPair2Value, CCell2_2,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem detTriple2_apply_2 :
    detTriple2 (2 : Fin 10) = detTriple2Value (2 : Fin 10) := by
  norm_num [detTriple2, detTriple2Value, detPair2Value, CCell2_2,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem detTriple2_apply_3 :
    detTriple2 (3 : Fin 10) = detTriple2Value (3 : Fin 10) := by
  norm_num [detTriple2, detTriple2Value, detPair2Value, CCell2_2,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem detTriple2_apply_4 :
    detTriple2 (4 : Fin 10) = detTriple2Value (4 : Fin 10) := by
  norm_num [detTriple2, detTriple2Value, detPair2Value, CCell2_2,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem detTriple2_apply_5 :
    detTriple2 (5 : Fin 10) = detTriple2Value (5 : Fin 10) := by
  norm_num [detTriple2, detTriple2Value, detPair2Value, CCell2_2,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem detTriple2_apply_6 :
    detTriple2 (6 : Fin 10) = detTriple2Value (6 : Fin 10) := by
  norm_num [detTriple2, detTriple2Value, detPair2Value, CCell2_2,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem detTriple2_apply_7 :
    detTriple2 (7 : Fin 10) = detTriple2Value (7 : Fin 10) := by
  norm_num [detTriple2, detTriple2Value, detPair2Value, CCell2_2,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem detTriple2_apply_8 :
    detTriple2 (8 : Fin 10) = detTriple2Value (8 : Fin 10) := by
  norm_num [detTriple2, detTriple2Value, detPair2Value, CCell2_2,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem detTriple2_apply_9 :
    detTriple2 (9 : Fin 10) = detTriple2Value (9 : Fin 10) := by
  norm_num [detTriple2, detTriple2Value, detPair2Value, CCell2_2,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem detTriple2_eq : detTriple2 = detTriple2Value := by
  funext n
  fin_cases n
  · exact detTriple2_apply_0
  · exact detTriple2_apply_1
  · exact detTriple2_apply_2
  · exact detTriple2_apply_3
  · exact detTriple2_apply_4
  · exact detTriple2_apply_5
  · exact detTriple2_apply_6
  · exact detTriple2_apply_7
  · exact detTriple2_apply_8
  · exact detTriple2_apply_9

theorem detTriple2_actual :
    mul (mul CCell0_1 CCell1_0) CCell2_2 = detTriple2Value := by
  calc
    _ = mul detPair2Value CCell2_2 :=
      congrArg (fun v => mul v CCell2_2) detPair2_eq
    _ = _ := detTriple2_eq

theorem eval_detTriple2 :
    eval CCell0_1 * eval CCell1_0 * eval CCell2_2 =
      eval detTriple2Value := by
  calc
    _ = eval (mul (mul CCell0_1 CCell1_0) CCell2_2) := by
      simp only [eval_mul]
    _ = _ := congrArg eval detTriple2_actual

def detPair3 : Vec := mul CCell0_1 CCell1_2

def detPair3Value (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 7
  | 1 => 0
  | 2 => (-11 / 2 : ℚ)
  | 3 => 2
  | 4 => (9 / 2 : ℚ)
  | 5 => -3
  | 6 => -3
  | 7 => (9 / 2 : ℚ)
  | 8 => 2
  | 9 => (-11 / 2 : ℚ)
  | _ => 0

theorem detPair3_apply_0 :
    detPair3 (0 : Fin 10) = detPair3Value (0 : Fin 10) := by
  norm_num [detPair3, detPair3Value, CCell0_1, CCell1_2,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem detPair3_apply_1 :
    detPair3 (1 : Fin 10) = detPair3Value (1 : Fin 10) := by
  norm_num [detPair3, detPair3Value, CCell0_1, CCell1_2,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem detPair3_apply_2 :
    detPair3 (2 : Fin 10) = detPair3Value (2 : Fin 10) := by
  norm_num [detPair3, detPair3Value, CCell0_1, CCell1_2,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem detPair3_apply_3 :
    detPair3 (3 : Fin 10) = detPair3Value (3 : Fin 10) := by
  norm_num [detPair3, detPair3Value, CCell0_1, CCell1_2,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem detPair3_apply_4 :
    detPair3 (4 : Fin 10) = detPair3Value (4 : Fin 10) := by
  norm_num [detPair3, detPair3Value, CCell0_1, CCell1_2,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem detPair3_apply_5 :
    detPair3 (5 : Fin 10) = detPair3Value (5 : Fin 10) := by
  norm_num [detPair3, detPair3Value, CCell0_1, CCell1_2,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem detPair3_apply_6 :
    detPair3 (6 : Fin 10) = detPair3Value (6 : Fin 10) := by
  norm_num [detPair3, detPair3Value, CCell0_1, CCell1_2,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem detPair3_apply_7 :
    detPair3 (7 : Fin 10) = detPair3Value (7 : Fin 10) := by
  norm_num [detPair3, detPair3Value, CCell0_1, CCell1_2,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem detPair3_apply_8 :
    detPair3 (8 : Fin 10) = detPair3Value (8 : Fin 10) := by
  norm_num [detPair3, detPair3Value, CCell0_1, CCell1_2,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem detPair3_apply_9 :
    detPair3 (9 : Fin 10) = detPair3Value (9 : Fin 10) := by
  norm_num [detPair3, detPair3Value, CCell0_1, CCell1_2,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem detPair3_eq : detPair3 = detPair3Value := by
  funext n
  fin_cases n
  · exact detPair3_apply_0
  · exact detPair3_apply_1
  · exact detPair3_apply_2
  · exact detPair3_apply_3
  · exact detPair3_apply_4
  · exact detPair3_apply_5
  · exact detPair3_apply_6
  · exact detPair3_apply_7
  · exact detPair3_apply_8
  · exact detPair3_apply_9

def detTriple3 : Vec := mul detPair3Value CCell2_0

def detTriple3Value (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 11
  | 1 => 0
  | 2 => -9
  | 3 => (9 / 4 : ℚ)
  | 4 => (31 / 4 : ℚ)
  | 5 => -2
  | 6 => -2
  | 7 => (31 / 4 : ℚ)
  | 8 => (9 / 4 : ℚ)
  | 9 => -9
  | _ => 0

theorem detTriple3_apply_0 :
    detTriple3 (0 : Fin 10) = detTriple3Value (0 : Fin 10) := by
  norm_num [detTriple3, detTriple3Value, detPair3Value, CCell2_0,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem detTriple3_apply_1 :
    detTriple3 (1 : Fin 10) = detTriple3Value (1 : Fin 10) := by
  norm_num [detTriple3, detTriple3Value, detPair3Value, CCell2_0,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem detTriple3_apply_2 :
    detTriple3 (2 : Fin 10) = detTriple3Value (2 : Fin 10) := by
  norm_num [detTriple3, detTriple3Value, detPair3Value, CCell2_0,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem detTriple3_apply_3 :
    detTriple3 (3 : Fin 10) = detTriple3Value (3 : Fin 10) := by
  norm_num [detTriple3, detTriple3Value, detPair3Value, CCell2_0,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem detTriple3_apply_4 :
    detTriple3 (4 : Fin 10) = detTriple3Value (4 : Fin 10) := by
  norm_num [detTriple3, detTriple3Value, detPair3Value, CCell2_0,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem detTriple3_apply_5 :
    detTriple3 (5 : Fin 10) = detTriple3Value (5 : Fin 10) := by
  norm_num [detTriple3, detTriple3Value, detPair3Value, CCell2_0,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem detTriple3_apply_6 :
    detTriple3 (6 : Fin 10) = detTriple3Value (6 : Fin 10) := by
  norm_num [detTriple3, detTriple3Value, detPair3Value, CCell2_0,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem detTriple3_apply_7 :
    detTriple3 (7 : Fin 10) = detTriple3Value (7 : Fin 10) := by
  norm_num [detTriple3, detTriple3Value, detPair3Value, CCell2_0,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem detTriple3_apply_8 :
    detTriple3 (8 : Fin 10) = detTriple3Value (8 : Fin 10) := by
  norm_num [detTriple3, detTriple3Value, detPair3Value, CCell2_0,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem detTriple3_apply_9 :
    detTriple3 (9 : Fin 10) = detTriple3Value (9 : Fin 10) := by
  norm_num [detTriple3, detTriple3Value, detPair3Value, CCell2_0,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem detTriple3_eq : detTriple3 = detTriple3Value := by
  funext n
  fin_cases n
  · exact detTriple3_apply_0
  · exact detTriple3_apply_1
  · exact detTriple3_apply_2
  · exact detTriple3_apply_3
  · exact detTriple3_apply_4
  · exact detTriple3_apply_5
  · exact detTriple3_apply_6
  · exact detTriple3_apply_7
  · exact detTriple3_apply_8
  · exact detTriple3_apply_9

theorem detTriple3_actual :
    mul (mul CCell0_1 CCell1_2) CCell2_0 = detTriple3Value := by
  calc
    _ = mul detPair3Value CCell2_0 :=
      congrArg (fun v => mul v CCell2_0) detPair3_eq
    _ = _ := detTriple3_eq

theorem eval_detTriple3 :
    eval CCell0_1 * eval CCell1_2 * eval CCell2_0 =
      eval detTriple3Value := by
  calc
    _ = eval (mul (mul CCell0_1 CCell1_2) CCell2_0) := by
      simp only [eval_mul]
    _ = _ := congrArg eval detTriple3_actual

def detPair4 : Vec := mul CCell0_2 CCell1_0

def detPair4Value (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 5
  | 1 => 0
  | 2 => (-15 / 4 : ℚ)
  | 3 => (9 / 4 : ℚ)
  | 4 => (17 / 4 : ℚ)
  | 5 => -2
  | 6 => -2
  | 7 => (17 / 4 : ℚ)
  | 8 => (9 / 4 : ℚ)
  | 9 => (-15 / 4 : ℚ)
  | _ => 0

theorem detPair4_apply_0 :
    detPair4 (0 : Fin 10) = detPair4Value (0 : Fin 10) := by
  norm_num [detPair4, detPair4Value, CCell0_2, CCell1_0,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem detPair4_apply_1 :
    detPair4 (1 : Fin 10) = detPair4Value (1 : Fin 10) := by
  norm_num [detPair4, detPair4Value, CCell0_2, CCell1_0,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem detPair4_apply_2 :
    detPair4 (2 : Fin 10) = detPair4Value (2 : Fin 10) := by
  norm_num [detPair4, detPair4Value, CCell0_2, CCell1_0,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem detPair4_apply_3 :
    detPair4 (3 : Fin 10) = detPair4Value (3 : Fin 10) := by
  norm_num [detPair4, detPair4Value, CCell0_2, CCell1_0,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem detPair4_apply_4 :
    detPair4 (4 : Fin 10) = detPair4Value (4 : Fin 10) := by
  norm_num [detPair4, detPair4Value, CCell0_2, CCell1_0,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem detPair4_apply_5 :
    detPair4 (5 : Fin 10) = detPair4Value (5 : Fin 10) := by
  norm_num [detPair4, detPair4Value, CCell0_2, CCell1_0,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem detPair4_apply_6 :
    detPair4 (6 : Fin 10) = detPair4Value (6 : Fin 10) := by
  norm_num [detPair4, detPair4Value, CCell0_2, CCell1_0,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem detPair4_apply_7 :
    detPair4 (7 : Fin 10) = detPair4Value (7 : Fin 10) := by
  norm_num [detPair4, detPair4Value, CCell0_2, CCell1_0,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem detPair4_apply_8 :
    detPair4 (8 : Fin 10) = detPair4Value (8 : Fin 10) := by
  norm_num [detPair4, detPair4Value, CCell0_2, CCell1_0,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem detPair4_apply_9 :
    detPair4 (9 : Fin 10) = detPair4Value (9 : Fin 10) := by
  norm_num [detPair4, detPair4Value, CCell0_2, CCell1_0,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem detPair4_eq : detPair4 = detPair4Value := by
  funext n
  fin_cases n
  · exact detPair4_apply_0
  · exact detPair4_apply_1
  · exact detPair4_apply_2
  · exact detPair4_apply_3
  · exact detPair4_apply_4
  · exact detPair4_apply_5
  · exact detPair4_apply_6
  · exact detPair4_apply_7
  · exact detPair4_apply_8
  · exact detPair4_apply_9

def detTriple4 : Vec := mul detPair4Value CCell2_1

def detTriple4Value (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => -42
  | 1 => 0
  | 2 => (127 / 4 : ℚ)
  | 3 => (-65 / 4 : ℚ)
  | 4 => (-67 / 2 : ℚ)
  | 5 => 17
  | 6 => 17
  | 7 => (-67 / 2 : ℚ)
  | 8 => (-65 / 4 : ℚ)
  | 9 => (127 / 4 : ℚ)
  | _ => 0

theorem detTriple4_apply_0 :
    detTriple4 (0 : Fin 10) = detTriple4Value (0 : Fin 10) := by
  norm_num [detTriple4, detTriple4Value, detPair4Value, CCell2_1,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem detTriple4_apply_1 :
    detTriple4 (1 : Fin 10) = detTriple4Value (1 : Fin 10) := by
  norm_num [detTriple4, detTriple4Value, detPair4Value, CCell2_1,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem detTriple4_apply_2 :
    detTriple4 (2 : Fin 10) = detTriple4Value (2 : Fin 10) := by
  norm_num [detTriple4, detTriple4Value, detPair4Value, CCell2_1,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem detTriple4_apply_3 :
    detTriple4 (3 : Fin 10) = detTriple4Value (3 : Fin 10) := by
  norm_num [detTriple4, detTriple4Value, detPair4Value, CCell2_1,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem detTriple4_apply_4 :
    detTriple4 (4 : Fin 10) = detTriple4Value (4 : Fin 10) := by
  norm_num [detTriple4, detTriple4Value, detPair4Value, CCell2_1,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem detTriple4_apply_5 :
    detTriple4 (5 : Fin 10) = detTriple4Value (5 : Fin 10) := by
  norm_num [detTriple4, detTriple4Value, detPair4Value, CCell2_1,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem detTriple4_apply_6 :
    detTriple4 (6 : Fin 10) = detTriple4Value (6 : Fin 10) := by
  norm_num [detTriple4, detTriple4Value, detPair4Value, CCell2_1,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem detTriple4_apply_7 :
    detTriple4 (7 : Fin 10) = detTriple4Value (7 : Fin 10) := by
  norm_num [detTriple4, detTriple4Value, detPair4Value, CCell2_1,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem detTriple4_apply_8 :
    detTriple4 (8 : Fin 10) = detTriple4Value (8 : Fin 10) := by
  norm_num [detTriple4, detTriple4Value, detPair4Value, CCell2_1,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem detTriple4_apply_9 :
    detTriple4 (9 : Fin 10) = detTriple4Value (9 : Fin 10) := by
  norm_num [detTriple4, detTriple4Value, detPair4Value, CCell2_1,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem detTriple4_eq : detTriple4 = detTriple4Value := by
  funext n
  fin_cases n
  · exact detTriple4_apply_0
  · exact detTriple4_apply_1
  · exact detTriple4_apply_2
  · exact detTriple4_apply_3
  · exact detTriple4_apply_4
  · exact detTriple4_apply_5
  · exact detTriple4_apply_6
  · exact detTriple4_apply_7
  · exact detTriple4_apply_8
  · exact detTriple4_apply_9

theorem detTriple4_actual :
    mul (mul CCell0_2 CCell1_0) CCell2_1 = detTriple4Value := by
  calc
    _ = mul detPair4Value CCell2_1 :=
      congrArg (fun v => mul v CCell2_1) detPair4_eq
    _ = _ := detTriple4_eq

theorem eval_detTriple4 :
    eval CCell0_2 * eval CCell1_0 * eval CCell2_1 =
      eval detTriple4Value := by
  calc
    _ = eval (mul (mul CCell0_2 CCell1_0) CCell2_1) := by
      simp only [eval_mul]
    _ = _ := congrArg eval detTriple4_actual

def detPair5 : Vec := mul CCell0_2 CCell1_1

def detPair5Value (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (21 / 2 : ℚ)
  | 1 => 0
  | 2 => (-15 / 2 : ℚ)
  | 3 => 5
  | 4 => 9
  | 5 => (-9 / 2 : ℚ)
  | 6 => (-9 / 2 : ℚ)
  | 7 => 9
  | 8 => 5
  | 9 => (-15 / 2 : ℚ)
  | _ => 0

theorem detPair5_apply_0 :
    detPair5 (0 : Fin 10) = detPair5Value (0 : Fin 10) := by
  norm_num [detPair5, detPair5Value, CCell0_2, CCell1_1,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem detPair5_apply_1 :
    detPair5 (1 : Fin 10) = detPair5Value (1 : Fin 10) := by
  norm_num [detPair5, detPair5Value, CCell0_2, CCell1_1,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem detPair5_apply_2 :
    detPair5 (2 : Fin 10) = detPair5Value (2 : Fin 10) := by
  norm_num [detPair5, detPair5Value, CCell0_2, CCell1_1,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem detPair5_apply_3 :
    detPair5 (3 : Fin 10) = detPair5Value (3 : Fin 10) := by
  norm_num [detPair5, detPair5Value, CCell0_2, CCell1_1,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem detPair5_apply_4 :
    detPair5 (4 : Fin 10) = detPair5Value (4 : Fin 10) := by
  norm_num [detPair5, detPair5Value, CCell0_2, CCell1_1,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem detPair5_apply_5 :
    detPair5 (5 : Fin 10) = detPair5Value (5 : Fin 10) := by
  norm_num [detPair5, detPair5Value, CCell0_2, CCell1_1,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem detPair5_apply_6 :
    detPair5 (6 : Fin 10) = detPair5Value (6 : Fin 10) := by
  norm_num [detPair5, detPair5Value, CCell0_2, CCell1_1,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem detPair5_apply_7 :
    detPair5 (7 : Fin 10) = detPair5Value (7 : Fin 10) := by
  norm_num [detPair5, detPair5Value, CCell0_2, CCell1_1,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem detPair5_apply_8 :
    detPair5 (8 : Fin 10) = detPair5Value (8 : Fin 10) := by
  norm_num [detPair5, detPair5Value, CCell0_2, CCell1_1,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem detPair5_apply_9 :
    detPair5 (9 : Fin 10) = detPair5Value (9 : Fin 10) := by
  norm_num [detPair5, detPair5Value, CCell0_2, CCell1_1,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem detPair5_eq : detPair5 = detPair5Value := by
  funext n
  fin_cases n
  · exact detPair5_apply_0
  · exact detPair5_apply_1
  · exact detPair5_apply_2
  · exact detPair5_apply_3
  · exact detPair5_apply_4
  · exact detPair5_apply_5
  · exact detPair5_apply_6
  · exact detPair5_apply_7
  · exact detPair5_apply_8
  · exact detPair5_apply_9

def detTriple5 : Vec := mul detPair5Value CCell2_0

def detTriple5Value (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (63 / 4 : ℚ)
  | 1 => 0
  | 2 => (-23 / 2 : ℚ)
  | 3 => 7
  | 4 => 13
  | 5 => -7
  | 6 => -7
  | 7 => 13
  | 8 => 7
  | 9 => (-23 / 2 : ℚ)
  | _ => 0

theorem detTriple5_apply_0 :
    detTriple5 (0 : Fin 10) = detTriple5Value (0 : Fin 10) := by
  norm_num [detTriple5, detTriple5Value, detPair5Value, CCell2_0,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem detTriple5_apply_1 :
    detTriple5 (1 : Fin 10) = detTriple5Value (1 : Fin 10) := by
  norm_num [detTriple5, detTriple5Value, detPair5Value, CCell2_0,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem detTriple5_apply_2 :
    detTriple5 (2 : Fin 10) = detTriple5Value (2 : Fin 10) := by
  norm_num [detTriple5, detTriple5Value, detPair5Value, CCell2_0,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem detTriple5_apply_3 :
    detTriple5 (3 : Fin 10) = detTriple5Value (3 : Fin 10) := by
  norm_num [detTriple5, detTriple5Value, detPair5Value, CCell2_0,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem detTriple5_apply_4 :
    detTriple5 (4 : Fin 10) = detTriple5Value (4 : Fin 10) := by
  norm_num [detTriple5, detTriple5Value, detPair5Value, CCell2_0,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem detTriple5_apply_5 :
    detTriple5 (5 : Fin 10) = detTriple5Value (5 : Fin 10) := by
  norm_num [detTriple5, detTriple5Value, detPair5Value, CCell2_0,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem detTriple5_apply_6 :
    detTriple5 (6 : Fin 10) = detTriple5Value (6 : Fin 10) := by
  norm_num [detTriple5, detTriple5Value, detPair5Value, CCell2_0,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem detTriple5_apply_7 :
    detTriple5 (7 : Fin 10) = detTriple5Value (7 : Fin 10) := by
  norm_num [detTriple5, detTriple5Value, detPair5Value, CCell2_0,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem detTriple5_apply_8 :
    detTriple5 (8 : Fin 10) = detTriple5Value (8 : Fin 10) := by
  norm_num [detTriple5, detTriple5Value, detPair5Value, CCell2_0,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem detTriple5_apply_9 :
    detTriple5 (9 : Fin 10) = detTriple5Value (9 : Fin 10) := by
  norm_num [detTriple5, detTriple5Value, detPair5Value, CCell2_0,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem detTriple5_eq : detTriple5 = detTriple5Value := by
  funext n
  fin_cases n
  · exact detTriple5_apply_0
  · exact detTriple5_apply_1
  · exact detTriple5_apply_2
  · exact detTriple5_apply_3
  · exact detTriple5_apply_4
  · exact detTriple5_apply_5
  · exact detTriple5_apply_6
  · exact detTriple5_apply_7
  · exact detTriple5_apply_8
  · exact detTriple5_apply_9

theorem detTriple5_actual :
    mul (mul CCell0_2 CCell1_1) CCell2_0 = detTriple5Value := by
  calc
    _ = mul detPair5Value CCell2_0 :=
      congrArg (fun v => mul v CCell2_0) detPair5_eq
    _ = _ := detTriple5_eq

theorem eval_detTriple5 :
    eval CCell0_2 * eval CCell1_1 * eval CCell2_0 =
      eval detTriple5Value := by
  calc
    _ = eval (mul (mul CCell0_2 CCell1_1) CCell2_0) := by
      simp only [eval_mul]
    _ = _ := congrArg eval detTriple5_actual

def determinantVec : Vec :=
  detTriple0Value - detTriple1Value - detTriple2Value + detTriple3Value + detTriple4Value - detTriple5Value

theorem determinantVec_apply_0 :
    determinantVec (0 : Fin 10) = deltaVec (0 : Fin 10) := by
  norm_num [determinantVec, deltaVec, detTriple0Value, detTriple1Value, detTriple2Value, detTriple3Value, detTriple4Value, detTriple5Value]

theorem determinantVec_apply_1 :
    determinantVec (1 : Fin 10) = deltaVec (1 : Fin 10) := by
  norm_num [determinantVec, deltaVec, detTriple0Value, detTriple1Value, detTriple2Value, detTriple3Value, detTriple4Value, detTriple5Value]

theorem determinantVec_apply_2 :
    determinantVec (2 : Fin 10) = deltaVec (2 : Fin 10) := by
  norm_num [determinantVec, deltaVec, detTriple0Value, detTriple1Value, detTriple2Value, detTriple3Value, detTriple4Value, detTriple5Value]

theorem determinantVec_apply_3 :
    determinantVec (3 : Fin 10) = deltaVec (3 : Fin 10) := by
  norm_num [determinantVec, deltaVec, detTriple0Value, detTriple1Value, detTriple2Value, detTriple3Value, detTriple4Value, detTriple5Value]

theorem determinantVec_apply_4 :
    determinantVec (4 : Fin 10) = deltaVec (4 : Fin 10) := by
  norm_num [determinantVec, deltaVec, detTriple0Value, detTriple1Value, detTriple2Value, detTriple3Value, detTriple4Value, detTriple5Value]

theorem determinantVec_apply_5 :
    determinantVec (5 : Fin 10) = deltaVec (5 : Fin 10) := by
  norm_num [determinantVec, deltaVec, detTriple0Value, detTriple1Value, detTriple2Value, detTriple3Value, detTriple4Value, detTriple5Value]

theorem determinantVec_apply_6 :
    determinantVec (6 : Fin 10) = deltaVec (6 : Fin 10) := by
  norm_num [determinantVec, deltaVec, detTriple0Value, detTriple1Value, detTriple2Value, detTriple3Value, detTriple4Value, detTriple5Value]

theorem determinantVec_apply_7 :
    determinantVec (7 : Fin 10) = deltaVec (7 : Fin 10) := by
  norm_num [determinantVec, deltaVec, detTriple0Value, detTriple1Value, detTriple2Value, detTriple3Value, detTriple4Value, detTriple5Value]

theorem determinantVec_apply_8 :
    determinantVec (8 : Fin 10) = deltaVec (8 : Fin 10) := by
  norm_num [determinantVec, deltaVec, detTriple0Value, detTriple1Value, detTriple2Value, detTriple3Value, detTriple4Value, detTriple5Value]

theorem determinantVec_apply_9 :
    determinantVec (9 : Fin 10) = deltaVec (9 : Fin 10) := by
  norm_num [determinantVec, deltaVec, detTriple0Value, detTriple1Value, detTriple2Value, detTriple3Value, detTriple4Value, detTriple5Value]

theorem determinantVec_eq : determinantVec = deltaVec := by
  funext n
  fin_cases n
  · exact determinantVec_apply_0
  · exact determinantVec_apply_1
  · exact determinantVec_apply_2
  · exact determinantVec_apply_3
  · exact determinantVec_apply_4
  · exact determinantVec_apply_5
  · exact determinantVec_apply_6
  · exact determinantVec_apply_7
  · exact determinantVec_apply_8
  · exact determinantVec_apply_9

theorem eval_determinant :
    eval CCell0_0 * eval CCell1_1 * eval CCell2_2 - eval CCell0_0 * eval CCell1_2 * eval CCell2_1 - eval CCell0_1 * eval CCell1_0 * eval CCell2_2 + eval CCell0_1 * eval CCell1_2 * eval CCell2_0 + eval CCell0_2 * eval CCell1_0 * eval CCell2_1 - eval CCell0_2 * eval CCell1_1 * eval CCell2_0 =
      eval deltaVec := by
  calc
    _ = eval detTriple0Value - eval detTriple1Value - eval detTriple2Value + eval detTriple3Value + eval detTriple4Value - eval detTriple5Value := by
      rw [eval_detTriple0, eval_detTriple1, eval_detTriple2, eval_detTriple3, eval_detTriple4, eval_detTriple5]
    _ = eval determinantVec := by
      simp only [determinantVec, eval_add, eval_sub]
    _ = eval deltaVec := congrArg eval determinantVec_eq

theorem det_evalMatrix_CVec : (evalMatrix CVec).det = eval deltaVec := by
  rw [Matrix.det_fin_three]
  change eval CCell0_0 * eval CCell1_1 * eval CCell2_2 -
      eval CCell0_0 * eval CCell1_2 * eval CCell2_1 -
      eval CCell0_1 * eval CCell1_0 * eval CCell2_2 +
      eval CCell0_1 * eval CCell1_2 * eval CCell2_0 +
      eval CCell0_2 * eval CCell1_0 * eval CCell2_1 -
      eval CCell0_2 * eval CCell1_1 * eval CCell2_0 = _
  exact eval_determinant

public theorem det_ne_zero : (evalMatrix CVec).det ≠ 0 := by
  rw [det_evalMatrix_CVec]
  exact delta_ne_zero

end V14Formalization.D12PiecePPDeterminant
