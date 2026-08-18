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

def CV_004_0_pre : Polynomial ℚ := interpQ 8639957931 [-123401201950788, -2005841983049520, -4004812981289040, -6502342120435826, -9879947327087552, -11943720097526374, -13826671102608190, -15080919901723538, -14827953457452556, -15027098726411248, -15178942185251458, -15112341004719292, -13173100202201938, -11022285745122208, -8325611337016730, -4765172100345498, -2592639641761168, -709688636679352, 435800474290488]
def CV_004_0_pim : Polynomial ℚ := interpQ 8639957931 [1436492904950628, 2872985809901256, 3502064868926136, 4374127870863298, 3799448300943096, 2286407422292562, 1114588240972928, -993651070944020, -2211799677855302, -2240291329564636, -2372038451553014, -4001464396726552, -5630890341900090, -6391716522913348, -7292271176559844, -6634192511850612, -4951832934572374, -3579105712244964, -1301547701700312]
theorem CV_004_0_pre_eq :
    CV_0_re_002 * Fplus_dU_re_002 - CV_0_im_002 * Fplus_dU_im_002 = CV_004_0_pre := by
  simp only [CV_0_re_002_def, CV_0_im_002_def, Fplus_dU_re_002_def, Fplus_dU_im_002_def, CV_004_0_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_004_0_pim_eq :
    CV_0_re_002 * Fplus_dU_im_002 + CV_0_im_002 * Fplus_dU_re_002 = CV_004_0_pim := by
  simp only [CV_0_re_002_def, CV_0_im_002_def, Fplus_dU_re_002_def, Fplus_dU_im_002_def, CV_004_0_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_004_0_mul :
    CV_0_c_002 * Fplus_dU_c_002 = ofLadj CV_004_0_pre CV_004_0_pim := by
  rw [CV_0_c_002_def, Fplus_dU_c_002_def, ofLadj_mul, CV_004_0_pre_eq, CV_004_0_pim_eq]

def CV_004_1_pre : Polynomial ℚ := interpQ 8639957931 [9097438588078, -217241626093000, -464083499249648, -792624994442568, -1261984710951050, -1632786589509630, -1922881863277006, -2008768681095482, -1815488315286866, -1679534397661064, -1575587907597896, -1546058900725428, -1358346281504896, -1215450898411416, -1022863320844298, -678552208175984, -382013944702540, -91918670935164, 68231761968448]
def CV_004_1_pim : Polynomial ℚ := interpQ 8639957931 [233093587370832, 466187174741664, 578197342152560, 733789240048240, 718857776694028, 507160560792470, 214353342567256, -188182003182790, -410890188697918, -391297530144386, -301342642020454, -402554926087772, -503767210155090, -525822489442054, -661821728784202, -704054909323522, -607879722978178, -452556857815428, -165543541621596]
theorem CV_004_1_pre_eq :
    CV_1_re_002 * Fplus_dV_re_002 - CV_1_im_002 * Fplus_dV_im_002 = CV_004_1_pre := by
  simp only [CV_1_re_002_def, CV_1_im_002_def, Fplus_dV_re_002_def, Fplus_dV_im_002_def, CV_004_1_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_004_1_pim_eq :
    CV_1_re_002 * Fplus_dV_im_002 + CV_1_im_002 * Fplus_dV_re_002 = CV_004_1_pim := by
  simp only [CV_1_re_002_def, CV_1_im_002_def, Fplus_dV_re_002_def, Fplus_dV_im_002_def, CV_004_1_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_004_1_mul :
    CV_1_c_002 * Fplus_dV_c_002 = ofLadj CV_004_1_pre CV_004_1_pim := by
  rw [CV_1_c_002_def, Fplus_dV_c_002_def, ofLadj_mul, CV_004_1_pre_eq, CV_004_1_pim_eq]

def CV_004_2_pre : Polynomial ℚ := interpQ 8639957931 [18173575958076, 0, -47896968777042, -111088320109932, -168873746289270, -203369819349642, -203369819349642, -168873746289270, -111088320109932, -47896968777042]
def CV_004_2_pim : Polynomial ℚ := interpQ 8639957931 [61051736919396, 122103473838792, 163895707703238, 172794700859040, 146560249963542, 92763580892052, 29339892946740, -24456776124750, -50691227020248, -41792233864446]
theorem CV_004_2_pre_eq :
    CV_2_re_002 * Fplus_dW_re_002 - CV_2_im_002 * Fplus_dW_im_002 = CV_004_2_pre := by
  simp only [CV_2_re_002_def, CV_2_im_002_def, Fplus_dW_re_002_def, Fplus_dW_im_002_def, CV_004_2_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_004_2_pim_eq :
    CV_2_re_002 * Fplus_dW_im_002 + CV_2_im_002 * Fplus_dW_re_002 = CV_004_2_pim := by
  simp only [CV_2_re_002_def, CV_2_im_002_def, Fplus_dW_re_002_def, Fplus_dW_im_002_def, CV_004_2_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_004_2_mul :
    CV_2_c_002 * Fplus_dW_c_002 = ofLadj CV_004_2_pre CV_004_2_pim := by
  rw [CV_2_c_002_def, Fplus_dW_c_002_def, ofLadj_mul, CV_004_2_pre_eq, CV_004_2_pim_eq]

@[expose] public def CV_coeff_004 : Ki := CV_0_c_002 * Fplus_dU_c_002 + CV_1_c_002 * Fplus_dV_c_002 + CV_2_c_002 * Fplus_dW_c_002

theorem CV_coeff_004_sum :
    CV_coeff_004 = ofLadj (CV_004_0_pre + CV_004_1_pre + CV_004_2_pre) (CV_004_0_pim + CV_004_1_pim + CV_004_2_pim) := by
  simp only [CV_coeff_004, CV_004_0_mul, CV_004_1_mul, CV_004_2_mul]
  simpa [add_assoc] using ofLadj_add3 CV_004_0_pre CV_004_0_pim CV_004_1_pre CV_004_1_pim CV_004_2_pre CV_004_2_pim

def CV_004_qre : Polynomial ℚ := interpQ 8639957931 [-96130187404634, -2126953421737886, -2293709840173210, -2889261985672596, -3904750349339546, -2469070722057774, -2173046278849192, -1305639543873452, 504032236258936]
def CV_004_qim : Polynomial ℚ := interpQ 8639957931 [1730638229240856, 1730638229240856, 782881460300222, 1036553892988644, -615845484169912, -1778534763623582, -1528050087490160, -2564571326738484, -1467091243321908]
theorem CV_coeff_004_poly_re :
    CV_004_0_pre + CV_004_1_pre + CV_004_2_pre = (0 : Polynomial ℚ) + Phi11 * CV_004_qre := by
  rw [phi11_interpQ]
  simp only [CV_004_0_pre, CV_004_1_pre, CV_004_2_pre, CV_004_qre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_coeff_004_poly_im :
    CV_004_0_pim + CV_004_1_pim + CV_004_2_pim = (0 : Polynomial ℚ) + Phi11 * CV_004_qim := by
  rw [phi11_interpQ]
  simp only [CV_004_0_pim, CV_004_1_pim, CV_004_2_pim, CV_004_qim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
public theorem CV_coeff_004_eq :
    CV_coeff_004 = (0 : Ki) := by
  rw [CV_coeff_004_sum, CV_coeff_004_poly_re,
    CV_coeff_004_poly_im, ofLadj_add_Phi11]
  exact ofLadj_zero

end V14Formalization.D12SigmaPlusSegreCore
