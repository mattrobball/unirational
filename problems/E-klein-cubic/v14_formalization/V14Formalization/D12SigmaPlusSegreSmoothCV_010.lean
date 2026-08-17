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

def CV_010_0_pre : Polynomial ℚ := C (1)
def CV_010_0_pim : Polynomial ℚ := (0 : Polynomial ℚ)
theorem CV_010_0_neg_re : -CV_3_re_010 = CV_010_0_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_3_re_010, CV_010_0_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CV_010_0_neg_im : -CV_3_im_010 = CV_010_0_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_3_im_010, CV_010_0_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CV_010_0_mul : -CV_3_c_010 = ofLadj CV_010_0_pre CV_010_0_pim := by
  rw [CV_3_c_010, ofLadj_neg, CV_010_0_neg_re, CV_010_0_neg_im]

theorem CV_010_1_mul : CV_3_c_000 = ofLadj CV_3_re_000 CV_3_im_000 := rfl

@[expose] public def CV_coeff_010 : Ki := (-CV_3_c_010) + CV_3_c_000

theorem CV_coeff_010_sum :
    CV_coeff_010 = ofLadj (CV_010_0_pre + CV_3_re_000) (CV_010_0_pim + CV_3_im_000) := by
  simp only [CV_coeff_010, CV_010_0_mul, CV_010_1_mul]
  simpa [add_assoc] using ofLadj_add CV_010_0_pre CV_010_0_pim CV_3_re_000 CV_3_im_000

def CV_010_qre : Polynomial ℚ := (0 : Polynomial ℚ)
def CV_010_qim : Polynomial ℚ := (0 : Polynomial ℚ)
theorem CV_coeff_010_poly_re :
    CV_010_0_pre + CV_3_re_000 = (0 : Polynomial ℚ) + Phi11 * CV_010_qre := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [CV_010_0_pre, CV_3_re_000, CV_010_qre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try ring
theorem CV_coeff_010_poly_im :
    CV_010_0_pim + CV_3_im_000 = (0 : Polynomial ℚ) + Phi11 * CV_010_qim := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [CV_010_0_pim, CV_3_im_000, CV_010_qim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try ring
public theorem CV_coeff_010_eq :
    CV_coeff_010 = (0 : Ki) := by
  rw [CV_coeff_010_sum, CV_coeff_010_poly_re,
    CV_coeff_010_poly_im, ofLadj_add_Phi11]
  exact ofLadj_zero

end V14Formalization.D12SigmaPlusSegreCore
