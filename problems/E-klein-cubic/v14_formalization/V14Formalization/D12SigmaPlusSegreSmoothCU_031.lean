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

def CU_031_0_pre : Polynomial ℚ := interpQ 235794999 [84012233456, 338878406298480, 641623257611156, 1104186467931856, 1802492217278052, 2326204769851440, 2834942877289356, 3246142256602856, 3300678479805144, 3415803718867708, 3503727987968192, 3536601280067404, 3164849581669712, 2774180461256552, 2196492011873288, 1392425124189340, 805660953941612, 296922846503696, -51224915135464]
def CU_031_0_pim : Polynomial ℚ := interpQ 235794999 [-312939465748168, -625878931496336, -845203209781772, -1187136192174648, -1242889185199092, -1104615275872580, -968891813423432, -577675069138312, -296826469191072, -280262338017464, -204203048166188, 220471288824964, 645145625816116, 940529193952828, 1299026307519312, 1306488288621716, 1070428407745492, 818142327704112, 329139611869280]
theorem CU_031_0_pre_eq :
    CU_0_re_011 * Fplus_dU_re_020 - CU_0_im_011 * Fplus_dU_im_020 = CU_031_0_pre := by
  simp only [CU_0_re_011_def, CU_0_im_011_def, Fplus_dU_re_020_def, Fplus_dU_im_020_def, CU_031_0_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_031_0_pim_eq :
    CU_0_re_011 * Fplus_dU_im_020 + CU_0_im_011 * Fplus_dU_re_020 = CU_031_0_pim := by
  simp only [CU_0_re_011_def, CU_0_im_011_def, Fplus_dU_re_020_def, Fplus_dU_im_020_def, CU_031_0_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_031_0_mul :
    CU_0_c_011 * Fplus_dU_c_020 = ofLadj CU_031_0_pre CU_031_0_pim := by
  rw [CU_0_c_011_def, Fplus_dU_c_020_def, ofLadj_mul, CU_031_0_pre_eq, CU_031_0_pim_eq]

def CU_031_1_pre : Polynomial ℚ := interpQ 235794999 [-37511619531708, -363427983159024, -632782069018404, -1021845300411240, -1543898651239464, -1755401301907464, -2013285918527016, -2310727786067196, -2366068435279980, -2550772823600604, -2691862835831532, -2706974778305616, -2328434852672508, -1917990754582200, -1344223134868740, -652399378570344, -339934569493908, -82049952874356, 114429756257388]
def CU_031_1_pim : Polynomial ℚ := interpQ 235794999 [208386679708536, 416773359417072, 480037862689512, 622684016126196, 468293586611568, 211006625264352, 142109367030600, -119458473849720, -318722986156368, -345264241754892, -467452146076944, -854963311723320, -1242474477369696, -1427926884964188, -1597114293999396, -1365235801687260, -950934074603796, -695335181720724, -276752575104156]
theorem CU_031_1_pre_eq :
    CU_1_re_011 * Fplus_dV_re_020 - CU_1_im_011 * Fplus_dV_im_020 = CU_031_1_pre := by
  simp only [CU_1_re_011_def, CU_1_im_011_def, Fplus_dV_re_020_def, Fplus_dV_im_020_def, CU_031_1_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_031_1_pim_eq :
    CU_1_re_011 * Fplus_dV_im_020 + CU_1_im_011 * Fplus_dV_re_020 = CU_031_1_pim := by
  simp only [CU_1_re_011_def, CU_1_im_011_def, Fplus_dV_re_020_def, Fplus_dV_im_020_def, CU_031_1_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_031_1_mul :
    CU_1_c_011 * Fplus_dV_c_020 = ofLadj CU_031_1_pre CU_031_1_pim := by
  rw [CU_1_c_011_def, Fplus_dV_c_020_def, ofLadj_mul, CU_031_1_pre_eq, CU_031_1_pim_eq]

def CU_031_2_pre : Polynomial ℚ := interpQ 235794999 [-66497033689136, -924876597203552, -1835310994754668, -3006419826727340, -4483879340523424, -5341429850778700, -6040776195659476, -6462212297628972, -6158443723147092, -6088864573889032, -6035698830758588, -5949535539396328, -5110822233555036, -4253553579134364, -3152023896419752, -1738573649756088, -918933680234908, -219587335354132, 239759307349460]
def CU_031_2_pim : Polynomial ℚ := interpQ 235794999 [629358973217920, 1258717946435840, 1476366929234772, 1772128108697196, 1360785579833888, 524756150498480, -155309931583432, -1172533041529340, -1768320141167036, -1758343016742120, -1712214402271344, -2274183760794408, -2836153119317472, -3007673487645628, -3293457542683136, -2911312064695296, -2134511429546424, -1524584364521600, -566590048762228]
theorem CU_031_2_pre_eq :
    CU_2_re_011 * Fplus_dW_re_020 - CU_2_im_011 * Fplus_dW_im_020 = CU_031_2_pre := by
  simp only [CU_2_re_011_def, CU_2_im_011_def, Fplus_dW_re_020_def, Fplus_dW_im_020_def, CU_031_2_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_031_2_pim_eq :
    CU_2_re_011 * Fplus_dW_im_020 + CU_2_im_011 * Fplus_dW_re_020 = CU_031_2_pim := by
  simp only [CU_2_re_011_def, CU_2_im_011_def, Fplus_dW_re_020_def, Fplus_dW_im_020_def, CU_031_2_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_031_2_mul :
    CU_2_c_011 * Fplus_dW_c_020 = ofLadj CU_031_2_pre CU_031_2_pim := by
  rw [CU_2_c_011_def, Fplus_dW_c_020_def, ofLadj_mul, CU_031_2_pre_eq, CU_031_2_pim_eq]

@[expose] public def CU_coeff_031 : Ki := CU_0_c_011 * Fplus_dU_c_020 + CU_1_c_011 * Fplus_dV_c_020 + CU_2_c_011 * Fplus_dW_c_020

theorem CU_coeff_031_sum :
    CU_coeff_031 = ofLadj (CU_031_0_pre + CU_031_1_pre + CU_031_2_pre) (CU_031_0_pim + CU_031_1_pim + CU_031_2_pim) := by
  simp only [CU_coeff_031, CU_031_0_mul, CU_031_1_mul, CU_031_2_mul]
  simpa [add_assoc] using ofLadj_add3 CU_031_0_pre CU_031_0_pim CU_031_1_pre CU_031_1_pim CU_031_2_pre CU_031_2_pim

def CU_031_qre : Polynomial ℚ := interpQ 235794999 [-103924640987388, -845501533076708, -877043632097820, -1097608853044808, -1301207115278112, -545340608349888, -448492854062412, -307678590196176, 302964148471384]
def CU_031_qim : Polynomial ℚ := interpQ 235794999 [524806187178288, 524806187178288, 61589207785936, 96474350506232, -621485951402380, -955042481356112, -613239877866516, -887574206541108, -514203011997104]
theorem CU_coeff_031_poly_re :
    CU_031_0_pre + CU_031_1_pre + CU_031_2_pre = (0 : Polynomial ℚ) + Phi11 * CU_031_qre := by
  rw [phi11_interpQ]
  simp only [CU_031_0_pre, CU_031_1_pre, CU_031_2_pre, CU_031_qre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_coeff_031_poly_im :
    CU_031_0_pim + CU_031_1_pim + CU_031_2_pim = (0 : Polynomial ℚ) + Phi11 * CU_031_qim := by
  rw [phi11_interpQ]
  simp only [CU_031_0_pim, CU_031_1_pim, CU_031_2_pim, CU_031_qim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
public theorem CU_coeff_031_eq :
    CU_coeff_031 = (0 : Ki) := by
  rw [CU_coeff_031_sum, CU_coeff_031_poly_re,
    CU_coeff_031_poly_im, ofLadj_add_Phi11]
  exact ofLadj_zero

end V14Formalization.D12SigmaPlusSegreCore
