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

def CW_200_0_pre : Polynomial ℚ := C ((-2874981129849 / 11519943908 : ℚ)) + C ((1105286884375 / 5759971954 : ℚ)) * X ^ 2 + C ((6969605026925 / 11519943908 : ℚ)) * X ^ 3 + C ((21449525067351 / 11519943908 : ℚ)) * X ^ 4 + C ((35919615908331 / 11519943908 : ℚ)) * X ^ 5 + C ((4653330668711 / 1047267628 : ℚ)) * X ^ 6 + C ((15840247376861 / 2879985977 : ℚ)) * X ^ 7 + C ((67892026910927 / 11519943908 : ℚ)) * X ^ 8 + C ((69849590106705 / 11519943908 : ℚ)) * X ^ 9 + C ((71369253545409 / 11519943908 : ℚ)) * X ^ 10 + C ((74751601421809 / 11519943908 : ℚ)) * X ^ 11 + C ((71369253545409 / 11519943908 : ℚ)) * X ^ 12 + C ((67639016337955 / 11519943908 : ℚ)) * X ^ 13 + C ((30461210942001 / 5759971954 : ℚ)) * X ^ 14 + C ((22297954831719 / 5759971954 : ℚ)) * X ^ 15 + C ((14514649885057 / 5759971954 : ℚ)) * X ^ 16 + C ((3440569580656 / 2879985977 : ℚ)) * X ^ 17 + C ((2684445223345 / 11519943908 : ℚ)) * X ^ 18
def CW_200_0_pim : Polynomial ℚ := C ((-9404065506945 / 11519943908 : ℚ)) + C ((-9404065506945 / 5759971954 : ℚ)) * X + C ((-7647419505116 / 2879985977 : ℚ)) * X ^ 2 + C ((-11685359485682 / 2879985977 : ℚ)) * X ^ 3 + C ((-14103744653062 / 2879985977 : ℚ)) * X ^ 4 + C ((-61385704548951 / 11519943908 : ℚ)) * X ^ 5 + C ((-62562367678575 / 11519943908 : ℚ)) * X ^ 6 + C ((-26669772425713 / 5759971954 : ℚ)) * X ^ 7 + C ((-11850643936910 / 2879985977 : ℚ)) * X ^ 8 + C ((-23553296577341 / 5759971954 : ℚ)) * X ^ 9 + C ((-11444158634465 / 2879985977 : ℚ)) * X ^ 10 + C ((-3134688502315 / 1047267628 : ℚ)) * X ^ 11 + C ((-11593256256535 / 5759971954 : ℚ)) * X ^ 12 + C ((-5037503444837 / 5759971954 : ℚ)) * X ^ 13 + C ((1593183906387 / 2879985977 : ℚ)) * X ^ 14 + C ((15248941916159 / 11519943908 : ℚ)) * X ^ 15 + C ((18482349144817 / 11519943908 : ℚ)) * X ^ 16 + C ((17694445017889 / 11519943908 : ℚ)) * X ^ 17 + C ((6734303482695 / 11519943908 : ℚ)) * X ^ 18
theorem CW_200_0_pre_eq :
    CW_0_re_000 * Fplus_dU_re_200 - CW_0_im_000 * Fplus_dU_im_200 = CW_200_0_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_0_re_000, CW_0_im_000, Fplus_dU_re_200, Fplus_dU_im_200, CW_200_0_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CW_200_0_pim_eq :
    CW_0_re_000 * Fplus_dU_im_200 + CW_0_im_000 * Fplus_dU_re_200 = CW_200_0_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_0_re_000, CW_0_im_000, Fplus_dU_re_200, Fplus_dU_im_200, CW_200_0_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CW_200_0_mul :
    CW_0_c_000 * Fplus_dU_c_200 = ofLadj CW_200_0_pre CW_200_0_pim := by
  rw [CW_0_c_000, Fplus_dU_c_200, ofLadj_mul, CW_200_0_pre_eq, CW_200_0_pim_eq]

