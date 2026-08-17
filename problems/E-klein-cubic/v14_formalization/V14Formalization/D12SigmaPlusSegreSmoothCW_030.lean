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

def CW_030_0_pre : Polynomial ℚ := C ((-473382199786 / 8639957931 : ℚ)) + C ((11159748055040 / 8639957931 : ℚ)) * X + C ((6679614529615 / 2879985977 : ℚ)) * X ^ 2 + C ((35506066195009 / 8639957931 : ℚ)) * X ^ 3 + C ((58276419726292 / 8639957931 : ℚ)) * X ^ 4 + C ((24755522103868 / 2879985977 : ℚ)) * X ^ 5 + C ((91819940372176 / 8639957931 : ℚ)) * X ^ 6 + C ((104409950888066 / 8639957931 : ℚ)) * X ^ 7 + C ((106312088869021 / 8639957931 : ℚ)) * X ^ 8 + C ((109753109779603 / 8639957931 : ℚ)) * X ^ 9 + C ((37687106968479 / 2879985977 : ℚ)) * X ^ 10 + C ((3457444424292 / 261816907 : ℚ)) * X ^ 11 + C ((101901572850397 / 8639957931 : ℚ)) * X ^ 12 + C ((8155842380978 / 785450721 : ℚ)) * X ^ 13 + C ((23602007558004 / 2879985977 : ℚ)) * X ^ 14 + C ((44351173420234 / 8639957931 : ℚ)) * X ^ 15 + C ((8851348869016 / 2879985977 : ℚ)) * X ^ 16 + C ((9000672546476 / 8639957931 : ℚ)) * X ^ 17 + C ((-594119247180 / 2879985977 : ℚ)) * X ^ 18
def CW_030_0_pim : Polynomial ℚ := C ((-10445585615474 / 8639957931 : ℚ)) + C ((-20891171230948 / 8639957931 : ℚ)) * X + C ((-27532193521205 / 8639957931 : ℚ)) * X ^ 2 + C ((-13280161363465 / 2879985977 : ℚ)) * X ^ 3 + C ((-40459340262635 / 8639957931 : ℚ)) * X ^ 4 + C ((-37151467730383 / 8639957931 : ℚ)) * X ^ 5 + C ((-32597826637019 / 8639957931 : ℚ)) * X ^ 6 + C ((-19774265881387 / 8639957931 : ℚ)) * X ^ 7 + C ((-3669822324808 / 2879985977 : ℚ)) * X ^ 8 + C ((-10824056520322 / 8639957931 : ℚ)) * X ^ 9 + C ((-8141338200946 / 8639957931 : ℚ)) * X ^ 10 + C ((5887927370282 / 8639957931 : ℚ)) * X ^ 11 + C ((19917192941510 / 8639957931 : ℚ)) * X ^ 12 + C ((9746977850381 / 2879985977 : ℚ)) * X ^ 13 + C ((1264685896195 / 261816907 : ℚ)) * X ^ 14 + C ((1246933529824 / 261816907 : ℚ)) * X ^ 15 + C ((11403913799680 / 2879985977 : ℚ)) * X ^ 16 + C ((800673832666 / 261816907 : ℚ)) * X ^ 17 + C ((3323161056482 / 2879985977 : ℚ)) * X ^ 18
theorem CW_030_0_pre_eq :
    CW_0_re_010 * Fplus_dU_re_020 - CW_0_im_010 * Fplus_dU_im_020 = CW_030_0_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_0_re_010, CW_0_im_010, Fplus_dU_re_020, Fplus_dU_im_020, CW_030_0_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CW_030_0_pim_eq :
    CW_0_re_010 * Fplus_dU_im_020 + CW_0_im_010 * Fplus_dU_re_020 = CW_030_0_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_0_re_010, CW_0_im_010, Fplus_dU_re_020, Fplus_dU_im_020, CW_030_0_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CW_030_0_mul :
    CW_0_c_010 * Fplus_dU_c_020 = ofLadj CW_030_0_pre CW_030_0_pim := by
  rw [CW_0_c_010, Fplus_dU_c_020, ofLadj_mul, CW_030_0_pre_eq, CW_030_0_pim_eq]

