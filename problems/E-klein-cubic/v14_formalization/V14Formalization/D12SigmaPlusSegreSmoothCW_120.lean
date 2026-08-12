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

def CW_120_0_pre : Polynomial ℚ := C ((443580621895 / 17279915862 : ℚ)) + C ((-5792375654690 / 2879985977 : ℚ)) * X + C ((-10796459588203 / 2879985977 : ℚ)) * X ^ 2 + C ((-37523466423011 / 5759971954 : ℚ)) * X ^ 3 + C ((-184247010394417 / 17279915862 : ℚ)) * X ^ 4 + C ((-79002243137233 / 5759971954 : ℚ)) * X ^ 5 + C ((-290018347862945 / 17279915862 : ℚ)) * X ^ 6 + C ((-165646280614907 / 8639957931 : ℚ)) * X ^ 7 + C ((-112336979035541 / 5759971954 : ℚ)) * X ^ 8 + C ((-116160583848579 / 5759971954 : ℚ)) * X ^ 9 + C ((-178913140955842 / 8639957931 : ℚ)) * X ^ 10 + C ((-180560865954635 / 8639957931 : ℚ)) * X ^ 11 + C ((-161536013991772 / 8639957931 : ℚ)) * X ^ 12 + C ((-8597060424743 / 523633814 : ℚ)) * X ^ 13 + C ((-37406756306265 / 2879985977 : ℚ)) * X ^ 14 + C ((-141603147845597 / 17279915862 : ℚ)) * X ^ 15 + C ((-13746745803895 / 2879985977 : ℚ)) * X ^ 16 + C ((-14734428186062 / 8639957931 : ℚ)) * X ^ 17 + C ((2721201494900 / 8639957931 : ℚ)) * X ^ 18
def CW_120_0_pim : Polynomial ℚ := C ((32227040575369 / 17279915862 : ℚ)) + C ((32227040575369 / 8639957931 : ℚ)) * X + C ((43247021598259 / 8639957931 : ℚ)) * X ^ 2 + C ((40904905447389 / 5759971954 : ℚ)) * X ^ 3 + C ((42436037319229 / 5759971954 : ℚ)) * X ^ 4 + C ((114146961555373 / 17279915862 : ℚ)) * X ^ 5 + C ((99949602986129 / 17279915862 : ℚ)) * X ^ 6 + C ((29881174169350 / 8639957931 : ℚ)) * X ^ 7 + C ((31316048586623 / 17279915862 : ℚ)) * X ^ 8 + C ((9948874684329 / 5759971954 : ℚ)) * X ^ 9 + C ((10918801136471 / 8639957931 : ℚ)) * X ^ 10 + C ((-3619111783167 / 2879985977 : ℚ)) * X ^ 11 + C ((-32633471835473 / 8639957931 : ℚ)) * X ^ 12 + C ((-31771975832257 / 5759971954 : ℚ)) * X ^ 13 + C ((-22167670862676 / 2879985977 : ℚ)) * X ^ 14 + C ((-133075487364353 / 17279915862 : ℚ)) * X ^ 15 + C ((-4973250891991 / 785450721 : ℚ)) * X ^ 16 + C ((-13943384194161 / 2879985977 : ℚ)) * X ^ 17 + C ((-16485116589650 / 8639957931 : ℚ)) * X ^ 18
theorem CW_120_0_pre_eq :
    CW_0_re_100 * Fplus_dU_re_020 - CW_0_im_100 * Fplus_dU_im_020 = CW_120_0_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_0_re_100, CW_0_im_100, Fplus_dU_re_020, Fplus_dU_im_020, CW_120_0_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CW_120_0_pim_eq :
    CW_0_re_100 * Fplus_dU_im_020 + CW_0_im_100 * Fplus_dU_re_020 = CW_120_0_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_0_re_100, CW_0_im_100, Fplus_dU_re_020, Fplus_dU_im_020, CW_120_0_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CW_120_0_mul :
    CW_0_c_100 * Fplus_dU_c_020 = ofLadj CW_120_0_pre CW_120_0_pim := by
  rw [CW_0_c_100, Fplus_dU_c_020, ofLadj_mul, CW_120_0_pre_eq, CW_120_0_pim_eq]

