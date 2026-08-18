/- Normalized Plucker data for the PP character plane. -/
module

public import V14Formalization.D12MatrixCertificate
public import V14Formalization.D12PieceAmbientVec
public import V14Formalization.D12PiecePPData

noncomputable section
open Matrix
namespace V14Formalization.D12PiecePPPluckerBase
open D12Certificate D12CyclotomicVec D12PieceAmbientVec D12PiecePPData
open D12PolynomialData D12PolynomialEvaluation
def payloadSha256 : String := "76c6196f29afe1a8398af99502447f48ebeed4bcb3805fc5dbec693940bc04b0"

@[expose] public def BKVec : Matrix (Fin 15) (Fin 2) Vec := matrixMul BVec KVec

theorem mul_constVec_left (r : ℚ) (v : Vec) :
    mul (constVec r) v = r • v := by
  apply eval_injective
  rw [eval_mul, eval_constVec, eval_smul]

@[expose] public def BKCoord0_0 (i : Fin 10) : ℚ :=
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

public theorem BKVec_0_0 :
    BKVec (0 : Fin 15) (0 : Fin 2) = BKCoord0_0 := by
  refine vec_ext ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ <;>
    norm_num [BKVec, matrixMul, BVec, BRow0, BCell0_0, BCell0_1, BCell0_2, BCell0_3, BCell0_4, BCell0_5, BCell0_6, BCell0_7, BCell0_8, BCell0_9,
      KVec_col0, KVec_col1, KCell0_0_def, KCell0_1_def, KCell1_0_def, KCell1_1_def, KCell2_0_def, KCell2_1_def, KCell3_0_def, KCell3_1_def, KCell4_0_def, KCell4_1_def, KCell5_0_def, KCell5_1_def, KCell6_0_def, KCell6_1_def, KCell7_0_def, KCell7_1_def, KCell8_0_def, KCell8_1_def, KCell9_0_def, KCell9_1_def, BKCoord0_0,
      mul_constVec_left, Fin.sum_univ_succ]

@[expose] public def BKCoord0_1 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
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

public theorem BKVec_0_1 :
    BKVec (0 : Fin 15) (1 : Fin 2) = BKCoord0_1 := by
  refine vec_ext ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ <;>
    norm_num [BKVec, matrixMul, BVec, BRow0, BCell0_0, BCell0_1, BCell0_2, BCell0_3, BCell0_4, BCell0_5, BCell0_6, BCell0_7, BCell0_8, BCell0_9,
      KVec_col0, KVec_col1, KCell0_0_def, KCell0_1_def, KCell1_0_def, KCell1_1_def, KCell2_0_def, KCell2_1_def, KCell3_0_def, KCell3_1_def, KCell4_0_def, KCell4_1_def, KCell5_0_def, KCell5_1_def, KCell6_0_def, KCell6_1_def, KCell7_0_def, KCell7_1_def, KCell8_0_def, KCell8_1_def, KCell9_0_def, KCell9_1_def, BKCoord0_1,
      mul_constVec_left, Fin.sum_univ_succ]

@[expose] public def BKCoord1_0 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
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

public theorem BKVec_1_0 :
    BKVec (1 : Fin 15) (0 : Fin 2) = BKCoord1_0 := by
  refine vec_ext ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ <;>
    norm_num [BKVec, matrixMul, BVec, BRow1, BCell1_0, BCell1_1, BCell1_2, BCell1_3, BCell1_4, BCell1_5, BCell1_6, BCell1_7, BCell1_8, BCell1_9,
      KVec_col0, KVec_col1, KCell0_0_def, KCell0_1_def, KCell1_0_def, KCell1_1_def, KCell2_0_def, KCell2_1_def, KCell3_0_def, KCell3_1_def, KCell4_0_def, KCell4_1_def, KCell5_0_def, KCell5_1_def, KCell6_0_def, KCell6_1_def, KCell7_0_def, KCell7_1_def, KCell8_0_def, KCell8_1_def, KCell9_0_def, KCell9_1_def, BKCoord1_0,
      mul_constVec_left, Fin.sum_univ_succ]

@[expose] public def BKCoord1_1 (i : Fin 10) : ℚ :=
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

public theorem BKVec_1_1 :
    BKVec (1 : Fin 15) (1 : Fin 2) = BKCoord1_1 := by
  refine vec_ext ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ <;>
    norm_num [BKVec, matrixMul, BVec, BRow1, BCell1_0, BCell1_1, BCell1_2, BCell1_3, BCell1_4, BCell1_5, BCell1_6, BCell1_7, BCell1_8, BCell1_9,
      KVec_col0, KVec_col1, KCell0_0_def, KCell0_1_def, KCell1_0_def, KCell1_1_def, KCell2_0_def, KCell2_1_def, KCell3_0_def, KCell3_1_def, KCell4_0_def, KCell4_1_def, KCell5_0_def, KCell5_1_def, KCell6_0_def, KCell6_1_def, KCell7_0_def, KCell7_1_def, KCell8_0_def, KCell8_1_def, KCell9_0_def, KCell9_1_def, BKCoord1_1,
      mul_constVec_left, Fin.sum_univ_succ]

