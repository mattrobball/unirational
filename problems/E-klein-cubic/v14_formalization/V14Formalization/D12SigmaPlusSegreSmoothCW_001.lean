/-
Auto-generated Fplus chart Nullstellensatz identities.
-/
import V14Formalization.D12SigmaPlusSegreEval
import V14Formalization.D12SigmaPlusSegreMul
import V14Formalization.D12SigmaPlusSegrePartials
import V14Formalization.D12SigmaPlusSegreBezoutData

noncomputable section
open Matrix Polynomial
namespace V14Formalization.D12SigmaPlusSegreCore
open D12PolynomialData

def CW_001_0_pre : Polynomial ℚ := C (1)
def CW_001_0_pim : Polynomial ℚ := (0 : Polynomial ℚ)
theorem CW_001_0_neg_re : -CW_3_re_001 = CW_001_0_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_3_re_001, CW_001_0_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CW_001_0_neg_im : -CW_3_im_001 = CW_001_0_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_3_im_001, CW_001_0_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CW_001_0_mul : -CW_3_c_001 = ofLadj CW_001_0_pre CW_001_0_pim := by
  rw [CW_3_c_001, ofLadj_neg, CW_001_0_neg_re, CW_001_0_neg_im]

theorem CW_001_1_mul : CW_3_c_000 = ofLadj CW_3_re_000 CW_3_im_000 := rfl

def CW_coeff_001 : Ki := (-CW_3_c_001) + CW_3_c_000

theorem CW_coeff_001_sum :
    CW_coeff_001 = ofLadj (CW_001_0_pre + CW_3_re_000) (CW_001_0_pim + CW_3_im_000) := by
  simp only [CW_coeff_001, CW_001_0_mul, CW_001_1_mul]
  simpa [add_assoc] using ofLadj_add CW_001_0_pre CW_001_0_pim CW_3_re_000 CW_3_im_000

def CW_001_qre : Polynomial ℚ := (0 : Polynomial ℚ)
def CW_001_qim : Polynomial ℚ := (0 : Polynomial ℚ)
theorem CW_coeff_001_poly_re :
    CW_001_0_pre + CW_3_re_000 = (0 : Polynomial ℚ) + Phi11 * CW_001_qre := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [CW_001_0_pre, CW_3_re_000, CW_001_qre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try ring
theorem CW_coeff_001_poly_im :
    CW_001_0_pim + CW_3_im_000 = (0 : Polynomial ℚ) + Phi11 * CW_001_qim := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [CW_001_0_pim, CW_3_im_000, CW_001_qim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try ring
theorem CW_coeff_001_eq :
    CW_coeff_001 = (0 : Ki) := by
  rw [CW_coeff_001_sum, CW_coeff_001_poly_re,
    CW_coeff_001_poly_im, ofLadj_add_Phi11]
  exact ofLadj_zero

end V14Formalization.D12SigmaPlusSegreCore
