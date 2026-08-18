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

def CU_000_0_pre : Polynomial ℚ := C (1)
def CU_000_0_pim : Polynomial ℚ := (0 : Polynomial ℚ)
theorem CU_000_0_neg_re : -CU_3_re_000 = CU_000_0_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_3_re_000, CU_000_0_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CU_000_0_neg_im : -CU_3_im_000 = CU_000_0_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_3_im_000, CU_000_0_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CU_000_0_mul : -CU_3_c_000 = ofLadj CU_000_0_pre CU_000_0_pim := by
  rw [CU_3_c_000, ofLadj_neg, CU_000_0_neg_re, CU_000_0_neg_im]

@[expose] public def CU_coeff_000 : Ki := (-CU_3_c_000)

theorem CU_coeff_000_sum :
    CU_coeff_000 = ofLadj (CU_000_0_pre) (CU_000_0_pim) := by
  simp only [CU_coeff_000, CU_000_0_mul]

def CU_000_qre : Polynomial ℚ := (0 : Polynomial ℚ)
def CU_000_qim : Polynomial ℚ := (0 : Polynomial ℚ)
theorem CU_coeff_000_poly_re :
    CU_000_0_pre = (1 : Polynomial ℚ) + Phi11 * CU_000_qre := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [CU_000_0_pre, CU_000_qre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try grind
theorem CU_coeff_000_poly_im :
    CU_000_0_pim = (0 : Polynomial ℚ) + Phi11 * CU_000_qim := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [CU_000_0_pim, CU_000_qim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try grind
public theorem CU_coeff_000_eq :
    CU_coeff_000 = (1 : Ki) := by
  rw [CU_coeff_000_sum, CU_coeff_000_poly_re,
    CU_coeff_000_poly_im, ofLadj_add_Phi11]
  exact ofLadj_one

end V14Formalization.D12SigmaPlusSegreCore