@[expose] public def BKCoord2_0 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => 0
  | 2 => 0
  | 3 => 0
  | 4 => 0
  | 5 => 1
  | 6 => 1
  | 7 => 0
  | 8 => 0
  | 9 => 0
  | _ => 0

public theorem BKVec_2_0 :
    BKVec (2 : Fin 15) (0 : Fin 2) = BKCoord2_0 := by
  refine vec_ext ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ <;>
    norm_num [BKVec, matrixMul, BVec, BRow2, BCell2_0, BCell2_1, BCell2_2, BCell2_3, BCell2_4, BCell2_5, BCell2_6, BCell2_7, BCell2_8, BCell2_9,
      KVec_col0, KVec_col1, KCell0_0_def, KCell0_1_def, KCell1_0_def, KCell1_1_def, KCell2_0_def, KCell2_1_def, KCell3_0_def, KCell3_1_def, KCell4_0_def, KCell4_1_def, KCell5_0_def, KCell5_1_def, KCell6_0_def, KCell6_1_def, KCell7_0_def, KCell7_1_def, KCell8_0_def, KCell8_1_def, KCell9_0_def, KCell9_1_def, BKCoord2_0,
      mul_constVec_left, Fin.sum_univ_succ]

@[expose] public def BKCoord2_1 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => -1
  | 1 => 0
  | 2 => 1
  | 3 => 0
  | 4 => -1
  | 5 => 0
  | 6 => 0
  | 7 => -1
  | 8 => 0
  | 9 => 1
  | _ => 0

public theorem BKVec_2_1 :
    BKVec (2 : Fin 15) (1 : Fin 2) = BKCoord2_1 := by
  refine vec_ext ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ <;>
    norm_num [BKVec, matrixMul, BVec, BRow2, BCell2_0, BCell2_1, BCell2_2, BCell2_3, BCell2_4, BCell2_5, BCell2_6, BCell2_7, BCell2_8, BCell2_9,
      KVec_col0, KVec_col1, KCell0_0_def, KCell0_1_def, KCell1_0_def, KCell1_1_def, KCell2_0_def, KCell2_1_def, KCell3_0_def, KCell3_1_def, KCell4_0_def, KCell4_1_def, KCell5_0_def, KCell5_1_def, KCell6_0_def, KCell6_1_def, KCell7_0_def, KCell7_1_def, KCell8_0_def, KCell8_1_def, KCell9_0_def, KCell9_1_def, BKCoord2_1,
      mul_constVec_left, Fin.sum_univ_succ]

@[expose] public def BKCoord3_0 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 1
  | 1 => 0
  | 2 => 0
  | 3 => 1
  | 4 => 1
  | 5 => 1
  | 6 => 1
  | 7 => 1
  | 8 => 1
  | 9 => 0
  | _ => 0

public theorem BKVec_3_0 :
    BKVec (3 : Fin 15) (0 : Fin 2) = BKCoord3_0 := by
  refine vec_ext ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ <;>
    norm_num [BKVec, matrixMul, BVec, BRow3, BCell3_0, BCell3_1, BCell3_2, BCell3_3, BCell3_4, BCell3_5, BCell3_6, BCell3_7, BCell3_8, BCell3_9,
      KVec_col0, KVec_col1, KCell0_0_def, KCell0_1_def, KCell1_0_def, KCell1_1_def, KCell2_0_def, KCell2_1_def, KCell3_0_def, KCell3_1_def, KCell4_0_def, KCell4_1_def, KCell5_0_def, KCell5_1_def, KCell6_0_def, KCell6_1_def, KCell7_0_def, KCell7_1_def, KCell8_0_def, KCell8_1_def, KCell9_0_def, KCell9_1_def, BKCoord3_0,
      mul_constVec_left, Fin.sum_univ_succ]

@[expose] public def BKCoord3_1 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 1
  | 1 => 0
  | 2 => 0
  | 3 => 1
  | 4 => 1
  | 5 => 0
  | 6 => 0
  | 7 => 1
  | 8 => 1
  | 9 => 0
  | _ => 0

