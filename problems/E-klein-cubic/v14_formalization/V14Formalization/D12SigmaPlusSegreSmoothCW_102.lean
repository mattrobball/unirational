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

def CW_102_0_pre : Polynomial ℚ := C ((-831553274543 / 2879985977 : ℚ)) + C ((-16218651833132 / 2879985977 : ℚ)) * X + C ((-96126399615593 / 8639957931 : ℚ)) * X ^ 2 + C ((-313857674496065 / 17279915862 : ℚ)) * X ^ 3 + C ((-159409578059757 / 5759971954 : ℚ)) * X ^ 4 + C ((-288130742743442 / 8639957931 : ℚ)) * X ^ 5 + C ((-223091368024339 / 5759971954 : ℚ)) * X ^ 6 + C ((-121401526467482 / 2879985977 : ℚ)) * X ^ 7 + C ((-358018551422872 / 8639957931 : ℚ)) * X ^ 8 + C ((-362895859767415 / 8639957931 : ℚ)) * X ^ 9 + C ((-122167111166486 / 2879985977 : ℚ)) * X ^ 10 + C ((-365429394580297 / 8639957931 : ℚ)) * X ^ 11 + C ((-9631678121214 / 261816907 : ℚ)) * X ^ 12 + C ((-266769460151822 / 8639957931 : ℚ)) * X ^ 13 + C ((-134059809449893 / 5759971954 : ℚ)) * X ^ 14 + C ((-228980563126121 / 17279915862 : ℚ)) * X ^ 15 + C ((-125623683625093 / 17279915862 : ℚ)) * X ^ 16 + C ((-16305532519480 / 8639957931 : ℚ)) * X ^ 17 + C ((10599930749750 / 8639957931 : ℚ)) * X ^ 18
def CW_102_0_pim : Polynomial ℚ := C ((35039123166356 / 8639957931 : ℚ)) + C ((70078246332712 / 8639957931 : ℚ)) * X + C ((28293584793477 / 2879985977 : ℚ)) * X ^ 2 + C ((214561033411633 / 17279915862 : ℚ)) * X ^ 3 + C ((184780936895561 / 17279915862 : ℚ)) * X ^ 4 + C ((56481847246436 / 8639957931 : ℚ)) * X ^ 5 + C ((18754874952189 / 5759971954 : ℚ)) * X ^ 6 + C ((-7795827131431 / 2879985977 : ℚ)) * X ^ 7 + C ((-52106717152517 / 8639957931 : ℚ)) * X ^ 8 + C ((-52858753506022 / 8639957931 : ℚ)) * X ^ 9 + C ((-18674703494446 / 2879985977 : ℚ)) * X ^ 10 + C ((-31912845454502 / 2879985977 : ℚ)) * X ^ 11 + C ((-45150987414558 / 2879985977 : ℚ)) * X ^ 12 + C ((-1267940721229 / 71404611 : ℚ)) * X ^ 13 + C ((-353145251895199 / 17279915862 : ℚ)) * X ^ 14 + C ((-319229692210675 / 17279915862 : ℚ)) * X ^ 15 + C ((-239322864803251 / 17279915862 : ℚ)) * X ^ 16 + C ((-86351553667394 / 8639957931 : ℚ)) * X ^ 17 + C ((-2798815212950 / 785450721 : ℚ)) * X ^ 18
theorem CW_102_0_pre_eq :
    CW_0_re_100 * Fplus_dU_re_002 - CW_0_im_100 * Fplus_dU_im_002 = CW_102_0_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_0_re_100, CW_0_im_100, Fplus_dU_re_002, Fplus_dU_im_002, CW_102_0_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CW_102_0_pim_eq :
    CW_0_re_100 * Fplus_dU_im_002 + CW_0_im_100 * Fplus_dU_re_002 = CW_102_0_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_0_re_100, CW_0_im_100, Fplus_dU_re_002, Fplus_dU_im_002, CW_102_0_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CW_102_0_mul :
    CW_0_c_100 * Fplus_dU_c_002 = ofLadj CW_102_0_pre CW_102_0_pim := by
  rw [CW_0_c_100, Fplus_dU_c_002, ofLadj_mul, CW_102_0_pre_eq, CW_102_0_pim_eq]