def CW_120_1_pre : Polynomial ℚ := C ((-455489741324 / 8639957931 : ℚ)) + C ((8927798444032 / 8639957931 : ℚ)) * X + C ((17020584872996 / 8639957931 : ℚ)) * X ^ 2 + C ((2577481821484 / 785450721 : ℚ)) * X ^ 3 + C ((48445408179403 / 8639957931 : ℚ)) * X ^ 4 + C ((20394420057875 / 2879985977 : ℚ)) * X ^ 5 + C ((74837228637010 / 8639957931 : ℚ)) * X ^ 6 + C ((79982291196644 / 8639957931 : ℚ)) * X ^ 7 + C ((612457241456 / 71404611 : ℚ)) * X ^ 8 + C ((23492240339751 / 2879985977 : ℚ)) * X ^ 9 + C ((67098292502675 / 8639957931 : ℚ)) * X ^ 10 + C ((22294304332908 / 2879985977 : ℚ)) * X ^ 11 + C ((58170494058643 / 8639957931 : ℚ)) * X ^ 12 + C ((53456136146257 / 8639957931 : ℚ)) * X ^ 13 + C ((1386515944844 / 261816907 : ℚ)) * X ^ 14 + C ((29603114065177 / 8639957931 : ℚ)) * X ^ 15 + C ((18976451031367 / 8639957931 : ℚ)) * X ^ 16 + C ((1774160855994 / 2879985977 : ℚ)) * X ^ 17 + C ((-644589650688 / 2879985977 : ℚ)) * X ^ 18
def CW_120_1_pim : Polynomial ℚ := C ((-8579663453480 / 8639957931 : ℚ)) + C ((-17159326906960 / 8639957931 : ℚ)) * X + C ((-21653796947842 / 8639957931 : ℚ)) * X ^ 2 + C ((-10185765719702 / 2879985977 : ℚ)) * X ^ 3 + C ((-30017825345311 / 8639957931 : ℚ)) * X ^ 4 + C ((-685888064435 / 261816907 : ℚ)) * X ^ 5 + C ((-14220888964408 / 8639957931 : ℚ)) * X ^ 6 + C ((3317876054294 / 8639957931 : ℚ)) * X ^ 7 + C ((11544180352906 / 8639957931 : ℚ)) * X ^ 8 + C ((11188387218959 / 8639957931 : ℚ)) * X ^ 9 + C ((8336760478825 / 8639957931 : ℚ)) * X ^ 10 + C ((4397250139352 / 2879985977 : ℚ)) * X ^ 11 + C ((18046740357287 / 8639957931 : ℚ)) * X ^ 12 + C ((19689583658035 / 8639957931 : ℚ)) * X ^ 13 + C ((28237290735352 / 8639957931 : ℚ)) * X ^ 14 + C ((28987232285047 / 8639957931 : ℚ)) * X ^ 15 + C ((8479804264469 / 2879985977 : ℚ)) * X ^ 16 + C ((6879985408836 / 2879985977 : ℚ)) * X ^ 17 + C ((2312296978374 / 2879985977 : ℚ)) * X ^ 18
theorem CW_120_1_pre_eq :
    CW_0_re_010 * Fplus_dU_re_110 - CW_0_im_010 * Fplus_dU_im_110 = CW_120_1_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_0_re_010, CW_0_im_010, Fplus_dU_re_110, Fplus_dU_im_110, CW_120_1_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CW_120_1_pim_eq :
    CW_0_re_010 * Fplus_dU_im_110 + CW_0_im_010 * Fplus_dU_re_110 = CW_120_1_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_0_re_010, CW_0_im_010, Fplus_dU_re_110, Fplus_dU_im_110, CW_120_1_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CW_120_1_mul :
    CW_0_c_010 * Fplus_dU_c_110 = ofLadj CW_120_1_pre CW_120_1_pim := by
  rw [CW_0_c_010, Fplus_dU_c_110, ofLadj_mul, CW_120_1_pre_eq, CW_120_1_pim_eq]

