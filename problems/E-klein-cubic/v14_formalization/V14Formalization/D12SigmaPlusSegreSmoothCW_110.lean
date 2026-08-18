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

def CW_110_0_pre : Polynomial ℚ := interpQ 17279915862 [-438912298351, 25077508018520, 49730040091258, 81896946151888, 138591820770524, 176740768793396, 214225449177065, 229772081685405, 213461110609618, 202236738835960, 193188874625404, 190686219030236, 168111366606884, 152506698744702, 131564164457730, 85501183182058, 53400473056455, 15915792672786, -5679077732823]
def CW_110_0_pim : Polynomial ℚ := interpQ 17279915862 [-23859473602771, -47718947205542, -61629599319898, -85113908387574, -84808724424284, -62777604264540, -37858596007483, 11082232275645, 36677569379850, 35292729010924, 27586518639134, 40394515926566, 53202513213998, 59406954956564, 81506423655314, 85802247035740, 73746536727601, 59959748192012, 20994329760489]
theorem CW_110_0_pre_eq :
    CW_0_re_000 * Fplus_dU_re_110 - CW_0_im_000 * Fplus_dU_im_110 = CW_110_0_pre := by
  simp only [CW_0_re_000_def, CW_0_im_000_def, Fplus_dU_re_110_def, Fplus_dU_im_110_def, CW_110_0_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_110_0_pim_eq :
    CW_0_re_000 * Fplus_dU_im_110 + CW_0_im_000 * Fplus_dU_re_110 = CW_110_0_pim := by
  simp only [CW_0_re_000_def, CW_0_im_000_def, Fplus_dU_re_110_def, Fplus_dU_im_110_def, CW_110_0_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_110_0_mul :
    CW_0_c_000 * Fplus_dU_c_110 = ofLadj CW_110_0_pre CW_110_0_pim := by
  rw [CW_0_c_000_def, Fplus_dU_c_110_def, ofLadj_mul, CW_110_0_pre_eq, CW_110_0_pim_eq]

def CW_110_1_pre : Polynomial ℚ := interpQ 17279915862 [-958456314289, 43449760406300, 81241642837775, 140317851168585, 230030024438703, 296005317640080, 361709026154887, 413625744054588, 420840304274351, 435064683588540, 446955403647263, 451732555214826, 403505643240963, 353823040750765, 280522453105766, 177091310177903, 103186901739329, 37483193224522, -6504409437982]
def CW_110_1_pim : Polynomial ℚ := interpQ 17279915862 [-40409030585315, -80818061170630, -107837796955717, -153184419555371, -159259255514221, -142345301555248, -124991558886735, -75155722253540, -39267217316295, -37598094487788, -27642855376611, 27040463463150, 81723782302911, 118698757199175, 165714502627336, 165997350253411, 136100548000245, 104499178197408, 41680493270020]
theorem CW_110_1_pre_eq :
    CW_1_re_000 * Fplus_dV_re_110 - CW_1_im_000 * Fplus_dV_im_110 = CW_110_1_pre := by
  simp only [CW_1_re_000_def, CW_1_im_000_def, Fplus_dV_re_110_def, Fplus_dV_im_110_def, CW_110_1_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_110_1_pim_eq :
    CW_1_re_000 * Fplus_dV_im_110 + CW_1_im_000 * Fplus_dV_re_110 = CW_110_1_pim := by
  simp only [CW_1_re_000_def, CW_1_im_000_def, Fplus_dV_re_110_def, Fplus_dV_im_110_def, CW_110_1_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_110_1_mul :
    CW_1_c_000 * Fplus_dV_c_110 = ofLadj CW_110_1_pre CW_110_1_pim := by
  rw [CW_1_c_000_def, Fplus_dV_c_110_def, ofLadj_mul, CW_110_1_pre_eq, CW_110_1_pim_eq]

def CW_110_2_pre : Polynomial ℚ := interpQ 17279915862 [3651496707956, 42953976616400, 87187105549772, 145153900565552, 214829908418960, 254362323096804, 288359171153348, 305779874658102, 290974120657793, 285534367447956, 281277091563265, 275972614036316, 238323114946865, 198347261898184, 145820220092241, 81163176837214, 44734579053332, 10737730996788, -9786789401928]
def CW_110_2_pim : Polynomial ℚ := interpQ 17279915862 [-28725301572400, -57450603144800, -69170669704024, -81159054300974, -59628295006374, -21259647184982, 10768481746636, 58753354519656, 85065411008195, 84332831284340, 80815227189453, 104096332989680, 127377438789907, 135579901254244, 146835706127339, 127492279441686, 93779125344588, 67454102928318, 24124723879592]
theorem CW_110_2_pre_eq :
    CW_2_re_000 * Fplus_dW_re_110 - CW_2_im_000 * Fplus_dW_im_110 = CW_110_2_pre := by
  simp only [CW_2_re_000_def, CW_2_im_000_def, Fplus_dW_re_110_def, Fplus_dW_im_110_def, CW_110_2_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_110_2_pim_eq :
    CW_2_re_000 * Fplus_dW_im_110 + CW_2_im_000 * Fplus_dW_re_110 = CW_110_2_pim := by
  simp only [CW_2_re_000_def, CW_2_im_000_def, Fplus_dW_re_110_def, Fplus_dW_im_110_def, CW_110_2_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_110_2_mul :
    CW_2_c_000 * Fplus_dW_c_110 = ofLadj CW_110_2_pre CW_110_2_pim := by
  rw [CW_2_c_000_def, Fplus_dW_c_110_def, ofLadj_mul, CW_110_2_pre_eq, CW_110_2_pim_eq]

def CW_110_3_pre : Polynomial ℚ := interpQ 17279915862 [775853459238, 0, -1414420036524, -3854165705830, -5786053989430, -7008993543464, -7008993543464, -5786053989430, -3854165705830, -1414420036524]
def CW_110_3_pim : Polynomial ℚ := interpQ 17279915862 [2221383833066, 4442767666132, 5711343021632, 6159640285906, 5163288666018, 3515233384312, 927534281820, -720520999886, -1716872619774, -1268575355500]
theorem CW_110_3_neg_re : -CW_3_re_110 = CW_110_3_pre := by
  simp only [CW_3_re_110_def, CW_110_3_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_110_3_neg_im : -CW_3_im_110 = CW_110_3_pim := by
  simp only [CW_3_im_110_def, CW_110_3_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_110_3_mul : -CW_3_c_110 = ofLadj CW_110_3_pre CW_110_3_pim := by
  rw [CW_3_c_110_def, ofLadj_neg, CW_110_3_neg_re, CW_110_3_neg_im]

@[expose] public def CW_coeff_110 : Ki := CW_0_c_000 * Fplus_dU_c_110 + CW_1_c_000 * Fplus_dV_c_110 + CW_2_c_000 * Fplus_dW_c_110 + (-CW_3_c_110)

theorem CW_coeff_110_sum :
    CW_coeff_110 = ofLadj (CW_110_0_pre + CW_110_1_pre + CW_110_2_pre + CW_110_3_pre) (CW_110_0_pim + CW_110_1_pim + CW_110_2_pim + CW_110_3_pim) := by
  simp only [CW_coeff_110, CW_110_0_mul, CW_110_1_mul, CW_110_2_mul, CW_110_3_mul]
  simpa [add_assoc] using ofLadj_add4 CW_110_0_pre CW_110_0_pim CW_110_1_pre CW_110_1_pim CW_110_2_pre CW_110_2_pim CW_110_3_pre CW_110_3_pim

def CW_110_qre : Polynomial ℚ := interpQ 17279915862 [3029981554554, 108451263486666, 105263123401061, 146770163737914, 214151167458562, 142433716348059, 137185236955020, 86106993466829, -21970276572733]
def CW_110_qim : Polynomial ℚ := interpQ 17279915862 [-90772421927420, -90772421927420, -51381879103167, -80371019000006, 14764755679152, 75665666658403, 71713180754696, 145113482407637, 86799546910101]
theorem CW_coeff_110_poly_re :
    CW_110_0_pre + CW_110_1_pre + CW_110_2_pre + CW_110_3_pre = (0 : Polynomial ℚ) + Phi11 * CW_110_qre := by
  rw [phi11_interpQ]
  simp only [CW_110_0_pre, CW_110_1_pre, CW_110_2_pre, CW_110_3_pre, CW_110_qre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_coeff_110_poly_im :
    CW_110_0_pim + CW_110_1_pim + CW_110_2_pim + CW_110_3_pim = (0 : Polynomial ℚ) + Phi11 * CW_110_qim := by
  rw [phi11_interpQ]
  simp only [CW_110_0_pim, CW_110_1_pim, CW_110_2_pim, CW_110_3_pim, CW_110_qim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
public theorem CW_coeff_110_eq :
    CW_coeff_110 = (0 : Ki) := by
  rw [CW_coeff_110_sum, CW_coeff_110_poly_re,
    CW_coeff_110_poly_im, ofLadj_add_Phi11]
  exact ofLadj_zero

end V14Formalization.D12SigmaPlusSegreCore
