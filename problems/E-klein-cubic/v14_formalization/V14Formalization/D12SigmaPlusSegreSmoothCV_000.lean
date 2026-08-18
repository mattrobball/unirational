/-
Auto-generated Fplus chart Nullstellensatz identities.
-/
module

public import V14Formalization.D12SigmaPlusSegreEval
public import V14Formalization.D12SigmaPlusSegreMul
public import V14Formalization.D12SigmaPlusSegrePartials
public import V14Formalization.D12SigmaPlusSegreBezoutData
public import V14Formalization.D12PolyZReflection
public import V14Formalization.D12SigmaPlusSegreFplusZ

noncomputable section
open Matrix Polynomial
namespace V14Formalization.D12SigmaPlusSegreCore
open D12PolynomialData
open V14Formalization.D12PolyZReflection

def CV_000_0_pre : Polynomial ℚ := interpQ 1 [1]
def CV_000_0_pim : Polynomial ℚ := interpQ 1 []
theorem CV_000_0_neg_re : -CV_3_re_000 = CV_000_0_pre := by
  simp only [CV_3_re_000_def, CV_000_0_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_000_0_neg_im : -CV_3_im_000 = CV_000_0_pim := by
  simp only [CV_3_im_000_def, CV_000_0_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_000_0_mul : -CV_3_c_000 = ofLadj CV_000_0_pre CV_000_0_pim := by
  rw [CV_3_c_000_def, ofLadj_neg, CV_000_0_neg_re, CV_000_0_neg_im]

@[expose] public def CV_coeff_000 : Ki := (-CV_3_c_000)

theorem CV_coeff_000_sum :
    CV_coeff_000 = ofLadj (CV_000_0_pre) (CV_000_0_pim) := by
  simp only [CV_coeff_000, CV_000_0_mul]

def CV_000_qre : Polynomial ℚ := interpQ 1 []
def CV_000_qim : Polynomial ℚ := interpQ 1 []
theorem CV_coeff_000_poly_re :
    CV_000_0_pre = (1 : Polynomial ℚ) + Phi11 * CV_000_qre := by
  rw [phi11_interpQ]
  simp only [CV_000_0_pre, CV_000_qre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_coeff_000_poly_im :
    CV_000_0_pim = (0 : Polynomial ℚ) + Phi11 * CV_000_qim := by
  rw [phi11_interpQ]
  simp only [CV_000_0_pim, CV_000_qim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
public theorem CV_coeff_000_eq :
    CV_coeff_000 = (1 : Ki) := by
  rw [CV_coeff_000_sum, CV_coeff_000_poly_re,
    CV_coeff_000_poly_im, ofLadj_add_Phi11]
  exact ofLadj_one

end V14Formalization.D12SigmaPlusSegreCore
