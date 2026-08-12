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

def CU_121_0_pre : Polynomial ℚ := C ((-1924215844792 / 235794999 : ℚ)) + C ((90367575012928 / 78598333 : ℚ)) * X + C ((542152426272304 / 235794999 : ℚ)) * X ^ 2 + C ((7296854726960 / 1948719 : ℚ)) * X ^ 3 + C ((1493086923195880 / 235794999 : ℚ)) * X ^ 4 + C ((1911786355982044 / 235794999 : ℚ)) * X ^ 5 + C ((209530602983348 / 21435909 : ℚ)) * X ^ 6 + C ((825454368906164 / 78598333 : ℚ)) * X ^ 7 + C ((2305313857369252 / 235794999 : ℚ)) * X ^ 8 + C ((2182710608276500 / 235794999 : ℚ)) * X ^ 9 + C ((696387305378552 / 78598333 : ℚ)) * X ^ 10 + C ((2056086698421752 / 235794999 : ℚ)) * X ^ 11 + C ((606019730365624 / 78598333 : ℚ)) * X ^ 12 + C ((546852727334732 / 78598333 : ℚ)) * X ^ 13 + C ((1422394435407092 / 235794999 : ℚ)) * X ^ 14 + C ((924826663019804 / 235794999 : ℚ)) * X ^ 15 + C ((52104260636936 / 21435909 : ℚ)) * X ^ 16 + C ((180096590171512 / 235794999 : ℚ)) * X ^ 17 + C ((-19483173500936 / 78598333 : ℚ)) * X ^ 18
def CU_121_0_pim : Polynomial ℚ := C ((-257129140724504 / 235794999 : ℚ)) + C ((-514258281449008 / 235794999 : ℚ)) * X + C ((-664431809947544 / 235794999 : ℚ)) * X ^ 2 + C ((-911483777461472 / 235794999 : ℚ)) * X ^ 3 + C ((-305786028288088 / 78598333 : ℚ)) * X ^ 4 + C ((-224441894585324 / 78598333 : ℚ)) * X ^ 5 + C ((-134519408502388 / 78598333 : ℚ)) * X ^ 6 + C ((113349388179580 / 235794999 : ℚ)) * X ^ 7 + C ((35850283491772 / 21435909 : ℚ)) * X ^ 8 + C ((125565309835772 / 78598333 : ℚ)) * X ^ 9 + C ((295662805984624 / 235794999 : ℚ)) * X ^ 10 + C ((433924619846816 / 235794999 : ℚ)) * X ^ 11 + C ((190728811236336 / 78598333 : ℚ)) * X ^ 12 + C ((641326838684852 / 235794999 : ℚ)) * X ^ 13 + C ((290240539098868 / 78598333 : ℚ)) * X ^ 14 + C ((928066553165804 / 235794999 : ℚ)) * X ^ 15 + C ((788139088586984 / 235794999 : ℚ)) * X ^ 16 + C ((642335778920776 / 235794999 : ℚ)) * X ^ 17 + C ((6955548538288 / 7145303 : ℚ)) * X ^ 18
theorem CU_121_0_pre_eq :
    CU_0_re_011 * Fplus_dU_re_110 - CU_0_im_011 * Fplus_dU_im_110 = CU_121_0_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_0_re_011, CU_0_im_011, Fplus_dU_re_110, Fplus_dU_im_110, CU_121_0_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CU_121_0_pim_eq :
    CU_0_re_011 * Fplus_dU_im_110 + CU_0_im_011 * Fplus_dU_re_110 = CU_121_0_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_0_re_011, CU_0_im_011, Fplus_dU_re_110, Fplus_dU_im_110, CU_121_0_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CU_121_0_mul :
    CU_0_c_011 * Fplus_dU_c_110 = ofLadj CU_121_0_pre CU_121_0_pim := by
  rw [CU_0_c_011, Fplus_dU_c_110, ofLadj_mul, CU_121_0_pre_eq, CU_121_0_pim_eq]

