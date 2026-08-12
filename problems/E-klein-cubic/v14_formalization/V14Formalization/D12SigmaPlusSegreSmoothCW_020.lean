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

def CW_020_0_pre : Polynomial ℚ := C ((-154529306059 / 8639957931 : ℚ)) + C ((15673442511575 / 8639957931 : ℚ)) * X + C ((29396068681171 / 8639957931 : ℚ)) * X ^ 2 + C ((102440088106991 / 17279915862 : ℚ)) * X ^ 3 + C ((167175257091991 / 17279915862 : ℚ)) * X ^ 4 + C ((888522025652 / 71404611 : ℚ)) * X ^ 5 + C ((43897906137104 / 2879985977 : ℚ)) * X ^ 6 + C ((300849651507731 / 17279915862 : ℚ)) * X ^ 7 + C ((305802080332819 / 17279915862 : ℚ)) * X ^ 8 + C ((105446909394251 / 5759971954 : ℚ)) * X ^ 9 + C ((162375577772164 / 8639957931 : ℚ)) * X ^ 10 + C ((109223127292733 / 5759971954 : ℚ)) * X ^ 11 + C ((146702135260589 / 8639957931 : ℚ)) * X ^ 12 + C ((23413508256401 / 1570901442 : ℚ)) * X ^ 13 + C ((101680996112914 / 8639957931 : ℚ)) * X ^ 14 + C ((128522929557853 / 17279915862 : ℚ)) * X ^ 15 + C ((12494744926484 / 2879985977 : ℚ)) * X ^ 16 + C ((13301681472032 / 8639957931 : ℚ)) * X ^ 17 + C ((-1717154952629 / 5759971954 : ℚ)) * X ^ 18
def CW_020_0_pim : Polynomial ℚ := C ((-29040669877885 / 17279915862 : ℚ)) + C ((-29040669877885 / 8639957931 : ℚ)) * X + C ((-78369643917865 / 17279915862 : ℚ)) * X ^ 2 + C ((-10076264119789 / 1570901442 : ℚ)) * X ^ 3 + C ((-5218464085691 / 785450721 : ℚ)) * X ^ 4 + C ((-103009096579421 / 17279915862 : ℚ)) * X ^ 5 + C ((-45029756312053 / 8639957931 : ℚ)) * X ^ 6 + C ((-26587526287103 / 8639957931 : ℚ)) * X ^ 7 + C ((-2482159547159 / 1570901442 : ℚ)) * X ^ 8 + C ((-12951406371124 / 8639957931 : ℚ)) * X ^ 9 + C ((-18572095480133 / 17279915862 : ℚ)) * X ^ 10 + C ((20713604136215 / 17279915862 : ℚ)) * X ^ 11 + C ((19999767917521 / 5759971954 : ℚ)) * X ^ 12 + C ((87618325176773 / 17279915862 : ℚ)) * X ^ 13 + C ((60744264426544 / 8639957931 : ℚ)) * X ^ 14 + C ((121177858947007 / 17279915862 : ℚ)) * X ^ 15 + C ((99892443248075 / 17279915862 : ℚ)) * X ^ 16 + C ((38261017236056 / 8639957931 : ℚ)) * X ^ 17 + C ((30149272029061 / 17279915862 : ℚ)) * X ^ 18
theorem CW_020_0_pre_eq :
    CW_0_re_000 * Fplus_dU_re_020 - CW_0_im_000 * Fplus_dU_im_020 = CW_020_0_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_0_re_000, CW_0_im_000, Fplus_dU_re_020, Fplus_dU_im_020, CW_020_0_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CW_020_0_pim_eq :
    CW_0_re_000 * Fplus_dU_im_020 + CW_0_im_000 * Fplus_dU_re_020 = CW_020_0_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_0_re_000, CW_0_im_000, Fplus_dU_re_020, Fplus_dU_im_020, CW_020_0_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CW_020_0_mul :
    CW_0_c_000 * Fplus_dU_c_020 = ofLadj CW_020_0_pre CW_020_0_pim := by
  rw [CW_0_c_000, Fplus_dU_c_020, ofLadj_mul, CW_020_0_pre_eq, CW_020_0_pim_eq]

