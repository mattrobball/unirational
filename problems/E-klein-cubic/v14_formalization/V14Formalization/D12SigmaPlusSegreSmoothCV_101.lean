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

def CV_101_0_pre : Polynomial ℚ := C ((35895417159262 / 8639957931 : ℚ)) + C ((261482149647472 / 8639957931 : ℚ)) * X + C ((491940985611346 / 8639957931 : ℚ)) * X ^ 2 + C ((1547058307166965 / 17279915862 : ℚ)) * X ^ 3 + C ((367460272654378 / 2879985977 : ℚ)) * X ^ 4 + C ((1262470420606673 / 8639957931 : ℚ)) * X ^ 5 + C ((125729593730465 / 785450721 : ℚ)) * X ^ 6 + C ((2876081840155439 / 17279915862 : ℚ)) * X ^ 7 + C ((1332233181793012 / 8639957931 : ℚ)) * X ^ 8 + C ((1312174356693551 / 8639957931 : ℚ)) * X ^ 9 + C ((1296566614292506 / 8639957931 : ℚ)) * X ^ 10 + C ((1255143678810488 / 8639957931 : ℚ)) * X ^ 11 + C ((345028154881678 / 2879985977 : ℚ)) * X ^ 12 + C ((820233371082205 / 8639957931 : ℚ)) * X ^ 13 + C ((1117408056419059 / 17279915862 : ℚ)) * X ^ 14 + C ((497067773549599 / 17279915862 : ℚ)) * X ^ 15 + C ((66266183870957 / 5759971954 : ℚ)) * X ^ 16 + C ((-42311669244013 / 17279915862 : ℚ)) * X ^ 17 + C ((-87126215339786 / 8639957931 : ℚ)) * X ^ 18
def CV_101_0_pim : Polynomial ℚ := C ((-117705886286206 / 8639957931 : ℚ)) + C ((-235411772572412 / 8639957931 : ℚ)) * X + C ((-223082687436344 / 8639957931 : ℚ)) * X ^ 2 + C ((-448371793643311 / 17279915862 : ℚ)) * X ^ 3 + C ((-20597738343671 / 2879985977 : ℚ)) * X ^ 4 + C ((188119434676487 / 8639957931 : ℚ)) * X ^ 5 + C ((379360619643658 / 8639957931 : ℚ)) * X ^ 6 + C ((1247844978850889 / 17279915862 : ℚ)) * X ^ 7 + C ((22983688060381 / 261816907 : ℚ)) * X ^ 8 + C ((251829269078377 / 2879985977 : ℚ)) * X ^ 9 + C ((742148312278066 / 8639957931 : ℚ)) * X ^ 10 + C ((76388138604302 / 785450721 : ℚ)) * X ^ 11 + C ((938390737016578 / 8639957931 : ℚ)) * X ^ 12 + C ((82974741538495 / 785450721 : ℚ)) * X ^ 13 + C ((1821702935102629 / 17279915862 : ℚ)) * X ^ 14 + C ((1514065224873073 / 17279915862 : ℚ)) * X ^ 15 + C ((349469535472597 / 5759971954 : ℚ)) * X ^ 16 + C ((235628612795461 / 5759971954 : ℚ)) * X ^ 17 + C ((3817133027008 / 261816907 : ℚ)) * X ^ 18
theorem CV_101_0_pre_eq :
    CV_0_re_000 * Fplus_dU_re_101 - CV_0_im_000 * Fplus_dU_im_101 = CV_101_0_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_0_re_000, CV_0_im_000, Fplus_dU_re_101, Fplus_dU_im_101, CV_101_0_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CV_101_0_pim_eq :
    CV_0_re_000 * Fplus_dU_im_101 + CV_0_im_000 * Fplus_dU_re_101 = CV_101_0_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_0_re_000, CV_0_im_000, Fplus_dU_re_101, Fplus_dU_im_101, CV_101_0_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CV_101_0_mul :
    CV_0_c_000 * Fplus_dU_c_101 = ofLadj CV_101_0_pre CV_101_0_pim := by
  rw [CV_0_c_000, Fplus_dU_c_101, ofLadj_mul, CV_101_0_pre_eq, CV_101_0_pim_eq]