public theorem BKVec_3_1 :
    BKVec (3 : Fin 15) (1 : Fin 2) = BKCoord3_1 := by
  refine vec_ext ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ <;>
    norm_num [BKVec, matrixMul, BVec, BRow3, BCell3_0, BCell3_1, BCell3_2, BCell3_3, BCell3_4, BCell3_5, BCell3_6, BCell3_7, BCell3_8, BCell3_9,
      KVec_col0, KVec_col1, KCell0_0_def, KCell0_1_def, KCell1_0_def, KCell1_1_def, KCell2_0_def, KCell2_1_def, KCell3_0_def, KCell3_1_def, KCell4_0_def, KCell4_1_def, KCell5_0_def, KCell5_1_def, KCell6_0_def, KCell6_1_def, KCell7_0_def, KCell7_1_def, KCell8_0_def, KCell8_1_def, KCell9_0_def, KCell9_1_def, BKCoord3_1,
      mul_constVec_left, Fin.sum_univ_succ]

@[expose] public def BKCoord4_0 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => 0
  | 2 => 0
  | 3 => 1
  | 4 => 1
  | 5 => 0
  | 6 => 0
  | 7 => 1
  | 8 => 1
  | 9 => 0
  | _ => 0

public theorem BKVec_4_0 :
    BKVec (4 : Fin 15) (0 : Fin 2) = BKCoord4_0 := by
  refine vec_ext ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ <;>
    norm_num [BKVec, matrixMul, BVec, BRow4, BCell4_0, BCell4_1, BCell4_2, BCell4_3, BCell4_4, BCell4_5, BCell4_6, BCell4_7, BCell4_8, BCell4_9,
      KVec_col0, KVec_col1, KCell0_0_def, KCell0_1_def, KCell1_0_def, KCell1_1_def, KCell2_0_def, KCell2_1_def, KCell3_0_def, KCell3_1_def, KCell4_0_def, KCell4_1_def, KCell5_0_def, KCell5_1_def, KCell6_0_def, KCell6_1_def, KCell7_0_def, KCell7_1_def, KCell8_0_def, KCell8_1_def, KCell9_0_def, KCell9_1_def, BKCoord4_0,
      mul_constVec_left, Fin.sum_univ_succ]

@[expose] public def BKCoord4_1 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 1
  | 1 => 0
  | 2 => -1
  | 3 => -1
  | 4 => 0
  | 5 => 0
  | 6 => 0
  | 7 => 0
  | 8 => -1
  | 9 => -1
  | _ => 0

public theorem BKVec_4_1 :
    BKVec (4 : Fin 15) (1 : Fin 2) = BKCoord4_1 := by
  refine vec_ext ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ <;>
    norm_num [BKVec, matrixMul, BVec, BRow4, BCell4_0, BCell4_1, BCell4_2, BCell4_3, BCell4_4, BCell4_5, BCell4_6, BCell4_7, BCell4_8, BCell4_9,
      KVec_col0, KVec_col1, KCell0_0_def, KCell0_1_def, KCell1_0_def, KCell1_1_def, KCell2_0_def, KCell2_1_def, KCell3_0_def, KCell3_1_def, KCell4_0_def, KCell4_1_def, KCell5_0_def, KCell5_1_def, KCell6_0_def, KCell6_1_def, KCell7_0_def, KCell7_1_def, KCell8_0_def, KCell8_1_def, KCell9_0_def, KCell9_1_def, BKCoord4_1,
      mul_constVec_left, Fin.sum_univ_succ]

@[expose] public def BKCoord5_0 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (-1 / 2 : ℚ)
  | 1 => 0
  | 2 => 0
  | 3 => (-1 / 2 : ℚ)
  | 4 => (-1 / 2 : ℚ)
  | 5 => (-1 / 2 : ℚ)
  | 6 => (-1 / 2 : ℚ)
  | 7 => (-1 / 2 : ℚ)
  | 8 => (-1 / 2 : ℚ)
  | 9 => 0
  | _ => 0

public theorem BKVec_5_0 :
    BKVec (5 : Fin 15) (0 : Fin 2) = BKCoord5_0 := by
  refine vec_ext ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ <;>
    norm_num [BKVec, matrixMul, BVec, BRow5, BCell5_0, BCell5_1, BCell5_2, BCell5_3, BCell5_4, BCell5_5, BCell5_6, BCell5_7, BCell5_8, BCell5_9,
      KVec_col0, KVec_col1, KCell0_0_def, KCell0_1_def, KCell1_0_def, KCell1_1_def, KCell2_0_def, KCell2_1_def, KCell3_0_def, KCell3_1_def, KCell4_0_def, KCell4_1_def, KCell5_0_def, KCell5_1_def, KCell6_0_def, KCell6_1_def, KCell7_0_def, KCell7_1_def, KCell8_0_def, KCell8_1_def, KCell9_0_def, KCell9_1_def, BKCoord5_0,
      mul_constVec_left, Fin.sum_univ_succ]

@[expose] public def BKCoord5_1 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (-1 / 2 : ℚ)
  | 1 => 0
  | 2 => 0
  | 3 => (-1 / 2 : ℚ)
  | 4 => (-1 / 2 : ℚ)
  | 5 => 0
  | 6 => 0
  | 7 => (-1 / 2 : ℚ)
  | 8 => (-1 / 2 : ℚ)
  | 9 => 0
  | _ => 0

