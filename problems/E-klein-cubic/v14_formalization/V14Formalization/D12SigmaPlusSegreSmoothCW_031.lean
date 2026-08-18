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

def CW_031_0_pre : Polynomial ℚ := C ((6051707098220 / 8639957931 : ℚ)) + C ((-14758616231440 / 8639957931 : ℚ)) * X + C ((-18247483096504 / 8639957931 : ℚ)) * X ^ 2 + C ((-37028349740836 / 8639957931 : ℚ)) * X ^ 3 + C ((-20807095303600 / 2879985977 : ℚ)) * X ^ 4 + C ((-62386607174984 / 8639957931 : ℚ)) * X ^ 5 + C ((-7509813295480 / 785450721 : ℚ)) * X ^ 6 + C ((-26649173610584 / 2879985977 : ℚ)) * X ^ 7 + C ((-25499736222852 / 2879985977 : ℚ)) * X ^ 8 + C ((-24841677820096 / 2879985977 : ℚ)) * X ^ 9 + C ((-24557773556748 / 2879985977 : ℚ)) * X ^ 10 + C ((-78847800013916 / 8639957931 : ℚ)) * X ^ 11 + C ((-58914704438804 / 8639957931 : ℚ)) * X ^ 12 + C ((-56277550363784 / 8639957931 : ℚ)) * X ^ 13 + C ((-3588259902520 / 785450721 : ℚ)) * X ^ 14 + C ((-15363045381500 / 8639957931 : ℚ)) * X ^ 15 + C ((-16380791038324 / 8639957931 : ℚ)) * X ^ 16 + C ((3840548036972 / 8639957931 : ℚ)) * X ^ 17 + C ((2163189539452 / 8639957931 : ℚ)) * X ^ 18
def CW_031_0_pim : Polynomial ℚ := C ((12914070220564 / 8639957931 : ℚ)) + C ((25828140441128 / 8639957931 : ℚ)) * X + C ((22251050802304 / 8639957931 : ℚ)) * X ^ 2 + C ((1259476229316 / 261816907 : ℚ)) * X ^ 3 + C ((24302422164400 / 8639957931 : ℚ)) * X ^ 4 + C ((21979674929260 / 8639957931 : ℚ)) * X ^ 5 + C ((14522094141988 / 8639957931 : ℚ)) * X ^ 6 + C ((-228899079212 / 785450721 : ℚ)) * X ^ 7 + C ((-3553466344720 / 8639957931 : ℚ)) * X ^ 8 + C ((-3047289245848 / 8639957931 : ℚ)) * X ^ 9 + C ((-709984445204 / 2879985977 : ℚ)) * X ^ 10 + C ((-13401808293532 / 8639957931 : ℚ)) * X ^ 11 + C ((-24673663251452 / 8639957931 : ℚ)) * X ^ 12 + C ((-6726412567464 / 2879985977 : ℚ)) * X ^ 13 + C ((-322187812964 / 71404611 : ℚ)) * X ^ 14 + C ((-7591451857160 / 2879985977 : ℚ)) * X ^ 15 + C ((-21427922216572 / 8639957931 : ℚ)) * X ^ 16 + C ((-1459029363692 / 785450721 : ℚ)) * X ^ 17 + C ((4782377492 / 2879985977 : ℚ)) * X ^ 18
theorem CW_031_0_pre_eq :
    CW_0_re_020 * Fplus_dU_re_011 - CW_0_im_020 * Fplus_dU_im_011 = CW_031_0_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_0_re_020_def, CW_0_im_020_def, Fplus_dU_re_011_def, Fplus_dU_im_011_def, CW_031_0_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CW_031_0_pim_eq :
    CW_0_re_020 * Fplus_dU_im_011 + CW_0_im_020 * Fplus_dU_re_011 = CW_031_0_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_0_re_020_def, CW_0_im_020_def, Fplus_dU_re_011_def, Fplus_dU_im_011_def, CW_031_0_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CW_031_0_mul :
    CW_0_c_020 * Fplus_dU_c_011 = ofLadj CW_031_0_pre CW_031_0_pim := by
  rw [CW_0_c_020_def, Fplus_dU_c_011_def, ofLadj_mul, CW_031_0_pre_eq, CW_031_0_pim_eq]

