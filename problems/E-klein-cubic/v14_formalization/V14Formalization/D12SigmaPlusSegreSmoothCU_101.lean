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

def CU_101_0_pre : Polynomial ℚ := interpQ 235794999 [1515698986916, 10413988614752, 19722659790912, 31611299289029, 44680905319152, 50938765455670, 56268110946031, 58281350881593, 53751687839986, 52950679705214, 52302943045473, 50538126666900, 41888954430721, 33228019914302, 22140388550957, 9825618980929, 4041384289216, -1287961201145, -3774826581512]
def CU_101_0_pim : Polynomial ℚ := interpQ 235794999 [-4630444508380, -9260889016760, -9112401515172, -8980606438753, -1901981937850, 7899665825102, 15775351637117, 26155457987437, 31498042750976, 31392361715896, 30863959911725, 34678568141060, 38493176370395, 37816287064636, 37578810953137, 30819823415921, 21721461933464, 14699767869677, 5022947799852]
theorem CU_101_0_pre_eq :
    CU_0_re_000 * Fplus_dU_re_101 - CU_0_im_000 * Fplus_dU_im_101 = CU_101_0_pre := by
  simp only [CU_0_re_000_def, CU_0_im_000_def, Fplus_dU_re_101_def, Fplus_dU_im_101_def, CU_101_0_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_101_0_pim_eq :
    CU_0_re_000 * Fplus_dU_im_101 + CU_0_im_000 * Fplus_dU_re_101 = CU_101_0_pim := by
  simp only [CU_0_re_000_def, CU_0_im_000_def, Fplus_dU_re_101_def, Fplus_dU_im_101_def, CU_101_0_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_101_0_mul :
    CU_0_c_000 * Fplus_dU_c_101 = ofLadj CU_101_0_pre CU_101_0_pim := by
  rw [CU_0_c_000_def, Fplus_dU_c_101_def, ofLadj_mul, CU_101_0_pre_eq, CU_101_0_pim_eq]

def CU_101_1_pre : Polynomial ℚ := interpQ 235794999 [4886626511804, 65904409431440, 134129960193066, 220366643143480, 328075028950948, 389946284147361, 439621791968759, 467003152171737, 444931898208011, 436521686001167, 430100691240430, 422825161895358, 364196281808990, 302391725808101, 224565255064531, 124586725891891, 67304960166692, 17629452345294, -14341397328898]
def CU_101_1_pim : Polynomial ℚ := interpQ 235794999 [-44371593928054, -88743187856108, -105291660343954, -123953873293186, -93324316845842, -32450843573865, 16281562572781, 87816702075309, 128931445548945, 127722300003555, 122155552390806, 158377894222892, 194600236054978, 205581960930075, 223035028333917, 195936290610897, 142211630549992, 101970251040768, 37583924749312]
theorem CU_101_1_pre_eq :
    CU_1_re_000 * Fplus_dV_re_101 - CU_1_im_000 * Fplus_dV_im_101 = CU_101_1_pre := by
  simp only [CU_1_re_000_def, CU_1_im_000_def, Fplus_dV_re_101_def, Fplus_dV_im_101_def, CU_101_1_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_101_1_pim_eq :
    CU_1_re_000 * Fplus_dV_im_101 + CU_1_im_000 * Fplus_dV_re_101 = CU_101_1_pim := by
  simp only [CU_1_re_000_def, CU_1_im_000_def, Fplus_dV_re_101_def, Fplus_dV_im_101_def, CU_101_1_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_101_1_mul :
    CU_1_c_000 * Fplus_dV_c_101 = ofLadj CU_101_1_pre CU_101_1_pim := by
  rw [CU_1_c_000_def, Fplus_dV_c_101_def, ofLadj_mul, CU_101_1_pre_eq, CU_101_1_pim_eq]

def CU_101_2_pre : Polynomial ℚ := interpQ 235794999 [9067395258760, 149300994117184, 298003776606520, 483239228132078, 734670330802294, 888408561248451, 1027898344474890, 1121350416207696, 1102757919219717, 1117529059675147, 1128843605699513, 1123997569889980, 979542611582329, 819525283068627, 619518691087639, 354493275730500, 192654242859072, 53164459632633, -32186809674902]
def CU_101_2_pim : Polynomial ℚ := interpQ 235794999 [-106968375664668, -213936751329336, -260385142560466, -325334252570088, -283162258076164, -170221517000407, -83184538388758, 73155423127086, 163806115450513, 165920121207541, 175693517826237, 297017383610892, 418341249395547, 474563037245373, 541626153012023, 493270634430144, 367752183100292, 265751888181321, 96834216411382]
theorem CU_101_2_pre_eq :
    CU_2_re_000 * Fplus_dW_re_101 - CU_2_im_000 * Fplus_dW_im_101 = CU_101_2_pre := by
  simp only [CU_2_re_000_def, CU_2_im_000_def, Fplus_dW_re_101_def, Fplus_dW_im_101_def, CU_101_2_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_101_2_pim_eq :
    CU_2_re_000 * Fplus_dW_im_101 + CU_2_im_000 * Fplus_dW_re_101 = CU_101_2_pim := by
  simp only [CU_2_re_000_def, CU_2_im_000_def, Fplus_dW_re_101_def, Fplus_dW_im_101_def, CU_101_2_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_101_2_mul :
    CU_2_c_000 * Fplus_dW_c_101 = ofLadj CU_101_2_pre CU_101_2_pim := by
  rw [CU_2_c_000_def, Fplus_dW_c_101_def, ofLadj_mul, CU_101_2_pre_eq, CU_101_2_pim_eq]

def CU_101_3_pre : Polynomial ℚ := interpQ 235794999 [-1583339224302, 0, 4245814603888, 9805734717702, 14915354309702, 17953041818954, 17953041818954, 14915354309702, 9805734717702, 4245814603888]
def CU_101_3_pim : Polynomial ℚ := interpQ 235794999 [-5390401744974, -10780803489948, -14459050691724, -15258229868282, -12925161468338, -8199550705810, -2581252784138, 2144357978390, 4477426378334, 3678247201776]
theorem CU_101_3_neg_re : -CU_3_re_101 = CU_101_3_pre := by
  simp only [CU_3_re_101_def, CU_101_3_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_101_3_neg_im : -CU_3_im_101 = CU_101_3_pim := by
  simp only [CU_3_im_101_def, CU_101_3_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_101_3_mul : -CU_3_c_101 = ofLadj CU_101_3_pre CU_101_3_pim := by
  rw [CU_3_c_101_def, ofLadj_neg, CU_101_3_neg_re, CU_101_3_neg_im]

@[expose] public def CU_coeff_101 : Ki := CU_0_c_000 * Fplus_dU_c_101 + CU_1_c_000 * Fplus_dV_c_101 + CU_2_c_000 * Fplus_dW_c_101 + (-CU_3_c_101)

theorem CU_coeff_101_sum :
    CU_coeff_101 = ofLadj (CU_101_0_pre + CU_101_1_pre + CU_101_2_pre + CU_101_3_pre) (CU_101_0_pim + CU_101_1_pim + CU_101_2_pim + CU_101_3_pim) := by
  simp only [CU_coeff_101, CU_101_0_mul, CU_101_1_mul, CU_101_2_mul, CU_101_3_mul]
  simpa [add_assoc] using ofLadj_add4 CU_101_0_pre CU_101_0_pim CU_101_1_pre CU_101_1_pim CU_101_2_pre CU_101_2_pim CU_101_3_pre CU_101_3_pim

def CU_101_qre : Polynomial ℚ := interpQ 235794999 [13886381533178, 211733010630198, 230482819031010, 288920694087903, 377318714099807, 224905033288340, 194494636538198, 119808984362094, -50303033585312]
def CU_101_qim : Polynomial ℚ := interpQ 235794999 [-161360815846076, -161360815846076, -66526623419164, -84278707058993, 82213243842115, 188341472873214, 149263368491982, 242980818131220, 139441088960546]
theorem CU_coeff_101_poly_re :
    CU_101_0_pre + CU_101_1_pre + CU_101_2_pre + CU_101_3_pre = (0 : Polynomial ℚ) + Phi11 * CU_101_qre := by
  rw [phi11_interpQ]
  simp only [CU_101_0_pre, CU_101_1_pre, CU_101_2_pre, CU_101_3_pre, CU_101_qre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_coeff_101_poly_im :
    CU_101_0_pim + CU_101_1_pim + CU_101_2_pim + CU_101_3_pim = (0 : Polynomial ℚ) + Phi11 * CU_101_qim := by
  rw [phi11_interpQ]
  simp only [CU_101_0_pim, CU_101_1_pim, CU_101_2_pim, CU_101_3_pim, CU_101_qim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
public theorem CU_coeff_101_eq :
    CU_coeff_101 = (0 : Ki) := by
  rw [CU_coeff_101_sum, CU_coeff_101_poly_re,
    CU_coeff_101_poly_im, ofLadj_add_Phi11]
  exact ofLadj_zero

end V14Formalization.D12SigmaPlusSegreCore
