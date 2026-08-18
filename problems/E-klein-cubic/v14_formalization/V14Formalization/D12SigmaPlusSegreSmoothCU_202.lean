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

def CU_202_0_pre : Polynomial ℚ := interpQ 235794999 [253555779399084, 0, -223321654574892, -640359398123448, -1969759431924276, -3307300997982468, -4684043293920084, -5802747156413880, -6225843833786160, -6406611462874284, -6544624478008272, -6849618834300948, -6544624478008272, -6183289808299392, -5585484435662712, -4089962214328068, -2653699547470320, -1276957251532704, -256974489838464]
def CU_202_0_pim : Polynomial ℚ := interpQ 235794999 [863675366943276, 1727350733886552, 2808193508844396, 4274124697407276, 5180162548172040, 5613420505620408, 5728764270431700, 4895225331025404, 4351292720285064, 4325301626833260, 4205700793895532, 3166809678792012, 2127918563688492, 927474955792920, -564447326221764, -1394615717700396, -1674238548894276, -1606976135687256, -619802070026472]
theorem CU_202_0_pre_eq :
    CU_0_re_002 * Fplus_dU_re_200 - CU_0_im_002 * Fplus_dU_im_200 = CU_202_0_pre := by
  simp only [CU_0_re_002_def, CU_0_im_002_def, Fplus_dU_re_200_def, Fplus_dU_im_200_def, CU_202_0_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_202_0_pim_eq :
    CU_0_re_002 * Fplus_dU_im_200 + CU_0_im_002 * Fplus_dU_re_200 = CU_202_0_pim := by
  simp only [CU_0_re_002_def, CU_0_im_002_def, Fplus_dU_re_200_def, Fplus_dU_im_200_def, CU_202_0_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_202_0_mul :
    CU_0_c_002 * Fplus_dU_c_200 = ofLadj CU_202_0_pre CU_202_0_pim := by
  rw [CU_0_c_002_def, Fplus_dU_c_200_def, ofLadj_mul, CU_202_0_pre_eq, CU_202_0_pim_eq]

def CU_202_1_pre : Polynomial ℚ := interpQ 235794999 [4017041316004, -580059195661920, -1159937578054204, -1890335461890900, -3195765854096820, -4091220856096160, -4933911062939668, -5300725788119988, -4933970410082332, -4671553444818984, -4471184862324956, -4400514947305176, -3891125666663036, -3511615866764780, -3043634948191432, -1979368570431984, -1227245802751740, -384555595908232, 125591363591184]
def CU_202_1_pim : Polynomial ℚ := interpQ 235794999 [550132321984604, 1100264643969208, 1422231757077400, 1951004422529260, 1962366768407152, 1441119967411864, 863752422900256, -243859690682664, -845101764777904, -807374634255872, -633755767428380, -929509243808216, -1225262720188052, -1373610966468752, -1864656501398580, -1986149066810140, -1687940155651448, -1375686078307896, -491111854561572]
theorem CU_202_1_pre_eq :
    CU_1_re_002 * Fplus_dV_re_200 - CU_1_im_002 * Fplus_dV_im_200 = CU_202_1_pre := by
  simp only [CU_1_re_002_def, CU_1_im_002_def, Fplus_dV_re_200_def, Fplus_dV_im_200_def, CU_202_1_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_202_1_pim_eq :
    CU_1_re_002 * Fplus_dV_im_200 + CU_1_im_002 * Fplus_dV_re_200 = CU_202_1_pim := by
  simp only [CU_1_re_002_def, CU_1_im_002_def, Fplus_dV_re_200_def, Fplus_dV_im_200_def, CU_202_1_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_202_1_mul :
    CU_1_c_002 * Fplus_dV_c_200 = ofLadj CU_202_1_pre CU_202_1_pim := by
  rw [CU_1_c_002_def, Fplus_dV_c_200_def, ofLadj_mul, CU_202_1_pre_eq, CU_202_1_pim_eq]

def CU_202_2_pre : Polynomial ℚ := interpQ 235794999 [123039289125952, 879336186879232, 1657729753990416, 2607405965348888, 3711911268089736, 4254652139425268, 4658110018174960, 4845184199258736, 4488230295927176, 4420195513845488, 4368235556208760, 4225822454713080, 3488899369329528, 2762465759855072, 1880824330578288, 838848964227360, 333283671846776, -70174206902916, -294423966941640]
def CU_202_2_pim : Polynomial ℚ := interpQ 235794999 [-394280908475616, -788561816951232, -750320484179200, -747951588620928, -203246964021816, 640096385428832, 1286168158424008, 2109372013987204, 2565026675176388, 2555248089256520, 2510238035355260, 2838552779804000, 3166867524252740, 3083616137579448, 3071468656101308, 2555311287903596, 1769798703062216, 1192480495741712, 427107404787784]
theorem CU_202_2_pre_eq :
    CU_2_re_002 * Fplus_dW_re_200 - CU_2_im_002 * Fplus_dW_im_200 = CU_202_2_pre := by
  simp only [CU_2_re_002_def, CU_2_im_002_def, Fplus_dW_re_200_def, Fplus_dW_im_200_def, CU_202_2_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_202_2_pim_eq :
    CU_2_re_002 * Fplus_dW_im_200 + CU_2_im_002 * Fplus_dW_re_200 = CU_202_2_pim := by
  simp only [CU_2_re_002_def, CU_2_im_002_def, Fplus_dW_re_200_def, Fplus_dW_im_200_def, CU_202_2_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_202_2_mul :
    CU_2_c_002 * Fplus_dW_c_200 = ofLadj CU_202_2_pre CU_202_2_pim := by
  rw [CU_2_c_002_def, Fplus_dW_c_200_def, ofLadj_mul, CU_202_2_pre_eq, CU_202_2_pim_eq]

theorem CU_202_3_mul : CU_3_c_102 = ofLadj CU_3_re_102 CU_3_im_102 := CU_3_c_102_def

@[expose] public def CU_coeff_202 : Ki := CU_0_c_002 * Fplus_dU_c_200 + CU_1_c_002 * Fplus_dV_c_200 + CU_2_c_002 * Fplus_dW_c_200 + CU_3_c_102

theorem CU_coeff_202_sum :
    CU_coeff_202 = ofLadj (CU_202_0_pre + CU_202_1_pre + CU_202_2_pre + CU_3_re_102) (CU_202_0_pim + CU_202_1_pim + CU_202_2_pim + CU_3_im_102) := by
  simp only [CU_coeff_202, CU_202_0_mul, CU_202_1_mul, CU_202_2_mul, CU_202_3_mul]
  simpa [add_assoc] using ofLadj_add4 CU_202_0_pre CU_202_0_pim CU_202_1_pre CU_202_1_pim CU_202_2_pre CU_202_2_pim CU_3_re_102 CU_3_im_102

def CU_202_qre : Polynomial ℚ := interpQ 235794999 [376737542768576, -77460551551264, -14410860132680, -184144861933244, -1517813232743164, -1682820142157408, -1815974624031432, -1305879961154932, -425807093188920]
def CU_202_qim : Polynomial ℚ := interpQ 235794999 [1006329847034616, 1006329847034616, 1432043240849564, 1995115298422652, 1467818325087904, 766926504876568, 197801716769932, -1106375198453180, -683806519800260]
theorem CU_coeff_202_poly_re :
    CU_202_0_pre + CU_202_1_pre + CU_202_2_pre + CU_3_re_102 = (0 : Polynomial ℚ) + Phi11 * CU_202_qre := by
  rw [phi11_interpQ]
  simp only [CU_202_0_pre, CU_202_1_pre, CU_202_2_pre, CU_3_re_102_def, CU_202_qre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_coeff_202_poly_im :
    CU_202_0_pim + CU_202_1_pim + CU_202_2_pim + CU_3_im_102 = (0 : Polynomial ℚ) + Phi11 * CU_202_qim := by
  rw [phi11_interpQ]
  simp only [CU_202_0_pim, CU_202_1_pim, CU_202_2_pim, CU_3_im_102_def, CU_202_qim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
public theorem CU_coeff_202_eq :
    CU_coeff_202 = (0 : Ki) := by
  rw [CU_coeff_202_sum, CU_coeff_202_poly_re,
    CU_coeff_202_poly_im, ofLadj_add_Phi11]
  exact ofLadj_zero

end V14Formalization.D12SigmaPlusSegreCore
