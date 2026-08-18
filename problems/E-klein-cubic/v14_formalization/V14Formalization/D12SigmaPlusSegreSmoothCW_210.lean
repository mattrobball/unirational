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

def CW_210_0_pre : Polynomial ℚ := C ((284869238216 / 8639957931 : ℚ)) + C ((-4633900523752 / 2879985977 : ℚ)) * X + C ((-27409559386400 / 8639957931 : ℚ)) * X ^ 2 + C ((-14996011587317 / 2879985977 : ℚ)) * X ^ 3 + C ((-76391819445571 / 8639957931 : ℚ)) * X ^ 4 + C ((-8859926695244 / 785450721 : ℚ)) * X ^ 5 + C ((-117977068540765 / 8639957931 : ℚ)) * X ^ 6 + C ((-42176911856642 / 2879985977 : ℚ)) * X ^ 7 + C ((-117646388372506 / 8639957931 : ℚ)) * X ^ 8 + C ((-3378928057918 / 261816907 : ℚ)) * X ^ 9 + C ((-106466579659750 / 8639957931 : ℚ)) * X ^ 10 + C ((-35044561633690 / 2879985977 : ℚ)) * X ^ 11 + C ((-92564878088494 / 8639957931 : ℚ)) * X ^ 12 + C ((-84095066524894 / 8639957931 : ℚ)) * X ^ 13 + C ((-72658353610555 / 8639957931 : ℚ)) * X ^ 14 + C ((-4281937835905 / 785450721 : ℚ)) * X ^ 15 + C ((-29365413142403 / 8639957931 : ℚ)) * X ^ 16 + C ((-8847538249322 / 8639957931 : ℚ)) * X ^ 17 + C ((1012533309800 / 2879985977 : ℚ)) * X ^ 18
def CW_210_0_pim : Polynomial ℚ := C ((13238358769429 / 8639957931 : ℚ)) + C ((26476717538858 / 8639957931 : ℚ)) * X + C ((11334670048363 / 2879985977 : ℚ)) * X ^ 2 + C ((47101994888624 / 8639957931 : ℚ)) * X ^ 3 + C ((47063307940420 / 8639957931 : ℚ)) * X ^ 4 + C ((3162268636037 / 785450721 : ℚ)) * X ^ 5 + C ((21084420715349 / 8639957931 : ℚ)) * X ^ 6 + C ((-1909710388885 / 2879985977 : ℚ)) * X ^ 7 + C ((-19721027936135 / 8639957931 : ℚ)) * X ^ 8 + C ((-6332948533927 / 2879985977 : ℚ)) * X ^ 9 + C ((-14755878682294 / 8639957931 : ℚ)) * X ^ 10 + C ((-7297494924098 / 2879985977 : ℚ)) * X ^ 11 + C ((-29029090862294 / 8639957931 : ℚ)) * X ^ 12 + C ((-32313416549038 / 8639957931 : ℚ)) * X ^ 13 + C ((-4062656268929 / 785450721 : ℚ)) * X ^ 14 + C ((-47156640732545 / 8639957931 : ℚ)) * X ^ 15 + C ((-1224140045219 / 261816907 : ℚ)) * X ^ 16 + C ((-32781006225259 / 8639957931 : ℚ)) * X ^ 17 + C ((-3828596015650 / 2879985977 : ℚ)) * X ^ 18
theorem CW_210_0_pre_eq :
    CW_0_re_100 * Fplus_dU_re_110 - CW_0_im_100 * Fplus_dU_im_110 = CW_210_0_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_0_re_100_def, CW_0_im_100_def, Fplus_dU_re_110_def, Fplus_dU_im_110_def, CW_210_0_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CW_210_0_pim_eq :
    CW_0_re_100 * Fplus_dU_im_110 + CW_0_im_100 * Fplus_dU_re_110 = CW_210_0_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_0_re_100_def, CW_0_im_100_def, Fplus_dU_re_110_def, Fplus_dU_im_110_def, CW_210_0_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CW_210_0_mul :
    CW_0_c_100 * Fplus_dU_c_110 = ofLadj CW_210_0_pre CW_210_0_pim := by
  rw [CW_0_c_100_def, Fplus_dU_c_110_def, ofLadj_mul, CW_210_0_pre_eq, CW_210_0_pim_eq]