def CW_120_2_pre : Polynomial ℚ := C ((400536152756 / 2879985977 : ℚ)) + C ((4310848087496 / 2879985977 : ℚ)) * X + C ((14890960333829 / 5759971954 : ℚ)) * X ^ 2 + C ((1094064219869 / 261816907 : ℚ)) * X ^ 3 + C ((18247229485482 / 2879985977 : ℚ)) * X ^ 4 + C ((20630306162179 / 2879985977 : ℚ)) * X ^ 5 + C ((23757753298031 / 2879985977 : ℚ)) * X ^ 6 + C ((54496524536735 / 5759971954 : ℚ)) * X ^ 7 + C ((55828190838155 / 5759971954 : ℚ)) * X ^ 8 + C ((60170954141099 / 5759971954 : ℚ)) * X ^ 9 + C ((31749957100647 / 2879985977 : ℚ)) * X ^ 10 + C ((31974566668981 / 2879985977 : ℚ)) * X ^ 11 + C ((2494464455741 / 261816907 : ℚ)) * X ^ 12 + C ((22639996903635 / 2879985977 : ℚ)) * X ^ 13 + C ((31758778001037 / 5759971954 : ℚ)) * X ^ 14 + C ((15329756387511 / 5759971954 : ℚ)) * X ^ 15 + C ((4076302970878 / 2879985977 : ℚ)) * X ^ 16 + C ((86259621366 / 261816907 : ℚ)) * X ^ 17 + C ((-1336154589130 / 2879985977 : ℚ)) * X ^ 18
def CW_120_2_pim : Polynomial ℚ := C ((-2494011978307 / 2879985977 : ℚ)) + C ((-4988023956614 / 2879985977 : ℚ)) * X + C ((-11324305764921 / 5759971954 : ℚ)) * X ^ 2 + C ((-7458156359846 / 2879985977 : ℚ)) * X ^ 3 + C ((-5554087766993 / 2879985977 : ℚ)) * X ^ 4 + C ((-233029158873 / 261816907 : ℚ)) * X ^ 5 + C ((-1810033820558 / 2879985977 : ℚ)) * X ^ 6 + C ((2606858887241 / 5759971954 : ℚ)) * X ^ 7 + C ((7251283786997 / 5759971954 : ℚ)) * X ^ 8 + C ((7886797506367 / 5759971954 : ℚ)) * X ^ 9 + C ((5380971120114 / 2879985977 : ℚ)) * X ^ 10 + C ((9987735857579 / 2879985977 : ℚ)) * X ^ 11 + C ((14594500595044 / 2879985977 : ℚ)) * X ^ 12 + C ((16706201887821 / 2879985977 : ℚ)) * X ^ 13 + C ((37639924449783 / 5759971954 : ℚ)) * X ^ 14 + C ((32013662069003 / 5759971954 : ℚ)) * X ^ 15 + C ((11162290898155 / 2879985977 : ℚ)) * X ^ 16 + C ((8198511428550 / 2879985977 : ℚ)) * X ^ 17 + C ((3231275047415 / 2879985977 : ℚ)) * X ^ 18
theorem CW_120_2_pre_eq :
    CW_1_re_100 * Fplus_dV_re_020 - CW_1_im_100 * Fplus_dV_im_020 = CW_120_2_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_1_re_100, CW_1_im_100, Fplus_dV_re_020, Fplus_dV_im_020, CW_120_2_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CW_120_2_pim_eq :
    CW_1_re_100 * Fplus_dV_im_020 + CW_1_im_100 * Fplus_dV_re_020 = CW_120_2_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_1_re_100, CW_1_im_100, Fplus_dV_re_020, Fplus_dV_im_020, CW_120_2_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CW_120_2_mul :
    CW_1_c_100 * Fplus_dV_c_020 = ofLadj CW_120_2_pre CW_120_2_pim := by
  rw [CW_1_c_100, Fplus_dV_c_020, ofLadj_mul, CW_120_2_pre_eq, CW_120_2_pim_eq]