public theorem BKVec_5_1 :
    BKVec (5 : Fin 15) (1 : Fin 2) = BKCoord5_1 := by
  refine vec_ext ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ <;>
    norm_num [BKVec, matrixMul, BVec, BRow5, BCell5_0, BCell5_1, BCell5_2, BCell5_3, BCell5_4, BCell5_5, BCell5_6, BCell5_7, BCell5_8, BCell5_9,
      KVec_col0, KVec_col1, KCell0_0_def, KCell0_1_def, KCell1_0_def, KCell1_1_def, KCell2_0_def, KCell2_1_def, KCell3_0_def, KCell3_1_def, KCell4_0_def, KCell4_1_def, KCell5_0_def, KCell5_1_def, KCell6_0_def, KCell6_1_def, KCell7_0_def, KCell7_1_def, KCell8_0_def, KCell8_1_def, KCell9_0_def, KCell9_1_def, BKCoord5_1,
      mul_constVec_left, Fin.sum_univ_succ]

@[expose] public def BKCoord7_0 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (1 / 2 : ℚ)
  | 1 => 0
  | 2 => (-1 / 2 : ℚ)
  | 3 => 0
  | 4 => (-1 / 2 : ℚ)
  | 5 => -1
  | 6 => -1
  | 7 => (-1 / 2 : ℚ)
  | 8 => 0
  | 9 => (-1 / 2 : ℚ)
  | _ => 0

public theorem BKVec_7_0 :
    BKVec (7 : Fin 15) (0 : Fin 2) = BKCoord7_0 := by
  refine vec_ext ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ <;>
    norm_num [BKVec, matrixMul, BVec, BRow7, BCell7_0, BCell7_1, BCell7_2, BCell7_3, BCell7_4, BCell7_5, BCell7_6, BCell7_7, BCell7_8, BCell7_9,
      KVec_col0, KVec_col1, KCell0_0_def, KCell0_1_def, KCell1_0_def, KCell1_1_def, KCell2_0_def, KCell2_1_def, KCell3_0_def, KCell3_1_def, KCell4_0_def, KCell4_1_def, KCell5_0_def, KCell5_1_def, KCell6_0_def, KCell6_1_def, KCell7_0_def, KCell7_1_def, KCell8_0_def, KCell8_1_def, KCell9_0_def, KCell9_1_def, BKCoord7_0,
      mul_constVec_left, Fin.sum_univ_succ]

@[expose] public def BKCoord7_1 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (1 / 2 : ℚ)
  | 1 => 0
  | 2 => (-1 / 2 : ℚ)
  | 3 => 0
  | 4 => (1 / 2 : ℚ)
  | 5 => 0
  | 6 => 0
  | 7 => (1 / 2 : ℚ)
  | 8 => 0
  | 9 => (-1 / 2 : ℚ)
  | _ => 0

public theorem BKVec_7_1 :
    BKVec (7 : Fin 15) (1 : Fin 2) = BKCoord7_1 := by
  refine vec_ext ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ <;>
    norm_num [BKVec, matrixMul, BVec, BRow7, BCell7_0, BCell7_1, BCell7_2, BCell7_3, BCell7_4, BCell7_5, BCell7_6, BCell7_7, BCell7_8, BCell7_9,
      KVec_col0, KVec_col1, KCell0_0_def, KCell0_1_def, KCell1_0_def, KCell1_1_def, KCell2_0_def, KCell2_1_def, KCell3_0_def, KCell3_1_def, KCell4_0_def, KCell4_1_def, KCell5_0_def, KCell5_1_def, KCell6_0_def, KCell6_1_def, KCell7_0_def, KCell7_1_def, KCell8_0_def, KCell8_1_def, KCell9_0_def, KCell9_1_def, BKCoord7_1,
      mul_constVec_left, Fin.sum_univ_succ]

@[expose] public def BKCoord8_0 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
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

public theorem BKVec_8_0 :
    BKVec (8 : Fin 15) (0 : Fin 2) = BKCoord8_0 := by
  refine vec_ext ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ <;>
    norm_num [BKVec, matrixMul, BVec, BRow8, BCell8_0, BCell8_1, BCell8_2, BCell8_3, BCell8_4, BCell8_5, BCell8_6, BCell8_7, BCell8_8, BCell8_9,
      KVec_col0, KVec_col1, KCell0_0_def, KCell0_1_def, KCell1_0_def, KCell1_1_def, KCell2_0_def, KCell2_1_def, KCell3_0_def, KCell3_1_def, KCell4_0_def, KCell4_1_def, KCell5_0_def, KCell5_1_def, KCell6_0_def, KCell6_1_def, KCell7_0_def, KCell7_1_def, KCell8_0_def, KCell8_1_def, KCell9_0_def, KCell9_1_def, BKCoord8_0,
      mul_constVec_left, Fin.sum_univ_succ]

