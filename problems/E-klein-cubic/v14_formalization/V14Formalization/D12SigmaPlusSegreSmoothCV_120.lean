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

def CV_120_0_pre : Polynomial ℚ := C ((-127219876790 / 8639957931 : ℚ)) + C ((2393649111190 / 8639957931 : ℚ)) * X + C ((8546723605033 / 17279915862 : ℚ)) * X ^ 2 + C ((123728576333 / 142809222 : ℚ)) * X ^ 3 + C ((8300347165197 / 5759971954 : ℚ)) * X ^ 4 + C ((31958814146477 / 17279915862 : ℚ)) * X ^ 5 + C ((6529840009873 / 2879985977 : ℚ)) * X ^ 6 + C ((22313492180072 / 8639957931 : ℚ)) * X ^ 7 + C ((2067582505294 / 785450721 : ℚ)) * X ^ 8 + C ((46906650727405 / 17279915862 : ℚ)) * X ^ 9 + C ((24134241552035 / 8639957931 : ℚ)) * X ^ 10 + C ((24401639871530 / 8639957931 : ℚ)) * X ^ 11 + C ((21740592440845 / 8639957931 : ℚ)) * X ^ 12 + C ((6393321187062 / 2879985977 : ℚ)) * X ^ 13 + C ((2774150670925 / 1570901442 : ℚ)) * X ^ 14 + C ((18978200467283 / 17279915862 : ℚ)) * X ^ 15 + C ((123604195457 / 194156358 : ℚ)) * X ^ 16 + C ((630091247152 / 2879985977 : ℚ)) * X ^ 17 + C ((-33988290785 / 785450721 : ℚ)) * X ^ 18
def CV_120_0_pim : Polynomial ℚ := C ((-2248022966449 / 8639957931 : ℚ)) + C ((-4496045932898 / 8639957931 : ℚ)) * X + C ((-3923591935297 / 5759971954 : ℚ)) * X ^ 2 + C ((-17140542105223 / 17279915862 : ℚ)) * X ^ 3 + C ((-5887031604593 / 5759971954 : ℚ)) * X ^ 4 + C ((-15902498025391 / 17279915862 : ℚ)) * X ^ 5 + C ((-6982031408195 / 8639957931 : ℚ)) * X ^ 6 + C ((-4322693568728 / 8639957931 : ℚ)) * X ^ 7 + C ((-809312373819 / 2879985977 : ℚ)) * X ^ 8 + C ((-4695498872081 / 17279915862 : ℚ)) * X ^ 9 + C ((-1793897916853 / 8639957931 : ℚ)) * X ^ 10 + C ((1212266369557 / 8639957931 : ℚ)) * X ^ 11 + C ((127831231999 / 261816907 : ℚ)) * X ^ 12 + C ((6161624145202 / 8639957931 : ℚ)) * X ^ 13 + C ((17853389960569 / 17279915862 : ℚ)) * X ^ 14 + C ((17912808238871 / 17279915862 : ℚ)) * X ^ 15 + C ((14611139457275 / 17279915862 : ℚ)) * X ^ 16 + C ((1852065832823 / 2879985977 : ℚ)) * X ^ 17 + C ((2125323662398 / 8639957931 : ℚ)) * X ^ 18
theorem CV_120_0_pre_eq :
    CV_0_re_100 * Fplus_dU_re_020 - CV_0_im_100 * Fplus_dU_im_020 = CV_120_0_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_0_re_100_def, CV_0_im_100_def, Fplus_dU_re_020_def, Fplus_dU_im_020_def, CV_120_0_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CV_120_0_pim_eq :
    CV_0_re_100 * Fplus_dU_im_020 + CV_0_im_100 * Fplus_dU_re_020 = CV_120_0_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_0_re_100_def, CV_0_im_100_def, Fplus_dU_re_020_def, Fplus_dU_im_020_def, CV_120_0_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CV_120_0_mul :
    CV_0_c_100 * Fplus_dU_c_020 = ofLadj CV_120_0_pre CV_120_0_pim := by
  rw [CV_0_c_100_def, Fplus_dU_c_020_def, ofLadj_mul, CV_120_0_pre_eq, CV_120_0_pim_eq]

