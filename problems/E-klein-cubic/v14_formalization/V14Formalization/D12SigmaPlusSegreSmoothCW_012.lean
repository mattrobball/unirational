/-
Auto-generated Fplus chart Nullstellensatz identities.
-/
import V14Formalization.D12SigmaPlusSegreEval
import V14Formalization.D12SigmaPlusSegreMul
import V14Formalization.D12SigmaPlusSegrePartials
import V14Formalization.D12SigmaPlusSegreBezoutData

noncomputable section
open Matrix Polynomial
namespace V14Formalization.D12SigmaPlusSegreCore
open D12PolynomialData

def CW_012_0_pre : Polynomial ℚ := C ((901265303960 / 8639957931 : ℚ)) + C ((31247294554112 / 8639957931 : ℚ)) * X + C ((20068553451930 / 2879985977 : ℚ)) * X ^ 2 + C ((33105292698208 / 2879985977 : ℚ)) * X ^ 3 + C ((151712365228925 / 8639957931 : ℚ)) * X ^ 4 + C ((60344053003286 / 2879985977 : ℚ)) * X ^ 5 + C ((212208355928479 / 8639957931 : ℚ)) * X ^ 6 + C ((230201351171251 / 8639957931 : ℚ)) * X ^ 7 + C ((226257093303775 / 8639957931 : ℚ)) * X ^ 8 + C ((229452927807811 / 8639957931 : ℚ)) * X ^ 9 + C ((231663284751563 / 8639957931 : ℚ)) * X ^ 10 + C ((77251670700332 / 2879985977 : ℚ)) * X ^ 11 + C ((66805330065817 / 2879985977 : ℚ)) * X ^ 12 + C ((15386115222911 / 785450721 : ℚ)) * X ^ 13 + C ((126941215209151 / 8639957931 : ℚ)) * X ^ 14 + C ((71815972619660 / 8639957931 : ℚ)) * X ^ 15 + C ((40835871514906 / 8639957931 : ℚ)) * X ^ 16 + C ((3219891532095 / 2879985977 : ℚ)) * X ^ 17 + C ((-2224337774222 / 2879985977 : ℚ)) * X ^ 18
def CW_012_0_pim : Polynomial ℚ := C ((-7591661950468 / 2879985977 : ℚ)) + C ((-15183323900936 / 2879985977 : ℚ)) * X + C ((-54228465492860 / 8639957931 : ℚ)) * X ^ 2 + C ((-70081015917710 / 8639957931 : ℚ)) * X ^ 3 + C ((-59034533260753 / 8639957931 : ℚ)) * X ^ 4 + C ((-37803256468930 / 8639957931 : ℚ)) * X ^ 5 + C ((-6786647056667 / 2879985977 : ℚ)) * X ^ 6 + C ((13039023713908 / 8639957931 : ℚ)) * X ^ 7 + C ((30196490971667 / 8639957931 : ℚ)) * X ^ 8 + C ((10236819330631 / 2879985977 : ℚ)) * X ^ 9 + C ((270016708453 / 71404611 : ℚ)) * X ^ 10 + C ((58446849323740 / 8639957931 : ℚ)) * X ^ 11 + C ((84221676924667 / 8639957931 : ℚ)) * X ^ 12 + C ((94861734445639 / 8639957931 : ℚ)) * X ^ 13 + C ((111228251890715 / 8639957931 : ℚ)) * X ^ 14 + C ((816240950903 / 71404611 : ℚ)) * X ^ 15 + C ((75079400913676 / 8639957931 : ℚ)) * X ^ 16 + C ((54427523669927 / 8639957931 : ℚ)) * X ^ 17 + C ((6191360477418 / 2879985977 : ℚ)) * X ^ 18
theorem CW_012_0_pre_eq :
    CW_0_re_010 * Fplus_dU_re_002 - CW_0_im_010 * Fplus_dU_im_002 = CW_012_0_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_0_re_010, CW_0_im_010, Fplus_dU_re_002, Fplus_dU_im_002, CW_012_0_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CW_012_0_pim_eq :
    CW_0_re_010 * Fplus_dU_im_002 + CW_0_im_010 * Fplus_dU_re_002 = CW_012_0_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_0_re_010, CW_0_im_010, Fplus_dU_re_002, Fplus_dU_im_002, CW_012_0_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CW_012_0_mul :
    CW_0_c_010 * Fplus_dU_c_002 = ofLadj CW_012_0_pre CW_012_0_pim := by
  rw [CW_0_c_010, Fplus_dU_c_002, ofLadj_mul, CW_012_0_pre_eq, CW_012_0_pim_eq]

