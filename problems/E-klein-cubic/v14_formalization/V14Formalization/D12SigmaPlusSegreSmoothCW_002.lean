/-
Auto-generated Fplus chart Nullstellensatz identities.
-/
module

public import V14Formalization.D12SigmaPlusSegreEval
public import V14Formalization.D12SigmaPlusSegreMul
public import V14Formalization.D12SigmaPlusSegrePartials
public import V14Formalization.D12SigmaPlusSegreBezoutData

noncomputable section
open Matrix Polynomial
namespace V14Formalization.D12SigmaPlusSegreCore
open D12PolynomialData

def CW_002_0_pre : Polynomial ℚ := C ((4692932737111 / 17279915862 : ℚ)) + C ((43885639032410 / 8639957931 : ℚ)) * X + C ((174213886871953 / 17279915862 : ℚ)) * X ^ 2 + C ((95082270878349 / 5759971954 : ℚ)) * X ^ 3 + C ((19714500548458 / 785450721 : ℚ)) * X ^ 4 + C ((261246028800308 / 8639957931 : ℚ)) * X ^ 5 + C ((101228863535964 / 2879985977 : ℚ)) * X ^ 6 + C ((661032682882565 / 17279915862 : ℚ)) * X ^ 7 + C ((59030146134739 / 1570901442 : ℚ)) * X ^ 8 + C ((109701720676279 / 2879985977 : ℚ)) * X ^ 9 + C ((332384420271550 / 8639957931 : ℚ)) * X ^ 10 + C ((331316521187959 / 8639957931 : ℚ)) * X ^ 11 + C ((288498781239140 / 8639957931 : ℚ)) * X ^ 12 + C ((483996437185721 / 17279915862 : ℚ)) * X ^ 13 + C ((182042397423541 / 8639957931 : ℚ)) * X ^ 14 + C ((69197330798225 / 5759971954 : ℚ)) * X ^ 15 + C ((57012472869574 / 8639957931 : ℚ)) * X ^ 16 + C ((4857303687330 / 2879985977 : ℚ)) * X ^ 17 + C ((-9860839210907 / 8639957931 : ℚ)) * X ^ 18
def CW_002_0_pim : Polynomial ℚ := C ((-21044227448217 / 5759971954 : ℚ)) + C ((-21044227448217 / 2879985977 : ℚ)) * X + C ((-51265045079973 / 5759971954 : ℚ)) * X ^ 2 + C ((-96836119383268 / 8639957931 : ℚ)) * X ^ 3 + C ((-166026278626739 / 17279915862 : ℚ)) * X ^ 4 + C ((-33734362689277 / 5759971954 : ℚ)) * X ^ 5 + C ((-4509295177645 / 1570901442 : ℚ)) * X ^ 6 + C ((22320748612609 / 8639957931 : ℚ)) * X ^ 7 + C ((97100649975437 / 17279915862 : ℚ)) * X ^ 8 + C ((98471311582219 / 17279915862 : ℚ)) * X ^ 9 + C ((52132554142133 / 8639957931 : ℚ)) * X ^ 10 + C ((29310396544741 / 2879985977 : ℚ)) * X ^ 11 + C ((123729825126313 / 8639957931 : ℚ)) * X ^ 12 + C ((140391608752645 / 8639957931 : ℚ)) * X ^ 13 + C ((107343660879563 / 5759971954 : ℚ)) * X ^ 14 + C ((96865163150113 / 5759971954 : ℚ)) * X ^ 15 + C ((218393594008187 / 17279915862 : ℚ)) * X ^ 16 + C ((52623711620443 / 5759971954 : ℚ)) * X ^ 17 + C ((9374780966462 / 2879985977 : ℚ)) * X ^ 18
theorem CW_002_0_pre_eq :
    CW_0_re_000 * Fplus_dU_re_002 - CW_0_im_000 * Fplus_dU_im_002 = CW_002_0_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_0_re_000, CW_0_im_000, Fplus_dU_re_002, Fplus_dU_im_002, CW_002_0_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CW_002_0_pim_eq :
    CW_0_re_000 * Fplus_dU_im_002 + CW_0_im_000 * Fplus_dU_re_002 = CW_002_0_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_0_re_000, CW_0_im_000, Fplus_dU_re_002, Fplus_dU_im_002, CW_002_0_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CW_002_0_mul :
    CW_0_c_000 * Fplus_dU_c_002 = ofLadj CW_002_0_pre CW_002_0_pim := by
  rw [CW_0_c_000, Fplus_dU_c_002, ofLadj_mul, CW_002_0_pre_eq, CW_002_0_pim_eq]