def CW_102_1_pre : Polynomial ℚ := C ((276639716362 / 8639957931 : ℚ)) + C ((-4310848087496 / 8639957931 : ℚ)) * X + C ((-18234028555075 / 17279915862 : ℚ)) * X ^ 2 + C ((-15601921028234 / 8639957931 : ℚ)) * X ^ 3 + C ((-24892468660993 / 8639957931 : ℚ)) * X ^ 4 + C ((-64327555014379 / 17279915862 : ℚ)) * X ^ 5 + C ((-37968099796639 / 8639957931 : ℚ)) * X ^ 6 + C ((-79159053871001 / 17279915862 : ℚ)) * X ^ 7 + C ((-23856120500995 / 5759971954 : ℚ)) * X ^ 8 + C ((-66181861667929 / 17279915862 : ℚ)) * X ^ 9 + C ((-62167472283071 / 17279915862 : ℚ)) * X ^ 10 + C ((-10187242071535 / 2879985977 : ℚ)) * X ^ 11 + C ((-53545776108079 / 17279915862 : ℚ)) * X ^ 12 + C ((-7991305518809 / 2879985977 : ℚ)) * X ^ 13 + C ((-40364519446517 / 17279915862 : ℚ)) * X ^ 14 + C ((-2427437033705 / 1570901442 : ℚ)) * X ^ 15 + C ((-7588945179787 / 8639957931 : ℚ)) * X ^ 16 + C ((-3569245780675 / 17279915862 : ℚ)) * X ^ 17 + C ((1336154589130 / 8639957931 : ℚ)) * X ^ 18
def CW_102_1_pim : Polynomial ℚ := C ((422676002005 / 785450721 : ℚ)) + C ((845352004010 / 785450721 : ℚ)) * X + C ((7613965821945 / 5759971954 : ℚ)) * X ^ 2 + C ((14630436167692 / 8639957931 : ℚ)) * X ^ 3 + C ((1295624603798 / 785450721 : ℚ)) * X ^ 4 + C ((1844106479899 / 1570901442 : ℚ)) * X ^ 5 + C ((1452168553532 / 2879985977 : ℚ)) * X ^ 6 + C ((-2395128739687 / 5759971954 : ℚ)) * X ^ 7 + C ((-15936572326157 / 17279915862 : ℚ)) * X ^ 8 + C ((-456896557281 / 523633814 : ℚ)) * X ^ 9 + C ((-11546177144981 / 17279915862 : ℚ)) * X ^ 10 + C ((-7832311813831 / 8639957931 : ℚ)) * X ^ 11 + C ((-19783070110343 / 17279915862 : ℚ)) * X ^ 12 + C ((-10247907121333 / 8639957931 : ℚ)) * X ^ 13 + C ((-26055803176331 / 17279915862 : ℚ)) * X ^ 14 + C ((-9195769378923 / 5759971954 : ℚ)) * X ^ 15 + C ((-3980785857854 / 2879985977 : ℚ)) * X ^ 16 + C ((-17844970620061 / 17279915862 : ℚ)) * X ^ 17 + C ((-3231275047415 / 8639957931 : ℚ)) * X ^ 18
theorem CW_102_1_pre_eq :
    CW_1_re_100 * Fplus_dV_re_002 - CW_1_im_100 * Fplus_dV_im_002 = CW_102_1_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_1_re_100, CW_1_im_100, Fplus_dV_re_002, Fplus_dV_im_002, CW_102_1_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CW_102_1_pim_eq :
    CW_1_re_100 * Fplus_dV_im_002 + CW_1_im_100 * Fplus_dV_re_002 = CW_102_1_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_1_re_100, CW_1_im_100, Fplus_dV_re_002, Fplus_dV_im_002, CW_102_1_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CW_102_1_mul :
    CW_1_c_100 * Fplus_dV_c_002 = ofLadj CW_102_1_pre CW_102_1_pim := by
  rw [CW_1_c_100, Fplus_dV_c_002, ofLadj_mul, CW_102_1_pre_eq, CW_102_1_pim_eq]

def CW_102_2_pre : Polynomial ℚ := C ((210126291019 / 5759971954 : ℚ)) + C ((-175434768789 / 2879985977 : ℚ)) * X ^ 2 + C ((-448067978507 / 2879985977 : ℚ)) * X ^ 3 + C ((-661355895357 / 2879985977 : ℚ)) * X ^ 4 + C ((-1612953645471 / 5759971954 : ℚ)) * X ^ 5 + C ((-1612953645471 / 5759971954 : ℚ)) * X ^ 6 + C ((-661355895357 / 2879985977 : ℚ)) * X ^ 7 + C ((-448067978507 / 2879985977 : ℚ)) * X ^ 8 + C ((-175434768789 / 2879985977 : ℚ)) * X ^ 9
def CW_102_2_pim : Polynomial ℚ := C ((45269741293 / 523633814 : ℚ)) + C ((45269741293 / 261816907 : ℚ)) * X + C ((659968879712 / 2879985977 : ℚ)) * X ^ 2 + C ((713155967168 / 2879985977 : ℚ)) * X ^ 3 + C ((572833157689 / 2879985977 : ℚ)) * X ^ 4 + C ((769856780499 / 5759971954 : ℚ)) * X ^ 5 + C ((226077527947 / 5759971954 : ℚ)) * X ^ 6 + C ((-74866003466 / 2879985977 : ℚ)) * X ^ 7 + C ((-215188812945 / 2879985977 : ℚ)) * X ^ 8 + C ((-162001725489 / 2879985977 : ℚ)) * X ^ 9
theorem CW_102_2_pre_eq :
    CW_2_re_100 * Fplus_dW_re_002 - CW_2_im_100 * Fplus_dW_im_002 = CW_102_2_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_2_re_100, CW_2_im_100, Fplus_dW_re_002, Fplus_dW_im_002, CW_102_2_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CW_102_2_pim_eq :
    CW_2_re_100 * Fplus_dW_im_002 + CW_2_im_100 * Fplus_dW_re_002 = CW_102_2_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_2_re_100, CW_2_im_100, Fplus_dW_re_002, Fplus_dW_im_002, CW_102_2_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CW_102_2_mul :
    CW_2_c_100 * Fplus_dW_c_002 = ofLadj CW_102_2_pre CW_102_2_pim := by
  rw [CW_2_c_100, Fplus_dW_c_002, ofLadj_mul, CW_102_2_pre_eq, CW_102_2_pim_eq]