def CW_030_1_pre : Polynomial ℚ := C ((-188930678693 / 2879985977 : ℚ)) + C ((-2482558759220 / 2879985977 : ℚ)) * X + C ((-4251148536320 / 2879985977 : ℚ)) * X ^ 2 + C ((-6818525106035 / 2879985977 : ℚ)) * X ^ 3 + C ((-10499330037981 / 2879985977 : ℚ)) * X ^ 4 + C ((-11855918836215 / 2879985977 : ℚ)) * X ^ 5 + C ((-13583557963158 / 2879985977 : ℚ)) * X ^ 6 + C ((-15617115671139 / 2879985977 : ℚ)) * X ^ 7 + C ((-16002425379723 / 2879985977 : ℚ)) * X ^ 8 + C ((-17176546679977 / 2879985977 : ℚ)) * X ^ 9 + C ((-18191643727419 / 2879985977 : ℚ)) * X ^ 10 + C ((-18436342792040 / 2879985977 : ℚ)) * X ^ 11 + C ((-15709084968199 / 2879985977 : ℚ)) * X ^ 12 + C ((-12925398143657 / 2879985977 : ℚ)) * X ^ 13 + C ((-9183900273688 / 2879985977 : ℚ)) * X ^ 14 + C ((-4378318992312 / 2879985977 : ℚ)) * X ^ 15 + C ((-2251981648849 / 2879985977 : ℚ)) * X ^ 16 + C ((-524342521906 / 2879985977 : ℚ)) * X ^ 17 + C ((739466640846 / 2879985977 : ℚ)) * X ^ 18
def CW_030_1_pim : Polynomial ℚ := C ((1457133885166 / 2879985977 : ℚ)) + C ((2914267770332 / 2879985977 : ℚ)) * X + C ((3220705173666 / 2879985977 : ℚ)) * X ^ 2 + C ((4360927082273 / 2879985977 : ℚ)) * X ^ 3 + C ((3302023857084 / 2879985977 : ℚ)) * X ^ 4 + C ((1484420127659 / 2879985977 : ℚ)) * X ^ 5 + C ((98444437042 / 261816907 : ℚ)) * X ^ 6 + C ((-651249384944 / 2879985977 : ℚ)) * X ^ 7 + C ((-2037877111381 / 2879985977 : ℚ)) * X ^ 8 + C ((-2177324461528 / 2879985977 : ℚ)) * X ^ 9 + C ((-267406141923 / 261816907 : ℚ)) * X ^ 10 + C ((-5674757148044 / 2879985977 : ℚ)) * X ^ 11 + C ((-8408046734935 / 2879985977 : ℚ)) * X ^ 12 + C ((-9478627237894 / 2879985977 : ℚ)) * X ^ 13 + C ((-10758296496648 / 2879985977 : ℚ)) * X ^ 14 + C ((-9243366813944 / 2879985977 : ℚ)) * X ^ 15 + C ((-6374845366737 / 2879985977 : ℚ)) * X ^ 16 + C ((-4627710094140 / 2879985977 : ℚ)) * X ^ 17 + C ((-1842654183952 / 2879985977 : ℚ)) * X ^ 18
theorem CW_030_1_pre_eq :
    CW_1_re_010 * Fplus_dV_re_020 - CW_1_im_010 * Fplus_dV_im_020 = CW_030_1_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_1_re_010, CW_1_im_010, Fplus_dV_re_020, Fplus_dV_im_020, CW_030_1_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CW_030_1_pim_eq :
    CW_1_re_010 * Fplus_dV_im_020 + CW_1_im_010 * Fplus_dV_re_020 = CW_030_1_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_1_re_010, CW_1_im_010, Fplus_dV_re_020, Fplus_dV_im_020, CW_030_1_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CW_030_1_mul :
    CW_1_c_010 * Fplus_dV_c_020 = ofLadj CW_030_1_pre CW_030_1_pim := by
  rw [CW_1_c_010, Fplus_dV_c_020, ofLadj_mul, CW_030_1_pre_eq, CW_030_1_pim_eq]