def CW_012_1_pre : Polynomial ℚ := C ((-242778332419 / 8639957931 : ℚ)) + C ((2482558759220 / 8639957931 : ℚ)) * X + C ((5208847718522 / 8639957931 : ℚ)) * X ^ 2 + C ((8805298832125 / 8639957931 : ℚ)) * X ^ 3 + C ((14258369307344 / 8639957931 : ℚ)) * X ^ 4 + C ((18537835169809 / 8639957931 : ℚ)) * X ^ 5 + C ((7257631274408 / 2879985977 : ℚ)) * X ^ 6 + C ((22593408843803 / 8639957931 : ℚ)) * X ^ 7 + C ((20501866747799 / 8639957931 : ℚ)) * X ^ 8 + C ((6337196398714 / 2879985977 : ℚ)) * X ^ 9 + C ((5923788307164 / 2879985977 : ℚ)) * X ^ 10 + C ((17446765042574 / 8639957931 : ℚ)) * X ^ 11 + C ((15288806162272 / 8639957931 : ℚ)) * X ^ 12 + C ((13802741477620 / 8639957931 : ℚ)) * X ^ 13 + C ((11696567915674 / 8639957931 : ℚ)) * X ^ 14 + C ((2531857631871 / 2879985977 : ℚ)) * X ^ 15 + C ((1412750255474 / 2879985977 : ℚ)) * X ^ 16 + C ((1003192113007 / 8639957931 : ℚ)) * X ^ 17 + C ((-246488880282 / 2879985977 : ℚ)) * X ^ 18
def CW_012_1_pim : Polynomial ℚ := C ((-2698413264776 / 8639957931 : ℚ)) + C ((-5396826529552 / 8639957931 : ℚ)) * X + C ((-592315886744 / 785450721 : ℚ)) * X ^ 2 + C ((-8487239382044 / 8639957931 : ℚ)) * X ^ 3 + C ((-2785856202337 / 2879985977 : ℚ)) * X ^ 4 + C ((-1964751198749 / 2879985977 : ℚ)) * X ^ 5 + C ((-2483091012884 / 8639957931 : ℚ)) * X ^ 6 + C ((59660078811 / 261816907 : ℚ)) * X ^ 7 + C ((4447021726271 / 8639957931 : ℚ)) * X ^ 8 + C ((4260923545202 / 8639957931 : ℚ)) * X ^ 9 + C ((1103088457919 / 2879985977 : ℚ)) * X ^ 10 + C ((403043433494 / 785450721 : ℚ)) * X ^ 11 + C ((5557690163111 / 8639957931 : ℚ)) * X ^ 12 + C ((1908226738766 / 2879985977 : ℚ)) * X ^ 13 + C ((7510346663089 / 8639957931 : ℚ)) * X ^ 14 + C ((2672086943204 / 2879985977 : ℚ)) * X ^ 15 + C ((6813658111658 / 8639957931 : ℚ)) * X ^ 16 + C ((5033815504789 / 8639957931 : ℚ)) * X ^ 17 + C ((1842654183952 / 8639957931 : ℚ)) * X ^ 18
theorem CW_012_1_pre_eq :
    CW_1_re_010 * Fplus_dV_re_002 - CW_1_im_010 * Fplus_dV_im_002 = CW_012_1_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_1_re_010, CW_1_im_010, Fplus_dV_re_002, Fplus_dV_im_002, CW_012_1_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CW_012_1_pim_eq :
    CW_1_re_010 * Fplus_dV_im_002 + CW_1_im_010 * Fplus_dV_re_002 = CW_012_1_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_1_re_010, CW_1_im_010, Fplus_dV_re_002, Fplus_dV_im_002, CW_012_1_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CW_012_1_mul :
    CW_1_c_010 * Fplus_dV_c_002 = ofLadj CW_012_1_pre CW_012_1_pim := by
  rw [CW_1_c_010, Fplus_dV_c_002, ofLadj_mul, CW_012_1_pre_eq, CW_012_1_pim_eq]

