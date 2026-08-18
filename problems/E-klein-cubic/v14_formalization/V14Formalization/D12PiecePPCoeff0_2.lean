/- PP Plucker coefficient (0,2). Auto-generated. -/
module

public import V14Formalization.D12PiecePPPluckerBase

noncomputable section
namespace V14Formalization.D12PiecePPCoeff0_2
open D12CyclotomicVec D12PiecePPPluckerBase
def payloadSha256 : String := "76c6196f29afe1a8398af99502447f48ebeed4bcb3805fc5dbec693940bc04b0"

def coefficientVec : Vec :=
  mul BKCoord0_1 BKCoord10_1 - mul BKCoord1_1 BKCoord7_1 + mul BKCoord3_1 BKCoord5_1

theorem coefficientVec_apply_0 :
    coefficientVec (0 : Fin 10) = CCell0_2 (0 : Fin 10) := by
  norm_num [coefficientVec, CCell0_2, BKCoord0_1, BKCoord10_1, BKCoord1_1, BKCoord3_1, BKCoord5_1, BKCoord7_1, mul_apply_0]

theorem coefficientVec_apply_1 :
    coefficientVec (1 : Fin 10) = CCell0_2 (1 : Fin 10) := by
  norm_num [coefficientVec, CCell0_2, BKCoord0_1, BKCoord10_1, BKCoord1_1, BKCoord3_1, BKCoord5_1, BKCoord7_1, mul_apply_1]

theorem coefficientVec_apply_2 :
    coefficientVec (2 : Fin 10) = CCell0_2 (2 : Fin 10) := by
  norm_num [coefficientVec, CCell0_2, BKCoord0_1, BKCoord10_1, BKCoord1_1, BKCoord3_1, BKCoord5_1, BKCoord7_1, mul_apply_2]

theorem coefficientVec_apply_3 :
    coefficientVec (3 : Fin 10) = CCell0_2 (3 : Fin 10) := by
  norm_num [coefficientVec, CCell0_2, BKCoord0_1, BKCoord10_1, BKCoord1_1, BKCoord3_1, BKCoord5_1, BKCoord7_1, mul_apply_3]

theorem coefficientVec_apply_4 :
    coefficientVec (4 : Fin 10) = CCell0_2 (4 : Fin 10) := by
  norm_num [coefficientVec, CCell0_2, BKCoord0_1, BKCoord10_1, BKCoord1_1, BKCoord3_1, BKCoord5_1, BKCoord7_1, mul_apply_4]

theorem coefficientVec_apply_5 :
    coefficientVec (5 : Fin 10) = CCell0_2 (5 : Fin 10) := by
  norm_num [coefficientVec, CCell0_2, BKCoord0_1, BKCoord10_1, BKCoord1_1, BKCoord3_1, BKCoord5_1, BKCoord7_1, mul_apply_5]

theorem coefficientVec_apply_6 :
    coefficientVec (6 : Fin 10) = CCell0_2 (6 : Fin 10) := by
  norm_num [coefficientVec, CCell0_2, BKCoord0_1, BKCoord10_1, BKCoord1_1, BKCoord3_1, BKCoord5_1, BKCoord7_1, mul_apply_6]

theorem coefficientVec_apply_7 :
    coefficientVec (7 : Fin 10) = CCell0_2 (7 : Fin 10) := by
  norm_num [coefficientVec, CCell0_2, BKCoord0_1, BKCoord10_1, BKCoord1_1, BKCoord3_1, BKCoord5_1, BKCoord7_1, mul_apply_7]

theorem coefficientVec_apply_8 :
    coefficientVec (8 : Fin 10) = CCell0_2 (8 : Fin 10) := by
  norm_num [coefficientVec, CCell0_2, BKCoord0_1, BKCoord10_1, BKCoord1_1, BKCoord3_1, BKCoord5_1, BKCoord7_1, mul_apply_8]

theorem coefficientVec_apply_9 :
    coefficientVec (9 : Fin 10) = CCell0_2 (9 : Fin 10) := by
  norm_num [coefficientVec, CCell0_2, BKCoord0_1, BKCoord10_1, BKCoord1_1, BKCoord3_1, BKCoord5_1, BKCoord7_1, mul_apply_9]

theorem coefficientVec_eq : coefficientVec = CCell0_2 := by
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

public theorem eval_coefficient :
    eval BKCoord0_1 * eval BKCoord10_1 - eval BKCoord1_1 * eval BKCoord7_1 + eval BKCoord3_1 * eval BKCoord5_1 =
      eval CCell0_2 := by
  calc
    _ = eval coefficientVec := by
      simp only [coefficientVec, eval_add, eval_sub, eval_mul]
    _ = _ := congrArg eval coefficientVec_eq

end V14Formalization.D12PiecePPCoeff0_2
