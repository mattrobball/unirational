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

def CW_000_0_pre : Polynomial ℚ := C (1)
def CW_000_0_pim : Polynomial ℚ := (0 : Polynomial ℚ)
theorem CW_000_0_neg_re : -CW_3_re_000 = CW_000_0_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_3_re_000, CW_000_0_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CW_000_0_neg_im : -CW_3_im_000 = CW_000_0_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_3_im_000, CW_000_0_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CW_000_0_mul : -CW_3_c_000 = ofLadj CW_000_0_pre CW_000_0_pim := by
  rw [CW_3_c_000, ofLadj_neg, CW_000_0_neg_re, CW_000_0_neg_im]

@[expose] public def CW_coeff_000 : Ki := (-CW_3_c_000)

theorem CW_coeff_000_sum :
    CW_coeff_000 = ofLadj (CW_000_0_pre) (CW_000_0_pim) := by
  simp only [CW_coeff_000, CW_000_0_mul]

def CW_000_qre : Polynomial ℚ := (0 : Polynomial ℚ)
def CW_000_qim : Polynomial ℚ := (0 : Polynomial ℚ)
theorem CW_coeff_000_poly_re :
    CW_000_0_pre = (1 : Polynomial ℚ) + Phi11 * CW_000_qre := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [CW_000_0_pre, CW_000_qre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try grind
theorem CW_coeff_000_poly_im :
    CW_000_0_pim = (0 : Polynomial ℚ) + Phi11 * CW_000_qim := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [CW_000_0_pim, CW_000_qim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try grind
public theorem CW_coeff_000_eq :
    CW_coeff_000 = (1 : Ki) := by
  rw [CW_coeff_000_sum, CW_coeff_000_poly_re,
    CW_coeff_000_poly_im, ofLadj_add_Phi11]
  exact ofLadj_one

end V14Formalization.D12SigmaPlusSegreCore
