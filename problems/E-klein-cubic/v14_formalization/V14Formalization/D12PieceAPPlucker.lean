/- Normalized Plucker coefficient for the AP character line. -/
module

public import V14Formalization.D12MatrixCertificate
public import V14Formalization.D12PieceAmbientVec
public import V14Formalization.D12PieceAPData

noncomputable section
open Matrix
namespace V14Formalization.D12PieceAPPlucker
open D12Certificate D12CyclotomicVec D12PieceAmbientVec D12PieceAPData
open D12PolynomialData D12PolynomialEvaluation
def payloadSha256 : String := "76c6196f29afe1a8398af99502447f48ebeed4bcb3805fc5dbec693940bc04b0"

@[expose] public def BKVec : Matrix (Fin 15) (Fin 1) Vec := matrixMul BVec KVec

theorem mul_constVec_left (r : ℚ) (v : Vec) :
    mul (constVec r) v = r • v := by
  apply eval_injective
  rw [eval_mul, eval_constVec, eval_smul]

def BKCoord0 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 1
  | 1 => 0
  | 2 => 0
  | 3 => 0
  | 4 => 0
  | 5 => 0
  | 6 => 0
  | 7 => 0
  | 8 => 0
  | 9 => 0
  | _ => 0

theorem BKVec_0 : BKVec (0 : Fin 15) 0 = BKCoord0 := by
  funext n
  fin_cases n <;>
    norm_num [BKVec, matrixMul, BVec, BRow0, BCell0_0, BCell0_1, BCell0_2, BCell0_3, BCell0_4, BCell0_5, BCell0_6, BCell0_7, BCell0_8, BCell0_9,
      KVec, KRow0, KRow1, KRow2, KRow3, KRow4, KRow5, KRow6, KRow7, KRow8, KRow9, KCell0_0, KCell1_0, KCell2_0, KCell3_0, KCell4_0, KCell5_0, KCell6_0, KCell7_0, KCell8_0, KCell9_0, BKCoord0,
      mul_constVec_left, Fin.sum_univ_succ]

def BKCoord9 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (1 / 2 : ℚ)
  | 1 => 0
  | 2 => (-1 / 2 : ℚ)
  | 3 => 0
  | 4 => (-1 / 2 : ℚ)
  | 5 => (1 / 2 : ℚ)
  | 6 => 0
  | 7 => 0
  | 8 => 0
  | 9 => (-1 / 2 : ℚ)
  | _ => 0

theorem BKVec_9 : BKVec (9 : Fin 15) 0 = BKCoord9 := by
  funext n
  fin_cases n <;>
    norm_num [BKVec, matrixMul, BVec, BRow9, BCell9_0, BCell9_1, BCell9_2, BCell9_3, BCell9_4, BCell9_5, BCell9_6, BCell9_7, BCell9_8, BCell9_9,
      KVec, KRow0, KRow1, KRow2, KRow3, KRow4, KRow5, KRow6, KRow7, KRow8, KRow9, KCell0_0, KCell1_0, KCell2_0, KCell3_0, KCell4_0, KCell5_0, KCell6_0, KCell7_0, KCell8_0, KCell9_0, BKCoord9,
      mul_constVec_left, Fin.sum_univ_succ]

def BKCoord1 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => -1
  | 2 => -1
  | 3 => -1
  | 4 => -1
  | 5 => 0
  | 6 => 0
  | 7 => -1
  | 8 => -1
  | 9 => -1
  | _ => 0

theorem BKVec_1 : BKVec (1 : Fin 15) 0 = BKCoord1 := by
  funext n
  fin_cases n <;>
    norm_num [BKVec, matrixMul, BVec, BRow1, BCell1_0, BCell1_1, BCell1_2, BCell1_3, BCell1_4, BCell1_5, BCell1_6, BCell1_7, BCell1_8, BCell1_9,
      KVec, KRow0, KRow1, KRow2, KRow3, KRow4, KRow5, KRow6, KRow7, KRow8, KRow9, KCell0_0, KCell1_0, KCell2_0, KCell3_0, KCell4_0, KCell5_0, KCell6_0, KCell7_0, KCell8_0, KCell9_0, BKCoord1,
      mul_constVec_left, Fin.sum_univ_succ]

def BKCoord6 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (1 / 2 : ℚ)
  | 1 => 0
  | 2 => 0
  | 3 => (1 / 2 : ℚ)
  | 4 => 0
  | 5 => (1 / 2 : ℚ)
  | 6 => (1 / 2 : ℚ)
  | 7 => (1 / 2 : ℚ)
  | 8 => 0
  | 9 => 0
  | _ => 0