def CW_020_1_pre : Polynomial ℚ := C ((-781794324331 / 5759971954 : ℚ)) + C ((-4344976040630 / 2879985977 : ℚ)) * X + C ((-15011371567035 / 5759971954 : ℚ)) * X ^ 2 + C ((-12127211250320 / 2879985977 : ℚ)) * X ^ 3 + C ((-18414668766125 / 2879985977 : ℚ)) * X ^ 4 + C ((-20811985635642 / 2879985977 : ℚ)) * X ^ 5 + C ((-23959355458199 / 2879985977 : ℚ)) * X ^ 6 + C ((-27484838543427 / 2879985977 : ℚ)) * X ^ 7 + C ((-28152686119497 / 2879985977 : ℚ)) * X ^ 8 + C ((-30333038547227 / 2879985977 : ℚ)) * X ^ 9 + C ((-32022481249898 / 2879985977 : ℚ)) * X ^ 10 + C ((-2934029258650 / 261816907 : ℚ)) * X ^ 11 + C ((-27677505209268 / 2879985977 : ℚ)) * X ^ 12 + C ((-45654705527419 / 5759971954 : ℚ)) * X ^ 13 + C ((-16025474869177 / 2879985977 : ℚ)) * X ^ 14 + C ((-15441511877123 / 5759971954 : ℚ)) * X ^ 15 + C ((-8186916434341 / 5759971954 : ℚ)) * X ^ 16 + C ((-1892176789227 / 5759971954 : ℚ)) * X ^ 17 + C ((2698827677481 / 5759971954 : ℚ)) * X ^ 18
def CW_020_1_pim : Polynomial ℚ := C ((2520161444311 / 2879985977 : ℚ)) + C ((5040322888622 / 2879985977 : ℚ)) * X + C ((5701393774931 / 2879985977 : ℚ)) * X ^ 2 + C ((1369962206319 / 523633814 : ℚ)) * X ^ 3 + C ((5615739135475 / 2879985977 : ℚ)) * X ^ 4 + C ((5154965571691 / 5759971954 : ℚ)) * X ^ 5 + C ((3646557322161 / 5759971954 : ℚ)) * X ^ 6 + C ((-2626386696589 / 5759971954 : ℚ)) * X ^ 7 + C ((-7339476698883 / 5759971954 : ℚ)) * X ^ 8 + C ((-362352203407 / 261816907 : ℚ)) * X ^ 9 + C ((-5430390839373 / 2879985977 : ℚ)) * X ^ 10 + C ((-10090505615386 / 2879985977 : ℚ)) * X ^ 11 + C ((-14750620391399 / 2879985977 : ℚ)) * X ^ 12 + C ((-16856207879604 / 2879985977 : ℚ)) * X ^ 13 + C ((-19005742127463 / 2879985977 : ℚ)) * X ^ 14 + C ((-16175808739542 / 2879985977 : ℚ)) * X ^ 15 + C ((-22535169247137 / 5759971954 : ℚ)) * X ^ 16 + C ((-16547730331015 / 5759971954 : ℚ)) * X ^ 17 + C ((-6534850779577 / 5759971954 : ℚ)) * X ^ 18
theorem CW_020_1_pre_eq :
    CW_1_re_000 * Fplus_dV_re_020 - CW_1_im_000 * Fplus_dV_im_020 = CW_020_1_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_1_re_000, CW_1_im_000, Fplus_dV_re_020, Fplus_dV_im_020, CW_020_1_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CW_020_1_pim_eq :
    CW_1_re_000 * Fplus_dV_im_020 + CW_1_im_000 * Fplus_dV_re_020 = CW_020_1_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_1_re_000, CW_1_im_000, Fplus_dV_re_020, Fplus_dV_im_020, CW_020_1_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CW_020_1_mul :
    CW_1_c_000 * Fplus_dV_c_020 = ofLadj CW_020_1_pre CW_020_1_pim := by
  rw [CW_1_c_000, Fplus_dV_c_020, ofLadj_mul, CW_020_1_pre_eq, CW_020_1_pim_eq]

