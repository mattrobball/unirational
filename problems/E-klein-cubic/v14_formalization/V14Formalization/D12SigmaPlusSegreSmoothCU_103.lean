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

def CU_103_0_pre : Polynomial ℚ := C ((859274129501600 / 235794999 : ℚ)) + C ((6141691498263296 / 235794999 : ℚ)) * X + C ((11578130044330336 / 235794999 : ℚ)) * X ^ 2 + C ((18210208718557640 / 235794999 : ℚ)) * X ^ 3 + C ((25924557572015680 / 235794999 : ℚ)) * X ^ 4 + C ((900466797353144 / 7145303 : ℚ)) * X ^ 5 + C ((32532720565309280 / 235794999 : ℚ)) * X ^ 6 + C ((33839525768773672 / 235794999 : ℚ)) * X ^ 7 + C ((10448944066279080 / 78598333 : ℚ)) * X ^ 8 + C ((935504469933752 / 7145303 : ℚ)) * X ^ 9 + C ((30508777801884760 / 235794999 : ℚ)) * X ^ 10 + C ((9838072406124288 / 78598333 : ℚ)) * X ^ 11 + C ((24367086303621464 / 235794999 : ℚ)) * X ^ 12 + C ((19293517463483480 / 235794999 : ℚ)) * X ^ 13 + C ((13136623480279600 / 235794999 : ℚ)) * X ^ 14 + C ((532635513590680 / 21435909 : ℚ)) * X ^ 15 + C ((2327747609049032 / 235794999 : ℚ)) * X ^ 16 + C ((-163189547868832 / 78598333 : ℚ)) * X ^ 17 + C ((-2055977547260512 / 235794999 : ℚ)) * X ^ 18
def CU_103_0_pim : Polynomial ℚ := C ((-2753900141891552 / 235794999 : ℚ)) + C ((-5507800283783104 / 235794999 : ℚ)) * X + C ((-5240305872154432 / 235794999 : ℚ)) * X ^ 2 + C ((-5224021787736968 / 235794999 : ℚ)) * X ^ 3 + C ((-1420326343353776 / 235794999 : ℚ)) * X ^ 4 + C ((406370468742488 / 21435909 : ℚ)) * X ^ 5 + C ((8982164648748304 / 235794999 : ℚ)) * X ^ 6 + C ((14730932484356536 / 235794999 : ℚ)) * X ^ 7 + C ((5971124192428312 / 78598333 : ℚ)) * X ^ 8 + C ((5948355076835064 / 78598333 : ℚ)) * X ^ 9 + C ((17530689515266472 / 235794999 : ℚ)) * X ^ 10 + C ((6607967566438496 / 78598333 : ℚ)) * X ^ 11 + C ((22117115883364504 / 235794999 : ℚ)) * X ^ 12 + C ((7178415252165704 / 78598333 : ℚ)) * X ^ 13 + C ((21450654325299904 / 235794999 : ℚ)) * X ^ 14 + C ((17846361881166424 / 235794999 : ℚ)) * X ^ 15 + C ((374541078508760 / 7145303 : ℚ)) * X ^ 16 + C ((2775969906381040 / 78598333 : ℚ)) * X ^ 17 + C ((2983037092678688 / 235794999 : ℚ)) * X ^ 18
theorem CU_103_0_pre_eq :
    CU_0_re_002 * Fplus_dU_re_101 - CU_0_im_002 * Fplus_dU_im_101 = CU_103_0_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_0_re_002, CU_0_im_002, Fplus_dU_re_101, Fplus_dU_im_101, CU_103_0_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CU_103_0_pim_eq :
    CU_0_re_002 * Fplus_dU_im_101 + CU_0_im_002 * Fplus_dU_re_101 = CU_103_0_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_0_re_002, CU_0_im_002, Fplus_dU_re_101, Fplus_dU_im_101, CU_103_0_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CU_103_0_mul :
    CU_0_c_002 * Fplus_dU_c_101 = ofLadj CU_103_0_pre CU_103_0_pim := by
  rw [CU_0_c_002, Fplus_dU_c_101, ofLadj_mul, CU_103_0_pre_eq, CU_103_0_pim_eq]

