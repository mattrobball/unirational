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

def CU_002_0_pre : Polynomial ℚ := C ((-646362759319 / 235794999 : ℚ)) + C ((-9112240037908 / 235794999 : ℚ)) * X + C ((-18269361732289 / 235794999 : ℚ)) * X ^ 2 + C ((-30358707705439 / 235794999 : ℚ)) * X ^ 3 + C ((-15235816837528 / 78598333 : ℚ)) * X ^ 4 + C ((-18319163955641 / 78598333 : ℚ)) * X ^ 5 + C ((-64222246824125 / 235794999 : ℚ)) * X ^ 6 + C ((-69825751731434 / 235794999 : ℚ)) * X ^ 7 + C ((-68407231446524 / 235794999 : ℚ)) * X ^ 8 + C ((-69359499999239 / 235794999 : ℚ)) * X ^ 9 + C ((-70049710887883 / 235794999 : ℚ)) * X ^ 10 + C ((-69656062719580 / 235794999 : ℚ)) * X ^ 11 + C ((-20312490283325 / 78598333 : ℚ)) * X ^ 12 + C ((-51090138266950 / 235794999 : ℚ)) * X ^ 13 + C ((-3458956703735 / 21435909 : ℚ)) * X ^ 14 + C ((-21844419180748 / 235794999 : ℚ)) * X ^ 15 + C ((-12108423352750 / 235794999 : ℚ)) * X ^ 16 + C ((-2843668395548 / 235794999 : ℚ)) * X ^ 17 + C ((2273882038102 / 235794999 : ℚ)) * X ^ 18
def CU_002_0_pim : Polynomial ℚ := C ((6492417526415 / 235794999 : ℚ)) + C ((12984835052830 / 235794999 : ℚ)) * X + C ((16233512545247 / 235794999 : ℚ)) * X ^ 2 + C ((20172191587780 / 235794999 : ℚ)) * X ^ 3 + C ((512906169493 / 7145303 : ℚ)) * X ^ 4 + C ((3449698569708 / 78598333 : ℚ)) * X ^ 5 + C ((4847000980406 / 235794999 : ℚ)) * X ^ 6 + C ((-1806293144335 / 78598333 : ℚ)) * X ^ 7 + C ((-10962418299647 / 235794999 : ℚ)) * X ^ 8 + C ((-11108608055518 / 235794999 : ℚ)) * X ^ 9 + C ((-11738714360840 / 235794999 : ℚ)) * X ^ 10 + C ((-19116165648148 / 235794999 : ℚ)) * X ^ 11 + C ((-802836876832 / 7145303 : ℚ)) * X ^ 12 + C ((-30372400733195 / 235794999 : ℚ)) * X ^ 13 + C ((-11485756510533 / 78598333 : ℚ)) * X ^ 14 + C ((-10265096901394 / 78598333 : ℚ)) * X ^ 15 + C ((-7810914071713 / 78598333 : ℚ)) * X ^ 16 + C ((-5670283572619 / 78598333 : ℚ)) * X ^ 17 + C ((-5959229699548 / 235794999 : ℚ)) * X ^ 18
theorem CU_002_0_pre_eq :
    CU_0_re_000 * Fplus_dU_re_002 - CU_0_im_000 * Fplus_dU_im_002 = CU_002_0_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_0_re_000, CU_0_im_000, Fplus_dU_re_002, Fplus_dU_im_002, CU_002_0_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CU_002_0_pim_eq :
    CU_0_re_000 * Fplus_dU_im_002 + CU_0_im_000 * Fplus_dU_re_002 = CU_002_0_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_0_re_000, CU_0_im_000, Fplus_dU_re_002, Fplus_dU_im_002, CU_002_0_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CU_002_0_mul :
    CU_0_c_000 * Fplus_dU_c_002 = ofLadj CU_002_0_pre CU_002_0_pim := by
  rw [CU_0_c_000, Fplus_dU_c_002, ofLadj_mul, CU_002_0_pre_eq, CU_002_0_pim_eq]