def CW_200_1_pre : Polynomial ℚ := C ((-261225947657 / 17279915862 : ℚ)) + C ((4344976040630 / 8639957931 : ℚ)) * X + C ((11466371228151 / 11519943908 : ℚ)) * X ^ 2 + C ((14015735801458 / 8639957931 : ℚ)) * X ^ 3 + C ((15897074631347 / 5759971954 : ℚ)) * X ^ 4 + C ((10147973702571 / 2879985977 : ℚ)) * X ^ 5 + C ((4459569645637 / 1047267628 : ℚ)) * X ^ 6 + C ((39484658126119 / 8639957931 : ℚ)) * X ^ 7 + C ((36712481831426 / 8639957931 : ℚ)) * X ^ 8 + C ((34800641291545 / 8639957931 : ℚ)) * X ^ 9 + C ((22178966927983 / 5759971954 : ℚ)) * X ^ 10 + C ((32914449239636 / 8639957931 : ℚ)) * X ^ 11 + C ((57846948702689 / 17279915862 : ℚ)) * X ^ 12 + C ((104803451481727 / 34559831724 : ℚ)) * X ^ 13 + C ((22696746029968 / 8639957931 : ℚ)) * X ^ 14 + C ((58849101827557 / 34559831724 : ℚ)) * X ^ 15 + C ((36720593727077 / 34559831724 : ℚ)) * X ^ 16 + C ((2832619962977 / 8639957931 : ℚ)) * X ^ 17 + C ((-1235694296279 / 11519943908 : ℚ)) * X ^ 18
def CW_200_1_pim : Polynomial ℚ := C ((-1508919076199 / 3141802884 : ℚ)) + C ((-1508919076199 / 1570901442 : ℚ)) * X + C ((-14134130461845 / 11519943908 : ℚ)) * X ^ 2 + C ((-5342518210345 / 3141802884 : ℚ)) * X ^ 3 + C ((-14728748932024 / 8639957931 : ℚ)) * X ^ 4 + C ((-21675426196201 / 17279915862 : ℚ)) * X ^ 5 + C ((-26367466753217 / 34559831724 : ℚ)) * X ^ 6 + C ((2333709578361 / 11519943908 : ℚ)) * X ^ 7 + C ((24541741986805 / 34559831724 : ℚ)) * X ^ 8 + C ((5879638279378 / 8639957931 : ℚ)) * X ^ 9 + C ((9129519698413 / 17279915862 : ℚ)) * X ^ 10 + C ((13663547169827 / 17279915862 : ℚ)) * X ^ 11 + C ((6065858213747 / 5759971954 : ℚ)) * X ^ 12 + C ((40341807270953 / 34559831724 : ℚ)) * X ^ 13 + C ((13920981832480 / 8639957931 : ℚ)) * X ^ 14 + C ((58839001055587 / 34559831724 : ℚ)) * X ^ 15 + C ((4182668173085 / 2879985977 : ℚ)) * X ^ 16 + C ((40984270071529 / 34559831724 : ℚ)) * X ^ 17 + C ((1211069578363 / 2879985977 : ℚ)) * X ^ 18
theorem CW_200_1_pre_eq :
    CW_1_re_000 * Fplus_dV_re_200 - CW_1_im_000 * Fplus_dV_im_200 = CW_200_1_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_1_re_000, CW_1_im_000, Fplus_dV_re_200, Fplus_dV_im_200, CW_200_1_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CW_200_1_pim_eq :
    CW_1_re_000 * Fplus_dV_im_200 + CW_1_im_000 * Fplus_dV_re_200 = CW_200_1_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_1_re_000, CW_1_im_000, Fplus_dV_re_200, Fplus_dV_im_200, CW_200_1_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CW_200_1_mul :
    CW_1_c_000 * Fplus_dV_c_200 = ofLadj CW_200_1_pre CW_200_1_pim := by
  rw [CW_1_c_000, Fplus_dV_c_200, ofLadj_mul, CW_200_1_pre_eq, CW_200_1_pim_eq]