@[expose] public def BKCoord8_1 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (1 / 2 : ℚ)
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

public theorem BKVec_8_1 :
    BKVec (8 : Fin 15) (1 : Fin 2) = BKCoord8_1 := by
  refine vec_ext ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ <;>
    norm_num [BKVec, matrixMul, BVec, BRow8, BCell8_0, BCell8_1, BCell8_2, BCell8_3, BCell8_4, BCell8_5, BCell8_6, BCell8_7, BCell8_8, BCell8_9,
      KVec_col0, KVec_col1, KCell0_0_def, KCell0_1_def, KCell1_0_def, KCell1_1_def, KCell2_0_def, KCell2_1_def, KCell3_0_def, KCell3_1_def, KCell4_0_def, KCell4_1_def, KCell5_0_def, KCell5_1_def, KCell6_0_def, KCell6_1_def, KCell7_0_def, KCell7_1_def, KCell8_0_def, KCell8_1_def, KCell9_0_def, KCell9_1_def, BKCoord8_1,
      mul_constVec_left, Fin.sum_univ_succ]

@[expose] public def BKCoord10_0 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => 0
  | 2 => 0
  | 3 => 0
  | 4 => 0
  | 5 => (-1 / 2 : ℚ)
  | 6 => (-1 / 2 : ℚ)
  | 7 => 0
  | 8 => 0
  | 9 => 0
  | _ => 0

public theorem BKVec_10_0 :
    BKVec (10 : Fin 15) (0 : Fin 2) = BKCoord10_0 := by
  refine vec_ext ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ <;>
    norm_num [BKVec, matrixMul, BVec, BRow10, BCell10_0, BCell10_1, BCell10_2, BCell10_3, BCell10_4, BCell10_5, BCell10_6, BCell10_7, BCell10_8, BCell10_9,
      KVec_col0, KVec_col1, KCell0_0_def, KCell0_1_def, KCell1_0_def, KCell1_1_def, KCell2_0_def, KCell2_1_def, KCell3_0_def, KCell3_1_def, KCell4_0_def, KCell4_1_def, KCell5_0_def, KCell5_1_def, KCell6_0_def, KCell6_1_def, KCell7_0_def, KCell7_1_def, KCell8_0_def, KCell8_1_def, KCell9_0_def, KCell9_1_def, BKCoord10_0,
      mul_constVec_left, Fin.sum_univ_succ]

@[expose] public def BKCoord10_1 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (1 / 2 : ℚ)
  | 1 => 0
  | 2 => (-1 / 2 : ℚ)
  | 3 => 0
  | 4 => (1 / 2 : ℚ)
  | 5 => 0
  | 6 => 0
  | 7 => (1 / 2 : ℚ)
  | 8 => 0
  | 9 => (-1 / 2 : ℚ)
  | _ => 0

public theorem BKVec_10_1 :
    BKVec (10 : Fin 15) (1 : Fin 2) = BKCoord10_1 := by
  refine vec_ext ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ <;>
    norm_num [BKVec, matrixMul, BVec, BRow10, BCell10_0, BCell10_1, BCell10_2, BCell10_3, BCell10_4, BCell10_5, BCell10_6, BCell10_7, BCell10_8, BCell10_9,
      KVec_col0, KVec_col1, KCell0_0_def, KCell0_1_def, KCell1_0_def, KCell1_1_def, KCell2_0_def, KCell2_1_def, KCell3_0_def, KCell3_1_def, KCell4_0_def, KCell4_1_def, KCell5_0_def, KCell5_1_def, KCell6_0_def, KCell6_1_def, KCell7_0_def, KCell7_1_def, KCell8_0_def, KCell8_1_def, KCell9_0_def, KCell9_1_def, BKCoord10_1,
      mul_constVec_left, Fin.sum_univ_succ]

@[expose] public def BKCoord11_0 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (1 / 2 : ℚ)
  | 1 => 0
  | 2 => (1 / 2 : ℚ)
  | 3 => (1 / 2 : ℚ)
  | 4 => 0
  | 5 => 0
  | 6 => 0
  | 7 => 0
  | 8 => (1 / 2 : ℚ)
  | 9 => (1 / 2 : ℚ)
  | _ => 0