def CW_012_2_pre : Polynomial ℚ := C ((-97763926638 / 2879985977 : ℚ)) + C ((-149658362688 / 2879985977 : ℚ)) * X ^ 2 + C ((-82454673247 / 2879985977 : ℚ)) * X ^ 3 + C ((-183626826785 / 2879985977 : ℚ)) * X ^ 4 + C ((-187322486508 / 2879985977 : ℚ)) * X ^ 5 + C ((-187322486508 / 2879985977 : ℚ)) * X ^ 6 + C ((-183626826785 / 2879985977 : ℚ)) * X ^ 7 + C ((-82454673247 / 2879985977 : ℚ)) * X ^ 8 + C ((-149658362688 / 2879985977 : ℚ)) * X ^ 9
def CW_012_2_pim : Polynomial ℚ := C ((53770675820 / 2879985977 : ℚ)) + C ((107541351640 / 2879985977 : ℚ)) * X + C ((142029145231 / 2879985977 : ℚ)) * X ^ 2 + C ((47205134056 / 2879985977 : ℚ)) * X ^ 3 + C ((185580582873 / 2879985977 : ℚ)) * X ^ 4 + C ((40916548599 / 2879985977 : ℚ)) * X ^ 5 + C ((66624803041 / 2879985977 : ℚ)) * X ^ 6 + C ((-78039231233 / 2879985977 : ℚ)) * X ^ 7 + C ((60336217584 / 2879985977 : ℚ)) * X ^ 8 + C ((-34487793591 / 2879985977 : ℚ)) * X ^ 9
theorem CW_012_2_pre_eq :
    CW_2_re_010 * Fplus_dW_re_002 - CW_2_im_010 * Fplus_dW_im_002 = CW_012_2_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_2_re_010, CW_2_im_010, Fplus_dW_re_002, Fplus_dW_im_002, CW_012_2_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CW_012_2_pim_eq :
    CW_2_re_010 * Fplus_dW_im_002 + CW_2_im_010 * Fplus_dW_re_002 = CW_012_2_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_2_re_010, CW_2_im_010, Fplus_dW_re_002, Fplus_dW_im_002, CW_012_2_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CW_012_2_mul :
    CW_2_c_010 * Fplus_dW_c_002 = ofLadj CW_012_2_pre CW_012_2_pim := by
  rw [CW_2_c_010, Fplus_dW_c_002, ofLadj_mul, CW_012_2_pre_eq, CW_012_2_pim_eq]

theorem CW_012_3_mul : CW_3_c_011 = ofLadj CW_3_re_011 CW_3_im_011 := rfl

def CW_coeff_012 : Ki := CW_0_c_010 * Fplus_dU_c_002 + CW_1_c_010 * Fplus_dV_c_002 + CW_2_c_010 * Fplus_dW_c_002 + CW_3_c_011

theorem CW_coeff_012_sum :
    CW_coeff_012 = ofLadj (CW_012_0_pre + CW_012_1_pre + CW_012_2_pre + CW_3_re_011) (CW_012_0_pim + CW_012_1_pim + CW_012_2_pim + CW_3_im_011) := by
  simp only [CW_coeff_012, CW_012_0_mul, CW_012_1_mul, CW_012_2_mul, CW_012_3_mul]
  simpa [add_assoc] using ofLadj_add4 CW_012_0_pre CW_012_0_pim CW_012_1_pre CW_012_1_pim CW_012_2_pre CW_012_2_pim CW_3_re_011 CW_3_im_011

def CW_012_qre : Polynomial ℚ := C ((77624176495 / 2879985977 : ℚ)) + C ((33496980783847 / 8639957931 : ℚ)) * X + C ((32654787430082 / 8639957931 : ℚ)) * X ^ 2 + C ((14804075268272 / 2879985977 : ℚ)) * X ^ 3 + C ((19742079203184 / 2879985977 : ℚ)) * X ^ 4 + C ((34337423233945 / 8639957931 : ℚ)) * X ^ 5 + C ((11470418524012 / 2879985977 : ℚ)) * X ^ 6 + C ((18075346672804 / 8639957931 : ℚ)) * X ^ 7 + C ((-2470826654504 / 2879985977 : ℚ)) * X ^ 8
def CW_012_qim : Polynomial ℚ := C ((-26899039995604 / 8639957931 : ℚ)) + C ((-26899039995604 / 8639957931 : ℚ)) * X + C ((-10807047574159 / 8639957931 : ℚ)) * X ^ 2 + C ((-18152183891867 / 8639957931 : ℚ)) * X ^ 3 + C ((11957182664929 / 8639957931 : ℚ)) * X ^ 4 + C ((24888356863541 / 8639957931 : ℚ)) * X ^ 5 + C ((7477239950206 / 2879985977 : ℚ)) * X ^ 6 + C ((3549509414410 / 785450721 : ℚ)) * X ^ 7 + C ((20416735616206 / 8639957931 : ℚ)) * X ^ 8
theorem CW_coeff_012_poly_re :
    CW_012_0_pre + CW_012_1_pre + CW_012_2_pre + CW_3_re_011 = (0 : Polynomial ℚ) + Phi11 * CW_012_qre := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [CW_012_0_pre, CW_012_1_pre, CW_012_2_pre, CW_3_re_011, CW_012_qre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try ring
theorem CW_coeff_012_poly_im :
    CW_012_0_pim + CW_012_1_pim + CW_012_2_pim + CW_3_im_011 = (0 : Polynomial ℚ) + Phi11 * CW_012_qim := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [CW_012_0_pim, CW_012_1_pim, CW_012_2_pim, CW_3_im_011, CW_012_qim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try ring
theorem CW_coeff_012_eq :
    CW_coeff_012 = (0 : Ki) := by
  rw [CW_coeff_012_sum, CW_coeff_012_poly_re,
    CW_coeff_012_poly_im, ofLadj_add_Phi11]
  exact ofLadj_zero

end V14Formalization.D12SigmaPlusSegreCore
