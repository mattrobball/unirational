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

def CU_201_0_pre : Polynomial ℚ := interpQ 235794999 [-105094710303408, 0, 92568738663582, 265598375981280, 816703741957002, 1371204384273909, 1942146991840068, 2405952477081945, 2581320555370467, 2656272725781219, 2713496200352742, 2839906452915024, 2713496200352742, 2563703987117637, 2315722179389187, 1695734376957579, 1100311857842178, 529369250276019, 106485641832636]
def CU_201_0_pim : Polynomial ℚ := interpQ 235794999 [-358046126045028, -716092252090056, -1164262348949424, -1772032812589194, -2147570667022770, -2327310931302063, -2375124414816750, -2029433313954831, -1803897108930009, -1793120623673601, -1743523421188080, -1312835795498436, -882148169808792, -384380870463903, 234166078432275, 578243775643395, 694278346717692, 666393156314193, 256996362247278]
theorem CU_201_0_pre_eq :
    CU_0_re_001 * Fplus_dU_re_200 - CU_0_im_001 * Fplus_dU_im_200 = CU_201_0_pre := by
  simp only [CU_0_re_001_def, CU_0_im_001_def, Fplus_dU_re_200_def, Fplus_dU_im_200_def, CU_201_0_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_201_0_pim_eq :
    CU_0_re_001 * Fplus_dU_im_200 + CU_0_im_001 * Fplus_dU_re_200 = CU_201_0_pim := by
  simp only [CU_0_re_001_def, CU_0_im_001_def, Fplus_dU_re_200_def, Fplus_dU_im_200_def, CU_201_0_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_201_0_mul :
    CU_0_c_001 * Fplus_dU_c_200 = ofLadj CU_201_0_pre CU_201_0_pim := by
  rw [CU_0_c_001_def, Fplus_dU_c_200_def, ofLadj_mul, CU_201_0_pre_eq, CU_201_0_pim_eq]

def CU_201_1_pre : Polynomial ℚ := interpQ 235794999 [-1509997799874, 217317998116224, 434558418100022, 708215671640717, 1197294879937355, 1532759820780020, 1848498977088782, 1985917595873031, 1848501897021444, 1750191466551872, 1675116311076553, 1648653075452548, 1457798312960329, 1315633048451850, 1140286225380727, 741564267595996, 459795930151535, 144056773842773, -47058448339680]
def CU_201_1_pim : Polynomial ℚ := interpQ 235794999 [-206107390445676, -412214780891352, -532839873993922, -730956615397961, -735192159476015, -539923524808510, -323616344762574, 91373707315447, 316617214964246, 302486974349628, 237436252488493, 348241563196188, 459046873903883, 514621245145318, 698607745934739, 744098838351922, 632399103106071, 515409111966037, 183987959309670]
theorem CU_201_1_pre_eq :
    CU_1_re_001 * Fplus_dV_re_200 - CU_1_im_001 * Fplus_dV_im_200 = CU_201_1_pre := by
  simp only [CU_1_re_001_def, CU_1_im_001_def, Fplus_dV_re_200_def, Fplus_dV_im_200_def, CU_201_1_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_201_1_pim_eq :
    CU_1_re_001 * Fplus_dV_im_200 + CU_1_im_001 * Fplus_dV_re_200 = CU_201_1_pim := by
  simp only [CU_1_re_001_def, CU_1_im_001_def, Fplus_dV_re_200_def, Fplus_dV_im_200_def, CU_201_1_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_201_1_mul :
    CU_1_c_001 * Fplus_dV_c_200 = ofLadj CU_201_1_pre CU_201_1_pim := by
  rw [CU_1_c_001_def, Fplus_dV_c_200_def, ofLadj_mul, CU_201_1_pre_eq, CU_201_1_pim_eq]

def CU_201_2_pre : Polynomial ℚ := interpQ 235794999 [-32203859684136, -230070564615744, -433748129757368, -682424580444710, -971411296616360, -1113340162593744, -1219094132738024, -1267962481599360, -1174476027957419, -1156677688012413, -1143071821712505, -1105793610087666, -913001257096761, -722929558255045, -492051447512709, -219429925805080, -87238098918154, 18515871226126, 77121259177920]
def CU_201_2_pim : Polynomial ℚ := interpQ 235794999 [103152316044104, 206304632088208, 196387262865712, 195755983298618, 53024704238540, -167554777732660, -336658500086472, -552248218245208, -671436335343081, -668881759161429, -657106486987591, -742988624683304, -828870762379017, -807178120982683, -803992265233937, -668723308890588, -463281422373518, -312177917085750, -111725794381144]
theorem CU_201_2_pre_eq :
    CU_2_re_001 * Fplus_dW_re_200 - CU_2_im_001 * Fplus_dW_im_200 = CU_201_2_pre := by
  simp only [CU_2_re_001_def, CU_2_im_001_def, Fplus_dW_re_200_def, Fplus_dW_im_200_def, CU_201_2_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_201_2_pim_eq :
    CU_2_re_001 * Fplus_dW_im_200 + CU_2_im_001 * Fplus_dW_re_200 = CU_201_2_pim := by
  simp only [CU_2_re_001_def, CU_2_im_001_def, Fplus_dW_re_200_def, Fplus_dW_im_200_def, CU_201_2_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_201_2_mul :
    CU_2_c_001 * Fplus_dW_c_200 = ofLadj CU_201_2_pre CU_201_2_pim := by
  rw [CU_2_c_001_def, Fplus_dW_c_200_def, ofLadj_mul, CU_201_2_pre_eq, CU_201_2_pim_eq]

theorem CU_201_3_mul : CU_3_c_101 = ofLadj CU_3_re_101 CU_3_im_101 := CU_3_c_101_def

@[expose] public def CU_coeff_201 : Ki := CU_0_c_001 * Fplus_dU_c_200 + CU_1_c_001 * Fplus_dV_c_200 + CU_2_c_001 * Fplus_dW_c_200 + CU_3_c_101

theorem CU_coeff_201_sum :
    CU_coeff_201 = ofLadj (CU_201_0_pre + CU_201_1_pre + CU_201_2_pre + CU_3_re_101) (CU_201_0_pim + CU_201_1_pim + CU_201_2_pim + CU_3_im_101) := by
  simp only [CU_coeff_201, CU_201_0_mul, CU_201_1_mul, CU_201_2_mul, CU_201_3_mul]
  simpa [add_assoc] using ofLadj_add4 CU_201_0_pre CU_201_0_pim CU_201_1_pre CU_201_1_pim CU_201_2_pre CU_201_2_pim CU_3_re_101 CU_3_im_101

def CU_201_qre : Polynomial ℚ := interpQ 235794999 [-137225228563116, 124472662063596, 101885778901868, 192450520057237, 746088238508710, 744999029672936, 780927793730641, 555393442674042, 136548452670876]
def CU_201_qim : Polynomial ℚ := interpQ 235794999 [-455610798701626, -455610798701626, -575034311982658, -805719305434345, -524837745971652, -209776722345516, -6228323744235, 540365824018676, 329258527175804]
theorem CU_coeff_201_poly_re :
    CU_201_0_pre + CU_201_1_pre + CU_201_2_pre + CU_3_re_101 = (0 : Polynomial ℚ) + Phi11 * CU_201_qre := by
  rw [phi11_interpQ]
  simp only [CU_201_0_pre, CU_201_1_pre, CU_201_2_pre, CU_3_re_101_def, CU_201_qre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_coeff_201_poly_im :
    CU_201_0_pim + CU_201_1_pim + CU_201_2_pim + CU_3_im_101 = (0 : Polynomial ℚ) + Phi11 * CU_201_qim := by
  rw [phi11_interpQ]
  simp only [CU_201_0_pim, CU_201_1_pim, CU_201_2_pim, CU_3_im_101_def, CU_201_qim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
public theorem CU_coeff_201_eq :
    CU_coeff_201 = (0 : Ki) := by
  rw [CU_coeff_201_sum, CU_coeff_201_poly_re,
    CU_coeff_201_poly_im, ofLadj_add_Phi11]
  exact ofLadj_zero

end V14Formalization.D12SigmaPlusSegreCore