def CV_120_1_pre : Polynomial ℚ := C ((-383732292670 / 2879985977 : ℚ)) + C ((-3927461430000 / 2879985977 : ℚ)) * X + C ((-6811170737839 / 2879985977 : ℚ)) * X ^ 2 + C ((-22034507658527 / 5759971954 : ℚ)) * X ^ 3 + C ((-33315798759935 / 5759971954 : ℚ)) * X ^ 4 + C ((-18890363381539 / 2879985977 : ℚ)) * X ^ 5 + C ((-21707336297521 / 2879985977 : ℚ)) * X ^ 6 + C ((-49827125090211 / 5759971954 : ℚ)) * X ^ 7 + C ((-25508304007669 / 2879985977 : ℚ)) * X ^ 8 + C ((-27507446625663 / 2879985977 : ℚ)) * X ^ 9 + C ((-58038174337971 / 5759971954 : ℚ)) * X ^ 10 + C ((-29198693305294 / 2879985977 : ℚ)) * X ^ 11 + C ((-50183251477971 / 5759971954 : ℚ)) * X ^ 12 + C ((-20696275887824 / 2879985977 : ℚ)) * X ^ 13 + C ((-28982100356811 / 5759971954 : ℚ)) * X ^ 14 + C ((-7015820078210 / 2879985977 : ℚ)) * X ^ 15 + C ((-3697988546839 / 2879985977 : ℚ)) * X ^ 16 + C ((-881015630857 / 2879985977 : ℚ)) * X ^ 17 + C ((1239843086928 / 2879985977 : ℚ)) * X ^ 18
def CV_120_1_pim : Polynomial ℚ := C ((2262797247415 / 2879985977 : ℚ)) + C ((4525594494830 / 2879985977 : ℚ)) * X + C ((5181446676783 / 2879985977 : ℚ)) * X ^ 2 + C ((13518549790241 / 5759971954 : ℚ)) * X ^ 3 + C ((10109523438519 / 5759971954 : ℚ)) * X ^ 4 + C ((2307281958863 / 2879985977 : ℚ)) * X ^ 5 + C ((1597184989031 / 2879985977 : ℚ)) * X ^ 6 + C ((-2499567205577 / 5759971954 : ℚ)) * X ^ 7 + C ((-3378504202825 / 2879985977 : ℚ)) * X ^ 8 + C ((-3669153425145 / 2879985977 : ℚ)) * X ^ 9 + C ((-9988899472841 / 5759971954 : ℚ)) * X ^ 10 + C ((-9181197244236 / 2879985977 : ℚ)) * X ^ 11 + C ((-26735889504103 / 5759971954 : ℚ)) * X ^ 12 + C ((-15349093245280 / 2879985977 : ℚ)) * X ^ 13 + C ((-34435141371875 / 5759971954 : ℚ)) * X ^ 14 + C ((-14674740718597 / 2879985977 : ℚ)) * X ^ 15 + C ((-10230014182552 / 2879985977 : ℚ)) * X ^ 16 + C ((-7511252758984 / 2879985977 : ℚ)) * X ^ 17 + C ((-269730671956 / 261816907 : ℚ)) * X ^ 18
theorem CV_120_1_pre_eq :
    CV_1_re_100 * Fplus_dV_re_020 - CV_1_im_100 * Fplus_dV_im_020 = CV_120_1_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_1_re_100_def, CV_1_im_100_def, Fplus_dV_re_020_def, Fplus_dV_im_020_def, CV_120_1_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CV_120_1_pim_eq :
    CV_1_re_100 * Fplus_dV_im_020 + CV_1_im_100 * Fplus_dV_re_020 = CV_120_1_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_1_re_100_def, CV_1_im_100_def, Fplus_dV_re_020_def, Fplus_dV_im_020_def, CV_120_1_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CV_120_1_mul :
    CV_1_c_100 * Fplus_dV_c_020 = ofLadj CV_120_1_pre CV_120_1_pim := by
  rw [CV_1_c_100_def, Fplus_dV_c_020_def, ofLadj_mul, CV_120_1_pre_eq, CV_120_1_pim_eq]