def CU_103_1_pre : Polynomial ℚ := C ((-142738456808208 / 78598333 : ℚ)) + C ((-1933530652206400 / 78598333 : ℚ)) * X + C ((-11801163745548640 / 235794999 : ℚ)) * X ^ 2 + C ((-6465119445316000 / 78598333 : ℚ)) * X ^ 3 + C ((-28875349259224096 / 235794999 : ℚ)) * X ^ 4 + C ((-34315030598639536 / 235794999 : ℚ)) * X ^ 5 + C ((-12898144636811728 / 78598333 : ℚ)) * X ^ 6 + C ((-41100138687936952 / 235794999 : ℚ)) * X ^ 7 + C ((-39156258992802520 / 235794999 : ℚ)) * X ^ 8 + C ((-38416068011147072 / 235794999 : ℚ)) * X ^ 9 + C ((-37850916417397408 / 235794999 : ℚ)) * X ^ 10 + C ((-12404005251424912 / 78598333 : ℚ)) * X ^ 11 + C ((-32050324460778208 / 235794999 : ℚ)) * X ^ 12 + C ((-26614904265598432 / 235794999 : ℚ)) * X ^ 13 + C ((-19760900656854520 / 235794999 : ℚ)) * X ^ 14 + C ((-3653711052499352 / 78598333 : ℚ)) * X ^ 15 + C ((-1975249385269568 / 78598333 : ℚ)) * X ^ 16 + C ((-1546344844013056 / 235794999 : ℚ)) * X ^ 17 + C ((421218757071600 / 78598333 : ℚ)) * X ^ 18
def CU_103_1_pim : Polynomial ℚ := C ((3906160431775760 / 235794999 : ℚ)) + C ((7812320863551520 / 235794999 : ℚ)) * X + C ((9268833888577360 / 235794999 : ℚ)) * X ^ 2 + C ((10916732230482112 / 235794999 : ℚ)) * X ^ 3 + C ((2737734823496144 / 78598333 : ℚ)) * X ^ 4 + C ((953743732093552 / 78598333 : ℚ)) * X ^ 5 + C ((-129781646756272 / 21435909 : ℚ)) * X ^ 6 + C ((-7727830299022712 / 235794999 : ℚ)) * X ^ 7 + C ((-11343047286769784 / 235794999 : ℚ)) * X ^ 8 + C ((-11236623206727536 / 235794999 : ℚ)) * X ^ 9 + C ((-976992695585824 / 21435909 : ℚ)) * X ^ 10 + C ((-13935566003377520 / 235794999 : ℚ)) * X ^ 11 + C ((-17124212355310976 / 235794999 : ℚ)) * X ^ 12 + C ((-18091021825053344 / 235794999 : ℚ)) * X ^ 13 + C ((-19632496086915848 / 235794999 : ℚ)) * X ^ 14 + C ((-17239616213915288 / 235794999 : ℚ)) * X ^ 15 + C ((-12516732324216688 / 235794999 : ℚ)) * X ^ 16 + C ((-271991269725712 / 7145303 : ℚ)) * X ^ 17 + C ((-3304569100753952 / 235794999 : ℚ)) * X ^ 18
theorem CU_103_1_pre_eq :
    CU_1_re_002 * Fplus_dV_re_101 - CU_1_im_002 * Fplus_dV_im_101 = CU_103_1_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_1_re_002, CU_1_im_002, Fplus_dV_re_101, Fplus_dV_im_101, CU_103_1_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CU_103_1_pim_eq :
    CU_1_re_002 * Fplus_dV_im_101 + CU_1_im_002 * Fplus_dV_re_101 = CU_103_1_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_1_re_002, CU_1_im_002, Fplus_dV_re_101, Fplus_dV_im_101, CU_103_1_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CU_103_1_mul :
    CU_1_c_002 * Fplus_dV_c_101 = ofLadj CU_103_1_pre CU_103_1_pim := by
  rw [CU_1_c_002, Fplus_dV_c_101, ofLadj_mul, CU_103_1_pre_eq, CU_103_1_pim_eq]