def CU_002_1_pre : Polynomial ℚ := C ((-283969071890 / 235794999 : ℚ)) + C ((6590440943144 / 235794999 : ℚ)) * X + C ((14077497232750 / 235794999 : ℚ)) * X ^ 2 + C ((24042832269383 / 235794999 : ℚ)) * X ^ 3 + C ((12760538093322 / 78598333 : ℚ)) * X ^ 4 + C ((4503724382174 / 21435909 : ℚ)) * X ^ 5 + C ((58331060090645 / 235794999 : ℚ)) * X ^ 6 + C ((60941269358402 / 235794999 : ℚ)) * X ^ 7 + C ((55074128534284 / 235794999 : ℚ)) * X ^ 8 + C ((50951601363535 / 235794999 : ℚ)) * X ^ 9 + C ((47796282950056 / 235794999 : ℚ)) * X ^ 10 + C ((46906052422952 / 235794999 : ℚ)) * X ^ 11 + C ((3745985636992 / 21435909 : ℚ)) * X ^ 12 + C ((12291368043595 / 78598333 : ℚ)) * X ^ 13 + C ((31031296264901 / 235794999 : ℚ)) * X ^ 14 + C ((6861958473933 / 78598333 : ℚ)) * X ^ 15 + C ((1052971625225 / 21435909 : ℚ)) * X ^ 16 + C ((930865330248 / 78598333 : ℚ)) * X ^ 17 + C ((-2073779656637 / 235794999 : ℚ)) * X ^ 18
def CU_002_1_pim : Polynomial ℚ := C ((-2357778590021 / 78598333 : ℚ)) + C ((-4715557180042 / 78598333 : ℚ)) * X + C ((-17543796913891 / 235794999 : ℚ)) * X ^ 2 + C ((-22259329589062 / 235794999 : ℚ)) * X ^ 3 + C ((-21822406875953 / 235794999 : ℚ)) * X ^ 4 + C ((-5127927676693 / 78598333 : ℚ)) * X ^ 5 + C ((-2169416326005 / 78598333 : ℚ)) * X ^ 6 + C ((1903903399643 / 78598333 : ℚ)) * X ^ 7 + C ((4153877507199 / 78598333 : ℚ)) * X ^ 8 + C ((11870937727334 / 235794999 : ℚ)) * X ^ 9 + C ((831061175116 / 21435909 : ℚ)) * X ^ 10 + C ((4071015634520 / 78598333 : ℚ)) * X ^ 11 + C ((15284420880844 / 235794999 : ℚ)) * X ^ 12 + C ((15952281453551 / 235794999 : ℚ)) * X ^ 13 + C ((1825192666769 / 21435909 : ℚ)) * X ^ 14 + C ((21367258292939 / 235794999 : ℚ)) * X ^ 15 + C ((18438502172599 / 235794999 : ℚ)) * X ^ 16 + C ((13732952102489 / 235794999 : ℚ)) * X ^ 17 + C ((1674286883693 / 78598333 : ℚ)) * X ^ 18
theorem CU_002_1_pre_eq :
    CU_1_re_000 * Fplus_dV_re_002 - CU_1_im_000 * Fplus_dV_im_002 = CU_002_1_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_1_re_000, CU_1_im_000, Fplus_dV_re_002, Fplus_dV_im_002, CU_002_1_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CU_002_1_pim_eq :
    CU_1_re_000 * Fplus_dV_im_002 + CU_1_im_000 * Fplus_dV_re_002 = CU_002_1_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_1_re_000, CU_1_im_000, Fplus_dV_re_002, Fplus_dV_im_002, CU_002_1_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CU_002_1_mul :
    CU_1_c_000 * Fplus_dV_c_002 = ofLadj CU_002_1_pre CU_002_1_pim := by
  rw [CU_1_c_000, Fplus_dV_c_002, ofLadj_mul, CU_002_1_pre_eq, CU_002_1_pim_eq]