def CW_002_1_pre : Polynomial ℚ := C ((-608899371653 / 17279915862 : ℚ)) + C ((4344976040630 / 8639957931 : ℚ)) * X + C ((6130838833095 / 5759971954 : ℚ)) * X ^ 2 + C ((1428825462055 / 785450721 : ℚ)) * X ^ 3 + C ((16737873398667 / 5759971954 : ℚ)) * X ^ 4 + C ((10820816517233 / 2879985977 : ℚ)) * X ^ 5 + C ((76620314385995 / 17279915862 : ℚ)) * X ^ 6 + C ((79826470467445 / 17279915862 : ℚ)) * X ^ 7 + C ((12030730983250 / 2879985977 : ℚ)) * X ^ 8 + C ((33385761308797 / 8639957931 : ℚ)) * X ^ 9 + C ((10448320009378 / 2879985977 : ℚ)) * X ^ 10 + C ((30822419727311 / 8639957931 : ℚ)) * X ^ 11 + C ((2454543998864 / 785450721 : ℚ)) * X ^ 12 + C ((48379006118309 / 17279915862 : ℚ)) * X ^ 13 + C ((20375112867145 / 8639957931 : ℚ)) * X ^ 14 + C ((26914022593963 / 17279915862 : ℚ)) * X ^ 15 + C ((15278164537949 / 17279915862 : ℚ)) * X ^ 16 + C ((597124875892 / 2879985977 : ℚ)) * X ^ 17 + C ((-899609225827 / 5759971954 : ℚ)) * X ^ 18
def CW_002_1_pim : Polynomial ℚ := C ((-4692649464626 / 8639957931 : ℚ)) + C ((-9385298929252 / 8639957931 : ℚ)) * X + C ((-1046318472433 / 785450721 : ℚ)) * X ^ 2 + C ((-4924949661770 / 2879985977 : ℚ)) * X ^ 3 + C ((-872513027643 / 523633814 : ℚ)) * X ^ 4 + C ((-3410117832229 / 2879985977 : ℚ)) * X ^ 5 + C ((-8765251159045 / 17279915862 : ℚ)) * X ^ 6 + C ((3630500576821 / 8639957931 : ℚ)) * X ^ 7 + C ((2685488350606 / 2879985977 : ℚ)) * X ^ 8 + C ((693287054212 / 785450721 : ℚ)) * X ^ 9 + C ((11693776654189 / 17279915862 : ℚ)) * X ^ 10 + C ((2639339198357 / 2879985977 : ℚ)) * X ^ 11 + C ((19978293726095 / 17279915862 : ℚ)) * X ^ 12 + C ((10334081861321 / 8639957931 : ℚ)) * X ^ 13 + C ((13169120194382 / 8639957931 : ℚ)) * X ^ 14 + C ((13949275250390 / 8639957931 : ℚ)) * X ^ 15 + C ((365402529727 / 261816907 : ℚ)) * X ^ 16 + C ((18010863712217 / 17279915862 : ℚ)) * X ^ 17 + C ((6534850779577 / 17279915862 : ℚ)) * X ^ 18
theorem CW_002_1_pre_eq :
    CW_1_re_000 * Fplus_dV_re_002 - CW_1_im_000 * Fplus_dV_im_002 = CW_002_1_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_1_re_000, CW_1_im_000, Fplus_dV_re_002, Fplus_dV_im_002, CW_002_1_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CW_002_1_pim_eq :
    CW_1_re_000 * Fplus_dV_im_002 + CW_1_im_000 * Fplus_dV_re_002 = CW_002_1_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_1_re_000, CW_1_im_000, Fplus_dV_re_002, Fplus_dV_im_002, CW_002_1_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CW_002_1_mul :
    CW_1_c_000 * Fplus_dV_c_002 = ofLadj CW_002_1_pre CW_002_1_pim := by
  rw [CW_1_c_000, Fplus_dV_c_002, ofLadj_mul, CW_002_1_pre_eq, CW_002_1_pim_eq]

