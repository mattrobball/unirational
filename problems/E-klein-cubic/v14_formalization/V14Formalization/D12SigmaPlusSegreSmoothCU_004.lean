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

def CU_004_0_pre : Polynomial ℚ := interpQ 235794999 [-329271897648760, -5373980060980384, -10728889938375936, -17423131425522400, -26473543365852136, -32002326967544120, -37049081186040152, -40409149415629008, -39730208294273680, -40263637027380632, -40670864494167624, -40493390894580624, -35296884433187240, -29534747089004696, -22307076868751280, -12766479822347224, -6946391029947320, -1899636811451288, 1169126227429648]
def CU_004_0_pim : Polynomial ℚ := interpQ 235794999 [3849121569060568, 7698243138121136, 9384004278650160, 11721412543162232, 10180196158627184, 6125979316113640, 2986666785200016, -2665574058157544, -5928632419072424, -6005341355059480, -6358256928902000, -10724403715335936, -15090550501769872, -17129227216141416, -19543344416640544, -17778229673492488, -13270684273509248, -9592526120355144, -3486956719527888]
theorem CU_004_0_pre_eq :
    CU_0_re_002 * Fplus_dU_re_002 - CU_0_im_002 * Fplus_dU_im_002 = CU_004_0_pre := by
  simp only [CU_0_re_002_def, CU_0_im_002_def, Fplus_dU_re_002_def, Fplus_dU_im_002_def, CU_004_0_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_004_0_pim_eq :
    CU_0_re_002 * Fplus_dU_im_002 + CU_0_im_002 * Fplus_dU_re_002 = CU_004_0_pim := by
  simp only [CU_0_re_002_def, CU_0_im_002_def, Fplus_dU_re_002_def, Fplus_dU_im_002_def, CU_004_0_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_004_0_mul :
    CU_0_c_002 * Fplus_dU_c_002 = ofLadj CU_004_0_pre CU_004_0_pim := by
  rw [CU_0_c_002_def, Fplus_dU_c_002_def, ofLadj_mul, CU_004_0_pre_eq, CU_004_0_pim_eq]

def CU_004_1_pre : Polynomial ℚ := interpQ 235794999 [25307304206216, -580059195661920, -1238336663979880, -2116041549196192, -3369231462912712, -4359498177161424, -5134135539831832, -5363436516988640, -4846886339395024, -4483601079120792, -4206234929753864, -4128141314695248, -3626175734091944, -3245264415140912, -2730844790198832, -1811504867449280, -1019662016035432, -245024653365024, 182700186626648]
def CU_004_1_pim : Polynomial ℚ := interpQ 235794999 [622639721442344, 1245279442884688, 1544225461984736, 1960028141755472, 1920437475076792, 1354648459950072, 573458025341896, -502516701455416, -1096612942701048, -1044379219874608, -804034003614864, -1074524042723696, -1345014081832528, -1403614884672832, -1767183841617128, -1880063867072104, -1623025033825576, -1208850094029096, -441625549111976]
theorem CU_004_1_pre_eq :
    CU_1_re_002 * Fplus_dV_re_002 - CU_1_im_002 * Fplus_dV_im_002 = CU_004_1_pre := by
  simp only [CU_1_re_002_def, CU_1_im_002_def, Fplus_dV_re_002_def, Fplus_dV_im_002_def, CU_004_1_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_004_1_pim_eq :
    CU_1_re_002 * Fplus_dV_im_002 + CU_1_im_002 * Fplus_dV_re_002 = CU_004_1_pim := by
  simp only [CU_1_re_002_def, CU_1_im_002_def, Fplus_dV_re_002_def, Fplus_dV_im_002_def, CU_004_1_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_004_1_mul :
    CU_1_c_002 * Fplus_dV_c_002 = ofLadj CU_004_1_pre CU_004_1_pim := by
  rw [CU_1_c_002_def, Fplus_dV_c_002_def, ofLadj_mul, CU_004_1_pre_eq, CU_004_1_pim_eq]

def CU_004_2_pre : Polynomial ℚ := interpQ 235794999 [48397378796928, 0, -129861317420064, -300004790252784, -456339905360136, -549221233233192, -549221233233192, -456339905360136, -300004790252784, -129861317420064]
def CU_004_2_pim : Polynomial ℚ := interpQ 235794999 [164875535039856, 329751070079712, 442321427662488, 466796640823104, 395368974343752, 250790598754248, 78960471325464, -65617904264040, -137045570743392, -112570357582776]
theorem CU_004_2_pre_eq :
    CU_2_re_002 * Fplus_dW_re_002 - CU_2_im_002 * Fplus_dW_im_002 = CU_004_2_pre := by
  simp only [CU_2_re_002_def, CU_2_im_002_def, Fplus_dW_re_002_def, Fplus_dW_im_002_def, CU_004_2_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_004_2_pim_eq :
    CU_2_re_002 * Fplus_dW_im_002 + CU_2_im_002 * Fplus_dW_re_002 = CU_004_2_pim := by
  simp only [CU_2_re_002_def, CU_2_im_002_def, Fplus_dW_re_002_def, Fplus_dW_im_002_def, CU_004_2_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_004_2_mul :
    CU_2_c_002 * Fplus_dW_c_002 = ofLadj CU_004_2_pre CU_004_2_pim := by
  rw [CU_2_c_002_def, Fplus_dW_c_002_def, ofLadj_mul, CU_004_2_pre_eq, CU_004_2_pim_eq]

@[expose] public def CU_coeff_004 : Ki := CU_0_c_002 * Fplus_dU_c_002 + CU_1_c_002 * Fplus_dV_c_002 + CU_2_c_002 * Fplus_dW_c_002

theorem CU_coeff_004_sum :
    CU_coeff_004 = ofLadj (CU_004_0_pre + CU_004_1_pre + CU_004_2_pre) (CU_004_0_pim + CU_004_1_pim + CU_004_2_pim) := by
  simp only [CU_coeff_004, CU_004_0_mul, CU_004_1_mul, CU_004_2_mul]
  simpa [add_assoc] using ofLadj_add3 CU_004_0_pre CU_004_0_pim CU_004_1_pre CU_004_1_pim CU_004_2_pre CU_004_2_pim

def CU_004_qre : Polynomial ℚ := interpQ 235794999 [-255567214645616, -5698472041996688, -6143048663133576, -7742089845195496, -10459936969153608, -6611931643813752, -5821391581166440, -3496487878872608, 1351826414056296]
def CU_004_qim : Polynomial ℚ := interpQ 235794999 [4636636825542768, 4636636825542768, 2097277517211848, 2777686157443424, -1652234717693080, -4764584233229768, -4092333092950584, -6872793945744376, -3928582268639864]
theorem CU_coeff_004_poly_re :
    CU_004_0_pre + CU_004_1_pre + CU_004_2_pre = (0 : Polynomial ℚ) + Phi11 * CU_004_qre := by
  rw [phi11_interpQ]
  simp only [CU_004_0_pre, CU_004_1_pre, CU_004_2_pre, CU_004_qre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_coeff_004_poly_im :
    CU_004_0_pim + CU_004_1_pim + CU_004_2_pim = (0 : Polynomial ℚ) + Phi11 * CU_004_qim := by
  rw [phi11_interpQ]
  simp only [CU_004_0_pim, CU_004_1_pim, CU_004_2_pim, CU_004_qim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
public theorem CU_coeff_004_eq :
    CU_coeff_004 = (0 : Ki) := by
  rw [CU_coeff_004_sum, CU_coeff_004_poly_re,
    CU_coeff_004_poly_im, ofLadj_add_Phi11]
  exact ofLadj_zero

end V14Formalization.D12SigmaPlusSegreCore
