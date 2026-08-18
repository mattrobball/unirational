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

def CW_112_0_pre : Polynomial ℚ := interpQ 17279915862 [-1175939650878, 22121364463464, 38998685374780, 68032501433999, 105856639114675, 122543822270856, 148401991270664, 157832483484950, 154753496282901, 157218207222904, 158481368606826, 160586298890398, 136360004143362, 118219521848124, 86720994848902, 47033571821711, 29107620885132, 3249451885324, -4942272548564]
def CW_112_0_pim : Polynomial ℚ := interpQ 17279915862 [-16828875231040, -33657750462080, -38260103489560, -54185661318517, -42137432678327, -30420106978850, -18429604978038, 7157814208548, 16322569564577, 16889060798980, 18223881864818, 37150493226460, 56077104588102, 62014278681420, 78506327744780, 65247551518979, 52027944612358, 37465003335370, 10375302941640]
theorem CW_112_0_pre_eq :
    CW_0_re_110 * Fplus_dU_re_002 - CW_0_im_110 * Fplus_dU_im_002 = CW_112_0_pre := by
  simp only [CW_0_re_110_def, CW_0_im_110_def, Fplus_dU_re_002_def, Fplus_dU_im_002_def, CW_112_0_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_112_0_pim_eq :
    CW_0_re_110 * Fplus_dU_im_002 + CW_0_im_110 * Fplus_dU_re_002 = CW_112_0_pim := by
  simp only [CW_0_re_110_def, CW_0_im_110_def, Fplus_dU_re_002_def, Fplus_dU_im_002_def, CW_112_0_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_112_0_mul :
    CW_0_c_110 * Fplus_dU_c_002 = ofLadj CW_112_0_pre CW_112_0_pim := by
  rw [CW_0_c_110_def, Fplus_dU_c_002_def, ofLadj_mul, CW_112_0_pre_eq, CW_112_0_pim_eq]

def CW_112_1_pre : Polynomial ℚ := interpQ 17279915862 [-458403891969, 1527643439244, 2815352917648, 5170020921803, 8470014793888, 10646809224164, 13095464548718, 13285456884108, 12011667977288, 10949505156963, 10437912766039, 10480752756138, 8910269326795, 8134152239315, 6841647055485, 4339062222898, 2751528909184, 302873584630, -476379867322]
def CW_112_1_pim : Polynomial ℚ := interpQ 17279915862 [-1737722127189, -3475444254378, -3935914054278, -5647825413199, -4989114589090, -4002982848070, -1930912238542, 890415457662, 2355182388328, 2045032821259, 1444196092003, 2321265584684, 3198335077365, 3057968148009, 4459729939861, 4370774282364, 4034556701142, 3066425300460, 895011764054]
theorem CW_112_1_pre_eq :
    CW_1_re_110 * Fplus_dV_re_002 - CW_1_im_110 * Fplus_dV_im_002 = CW_112_1_pre := by
  simp only [CW_1_re_110_def, CW_1_im_110_def, Fplus_dV_re_002_def, Fplus_dV_im_002_def, CW_112_1_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_112_1_pim_eq :
    CW_1_re_110 * Fplus_dV_im_002 + CW_1_im_110 * Fplus_dV_re_002 = CW_112_1_pim := by
  simp only [CW_1_re_110_def, CW_1_im_110_def, Fplus_dV_re_002_def, Fplus_dV_im_002_def, CW_112_1_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_112_1_mul :
    CW_1_c_110 * Fplus_dV_c_002 = ofLadj CW_112_1_pre CW_112_1_pim := by
  rw [CW_1_c_110_def, Fplus_dV_c_002_def, ofLadj_mul, CW_112_1_pre_eq, CW_112_1_pim_eq]

def CW_112_2_pre : Polynomial ℚ := interpQ 17279915862 [-391068271458, 0, -417790418574, -321844394706, -647466275241, -646996505295, -646996505295, -647466275241, -321844394706, -417790418574]
def CW_112_2_pim : Polynomial ℚ := interpQ 17279915862 [127445004972, 254890009944, 416463340998, 222834038538, 551997454065, 47259207993, 207630801951, -297107444121, 32055971406, -161573331054]
theorem CW_112_2_pre_eq :
    CW_2_re_110 * Fplus_dW_re_002 - CW_2_im_110 * Fplus_dW_im_002 = CW_112_2_pre := by
  simp only [CW_2_re_110_def, CW_2_im_110_def, Fplus_dW_re_002_def, Fplus_dW_im_002_def, CW_112_2_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_112_2_pim_eq :
    CW_2_re_110 * Fplus_dW_im_002 + CW_2_im_110 * Fplus_dW_re_002 = CW_112_2_pim := by
  simp only [CW_2_re_110_def, CW_2_im_110_def, Fplus_dW_re_002_def, Fplus_dW_im_002_def, CW_112_2_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_112_2_mul :
    CW_2_c_110 * Fplus_dW_c_002 = ofLadj CW_112_2_pre CW_112_2_pim := by
  rw [CW_2_c_110_def, Fplus_dW_c_002_def, ofLadj_mul, CW_112_2_pre_eq, CW_112_2_pim_eq]

theorem CW_112_3_mul : CW_3_c_111 = ofLadj CW_3_re_111 CW_3_im_111 := CW_3_c_111_def

@[expose] public def CW_coeff_112 : Ki := CW_0_c_110 * Fplus_dU_c_002 + CW_1_c_110 * Fplus_dV_c_002 + CW_2_c_110 * Fplus_dW_c_002 + CW_3_c_111

theorem CW_coeff_112_sum :
    CW_coeff_112 = ofLadj (CW_112_0_pre + CW_112_1_pre + CW_112_2_pre + CW_3_re_111) (CW_112_0_pim + CW_112_1_pim + CW_112_2_pim + CW_3_im_111) := by
  simp only [CW_coeff_112, CW_112_0_mul, CW_112_1_mul, CW_112_2_mul, CW_112_3_mul]
  simpa [add_assoc] using ofLadj_add4 CW_112_0_pre CW_112_0_pim CW_112_1_pre CW_112_1_pim CW_112_2_pre CW_112_2_pim CW_3_re_111 CW_3_im_111

def CW_112_qre : Polynomial ℚ := interpQ 17279915862 [-2147770273671, 25796778176379, 18916599382718, 32791032183052, 42190007859778, 19513484250293, 28306824324362, 8970977885840, -5418652415886]
def CW_112_qim : Polynomial ℚ := interpQ 17279915862 [-19803680854323, -19803680854323, -5796807163962, -17893810855212, 13347731883298, 13555824487843, 15531072677670, 29261113930136, 11270314705694]
theorem CW_coeff_112_poly_re :
    CW_112_0_pre + CW_112_1_pre + CW_112_2_pre + CW_3_re_111 = (0 : Polynomial ℚ) + Phi11 * CW_112_qre := by
  rw [phi11_interpQ]
  simp only [CW_112_0_pre, CW_112_1_pre, CW_112_2_pre, CW_3_re_111_def, CW_112_qre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_coeff_112_poly_im :
    CW_112_0_pim + CW_112_1_pim + CW_112_2_pim + CW_3_im_111 = (0 : Polynomial ℚ) + Phi11 * CW_112_qim := by
  rw [phi11_interpQ]
  simp only [CW_112_0_pim, CW_112_1_pim, CW_112_2_pim, CW_3_im_111_def, CW_112_qim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
public theorem CW_coeff_112_eq :
    CW_coeff_112 = (0 : Ki) := by
  rw [CW_coeff_112_sum, CW_coeff_112_poly_re,
    CW_coeff_112_poly_im, ofLadj_add_Phi11]
  exact ofLadj_zero

end V14Formalization.D12SigmaPlusSegreCore
