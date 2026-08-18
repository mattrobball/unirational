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

def CW_211_0_pre : Polynomial ℚ := interpQ 8639957931 [-924768001104, -12640779693408, -22169225598394, -36037088742305, -52815187015368, -57594739898228, -66254090470761, -66712137710779, -61950608227121, -61120592223855, -60277308446568, -59180529266166, -47636528753160, -38951366625461, -25913519484816, -10145389917051, -5839395162362, 2819955410171, 3751560778360]
def CW_211_0_pim : Polynomial ℚ := interpQ 8639957931 [6230576999860, 12461153999720, 11000836178046, 13993059271146, 3689638196712, -6118258405079, -14770982559258, -27724737315870, -32201482687827, -32192340784571, -31488003526257, -36804099680212, -42120195834167, -39955540754179, -42938621944023, -32873177207734, -23990774890688, -16267029505679, -4238769033812]
theorem CW_211_0_pre_eq :
    CW_0_re_110 * Fplus_dU_re_101 - CW_0_im_110 * Fplus_dU_im_101 = CW_211_0_pre := by
  simp only [CW_0_re_110_def, CW_0_im_110_def, Fplus_dU_re_101_def, Fplus_dU_im_101_def, CW_211_0_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_211_0_pim_eq :
    CW_0_re_110 * Fplus_dU_im_101 + CW_0_im_110 * Fplus_dU_re_101 = CW_211_0_pim := by
  simp only [CW_0_re_110_def, CW_0_im_110_def, Fplus_dU_re_101_def, Fplus_dU_im_101_def, CW_211_0_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_211_0_mul :
    CW_0_c_110 * Fplus_dU_c_101 = ofLadj CW_211_0_pre CW_211_0_pim := by
  rw [CW_0_c_110_def, Fplus_dU_c_101_def, ofLadj_mul, CW_211_0_pre_eq, CW_211_0_pim_eq]

def CW_211_1_pre : Polynomial ℚ := interpQ 8639957931 [-611389956285, 7638217196220, 14047562375557, 24175620764105, 36842887003359, 41889351044289, 49261758963057, 51266090916491, 48768902582163, 47791543229039, 47090654850101, 47336471925185, 39452437653881, 33743980853482, 24593281818058, 12750099580446, 8254590937630, 882183018862, -1673104332686]
def CW_211_1_pim : Polynomial ℚ := interpQ 8639957931 [-5633323757457, -11266647514914, -12168079313567, -16486419387101, -11087333593483, -5682971713346, -664306874332, 8064716587827, 11881552918113, 11722023043497, 11122587306890, 15807347381341, 20492107455792, 20794103517838, 24952913716756, 20011482739692, 15348371027240, 11346954808206, 3359181513732]
theorem CW_211_1_pre_eq :
    CW_1_re_110 * Fplus_dV_re_101 - CW_1_im_110 * Fplus_dV_im_101 = CW_211_1_pre := by
  simp only [CW_1_re_110_def, CW_1_im_110_def, Fplus_dV_re_101_def, Fplus_dV_im_101_def, CW_211_1_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_211_1_pim_eq :
    CW_1_re_110 * Fplus_dV_im_101 + CW_1_im_110 * Fplus_dV_re_101 = CW_211_1_pim := by
  simp only [CW_1_re_110_def, CW_1_im_110_def, Fplus_dV_re_101_def, Fplus_dV_im_101_def, CW_211_1_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_211_1_mul :
    CW_1_c_110 * Fplus_dV_c_101 = ofLadj CW_211_1_pre CW_211_1_pim := by
  rw [CW_1_c_110_def, Fplus_dV_c_101_def, ofLadj_mul, CW_211_1_pre_eq, CW_211_1_pim_eq]

def CW_211_2_pre : Polynomial ℚ := interpQ 8639957931 [-2643781307016, -1189486713072, -5453024648608, -6779032718283, -7868310522422, -13319608076813, -11311126829143, -14333530891566, -14703582364646, -14640613015048, -14914225780997, -12081239416612, -13724739067925, -9187588366440, -7924549646363, -6524482469844, -1087342370890, -3095823618560, -59262100700]
def CW_211_2_pim : Polynomial ℚ := interpQ 8639957931 [-147822603570, -295645207140, 2212375685708, -1567058799805, 1615779721548, -2028363676879, -3851912752819, -3772813477541, -6720828968114, -6562317936244, -6755604908837, -6688665328424, -6621725748011, -9323033613452, -5385088096069, -8771458630283, -4806899794628, -2985799639662, -2744483477712]
theorem CW_211_2_pre_eq :
    CW_2_re_110 * Fplus_dW_re_101 - CW_2_im_110 * Fplus_dW_im_101 = CW_211_2_pre := by
  simp only [CW_2_re_110_def, CW_2_im_110_def, Fplus_dW_re_101_def, Fplus_dW_im_101_def, CW_211_2_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_211_2_pim_eq :
    CW_2_re_110 * Fplus_dW_im_101 + CW_2_im_110 * Fplus_dW_re_101 = CW_211_2_pim := by
  simp only [CW_2_re_110_def, CW_2_im_110_def, Fplus_dW_re_101_def, Fplus_dW_im_101_def, CW_211_2_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_211_2_mul :
    CW_2_c_110 * Fplus_dW_c_101 = ofLadj CW_211_2_pre CW_211_2_pim := by
  rw [CW_2_c_110_def, Fplus_dW_c_101_def, ofLadj_mul, CW_211_2_pre_eq, CW_211_2_pim_eq]

theorem CW_211_3_mul : CW_3_c_210 = ofLadj CW_3_re_210 CW_3_im_210 := CW_3_c_210_def

@[expose] public def CW_coeff_211 : Ki := CW_0_c_110 * Fplus_dU_c_101 + CW_1_c_110 * Fplus_dV_c_101 + CW_2_c_110 * Fplus_dW_c_101 + CW_3_c_210

theorem CW_coeff_211_sum :
    CW_coeff_211 = ofLadj (CW_211_0_pre + CW_211_1_pre + CW_211_2_pre + CW_3_re_210) (CW_211_0_pim + CW_211_1_pim + CW_211_2_pim + CW_3_im_210) := by
  simp only [CW_coeff_211, CW_211_0_mul, CW_211_1_mul, CW_211_2_mul, CW_211_3_mul]
  simpa [add_assoc] using ofLadj_add4 CW_211_0_pre CW_211_0_pim CW_211_1_pre CW_211_1_pim CW_211_2_pre CW_211_2_pim CW_3_re_210 CW_3_im_210

def CW_211_qre : Polynomial ℚ := interpQ 8639957931 [-4175582619871, -2016466590389, -7513856028785, -5150186825298, -5325014506672, -5247626210827, 721538593905, -1412879534501, 2019194344974]
def CW_211_qim : Polynomial ℚ := interpQ 8639957931 [564396499091, 564396499091, 234656723407, -5113674526457, -1737643225011, -8183849440249, -5543429320941, -4281803339343, -3624070997792]
theorem CW_coeff_211_poly_re :
    CW_211_0_pre + CW_211_1_pre + CW_211_2_pre + CW_3_re_210 = (0 : Polynomial ℚ) + Phi11 * CW_211_qre := by
  rw [phi11_interpQ]
  simp only [CW_211_0_pre, CW_211_1_pre, CW_211_2_pre, CW_3_re_210_def, CW_211_qre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_coeff_211_poly_im :
    CW_211_0_pim + CW_211_1_pim + CW_211_2_pim + CW_3_im_210 = (0 : Polynomial ℚ) + Phi11 * CW_211_qim := by
  rw [phi11_interpQ]
  simp only [CW_211_0_pim, CW_211_1_pim, CW_211_2_pim, CW_3_im_210_def, CW_211_qim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
public theorem CW_coeff_211_eq :
    CW_coeff_211 = (0 : Ki) := by
  rw [CW_coeff_211_sum, CW_coeff_211_poly_re,
    CW_coeff_211_poly_im, ofLadj_add_Phi11]
  exact ofLadj_zero

end V14Formalization.D12SigmaPlusSegreCore