theorem BKVec_6 : BKVec (6 : Fin 15) 0 = BKCoord6 := by
  funext n
  fin_cases n <;>
    norm_num [BKVec, matrixMul, BVec, BRow6, BCell6_0, BCell6_1, BCell6_2, BCell6_3, BCell6_4, BCell6_5, BCell6_6, BCell6_7, BCell6_8, BCell6_9,
      KVec, KRow0, KRow1, KRow2, KRow3, KRow4, KRow5, KRow6, KRow7, KRow8, KRow9, KCell0_0, KCell1_0, KCell2_0, KCell3_0, KCell4_0, KCell5_0, KCell6_0, KCell7_0, KCell8_0, KCell9_0, BKCoord6,
      mul_constVec_left, Fin.sum_univ_succ]

def BKCoord2 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => -1
  | 1 => 0
  | 2 => 0
  | 3 => 0
  | 4 => 0
  | 5 => 0
  | 6 => -1
  | 7 => 0
  | 8 => 0
  | 9 => 0
  | _ => 0

theorem BKVec_2 : BKVec (2 : Fin 15) 0 = BKCoord2 := by
  funext n
  fin_cases n <;>
    norm_num [BKVec, matrixMul, BVec, BRow2, BCell2_0, BCell2_1, BCell2_2, BCell2_3, BCell2_4, BCell2_5, BCell2_6, BCell2_7, BCell2_8, BCell2_9,
      KVec, KRow0, KRow1, KRow2, KRow3, KRow4, KRow5, KRow6, KRow7, KRow8, KRow9, KCell0_0, KCell1_0, KCell2_0, KCell3_0, KCell4_0, KCell5_0, KCell6_0, KCell7_0, KCell8_0, KCell9_0, BKCoord2,
      mul_constVec_left, Fin.sum_univ_succ]

def BKCoord5 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => (-1 / 2 : ℚ)
  | 2 => (-1 / 2 : ℚ)
  | 3 => 0
  | 4 => 0
  | 5 => 0
  | 6 => (-1 / 2 : ℚ)
  | 7 => (-1 / 2 : ℚ)
  | 8 => (-1 / 2 : ℚ)
  | 9 => 0
  | _ => 0

theorem BKVec_5 : BKVec (5 : Fin 15) 0 = BKCoord5 := by
  funext n
  fin_cases n <;>
    norm_num [BKVec, matrixMul, BVec, BRow5, BCell5_0, BCell5_1, BCell5_2, BCell5_3, BCell5_4, BCell5_5, BCell5_6, BCell5_7, BCell5_8, BCell5_9,
      KVec, KRow0, KRow1, KRow2, KRow3, KRow4, KRow5, KRow6, KRow7, KRow8, KRow9, KCell0_0, KCell1_0, KCell2_0, KCell3_0, KCell4_0, KCell5_0, KCell6_0, KCell7_0, KCell8_0, KCell9_0, BKCoord5,
      mul_constVec_left, Fin.sum_univ_succ]