def CV_101_1_pre : Polynomial ℚ := C ((-19581996919984 / 8639957931 : ℚ)) + C ((-270076688425600 / 8639957931 : ℚ)) * X + C ((-548750621269055 / 8639957931 : ℚ)) * X ^ 2 + C ((-902363214835562 / 8639957931 : ℚ)) * X ^ 3 + C ((-1343780698728487 / 8639957931 : ℚ)) * X ^ 4 + C ((-532110061012875 / 2879985977 : ℚ)) * X ^ 5 + C ((-1800766498814941 / 8639957931 : ℚ)) * X ^ 6 + C ((-3824481357397055 / 17279915862 : ℚ)) * X ^ 7 + C ((-3643473523979989 / 17279915862 : ℚ)) * X ^ 8 + C ((-3574530472999403 / 17279915862 : ℚ)) * X ^ 9 + C ((-586997196722608 / 2879985977 : ℚ)) * X ^ 10 + C ((-1731571026299819 / 8639957931 : ℚ)) * X ^ 11 + C ((-1490914901742224 / 8639957931 : ℚ)) * X ^ 12 + C ((-2477029230461293 / 17279915862 : ℚ)) * X ^ 13 + C ((-612915698102955 / 5759971954 : ℚ)) * X ^ 14 + C ((-1019204643263407 / 17279915862 : ℚ)) * X ^ 15 + C ((-275885323933877 / 8639957931 : ℚ)) * X ^ 16 + C ((-71449008157561 / 8639957931 : ℚ)) * X ^ 17 + C ((58857658338337 / 8639957931 : ℚ)) * X ^ 18
def CV_101_1_pim : Polynomial ℚ := C ((1504296165700 / 71404611 : ℚ)) + C ((3008592331400 / 71404611 : ℚ)) * X + C ((431580460309124 / 8639957931 : ℚ)) * X ^ 2 + C ((509140710756896 / 8639957931 : ℚ)) * X ^ 3 + C ((127559870337495 / 2879985977 : ℚ)) * X ^ 4 + C ((44699653696083 / 2879985977 : ℚ)) * X ^ 5 + C ((-65391891552920 / 8639957931 : ℚ)) * X ^ 6 + C ((-717663582240053 / 17279915862 : ℚ)) * X ^ 7 + C ((-351079438529559 / 5759971954 : ℚ)) * X ^ 8 + C ((-8622391894603 / 142809222 : ℚ)) * X ^ 9 + C ((-166289695331454 / 2879985977 : ℚ)) * X ^ 10 + C ((-647492656086560 / 8639957931 : ℚ)) * X ^ 11 + C ((-796116226178758 / 8639957931 : ℚ)) * X ^ 12 + C ((-1681742781518725 / 17279915862 : ℚ)) * X ^ 13 + C ((-1826934386072555 / 17279915862 : ℚ)) * X ^ 14 + C ((-534313059495319 / 5759971954 : ℚ)) * X ^ 15 + C ((-582158414253019 / 8639957931 : ℚ)) * X ^ 16 + C ((-417494295356030 / 8639957931 : ℚ)) * X ^ 17 + C ((-153323870723200 / 8639957931 : ℚ)) * X ^ 18
theorem CV_101_1_pre_eq :
    CV_1_re_000 * Fplus_dV_re_101 - CV_1_im_000 * Fplus_dV_im_101 = CV_101_1_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_1_re_000, CV_1_im_000, Fplus_dV_re_101, Fplus_dV_im_101, CV_101_1_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CV_101_1_pim_eq :
    CV_1_re_000 * Fplus_dV_im_101 + CV_1_im_000 * Fplus_dV_re_101 = CV_101_1_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_1_re_000, CV_1_im_000, Fplus_dV_re_101, Fplus_dV_im_101, CV_101_1_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CV_101_1_mul :
    CV_1_c_000 * Fplus_dV_c_101 = ofLadj CV_101_1_pre CV_101_1_pim := by
  rw [CV_1_c_000, Fplus_dV_c_101, ofLadj_mul, CV_101_1_pre_eq, CV_101_1_pim_eq]