def CW_031_1_pre : Polynomial ℚ := C ((-6174221031032 / 8639957931 : ℚ)) + C ((13364134761152 / 8639957931 : ℚ)) * X + C ((15327970445132 / 8639957931 : ℚ)) * X ^ 2 + C ((12712497582732 / 2879985977 : ℚ)) * X ^ 3 + C ((20799329901056 / 2879985977 : ℚ)) * X ^ 4 + C ((5363471546060 / 785450721 : ℚ)) * X ^ 5 + C ((85919973385676 / 8639957931 : ℚ)) * X ^ 6 + C ((26613061543748 / 2879985977 : ℚ)) * X ^ 7 + C ((75370730889052 / 8639957931 : ℚ)) * X ^ 8 + C ((24421117941384 / 2879985977 : ℚ)) * X ^ 9 + C ((73977992599996 / 8639957931 : ℚ)) * X ^ 10 + C ((77621998032232 / 8639957931 : ℚ)) * X ^ 11 + C ((60613857838844 / 8639957931 : ℚ)) * X ^ 12 + C ((57935383379020 / 8639957931 : ℚ)) * X ^ 13 + C ((37233238140856 / 8639957931 : ℚ)) * X ^ 14 + C ((12764133907640 / 8639957931 : ℚ)) * X ^ 15 + C ((17710940590796 / 8639957931 : ℚ)) * X ^ 16 + C ((-9210845788220 / 8639957931 : ℚ)) * X ^ 17 + C ((-4677061020436 / 8639957931 : ℚ)) * X ^ 18
def CW_031_1_pim : Polynomial ℚ := C ((-4010661674616 / 2879985977 : ℚ)) + C ((-8021323349232 / 2879985977 : ℚ)) * X + C ((-22017013092728 / 8639957931 : ℚ)) * X ^ 2 + C ((-43307902900888 / 8639957931 : ℚ)) * X ^ 3 + C ((-19252881314440 / 8639957931 : ℚ)) * X ^ 4 + C ((-21213946700932 / 8639957931 : ℚ)) * X ^ 5 + C ((-1087635154064 / 785450721 : ℚ)) * X ^ 6 + C ((9416021192920 / 8639957931 : ℚ)) * X ^ 7 + C ((10617280947004 / 8639957931 : ℚ)) * X ^ 8 + C ((9328146202316 / 8639957931 : ℚ)) * X ^ 9 + C ((9698353462700 / 8639957931 : ℚ)) * X ^ 10 + C ((6745527957632 / 2879985977 : ℚ)) * X ^ 11 + C ((2797710389372 / 785450721 : ℚ)) * X ^ 12 + C ((9699354862836 / 2879985977 : ℚ)) * X ^ 13 + C ((16366606550660 / 2879985977 : ℚ)) * X ^ 14 + C ((26812884223376 / 8639957931 : ℚ)) * X ^ 15 + C ((9259055698592 / 2879985977 : ℚ)) * X ^ 16 + C ((21809963997956 / 8639957931 : ℚ)) * X ^ 17 + C ((-566826403760 / 8639957931 : ℚ)) * X ^ 18
theorem CW_031_1_pre_eq :
    CW_1_re_020 * Fplus_dV_re_011 - CW_1_im_020 * Fplus_dV_im_011 = CW_031_1_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_1_re_020_def, CW_1_im_020_def, Fplus_dV_re_011_def, Fplus_dV_im_011_def, CW_031_1_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CW_031_1_pim_eq :
    CW_1_re_020 * Fplus_dV_im_011 + CW_1_im_020 * Fplus_dV_re_011 = CW_031_1_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_1_re_020_def, CW_1_im_020_def, Fplus_dV_re_011_def, Fplus_dV_im_011_def, CW_031_1_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CW_031_1_mul :
    CW_1_c_020 * Fplus_dV_c_011 = ofLadj CW_031_1_pre CW_031_1_pim := by
  rw [CW_1_c_020_def, Fplus_dV_c_011_def, ofLadj_mul, CW_031_1_pre_eq, CW_031_1_pim_eq]

