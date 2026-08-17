/- PP Plucker coefficient (1,1). Auto-generated. -/
module

public import V14Formalization.D12PiecePPCoeff1_1Product0
public import V14Formalization.D12PiecePPCoeff1_1Product1
public import V14Formalization.D12PiecePPCoeff1_1Product2
public import V14Formalization.D12PiecePPCoeff1_1Product3
public import V14Formalization.D12PiecePPCoeff1_1Product4
public import V14Formalization.D12PiecePPCoeff1_1Product5

noncomputable section
namespace V14Formalization.D12PiecePPCoeff1_1
open D12CyclotomicVec D12PiecePPPluckerBase
def payloadSha256 : String := "76c6196f29afe1a8398af99502447f48ebeed4bcb3805fc5dbec693940bc04b0"

def coefficientVec : Vec :=
  D12PiecePPCoeff1_1Product0.productValue + D12PiecePPCoeff1_1Product1.productValue - D12PiecePPCoeff1_1Product2.productValue - D12PiecePPCoeff1_1Product3.productValue + D12PiecePPCoeff1_1Product4.productValue + D12PiecePPCoeff1_1Product5.productValue

theorem coefficientVec_apply_0 :
    coefficientVec (0 : Fin 10) = CCell1_1 (0 : Fin 10) := by
  norm_num [coefficientVec, CCell1_1, D12PiecePPCoeff1_1Product0.productValue, D12PiecePPCoeff1_1Product1.productValue, D12PiecePPCoeff1_1Product2.productValue, D12PiecePPCoeff1_1Product3.productValue, D12PiecePPCoeff1_1Product4.productValue, D12PiecePPCoeff1_1Product5.productValue]

theorem coefficientVec_apply_1 :
    coefficientVec (1 : Fin 10) = CCell1_1 (1 : Fin 10) := by
  norm_num [coefficientVec, CCell1_1, D12PiecePPCoeff1_1Product0.productValue, D12PiecePPCoeff1_1Product1.productValue, D12PiecePPCoeff1_1Product2.productValue, D12PiecePPCoeff1_1Product3.productValue, D12PiecePPCoeff1_1Product4.productValue, D12PiecePPCoeff1_1Product5.productValue]

theorem coefficientVec_apply_2 :
    coefficientVec (2 : Fin 10) = CCell1_1 (2 : Fin 10) := by
  norm_num [coefficientVec, CCell1_1, D12PiecePPCoeff1_1Product0.productValue, D12PiecePPCoeff1_1Product1.productValue, D12PiecePPCoeff1_1Product2.productValue, D12PiecePPCoeff1_1Product3.productValue, D12PiecePPCoeff1_1Product4.productValue, D12PiecePPCoeff1_1Product5.productValue]

theorem coefficientVec_apply_3 :
    coefficientVec (3 : Fin 10) = CCell1_1 (3 : Fin 10) := by
  norm_num [coefficientVec, CCell1_1, D12PiecePPCoeff1_1Product0.productValue, D12PiecePPCoeff1_1Product1.productValue, D12PiecePPCoeff1_1Product2.productValue, D12PiecePPCoeff1_1Product3.productValue, D12PiecePPCoeff1_1Product4.productValue, D12PiecePPCoeff1_1Product5.productValue]

theorem coefficientVec_apply_4 :
    coefficientVec (4 : Fin 10) = CCell1_1 (4 : Fin 10) := by
  norm_num [coefficientVec, CCell1_1, D12PiecePPCoeff1_1Product0.productValue, D12PiecePPCoeff1_1Product1.productValue, D12PiecePPCoeff1_1Product2.productValue, D12PiecePPCoeff1_1Product3.productValue, D12PiecePPCoeff1_1Product4.productValue, D12PiecePPCoeff1_1Product5.productValue]