def CW_020_2_pre : Polynomial ℚ := C ((-832329794506 / 2879985977 : ℚ)) + C ((-30067783631480 / 8639957931 : ℚ)) * X + C ((-19835823857050 / 2879985977 : ℚ)) * X ^ 2 + C ((-98849490733793 / 8639957931 : ℚ)) * X ^ 3 + C ((-146477961261341 / 8639957931 : ℚ)) * X ^ 4 + C ((-31595958311377 / 1570901442 : ℚ)) * X ^ 5 + C ((-197729928431935 / 8639957931 : ℚ)) * X ^ 6 + C ((-422210744929901 / 17279915862 : ℚ)) * X ^ 7 + C ((-133949542212451 / 5759971954 : ℚ)) * X ^ 8 + C ((-397375073360923 / 17279915862 : ℚ)) * X ^ 9 + C ((-196941348516812 / 8639957931 : ℚ)) * X ^ 10 + C ((-64574352249866 / 2879985977 : ℚ)) * X ^ 11 + C ((-55624521628444 / 2879985977 : ℚ)) * X ^ 12 + C ((-278360130218623 / 17279915862 : ℚ)) * X ^ 13 + C ((-18559058651797 / 1570901442 : ℚ)) * X ^ 14 + C ((-113003914275103 / 17279915862 : ℚ)) * X ^ 15 + C ((-10172389331337 / 2879985977 : ℚ)) * X ^ 16 + C ((-4376673516433 / 5759971954 : ℚ)) * X ^ 17 + C ((2708484688686 / 2879985977 : ℚ)) * X ^ 18
def CW_020_2_pim : Polynomial ℚ := C ((20322480983762 / 8639957931 : ℚ)) + C ((40644961967524 / 8639957931 : ℚ)) * X + C ((48418174331935 / 8639957931 : ℚ)) * X ^ 2 + C ((19288056516510 / 2879985977 : ℚ)) * X ^ 3 + C ((43371866783446 / 8639957931 : ℚ)) * X ^ 4 + C ((5725377806042 / 2879985977 : ℚ)) * X ^ 5 + C ((-5146411673870 / 8639957931 : ℚ)) * X ^ 6 + C ((-78483995376317 / 17279915862 : ℚ)) * X ^ 7 + C ((-58243530431335 / 8639957931 : ℚ)) * X ^ 8 + C ((-57944659152823 / 8639957931 : ℚ)) * X ^ 9 + C ((-10281545368819 / 1570901442 : ℚ)) * X ^ 10 + C ((-74585592157432 / 8639957931 : ℚ)) * X ^ 11 + C ((-185245369572719 / 17279915862 : ℚ)) * X ^ 12 + C ((-98999737526452 / 8639957931 : ℚ)) * X ^ 13 + C ((-36048953821845 / 2879985977 : ℚ)) * X ^ 14 + C ((-63014848381897 / 5759971954 : ℚ)) * X ^ 15 + C ((-70217818516910 / 8639957931 : ℚ)) * X ^ 16 + C ((-16779375191562 / 2879985977 : ℚ)) * X ^ 17 + C ((-1648528988162 / 785450721 : ℚ)) * X ^ 18
theorem CW_020_2_pre_eq :
    CW_2_re_000 * Fplus_dW_re_020 - CW_2_im_000 * Fplus_dW_im_020 = CW_020_2_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_2_re_000, CW_2_im_000, Fplus_dW_re_020, Fplus_dW_im_020, CW_020_2_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CW_020_2_pim_eq :
    CW_2_re_000 * Fplus_dW_im_020 + CW_2_im_000 * Fplus_dW_re_020 = CW_020_2_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_2_re_000, CW_2_im_000, Fplus_dW_re_020, Fplus_dW_im_020, CW_020_2_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CW_020_2_mul :
    CW_2_c_000 * Fplus_dW_c_020 = ofLadj CW_020_2_pre CW_020_2_pim := by
  rw [CW_2_c_000, Fplus_dW_c_020, ofLadj_mul, CW_020_2_pre_eq, CW_020_2_pim_eq]

def CW_020_3_pre : Polynomial ℚ := C ((-2959787040 / 261816907 : ℚ)) + C ((80279430584 / 785450721 : ℚ)) * X ^ 2 + C ((56003545952 / 261816907 : ℚ)) * X ^ 3 + C ((263989517608 / 785450721 : ℚ)) * X ^ 4 + C ((307514171576 / 785450721 : ℚ)) * X ^ 5 + C ((307514171576 / 785450721 : ℚ)) * X ^ 6 + C ((263989517608 / 785450721 : ℚ)) * X ^ 7 + C ((56003545952 / 261816907 : ℚ)) * X ^ 8 + C ((80279430584 / 785450721 : ℚ)) * X ^ 9
def CW_020_3_pim : Polynomial ℚ := C ((-988043228960 / 8639957931 : ℚ)) + C ((-1976086457920 / 8639957931 : ℚ)) * X + C ((-2704054907608 / 8639957931 : ℚ)) * X ^ 2 + C ((-2754989660264 / 8639957931 : ℚ)) * X ^ 3 + C ((-2480929715992 / 8639957931 : ℚ)) * X ^ 4 + C ((-485134169688 / 2879985977 : ℚ)) * X ^ 5 + C ((-520683948856 / 8639957931 : ℚ)) * X ^ 6 + C ((168281086024 / 2879985977 : ℚ)) * X ^ 7 + C ((778903202344 / 8639957931 : ℚ)) * X ^ 8 + C ((242656149896 / 2879985977 : ℚ)) * X ^ 9
theorem CW_020_3_neg_re : -CW_3_re_020 = CW_020_3_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_3_re_020, CW_020_3_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CW_020_3_neg_im : -CW_3_im_020 = CW_020_3_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_3_im_020, CW_020_3_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CW_020_3_mul : -CW_3_c_020 = ofLadj CW_020_3_pre CW_020_3_pim := by
  rw [CW_3_c_020, ofLadj_neg, CW_020_3_neg_re, CW_020_3_neg_im]