def CW_031_2_pre : Polynomial ℚ := C ((773365997200 / 2879985977 : ℚ)) + C ((29100983552 / 8639957931 : ℚ)) * X + C ((3226136393980 / 8639957931 : ℚ)) * X ^ 2 + C ((132278478364 / 261816907 : ℚ)) * X ^ 3 + C ((1484904331780 / 2879985977 : ℚ)) * X ^ 4 + C ((6871782715088 / 8639957931 : ℚ)) * X ^ 5 + C ((2008371309920 / 2879985977 : ℚ)) * X ^ 6 + C ((2992356429444 / 2879985977 : ℚ)) * X ^ 7 + C ((7197124434464 / 8639957931 : ℚ)) * X ^ 8 + C ((7149080924464 / 8639957931 : ℚ)) * X ^ 9 + C ((6141193365248 / 8639957931 : ℚ)) * X ^ 10 + C ((5080065046184 / 8639957931 : ℚ)) * X ^ 11 + C ((2037364127232 / 2879985977 : ℚ)) * X ^ 12 + C ((1307648176828 / 2879985977 : ℚ)) * X ^ 13 + C ((2831934648452 / 8639957931 : ℚ)) * X ^ 14 + C ((3790422202808 / 8639957931 : ℚ)) * X ^ 15 + C ((798082150684 / 8639957931 : ℚ)) * X ^ 16 + C ((548250312004 / 2879985977 : ℚ)) * X ^ 17 + C ((-66539462744 / 785450721 : ℚ)) * X ^ 18
def CW_031_2_pim : Polynomial ℚ := C ((549104702876 / 8639957931 : ℚ)) + C ((1098209405752 / 8639957931 : ℚ)) * X + C ((-1801716284900 / 8639957931 : ℚ)) * X ^ 2 + C ((2028521511604 / 8639957931 : ℚ)) * X ^ 3 + C ((32944273564 / 8639957931 : ℚ)) * X ^ 4 + C ((867238803656 / 2879985977 : ℚ)) * X ^ 5 + C ((2412604016156 / 8639957931 : ℚ)) * X ^ 6 + C ((4338779544236 / 8639957931 : ℚ)) * X ^ 7 + C ((6116995819448 / 8639957931 : ℚ)) * X ^ 8 + C ((2196547788128 / 2879985977 : ℚ)) * X ^ 9 + C ((5537466539804 / 8639957931 : ℚ)) * X ^ 10 + C ((5015088701944 / 8639957931 : ℚ)) * X ^ 11 + C ((1497570288028 / 2879985977 : ℚ)) * X ^ 12 + C ((6340459730156 / 8639957931 : ℚ)) * X ^ 13 + C ((994289826196 / 2879985977 : ℚ)) * X ^ 14 + C ((1563824103144 / 2879985977 : ℚ)) * X ^ 15 + C ((3501801799768 / 8639957931 : ℚ)) * X ^ 16 + C ((870754860916 / 2879985977 : ℚ)) * X ^ 17 + C ((688396894136 / 2879985977 : ℚ)) * X ^ 18
theorem CW_031_2_pre_eq :
    CW_2_re_020 * Fplus_dW_re_011 - CW_2_im_020 * Fplus_dW_im_011 = CW_031_2_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_2_re_020_def, CW_2_im_020_def, Fplus_dW_re_011_def, Fplus_dW_im_011_def, CW_031_2_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CW_031_2_pim_eq :
    CW_2_re_020 * Fplus_dW_im_011 + CW_2_im_020 * Fplus_dW_re_011 = CW_031_2_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_2_re_020_def, CW_2_im_020_def, Fplus_dW_re_011_def, Fplus_dW_im_011_def, CW_031_2_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CW_031_2_mul :
    CW_2_c_020 * Fplus_dW_c_011 = ofLadj CW_031_2_pre CW_031_2_pim := by
  rw [CW_2_c_020_def, Fplus_dW_c_011_def, ofLadj_mul, CW_031_2_pre_eq, CW_031_2_pim_eq]

