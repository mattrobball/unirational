/- PP Plucker coefficient (2,0). Auto-generated. -/
import V14Formalization.D12PiecePPPluckerBase

noncomputable section
namespace V14Formalization.D12PiecePPCoeff2_0
open D12CyclotomicVec D12PiecePPPluckerBase
def payloadSha256 : String := "76c6196f29afe1a8398af99502447f48ebeed4bcb3805fc5dbec693940bc04b0"

def coefficientVec : Vec :=
  mul BKCoord2_0 BKCoord14_0 - mul BKCoord3_0 BKCoord13_0 + mul BKCoord4_0 BKCoord12_0

theorem coefficientVec_apply_0 :
    coefficientVec (0 : Fin 10) = CCell2_0 (0 : Fin 10) := by
  norm_num [coefficientVec, CCell2_0, BKCoord12_0, BKCoord13_0, BKCoord14_0, BKCoord2_0, BKCoord3_0, BKCoord4_0,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem coefficientVec_apply_1 :
    coefficientVec (1 : Fin 10) = CCell2_0 (1 : Fin 10) := by
  norm_num [coefficientVec, CCell2_0, BKCoord12_0, BKCoord13_0, BKCoord14_0, BKCoord2_0, BKCoord3_0, BKCoord4_0,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem coefficientVec_apply_2 :
    coefficientVec (2 : Fin 10) = CCell2_0 (2 : Fin 10) := by
  norm_num [coefficientVec, CCell2_0, BKCoord12_0, BKCoord13_0, BKCoord14_0, BKCoord2_0, BKCoord3_0, BKCoord4_0,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem coefficientVec_apply_3 :
    coefficientVec (3 : Fin 10) = CCell2_0 (3 : Fin 10) := by
  norm_num [coefficientVec, CCell2_0, BKCoord12_0, BKCoord13_0, BKCoord14_0, BKCoord2_0, BKCoord3_0, BKCoord4_0,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem coefficientVec_apply_4 :
    coefficientVec (4 : Fin 10) = CCell2_0 (4 : Fin 10) := by
  norm_num [coefficientVec, CCell2_0, BKCoord12_0, BKCoord13_0, BKCoord14_0, BKCoord2_0, BKCoord3_0, BKCoord4_0,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem coefficientVec_apply_5 :
    coefficientVec (5 : Fin 10) = CCell2_0 (5 : Fin 10) := by
  norm_num [coefficientVec, CCell2_0, BKCoord12_0, BKCoord13_0, BKCoord14_0, BKCoord2_0, BKCoord3_0, BKCoord4_0,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem coefficientVec_apply_6 :
    coefficientVec (6 : Fin 10) = CCell2_0 (6 : Fin 10) := by
  norm_num [coefficientVec, CCell2_0, BKCoord12_0, BKCoord13_0, BKCoord14_0, BKCoord2_0, BKCoord3_0, BKCoord4_0,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem coefficientVec_apply_7 :
    coefficientVec (7 : Fin 10) = CCell2_0 (7 : Fin 10) := by
  norm_num [coefficientVec, CCell2_0, BKCoord12_0, BKCoord13_0, BKCoord14_0, BKCoord2_0, BKCoord3_0, BKCoord4_0,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem coefficientVec_apply_8 :
    coefficientVec (8 : Fin 10) = CCell2_0 (8 : Fin 10) := by
  norm_num [coefficientVec, CCell2_0, BKCoord12_0, BKCoord13_0, BKCoord14_0, BKCoord2_0, BKCoord3_0, BKCoord4_0,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem coefficientVec_apply_9 :
    coefficientVec (9 : Fin 10) = CCell2_0 (9 : Fin 10) := by
  norm_num [coefficientVec, CCell2_0, BKCoord12_0, BKCoord13_0, BKCoord14_0, BKCoord2_0, BKCoord3_0, BKCoord4_0,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem coefficientVec_eq : coefficientVec = CCell2_0 := by
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
    eval BKCoord2_0 * eval BKCoord14_0 - eval BKCoord3_0 * eval BKCoord13_0 + eval BKCoord4_0 * eval BKCoord12_0 =
      eval CCell2_0 := by
  calc
    _ = eval coefficientVec := by
      simp only [coefficientVec, eval_add, eval_sub, eval_mul]
    _ = _ := congrArg eval coefficientVec_eq

end V14Formalization.D12PiecePPCoeff2_0