def CW_210_1_pre : Polynomial ℚ := C ((-575879861214 / 2879985977 : ℚ)) + C ((22917634690 / 261816907 : ℚ)) * X ^ 2 + C ((1132586503049 / 2879985977 : ℚ)) * X ^ 3 + C ((663850627499 / 523633814 : ℚ)) * X ^ 4 + C ((6112905873200 / 2879985977 : ℚ)) * X ^ 5 + C ((8829906564631 / 2879985977 : ℚ)) * X ^ 6 + C ((1983441664855 / 523633814 : ℚ)) * X ^ 7 + C ((11670748876825 / 2879985977 : ℚ)) * X ^ 8 + C ((12014000504760 / 2879985977 : ℚ)) * X ^ 9 + C ((24607230593721 / 5759971954 : ℚ)) * X ^ 10 + C ((12947748344617 / 2879985977 : ℚ)) * X ^ 11 + C ((24607230593721 / 5759971954 : ℚ)) * X ^ 12 + C ((11761906523170 / 2879985977 : ℚ)) * X ^ 13 + C ((10538162373776 / 2879985977 : ℚ)) * X ^ 14 + C ((7693603938695 / 2879985977 : ℚ)) * X ^ 15 + C ((10149772768099 / 5759971954 : ℚ)) * X ^ 16 + C ((428706489567 / 523633814 : ℚ)) * X ^ 17 + C ((435853233237 / 2879985977 : ℚ)) * X ^ 18
def CW_210_1_pim : Polynomial ℚ := C ((-1673962208256 / 2879985977 : ℚ)) + C ((-3347924416512 / 2879985977 : ℚ)) * X + C ((-5352382152203 / 2879985977 : ℚ)) * X ^ 2 + C ((-8264897055806 / 2879985977 : ℚ)) * X ^ 3 + C ((-19755804259637 / 5759971954 : ℚ)) * X ^ 4 + C ((-983017958114 / 261816907 : ℚ)) * X ^ 5 + C ((-11000168188634 / 2879985977 : ℚ)) * X ^ 6 + C ((-9403047378147 / 2879985977 : ℚ)) * X ^ 7 + C ((-8405807985804 / 2879985977 : ℚ)) * X ^ 8 + C ((-16774545659603 / 5759971954 : ℚ)) * X ^ 9 + C ((-16321236998639 / 5759971954 : ℚ)) * X ^ 10 + C ((-557987402752 / 261816907 : ℚ)) * X ^ 11 + C ((-8230208722449 / 5759971954 : ℚ)) * X ^ 12 + C ((-3767984590103 / 5759971954 : ℚ)) * X ^ 13 + C ((1047057764554 / 2879985977 : ℚ)) * X ^ 14 + C ((5078013088707 / 5759971954 : ℚ)) * X ^ 15 + C ((6327682403967 / 5759971954 : ℚ)) * X ^ 16 + C ((6051754497697 / 5759971954 : ℚ)) * X ^ 17 + C ((1118295686556 / 2879985977 : ℚ)) * X ^ 18
theorem CW_210_1_pre_eq :
    CW_0_re_010 * Fplus_dU_re_200 - CW_0_im_010 * Fplus_dU_im_200 = CW_210_1_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_0_re_010_def, CW_0_im_010_def, Fplus_dU_re_200_def, Fplus_dU_im_200_def, CW_210_1_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CW_210_1_pim_eq :
    CW_0_re_010 * Fplus_dU_im_200 + CW_0_im_010 * Fplus_dU_re_200 = CW_210_1_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_0_re_010_def, CW_0_im_010_def, Fplus_dU_re_200_def, Fplus_dU_im_200_def, CW_210_1_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CW_210_1_mul :
    CW_0_c_010 * Fplus_dU_c_200 = ofLadj CW_210_1_pre CW_210_1_pim := by
  rw [CW_0_c_010_def, Fplus_dU_c_200_def, ofLadj_mul, CW_210_1_pre_eq, CW_210_1_pim_eq]

