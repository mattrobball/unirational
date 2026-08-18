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

def CV_000_0_pre : Polynomial ℚ := C (1)
def CV_000_0_pim : Polynomial ℚ := (0 : Polynomial ℚ)
theorem CV_000_0_neg_re : -CV_3_re_000 = CV_000_0_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_3_re_000_def, CV_000_0_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CV_000_0_neg_im : -CV_3_im_000 = CV_000_0_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_3_im_000_def, CV_000_0_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CV_000_0_mul : -CV_3_c_000 = ofLadj CV_000_0_pre CV_000_0_pim := by
  rw [CV_3_c_000_def, ofLadj_neg, CV_000_0_neg_re, CV_000_0_neg_im]

@[expose] public def CV_coeff_000 : Ki := (-CV_3_c_000)

theorem CV_coeff_000_sum :
    CV_coeff_000 = ofLadj (CV_000_0_pre) (CV_000_0_pim) := by
  simp only [CV_coeff_000, CV_000_0_mul]

def CV_000_qre : Polynomial ℚ := (0 : Polynomial ℚ)
def CV_000_qim : Polynomial ℚ := (0 : Polynomial ℚ)
theorem CV_coeff_000_poly_re :
    CV_000_0_pre = (1 : Polynomial ℚ) + Phi11 * CV_000_qre := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [CV_000_0_pre, CV_000_qre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try grind
theorem CV_coeff_000_poly_im :
    CV_000_0_pim = (0 : Polynomial ℚ) + Phi11 * CV_000_qim := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [CV_000_0_pim, CV_000_qim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try grind
public theorem CV_coeff_000_eq :
    CV_coeff_000 = (1 : Ki) := by
  rw [CV_coeff_000_sum, CV_coeff_000_poly_re,
    CV_coeff_000_poly_im, ofLadj_add_Phi11]
  exact ofLadj_one

end V14Formalization.D12SigmaPlusSegreCore