@[expose] public def deltaVec (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => 1
  | 2 => (1 / 2 : ℚ)
  | 3 => 1
  | 4 => 0
  | 5 => 0
  | 6 => 0
  | 7 => (3 / 2 : ℚ)
  | 8 => (3 / 2 : ℚ)
  | 9 => 0
  | _ => 0

def coefficientVec : Vec :=
  mul BKCoord0 BKCoord9 - mul BKCoord1 BKCoord6 + mul BKCoord2 BKCoord5

theorem coefficientVec_apply_0 :
    coefficientVec (0 : Fin 10) = deltaVec (0 : Fin 10) := by
  norm_num [coefficientVec, deltaVec, BKCoord0, BKCoord9, BKCoord1, BKCoord6,
    BKCoord2, BKCoord5, mul, conv, coeffAt, Fin.sum_univ_succ]

theorem coefficientVec_apply_1 :
    coefficientVec (1 : Fin 10) = deltaVec (1 : Fin 10) := by
  norm_num [coefficientVec, deltaVec, BKCoord0, BKCoord9, BKCoord1, BKCoord6,
    BKCoord2, BKCoord5, mul, conv, coeffAt, Fin.sum_univ_succ]

theorem coefficientVec_apply_2 :
    coefficientVec (2 : Fin 10) = deltaVec (2 : Fin 10) := by
  norm_num [coefficientVec, deltaVec, BKCoord0, BKCoord9, BKCoord1, BKCoord6,
    BKCoord2, BKCoord5, mul, conv, coeffAt, Fin.sum_univ_succ]

theorem coefficientVec_apply_3 :
    coefficientVec (3 : Fin 10) = deltaVec (3 : Fin 10) := by
  norm_num [coefficientVec, deltaVec, BKCoord0, BKCoord9, BKCoord1, BKCoord6,
    BKCoord2, BKCoord5, mul, conv, coeffAt, Fin.sum_univ_succ]

theorem coefficientVec_apply_4 :
    coefficientVec (4 : Fin 10) = deltaVec (4 : Fin 10) := by
  norm_num [coefficientVec, deltaVec, BKCoord0, BKCoord9, BKCoord1, BKCoord6,
    BKCoord2, BKCoord5, mul, conv, coeffAt, Fin.sum_univ_succ]

theorem coefficientVec_apply_5 :
    coefficientVec (5 : Fin 10) = deltaVec (5 : Fin 10) := by
  norm_num [coefficientVec, deltaVec, BKCoord0, BKCoord9, BKCoord1, BKCoord6,
    BKCoord2, BKCoord5, mul, conv, coeffAt, Fin.sum_univ_succ]

theorem coefficientVec_apply_6 :
    coefficientVec (6 : Fin 10) = deltaVec (6 : Fin 10) := by
  norm_num [coefficientVec, deltaVec, BKCoord0, BKCoord9, BKCoord1, BKCoord6,
    BKCoord2, BKCoord5, mul, conv, coeffAt, Fin.sum_univ_succ]

theorem coefficientVec_apply_7 :
    coefficientVec (7 : Fin 10) = deltaVec (7 : Fin 10) := by
  norm_num [coefficientVec, deltaVec, BKCoord0, BKCoord9, BKCoord1, BKCoord6,
    BKCoord2, BKCoord5, mul, conv, coeffAt, Fin.sum_univ_succ]

theorem coefficientVec_apply_8 :
    coefficientVec (8 : Fin 10) = deltaVec (8 : Fin 10) := by
  norm_num [coefficientVec, deltaVec, BKCoord0, BKCoord9, BKCoord1, BKCoord6,
    BKCoord2, BKCoord5, mul, conv, coeffAt, Fin.sum_univ_succ]

theorem coefficientVec_apply_9 :
    coefficientVec (9 : Fin 10) = deltaVec (9 : Fin 10) := by
  norm_num [coefficientVec, deltaVec, BKCoord0, BKCoord9, BKCoord1, BKCoord6,
    BKCoord2, BKCoord5, mul, conv, coeffAt, Fin.sum_univ_succ]

theorem coefficientVec_eq : coefficientVec = deltaVec := by
  funext n
  fin_cases n
  · exact coefficientVec_apply_0
  · exact coefficientVec_apply_1
  · exact coefficientVec_apply_2
  · exact coefficientVec_apply_3
  · exact coefficientVec_apply_4
  · exact coefficientVec_apply_5
  · exact coefficientVec_apply_6
  · exact coefficientVec_apply_7
  · exact coefficientVec_apply_8
  · exact coefficientVec_apply_9

theorem eval_coefficient :
    eval BKCoord0 * eval BKCoord9 - eval BKCoord1 * eval BKCoord6 +
        eval BKCoord2 * eval BKCoord5 = eval deltaVec := by
  calc
    _ = eval coefficientVec := by
      simp only [coefficientVec, eval_add, eval_sub, eval_mul]
    _ = eval deltaVec := congrArg eval coefficientVec_eq

public theorem evalMatrix_BKVec :
    evalMatrix BKVec = evalMatrixK B_poly * evalMatrix KVec := by
  change evalMatrix (matrixMul BVec KVec) = _
  rw [evalMatrix_mul, evalMatrix_BVec]

theorem mulVec_fin1 (M : Matrix (Fin 15) (Fin 1) WeilRep.K)
    (t : Fin 1 → WeilRep.K) (i : Fin 15) :
    M.mulVec t i = M i 0 * t 0 := by
  change (∑ j : Fin 1, M i j * t j) = _
  rw [Fin.sum_univ_succ]
  simp

public theorem plucker_coefficient (t : Fin 1 → WeilRep.K) :
    pluckerValue ((evalMatrix BKVec).mulVec t) 0 =
      eval deltaVec * (t 0 * t 0) := by
  change ((evalMatrix BKVec).mulVec t) 0 * ((evalMatrix BKVec).mulVec t) 9 -
      ((evalMatrix BKVec).mulVec t) 1 * ((evalMatrix BKVec).mulVec t) 6 +
      ((evalMatrix BKVec).mulVec t) 2 * ((evalMatrix BKVec).mulVec t) 5 = _
  simp_rw [mulVec_fin1]
  change (eval (BKVec 0 0) * t 0) * (eval (BKVec 9 0) * t 0) -
      (eval (BKVec 1 0) * t 0) * (eval (BKVec 6 0) * t 0) +
      (eval (BKVec 2 0) * t 0) * (eval (BKVec 5 0) * t 0) = _
  rw [BKVec_0, BKVec_9, BKVec_1, BKVec_6, BKVec_2, BKVec_5]
  rw [← eval_coefficient]
  ring

public theorem delta_ne_zero : eval deltaVec ≠ 0 := by
  intro h
  have hv : deltaVec = 0 := (eval_eq_zero_iff deltaVec).mp h
  have hz := congrFun hv (1 : Fin 10)
  norm_num [deltaVec] at hz

end V14Formalization.D12PieceAPPlucker