def CU_103_2_pre : Polynomial ℚ := C ((-188650617956192 / 235794999 : ℚ)) + C ((-3077676654077312 / 235794999 : ℚ)) * X + C ((-6144573621077648 / 235794999 : ℚ)) * X ^ 2 + C ((-9978947593437712 / 235794999 : ℚ)) * X ^ 3 + C ((-5054053977376144 / 78598333 : ℚ)) * X ^ 4 + C ((-18328483253529224 / 235794999 : ℚ)) * X ^ 5 + C ((-7073082386653944 / 78598333 : ℚ)) * X ^ 6 + C ((-23143545556671008 / 235794999 : ℚ)) * X ^ 7 + C ((-7584839769362848 / 78598333 : ℚ)) * X ^ 8 + C ((-7686683196377304 / 78598333 : ℚ)) * X ^ 9 + C ((-7764425297549608 / 78598333 : ℚ)) * X ^ 10 + C ((-23191554436543072 / 235794999 : ℚ)) * X ^ 11 + C ((-20215599238571512 / 235794999 : ℚ)) * X ^ 12 + C ((-16915475968054264 / 235794999 : ℚ)) * X ^ 13 + C ((-12775571714650832 / 235794999 : ℚ)) * X ^ 14 + C ((-7311605719898080 / 235794999 : ℚ)) * X ^ 15 + C ((-3978460354836568 / 235794999 : ℚ)) * X ^ 16 + C ((-362565482801320 / 78598333 : ℚ)) * X ^ 17 + C ((669777904644496 / 235794999 : ℚ)) * X ^ 18
def CU_103_2_pim : Polynomial ℚ := C ((734786951621312 / 78598333 : ℚ)) + C ((1469573903242624 / 78598333 : ℚ)) * X + C ((5374462056581696 / 235794999 : ℚ)) * X ^ 2 + C ((203424671394864 / 7145303 : ℚ)) * X ^ 3 + C ((5829936919405712 / 235794999 : ℚ)) * X ^ 4 + C ((1169410964757960 / 78598333 : ℚ)) * X ^ 5 + C ((570058201563976 / 78598333 : ℚ)) * X ^ 6 + C ((-1527405206589664 / 235794999 : ℚ)) * X ^ 7 + C ((-3396243553131344 / 235794999 : ℚ)) * X ^ 8 + C ((-3440186574721352 / 235794999 : ℚ)) * X ^ 9 + C ((-110373574875496 / 7145303 : ℚ)) * X ^ 10 + C ((-6142797423397312 / 235794999 : ℚ)) * X ^ 11 + C ((-8643266875903256 / 235794999 : ℚ)) * X ^ 12 + C ((-9811148618927096 / 235794999 : ℚ)) * X ^ 13 + C ((-3731214579988640 / 78598333 : ℚ)) * X ^ 14 + C ((-10182314917069120 / 235794999 : ℚ)) * X ^ 15 + C ((-690997353386776 / 21435909 : ℚ)) * X ^ 16 + C ((-1831436582926008 / 78598333 : ℚ)) * X ^ 17 + C ((-1997089932813680 / 235794999 : ℚ)) * X ^ 18
theorem CU_103_2_pre_eq :
    CU_2_re_002 * Fplus_dW_re_101 - CU_2_im_002 * Fplus_dW_im_101 = CU_103_2_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_2_re_002, CU_2_im_002, Fplus_dW_re_101, Fplus_dW_im_101, CU_103_2_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CU_103_2_pim_eq :
    CU_2_re_002 * Fplus_dW_im_101 + CU_2_im_002 * Fplus_dW_re_101 = CU_103_2_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_2_re_002, CU_2_im_002, Fplus_dW_re_101, Fplus_dW_im_101, CU_103_2_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CU_103_2_mul :
    CU_2_c_002 * Fplus_dW_c_101 = ofLadj CU_103_2_pre CU_103_2_pim := by
  rw [CU_2_c_002, Fplus_dW_c_101, ofLadj_mul, CU_103_2_pre_eq, CU_103_2_pim_eq]