def CV_101_2_pre : Polynomial ℚ := C ((-10241362160780 / 8639957931 : ℚ)) + C ((-179221392134120 / 8639957931 : ℚ)) * X + C ((-118776918270426 / 2879985977 : ℚ)) * X ^ 2 + C ((-385520466192987 / 5759971954 : ℚ)) * X ^ 3 + C ((-1760465860197265 / 17279915862 : ℚ)) * X ^ 4 + C ((-2124753237648761 / 17279915862 : ℚ)) * X ^ 5 + C ((-1231325065097009 / 8639957931 : ℚ)) * X ^ 6 + C ((-1342013101654961 / 8639957931 : ℚ)) * X ^ 7 + C ((-2640188410095409 / 17279915862 : ℚ)) * X ^ 8 + C ((-243286789280033 / 1570901442 : ℚ)) * X ^ 9 + C ((-1351284275544524 / 8639957931 : ℚ)) * X ^ 10 + C ((-1346489767303039 / 8639957931 : ℚ)) * X ^ 11 + C ((-390687627803468 / 2879985977 : ℚ)) * X ^ 12 + C ((-1963493172457807 / 17279915862 : ℚ)) * X ^ 13 + C ((-741813505758224 / 8639957931 : ℚ)) * X ^ 14 + C ((-847610934135751 / 17279915862 : ℚ)) * X ^ 15 + C ((-21079172985865 / 785450721 : ℚ)) * X ^ 16 + C ((-125844913143773 / 17279915862 : ℚ)) * X ^ 17 + C ((37974704488453 / 8639957931 : ℚ)) * X ^ 18
def CV_101_2_pim : Polynomial ℚ := C ((11695936558895 / 785450721 : ℚ)) + C ((23391873117790 / 785450721 : ℚ)) * X + C ((311741377569889 / 8639957931 : ℚ)) * X ^ 2 + C ((261256584146953 / 5759971954 : ℚ)) * X ^ 3 + C ((226195283504207 / 5759971954 : ℚ)) * X ^ 4 + C ((412078701188873 / 17279915862 : ℚ)) * X ^ 5 + C ((101577379477214 / 8639957931 : ℚ)) * X ^ 6 + C ((-85706057230127 / 8639957931 : ℚ)) * X ^ 7 + C ((-387050642116553 / 17279915862 : ℚ)) * X ^ 8 + C ((-130650063480251 / 5759971954 : ℚ)) * X ^ 9 + C ((-207718743799189 / 8639957931 : ℚ)) * X ^ 10 + C ((-353555083940678 / 8639957931 : ℚ)) * X ^ 11 + C ((-166463808027389 / 2879985977 : ℚ)) * X ^ 12 + C ((-377043897290119 / 5759971954 : ℚ)) * X ^ 13 + C ((-648159118747819 / 8639957931 : ℚ)) * X ^ 14 + C ((-392165619445799 / 5759971954 : ℚ)) * X ^ 15 + C ((-4941976479685 / 97078179 : ℚ)) * X ^ 16 + C ((-211720257976901 / 5759971954 : ℚ)) * X ^ 17 + C ((-38379334147717 / 2879985977 : ℚ)) * X ^ 18
theorem CV_101_2_pre_eq :
    CV_2_re_000 * Fplus_dW_re_101 - CV_2_im_000 * Fplus_dW_im_101 = CV_101_2_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_2_re_000, CV_2_im_000, Fplus_dW_re_101, Fplus_dW_im_101, CV_101_2_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CV_101_2_pim_eq :
    CV_2_re_000 * Fplus_dW_im_101 + CV_2_im_000 * Fplus_dW_re_101 = CV_101_2_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_2_re_000, CV_2_im_000, Fplus_dW_re_101, Fplus_dW_im_101, CV_101_2_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CV_101_2_mul :
    CV_2_c_000 * Fplus_dW_c_101 = ofLadj CV_101_2_pre CV_101_2_pim := by
  rw [CV_2_c_000, Fplus_dW_c_101, ofLadj_mul, CV_101_2_pre_eq, CV_101_2_pim_eq]

def CV_101_3_pre : Polynomial ℚ := C ((103255026730 / 785450721 : ℚ)) + C ((-77000926470 / 261816907 : ℚ)) * X ^ 2 + C ((-555587834105 / 785450721 : ℚ)) * X ^ 3 + C ((-836594421007 / 785450721 : ℚ)) * X ^ 4 + C ((-1010538108323 / 785450721 : ℚ)) * X ^ 5 + C ((-1010538108323 / 785450721 : ℚ)) * X ^ 6 + C ((-836594421007 / 785450721 : ℚ)) * X ^ 7 + C ((-555587834105 / 785450721 : ℚ)) * X ^ 8 + C ((-77000926470 / 261816907 : ℚ)) * X ^ 9
def CV_101_3_pim : Polynomial ℚ := C ((3369445953092 / 8639957931 : ℚ)) + C ((6738891906184 / 8639957931 : ℚ)) * X + C ((9036411812942 / 8639957931 : ℚ)) * X ^ 2 + C ((3165212187209 / 2879985977 : ℚ)) * X ^ 3 + C ((8066567221873 / 8639957931 : ℚ)) * X ^ 4 + C ((1697584620477 / 2879985977 : ℚ)) * X ^ 5 + C ((1646138044753 / 8639957931 : ℚ)) * X ^ 6 + C ((-442558438563 / 2879985977 : ℚ)) * X ^ 7 + C ((-2756744655443 / 8639957931 : ℚ)) * X ^ 8 + C ((-2297519906758 / 8639957931 : ℚ)) * X ^ 9
theorem CV_101_3_neg_re : -CV_3_re_101 = CV_101_3_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_3_re_101, CV_101_3_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CV_101_3_neg_im : -CV_3_im_101 = CV_101_3_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_3_im_101, CV_101_3_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CV_101_3_mul : -CV_3_c_101 = ofLadj CV_101_3_pre CV_101_3_pim := by
  rw [CV_3_c_101, ofLadj_neg, CV_101_3_neg_re, CV_101_3_neg_im]