theorem CW_102_3_mul : CW_3_c_101 = ofLadj CW_3_re_101 CW_3_im_101 := rfl

@[expose] public def CW_coeff_102 : Ki := CW_0_c_100 * Fplus_dU_c_002 + CW_1_c_100 * Fplus_dV_c_002 + CW_2_c_100 * Fplus_dW_c_002 + CW_3_c_101

theorem CW_coeff_102_sum :
    CW_coeff_102 = ofLadj (CW_102_0_pre + CW_102_1_pre + CW_102_2_pre + CW_3_re_101) (CW_102_0_pim + CW_102_1_pim + CW_102_2_pim + CW_3_im_101) := by
  simp only [CW_coeff_102, CW_102_0_mul, CW_102_1_mul, CW_102_2_mul, CW_102_3_mul]
  simpa [add_assoc] using ofLadj_add4 CW_102_0_pre CW_102_0_pim CW_102_1_pre CW_102_1_pim CW_102_2_pre CW_102_2_pim CW_3_re_101 CW_3_im_101

def CW_102_qre : Polynomial ℚ := C ((-1062632564061 / 5759971954 : ℚ)) + C ((-102745709481601 / 17279915862 : ℚ)) * X + C ((-35916592897235 / 5759971954 : ℚ)) * X ^ 2 + C ((-69471402810151 / 8639957931 : ℚ)) * X ^ 3 + C ((-8493708059060 / 785450721 : ℚ)) * X ^ 4 + C ((-38293598837403 / 5759971954 : ℚ)) * X ^ 5 + C ((-17436877194172 / 2879985977 : ℚ)) * X ^ 6 + C ((-20017493832465 / 5759971954 : ℚ)) * X ^ 7 + C ((3978695112960 / 2879985977 : ℚ)) * X ^ 8
def CW_102_qim : Polynomial ℚ := C ((27849099414339 / 5759971954 : ℚ)) + C ((27849099414339 / 5759971954 : ℚ)) * X + C ((36648474182393 / 17279915862 : ℚ)) * X ^ 2 + C ((25931793145723 / 8639957931 : ℚ)) * X ^ 3 + C ((-16192027362043 / 8639957931 : ℚ)) * X ^ 4 + C ((-27869806799023 / 5759971954 : ℚ)) * X ^ 5 + C ((-36329750997763 / 8639957931 : ℚ)) * X ^ 6 + C ((-122511593175119 / 17279915862 : ℚ)) * X ^ 7 + C ((-11339414129955 / 2879985977 : ℚ)) * X ^ 8
theorem CW_coeff_102_poly_re :
    CW_102_0_pre + CW_102_1_pre + CW_102_2_pre + CW_3_re_101 = (0 : Polynomial ℚ) + Phi11 * CW_102_qre := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [CW_102_0_pre, CW_102_1_pre, CW_102_2_pre, CW_3_re_101, CW_102_qre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try ring
theorem CW_coeff_102_poly_im :
    CW_102_0_pim + CW_102_1_pim + CW_102_2_pim + CW_3_im_101 = (0 : Polynomial ℚ) + Phi11 * CW_102_qim := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [CW_102_0_pim, CW_102_1_pim, CW_102_2_pim, CW_3_im_101, CW_102_qim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try ring
public theorem CW_coeff_102_eq :
    CW_coeff_102 = (0 : Ki) := by
  rw [CW_coeff_102_sum, CW_coeff_102_poly_re,
    CW_coeff_102_poly_im, ofLadj_add_Phi11]
  exact ofLadj_zero

end V14Formalization.D12SigmaPlusSegreCore