def CU_002_2_pre : Polynomial ℚ := C ((-784940368626 / 78598333 : ℚ)) + C ((2101884632055 / 78598333 : ℚ)) * X ^ 2 + C ((4841043506575 / 78598333 : ℚ)) * X ^ 3 + C ((7363818112932 / 78598333 : ℚ)) * X ^ 4 + C ((8869723586243 / 78598333 : ℚ)) * X ^ 5 + C ((8869723586243 / 78598333 : ℚ)) * X ^ 6 + C ((7363818112932 / 78598333 : ℚ)) * X ^ 7 + C ((4841043506575 / 78598333 : ℚ)) * X ^ 8 + C ((2101884632055 / 78598333 : ℚ)) * X ^ 9
def CU_002_2_pim : Polynomial ℚ := C ((-2666089180664 / 78598333 : ℚ)) + C ((-5332178361328 / 78598333 : ℚ)) * X + C ((-7144331141436 / 78598333 : ℚ)) * X ^ 2 + C ((-685041825406 / 7145303 : ℚ)) * X ^ 3 + C ((-6390494397423 / 78598333 : ℚ)) * X ^ 4 + C ((-4055740688063 / 78598333 : ℚ)) * X ^ 5 + C ((-1276437673265 / 78598333 : ℚ)) * X ^ 6 + C ((1058316036095 / 78598333 : ℚ)) * X ^ 7 + C ((2203281718138 / 78598333 : ℚ)) * X ^ 8 + C ((164741161828 / 7145303 : ℚ)) * X ^ 9
theorem CU_002_2_pre_eq :
    CU_2_re_000 * Fplus_dW_re_002 - CU_2_im_000 * Fplus_dW_im_002 = CU_002_2_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_2_re_000, CU_2_im_000, Fplus_dW_re_002, Fplus_dW_im_002, CU_002_2_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CU_002_2_pim_eq :
    CU_2_re_000 * Fplus_dW_im_002 + CU_2_im_000 * Fplus_dW_re_002 = CU_002_2_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_2_re_000, CU_2_im_000, Fplus_dW_re_002, Fplus_dW_im_002, CU_002_2_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CU_002_2_mul :
    CU_2_c_000 * Fplus_dW_c_002 = ofLadj CU_002_2_pre CU_002_2_pim := by
  rw [CU_2_c_000, Fplus_dW_c_002, ofLadj_mul, CU_002_2_pre_eq, CU_002_2_pim_eq]

def CU_002_3_pre : Polynomial ℚ := C ((343794117808 / 21435909 : ℚ)) + C ((-922834836208 / 21435909 : ℚ)) * X ^ 2 + C ((-2131223231392 / 21435909 : ℚ)) * X ^ 3 + C ((-3241863844096 / 21435909 : ℚ)) * X ^ 4 + C ((-3901849050752 / 21435909 : ℚ)) * X ^ 5 + C ((-3901849050752 / 21435909 : ℚ)) * X ^ 6 + C ((-3241863844096 / 21435909 : ℚ)) * X ^ 7 + C ((-2131223231392 / 21435909 : ℚ)) * X ^ 8 + C ((-922834836208 / 21435909 : ℚ)) * X ^ 9
def CU_002_3_pim : Polynomial ℚ := C ((12885263095664 / 235794999 : ℚ)) + C ((25770526191328 / 235794999 : ℚ)) * X + C ((34566355638032 / 235794999 : ℚ)) * X ^ 2 + C ((36476627002256 / 235794999 : ℚ)) * X ^ 3 + C ((10299659150544 / 78598333 : ℚ)) * X ^ 4 + C ((19599107993120 / 235794999 : ℚ)) * X ^ 5 + C ((6171418198208 / 235794999 : ℚ)) * X ^ 6 + C ((-5128451260304 / 235794999 : ℚ)) * X ^ 7 + C ((-10706100810928 / 235794999 : ℚ)) * X ^ 8 + C ((-8795829446704 / 235794999 : ℚ)) * X ^ 9
theorem CU_002_3_neg_re : -CU_3_re_002 = CU_002_3_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_3_re_002, CU_002_3_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CU_002_3_neg_im : -CU_3_im_002 = CU_002_3_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_3_im_002, CU_002_3_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CU_002_3_mul : -CU_3_c_002 = ofLadj CU_002_3_pre CU_002_3_pim := by
  rw [CU_3_c_002, ofLadj_neg, CU_002_3_neg_re, CU_002_3_neg_im]