def CW_120_3_pre : Polynomial ℚ := C ((-51484376857 / 785450721 : ℚ)) + C ((12412793796100 / 8639957931 : ℚ)) * X + C ((22907777601722 / 8639957931 : ℚ)) * X ^ 2 + C ((39265417927990 / 8639957931 : ℚ)) * X ^ 3 + C ((65361264010436 / 8639957931 : ℚ)) * X ^ 4 + C ((84257720905663 / 8639957931 : ℚ)) * X ^ 5 + C ((34167109408529 / 2879985977 : ℚ)) * X ^ 6 + C ((117220732671830 / 8639957931 : ℚ)) * X ^ 7 + C ((119517411503269 / 8639957931 : ℚ)) * X ^ 8 + C ((41115789462993 / 2879985977 : ℚ)) * X ^ 9 + C ((42254027334139 / 2879985977 : ℚ)) * X ^ 10 + C ((128380063236728 / 8639957931 : ℚ)) * X ^ 11 + C ((114349288206317 / 8639957931 : ℚ)) * X ^ 12 + C ((100439590787257 / 8639957931 : ℚ)) * X ^ 13 + C ((26750664525093 / 2879985977 : ℚ)) * X ^ 14 + C ((50150278002020 / 8639957931 : ℚ)) * X ^ 15 + C ((28733431129802 / 8639957931 : ℚ)) * X ^ 16 + C ((3496607936626 / 2879985977 : ℚ)) * X ^ 17 + C ((-155380969034 / 785450721 : ℚ)) * X ^ 18
def CW_120_3_pim : Polynomial ℚ := C ((-11630147254465 / 8639957931 : ℚ)) + C ((-23260294508930 / 8639957931 : ℚ)) * X + C ((-10174187781204 / 2879985977 : ℚ)) * X ^ 2 + C ((-44004724583126 / 8639957931 : ℚ)) * X ^ 3 + C ((-15336678662718 / 2879985977 : ℚ)) * X ^ 4 + C ((-40766706125693 / 8639957931 : ℚ)) * X ^ 5 + C ((-35709246415033 / 8639957931 : ℚ)) * X ^ 6 + C ((-22021702239082 / 8639957931 : ℚ)) * X ^ 7 + C ((-11685029227165 / 8639957931 : ℚ)) * X ^ 8 + C ((-11176137028403 / 8639957931 : ℚ)) * X ^ 9 + C ((-8390315946461 / 8639957931 : ℚ)) * X ^ 10 + C ((7272036286850 / 8639957931 : ℚ)) * X ^ 11 + C ((7644796173387 / 2879985977 : ℚ)) * X ^ 12 + C ((32982478436785 / 8639957931 : ℚ)) * X ^ 13 + C ((4270321079551 / 785450721 : ℚ)) * X ^ 14 + C ((47592868727900 / 8639957931 : ℚ)) * X ^ 15 + C ((38525448928214 / 8639957931 : ℚ)) * X ^ 16 + C ((885887323554 / 261816907 : ℚ)) * X ^ 17 + C ((11722647564106 / 8639957931 : ℚ)) * X ^ 18
theorem CW_120_3_pre_eq :
    CW_1_re_010 * Fplus_dV_re_110 - CW_1_im_010 * Fplus_dV_im_110 = CW_120_3_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_1_re_010, CW_1_im_010, Fplus_dV_re_110, Fplus_dV_im_110, CW_120_3_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CW_120_3_pim_eq :
    CW_1_re_010 * Fplus_dV_im_110 + CW_1_im_010 * Fplus_dV_re_110 = CW_120_3_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_1_re_010, CW_1_im_010, Fplus_dV_re_110, Fplus_dV_im_110, CW_120_3_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CW_120_3_mul :
    CW_1_c_010 * Fplus_dV_c_110 = ofLadj CW_120_3_pre CW_120_3_pim := by
  rw [CW_1_c_010, Fplus_dV_c_110, ofLadj_mul, CW_120_3_pre_eq, CW_120_3_pim_eq]