def CW_002_2_pre : Polynomial ℚ := C ((-13422343648 / 261816907 : ℚ)) + C ((37528998850 / 261816907 : ℚ)) * X ^ 2 + C ((16371259553 / 47603074 : ℚ)) * X ^ 3 + C ((273336768141 / 523633814 : ℚ)) * X ^ 4 + C ((325414958129 / 523633814 : ℚ)) * X ^ 5 + C ((325414958129 / 523633814 : ℚ)) * X ^ 6 + C ((273336768141 / 523633814 : ℚ)) * X ^ 7 + C ((16371259553 / 47603074 : ℚ)) * X ^ 8 + C ((37528998850 / 261816907 : ℚ)) * X ^ 9
def CW_002_2_pim : Polynomial ℚ := C ((-536924707705 / 2879985977 : ℚ)) + C ((-1073849415410 / 2879985977 : ℚ)) * X + C ((-1446392442672 / 2879985977 : ℚ)) * X ^ 2 + C ((-1531400225307 / 2879985977 : ℚ)) * X ^ 3 + C ((-1285991078951 / 2879985977 : ℚ)) * X ^ 4 + C ((-1629160323503 / 5759971954 : ℚ)) * X ^ 5 + C ((-518538507317 / 5759971954 : ℚ)) * X ^ 6 + C ((212141663541 / 2879985977 : ℚ)) * X ^ 7 + C ((457550809897 / 2879985977 : ℚ)) * X ^ 8 + C ((372543027262 / 2879985977 : ℚ)) * X ^ 9
theorem CW_002_2_pre_eq :
    CW_2_re_000 * Fplus_dW_re_002 - CW_2_im_000 * Fplus_dW_im_002 = CW_002_2_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_2_re_000, CW_2_im_000, Fplus_dW_re_002, Fplus_dW_im_002, CW_002_2_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CW_002_2_pim_eq :
    CW_2_re_000 * Fplus_dW_im_002 + CW_2_im_000 * Fplus_dW_re_002 = CW_002_2_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_2_re_000, CW_2_im_000, Fplus_dW_re_002, Fplus_dW_im_002, CW_002_2_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CW_002_2_mul :
    CW_2_c_000 * Fplus_dW_c_002 = ofLadj CW_002_2_pre CW_002_2_pim := by
  rw [CW_2_c_000, Fplus_dW_c_002, ofLadj_mul, CW_002_2_pre_eq, CW_002_2_pim_eq]

theorem CW_002_3_mul : CW_3_c_001 = ofLadj CW_3_re_001 CW_3_im_001 := rfl

@[expose] public def CW_coeff_002 : Ki := CW_0_c_000 * Fplus_dU_c_002 + CW_1_c_000 * Fplus_dV_c_002 + CW_2_c_000 * Fplus_dW_c_002 + CW_3_c_001

theorem CW_coeff_002_sum :
    CW_coeff_002 = ofLadj (CW_002_0_pre + CW_002_1_pre + CW_002_2_pre + CW_3_re_001) (CW_002_0_pim + CW_002_1_pim + CW_002_2_pim + CW_3_im_001) := by
  simp only [CW_coeff_002, CW_002_0_mul, CW_002_1_mul, CW_002_2_mul, CW_002_3_mul]
  simpa [add_assoc] using ofLadj_add4 CW_002_0_pre CW_002_0_pim CW_002_1_pre CW_002_1_pim CW_002_2_pre CW_002_2_pim CW_3_re_001 CW_3_im_001

def CW_002_qre : Polynomial ℚ := C ((1590439384414 / 8639957931 : ℚ)) + C ((15546725229542 / 2879985977 : ℚ)) * X + C ((49311043574629 / 8639957931 : ℚ)) * X ^ 2 + C ((1932430647313 / 261816907 : ℚ)) * X ^ 3 + C ((28388167598789 / 2879985977 : ℚ)) * X ^ 4 + C ((35067634903847 / 5759971954 : ℚ)) * X ^ 5 + C ((96576538897765 / 17279915862 : ℚ)) * X ^ 6 + C ((55147077478627 / 17279915862 : ℚ)) * X ^ 7 + C ((-22420506099295 / 17279915862 : ℚ)) * X ^ 8
def CW_002_qim : Polynomial ℚ := C ((-75739529520133 / 17279915862 : ℚ)) + C ((-75739529520133 / 17279915862 : ℚ)) * X + C ((-34013437249211 / 17279915862 : ℚ)) * X ^ 2 + C ((-4265258345411 / 1570901442 : ℚ)) * X ^ 3 + C ((4979197179389 / 2879985977 : ℚ)) * X ^ 4 + C ((37991939490475 / 8639957931 : ℚ)) * X ^ 5 + C ((22209387465541 / 5759971954 : ℚ)) * X ^ 6 + C ((113098461995197 / 17279915862 : ℚ)) * X ^ 7 + C ((62783536578349 / 17279915862 : ℚ)) * X ^ 8
theorem CW_coeff_002_poly_re :
    CW_002_0_pre + CW_002_1_pre + CW_002_2_pre + CW_3_re_001 = (0 : Polynomial ℚ) + Phi11 * CW_002_qre := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [CW_002_0_pre, CW_002_1_pre, CW_002_2_pre, CW_3_re_001, CW_002_qre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try grind
theorem CW_coeff_002_poly_im :
    CW_002_0_pim + CW_002_1_pim + CW_002_2_pim + CW_3_im_001 = (0 : Polynomial ℚ) + Phi11 * CW_002_qim := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [CW_002_0_pim, CW_002_1_pim, CW_002_2_pim, CW_3_im_001, CW_002_qim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try grind
public theorem CW_coeff_002_eq :
    CW_coeff_002 = (0 : Ki) := by
  rw [CW_coeff_002_sum, CW_coeff_002_poly_re,
    CW_coeff_002_poly_im, ofLadj_add_Phi11]
  exact ofLadj_zero

end V14Formalization.D12SigmaPlusSegreCore
