/- PP Plucker coefficient (0,0). Auto-generated. -/
import V14Formalization.D12PiecePPPluckerBase

noncomputable section
namespace V14Formalization.D12PiecePPCoeff0_0
open D12CyclotomicVec D12PiecePPPluckerBase
def payloadSha256 : String := "76c6196f29afe1a8398af99502447f48ebeed4bcb3805fc5dbec693940bc04b0"

def coefficientVec : Vec :=
  mul BKCoord0_0 BKCoord10_0 - mul BKCoord1_0 BKCoord7_0 + mul BKCoord3_0 BKCoord5_0

theorem coefficientVec_apply_0 :
    coefficientVec (0 : Fin 10) = CCell0_0 (0 : Fin 10) := by
  norm_num [coefficientVec, CCell0_0, BKCoord0_0, BKCoord10_0, BKCoord1_0, BKCoord3_0, BKCoord5_0, BKCoord7_0,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem coefficientVec_apply_1 :
    coefficientVec (1 : Fin 10) = CCell0_0 (1 : Fin 10) := by
  norm_num [coefficientVec, CCell0_0, BKCoord0_0, BKCoord10_0, BKCoord1_0, BKCoord3_0, BKCoord5_0, BKCoord7_0,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem coefficientVec_apply_2 :
    coefficientVec (2 : Fin 10) = CCell0_0 (2 : Fin 10) := by
  norm_num [coefficientVec, CCell0_0, BKCoord0_0, BKCoord10_0, BKCoord1_0, BKCoord3_0, BKCoord5_0, BKCoord7_0,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem coefficientVec_apply_3 :
    coefficientVec (3 : Fin 10) = CCell0_0 (3 : Fin 10) := by
  norm_num [coefficientVec, CCell0_0, BKCoord0_0, BKCoord10_0, BKCoord1_0, BKCoord3_0, BKCoord5_0, BKCoord7_0,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem coefficientVec_apply_4 :
    coefficientVec (4 : Fin 10) = CCell0_0 (4 : Fin 10) := by
  norm_num [coefficientVec, CCell0_0, BKCoord0_0, BKCoord10_0, BKCoord1_0, BKCoord3_0, BKCoord5_0, BKCoord7_0,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem coefficientVec_apply_5 :
    coefficientVec (5 : Fin 10) = CCell0_0 (5 : Fin 10) := by
  norm_num [coefficientVec, CCell0_0, BKCoord0_0, BKCoord10_0, BKCoord1_0, BKCoord3_0, BKCoord5_0, BKCoord7_0,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem coefficientVec_apply_6 :
    coefficientVec (6 : Fin 10) = CCell0_0 (6 : Fin 10) := by
  norm_num [coefficientVec, CCell0_0, BKCoord0_0, BKCoord10_0, BKCoord1_0, BKCoord3_0, BKCoord5_0, BKCoord7_0,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem coefficientVec_apply_7 :
    coefficientVec (7 : Fin 10) = CCell0_0 (7 : Fin 10) := by
  norm_num [coefficientVec, CCell0_0, BKCoord0_0, BKCoord10_0, BKCoord1_0, BKCoord3_0, BKCoord5_0, BKCoord7_0,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem coefficientVec_apply_8 :
    coefficientVec (8 : Fin 10) = CCell0_0 (8 : Fin 10) := by
  norm_num [coefficientVec, CCell0_0, BKCoord0_0, BKCoord10_0, BKCoord1_0, BKCoord3_0, BKCoord5_0, BKCoord7_0,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem coefficientVec_apply_9 :
    coefficientVec (9 : Fin 10) = CCell0_0 (9 : Fin 10) := by
  norm_num [coefficientVec, CCell0_0, BKCoord0_0, BKCoord10_0, BKCoord1_0, BKCoord3_0, BKCoord5_0, BKCoord7_0,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem coefficientVec_eq : coefficientVec = CCell0_0 := by
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
    eval BKCoord0_0 * eval BKCoord10_0 - eval BKCoord1_0 * eval BKCoord7_0 + eval BKCoord3_0 * eval BKCoord5_0 =
      eval CCell0_0 := by
  calc
    _ = eval coefficientVec := by
      simp only [coefficientVec, eval_add, eval_sub, eval_mul]
    _ = _ := congrArg eval coefficientVec_eq

end V14Formalization.D12PiecePPCoeff0_0