def CW_210_2_pre : Polynomial ℚ := C ((367434778133 / 8639957931 : ℚ)) + C ((-21554240437480 / 8639957931 : ℚ)) * X + C ((-40307118527084 / 8639957931 : ℚ)) * X ^ 2 + C ((-23218963115504 / 2879985977 : ℚ)) * X ^ 3 + C ((-38002686630979 / 2879985977 : ℚ)) * X ^ 4 + C ((-4445184694172 / 261816907 : ℚ)) * X ^ 5 + C ((-179307187687565 / 8639957931 : ℚ)) * X ^ 6 + C ((-68348026493779 / 2879985977 : ℚ)) * X ^ 7 + C ((-69532314989391 / 2879985977 : ℚ)) * X ^ 8 + C ((-215692315296988 / 8639957931 : ℚ)) * X ^ 9 + C ((-221559159893189 / 8639957931 : ℚ)) * X ^ 10 + C ((-223819413340945 / 8639957931 : ℚ)) * X ^ 11 + C ((-200004919455709 / 8639957931 : ℚ)) * X ^ 12 + C ((-15944108797264 / 785450721 : ℚ)) * X ^ 13 + C ((-46313351873887 / 2879985977 : ℚ)) * X ^ 14 + C ((-29270036012609 / 2879985977 : ℚ)) * X ^ 15 + C ((-51247620798235 / 8639957931 : ℚ)) * X ^ 16 + C ((-18631528018346 / 8639957931 : ℚ)) * X ^ 17 + C ((1075303850191 / 2879985977 : ℚ)) * X ^ 18
def CW_210_2_pim : Polynomial ℚ := C ((20014044044653 / 8639957931 : ℚ)) + C ((40028088089306 / 8639957931 : ℚ)) * X + C ((53516522063713 / 8639957931 : ℚ)) * X ^ 2 + C ((2298944284852 / 261816907 : ℚ)) * X ^ 3 + C ((2389847569595 / 261816907 : ℚ)) * X ^ 4 + C ((70567680584480 / 8639957931 : ℚ)) * X ^ 5 + C ((20664708959926 / 2879985977 : ℚ)) * X ^ 6 + C ((37259047339147 / 8639957931 : ℚ)) * X ^ 7 + C ((592321133627 / 261816907 : ℚ)) * X ^ 8 + C ((18722192565424 / 8639957931 : ℚ)) * X ^ 9 + C ((4599989966079 / 2879985977 : ℚ)) * X ^ 10 + C ((-13296470544179 / 8639957931 : ℚ)) * X ^ 11 + C ((-40392910986595 / 8639957931 : ℚ)) * X ^ 12 + C ((-58803567628189 / 8639957931 : ℚ)) * X ^ 13 + C ((-81976611808859 / 8639957931 : ℚ)) * X ^ 14 + C ((-82076858435045 / 8639957931 : ℚ)) * X ^ 15 + C ((-67378059513370 / 8639957931 : ℚ)) * X ^ 16 + C ((-17249533649980 / 2879985977 : ℚ)) * X ^ 17 + C ((-20612011699789 / 8639957931 : ℚ)) * X ^ 18
theorem CW_210_2_pre_eq :
    CW_1_re_100 * Fplus_dV_re_110 - CW_1_im_100 * Fplus_dV_im_110 = CW_210_2_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_1_re_100_def, CW_1_im_100_def, Fplus_dV_re_110_def, Fplus_dV_im_110_def, CW_210_2_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CW_210_2_pim_eq :
    CW_1_re_100 * Fplus_dV_im_110 + CW_1_im_100 * Fplus_dV_re_110 = CW_210_2_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_1_re_100_def, CW_1_im_100_def, Fplus_dV_re_110_def, Fplus_dV_im_110_def, CW_210_2_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CW_210_2_mul :
    CW_1_c_100 * Fplus_dV_c_110 = ofLadj CW_210_2_pre CW_210_2_pim := by
  rw [CW_1_c_100_def, Fplus_dV_c_110_def, ofLadj_mul, CW_210_2_pre_eq, CW_210_2_pim_eq]

