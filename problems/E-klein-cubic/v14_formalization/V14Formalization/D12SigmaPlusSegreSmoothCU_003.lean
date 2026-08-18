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

def CU_003_0_pre : Polynomial ℚ := interpQ 235794999 [136581799300856, 2227842562057952, 4447848059259520, 7223977610714220, 10975955448106828, 13267772483863006, 15360897474816748, 16753705900030372, 16471901566083138, 16693103535702990, 16861922623893902, 16788267263393632, 14634080061835950, 12245255476443470, 9247923955368918, 5292704200741572, 2880133216751460, 787008225797718, -485046251181972]
def CU_003_0_pim : Polynomial ℚ := interpQ 235794999 [-1595665164652080, -3191330329304160, -3890647037542668, -4859666692975240, -4219891972262696, -2539574063329174, -1237911466862796, 1106188922906024, 2458920311297974, 2490744600860306, 2637088771718834, 4447103954372160, 6257119137025486, 7102780016122522, 8103623961117426, 7370980687577260, 5502711109408844, 3977652000223286, 1445599941219572]
theorem CU_003_0_pre_eq :
    CU_0_re_001 * Fplus_dU_re_002 - CU_0_im_001 * Fplus_dU_im_002 = CU_003_0_pre := by
  simp only [CU_0_re_001_def, CU_0_im_001_def, Fplus_dU_re_002_def, Fplus_dU_im_002_def, CU_003_0_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_003_0_pim_eq :
    CU_0_re_001 * Fplus_dU_im_002 + CU_0_im_001 * Fplus_dU_re_002 = CU_003_0_pim := by
  simp only [CU_0_re_001_def, CU_0_im_001_def, Fplus_dU_re_002_def, Fplus_dU_im_002_def, CU_003_0_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_003_0_mul :
    CU_0_c_001 * Fplus_dU_c_002 = ofLadj CU_003_0_pre CU_003_0_pim := by
  rw [CU_0_c_001_def, Fplus_dU_c_002_def, ofLadj_mul, CU_003_0_pre_eq, CU_003_0_pim_eq]

def CU_003_1_pre : Polynomial ℚ := interpQ 235794999 [-9487068846864, 217317998116224, 463929987165656, 792777512924450, 1262283874507966, 1633271307692194, 1923511167334940, 2009411783502128, 1815881739359786, 1679766421242966, 1575858000830762, 1546605844774628, 1358540002714538, 1215836434077310, 1023104226435336, 678674962635838, 382022438727262, 91782579084516, -68452946358324]
def CU_003_1_pim : Polynomial ℚ := interpQ 235794999 [-233272140210204, -466544280420408, -578544947491052, -734339678342386, -719482007020330, -507528231615818, -214853716038764, 188272699699792, 410854129738242, 391278734340062, 301229234008594, 402571062725244, 503912891441894, 525864058181070, 662083393634224, 704359516773550, 608076244131834, 452903548552828, 165447635577068]
theorem CU_003_1_pre_eq :
    CU_1_re_001 * Fplus_dV_re_002 - CU_1_im_001 * Fplus_dV_im_002 = CU_003_1_pre := by
  simp only [CU_1_re_001_def, CU_1_im_001_def, Fplus_dV_re_002_def, Fplus_dV_im_002_def, CU_003_1_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_003_1_pim_eq :
    CU_1_re_001 * Fplus_dV_im_002 + CU_1_im_001 * Fplus_dV_re_002 = CU_003_1_pim := by
  simp only [CU_1_re_001_def, CU_1_im_001_def, Fplus_dV_re_002_def, Fplus_dV_im_002_def, CU_003_1_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_003_1_mul :
    CU_1_c_001 * Fplus_dV_c_002 = ofLadj CU_003_1_pre CU_003_1_pim := by
  rw [CU_1_c_001_def, Fplus_dV_c_002_def, ofLadj_mul, CU_003_1_pre_eq, CU_003_1_pim_eq]

def CU_003_2_pre : Polynomial ℚ := interpQ 235794999 [-12656890734900, 0, 33966252082404, 78528913174092, 119449477806492, 143737110640518, 143737110640518, 119449477806492, 78528913174092, 33966252082404]
def CU_003_2_pim : Polynomial ℚ := interpQ 235794999 [-43138230865452, -86276461730904, -115757576132700, -122180181969348, -103452123131700, -65616785976978, -20659675753926, 17175661400796, 35903720238444, 29481114401796]
theorem CU_003_2_pre_eq :
    CU_2_re_001 * Fplus_dW_re_002 - CU_2_im_001 * Fplus_dW_im_002 = CU_003_2_pre := by
  simp only [CU_2_re_001_def, CU_2_im_001_def, Fplus_dW_re_002_def, Fplus_dW_im_002_def, CU_003_2_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_003_2_pim_eq :
    CU_2_re_001 * Fplus_dW_im_002 + CU_2_im_001 * Fplus_dW_re_002 = CU_003_2_pim := by
  simp only [CU_2_re_001_def, CU_2_im_001_def, Fplus_dW_re_002_def, Fplus_dW_im_002_def, CU_003_2_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_003_2_mul :
    CU_2_c_001 * Fplus_dW_c_002 = ofLadj CU_003_2_pre CU_003_2_pim := by
  rw [CU_2_c_001_def, Fplus_dW_c_002_def, ofLadj_mul, CU_003_2_pre_eq, CU_003_2_pim_eq]

def CU_003_3_pre : Polynomial ℚ := interpQ 235794999 [-11530323162688, 0, 30944415696304, 71468406107648, 108712660925968, 130844067050224, 130844067050224, 108712660925968, 71468406107648, 30944415696304]
def CU_003_3_pim : Polynomial ℚ := interpQ 235794999 [-39281475642240, -78562951284480, -105376507409744, -111202795737248, -94196096208656, -59750266891280, -18812684393200, 15633144924176, 32639844452768, 26813556125264]
theorem CU_003_3_neg_re : -CU_3_re_003 = CU_003_3_pre := by
  simp only [CU_3_re_003_def, CU_003_3_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_003_3_neg_im : -CU_3_im_003 = CU_003_3_pim := by
  simp only [CU_3_im_003_def, CU_003_3_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_003_3_mul : -CU_3_c_003 = ofLadj CU_003_3_pre CU_003_3_pim := by
  rw [CU_3_c_003_def, ofLadj_neg, CU_003_3_neg_re, CU_003_3_neg_im]

@[expose] public def CU_coeff_003 : Ki := CU_0_c_001 * Fplus_dU_c_002 + CU_1_c_001 * Fplus_dV_c_002 + CU_2_c_001 * Fplus_dW_c_002 + (-CU_3_c_003)

theorem CU_coeff_003_sum :
    CU_coeff_003 = ofLadj (CU_003_0_pre + CU_003_1_pre + CU_003_2_pre + CU_003_3_pre) (CU_003_0_pim + CU_003_1_pim + CU_003_2_pim + CU_003_3_pim) := by
  simp only [CU_coeff_003, CU_003_0_mul, CU_003_1_mul, CU_003_2_mul, CU_003_3_mul]
  simpa [add_assoc] using ofLadj_add4 CU_003_0_pre CU_003_0_pim CU_003_1_pre CU_003_1_pim CU_003_2_pre CU_003_2_pim CU_003_3_pre CU_003_3_pim

def CU_003_qre : Polynomial ℚ := interpQ 235794999 [102907516556404, 2342253043617772, 2531528154029708, 3190063728716526, 4299649018426844, 2709223507898688, 2383364850596488, 1432290002422530, -553499197540296]
def CU_003_qim : Polynomial ℚ := interpQ 235794999 [-1911357011369976, -1911357011369976, -867612045836212, -1137063280448058, 690367150400840, 1964552850810132, 1680231804764564, 2819507971979474, 1611047576796640]
theorem CU_coeff_003_poly_re :
    CU_003_0_pre + CU_003_1_pre + CU_003_2_pre + CU_003_3_pre = (0 : Polynomial ℚ) + Phi11 * CU_003_qre := by
  rw [phi11_interpQ]
  simp only [CU_003_0_pre, CU_003_1_pre, CU_003_2_pre, CU_003_3_pre, CU_003_qre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_coeff_003_poly_im :
    CU_003_0_pim + CU_003_1_pim + CU_003_2_pim + CU_003_3_pim = (0 : Polynomial ℚ) + Phi11 * CU_003_qim := by
  rw [phi11_interpQ]
  simp only [CU_003_0_pim, CU_003_1_pim, CU_003_2_pim, CU_003_3_pim, CU_003_qim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
public theorem CU_coeff_003_eq :
    CU_coeff_003 = (0 : Ki) := by
  rw [CU_coeff_003_sum, CU_coeff_003_poly_re,
    CU_coeff_003_poly_im, ofLadj_add_Phi11]
  exact ofLadj_zero

end V14Formalization.D12SigmaPlusSegreCore
