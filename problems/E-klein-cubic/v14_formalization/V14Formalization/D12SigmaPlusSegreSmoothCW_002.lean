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

def CW_002_0_pre : Polynomial ℚ := interpQ 17279915862 [4692932737111, 87771278064820, 174213886871953, 285246812635047, 433719012066076, 522492057600616, 607373181215784, 661032682882565, 649331607482129, 658210324057674, 664768840543100, 662633042375918, 576997562478280, 483996437185721, 364084794847082, 207591992394675, 114024945739148, 29143822123980, -19721678421814]
def CW_002_0_pim : Polynomial ℚ := interpQ 17279915862 [-63132682344651, -126265364689302, -153795135239919, -193672238766536, -166026278626739, -101203088067831, -49602246954095, 44641497225218, 97100649975437, 98471311582219, 104265108284266, 175862379268446, 247459650252626, 280783217505290, 322030982638689, 290595489450339, 218393594008187, 157871134861329, 56248685798772]
theorem CW_002_0_pre_eq :
    CW_0_re_000 * Fplus_dU_re_002 - CW_0_im_000 * Fplus_dU_im_002 = CW_002_0_pre := by
  simp only [CW_0_re_000_def, CW_0_im_000_def, Fplus_dU_re_002_def, Fplus_dU_im_002_def, CW_002_0_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_002_0_pim_eq :
    CW_0_re_000 * Fplus_dU_im_002 + CW_0_im_000 * Fplus_dU_re_002 = CW_002_0_pim := by
  simp only [CW_0_re_000_def, CW_0_im_000_def, Fplus_dU_re_002_def, Fplus_dU_im_002_def, CW_002_0_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_002_0_mul :
    CW_0_c_000 * Fplus_dU_c_002 = ofLadj CW_002_0_pre CW_002_0_pim := by
  rw [CW_0_c_000_def, Fplus_dU_c_002_def, ofLadj_mul, CW_002_0_pre_eq, CW_002_0_pim_eq]

def CW_002_1_pre : Polynomial ℚ := interpQ 17279915862 [-608899371653, 8689952081260, 18392516499285, 31434160165210, 50213620196001, 64924899103398, 76620314385995, 79826470467445, 72184385899500, 66771522617594, 62689920056268, 61644839454622, 53999967975008, 48379006118309, 40750225734290, 26914022593963, 15278164537949, 3582749255352, -2698827677481]
def CW_002_1_pim : Polynomial ℚ := interpQ 17279915862 [-9385298929252, -18770597858504, -23019006393526, -29549697970620, -28792929912219, -20460706993374, -8765251159045, 7261001153642, 16112930103636, 15252315192664, 11693776654189, 15836035190142, 19978293726095, 20668163722642, 26338240388764, 27898550500780, 24116566961982, 18010863712217, 6534850779577]
theorem CW_002_1_pre_eq :
    CW_1_re_000 * Fplus_dV_re_002 - CW_1_im_000 * Fplus_dV_im_002 = CW_002_1_pre := by
  simp only [CW_1_re_000_def, CW_1_im_000_def, Fplus_dV_re_002_def, Fplus_dV_im_002_def, CW_002_1_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_002_1_pim_eq :
    CW_1_re_000 * Fplus_dV_im_002 + CW_1_im_000 * Fplus_dV_re_002 = CW_002_1_pim := by
  simp only [CW_1_re_000_def, CW_1_im_000_def, Fplus_dV_re_002_def, Fplus_dV_im_002_def, CW_002_1_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_002_1_mul :
    CW_1_c_000 * Fplus_dV_c_002 = ofLadj CW_002_1_pre CW_002_1_pim := by
  rw [CW_1_c_000_def, Fplus_dV_c_002_def, ofLadj_mul, CW_002_1_pre_eq, CW_002_1_pim_eq]

def CW_002_2_pre : Polynomial ℚ := interpQ 17279915862 [-885874680768, 0, 2476913924100, 5942767217739, 9020113348653, 10738693618257, 10738693618257, 9020113348653, 5942767217739, 2476913924100]
def CW_002_2_pim : Polynomial ℚ := interpQ 17279915862 [-3221548246230, -6443096492460, -8678354656032, -9188401351842, -7715946473706, -4887480970509, -1555615521951, 1272849981246, 2745304859382, 2235258163572]
theorem CW_002_2_pre_eq :
    CW_2_re_000 * Fplus_dW_re_002 - CW_2_im_000 * Fplus_dW_im_002 = CW_002_2_pre := by
  simp only [CW_2_re_000_def, CW_2_im_000_def, Fplus_dW_re_002_def, Fplus_dW_im_002_def, CW_002_2_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_002_2_pim_eq :
    CW_2_re_000 * Fplus_dW_im_002 + CW_2_im_000 * Fplus_dW_re_002 = CW_002_2_pim := by
  simp only [CW_2_re_000_def, CW_2_im_000_def, Fplus_dW_re_002_def, Fplus_dW_im_002_def, CW_002_2_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_002_2_mul :
    CW_2_c_000 * Fplus_dW_c_002 = ofLadj CW_002_2_pre CW_002_2_pim := by
  rw [CW_2_c_000_def, Fplus_dW_c_002_def, ofLadj_mul, CW_002_2_pre_eq, CW_002_2_pim_eq]

theorem CW_002_3_mul : CW_3_c_001 = ofLadj CW_3_re_001 CW_3_im_001 := CW_3_c_001_def

@[expose] public def CW_coeff_002 : Ki := CW_0_c_000 * Fplus_dU_c_002 + CW_1_c_000 * Fplus_dV_c_002 + CW_2_c_000 * Fplus_dW_c_002 + CW_3_c_001

theorem CW_coeff_002_sum :
    CW_coeff_002 = ofLadj (CW_002_0_pre + CW_002_1_pre + CW_002_2_pre + CW_3_re_001) (CW_002_0_pim + CW_002_1_pim + CW_002_2_pim + CW_3_im_001) := by
  simp only [CW_coeff_002, CW_002_0_mul, CW_002_1_mul, CW_002_2_mul, CW_002_3_mul]
  simpa [add_assoc] using ofLadj_add4 CW_002_0_pre CW_002_0_pim CW_002_1_pre CW_002_1_pim CW_002_2_pre CW_002_2_pim CW_3_re_001 CW_3_im_001

def CW_002_qre : Polynomial ℚ := interpQ 17279915862 [3180878768828, 93280351377252, 98622087149258, 127540422722658, 170329005592734, 105202904711541, 96576538897765, 55147077478627, -22420506099295]
def CW_002_qim : Polynomial ℚ := interpQ 17279915862 [-75739529520133, -75739529520133, -34013437249211, -46917841799521, 29875183076334, 75983878980950, 66628162396623, 113098461995197, 62783536578349]
theorem CW_coeff_002_poly_re :
    CW_002_0_pre + CW_002_1_pre + CW_002_2_pre + CW_3_re_001 = (0 : Polynomial ℚ) + Phi11 * CW_002_qre := by
  rw [phi11_interpQ]
  simp only [CW_002_0_pre, CW_002_1_pre, CW_002_2_pre, CW_3_re_001_def, CW_002_qre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_coeff_002_poly_im :
    CW_002_0_pim + CW_002_1_pim + CW_002_2_pim + CW_3_im_001 = (0 : Polynomial ℚ) + Phi11 * CW_002_qim := by
  rw [phi11_interpQ]
  simp only [CW_002_0_pim, CW_002_1_pim, CW_002_2_pim, CW_3_im_001_def, CW_002_qim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
public theorem CW_coeff_002_eq :
    CW_coeff_002 = (0 : Ki) := by
  rw [CW_coeff_002_sum, CW_coeff_002_poly_re,
    CW_coeff_002_poly_im, ofLadj_add_Phi11]
  exact ofLadj_zero

end V14Formalization.D12SigmaPlusSegreCore