@[expose] public def CV_coeff_101 : Ki := CV_0_c_000 * Fplus_dU_c_101 + CV_1_c_000 * Fplus_dV_c_101 + CV_2_c_000 * Fplus_dW_c_101 + (-CV_3_c_101)

theorem CV_coeff_101_sum :
    CV_coeff_101 = ofLadj (CV_101_0_pre + CV_101_1_pre + CV_101_2_pre + CV_101_3_pre) (CV_101_0_pim + CV_101_1_pim + CV_101_2_pim + CV_101_3_pim) := by
  simp only [CV_coeff_101, CV_101_0_mul, CV_101_1_mul, CV_101_2_mul, CV_101_3_mul]
  simpa [add_assoc] using ofLadj_add4 CV_101_0_pre CV_101_0_pim CV_101_1_pre CV_101_1_pim CV_101_2_pre CV_101_2_pim CV_101_3_pre CV_101_3_pim

def CV_101_qre : Polynomial ℚ := C ((2402621124176 / 2879985977 : ℚ)) + C ((-195023794284776 / 8639957931 : ℚ)) * X + C ((-227865490130249 / 8639957931 : ℚ)) * X ^ 2 + C ((-99181601891406 / 2879985977 : ℚ)) * X ^ 3 + C ((-75928931414245 / 1570901442 : ℚ)) * X ^ 4 + C ((-276516950952823 / 8639957931 : ℚ)) * X ^ 5 + C ((-168553101080335 / 5759971954 : ℚ)) * X ^ 6 + C ((-165233446838458 / 8639957931 : ℚ)) * X ^ 7 + C ((3235382495668 / 2879985977 : ℚ)) * X ^ 8
def CV_101_qim : Polynomial ℚ := C ((65446232621477 / 2879985977 : ℚ)) + C ((65446232621477 / 2879985977 : ℚ)) * X + C ((45532722175583 / 2879985977 : ℚ)) * X ^ 2 + C ((52353254820562 / 2879985977 : ℚ)) * X ^ 3 + C ((-36178876515283 / 17279915862 : ℚ)) * X ^ 4 + C ((-134895388239052 / 8639957931 : ℚ)) * X ^ 5 + C ((-232316509215797 / 17279915862 : ℚ)) * X ^ 6 + C ((-239135279853103 / 8639957931 : ℚ)) * X ^ 7 + C ((-142496483275087 / 8639957931 : ℚ)) * X ^ 8
theorem CV_coeff_101_poly_re :
    CV_101_0_pre + CV_101_1_pre + CV_101_2_pre + CV_101_3_pre = (0 : Polynomial ℚ) + Phi11 * CV_101_qre := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [CV_101_0_pre, CV_101_1_pre, CV_101_2_pre, CV_101_3_pre, CV_101_qre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try grind
theorem CV_coeff_101_poly_im :
    CV_101_0_pim + CV_101_1_pim + CV_101_2_pim + CV_101_3_pim = (0 : Polynomial ℚ) + Phi11 * CV_101_qim := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [CV_101_0_pim, CV_101_1_pim, CV_101_2_pim, CV_101_3_pim, CV_101_qim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try grind
public theorem CV_coeff_101_eq :
    CV_coeff_101 = (0 : Ki) := by
  rw [CV_coeff_101_sum, CV_coeff_101_poly_re,
    CV_coeff_101_poly_im, ofLadj_add_Phi11]
  exact ofLadj_zero

end V14Formalization.D12SigmaPlusSegreCore