def CU_121_1_pre : Polynomial ℚ := C ((283093585124 / 235794999 : ℚ)) + C ((605713305265040 / 235794999 : ℚ)) * X + C ((382307720777300 / 78598333 : ℚ)) * X ^ 2 + C ((1974827246744116 / 235794999 : ℚ)) * X ^ 3 + C ((3222886606343084 / 235794999 : ℚ)) * X ^ 4 + C ((1386304771122636 / 78598333 : ℚ)) * X ^ 5 + C ((5069570175135232 / 235794999 : ℚ)) * X ^ 6 + C ((527675463939208 / 21435909 : ℚ)) * X ^ 7 + C ((1967193118587588 / 78598333 : ℚ)) * X ^ 8 + C ((2035852827916964 / 78598333 : ℚ)) * X ^ 9 + C ((2088256314872344 / 78598333 : ℚ)) * X ^ 10 + C ((2107731699824760 / 78598333 : ℚ)) * X ^ 11 + C ((5659055639351992 / 235794999 : ℚ)) * X ^ 12 + C ((1653545107139664 / 78598333 : ℚ)) * X ^ 13 + C ((3926752109018648 / 235794999 : ℚ)) * X ^ 14 + C ((829821278868620 / 78598333 : ℚ)) * X ^ 15 + C ((1440893052160372 / 235794999 : ℚ)) * X ^ 16 + C ((176745730131016 / 78598333 : ℚ)) * X ^ 17 + C ((-30693220127448 / 78598333 : ℚ)) * X ^ 18
def CU_121_1_pim : Polynomial ℚ := C ((-559310789690324 / 235794999 : ℚ)) + C ((-1118621579380648 / 235794999 : ℚ)) * X + C ((-1511276278679108 / 235794999 : ℚ)) * X ^ 2 + C ((-2122467189784156 / 235794999 : ℚ)) * X ^ 3 + C ((-2221266439556420 / 235794999 : ℚ)) * X ^ 4 + C ((-1974843673951516 / 235794999 : ℚ)) * X ^ 5 + C ((-1731944992608128 / 235794999 : ℚ)) * X ^ 6 + C ((-1031603264255936 / 235794999 : ℚ)) * X ^ 7 + C ((-529611181408468 / 235794999 : ℚ)) * X ^ 8 + C ((-15150587512796 / 7145303 : ℚ)) * X ^ 9 + C ((-121253879923512 / 78598333 : ℚ)) * X ^ 10 + C ((395226233921632 / 235794999 : ℚ)) * X ^ 11 + C ((1154214107613800 / 235794999 : ℚ)) * X ^ 12 + C ((51002319850424 / 7145303 : ℚ)) * X ^ 13 + C ((774636419885080 / 78598333 : ℚ)) * X ^ 14 + C ((2336245060820156 / 235794999 : ℚ)) * X ^ 15 + C ((1914844767489892 / 235794999 : ℚ)) * X ^ 16 + C ((487924929177456 / 78598333 : ℚ)) * X ^ 17 + C ((196151843818272 / 78598333 : ℚ)) * X ^ 18
theorem CU_121_1_pre_eq :
    CU_1_re_011 * Fplus_dV_re_110 - CU_1_im_011 * Fplus_dV_im_110 = CU_121_1_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_1_re_011, CU_1_im_011, Fplus_dV_re_110, Fplus_dV_im_110, CU_121_1_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CU_121_1_pim_eq :
    CU_1_re_011 * Fplus_dV_im_110 + CU_1_im_011 * Fplus_dV_re_110 = CU_121_1_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_1_re_011, CU_1_im_011, Fplus_dV_re_110, Fplus_dV_im_110, CU_121_1_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CU_121_1_mul :
    CU_1_c_011 * Fplus_dV_c_110 = ofLadj CU_121_1_pre CU_121_1_pim := by
  rw [CU_1_c_011, Fplus_dV_c_110, ofLadj_mul, CU_121_1_pre_eq, CU_121_1_pim_eq]

def CU_121_2_pre : Polynomial ℚ := C ((48882100665448 / 235794999 : ℚ)) + C ((660626140859680 / 235794999 : ℚ)) * X + C ((448091447471152 / 78598333 : ℚ)) * X ^ 2 + C ((736128214639712 / 78598333 : ℚ)) * X ^ 3 + C ((3287978719004800 / 235794999 : ℚ)) * X ^ 4 + C ((1302673082667472 / 78598333 : ℚ)) * X ^ 5 + C ((400531096168240 / 21435909 : ℚ)) * X ^ 6 + C ((1560077232567424 / 78598333 : ℚ)) * X ^ 7 + C ((4459114389783076 / 235794999 : ℚ)) * X ^ 8 + C ((132570008928572 / 7145303 : ℚ)) * X ^ 9 + C ((1436825740624980 / 78598333 : ℚ)) * X ^ 10 + C ((4237658658752048 / 235794999 : ℚ)) * X ^ 11 + C ((331804643728660 / 21435909 : ℚ)) * X ^ 12 + C ((1010178650743140 / 78598333 : ℚ)) * X ^ 13 + C ((204611795078540 / 21435909 : ℚ)) * X ^ 14 + C ((416200985203704 / 78598333 : ℚ)) * X ^ 15 + C ((224847398002368 / 78598333 : ℚ)) * X ^ 16 + C ((176719384158880 / 235794999 : ℚ)) * X ^ 17 + C ((-143650023086360 / 235794999 : ℚ)) * X ^ 18
def CU_121_2_pim : Polynomial ℚ := C ((-148274455192696 / 78598333 : ℚ)) + C ((-296548910385392 / 78598333 : ℚ)) * X + C ((-1055325099283712 / 235794999 : ℚ)) * X ^ 2 + C ((-1242607023538808 / 235794999 : ℚ)) * X ^ 3 + C ((-935700676270640 / 235794999 : ℚ)) * X ^ 4 + C ((-325611602740808 / 235794999 : ℚ)) * X ^ 5 + C ((162692320814632 / 235794999 : ℚ)) * X ^ 6 + C ((879471942114136 / 235794999 : ℚ)) * X ^ 7 + C ((430476117214652 / 78598333 : ℚ)) * X ^ 8 + C ((1279302104120660 / 235794999 : ℚ)) * X ^ 9 + C ((407834022358844 / 78598333 : ℚ)) * X ^ 10 + C ((1586666906804024 / 235794999 : ℚ)) * X ^ 11 + C ((1949831746531516 / 235794999 : ℚ)) * X ^ 12 + C ((2059710077614924 / 235794999 : ℚ)) * X ^ 13 + C ((744955251448908 / 78598333 : ℚ)) * X ^ 14 + C ((1963359779031472 / 235794999 : ℚ)) * X ^ 15 + C ((474971983594200 / 78598333 : ℚ)) * X ^ 16 + C ((1021690413595448 / 235794999 : ℚ)) * X ^ 17 + C ((376556037576904 / 235794999 : ℚ)) * X ^ 18
theorem CU_121_2_pre_eq :
    CU_2_re_011 * Fplus_dW_re_110 - CU_2_im_011 * Fplus_dW_im_110 = CU_121_2_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_2_re_011, CU_2_im_011, Fplus_dW_re_110, Fplus_dW_im_110, CU_121_2_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CU_121_2_pim_eq :
    CU_2_re_011 * Fplus_dW_im_110 + CU_2_im_011 * Fplus_dW_re_110 = CU_121_2_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_2_re_011, CU_2_im_011, Fplus_dW_re_110, Fplus_dW_im_110, CU_121_2_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CU_121_2_mul :
    CU_2_c_011 * Fplus_dW_c_110 = ofLadj CU_121_2_pre CU_121_2_pim := by
  rw [CU_2_c_011, Fplus_dW_c_110, ofLadj_mul, CU_121_2_pre_eq, CU_121_2_pim_eq]