public theorem BKVec_11_0 :
    BKVec (11 : Fin 15) (0 : Fin 2) = BKCoord11_0 := by
  refine vec_ext ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ <;>
    norm_num [BKVec, matrixMul, BVec, BRow11, BCell11_0, BCell11_1, BCell11_2, BCell11_3, BCell11_4, BCell11_5, BCell11_6, BCell11_7, BCell11_8, BCell11_9,
      KVec_col0, KVec_col1, KCell0_0_def, KCell0_1_def, KCell1_0_def, KCell1_1_def, KCell2_0_def, KCell2_1_def, KCell3_0_def, KCell3_1_def, KCell4_0_def, KCell4_1_def, KCell5_0_def, KCell5_1_def, KCell6_0_def, KCell6_1_def, KCell7_0_def, KCell7_1_def, KCell8_0_def, KCell8_1_def, KCell9_0_def, KCell9_1_def, BKCoord11_0,
      mul_constVec_left, Fin.sum_univ_succ]

@[expose] public def BKCoord11_1 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (1 / 2 : ℚ)
  | 1 => 0
  | 2 => (-1 / 2 : ℚ)
  | 3 => 0
  | 4 => 0
  | 5 => (1 / 2 : ℚ)
  | 6 => (1 / 2 : ℚ)
  | 7 => 0
  | 8 => 0
  | 9 => (-1 / 2 : ℚ)
  | _ => 0

public theorem BKVec_11_1 :
    BKVec (11 : Fin 15) (1 : Fin 2) = BKCoord11_1 := by
  refine vec_ext ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ <;>
    norm_num [BKVec, matrixMul, BVec, BRow11, BCell11_0, BCell11_1, BCell11_2, BCell11_3, BCell11_4, BCell11_5, BCell11_6, BCell11_7, BCell11_8, BCell11_9,
      KVec_col0, KVec_col1, KCell0_0_def, KCell0_1_def, KCell1_0_def, KCell1_1_def, KCell2_0_def, KCell2_1_def, KCell3_0_def, KCell3_1_def, KCell4_0_def, KCell4_1_def, KCell5_0_def, KCell5_1_def, KCell6_0_def, KCell6_1_def, KCell7_0_def, KCell7_1_def, KCell8_0_def, KCell8_1_def, KCell9_0_def, KCell9_1_def, BKCoord11_1,
      mul_constVec_left, Fin.sum_univ_succ]

@[expose] public def BKCoord12_0 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => 0
  | 2 => 0
  | 3 => (1 / 2 : ℚ)
  | 4 => (1 / 2 : ℚ)
  | 5 => 0
  | 6 => 0
  | 7 => (1 / 2 : ℚ)
  | 8 => (1 / 2 : ℚ)
  | 9 => 0
  | _ => 0

public theorem BKVec_12_0 :
    BKVec (12 : Fin 15) (0 : Fin 2) = BKCoord12_0 := by
  refine vec_ext ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ <;>
    norm_num [BKVec, matrixMul, BVec, BRow12, BCell12_0, BCell12_1, BCell12_2, BCell12_3, BCell12_4, BCell12_5, BCell12_6, BCell12_7, BCell12_8, BCell12_9,
      KVec_col0, KVec_col1, KCell0_0_def, KCell0_1_def, KCell1_0_def, KCell1_1_def, KCell2_0_def, KCell2_1_def, KCell3_0_def, KCell3_1_def, KCell4_0_def, KCell4_1_def, KCell5_0_def, KCell5_1_def, KCell6_0_def, KCell6_1_def, KCell7_0_def, KCell7_1_def, KCell8_0_def, KCell8_1_def, KCell9_0_def, KCell9_1_def, BKCoord12_0,
      mul_constVec_left, Fin.sum_univ_succ]

@[expose] public def BKCoord12_1 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (1 / 2 : ℚ)
  | 1 => 0
  | 2 => (-1 / 2 : ℚ)
  | 3 => (-1 / 2 : ℚ)
  | 4 => 0
  | 5 => 0
  | 6 => 0
  | 7 => 0
  | 8 => (-1 / 2 : ℚ)
  | 9 => (-1 / 2 : ℚ)
  | _ => 0

public theorem BKVec_12_1 :
    BKVec (12 : Fin 15) (1 : Fin 2) = BKCoord12_1 := by
  refine vec_ext ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ <;>
    norm_num [BKVec, matrixMul, BVec, BRow12, BCell12_0, BCell12_1, BCell12_2, BCell12_3, BCell12_4, BCell12_5, BCell12_6, BCell12_7, BCell12_8, BCell12_9,
      KVec_col0, KVec_col1, KCell0_0_def, KCell0_1_def, KCell1_0_def, KCell1_1_def, KCell2_0_def, KCell2_1_def, KCell3_0_def, KCell3_1_def, KCell4_0_def, KCell4_1_def, KCell5_0_def, KCell5_1_def, KCell6_0_def, KCell6_1_def, KCell7_0_def, KCell7_1_def, KCell8_0_def, KCell8_1_def, KCell9_0_def, KCell9_1_def, BKCoord12_1,
      mul_constVec_left, Fin.sum_univ_succ]

@[expose] public def BKCoord13_0 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (-1 / 2 : ℚ)
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