def CW_030_2_pre : Polynomial ℚ := C ((4076762967172 / 8639957931 : ℚ)) + C ((3011157845920 / 8639957931 : ℚ)) * X + C ((3613576449548 / 2879985977 : ℚ)) * X ^ 2 + C ((11029090167632 / 8639957931 : ℚ)) * X ^ 3 + C ((14036850963596 / 8639957931 : ℚ)) * X ^ 4 + C ((24470613596441 / 8639957931 : ℚ)) * X ^ 5 + C ((17726996579416 / 8639957931 : ℚ)) * X ^ 6 + C ((24973821447362 / 8639957931 : ℚ)) * X ^ 7 + C ((24691592642327 / 8639957931 : ℚ)) * X ^ 8 + C ((24954180999139 / 8639957931 : ℚ)) * X ^ 9 + C ((8044265669653 / 2879985977 : ℚ)) * X ^ 10 + C ((21189978547028 / 8639957931 : ℚ)) * X ^ 11 + C ((21121639163039 / 8639957931 : ℚ)) * X ^ 12 + C ((14113451650495 / 8639957931 : ℚ)) * X ^ 13 + C ((4554167491565 / 2879985977 : ℚ)) * X ^ 14 + C ((3803542497080 / 2879985977 : ℚ)) * X ^ 15 + C ((485932717318 / 8639957931 : ℚ)) * X ^ 16 + C ((7229549734343 / 8639957931 : ℚ)) * X ^ 17 + C ((157885669158 / 2879985977 : ℚ)) * X ^ 18
def CW_030_2_pim : Polynomial ℚ := C ((-459508004948 / 8639957931 : ℚ)) + C ((-919016009896 / 8639957931 : ℚ)) * X + C ((-32329213670 / 71404611 : ℚ)) * X ^ 2 + C ((3539382648586 / 8639957931 : ℚ)) * X ^ 3 + C ((-1624352650927 / 2879985977 : ℚ)) * X ^ 4 + C ((4417511251345 / 8639957931 : ℚ)) * X ^ 5 + C ((2274762007548 / 2879985977 : ℚ)) * X ^ 6 + C ((1955397788126 / 2879985977 : ℚ)) * X ^ 7 + C ((3579786723475 / 2879985977 : ℚ)) * X ^ 8 + C ((11282601867644 / 8639957931 : ℚ)) * X ^ 9 + C ((10656946501103 / 8639957931 : ℚ)) * X ^ 10 + C ((11186054141464 / 8639957931 : ℚ)) * X ^ 11 + C ((3905053927275 / 2879985977 : ℚ)) * X ^ 12 + C ((14082325259458 / 8639957931 : ℚ)) * X ^ 13 + C ((2391449818007 / 2879985977 : ℚ)) * X ^ 14 + C ((14992206800542 / 8639957931 : ℚ)) * X ^ 15 + C ((6772071762554 / 8639957931 : ℚ)) * X ^ 16 + C ((3439223236489 / 8639957931 : ℚ)) * X ^ 17 + C ((1822583353631 / 2879985977 : ℚ)) * X ^ 18
theorem CW_030_2_pre_eq :
    CW_2_re_010 * Fplus_dW_re_020 - CW_2_im_010 * Fplus_dW_im_020 = CW_030_2_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_2_re_010, CW_2_im_010, Fplus_dW_re_020, Fplus_dW_im_020, CW_030_2_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CW_030_2_pim_eq :
    CW_2_re_010 * Fplus_dW_im_020 + CW_2_im_010 * Fplus_dW_re_020 = CW_030_2_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_2_re_010, CW_2_im_010, Fplus_dW_re_020, Fplus_dW_im_020, CW_030_2_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CW_030_2_mul :
    CW_2_c_010 * Fplus_dW_c_020 = ofLadj CW_030_2_pre CW_030_2_pim := by
  rw [CW_2_c_010, Fplus_dW_c_020, ofLadj_mul, CW_030_2_pre_eq, CW_030_2_pim_eq]

def CW_030_3_pre : Polynomial ℚ := C ((-35819833792 / 785450721 : ℚ)) + C ((-50769455152 / 785450721 : ℚ)) * X ^ 2 + C ((-11430867880 / 261816907 : ℚ)) * X ^ 3 + C ((-6801138664 / 71404611 : ℚ)) * X ^ 4 + C ((-25280940760 / 261816907 : ℚ)) * X ^ 5 + C ((-25280940760 / 261816907 : ℚ)) * X ^ 6 + C ((-6801138664 / 71404611 : ℚ)) * X ^ 7 + C ((-11430867880 / 261816907 : ℚ)) * X ^ 8 + C ((-50769455152 / 785450721 : ℚ)) * X ^ 9
def CW_030_3_pim : Polynomial ℚ := C ((175187514008 / 8639957931 : ℚ)) + C ((350375028016 / 8639957931 : ℚ)) * X + C ((585741374056 / 8639957931 : ℚ)) * X ^ 2 + C ((91810424392 / 2879985977 : ℚ)) * X ^ 3 + C ((706619417960 / 8639957931 : ℚ)) * X ^ 4 + C ((112624651376 / 8639957931 : ℚ)) * X ^ 5 + C ((237750376640 / 8639957931 : ℚ)) * X ^ 6 + C ((-356244389944 / 8639957931 : ℚ)) * X ^ 7 + C ((74943754840 / 8639957931 : ℚ)) * X ^ 8 + C ((-78455448680 / 2879985977 : ℚ)) * X ^ 9
theorem CW_030_3_neg_re : -CW_3_re_030 = CW_030_3_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_3_re_030, CW_030_3_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CW_030_3_neg_im : -CW_3_im_030 = CW_030_3_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_3_im_030, CW_030_3_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CW_030_3_mul : -CW_3_c_030 = ofLadj CW_030_3_pre CW_030_3_pim := by
  rw [CW_3_c_030, ofLadj_neg, CW_030_3_neg_re, CW_030_3_neg_im]