def CW_210_3_pre : Polynomial ℚ := C ((-134851079641 / 8639957931 : ℚ)) + C ((2482558759220 / 8639957931 : ℚ)) * X + C ((9722991340387 / 17279915862 : ℚ)) * X ^ 2 + C ((7836394676533 / 8639957931 : ℚ)) * X ^ 3 + C ((27129530484539 / 17279915862 : ℚ)) * X ^ 4 + C ((17364974083483 / 8639957931 : ℚ)) * X ^ 5 + C ((344969401975 / 142809222 : ℚ)) * X ^ 6 + C ((22394247424168 / 8639957931 : ℚ)) * X ^ 7 + C ((6955355548382 / 2879985977 : ℚ)) * X ^ 8 + C ((1798643993560 / 785450721 : ℚ)) * X ^ 9 + C ((12561382114291 / 5759971954 : ℚ)) * X ^ 10 + C ((6227982356336 / 2879985977 : ℚ)) * X ^ 11 + C ((32719028824433 / 17279915862 : ℚ)) * X ^ 12 + C ((9949058839311 / 5759971954 : ℚ)) * X ^ 13 + C ((13029671968613 / 8639957931 : ℚ)) * X ^ 14 + C ((2776480112201 / 2879985977 : ℚ)) * X ^ 15 + C ((5095895997149 / 8639957931 : ℚ)) * X ^ 16 + C ((3180442522289 / 17279915862 : ℚ)) * X ^ 17 + C ((-333361230197 / 5759971954 : ℚ)) * X ^ 18
def CW_210_3_pim : Polynomial ℚ := C ((-4776186839747 / 17279915862 : ℚ)) + C ((-4776186839747 / 8639957931 : ℚ)) * X + C ((-6002102203957 / 8639957931 : ℚ)) * X ^ 2 + C ((-8433853511482 / 8639957931 : ℚ)) * X ^ 3 + C ((-17089490922359 / 17279915862 : ℚ)) * X ^ 4 + C ((-6205486278413 / 8639957931 : ℚ)) * X ^ 5 + C ((-3775462402417 / 8639957931 : ℚ)) * X ^ 6 + C ((1778726381023 / 17279915862 : ℚ)) * X ^ 7 + C ((1122395533414 / 2879985977 : ℚ)) * X ^ 8 + C ((27155592589 / 71404611 : ℚ)) * X ^ 9 + C ((848576617036 / 2879985977 : ℚ)) * X ^ 10 + C ((3812838078629 / 8639957931 : ℚ)) * X ^ 11 + C ((5079946306150 / 8639957931 : ℚ)) * X ^ 12 + C ((5565764818199 / 8639957931 : ℚ)) * X ^ 13 + C ((2638718742917 / 2879985977 : ℚ)) * X ^ 14 + C ((1538029945255 / 1570901442 : ℚ)) * X ^ 15 + C ((4732244353327 / 5759971954 : ℚ)) * X ^ 16 + C ((11464142936701 / 17279915862 : ℚ)) * X ^ 17 + C ((1363804592851 / 5759971954 : ℚ)) * X ^ 18
theorem CW_210_3_pre_eq :
    CW_1_re_010 * Fplus_dV_re_200 - CW_1_im_010 * Fplus_dV_im_200 = CW_210_3_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_1_re_010_def, CW_1_im_010_def, Fplus_dV_re_200_def, Fplus_dV_im_200_def, CW_210_3_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CW_210_3_pim_eq :
    CW_1_re_010 * Fplus_dV_im_200 + CW_1_im_010 * Fplus_dV_re_200 = CW_210_3_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_1_re_010_def, CW_1_im_010_def, Fplus_dV_re_200_def, Fplus_dV_im_200_def, CW_210_3_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CW_210_3_mul :
    CW_1_c_010 * Fplus_dV_c_200 = ofLadj CW_210_3_pre CW_210_3_pim := by
  rw [CW_1_c_010_def, Fplus_dV_c_200_def, ofLadj_mul, CW_210_3_pre_eq, CW_210_3_pim_eq]