def CW_120_4_pre : Polynomial ℚ := C ((-28792289254 / 2879985977 : ℚ)) + C ((1267552756204 / 785450721 : ℚ)) * X + C ((52995661419529 / 17279915862 : ℚ)) * X ^ 2 + C ((29424374867541 / 5759971954 : ℚ)) * X ^ 3 + C ((133216786650533 / 17279915862 : ℚ)) * X ^ 4 + C ((77611360537132 / 8639957931 : ℚ)) * X ^ 5 + C ((89680431415265 / 8639957931 : ℚ)) * X ^ 6 + C ((31655699233319 / 2879985977 : ℚ)) * X ^ 7 + C ((60375431025759 / 5759971954 : ℚ)) * X ^ 8 + C ((178802507236711 / 17279915862 : ℚ)) * X ^ 9 + C ((177574224324169 / 17279915862 : ℚ)) * X ^ 10 + C ((88336250048686 / 8639957931 : ℚ)) * X ^ 11 + C ((49896021229227 / 5759971954 : ℚ)) * X ^ 12 + C ((20967807636197 / 2879985977 : ℚ)) * X ^ 13 + C ((15475528079109 / 2879985977 : ℚ)) * X ^ 14 + C ((49560856329487 / 17279915862 : ℚ)) * X ^ 15 + C ((14445003845483 / 8639957931 : ℚ)) * X ^ 16 + C ((2375932967350 / 8639957931 : ℚ)) * X ^ 17 + C ((-1192758736649 / 2879985977 : ℚ)) * X ^ 18
def CW_120_4_pim : Polynomial ℚ := C ((-9936325658924 / 8639957931 : ℚ)) + C ((-19872651317848 / 8639957931 : ℚ)) * X + C ((-44182591244663 / 17279915862 : ℚ)) * X ^ 2 + C ((-56983963748911 / 17279915862 : ℚ)) * X ^ 3 + C ((-13715337846437 / 5759971954 : ℚ)) * X ^ 4 + C ((-3154496864615 / 2879985977 : ℚ)) * X ^ 5 + C ((68075193191 / 2879985977 : ℚ)) * X ^ 6 + C ((15784905380711 / 8639957931 : ℚ)) * X ^ 7 + C ((48318050330335 / 17279915862 : ℚ)) * X ^ 8 + C ((15907919721495 / 5759971954 : ℚ)) * X ^ 9 + C ((15502812947153 / 5759971954 : ℚ)) * X ^ 10 + C ((32165133857059 / 8639957931 : ℚ)) * X ^ 11 + C ((82152096586777 / 17279915862 : ℚ)) * X ^ 12 + C ((42687032436359 / 8639957931 : ℚ)) * X ^ 13 + C ((48790573105558 / 8639957931 : ℚ)) * X ^ 14 + C ((82997833332019 / 17279915862 : ℚ)) * X ^ 15 + C ((2824233965650 / 785450721 : ℚ)) * X ^ 16 + C ((22650307788392 / 8639957931 : ℚ)) * X ^ 17 + C ((2582267039735 / 2879985977 : ℚ)) * X ^ 18
theorem CW_120_4_pre_eq :
    CW_2_re_100 * Fplus_dW_re_020 - CW_2_im_100 * Fplus_dW_im_020 = CW_120_4_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_2_re_100, CW_2_im_100, Fplus_dW_re_020, Fplus_dW_im_020, CW_120_4_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CW_120_4_pim_eq :
    CW_2_re_100 * Fplus_dW_im_020 + CW_2_im_100 * Fplus_dW_re_020 = CW_120_4_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_2_re_100, CW_2_im_100, Fplus_dW_re_020, Fplus_dW_im_020, CW_120_4_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CW_120_4_mul :
    CW_2_c_100 * Fplus_dW_c_020 = ofLadj CW_120_4_pre CW_120_4_pim := by
  rw [CW_2_c_100, Fplus_dW_c_020, ofLadj_mul, CW_120_4_pre_eq, CW_120_4_pim_eq]