theorem CU_103_3_mul : CU_3_c_003 = ofLadj CU_3_re_003 CU_3_im_003 := rfl

def CU_coeff_103 : Ki := CU_0_c_002 * Fplus_dU_c_101 + CU_1_c_002 * Fplus_dV_c_101 + CU_2_c_002 * Fplus_dW_c_101 + CU_3_c_003

theorem CU_coeff_103_sum :
    CU_coeff_103 = ofLadj (CU_103_0_pre + CU_103_1_pre + CU_103_2_pre + CU_3_re_003) (CU_103_0_pim + CU_103_1_pim + CU_103_2_pim + CU_3_im_003) := by
  simp only [CU_coeff_103, CU_103_0_mul, CU_103_1_mul, CU_103_2_mul, CU_103_3_mul]
  simpa [add_assoc] using ofLadj_add4 CU_103_0_pre CU_103_0_pim CU_103_1_pre CU_103_1_pim CU_103_2_pre CU_103_2_pim CU_3_re_003 CU_3_im_003

def CU_103_qre : Polynomial ℚ := C ((253938464283472 / 235794999 : ℚ)) + C ((-2990515576716688 / 235794999 : ℚ)) * X + C ((-1220658208519680 / 78598333 : ℚ)) * X ^ 2 + C ((-4837013878943464 / 235794999 : ℚ)) * X ^ 3 + C ((-2328700221109032 / 78598333 : ℚ)) * X ^ 4 + C ((-1612429108767472 / 78598333 : ℚ)) * X ^ 5 + C ((-4452850965572728 / 235794999 : ℚ)) * X ^ 6 + C ((-3001066564622296 / 235794999 : ℚ)) * X ^ 7 + C ((-40847790467072 / 78598333 : ℚ)) * X ^ 8
def CU_103_qim : Polynomial ℚ := C ((1131967540130128 / 78598333 : ℚ)) + C ((1131967540130128 / 78598333 : ℚ)) * X + C ((2716561339633600 / 235794999 : ℚ)) * X ^ 2 + C ((1002853604699512 / 78598333 : ℚ)) * X ^ 3 + C ((200083748236120 / 235794999 : ℚ)) * X ^ 4 + C ((-1817721629135840 / 235794999 : ℚ)) * X ^ 5 + C ((-538578563366248 / 78598333 : ℚ)) * X ^ 6 + C ((-3823489989694456 / 235794999 : ℚ)) * X ^ 7 + C ((-2318621940888944 / 235794999 : ℚ)) * X ^ 8
theorem CU_coeff_103_poly_re :
    CU_103_0_pre + CU_103_1_pre + CU_103_2_pre + CU_3_re_003 = (0 : Polynomial ℚ) + Phi11 * CU_103_qre := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [CU_103_0_pre, CU_103_1_pre, CU_103_2_pre, CU_3_re_003, CU_103_qre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try ring
theorem CU_coeff_103_poly_im :
    CU_103_0_pim + CU_103_1_pim + CU_103_2_pim + CU_3_im_003 = (0 : Polynomial ℚ) + Phi11 * CU_103_qim := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [CU_103_0_pim, CU_103_1_pim, CU_103_2_pim, CU_3_im_003, CU_103_qim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try ring
theorem CU_coeff_103_eq :
    CU_coeff_103 = (0 : Ki) := by
  rw [CU_coeff_103_sum, CU_coeff_103_poly_re,
    CU_coeff_103_poly_im, ofLadj_add_Phi11]
  exact ofLadj_zero

end V14Formalization.D12SigmaPlusSegreCore