def CW_200_2_pre : Polynomial ℚ := C ((-1261824150052 / 8639957931 : ℚ)) + C ((-8590795323280 / 8639957931 : ℚ)) * X + C ((-16168708530235 / 8639957931 : ℚ)) * X ^ 2 + C ((-51413437743905 / 17279915862 : ℚ)) * X ^ 3 + C ((-36415491725947 / 8639957931 : ℚ)) * X ^ 4 + C ((-13859687573782 / 2879985977 : ℚ)) * X ^ 5 + C ((-91561436812409 / 17279915862 : ℚ)) * X ^ 6 + C ((-31682595623695 / 5759971954 : ℚ)) * X ^ 7 + C ((-58617509057427 / 11519943908 : ℚ)) * X ^ 8 + C ((-173210717004107 / 34559831724 : ℚ)) * X ^ 9 + C ((-171150822472033 / 34559831724 : ℚ)) * X ^ 10 + C ((-82663454771389 / 17279915862 : ℚ)) * X ^ 11 + C ((-45595880392971 / 11519943908 : ℚ)) * X ^ 12 + C ((-108535882883167 / 34559831724 : ℚ)) * X ^ 13 + C ((-73025651684471 / 34559831724 : ℚ)) * X ^ 14 + C ((-16336666903175 / 17279915862 : ℚ)) * X ^ 15 + C ((-1121600669737 / 2879985977 : ℚ)) * X ^ 16 + C ((1673707351295 / 17279915862 : ℚ)) * X ^ 17 + C ((2940068258008 / 8639957931 : ℚ)) * X ^ 18
def CW_200_2_pim : Polynomial ℚ := C ((3812131366742 / 8639957931 : ℚ)) + C ((7624262733484 / 8639957931 : ℚ)) * X + C ((2472119211403 / 2879985977 : ℚ)) * X ^ 2 + C ((2442248551272 / 2879985977 : ℚ)) * X ^ 3 + C ((1745535358664 / 8639957931 : ℚ)) * X ^ 4 + C ((-12536430234853 / 17279915862 : ℚ)) * X ^ 5 + C ((-1531064276329 / 1047267628 : ℚ)) * X ^ 6 + C ((-83671965732371 / 34559831724 : ℚ)) * X ^ 7 + C ((-50528866187485 / 17279915862 : ℚ)) * X ^ 8 + C ((-9158154134581 / 3141802884 : ℚ)) * X ^ 9 + C ((-99019161293243 / 34559831724 : ℚ)) * X ^ 10 + C ((-27906672739642 / 8639957931 : ℚ)) * X ^ 11 + C ((-41411406874631 / 11519943908 : ℚ)) * X ^ 12 + C ((-121682066039645 / 34559831724 : ℚ)) * X ^ 13 + C ((-500023062907 / 142809222 : ℚ)) * X ^ 14 + C ((-33238283677279 / 11519943908 : ℚ)) * X ^ 15 + C ((-23301624073209 / 11519943908 : ℚ)) * X ^ 16 + C ((-23626738587505 / 17279915862 : ℚ)) * X ^ 17 + C ((-4087913913412 / 8639957931 : ℚ)) * X ^ 18
theorem CW_200_2_pre_eq :
    CW_2_re_000 * Fplus_dW_re_200 - CW_2_im_000 * Fplus_dW_im_200 = CW_200_2_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_2_re_000, CW_2_im_000, Fplus_dW_re_200, Fplus_dW_im_200, CW_200_2_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CW_200_2_pim_eq :
    CW_2_re_000 * Fplus_dW_im_200 + CW_2_im_000 * Fplus_dW_re_200 = CW_200_2_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_2_re_000, CW_2_im_000, Fplus_dW_re_200, Fplus_dW_im_200, CW_200_2_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CW_200_2_mul :
    CW_2_c_000 * Fplus_dW_c_200 = ofLadj CW_200_2_pre CW_200_2_pim := by
  rw [CW_2_c_000, Fplus_dW_c_200, ofLadj_mul, CW_200_2_pre_eq, CW_200_2_pim_eq]

def CW_200_3_pre : Polynomial ℚ := C ((-344 / 33 : ℚ)) + C ((156 / 11 : ℚ)) * X ^ 2 + C ((432 / 11 : ℚ)) * X ^ 3 + C ((636 / 11 : ℚ)) * X ^ 4 + C ((784 / 11 : ℚ)) * X ^ 5 + C ((784 / 11 : ℚ)) * X ^ 6 + C ((636 / 11 : ℚ)) * X ^ 7 + C ((432 / 11 : ℚ)) * X ^ 8 + C ((156 / 11 : ℚ)) * X ^ 9
def CW_200_3_pim : Polynomial ℚ := C ((-8234 / 363 : ℚ)) + C ((-16468 / 363 : ℚ)) * X + C ((-7068 / 121 : ℚ)) * X ^ 2 + C ((-7708 / 121 : ℚ)) * X ^ 3 + C ((-18730 / 363 : ℚ)) * X ^ 4 + C ((-13060 / 363 : ℚ)) * X ^ 5 + C ((-1136 / 121 : ℚ)) * X ^ 6 + C ((754 / 121 : ℚ)) * X ^ 7 + C ((6656 / 363 : ℚ)) * X ^ 8 + C ((4736 / 363 : ℚ)) * X ^ 9
theorem CW_200_3_neg_re : -CW_3_re_200 = CW_200_3_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_3_re_200, CW_200_3_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CW_200_3_neg_im : -CW_3_im_200 = CW_200_3_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_3_im_200, CW_200_3_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CW_200_3_mul : -CW_3_c_200 = ofLadj CW_200_3_pre CW_200_3_pim := by
  rw [CW_3_c_200, ofLadj_neg, CW_200_3_neg_re, CW_200_3_neg_im]