def CW_120_5_pre : Polynomial ℚ := C ((-2884040997512 / 8639957931 : ℚ)) + C ((-2150827032800 / 8639957931 : ℚ)) * X + C ((-712499022826 / 785450721 : ℚ)) * X ^ 2 + C ((-7999614397348 / 8639957931 : ℚ)) * X ^ 3 + C ((-10417639048180 / 8639957931 : ℚ)) * X ^ 4 + C ((-17542161600494 / 8639957931 : ℚ)) * X ^ 5 + C ((-13347292976056 / 8639957931 : ℚ)) * X ^ 6 + C ((-17943742038121 / 8639957931 : ℚ)) * X ^ 7 + C ((-18048206924524 / 8639957931 : ℚ)) * X ^ 8 + C ((-17801867356487 / 8639957931 : ℚ)) * X ^ 9 + C ((-17606887600363 / 8639957931 : ℚ)) * X ^ 10 + C ((-14979600149366 / 8639957931 : ℚ)) * X ^ 11 + C ((-1405096415233 / 785450721 : ℚ)) * X ^ 12 + C ((-3321459368467 / 2879985977 : ℚ)) * X ^ 13 + C ((-3349530842392 / 2879985977 : ℚ)) * X ^ 14 + C ((-241352679771 / 261816907 : ℚ)) * X ^ 15 + C ((-716357214964 / 8639957931 : ℚ)) * X ^ 16 + C ((-4911225839402 / 8639957931 : ℚ)) * X ^ 17 + C ((-146178480834 / 2879985977 : ℚ)) * X ^ 18
def CW_120_5_pim : Polynomial ℚ := C ((104285651100 / 2879985977 : ℚ)) + C ((208571302200 / 2879985977 : ℚ)) * X + C ((2537809118500 / 8639957931 : ℚ)) * X ^ 2 + C ((-228072465350 / 785450721 : ℚ)) * X ^ 3 + C ((2971171499974 / 8639957931 : ℚ)) * X ^ 4 + C ((-3204794928572 / 8639957931 : ℚ)) * X ^ 5 + C ((-5201086002358 / 8639957931 : ℚ)) * X ^ 6 + C ((-4299673094125 / 8639957931 : ℚ)) * X ^ 7 + C ((-719498746970 / 785450721 : ℚ)) * X ^ 8 + C ((-2648535330083 / 2879985977 : ℚ)) * X ^ 9 + C ((-7646593864453 / 8639957931 : ℚ)) * X ^ 10 + C ((-21672546200 / 23801537 : ℚ)) * X ^ 11 + C ((-8087674676747 / 8639957931 : ℚ)) * X ^ 12 + C ((-9700757762851 / 8639957931 : ℚ)) * X ^ 13 + C ((-4685271299080 / 8639957931 : ℚ)) * X ^ 14 + C ((-3403888904195 / 2879985977 : ℚ)) * X ^ 15 + C ((-4382288035712 / 8639957931 : ℚ)) * X ^ 16 + C ((-2320385667958 / 8639957931 : ℚ)) * X ^ 17 + C ((-1189462109288 / 2879985977 : ℚ)) * X ^ 18
theorem CW_120_5_pre_eq :
    CW_2_re_010 * Fplus_dW_re_110 - CW_2_im_010 * Fplus_dW_im_110 = CW_120_5_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_2_re_010, CW_2_im_010, Fplus_dW_re_110, Fplus_dW_im_110, CW_120_5_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CW_120_5_pim_eq :
    CW_2_re_010 * Fplus_dW_im_110 + CW_2_im_010 * Fplus_dW_re_110 = CW_120_5_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_2_re_010, CW_2_im_010, Fplus_dW_re_110, Fplus_dW_im_110, CW_120_5_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CW_120_5_mul :
    CW_2_c_010 * Fplus_dW_c_110 = ofLadj CW_120_5_pre CW_120_5_pim := by
  rw [CW_2_c_010, Fplus_dW_c_110, ofLadj_mul, CW_120_5_pre_eq, CW_120_5_pim_eq]

def CW_120_6_pre : Polynomial ℚ := C ((-3299435578 / 785450721 : ℚ)) + C ((-5609245088 / 785450721 : ℚ)) * X ^ 2 + C ((25284104 / 261816907 : ℚ)) * X ^ 3 + C ((-15841552 / 261816907 : ℚ)) * X ^ 4 + C ((4763211242 / 785450721 : ℚ)) * X ^ 5 + C ((4763211242 / 785450721 : ℚ)) * X ^ 6 + C ((-15841552 / 261816907 : ℚ)) * X ^ 7 + C ((25284104 / 261816907 : ℚ)) * X ^ 8 + C ((-5609245088 / 785450721 : ℚ)) * X ^ 9
def CW_120_6_pim : Polynomial ℚ := C ((-16692956114 / 2879985977 : ℚ)) + C ((-33385912228 / 2879985977 : ℚ)) * X + C ((-11303417848 / 2879985977 : ℚ)) * X ^ 2 + C ((-77302274092 / 8639957931 : ℚ)) * X ^ 3 + C ((-96411876964 / 8639957931 : ℚ)) * X ^ 4 + C ((-128696365582 / 8639957931 : ℚ)) * X ^ 5 + C ((28538628898 / 8639957931 : ℚ)) * X ^ 6 + C ((-3745859720 / 8639957931 : ℚ)) * X ^ 7 + C ((-22855462592 / 8639957931 : ℚ)) * X ^ 8 + C ((-22082494380 / 2879985977 : ℚ)) * X ^ 9
theorem CW_120_6_neg_re : -CW_3_re_120 = CW_120_6_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_3_re_120, CW_120_6_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CW_120_6_neg_im : -CW_3_im_120 = CW_120_6_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_3_im_120, CW_120_6_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CW_120_6_mul : -CW_3_c_120 = ofLadj CW_120_6_pre CW_120_6_pim := by
  rw [CW_3_c_120, ofLadj_neg, CW_120_6_neg_re, CW_120_6_neg_im]