@[expose] public def CW_coeff_030 : Ki := CW_0_c_010 * Fplus_dU_c_020 + CW_1_c_010 * Fplus_dV_c_020 + CW_2_c_010 * Fplus_dW_c_020 + (-CW_3_c_030)

theorem CW_coeff_030_sum :
    CW_coeff_030 = ofLadj (CW_030_0_pre + CW_030_1_pre + CW_030_2_pre + CW_030_3_pre) (CW_030_0_pim + CW_030_1_pim + CW_030_2_pim + CW_030_3_pim) := by
  simp only [CW_coeff_030, CW_030_0_mul, CW_030_1_mul, CW_030_2_mul, CW_030_3_mul]
  simpa [add_assoc] using ofLadj_add4 CW_030_0_pre CW_030_0_pim CW_030_1_pre CW_030_1_pim CW_030_2_pre CW_030_2_pim CW_030_3_pre CW_030_3_pim

def CW_030_qre : Polynomial ℚ := C ((2642570559595 / 8639957931 : ℚ)) + C ((4080659063705 / 8639957931 : ℚ)) * X + C ((10844433698557 / 8639957931 : ℚ)) * X ^ 2 + C ((8134699082639 / 8639957931 : ℚ)) * X ^ 3 + C ((14289980393105 / 8639957931 : ℚ)) * X ^ 4 + C ((7447603185573 / 2879985977 : ℚ)) * X ^ 5 + C ((1875613220906 / 2879985977 : ℚ)) * X ^ 6 + C ((13747495526629 / 8639957931 : ℚ)) * X ^ 7 + C ((303233062824 / 2879985977 : ℚ)) * X ^ 8
def CW_030_qim : Polynomial ℚ := C ((-6358504450916 / 8639957931 : ℚ)) + C ((-6358504450916 / 8639957931 : ℚ)) * X + C ((-8479162578389 / 8639957931 : ℚ)) * X ^ 2 + C ((-1746717441593 / 8639957931 : ℚ)) * X ^ 3 + C ((-11776818304390 / 8639957931 : ℚ)) * X ^ 4 + C ((6551635781519 / 8639957931 : ℚ)) * X ^ 5 + C ((5880947629336 / 8639957931 : ℚ)) * X ^ 6 + C ((6069058753564 / 8639957931 : ℚ)) * X ^ 7 + C ((300280929651 / 261816907 : ℚ)) * X ^ 8
theorem CW_coeff_030_poly_re :
    CW_030_0_pre + CW_030_1_pre + CW_030_2_pre + CW_030_3_pre = (0 : Polynomial ℚ) + Phi11 * CW_030_qre := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [CW_030_0_pre, CW_030_1_pre, CW_030_2_pre, CW_030_3_pre, CW_030_qre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try ring
theorem CW_coeff_030_poly_im :
    CW_030_0_pim + CW_030_1_pim + CW_030_2_pim + CW_030_3_pim = (0 : Polynomial ℚ) + Phi11 * CW_030_qim := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [CW_030_0_pim, CW_030_1_pim, CW_030_2_pim, CW_030_3_pim, CW_030_qim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try ring
public theorem CW_coeff_030_eq :
    CW_coeff_030 = (0 : Ki) := by
  rw [CW_coeff_030_sum, CW_coeff_030_poly_re,
    CW_coeff_030_poly_im, ofLadj_add_Phi11]
  exact ofLadj_zero

end V14Formalization.D12SigmaPlusSegreCore