def CV_120_2_pre : Polynomial ℚ := C ((-444527066284 / 785450721 : ℚ)) + C ((-23521795828664 / 2879985977 : ℚ)) * X + C ((-12691961191573 / 785450721 : ℚ)) * X ^ 2 + C ((-228272949976121 / 8639957931 : ℚ)) * X ^ 3 + C ((-227178121647617 / 5759971954 : ℚ)) * X ^ 4 + C ((-810898932247807 / 17279915862 : ℚ)) * X ^ 5 + C ((-917809879276163 / 17279915862 : ℚ)) * X ^ 6 + C ((-163603168060940 / 2879985977 : ℚ)) * X ^ 7 + C ((-468115968206165 / 8639957931 : ℚ)) * X ^ 8 + C ((-925527188165125 / 17279915862 : ℚ)) * X ^ 9 + C ((-917624431577581 / 17279915862 : ℚ)) * X ^ 10 + C ((-452373005112943 / 8639957931 : ℚ)) * X ^ 11 + C ((-776493656605597 / 17279915862 : ℚ)) * X ^ 12 + C ((-215434680650173 / 5759971954 : ℚ)) * X ^ 13 + C ((-79947672743348 / 2879985977 : ℚ)) * X ^ 14 + C ((-132170012122969 / 8639957931 : ℚ)) * X ^ 15 + C ((-140727596830999 / 17279915862 : ℚ)) * X ^ 16 + C ((-11272216600881 / 5759971954 : ℚ)) * X ^ 17 + C ((35744619176851 / 17279915862 : ℚ)) * X ^ 18
def CV_120_2_pim : Polynomial ℚ := C ((48093908855792 / 8639957931 : ℚ)) + C ((96187817711584 / 8639957931 : ℚ)) * X + C ((112203820254959 / 8639957931 : ℚ)) * X ^ 2 + C ((135252519308557 / 8639957931 : ℚ)) * X ^ 3 + C ((207486804063997 / 17279915862 : ℚ)) * X ^ 4 + C ((81318840484909 / 17279915862 : ℚ)) * X ^ 5 + C ((-7225919854595 / 5759971954 : ℚ)) * X ^ 6 + C ((-29249064270117 / 2879985977 : ℚ)) * X ^ 7 + C ((-132942464620220 / 8639957931 : ℚ)) * X ^ 8 + C ((-264274397257999 / 17279915862 : ℚ)) * X ^ 9 + C ((-257290773559579 / 17279915862 : ℚ)) * X ^ 10 + C ((-57211623574052 / 2879985977 : ℚ)) * X ^ 11 + C ((-429248709329045 / 17279915862 : ℚ)) * X ^ 12 + C ((-454297090717375 / 17279915862 : ℚ)) * X ^ 13 + C ((-249391978421065 / 8639957931 : ℚ)) * X ^ 14 + C ((-73388353300890 / 2879985977 : ℚ)) * X ^ 15 + C ((-29367492163525 / 1570901442 : ℚ)) * X ^ 16 + C ((-76920838195935 / 5759971954 : ℚ)) * X ^ 17 + C ((-85826146103411 / 17279915862 : ℚ)) * X ^ 18
theorem CV_120_2_pre_eq :
    CV_2_re_100 * Fplus_dW_re_020 - CV_2_im_100 * Fplus_dW_im_020 = CV_120_2_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_2_re_100_def, CV_2_im_100_def, Fplus_dW_re_020_def, Fplus_dW_im_020_def, CV_120_2_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CV_120_2_pim_eq :
    CV_2_re_100 * Fplus_dW_im_020 + CV_2_im_100 * Fplus_dW_re_020 = CV_120_2_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_2_re_100_def, CV_2_im_100_def, Fplus_dW_re_020_def, Fplus_dW_im_020_def, CV_120_2_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CV_120_2_mul :
    CV_2_c_100 * Fplus_dW_c_020 = ofLadj CV_120_2_pre CV_120_2_pim := by
  rw [CV_2_c_100_def, Fplus_dW_c_020_def, ofLadj_mul, CV_120_2_pre_eq, CV_120_2_pim_eq]

