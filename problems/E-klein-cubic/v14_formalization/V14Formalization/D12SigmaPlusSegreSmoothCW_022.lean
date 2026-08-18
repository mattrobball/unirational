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

def CW_022_0_pre : Polynomial ℚ := interpQ 8639957931 [4723263026558, -10331031362008, -11576060983930, -23958395392154, -42461631783768, -42417837723744, -58593797130184, -58305246702144, -57087493290264, -58441655225904, -58578262753572, -64141867210592, -48247231391564, -46865594241974, -33129097898110, -14145750410440, -13528195815850, 2647763590590, 1697864507936]
def CW_022_0_pim : Polynomial ℚ := interpQ 8639957931 [9482607641338, 18965215282676, 16432340740706, 31886074668240, 21163661273246, 21007584113754, 17789370448478, 5301146318022, 6113956279590, 5589265501174, 5271622077450, -5175060179512, -15621742436474, -13406511318228, -29384936024178, -17789916783044, -17449127993744, -12732731644836, -59795884572]
theorem CW_022_0_pre_eq :
    CW_0_re_020 * Fplus_dU_re_002 - CW_0_im_020 * Fplus_dU_im_002 = CW_022_0_pre := by
  simp only [CW_0_re_020_def, CW_0_im_020_def, Fplus_dU_re_002_def, Fplus_dU_im_002_def, CW_022_0_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_022_0_pim_eq :
    CW_0_re_020 * Fplus_dU_im_002 + CW_0_im_020 * Fplus_dU_re_002 = CW_022_0_pim := by
  simp only [CW_0_re_020_def, CW_0_im_020_def, Fplus_dU_re_002_def, Fplus_dU_im_002_def, CW_022_0_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_022_0_mul :
    CW_0_c_020 * Fplus_dU_c_002 = ofLadj CW_022_0_pre CW_022_0_pim := by
  rw [CW_0_c_020_def, Fplus_dU_c_002_def, ofLadj_mul, CW_022_0_pre_eq, CW_022_0_pim_eq]

def CW_022_1_pre : Polynomial ℚ := interpQ 8639957931 [440398234164, -477290527184, -405745553470, -1448932832480, -2524450875624, -2758561265810, -4110952611172, -3780886164248, -3395328246278, -2814092428088, -2837361565064, -3026430792276, -2360071037880, -2408346874618, -1946395413798, -1049279955142, -950662546578, 401728798784, 207155333482]
def CW_022_1_pim : Polynomial ℚ := interpQ 8639957931 [617220743674, 1234441487348, 1200950645072, 2382615291968, 1471159907514, 1716951342470, 977316091740, -98643514862, -535495992586, -287413158582, -73060576098, -432951603956, -792842631814, -544999207054, -1478581019946, -1027225694502, -1327025209872, -998703944902, 23247581286]
theorem CW_022_1_pre_eq :
    CW_1_re_020 * Fplus_dV_re_002 - CW_1_im_020 * Fplus_dV_im_002 = CW_022_1_pre := by
  simp only [CW_1_re_020_def, CW_1_im_020_def, Fplus_dV_re_002_def, Fplus_dV_im_002_def, CW_022_1_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_022_1_pim_eq :
    CW_1_re_020 * Fplus_dV_im_002 + CW_1_im_020 * Fplus_dV_re_002 = CW_022_1_pim := by
  simp only [CW_1_re_020_def, CW_1_im_020_def, Fplus_dV_re_002_def, Fplus_dV_im_002_def, CW_022_1_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_022_1_mul :
    CW_1_c_020 * Fplus_dV_c_002 = ofLadj CW_022_1_pre CW_022_1_pim := by
  rw [CW_1_c_020_def, Fplus_dV_c_002_def, ofLadj_mul, CW_022_1_pre_eq, CW_022_1_pim_eq]

def CW_022_2_pre : Polynomial ℚ := interpQ 8639957931 [867308529642, 0, 819545693556, 601133945922, 1337389561950, 1057811669190, 1057811669190, 1337389561950, 601133945922, 819545693556]
def CW_022_2_pim : Polynomial ℚ := interpQ 8639957931 [-10912868832, -21825737664, -660974680608, -219373945188, -669715128894, 336309309504, -358135047168, 647889391230, 197548207524, 639148942944]
theorem CW_022_2_pre_eq :
    CW_2_re_020 * Fplus_dW_re_002 - CW_2_im_020 * Fplus_dW_im_002 = CW_022_2_pre := by
  simp only [CW_2_re_020_def, CW_2_im_020_def, Fplus_dW_re_002_def, Fplus_dW_im_002_def, CW_022_2_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_022_2_pim_eq :
    CW_2_re_020 * Fplus_dW_im_002 + CW_2_im_020 * Fplus_dW_re_002 = CW_022_2_pim := by
  simp only [CW_2_re_020_def, CW_2_im_020_def, Fplus_dW_re_002_def, Fplus_dW_im_002_def, CW_022_2_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_022_2_mul :
    CW_2_c_020 * Fplus_dW_c_002 = ofLadj CW_022_2_pre CW_022_2_pim := by
  rw [CW_2_c_020_def, Fplus_dW_c_002_def, ofLadj_mul, CW_022_2_pre_eq, CW_022_2_pim_eq]

theorem CW_022_3_mul : CW_3_c_021 = ofLadj CW_3_re_021 CW_3_im_021 := CW_3_c_021_def

@[expose] public def CW_coeff_022 : Ki := CW_0_c_020 * Fplus_dU_c_002 + CW_1_c_020 * Fplus_dV_c_002 + CW_2_c_020 * Fplus_dW_c_002 + CW_3_c_021

theorem CW_coeff_022_sum :
    CW_coeff_022 = ofLadj (CW_022_0_pre + CW_022_1_pre + CW_022_2_pre + CW_3_re_021) (CW_022_0_pim + CW_022_1_pim + CW_022_2_pim + CW_3_im_021) := by
  simp only [CW_coeff_022, CW_022_0_mul, CW_022_1_mul, CW_022_2_mul, CW_022_3_mul]
  simpa [add_assoc] using ofLadj_add4 CW_022_0_pre CW_022_0_pim CW_022_1_pre CW_022_1_pim CW_022_2_pre CW_022_2_pim CW_3_re_021 CW_3_im_021

def CW_022_qre : Polynomial ℚ := interpQ 8639957931 [5752673684232, -16560995573424, -1333361312852, -14198447804684, -19880462946326, -716172003154, -17528350751802, 1144472547956, 1905019841418]
def CW_022_qim : Polynomial ℚ := interpQ 8639957931 [10806573284820, 10806573284820, -2463074543006, 16912006518842, -12046374566578, -40989273930, -5044717613878, -13694887286452, -36548303286]
theorem CW_coeff_022_poly_re :
    CW_022_0_pre + CW_022_1_pre + CW_022_2_pre + CW_3_re_021 = (0 : Polynomial ℚ) + Phi11 * CW_022_qre := by
  rw [phi11_interpQ]
  simp only [CW_022_0_pre, CW_022_1_pre, CW_022_2_pre, CW_3_re_021_def, CW_022_qre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_coeff_022_poly_im :
    CW_022_0_pim + CW_022_1_pim + CW_022_2_pim + CW_3_im_021 = (0 : Polynomial ℚ) + Phi11 * CW_022_qim := by
  rw [phi11_interpQ]
  simp only [CW_022_0_pim, CW_022_1_pim, CW_022_2_pim, CW_3_im_021_def, CW_022_qim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
public theorem CW_coeff_022_eq :
    CW_coeff_022 = (0 : Ki) := by
  rw [CW_coeff_022_sum, CW_coeff_022_poly_re,
    CW_coeff_022_poly_im, ofLadj_add_Phi11]
  exact ofLadj_zero

end V14Formalization.D12SigmaPlusSegreCore