@[expose] public def CU_coeff_002 : Ki := CU_0_c_000 * Fplus_dU_c_002 + CU_1_c_000 * Fplus_dV_c_002 + CU_2_c_000 * Fplus_dW_c_002 + (-CU_3_c_002)

theorem CU_coeff_002_sum :
    CU_coeff_002 = ofLadj (CU_002_0_pre + CU_002_1_pre + CU_002_2_pre + CU_002_3_pre) (CU_002_0_pim + CU_002_1_pim + CU_002_2_pim + CU_002_3_pim) := by
  simp only [CU_coeff_002, CU_002_0_mul, CU_002_1_mul, CU_002_2_mul, CU_002_3_mul]
  simpa [add_assoc] using ofLadj_add4 CU_002_0_pre CU_002_0_pim CU_002_1_pre CU_002_1_pim CU_002_2_pre CU_002_2_pim CU_002_3_pre CU_002_3_pim

def CU_002_qre : Polynomial ℚ := C ((496582358801 / 235794999 : ℚ)) + C ((-3018381453565 / 235794999 : ℚ)) * X + C ((-1838531568966 / 78598333 : ℚ)) * X ^ 2 + C ((-7198806659981 / 235794999 : ℚ)) * X ^ 3 + C ((-5758683717235 / 235794999 : ℚ)) * X ^ 4 + C ((-732808283674 / 235794999 : ℚ)) * X ^ 5 + C ((-474663070471 / 235794999 : ℚ)) * X ^ 6 + C ((-22834071479 / 21435909 : ℚ)) * X ^ 7 + C ((200102381465 / 235794999 : ℚ)) * X ^ 8
def CU_002_qim : Polynomial ℚ := C ((4306077310024 / 235794999 : ℚ)) + C ((4306077310024 / 235794999 : ℚ)) * X + C ((3210923225032 / 235794999 : ℚ)) * X ^ 2 + C ((-39969082504 / 235794999 : ℚ)) * X ^ 3 + C ((-4952117785897 / 235794999 : ℚ)) * X ^ 4 + C ((-4433792368703 / 235794999 : ℚ)) * X ^ 5 + C ((-1716341427172 / 235794999 : ℚ)) * X ^ 6 + C ((-780509855633 / 78598333 : ℚ)) * X ^ 7 + C ((-936369048469 / 235794999 : ℚ)) * X ^ 8
theorem CU_coeff_002_poly_re :
    CU_002_0_pre + CU_002_1_pre + CU_002_2_pre + CU_002_3_pre = (0 : Polynomial ℚ) + Phi11 * CU_002_qre := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [CU_002_0_pre, CU_002_1_pre, CU_002_2_pre, CU_002_3_pre, CU_002_qre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try grind
theorem CU_coeff_002_poly_im :
    CU_002_0_pim + CU_002_1_pim + CU_002_2_pim + CU_002_3_pim = (0 : Polynomial ℚ) + Phi11 * CU_002_qim := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [CU_002_0_pim, CU_002_1_pim, CU_002_2_pim, CU_002_3_pim, CU_002_qim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try grind
public theorem CU_coeff_002_eq :
    CU_coeff_002 = (0 : Ki) := by
  rw [CU_coeff_002_sum, CU_coeff_002_poly_re,
    CU_coeff_002_poly_im, ofLadj_add_Phi11]
  exact ofLadj_zero

end V14Formalization.D12SigmaPlusSegreCore
