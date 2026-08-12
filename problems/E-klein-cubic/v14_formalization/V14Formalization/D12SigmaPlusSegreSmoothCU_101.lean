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

def CU_101_0_pre : Polynomial ℚ := C ((1515698986916 / 235794999 : ℚ)) + C ((10413988614752 / 235794999 : ℚ)) * X + C ((6574219930304 / 78598333 : ℚ)) * X ^ 2 + C ((31611299289029 / 235794999 : ℚ)) * X ^ 3 + C ((14893635106384 / 78598333 : ℚ)) * X ^ 4 + C ((50938765455670 / 235794999 : ℚ)) * X ^ 5 + C ((56268110946031 / 235794999 : ℚ)) * X ^ 6 + C ((19427116960531 / 78598333 : ℚ)) * X ^ 7 + C ((53751687839986 / 235794999 : ℚ)) * X ^ 8 + C ((52950679705214 / 235794999 : ℚ)) * X ^ 9 + C ((17434314348491 / 78598333 : ℚ)) * X ^ 10 + C ((16846042222300 / 78598333 : ℚ)) * X ^ 11 + C ((41888954430721 / 235794999 : ℚ)) * X ^ 12 + C ((33228019914302 / 235794999 : ℚ)) * X ^ 13 + C ((22140388550957 / 235794999 : ℚ)) * X ^ 14 + C ((9825618980929 / 235794999 : ℚ)) * X ^ 15 + C ((4041384289216 / 235794999 : ℚ)) * X ^ 16 + C ((-1287961201145 / 235794999 : ℚ)) * X ^ 17 + C ((-3774826581512 / 235794999 : ℚ)) * X ^ 18
def CU_101_0_pim : Polynomial ℚ := C ((-4630444508380 / 235794999 : ℚ)) + C ((-9260889016760 / 235794999 : ℚ)) * X + C ((-3037467171724 / 78598333 : ℚ)) * X ^ 2 + C ((-8980606438753 / 235794999 : ℚ)) * X ^ 3 + C ((-1901981937850 / 235794999 : ℚ)) * X ^ 4 + C ((7899665825102 / 235794999 : ℚ)) * X ^ 5 + C ((15775351637117 / 235794999 : ℚ)) * X ^ 6 + C ((26155457987437 / 235794999 : ℚ)) * X ^ 7 + C ((31498042750976 / 235794999 : ℚ)) * X ^ 8 + C ((31392361715896 / 235794999 : ℚ)) * X ^ 9 + C ((30863959911725 / 235794999 : ℚ)) * X ^ 10 + C ((34678568141060 / 235794999 : ℚ)) * X ^ 11 + C ((38493176370395 / 235794999 : ℚ)) * X ^ 12 + C ((37816287064636 / 235794999 : ℚ)) * X ^ 13 + C ((37578810953137 / 235794999 : ℚ)) * X ^ 14 + C ((30819823415921 / 235794999 : ℚ)) * X ^ 15 + C ((21721461933464 / 235794999 : ℚ)) * X ^ 16 + C ((1336342533607 / 21435909 : ℚ)) * X ^ 17 + C ((1674315933284 / 78598333 : ℚ)) * X ^ 18
theorem CU_101_0_pre_eq :
    CU_0_re_000 * Fplus_dU_re_101 - CU_0_im_000 * Fplus_dU_im_101 = CU_101_0_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_0_re_000, CU_0_im_000, Fplus_dU_re_101, Fplus_dU_im_101, CU_101_0_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CU_101_0_pim_eq :
    CU_0_re_000 * Fplus_dU_im_101 + CU_0_im_000 * Fplus_dU_re_101 = CU_101_0_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_0_re_000, CU_0_im_000, Fplus_dU_re_101, Fplus_dU_im_101, CU_101_0_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CU_101_0_mul :
    CU_0_c_000 * Fplus_dU_c_101 = ofLadj CU_101_0_pre CU_101_0_pim := by
  rw [CU_0_c_000, Fplus_dU_c_101, ofLadj_mul, CU_101_0_pre_eq, CU_101_0_pim_eq]

