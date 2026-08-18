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

def CU_000_0_pre : Polynomial ℚ := interpQ 1 [1]
def CU_000_0_pim : Polynomial ℚ := interpQ 1 []
theorem CU_000_0_neg_re : -CU_3_re_000 = CU_000_0_pre := by
  simp only [CU_3_re_000_def, CU_000_0_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_000_0_neg_im : -CU_3_im_000 = CU_000_0_pim := by
  simp only [CU_3_im_000_def, CU_000_0_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_000_0_mul : -CU_3_c_000 = ofLadj CU_000_0_pre CU_000_0_pim := by
  rw [CU_3_c_000_def, ofLadj_neg, CU_000_0_neg_re, CU_000_0_neg_im]

@[expose] public def CU_coeff_000 : Ki := (-CU_3_c_000)

theorem CU_coeff_000_sum :
    CU_coeff_000 = ofLadj (CU_000_0_pre) (CU_000_0_pim) := by
  simp only [CU_coeff_000, CU_000_0_mul]

def CU_000_qre : Polynomial ℚ := interpQ 1 []
def CU_000_qim : Polynomial ℚ := interpQ 1 []
theorem CU_coeff_000_poly_re :
    CU_000_0_pre = (1 : Polynomial ℚ) + Phi11 * CU_000_qre := by
  rw [phi11_interpQ]
  simp only [CU_000_0_pre, CU_000_qre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_coeff_000_poly_im :
    CU_000_0_pim = (0 : Polynomial ℚ) + Phi11 * CU_000_qim := by
  rw [phi11_interpQ]
  simp only [CU_000_0_pim, CU_000_qim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
public theorem CU_coeff_000_eq :
    CU_coeff_000 = (1 : Ki) := by
  rw [CU_coeff_000_sum, CU_coeff_000_poly_re,
    CU_coeff_000_poly_im, ofLadj_add_Phi11]
  exact ofLadj_one

end V14Formalization.D12SigmaPlusSegreCore