theorem CV_120_3_mul : CV_3_c_110 = ofLadj CV_3_re_110 CV_3_im_110 := CV_3_c_110_def

@[expose] public def CV_coeff_120 : Ki := CV_0_c_100 * Fplus_dU_c_020 + CV_1_c_100 * Fplus_dV_c_020 + CV_2_c_100 * Fplus_dW_c_020 + CV_3_c_110

theorem CV_coeff_120_sum :
    CV_coeff_120 = ofLadj (CV_120_0_pre + CV_120_1_pre + CV_120_2_pre + CV_3_re_110) (CV_120_0_pim + CV_120_1_pim + CV_120_2_pim + CV_3_im_110) := by
  simp only [CV_coeff_120, CV_120_0_mul, CV_120_1_mul, CV_120_2_mul, CV_120_3_mul]
  simpa [add_assoc] using ofLadj_add4 CV_120_0_pre CV_120_0_pim CV_120_1_pre CV_120_1_pim CV_120_2_pre CV_120_2_pim CV_3_re_110 CV_3_im_110

def CV_120_qre : Polynomial ℚ := C ((-6167790586417 / 8639957931 : ℚ)) + C ((-73786332078385 / 8639957931 : ℚ)) * X + C ((-151440456002729 / 17279915862 : ℚ)) * X ^ 2 + C ((-196005090004745 / 17279915862 : ℚ)) * X ^ 3 + C ((-248659935902431 / 17279915862 : ℚ)) * X ^ 4 + C ((-45180663177185 / 5759971954 : ℚ)) * X ^ 5 + C ((-38864186203829 / 5759971954 : ℚ)) * X ^ 6 + C ((-38879065703011 / 8639957931 : ℚ)) * X ^ 7 + C ((42435935301149 / 17279915862 : ℚ)) * X ^ 8
def CV_120_qim : Polynomial ℚ := C ((52543562179403 / 8639957931 : ℚ)) + C ((52543562179403 / 8639957931 : ℚ)) * X + C ((11016295123077 / 5759971954 : ℚ)) * X ^ 2 + C ((50167589098535 / 17279915862 : ℚ)) * X ^ 3 + C ((-24590078373045 / 5759971954 : ℚ)) * X ^ 4 + C ((-140654396441239 / 17279915862 : ℚ)) * X ^ 5 + C ((-3184658281577 / 523633814 : ℚ)) * X ^ 6 + C ((-27556652169510 / 2879985977 : ℚ)) * X ^ 7 + C ((-33125907709237 / 5759971954 : ℚ)) * X ^ 8
theorem CV_coeff_120_poly_re :
    CV_120_0_pre + CV_120_1_pre + CV_120_2_pre + CV_3_re_110 = (0 : Polynomial ℚ) + Phi11 * CV_120_qre := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [CV_120_0_pre, CV_120_1_pre, CV_120_2_pre, CV_3_re_110_def, CV_120_qre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try grind
theorem CV_coeff_120_poly_im :
    CV_120_0_pim + CV_120_1_pim + CV_120_2_pim + CV_3_im_110 = (0 : Polynomial ℚ) + Phi11 * CV_120_qim := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [CV_120_0_pim, CV_120_1_pim, CV_120_2_pim, CV_3_im_110_def, CV_120_qim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try grind
public theorem CV_coeff_120_eq :
    CV_coeff_120 = (0 : Ki) := by
  rw [CV_coeff_120_sum, CV_coeff_120_poly_re,
    CV_coeff_120_poly_im, ofLadj_add_Phi11]
  exact ofLadj_zero

end V14Formalization.D12SigmaPlusSegreCore