def CU_101_1_pre : Polynomial ℚ := C ((4886626511804 / 235794999 : ℚ)) + C ((65904409431440 / 235794999 : ℚ)) * X + C ((44709986731022 / 78598333 : ℚ)) * X ^ 2 + C ((220366643143480 / 235794999 : ℚ)) * X ^ 3 + C ((328075028950948 / 235794999 : ℚ)) * X ^ 4 + C ((129982094715787 / 78598333 : ℚ)) * X ^ 5 + C ((439621791968759 / 235794999 : ℚ)) * X ^ 6 + C ((155667717390579 / 78598333 : ℚ)) * X ^ 7 + C ((444931898208011 / 235794999 : ℚ)) * X ^ 8 + C ((436521686001167 / 235794999 : ℚ)) * X ^ 9 + C ((430100691240430 / 235794999 : ℚ)) * X ^ 10 + C ((140941720631786 / 78598333 : ℚ)) * X ^ 11 + C ((364196281808990 / 235794999 : ℚ)) * X ^ 12 + C ((302391725808101 / 235794999 : ℚ)) * X ^ 13 + C ((224565255064531 / 235794999 : ℚ)) * X ^ 14 + C ((124586725891891 / 235794999 : ℚ)) * X ^ 15 + C ((67304960166692 / 235794999 : ℚ)) * X ^ 16 + C ((5876484115098 / 78598333 : ℚ)) * X ^ 17 + C ((-14341397328898 / 235794999 : ℚ)) * X ^ 18
def CU_101_1_pim : Polynomial ℚ := C ((-44371593928054 / 235794999 : ℚ)) + C ((-88743187856108 / 235794999 : ℚ)) * X + C ((-105291660343954 / 235794999 : ℚ)) * X ^ 2 + C ((-123953873293186 / 235794999 : ℚ)) * X ^ 3 + C ((-93324316845842 / 235794999 : ℚ)) * X ^ 4 + C ((-10816947857955 / 78598333 : ℚ)) * X ^ 5 + C ((1480142052071 / 21435909 : ℚ)) * X ^ 6 + C ((29272234025103 / 78598333 : ℚ)) * X ^ 7 + C ((42977148516315 / 78598333 : ℚ)) * X ^ 8 + C ((42574100001185 / 78598333 : ℚ)) * X ^ 9 + C ((3701683405782 / 7145303 : ℚ)) * X ^ 10 + C ((158377894222892 / 235794999 : ℚ)) * X ^ 11 + C ((194600236054978 / 235794999 : ℚ)) * X ^ 12 + C ((68527320310025 / 78598333 : ℚ)) * X ^ 13 + C ((74345009444639 / 78598333 : ℚ)) * X ^ 14 + C ((65312096870299 / 78598333 : ℚ)) * X ^ 15 + C ((142211630549992 / 235794999 : ℚ)) * X ^ 16 + C ((3090007607296 / 7145303 : ℚ)) * X ^ 17 + C ((37583924749312 / 235794999 : ℚ)) * X ^ 18
theorem CU_101_1_pre_eq :
    CU_1_re_000 * Fplus_dV_re_101 - CU_1_im_000 * Fplus_dV_im_101 = CU_101_1_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_1_re_000, CU_1_im_000, Fplus_dV_re_101, Fplus_dV_im_101, CU_101_1_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CU_101_1_pim_eq :
    CU_1_re_000 * Fplus_dV_im_101 + CU_1_im_000 * Fplus_dV_re_101 = CU_101_1_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_1_re_000, CU_1_im_000, Fplus_dV_re_101, Fplus_dV_im_101, CU_101_1_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CU_101_1_mul :
    CU_1_c_000 * Fplus_dV_c_101 = ofLadj CU_101_1_pre CU_101_1_pim := by
  rw [CU_1_c_000, Fplus_dV_c_101, ofLadj_mul, CU_101_1_pre_eq, CU_101_1_pim_eq]