def CW_210_4_pre : Polynomial ℚ := C ((31679721113 / 8639957931 : ℚ)) + C ((-905394825860 / 785450721 : ℚ)) * X + C ((-6476998004739 / 2879985977 : ℚ)) * X ^ 2 + C ((-32469075919459 / 8639957931 : ℚ)) * X ^ 3 + C ((-48816964237319 / 8639957931 : ℚ)) * X ^ 4 + C ((-18952133383796 / 2879985977 : ℚ)) * X ^ 5 + C ((-65322345886084 / 8639957931 : ℚ)) * X ^ 6 + C ((-68815654391164 / 8639957931 : ℚ)) * X ^ 7 + C ((-65539513155437 / 8639957931 : ℚ)) * X ^ 8 + C ((-21423710803138 / 2879985977 : ℚ)) * X ^ 9 + C ((-63319494838181 / 8639957931 : ℚ)) * X ^ 10 + C ((-62932476647509 / 8639957931 : ℚ)) * X ^ 11 + C ((-53360151753721 / 8639957931 : ℚ)) * X ^ 12 + C ((-14946712798399 / 2879985977 : ℚ)) * X ^ 13 + C ((-33070437235978 / 8639957931 : ℚ)) * X ^ 14 + C ((-17838130343399 / 8639957931 : ℚ)) * X ^ 15 + C ((-10501027602764 / 8639957931 : ℚ)) * X ^ 16 + C ((-2035081868068 / 8639957931 : ℚ)) * X ^ 17 + C ((720186603482 / 2879985977 : ℚ)) * X ^ 18
def CW_210_4_pim : Polynomial ℚ := C ((7026237305771 / 8639957931 : ℚ)) + C ((14052474611542 / 8639957931 : ℚ)) * X + C ((15866647751071 / 8639957931 : ℚ)) * X ^ 2 + C ((19980913446367 / 8639957931 : ℚ)) * X ^ 3 + C ((14237990649247 / 8639957931 : ℚ)) * X ^ 4 + C ((6017026285141 / 8639957931 : ℚ)) * X ^ 5 + C ((-853350529399 / 8639957931 : ℚ)) * X ^ 6 + C ((-11891027874410 / 8639957931 : ℚ)) * X ^ 7 + C ((-17619389442703 / 8639957931 : ℚ)) * X ^ 8 + C ((-17427703691600 / 8639957931 : ℚ)) * X ^ 9 + C ((-16612745037458 / 8639957931 : ℚ)) * X ^ 10 + C ((-22405990293073 / 8639957931 : ℚ)) * X ^ 11 + C ((-9399745182896 / 2879985977 : ℚ)) * X ^ 12 + C ((-9732816678025 / 2879985977 : ℚ)) * X ^ 13 + C ((-33121029978268 / 8639957931 : ℚ)) * X ^ 14 + C ((-9316963344057 / 2879985977 : ℚ)) * X ^ 15 + C ((-20753271652274 / 8639957931 : ℚ)) * X ^ 16 + C ((-15169910078072 / 8639957931 : ℚ)) * X ^ 17 + C ((-1718526239090 / 2879985977 : ℚ)) * X ^ 18
theorem CW_210_4_pre_eq :
    CW_2_re_100 * Fplus_dW_re_110 - CW_2_im_100 * Fplus_dW_im_110 = CW_210_4_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_2_re_100_def, CW_2_im_100_def, Fplus_dW_re_110_def, Fplus_dW_im_110_def, CW_210_4_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CW_210_4_pim_eq :
    CW_2_re_100 * Fplus_dW_im_110 + CW_2_im_100 * Fplus_dW_re_110 = CW_210_4_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_2_re_100_def, CW_2_im_100_def, Fplus_dW_re_110_def, Fplus_dW_im_110_def, CW_210_4_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CW_210_4_mul :
    CW_2_c_100 * Fplus_dW_c_110 = ofLadj CW_210_4_pre CW_210_4_pim := by
  rw [CW_2_c_100_def, Fplus_dW_c_110_def, ofLadj_mul, CW_210_4_pre_eq, CW_210_4_pim_eq]