public theorem BKVec_13_0 :
    BKVec (13 : Fin 15) (0 : Fin 2) = BKCoord13_0 := by
  refine vec_ext ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ <;>
    norm_num [BKVec, matrixMul, BVec, BRow13, BCell13_0, BCell13_1, BCell13_2, BCell13_3, BCell13_4, BCell13_5, BCell13_6, BCell13_7, BCell13_8, BCell13_9,
      KVec_col0, KVec_col1, KCell0_0_def, KCell0_1_def, KCell1_0_def, KCell1_1_def, KCell2_0_def, KCell2_1_def, KCell3_0_def, KCell3_1_def, KCell4_0_def, KCell4_1_def, KCell5_0_def, KCell5_1_def, KCell6_0_def, KCell6_1_def, KCell7_0_def, KCell7_1_def, KCell8_0_def, KCell8_1_def, KCell9_0_def, KCell9_1_def, BKCoord13_0,
      mul_constVec_left, Fin.sum_univ_succ]

@[expose] public def BKCoord13_1 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
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

public theorem BKVec_13_1 :
    BKVec (13 : Fin 15) (1 : Fin 2) = BKCoord13_1 := by
  refine vec_ext ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ <;>
    norm_num [BKVec, matrixMul, BVec, BRow13, BCell13_0, BCell13_1, BCell13_2, BCell13_3, BCell13_4, BCell13_5, BCell13_6, BCell13_7, BCell13_8, BCell13_9,
      KVec_col0, KVec_col1, KCell0_0_def, KCell0_1_def, KCell1_0_def, KCell1_1_def, KCell2_0_def, KCell2_1_def, KCell3_0_def, KCell3_1_def, KCell4_0_def, KCell4_1_def, KCell5_0_def, KCell5_1_def, KCell6_0_def, KCell6_1_def, KCell7_0_def, KCell7_1_def, KCell8_0_def, KCell8_1_def, KCell9_0_def, KCell9_1_def, BKCoord13_1,
      mul_constVec_left, Fin.sum_univ_succ]

@[expose] public def BKCoord14_0 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (1 / 2 : ℚ)
  | 1 => 0
  | 2 => (-1 / 2 : ℚ)
  | 3 => 0
  | 4 => 0
  | 5 => (-1 / 2 : ℚ)
  | 6 => (-1 / 2 : ℚ)
  | 7 => 0
  | 8 => 0
  | 9 => (-1 / 2 : ℚ)
  | _ => 0

public theorem BKVec_14_0 :
    BKVec (14 : Fin 15) (0 : Fin 2) = BKCoord14_0 := by
  refine vec_ext ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ <;>
    norm_num [BKVec, matrixMul, BVec, BRow14, BCell14_0, BCell14_1, BCell14_2, BCell14_3, BCell14_4, BCell14_5, BCell14_6, BCell14_7, BCell14_8, BCell14_9,
      KVec_col0, KVec_col1, KCell0_0_def, KCell0_1_def, KCell1_0_def, KCell1_1_def, KCell2_0_def, KCell2_1_def, KCell3_0_def, KCell3_1_def, KCell4_0_def, KCell4_1_def, KCell5_0_def, KCell5_1_def, KCell6_0_def, KCell6_1_def, KCell7_0_def, KCell7_1_def, KCell8_0_def, KCell8_1_def, KCell9_0_def, KCell9_1_def, BKCoord14_0,
      mul_constVec_left, Fin.sum_univ_succ]

@[expose] public def BKCoord14_1 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 1
  | 1 => 0
  | 2 => 0
  | 3 => 1
  | 4 => 1
  | 5 => (-1 / 2 : ℚ)
  | 6 => (-1 / 2 : ℚ)
  | 7 => 1
  | 8 => 1
  | 9 => 0
  | _ => 0

public theorem BKVec_14_1 :
    BKVec (14 : Fin 15) (1 : Fin 2) = BKCoord14_1 := by
  refine vec_ext ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ <;>
    norm_num [BKVec, matrixMul, BVec, BRow14, BCell14_0, BCell14_1, BCell14_2, BCell14_3, BCell14_4, BCell14_5, BCell14_6, BCell14_7, BCell14_8, BCell14_9,
      KVec_col0, KVec_col1, KCell0_0_def, KCell0_1_def, KCell1_0_def, KCell1_1_def, KCell2_0_def, KCell2_1_def, KCell3_0_def, KCell3_1_def, KCell4_0_def, KCell4_1_def, KCell5_0_def, KCell5_1_def, KCell6_0_def, KCell6_1_def, KCell7_0_def, KCell7_1_def, KCell8_0_def, KCell8_1_def, KCell9_0_def, KCell9_1_def, BKCoord14_1,
      mul_constVec_left, Fin.sum_univ_succ]