def CW_coeff_120 : Ki := CW_0_c_100 * Fplus_dU_c_020 + CW_0_c_010 * Fplus_dU_c_110 + CW_1_c_100 * Fplus_dV_c_020 + CW_1_c_010 * Fplus_dV_c_110 + CW_2_c_100 * Fplus_dW_c_020 + CW_2_c_010 * Fplus_dW_c_110 + (-CW_3_c_120)

theorem CW_coeff_120_sum :
    CW_coeff_120 = ofLadj (CW_120_0_pre + CW_120_1_pre + CW_120_2_pre + CW_120_3_pre + CW_120_4_pre + CW_120_5_pre + CW_120_6_pre) (CW_120_0_pim + CW_120_1_pim + CW_120_2_pim + CW_120_3_pim + CW_120_4_pim + CW_120_5_pim + CW_120_6_pim) := by
  simp only [CW_coeff_120, CW_120_0_mul, CW_120_1_mul, CW_120_2_mul, CW_120_3_mul, CW_120_4_mul, CW_120_5_mul, CW_120_6_mul]
  simp [ofLadj_add, add_assoc]

def CW_120_qre : Polynomial ℚ := C ((-1736753849445 / 5759971954 : ℚ)) + C ((62586787196323 / 17279915862 : ℚ)) * X + C ((19785801149569 / 8639957931 : ℚ)) * X ^ 2 + C ((35100355891307 / 8639957931 : ℚ)) * X ^ 3 + C ((49040667090077 / 8639957931 : ℚ)) * X ^ 4 + C ((10890028110219 / 5759971954 : ℚ)) * X ^ 5 + C ((31038047467813 / 8639957931 : ℚ)) * X ^ 6 + C ((10336186361201 / 8639957931 : ℚ)) * X ^ 7 + C ((-8947033536377 / 8639957931 : ℚ)) * X ^ 8
def CW_120_qim : Polynomial ℚ := C ((-159190066885 / 64718786 : ℚ)) + C ((-159190066885 / 64718786 : ℚ)) * X + C ((-999815413219 / 2879985977 : ℚ)) * X ^ 2 + C ((-7051339940044 / 2879985977 : ℚ)) * X ^ 3 + C ((19922898115838 / 8639957931 : ℚ)) * X ^ 4 + C ((39839680394153 / 17279915862 : ℚ)) * X ^ 5 + C ((16460718463232 / 8639957931 : ℚ)) * X ^ 6 + C ((36922879884227 / 8639957931 : ℚ)) * X ^ 7 + C ((16046661843164 / 8639957931 : ℚ)) * X ^ 8
theorem CW_coeff_120_poly_re :
    CW_120_0_pre + CW_120_1_pre + CW_120_2_pre + CW_120_3_pre + CW_120_4_pre + CW_120_5_pre + CW_120_6_pre = (0 : Polynomial ℚ) + Phi11 * CW_120_qre := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [CW_120_0_pre, CW_120_1_pre, CW_120_2_pre, CW_120_3_pre, CW_120_4_pre, CW_120_5_pre, CW_120_6_pre, CW_120_qre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try ring
theorem CW_coeff_120_poly_im :
    CW_120_0_pim + CW_120_1_pim + CW_120_2_pim + CW_120_3_pim + CW_120_4_pim + CW_120_5_pim + CW_120_6_pim = (0 : Polynomial ℚ) + Phi11 * CW_120_qim := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [CW_120_0_pim, CW_120_1_pim, CW_120_2_pim, CW_120_3_pim, CW_120_4_pim, CW_120_5_pim, CW_120_6_pim, CW_120_qim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try ring
theorem CW_coeff_120_eq :
    CW_coeff_120 = (0 : Ki) := by
  rw [CW_coeff_120_sum, CW_coeff_120_poly_re,
    CW_coeff_120_poly_im, ofLadj_add_Phi11]
  exact ofLadj_zero

end V14Formalization.D12SigmaPlusSegreCore
