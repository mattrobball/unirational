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

def CW_012_0_pre : Polynomial ℚ := interpQ 8639957931 [901265303960, 31247294554112, 60205660355790, 99315878094624, 151712365228925, 181032159009858, 212208355928479, 230201351171251, 226257093303775, 229452927807811, 231663284751563, 231755012100996, 200415990197451, 169247267452021, 126941215209151, 71815972619660, 40835871514906, 9659674596285, -6673013322666]
def CW_012_0_pim : Polynomial ℚ := interpQ 8639957931 [-22774985851404, -45549971702808, -54228465492860, -70081015917710, -59034533260753, -37803256468930, -20359941170001, 13039023713908, 30196490971667, 30710457991893, 32672021722813, 58446849323740, 84221676924667, 94861734445639, 111228251890715, 98765155059263, 75079400913676, 54427523669927, 18574081432254]
theorem CW_012_0_pre_eq :
    CW_0_re_010 * Fplus_dU_re_002 - CW_0_im_010 * Fplus_dU_im_002 = CW_012_0_pre := by
  simp only [CW_0_re_010_def, CW_0_im_010_def, Fplus_dU_re_002_def, Fplus_dU_im_002_def, CW_012_0_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_012_0_pim_eq :
    CW_0_re_010 * Fplus_dU_im_002 + CW_0_im_010 * Fplus_dU_re_002 = CW_012_0_pim := by
  simp only [CW_0_re_010_def, CW_0_im_010_def, Fplus_dU_re_002_def, Fplus_dU_im_002_def, CW_012_0_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_012_0_mul :
    CW_0_c_010 * Fplus_dU_c_002 = ofLadj CW_012_0_pre CW_012_0_pim := by
  rw [CW_0_c_010_def, Fplus_dU_c_002_def, ofLadj_mul, CW_012_0_pre_eq, CW_012_0_pim_eq]

def CW_012_1_pre : Polynomial ℚ := interpQ 8639957931 [-242778332419, 2482558759220, 5208847718522, 8805298832125, 14258369307344, 18537835169809, 21772893823224, 22593408843803, 20501866747799, 19011589196142, 17771364921492, 17446765042574, 15288806162272, 13802741477620, 11696567915674, 7595572895613, 4238250766422, 1003192113007, -739466640846]
def CW_012_1_pim : Polynomial ℚ := interpQ 8639957931 [-2698413264776, -5396826529552, -6515474754184, -8487239382044, -8357568607011, -5894253596247, -2483091012884, 1968782600763, 4447021726271, 4260923545202, 3309265373757, 4433477768434, 5557690163111, 5724680216298, 7510346663089, 8016260829612, 6813658111658, 5033815504789, 1842654183952]
theorem CW_012_1_pre_eq :
    CW_1_re_010 * Fplus_dV_re_002 - CW_1_im_010 * Fplus_dV_im_002 = CW_012_1_pre := by
  simp only [CW_1_re_010_def, CW_1_im_010_def, Fplus_dV_re_002_def, Fplus_dV_im_002_def, CW_012_1_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_012_1_pim_eq :
    CW_1_re_010 * Fplus_dV_im_002 + CW_1_im_010 * Fplus_dV_re_002 = CW_012_1_pim := by
  simp only [CW_1_re_010_def, CW_1_im_010_def, Fplus_dV_re_002_def, Fplus_dV_im_002_def, CW_012_1_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_012_1_mul :
    CW_1_c_010 * Fplus_dV_c_002 = ofLadj CW_012_1_pre CW_012_1_pim := by
  rw [CW_1_c_010_def, Fplus_dV_c_002_def, ofLadj_mul, CW_012_1_pre_eq, CW_012_1_pim_eq]

def CW_012_2_pre : Polynomial ℚ := interpQ 8639957931 [-293291779914, 0, -448975088064, -247364019741, -550880480355, -561967459524, -561967459524, -550880480355, -247364019741, -448975088064]
def CW_012_2_pim : Polynomial ℚ := interpQ 8639957931 [161312027460, 322624054920, 426087435693, 141615402168, 556741748619, 122749645797, 199874409123, -234117693699, 181008652752, -103463380773]
theorem CW_012_2_pre_eq :
    CW_2_re_010 * Fplus_dW_re_002 - CW_2_im_010 * Fplus_dW_im_002 = CW_012_2_pre := by
  simp only [CW_2_re_010_def, CW_2_im_010_def, Fplus_dW_re_002_def, Fplus_dW_im_002_def, CW_012_2_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_012_2_pim_eq :
    CW_2_re_010 * Fplus_dW_im_002 + CW_2_im_010 * Fplus_dW_re_002 = CW_012_2_pim := by
  simp only [CW_2_re_010_def, CW_2_im_010_def, Fplus_dW_re_002_def, Fplus_dW_im_002_def, CW_012_2_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_012_2_mul :
    CW_2_c_010 * Fplus_dW_c_002 = ofLadj CW_012_2_pre CW_012_2_pim := by
  rw [CW_2_c_010_def, Fplus_dW_c_002_def, ofLadj_mul, CW_012_2_pre_eq, CW_012_2_pim_eq]

theorem CW_012_3_mul : CW_3_c_011 = ofLadj CW_3_re_011 CW_3_im_011 := CW_3_c_011_def

@[expose] public def CW_coeff_012 : Ki := CW_0_c_010 * Fplus_dU_c_002 + CW_1_c_010 * Fplus_dV_c_002 + CW_2_c_010 * Fplus_dW_c_002 + CW_3_c_011

theorem CW_coeff_012_sum :
    CW_coeff_012 = ofLadj (CW_012_0_pre + CW_012_1_pre + CW_012_2_pre + CW_3_re_011) (CW_012_0_pim + CW_012_1_pim + CW_012_2_pim + CW_3_im_011) := by
  simp only [CW_coeff_012, CW_012_0_mul, CW_012_1_mul, CW_012_2_mul, CW_012_3_mul]
  simpa [add_assoc] using ofLadj_add4 CW_012_0_pre CW_012_0_pim CW_012_1_pre CW_012_1_pim CW_012_2_pre CW_012_2_pim CW_3_re_011 CW_3_im_011

def CW_012_qre : Polynomial ℚ := interpQ 8639957931 [232872529485, 33496980783847, 32654787430082, 44412225804816, 59226237609552, 34337423233945, 34411255572036, 18075346672804, -7412479963512]
def CW_012_qim : Polynomial ℚ := interpQ 8639957931 [-26899039995604, -26899039995604, -10807047574159, -18152183891867, 11957182664929, 24888356863541, 22431719850618, 39044603558510, 20416735616206]
theorem CW_coeff_012_poly_re :
    CW_012_0_pre + CW_012_1_pre + CW_012_2_pre + CW_3_re_011 = (0 : Polynomial ℚ) + Phi11 * CW_012_qre := by
  rw [phi11_interpQ]
  simp only [CW_012_0_pre, CW_012_1_pre, CW_012_2_pre, CW_3_re_011_def, CW_012_qre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_coeff_012_poly_im :
    CW_012_0_pim + CW_012_1_pim + CW_012_2_pim + CW_3_im_011 = (0 : Polynomial ℚ) + Phi11 * CW_012_qim := by
  rw [phi11_interpQ]
  simp only [CW_012_0_pim, CW_012_1_pim, CW_012_2_pim, CW_3_im_011_def, CW_012_qim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
public theorem CW_coeff_012_eq :
    CW_coeff_012 = (0 : Ki) := by
  rw [CW_coeff_012_sum, CW_coeff_012_poly_re,
    CW_coeff_012_poly_im, ofLadj_add_Phi11]
  exact ofLadj_zero

end V14Formalization.D12SigmaPlusSegreCore