theorem CU_121_3_mul : CU_3_c_021 = ofLadj CU_3_re_021 CU_3_im_021 := rfl

def CU_coeff_121 : Ki := CU_0_c_011 * Fplus_dU_c_110 + CU_1_c_011 * Fplus_dV_c_110 + CU_2_c_011 * Fplus_dW_c_110 + CU_3_c_021

theorem CU_coeff_121_sum :
    CU_coeff_121 = ofLadj (CU_121_0_pre + CU_121_1_pre + CU_121_2_pre + CU_3_re_021) (CU_121_0_pim + CU_121_1_pim + CU_121_2_pim + CU_3_im_021) := by
  simp only [CU_coeff_121, CU_121_0_mul, CU_121_1_mul, CU_121_2_mul, CU_121_3_mul]
  simpa [add_assoc] using ofLadj_add4 CU_121_0_pre CU_121_0_pim CU_121_1_pre CU_121_1_pim CU_121_2_pre CU_121_2_pim CU_3_re_021 CU_3_im_021

def CU_121_qre : Polynomial ℚ := C ((47467625979548 / 235794999 : ℚ)) + C ((1489974545183956 / 235794999 : ℚ)) * X + C ((45310195630652 / 7145303 : ℚ)) * X ^ 2 + C ((2031853165362928 / 235794999 : ℚ)) * X ^ 3 + C ((88999479850088 / 7145303 : ℚ)) * X ^ 4 + C ((658103780687668 / 78598333 : ℚ)) * X ^ 5 + C ((600509649483444 / 78598333 : ℚ)) * X ^ 6 + C ((1181232368694952 / 235794999 : ℚ)) * X ^ 7 + C ((-294179203971512 / 235794999 : ℚ)) * X ^ 8
def CU_121_qim : Polynomial ℚ := C ((-1260414527281852 / 235794999 : ℚ)) + C ((-1260414527281852 / 235794999 : ℚ)) * X + C ((-235960394503148 / 78598333 : ℚ)) * X ^ 2 + C ((-348461053311600 / 78598333 : ℚ)) * X ^ 3 + C ((201825238281136 / 235794999 : ℚ)) * X ^ 4 + C ((1099771586157956 / 235794999 : ℚ)) * X ^ 5 + C ((333366275603628 / 78598333 : ℚ)) * X ^ 6 + C ((175750573568488 / 21435909 : ℚ)) * X ^ 7 + C ((1194544670795224 / 235794999 : ℚ)) * X ^ 8
theorem CU_coeff_121_poly_re :
    CU_121_0_pre + CU_121_1_pre + CU_121_2_pre + CU_3_re_021 = (0 : Polynomial ℚ) + Phi11 * CU_121_qre := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [CU_121_0_pre, CU_121_1_pre, CU_121_2_pre, CU_3_re_021, CU_121_qre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try ring
theorem CU_coeff_121_poly_im :
    CU_121_0_pim + CU_121_1_pim + CU_121_2_pim + CU_3_im_021 = (0 : Polynomial ℚ) + Phi11 * CU_121_qim := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [CU_121_0_pim, CU_121_1_pim, CU_121_2_pim, CU_3_im_021, CU_121_qim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try ring
theorem CU_coeff_121_eq :
    CU_coeff_121 = (0 : Ki) := by
  rw [CU_coeff_121_sum, CU_coeff_121_poly_re,
    CU_coeff_121_poly_im, ofLadj_add_Phi11]
  exact ofLadj_zero

end V14Formalization.D12SigmaPlusSegreCore