@[expose] public def CW_coeff_200 : Ki := CW_0_c_000 * Fplus_dU_c_200 + CW_1_c_000 * Fplus_dV_c_200 + CW_2_c_000 * Fplus_dW_c_200 + (-CW_3_c_200)

theorem CW_coeff_200_sum :
    CW_coeff_200 = ofLadj (CW_200_0_pre + CW_200_1_pre + CW_200_2_pre + CW_200_3_pre) (CW_200_0_pim + CW_200_1_pim + CW_200_2_pim + CW_200_3_pim) := by
  simp only [CW_coeff_200, CW_200_0_mul, CW_200_1_mul, CW_200_2_mul, CW_200_3_mul]
  simpa [add_assoc] using ofLadj_add4 CW_200_0_pre CW_200_0_pim CW_200_1_pre CW_200_1_pim CW_200_2_pre CW_200_2_pim CW_200_3_pre CW_200_3_pim

def CW_200_qre : Polynomial ℚ := C ((-14554951949101 / 34559831724 : ℚ)) + C ((-2428325181499 / 34559831724 : ℚ)) * X + C ((-6170600749733 / 34559831724 : ℚ)) * X ^ 2 + C ((-671990237491 / 17279915862 : ℚ)) * X ^ 3 + C ((20282550537943 / 17279915862 : ℚ)) * X ^ 4 + C ((2255191455043 / 1570901442 : ℚ)) * X ^ 5 + C ((54384555478205 / 34559831724 : ℚ)) * X ^ 6 + C ((9964550927285 / 8639957931 : ℚ)) * X ^ 7 + C ((8053262906615 / 17279915862 : ℚ)) * X ^ 8
def CW_200_qim : Polynomial ℚ := C ((-2528809026224 / 2879985977 : ℚ)) + C ((-2528809026224 / 2879985977 : ℚ)) * X + C ((-15277776480969 / 11519943908 : ℚ)) * X ^ 2 + C ((-16340458105196 / 8639957931 : ℚ)) * X ^ 3 + C ((-51074422789157 / 34559831724 : ℚ)) * X ^ 4 + C ((-30863217519617 / 34559831724 : ℚ)) * X ^ 5 + C ((-503633393561 / 1570901442 : ℚ)) * X ^ 6 + C ((9476679405131 / 11519943908 : ℚ)) * X ^ 7 + C ((18384089734793 / 34559831724 : ℚ)) * X ^ 8
theorem CW_coeff_200_poly_re :
    CW_200_0_pre + CW_200_1_pre + CW_200_2_pre + CW_200_3_pre = (0 : Polynomial ℚ) + Phi11 * CW_200_qre := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [CW_200_0_pre, CW_200_1_pre, CW_200_2_pre, CW_200_3_pre, CW_200_qre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try ring
theorem CW_coeff_200_poly_im :
    CW_200_0_pim + CW_200_1_pim + CW_200_2_pim + CW_200_3_pim = (0 : Polynomial ℚ) + Phi11 * CW_200_qim := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [CW_200_0_pim, CW_200_1_pim, CW_200_2_pim, CW_200_3_pim, CW_200_qim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try ring
public theorem CW_coeff_200_eq :
    CW_coeff_200 = (0 : Ki) := by
  rw [CW_coeff_200_sum, CW_coeff_200_poly_re,
    CW_coeff_200_poly_im, ofLadj_add_Phi11]
  exact ofLadj_zero

end V14Formalization.D12SigmaPlusSegreCore