def CU_101_2_pre : Polynomial ℚ := C ((9067395258760 / 235794999 : ℚ)) + C ((149300994117184 / 235794999 : ℚ)) * X + C ((298003776606520 / 235794999 : ℚ)) * X ^ 2 + C ((43930838921098 / 21435909 : ℚ)) * X ^ 3 + C ((734670330802294 / 235794999 : ℚ)) * X ^ 4 + C ((296136187082817 / 78598333 : ℚ)) * X ^ 5 + C ((342632781491630 / 78598333 : ℚ)) * X ^ 6 + C ((373783472069232 / 78598333 : ℚ)) * X ^ 7 + C ((367585973073239 / 78598333 : ℚ)) * X ^ 8 + C ((1117529059675147 / 235794999 : ℚ)) * X ^ 9 + C ((102622145972683 / 21435909 : ℚ)) * X ^ 10 + C ((1123997569889980 / 235794999 : ℚ)) * X ^ 11 + C ((979542611582329 / 235794999 : ℚ)) * X ^ 12 + C ((273175094356209 / 78598333 : ℚ)) * X ^ 13 + C ((619518691087639 / 235794999 : ℚ)) * X ^ 14 + C ((118164425243500 / 78598333 : ℚ)) * X ^ 15 + C ((64218080953024 / 78598333 : ℚ)) * X ^ 16 + C ((17721486544211 / 78598333 : ℚ)) * X ^ 17 + C ((-32186809674902 / 235794999 : ℚ)) * X ^ 18
def CU_101_2_pim : Polynomial ℚ := C ((-35656125221556 / 78598333 : ℚ)) + C ((-71312250443112 / 78598333 : ℚ)) * X + C ((-2151943326946 / 1948719 : ℚ)) * X ^ 2 + C ((-108444750856696 / 78598333 : ℚ)) * X ^ 3 + C ((-283162258076164 / 235794999 : ℚ)) * X ^ 4 + C ((-170221517000407 / 235794999 : ℚ)) * X ^ 5 + C ((-83184538388758 / 235794999 : ℚ)) * X ^ 6 + C ((24385141042362 / 78598333 : ℚ)) * X ^ 7 + C ((163806115450513 / 235794999 : ℚ)) * X ^ 8 + C ((165920121207541 / 235794999 : ℚ)) * X ^ 9 + C ((58564505942079 / 78598333 : ℚ)) * X ^ 10 + C ((99005794536964 / 78598333 : ℚ)) * X ^ 11 + C ((139447083131849 / 78598333 : ℚ)) * X ^ 12 + C ((158187679081791 / 78598333 : ℚ)) * X ^ 13 + C ((541626153012023 / 235794999 : ℚ)) * X ^ 14 + C ((164423544810048 / 78598333 : ℚ)) * X ^ 15 + C ((367752183100292 / 235794999 : ℚ)) * X ^ 16 + C ((88583962727107 / 78598333 : ℚ)) * X ^ 17 + C ((96834216411382 / 235794999 : ℚ)) * X ^ 18
theorem CU_101_2_pre_eq :
    CU_2_re_000 * Fplus_dW_re_101 - CU_2_im_000 * Fplus_dW_im_101 = CU_101_2_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_2_re_000, CU_2_im_000, Fplus_dW_re_101, Fplus_dW_im_101, CU_101_2_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CU_101_2_pim_eq :
    CU_2_re_000 * Fplus_dW_im_101 + CU_2_im_000 * Fplus_dW_re_101 = CU_101_2_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_2_re_000, CU_2_im_000, Fplus_dW_re_101, Fplus_dW_im_101, CU_101_2_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CU_101_2_mul :
    CU_2_c_000 * Fplus_dW_c_101 = ofLadj CU_101_2_pre CU_101_2_pim := by
  rw [CU_2_c_000, Fplus_dW_c_101, ofLadj_mul, CU_101_2_pre_eq, CU_101_2_pim_eq]

def CU_101_3_pre : Polynomial ℚ := C ((-47979976494 / 7145303 : ℚ)) + C ((385983145808 / 21435909 : ℚ)) * X ^ 2 + C ((297143476294 / 7145303 : ℚ)) * X ^ 3 + C ((1355941300882 / 21435909 : ℚ)) * X ^ 4 + C ((1632094710814 / 21435909 : ℚ)) * X ^ 5 + C ((1632094710814 / 21435909 : ℚ)) * X ^ 6 + C ((1355941300882 / 21435909 : ℚ)) * X ^ 7 + C ((297143476294 / 7145303 : ℚ)) * X ^ 8 + C ((385983145808 / 21435909 : ℚ)) * X ^ 9
def CU_101_3_pim : Polynomial ℚ := C ((-1796800581658 / 78598333 : ℚ)) + C ((-3593601163316 / 78598333 : ℚ)) * X + C ((-4819683563908 / 78598333 : ℚ)) * X ^ 2 + C ((-15258229868282 / 235794999 : ℚ)) * X ^ 3 + C ((-12925161468338 / 235794999 : ℚ)) * X ^ 4 + C ((-8199550705810 / 235794999 : ℚ)) * X ^ 5 + C ((-2581252784138 / 235794999 : ℚ)) * X ^ 6 + C ((2144357978390 / 235794999 : ℚ)) * X ^ 7 + C ((4477426378334 / 235794999 : ℚ)) * X ^ 8 + C ((1226082400592 / 78598333 : ℚ)) * X ^ 9
theorem CU_101_3_neg_re : -CU_3_re_101 = CU_101_3_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_3_re_101, CU_101_3_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CU_101_3_neg_im : -CU_3_im_101 = CU_101_3_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_3_im_101, CU_101_3_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CU_101_3_mul : -CU_3_c_101 = ofLadj CU_101_3_pre CU_101_3_pim := by
  rw [CU_3_c_101, ofLadj_neg, CU_101_3_neg_re, CU_101_3_neg_im]