def CW_210_5_pre : Polynomial ℚ := C ((801666263108 / 8639957931 : ℚ)) + C ((860330813120 / 8639957931 : ℚ)) * X + C ((2370390820990 / 8639957931 : ℚ)) * X ^ 2 + C ((2702104014392 / 8639957931 : ℚ)) * X ^ 3 + C ((3109239245231 / 8639957931 : ℚ)) * X ^ 4 + C ((11345082415643 / 17279915862 : ℚ)) * X ^ 5 + C ((342704007709 / 785450721 : ℚ)) * X ^ 6 + C ((5441244595319 / 8639957931 : ℚ)) * X ^ 7 + C ((5272105301590 / 8639957931 : ℚ)) * X ^ 8 + C ((5092934255611 / 8639957931 : ℚ)) * X ^ 9 + C ((5175478778057 / 8639957931 : ℚ)) * X ^ 10 + C ((1440914514289 / 2879985977 : ℚ)) * X ^ 11 + C ((1438382654979 / 2879985977 : ℚ)) * X ^ 12 + C ((907514478207 / 2879985977 : ℚ)) * X ^ 13 + C ((2570001287198 / 8639957931 : ℚ)) * X ^ 14 + C ((723757856819 / 2879985977 : ℚ)) * X ^ 15 + C ((-396610212187 / 8639957931 : ℚ)) * X ^ 16 + C ((3012373821671 / 17279915862 : ℚ)) * X ^ 17 + C ((-53577259877 / 2879985977 : ℚ)) * X ^ 18
def CW_210_5_pim : Polynomial ℚ := C ((22810550544 / 2879985977 : ℚ)) + C ((45621101088 / 2879985977 : ℚ)) * X + C ((-405076023092 / 8639957931 : ℚ)) * X ^ 2 + C ((515639611127 / 2879985977 : ℚ)) * X ^ 3 + C ((-59913437051 / 8639957931 : ℚ)) * X ^ 4 + C ((2064526346870 / 8639957931 : ℚ)) * X ^ 5 + C ((2021458817129 / 5759971954 : ℚ)) * X ^ 6 + C ((5142413704435 / 17279915862 : ℚ)) * X ^ 7 + C ((245263976355 / 523633814 : ℚ)) * X ^ 8 + C ((3975023737123 / 8639957931 : ℚ)) * X ^ 9 + C ((3987840142282 / 8639957931 : ℚ)) * X ^ 10 + C ((116867473608 / 261816907 : ℚ)) * X ^ 11 + C ((3725413115846 / 8639957931 : ℚ)) * X ^ 12 + C ((389106258851 / 785450721 : ℚ)) * X ^ 13 + C ((1504228078769 / 5759971954 : ℚ)) * X ^ 14 + C ((2638273392295 / 5759971954 : ℚ)) * X ^ 15 + C ((3579780408599 / 17279915862 : ℚ)) * X ^ 16 + C ((321170594843 / 2879985977 : ℚ)) * X ^ 17 + C ((41861001751 / 261816907 : ℚ)) * X ^ 18
theorem CW_210_5_pre_eq :
    CW_2_re_010 * Fplus_dW_re_200 - CW_2_im_010 * Fplus_dW_im_200 = CW_210_5_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_2_re_010_def, CW_2_im_010_def, Fplus_dW_re_200_def, Fplus_dW_im_200_def, CW_210_5_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CW_210_5_pim_eq :
    CW_2_re_010 * Fplus_dW_im_200 + CW_2_im_010 * Fplus_dW_re_200 = CW_210_5_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_2_re_010_def, CW_2_im_010_def, Fplus_dW_re_200_def, Fplus_dW_im_200_def, CW_210_5_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CW_210_5_mul :
    CW_2_c_010 * Fplus_dW_c_200 = ofLadj CW_210_5_pre CW_210_5_pim := by
  rw [CW_2_c_010_def, Fplus_dW_c_200_def, ofLadj_mul, CW_210_5_pre_eq, CW_210_5_pim_eq]

def CW_210_6_pre : Polynomial ℚ := C ((-396058594 / 785450721 : ℚ)) + C ((11928851600 / 785450721 : ℚ)) * X ^ 2 + C ((19599215260 / 785450721 : ℚ)) * X ^ 3 + C ((30954185144 / 785450721 : ℚ)) * X ^ 4 + C ((12234419730 / 261816907 : ℚ)) * X ^ 5 + C ((12234419730 / 261816907 : ℚ)) * X ^ 6 + C ((30954185144 / 785450721 : ℚ)) * X ^ 7 + C ((19599215260 / 785450721 : ℚ)) * X ^ 8 + C ((11928851600 / 785450721 : ℚ)) * X ^ 9
def CW_210_6_pim : Polynomial ℚ := C ((-114965860258 / 8639957931 : ℚ)) + C ((-229931720516 / 8639957931 : ℚ)) * X + C ((-318317171402 / 8639957931 : ℚ)) * X ^ 2 + C ((-103398036964 / 2879985977 : ℚ)) * X ^ 3 + C ((-294047645344 / 8639957931 : ℚ)) * X ^ 4 + C ((-157876325176 / 8639957931 : ℚ)) * X ^ 5 + C ((-72055395340 / 8639957931 : ℚ)) * X ^ 6 + C ((64115924828 / 8639957931 : ℚ)) * X ^ 7 + C ((80262390376 / 8639957931 : ℚ)) * X ^ 8 + C ((29461816962 / 2879985977 : ℚ)) * X ^ 9
theorem CW_210_6_neg_re : -CW_3_re_210 = CW_210_6_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_3_re_210_def, CW_210_6_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CW_210_6_neg_im : -CW_3_im_210 = CW_210_6_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_3_im_210_def, CW_210_6_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CW_210_6_mul : -CW_3_c_210 = ofLadj CW_210_6_pre CW_210_6_pim := by
  rw [CW_3_c_210_def, ofLadj_neg, CW_210_6_neg_re, CW_210_6_neg_im]

