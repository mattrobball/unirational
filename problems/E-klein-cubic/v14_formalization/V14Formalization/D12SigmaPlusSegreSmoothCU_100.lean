/-
Auto-generated Fplus chart Nullstellensatz identities.
-/
module

public import V14Formalization.D12SigmaPlusSegreEval
public import V14Formalization.D12SigmaPlusSegreMul
public import V14Formalization.D12SigmaPlusSegrePartials
public import V14Formalization.D12SigmaPlusSegreBezoutData

noncomputable section
open Matrix Polynomial
namespace V14Formalization.D12SigmaPlusSegreCore
open D12PolynomialData

def CU_100_0_pre : Polynomial ℚ := C (1)
def CU_100_0_pim : Polynomial ℚ := (0 : Polynomial ℚ)
theorem CU_100_0_neg_re : -CU_3_re_100 = CU_100_0_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_3_re_100, CU_100_0_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CU_100_0_neg_im : -CU_3_im_100 = CU_100_0_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_3_im_100, CU_100_0_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CU_100_0_mul : -CU_3_c_100 = ofLadj CU_100_0_pre CU_100_0_pim := by
  rw [CU_3_c_100, ofLadj_neg, CU_100_0_neg_re, CU_100_0_neg_im]

theorem CU_100_1_mul : CU_3_c_000 = ofLadj CU_3_re_000 CU_3_im_000 := rfl

@[expose] public def CU_coeff_100 : Ki := (-CU_3_c_100) + CU_3_c_000

theorem CU_coeff_100_sum :
    CU_coeff_100 = ofLadj (CU_100_0_pre + CU_3_re_000) (CU_100_0_pim + CU_3_im_000) := by
  simp only [CU_coeff_100, CU_100_0_mul, CU_100_1_mul]
  simpa [add_assoc] using ofLadj_add CU_100_0_pre CU_100_0_pim CU_3_re_000 CU_3_im_000

def CU_100_qre : Polynomial ℚ := (0 : Polynomial ℚ)
def CU_100_qim : Polynomial ℚ := (0 : Polynomial ℚ)
theorem CU_coeff_100_poly_re :
    CU_100_0_pre + CU_3_re_000 = (0 : Polynomial ℚ) + Phi11 * CU_100_qre := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [CU_100_0_pre, CU_3_re_000, CU_100_qre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try grind
theorem CU_coeff_100_poly_im :
    CU_100_0_pim + CU_3_im_000 = (0 : Polynomial ℚ) + Phi11 * CU_100_qim := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [CU_100_0_pim, CU_3_im_000, CU_100_qim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try grind
public theorem CU_coeff_100_eq :
    CU_coeff_100 = (0 : Ki) := by
  rw [CU_coeff_100_sum, CU_coeff_100_poly_re,
    CU_coeff_100_poly_im, ofLadj_add_Phi11]
  exact ofLadj_zero

end V14Formalization.D12SigmaPlusSegreCore