def CU_coeff_101 : Ki := CU_0_c_000 * Fplus_dU_c_101 + CU_1_c_000 * Fplus_dV_c_101 + CU_2_c_000 * Fplus_dW_c_101 + (-CU_3_c_101)

theorem CU_coeff_101_sum :
    CU_coeff_101 = ofLadj (CU_101_0_pre + CU_101_1_pre + CU_101_2_pre + CU_101_3_pre) (CU_101_0_pim + CU_101_1_pim + CU_101_2_pim + CU_101_3_pim) := by
  simp only [CU_coeff_101, CU_101_0_mul, CU_101_1_mul, CU_101_2_mul, CU_101_3_mul]
  simpa [add_assoc] using ofLadj_add4 CU_101_0_pre CU_101_0_pim CU_101_1_pre CU_101_1_pim CU_101_2_pre CU_101_2_pim CU_101_3_pre CU_101_3_pim

def CU_101_qre : Polynomial ℚ := C ((1262398321198 / 21435909 : ℚ)) + C ((70577670210066 / 78598333 : ℚ)) * X + C ((76827606343670 / 78598333 : ℚ)) * X ^ 2 + C ((96306898029301 / 78598333 : ℚ)) * X ^ 3 + C ((377318714099807 / 235794999 : ℚ)) * X ^ 4 + C ((224905033288340 / 235794999 : ℚ)) * X ^ 5 + C ((194494636538198 / 235794999 : ℚ)) * X ^ 6 + C ((39936328120698 / 78598333 : ℚ)) * X ^ 7 + C ((-50303033585312 / 235794999 : ℚ)) * X ^ 8
def CU_101_qim : Polynomial ℚ := C ((-14669165076916 / 21435909 : ℚ)) + C ((-14669165076916 / 21435909 : ℚ)) * X + C ((-66526623419164 / 235794999 : ℚ)) * X ^ 2 + C ((-84278707058993 / 235794999 : ℚ)) * X ^ 3 + C ((82213243842115 / 235794999 : ℚ)) * X ^ 4 + C ((62780490957738 / 78598333 : ℚ)) * X ^ 5 + C ((49754456163994 / 78598333 : ℚ)) * X ^ 6 + C ((80993606043740 / 78598333 : ℚ)) * X ^ 7 + C ((139441088960546 / 235794999 : ℚ)) * X ^ 8
theorem CU_coeff_101_poly_re :
    CU_101_0_pre + CU_101_1_pre + CU_101_2_pre + CU_101_3_pre = (0 : Polynomial ℚ) + Phi11 * CU_101_qre := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [CU_101_0_pre, CU_101_1_pre, CU_101_2_pre, CU_101_3_pre, CU_101_qre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try ring
theorem CU_coeff_101_poly_im :
    CU_101_0_pim + CU_101_1_pim + CU_101_2_pim + CU_101_3_pim = (0 : Polynomial ℚ) + Phi11 * CU_101_qim := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [CU_101_0_pim, CU_101_1_pim, CU_101_2_pim, CU_101_3_pim, CU_101_qim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try ring
theorem CU_coeff_101_eq :
    CU_coeff_101 = (0 : Ki) := by
  rw [CU_coeff_101_sum, CU_coeff_101_poly_re,
    CU_coeff_101_poly_im, ofLadj_add_Phi11]
  exact ofLadj_zero

end V14Formalization.D12SigmaPlusSegreCore