@[expose] public def CW_coeff_210 : Ki := CW_0_c_100 * Fplus_dU_c_110 + CW_0_c_010 * Fplus_dU_c_200 + CW_1_c_100 * Fplus_dV_c_110 + CW_1_c_010 * Fplus_dV_c_200 + CW_2_c_100 * Fplus_dW_c_110 + CW_2_c_010 * Fplus_dW_c_200 + (-CW_3_c_210)

theorem CW_coeff_210_sum :
    CW_coeff_210 = ofLadj (CW_210_0_pre + CW_210_1_pre + CW_210_2_pre + CW_210_3_pre + CW_210_4_pre + CW_210_5_pre + CW_210_6_pre) (CW_210_0_pim + CW_210_1_pim + CW_210_2_pim + CW_210_3_pim + CW_210_4_pim + CW_210_5_pim + CW_210_6_pim) := by
  simp only [CW_coeff_210, CW_210_0_mul, CW_210_1_mul, CW_210_2_mul, CW_210_3_mul, CW_210_4_mul, CW_210_5_mul, CW_210_6_mul]
  simp [ofLadj_add, add_assoc]

def CW_210_qre : Polynomial ℚ := C ((-381197307247 / 8639957931 : ℚ)) + C ((-13897066071203 / 2879985977 : ℚ)) * X + C ((-73911781206583 / 17279915862 : ℚ)) * X ^ 2 + C ((-107867728671685 / 17279915862 : ℚ)) * X ^ 3 + C ((-26095552412673 / 2879985977 : ℚ)) * X ^ 4 + C ((-31985274831163 / 5759971954 : ℚ)) * X ^ 5 + C ((-51846033720391 / 8639957931 : ℚ)) * X ^ 6 + C ((-861058795488 / 261816907 : ℚ)) * X ^ 7 + C ((6047238243469 / 5759971954 : ℚ)) * X ^ 8
def CW_210_qim : Polynomial ℚ := C ((65644251733171 / 17279915862 : ℚ)) + C ((65644251733171 / 17279915862 : ℚ)) * X + C ((14960286371642 / 8639957931 : ℚ)) * X ^ 2 + C ((30351711673883 / 8639957931 : ℚ)) * X ^ 3 + C ((-9322394325424 / 8639957931 : ℚ)) * X ^ 4 + C ((-27002622461725 / 8639957931 : ℚ)) * X ^ 5 + C ((-52443740127569 / 17279915862 : ℚ)) * X ^ 6 + C ((-35636620531043 / 5759971954 : ℚ)) * X ^ 7 + C ((-60942742914563 / 17279915862 : ℚ)) * X ^ 8
theorem CW_coeff_210_poly_re :
    CW_210_0_pre + CW_210_1_pre + CW_210_2_pre + CW_210_3_pre + CW_210_4_pre + CW_210_5_pre + CW_210_6_pre = (0 : Polynomial ℚ) + Phi11 * CW_210_qre := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [CW_210_0_pre, CW_210_1_pre, CW_210_2_pre, CW_210_3_pre, CW_210_4_pre, CW_210_5_pre, CW_210_6_pre, CW_210_qre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try grind
theorem CW_coeff_210_poly_im :
    CW_210_0_pim + CW_210_1_pim + CW_210_2_pim + CW_210_3_pim + CW_210_4_pim + CW_210_5_pim + CW_210_6_pim = (0 : Polynomial ℚ) + Phi11 * CW_210_qim := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [CW_210_0_pim, CW_210_1_pim, CW_210_2_pim, CW_210_3_pim, CW_210_4_pim, CW_210_5_pim, CW_210_6_pim, CW_210_qim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try grind
public theorem CW_coeff_210_eq :
    CW_coeff_210 = (0 : Ki) := by
  rw [CW_coeff_210_sum, CW_coeff_210_poly_re,
    CW_coeff_210_poly_im, ofLadj_add_Phi11]
  exact ofLadj_zero

end V14Formalization.D12SigmaPlusSegreCore