def CW_coeff_020 : Ki := CW_0_c_000 * Fplus_dU_c_020 + CW_1_c_000 * Fplus_dV_c_020 + CW_2_c_000 * Fplus_dW_c_020 + (-CW_3_c_020)

theorem CW_coeff_020_sum :
    CW_coeff_020 = ofLadj (CW_020_0_pre + CW_020_1_pre + CW_020_2_pre + CW_020_3_pre) (CW_020_0_pim + CW_020_1_pim + CW_020_2_pim + CW_020_3_pim) := by
  simp only [CW_coeff_020, CW_020_0_mul, CW_020_1_mul, CW_020_2_mul, CW_020_3_mul]
  simpa [add_assoc] using ofLadj_add4 CW_020_0_pre CW_020_0_pim CW_020_1_pre CW_020_1_pim CW_020_2_pre CW_020_2_pim CW_020_3_pre CW_020_3_pim

def CW_020_qre : Polynomial ℚ := C ((-7843766296787 / 17279915862 : ℚ)) + C ((-47014772186803 / 17279915862 : ℚ)) * X + C ((-48632234524625 / 17279915862 : ℚ)) * X ^ 2 + C ((-10139192303578 / 2879985977 : ℚ)) * X ^ 3 + C ((-11022496968397 / 2879985977 : ℚ)) * X ^ 4 + C ((-3363150769413 / 2879985977 : ℚ)) * X ^ 5 + C ((-18423427759225 / 17279915862 : ℚ)) * X ^ 6 + C ((-5699557139794 / 8639957931 : ℚ)) * X ^ 7 + C ((3199321051112 / 2879985977 : ℚ)) * X ^ 8
def CW_020_qim : Polynomial ℚ := C ((24749174297585 / 17279915862 : ℚ)) + C ((24749174297585 / 17279915862 : ℚ)) * X + C ((-25071809155 / 194156358 : ℚ)) * X ^ 2 + C ((-243522755545 / 1570901442 : ℚ)) * X ^ 3 + C ((-21959054103412 / 8639957931 : ℚ)) * X ^ 4 + C ((-9462139518130 / 2879985977 : ℚ)) * X ^ 5 + C ((-11450431285617 / 5759971954 : ℚ)) * X ^ 6 + C ((-48074489621071 / 17279915862 : ℚ)) * X ^ 7 + C ((-12861459024617 / 8639957931 : ℚ)) * X ^ 8
theorem CW_coeff_020_poly_re :
    CW_020_0_pre + CW_020_1_pre + CW_020_2_pre + CW_020_3_pre = (0 : Polynomial ℚ) + Phi11 * CW_020_qre := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [CW_020_0_pre, CW_020_1_pre, CW_020_2_pre, CW_020_3_pre, CW_020_qre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try ring
theorem CW_coeff_020_poly_im :
    CW_020_0_pim + CW_020_1_pim + CW_020_2_pim + CW_020_3_pim = (0 : Polynomial ℚ) + Phi11 * CW_020_qim := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [CW_020_0_pim, CW_020_1_pim, CW_020_2_pim, CW_020_3_pim, CW_020_qim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try ring
theorem CW_coeff_020_eq :
    CW_coeff_020 = (0 : Ki) := by
  rw [CW_coeff_020_sum, CW_coeff_020_poly_re,
    CW_coeff_020_poly_im, ofLadj_add_Phi11]
  exact ofLadj_zero

end V14Formalization.D12SigmaPlusSegreCore