theorem coefficientVec_apply_5 :
    coefficientVec (5 : Fin 10) = CCell1_1 (5 : Fin 10) := by
  norm_num [coefficientVec, CCell1_1, D12PiecePPCoeff1_1Product0.productValue, D12PiecePPCoeff1_1Product1.productValue, D12PiecePPCoeff1_1Product2.productValue, D12PiecePPCoeff1_1Product3.productValue, D12PiecePPCoeff1_1Product4.productValue, D12PiecePPCoeff1_1Product5.productValue]

theorem coefficientVec_apply_6 :
    coefficientVec (6 : Fin 10) = CCell1_1 (6 : Fin 10) := by
  norm_num [coefficientVec, CCell1_1, D12PiecePPCoeff1_1Product0.productValue, D12PiecePPCoeff1_1Product1.productValue, D12PiecePPCoeff1_1Product2.productValue, D12PiecePPCoeff1_1Product3.productValue, D12PiecePPCoeff1_1Product4.productValue, D12PiecePPCoeff1_1Product5.productValue]

theorem coefficientVec_apply_7 :
    coefficientVec (7 : Fin 10) = CCell1_1 (7 : Fin 10) := by
  norm_num [coefficientVec, CCell1_1, D12PiecePPCoeff1_1Product0.productValue, D12PiecePPCoeff1_1Product1.productValue, D12PiecePPCoeff1_1Product2.productValue, D12PiecePPCoeff1_1Product3.productValue, D12PiecePPCoeff1_1Product4.productValue, D12PiecePPCoeff1_1Product5.productValue]

theorem coefficientVec_apply_8 :
    coefficientVec (8 : Fin 10) = CCell1_1 (8 : Fin 10) := by
  norm_num [coefficientVec, CCell1_1, D12PiecePPCoeff1_1Product0.productValue, D12PiecePPCoeff1_1Product1.productValue, D12PiecePPCoeff1_1Product2.productValue, D12PiecePPCoeff1_1Product3.productValue, D12PiecePPCoeff1_1Product4.productValue, D12PiecePPCoeff1_1Product5.productValue]

theorem coefficientVec_apply_9 :
    coefficientVec (9 : Fin 10) = CCell1_1 (9 : Fin 10) := by
  norm_num [coefficientVec, CCell1_1, D12PiecePPCoeff1_1Product0.productValue, D12PiecePPCoeff1_1Product1.productValue, D12PiecePPCoeff1_1Product2.productValue, D12PiecePPCoeff1_1Product3.productValue, D12PiecePPCoeff1_1Product4.productValue, D12PiecePPCoeff1_1Product5.productValue]

theorem coefficientVec_eq : coefficientVec = CCell1_1 := by
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
    eval BKCoord0_0 * eval BKCoord11_1 + eval BKCoord0_1 * eval BKCoord11_0 - eval BKCoord1_0 * eval BKCoord8_1 - eval BKCoord1_1 * eval BKCoord8_0 + eval BKCoord4_0 * eval BKCoord5_1 + eval BKCoord4_1 * eval BKCoord5_0 =
      eval CCell1_1 := by
  calc
    _ = eval D12PiecePPCoeff1_1Product0.productValue + eval D12PiecePPCoeff1_1Product1.productValue - eval D12PiecePPCoeff1_1Product2.productValue - eval D12PiecePPCoeff1_1Product3.productValue + eval D12PiecePPCoeff1_1Product4.productValue + eval D12PiecePPCoeff1_1Product5.productValue := by
      rw [D12PiecePPCoeff1_1Product0.eval_product, D12PiecePPCoeff1_1Product1.eval_product, D12PiecePPCoeff1_1Product2.eval_product, D12PiecePPCoeff1_1Product3.eval_product, D12PiecePPCoeff1_1Product4.eval_product, D12PiecePPCoeff1_1Product5.eval_product]
    _ = eval coefficientVec := by
      simp only [coefficientVec, eval_add, eval_sub]
    _ = _ := congrArg eval coefficientVec_eq

end V14Formalization.D12PiecePPCoeff1_1
