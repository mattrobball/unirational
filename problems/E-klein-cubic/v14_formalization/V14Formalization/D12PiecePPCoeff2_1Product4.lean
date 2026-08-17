/- Bounded product 4 for PP Plucker coefficient (2,1). -/
module

public import V14Formalization.D12PiecePPPluckerBase

noncomputable section
namespace V14Formalization.D12PiecePPCoeff2_1Product4
open D12CyclotomicVec D12PiecePPPluckerBase
@[expose] public def payloadSha256 : String := "76c6196f29afe1a8398af99502447f48ebeed4bcb3805fc5dbec693940bc04b0"

def productVec : Vec := mul BKCoord4_0 BKCoord12_1

@[expose] public def productValue (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => 0
  | 1 => 0
  | 2 => (1 / 2 : ℚ)
  | 3 => (3 / 2 : ℚ)
  | 4 => 1
  | 5 => (-1 / 2 : ℚ)
  | 6 => (-1 / 2 : ℚ)
  | 7 => 1
  | 8 => (3 / 2 : ℚ)
  | 9 => (1 / 2 : ℚ)
  | _ => 0

theorem productVec_apply_0 :
    productVec (0 : Fin 10) = productValue (0 : Fin 10) := by
  norm_num [productVec, productValue, BKCoord4_0, BKCoord12_1,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem productVec_apply_1 :
    productVec (1 : Fin 10) = productValue (1 : Fin 10) := by
  norm_num [productVec, productValue, BKCoord4_0, BKCoord12_1,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem productVec_apply_2 :
    productVec (2 : Fin 10) = productValue (2 : Fin 10) := by
  norm_num [productVec, productValue, BKCoord4_0, BKCoord12_1,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem productVec_apply_3 :
    productVec (3 : Fin 10) = productValue (3 : Fin 10) := by
  norm_num [productVec, productValue, BKCoord4_0, BKCoord12_1,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem productVec_apply_4 :
    productVec (4 : Fin 10) = productValue (4 : Fin 10) := by
  norm_num [productVec, productValue, BKCoord4_0, BKCoord12_1,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem productVec_apply_5 :
    productVec (5 : Fin 10) = productValue (5 : Fin 10) := by
  norm_num [productVec, productValue, BKCoord4_0, BKCoord12_1,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem productVec_apply_6 :
    productVec (6 : Fin 10) = productValue (6 : Fin 10) := by
  norm_num [productVec, productValue, BKCoord4_0, BKCoord12_1,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem productVec_apply_7 :
    productVec (7 : Fin 10) = productValue (7 : Fin 10) := by
  norm_num [productVec, productValue, BKCoord4_0, BKCoord12_1,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem productVec_apply_8 :
    productVec (8 : Fin 10) = productValue (8 : Fin 10) := by
  norm_num [productVec, productValue, BKCoord4_0, BKCoord12_1,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem productVec_apply_9 :
    productVec (9 : Fin 10) = productValue (9 : Fin 10) := by
  norm_num [productVec, productValue, BKCoord4_0, BKCoord12_1,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem productVec_eq : productVec = productValue := by
  funext n
  fin_cases n
  · exact productVec_apply_0
  · exact productVec_apply_1
  · exact productVec_apply_2
  · exact productVec_apply_3
  · exact productVec_apply_4
  · exact productVec_apply_5
  · exact productVec_apply_6
  · exact productVec_apply_7
  · exact productVec_apply_8
  · exact productVec_apply_9

public theorem eval_product :
    eval BKCoord4_0 * eval BKCoord12_1 = eval productValue := by
  calc
    _ = eval productVec := by simp only [productVec, eval_mul]
    _ = _ := congrArg eval productVec_eq

end V14Formalization.D12PiecePPCoeff2_1Product4