theorem CW_031_3_mul : CW_3_c_030 = ofLadj CW_3_re_030 CW_3_im_030 := CW_3_c_030_def

@[expose] public def CW_coeff_031 : Ki := CW_0_c_020 * Fplus_dU_c_011 + CW_1_c_020 * Fplus_dV_c_011 + CW_2_c_020 * Fplus_dW_c_011 + CW_3_c_030

theorem CW_coeff_031_sum :
    CW_coeff_031 = ofLadj (CW_031_0_pre + CW_031_1_pre + CW_031_2_pre + CW_3_re_030) (CW_031_0_pim + CW_031_1_pim + CW_031_2_pim + CW_3_im_030) := by
  simp only [CW_coeff_031, CW_031_0_mul, CW_031_1_mul, CW_031_2_mul, CW_031_3_mul]
  simpa [add_assoc] using ofLadj_add4 CW_031_0_pre CW_031_0_pim CW_031_1_pre CW_031_1_pim CW_031_2_pre CW_031_2_pim CW_3_re_030 CW_3_im_030

def CW_031_qre : Polynomial ℚ := C ((2591602230500 / 8639957931 : ℚ)) + C ((-3956982717236 / 8639957931 : ℚ)) * X + C ((2230468236016 / 8639957931 : ℚ)) * X ^ 2 + C ((4986463684132 / 8639957931 : ℚ)) * X ^ 3 + C ((-597196867360 / 8639957931 : ℚ)) * X ^ 4 + C ((-312240324736 / 2879985977 : ℚ)) * X ^ 5 + C ((5853778518392 / 8639957931 : ℚ)) * X ^ 6 + C ((-479741244068 / 8639957931 : ℚ)) * X ^ 7 + C ((-3245805571168 / 8639957931 : ℚ)) * X ^ 8
def CW_031_qim : Polynomial ℚ := C ((1256002385584 / 8639957931 : ℚ)) + C ((1256002385584 / 8639957931 : ℚ)) * X + C ((-1555141573516 / 2879985977 : ℚ)) * X ^ 2 + C ((2161322854348 / 8639957931 : ℚ)) * X ^ 3 + C ((4367962800596 / 8639957931 : ℚ)) * X ^ 4 + C ((-1121045717644 / 8639957931 : ℚ)) * X ^ 5 + C ((1478141098880 / 8639957931 : ℚ)) * X ^ 6 + C ((2286731389656 / 2879985977 : ℚ)) * X ^ 7 + C ((1512711411124 / 8639957931 : ℚ)) * X ^ 8
theorem CW_coeff_031_poly_re :
    CW_031_0_pre + CW_031_1_pre + CW_031_2_pre + CW_3_re_030 = (0 : Polynomial ℚ) + Phi11 * CW_031_qre := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [CW_031_0_pre, CW_031_1_pre, CW_031_2_pre, CW_3_re_030_def, CW_031_qre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try grind
theorem CW_coeff_031_poly_im :
    CW_031_0_pim + CW_031_1_pim + CW_031_2_pim + CW_3_im_030 = (0 : Polynomial ℚ) + Phi11 * CW_031_qim := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [CW_031_0_pim, CW_031_1_pim, CW_031_2_pim, CW_3_im_030_def, CW_031_qim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try grind
public theorem CW_coeff_031_eq :
    CW_coeff_031 = (0 : Ki) := by
  rw [CW_coeff_031_sum, CW_coeff_031_poly_re,
    CW_coeff_031_poly_im, ofLadj_add_Phi11]
  exact ofLadj_zero

end V14Formalization.D12SigmaPlusSegreCore