@[expose] public def CCell0_0 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => -1
  | 1 => 0
  | 2 => (1 / 2 : ℚ)
  | 3 => 0
  | 4 => (1 / 2 : ℚ)
  | 5 => (1 / 2 : ℚ)
  | 6 => (1 / 2 : ℚ)
  | 7 => (1 / 2 : ℚ)
  | 8 => 0
  | 9 => (1 / 2 : ℚ)
  | _ => 0

@[expose] public def CCell0_1 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => -2
  | 1 => 0
  | 2 => 1
  | 3 => -1
  | 4 => 0
  | 5 => 2
  | 6 => 2
  | 7 => 0
  | 8 => -1
  | 9 => 1
  | _ => 0

@[expose] public def CCell0_2 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => -2
  | 1 => 0
  | 2 => (3 / 2 : ℚ)
  | 3 => (-1 / 2 : ℚ)
  | 4 => (-3 / 2 : ℚ)
  | 5 => (1 / 2 : ℚ)
  | 6 => (1 / 2 : ℚ)
  | 7 => (-3 / 2 : ℚ)
  | 8 => (-1 / 2 : ℚ)
  | 9 => (3 / 2 : ℚ)
  | _ => 0

@[expose] public def CRow0 (j : Fin 3) : Vec :=
  match j.val with
  | 0 => CCell0_0
  | 1 => CCell0_1
  | 2 => CCell0_2
  | _ => 0

@[expose] public def CCell1_0 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => 0
  | 2 => 1
  | 3 => (1 / 2 : ℚ)
  | 4 => 0
  | 5 => 1
  | 6 => 1
  | 7 => 0
  | 8 => (1 / 2 : ℚ)
  | 9 => 1
  | _ => 0

@[expose] public def CCell1_1 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => -1
  | 1 => 0
  | 2 => 1
  | 3 => 0
  | 4 => -1
  | 5 => 1
  | 6 => 1
  | 7 => -1
  | 8 => 0
  | 9 => 1
  | _ => 0

@[expose] public def CCell1_2 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => -1
  | 1 => 0
  | 2 => 0
  | 3 => -1
  | 4 => -1
  | 5 => (1 / 2 : ℚ)
  | 6 => (1 / 2 : ℚ)
  | 7 => -1
  | 8 => -1
  | 9 => 0
  | _ => 0

@[expose] public def CRow1 (j : Fin 3) : Vec :=
  match j.val with
  | 0 => CCell1_0
  | 1 => CCell1_1
  | 2 => CCell1_2
  | _ => 0

@[expose] public def CCell2_0 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 1
  | 1 => 0
  | 2 => (-1 / 2 : ℚ)
  | 3 => 0
  | 4 => (1 / 2 : ℚ)
  | 5 => 1
  | 6 => 1
  | 7 => (1 / 2 : ℚ)
  | 8 => 0
  | 9 => (-1 / 2 : ℚ)
  | _ => 0

@[expose] public def CCell2_1 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => -3
  | 1 => 0
  | 2 => 4
  | 3 => 3
  | 4 => 0
  | 5 => 0
  | 6 => 0
  | 7 => 0
  | 8 => 3
  | 9 => 4
  | _ => 0

@[expose] public def CCell2_2 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => -2
  | 1 => 0
  | 2 => 0
  | 3 => -5
  | 4 => (-9 / 2 : ℚ)
  | 5 => (5 / 2 : ℚ)
  | 6 => (5 / 2 : ℚ)
  | 7 => (-9 / 2 : ℚ)
  | 8 => -5
  | 9 => 0
  | _ => 0

@[expose] public def CRow2 (j : Fin 3) : Vec :=
  match j.val with
  | 0 => CCell2_0
  | 1 => CCell2_1
  | 2 => CCell2_2
  | _ => 0

@[expose] public def CVec : Matrix (Fin 3) (Fin 3) Vec :=
  fun i j => match i.val with
  | 0 => CRow0 j
  | 1 => CRow1 j
  | 2 => CRow2 j
  | _ => 0

@[expose] public def deltaVec (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 1
  | 1 => 0
  | 2 => 1
  | 3 => 5
  | 4 => (9 / 2 : ℚ)
  | 5 => 0
  | 6 => 0
  | 7 => (9 / 2 : ℚ)
  | 8 => 5
  | 9 => 1
  | _ => 0

public theorem evalMatrix_BKVec :
    evalMatrix BKVec = evalMatrixK B_poly * evalMatrix KVec := by
  change evalMatrix (matrixMul BVec KVec) = _
  rw [evalMatrix_mul, evalMatrix_BVec]

public theorem delta_ne_zero : eval deltaVec ≠ 0 := by
  intro h
  have hv : deltaVec = 0 := (eval_eq_zero_iff deltaVec).mp h
  have hz := congrFun hv (0 : Fin 10)
  norm_num [deltaVec] at hz

end V14Formalization.D12PiecePPPluckerBase
