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

def CU_003_0_pre : Polynomial ℚ := C ((136581799300856 / 235794999 : ℚ)) + C ((2227842562057952 / 235794999 : ℚ)) * X + C ((4447848059259520 / 235794999 : ℚ)) * X ^ 2 + C ((2407992536904740 / 78598333 : ℚ)) * X ^ 3 + C ((10975955448106828 / 235794999 : ℚ)) * X ^ 4 + C ((13267772483863006 / 235794999 : ℚ)) * X ^ 5 + C ((15360897474816748 / 235794999 : ℚ)) * X ^ 6 + C ((16753705900030372 / 235794999 : ℚ)) * X ^ 7 + C ((5490633855361046 / 78598333 : ℚ)) * X ^ 8 + C ((505851622294030 / 7145303 : ℚ)) * X ^ 9 + C ((16861922623893902 / 235794999 : ℚ)) * X ^ 10 + C ((16788267263393632 / 235794999 : ℚ)) * X ^ 11 + C ((4878026687278650 / 78598333 : ℚ)) * X ^ 12 + C ((12245255476443470 / 235794999 : ℚ)) * X ^ 13 + C ((3082641318456306 / 78598333 : ℚ)) * X ^ 14 + C ((1764234733580524 / 78598333 : ℚ)) * X ^ 15 + C ((960044405583820 / 78598333 : ℚ)) * X ^ 16 + C ((262336075265906 / 78598333 : ℚ)) * X ^ 17 + C ((-161682083727324 / 78598333 : ℚ)) * X ^ 18
def CU_003_0_pim : Polynomial ℚ := C ((-531888388217360 / 78598333 : ℚ)) + C ((-1063776776434720 / 78598333 : ℚ)) * X + C ((-1296882345847556 / 78598333 : ℚ)) * X ^ 2 + C ((-4859666692975240 / 235794999 : ℚ)) * X ^ 3 + C ((-4219891972262696 / 235794999 : ℚ)) * X ^ 4 + C ((-2539574063329174 / 235794999 : ℚ)) * X ^ 5 + C ((-37512468692812 / 7145303 : ℚ)) * X ^ 6 + C ((1106188922906024 / 235794999 : ℚ)) * X ^ 7 + C ((2458920311297974 / 235794999 : ℚ)) * X ^ 8 + C ((2490744600860306 / 235794999 : ℚ)) * X ^ 9 + C ((2637088771718834 / 235794999 : ℚ)) * X ^ 10 + C ((1482367984790720 / 78598333 : ℚ)) * X ^ 11 + C ((6257119137025486 / 235794999 : ℚ)) * X ^ 12 + C ((7102780016122522 / 235794999 : ℚ)) * X ^ 13 + C ((2701207987039142 / 78598333 : ℚ)) * X ^ 14 + C ((7370980687577260 / 235794999 : ℚ)) * X ^ 15 + C ((5502711109408844 / 235794999 : ℚ)) * X ^ 16 + C ((361604727293026 / 21435909 : ℚ)) * X ^ 17 + C ((1445599941219572 / 235794999 : ℚ)) * X ^ 18
theorem CU_003_0_pre_eq :
    CU_0_re_001 * Fplus_dU_re_002 - CU_0_im_001 * Fplus_dU_im_002 = CU_003_0_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_0_re_001, CU_0_im_001, Fplus_dU_re_002, Fplus_dU_im_002, CU_003_0_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CU_003_0_pim_eq :
    CU_0_re_001 * Fplus_dU_im_002 + CU_0_im_001 * Fplus_dU_re_002 = CU_003_0_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_0_re_001, CU_0_im_001, Fplus_dU_re_002, Fplus_dU_im_002, CU_003_0_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CU_003_0_mul :
    CU_0_c_001 * Fplus_dU_c_002 = ofLadj CU_003_0_pre CU_003_0_pim := by
  rw [CU_0_c_001, Fplus_dU_c_002, ofLadj_mul, CU_003_0_pre_eq, CU_003_0_pim_eq]

def CU_003_1_pre : Polynomial ℚ := C ((-3162356282288 / 78598333 : ℚ)) + C ((72439332705408 / 78598333 : ℚ)) * X + C ((3834132125336 / 1948719 : ℚ)) * X ^ 2 + C ((792777512924450 / 235794999 : ℚ)) * X ^ 3 + C ((1262283874507966 / 235794999 : ℚ)) * X ^ 4 + C ((1633271307692194 / 235794999 : ℚ)) * X ^ 5 + C ((1923511167334940 / 235794999 : ℚ)) * X ^ 6 + C ((2009411783502128 / 235794999 : ℚ)) * X ^ 7 + C ((1815881739359786 / 235794999 : ℚ)) * X ^ 8 + C ((559922140414322 / 78598333 : ℚ)) * X ^ 9 + C ((143259818257342 / 21435909 : ℚ)) * X ^ 10 + C ((140600531343148 / 21435909 : ℚ)) * X ^ 11 + C ((1358540002714538 / 235794999 : ℚ)) * X ^ 12 + C ((1215836434077310 / 235794999 : ℚ)) * X ^ 13 + C ((341034742145112 / 78598333 : ℚ)) * X ^ 14 + C ((678674962635838 / 235794999 : ℚ)) * X ^ 15 + C ((382022438727262 / 235794999 : ℚ)) * X ^ 16 + C ((30594193028172 / 78598333 : ℚ)) * X ^ 17 + C ((-2074331707828 / 7145303 : ℚ)) * X ^ 18
def CU_003_1_pim : Polynomial ℚ := C ((-77757380070068 / 78598333 : ℚ)) + C ((-155514760140136 / 78598333 : ℚ)) * X + C ((-578544947491052 / 235794999 : ℚ)) * X ^ 2 + C ((-734339678342386 / 235794999 : ℚ)) * X ^ 3 + C ((-719482007020330 / 235794999 : ℚ)) * X ^ 4 + C ((-507528231615818 / 235794999 : ℚ)) * X ^ 5 + C ((-19532156003524 / 21435909 : ℚ)) * X ^ 6 + C ((188272699699792 / 235794999 : ℚ)) * X ^ 7 + C ((136951376579414 / 78598333 : ℚ)) * X ^ 8 + C ((391278734340062 / 235794999 : ℚ)) * X ^ 9 + C ((301229234008594 / 235794999 : ℚ)) * X ^ 10 + C ((134190354241748 / 78598333 : ℚ)) * X ^ 11 + C ((45810262858354 / 21435909 : ℚ)) * X ^ 12 + C ((175288019393690 / 78598333 : ℚ)) * X ^ 13 + C ((662083393634224 / 235794999 : ℚ)) * X ^ 14 + C ((64032683343050 / 21435909 : ℚ)) * X ^ 15 + C ((202692081377278 / 78598333 : ℚ)) * X ^ 16 + C ((452903548552828 / 235794999 : ℚ)) * X ^ 17 + C ((165447635577068 / 235794999 : ℚ)) * X ^ 18
theorem CU_003_1_pre_eq :
    CU_1_re_001 * Fplus_dV_re_002 - CU_1_im_001 * Fplus_dV_im_002 = CU_003_1_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_1_re_001, CU_1_im_001, Fplus_dV_re_002, Fplus_dV_im_002, CU_003_1_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CU_003_1_pim_eq :
    CU_1_re_001 * Fplus_dV_im_002 + CU_1_im_001 * Fplus_dV_re_002 = CU_003_1_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_1_re_001, CU_1_im_001, Fplus_dV_re_002, Fplus_dV_im_002, CU_003_1_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CU_003_1_mul :
    CU_1_c_001 * Fplus_dV_c_002 = ofLadj CU_003_1_pre CU_003_1_pim := by
  rw [CU_1_c_001, Fplus_dV_c_002, ofLadj_mul, CU_003_1_pre_eq, CU_003_1_pim_eq]

def CU_003_2_pre : Polynomial ℚ := C ((-4218963578300 / 78598333 : ℚ)) + C ((11322084027468 / 78598333 : ℚ)) * X ^ 2 + C ((26176304391364 / 78598333 : ℚ)) * X ^ 3 + C ((39816492602164 / 78598333 : ℚ)) * X ^ 4 + C ((47912370213506 / 78598333 : ℚ)) * X ^ 5 + C ((47912370213506 / 78598333 : ℚ)) * X ^ 6 + C ((39816492602164 / 78598333 : ℚ)) * X ^ 7 + C ((26176304391364 / 78598333 : ℚ)) * X ^ 8 + C ((11322084027468 / 78598333 : ℚ)) * X ^ 9
def CU_003_2_pim : Polynomial ℚ := C ((-14379410288484 / 78598333 : ℚ)) + C ((-28758820576968 / 78598333 : ℚ)) * X + C ((-38585858710900 / 78598333 : ℚ)) * X ^ 2 + C ((-40726727323116 / 78598333 : ℚ)) * X ^ 3 + C ((-34484041043900 / 78598333 : ℚ)) * X ^ 4 + C ((-21872261992326 / 78598333 : ℚ)) * X ^ 5 + C ((-626050780422 / 7145303 : ℚ)) * X ^ 6 + C ((5725220466932 / 78598333 : ℚ)) * X ^ 7 + C ((11967906746148 / 78598333 : ℚ)) * X ^ 8 + C ((9827038133932 / 78598333 : ℚ)) * X ^ 9
theorem CU_003_2_pre_eq :
    CU_2_re_001 * Fplus_dW_re_002 - CU_2_im_001 * Fplus_dW_im_002 = CU_003_2_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_2_re_001, CU_2_im_001, Fplus_dW_re_002, Fplus_dW_im_002, CU_003_2_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CU_003_2_pim_eq :
    CU_2_re_001 * Fplus_dW_im_002 + CU_2_im_001 * Fplus_dW_re_002 = CU_003_2_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_2_re_001, CU_2_im_001, Fplus_dW_re_002, Fplus_dW_im_002, CU_003_2_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CU_003_2_mul :
    CU_2_c_001 * Fplus_dW_c_002 = ofLadj CU_003_2_pre CU_003_2_pim := by
  rw [CU_2_c_001, Fplus_dW_c_002, ofLadj_mul, CU_003_2_pre_eq, CU_003_2_pim_eq]

def CU_003_3_pre : Polynomial ℚ := C ((-1048211196608 / 21435909 : ℚ)) + C ((2813128699664 / 21435909 : ℚ)) * X ^ 2 + C ((6497127827968 / 21435909 : ℚ)) * X ^ 3 + C ((9882969175088 / 21435909 : ℚ)) * X ^ 4 + C ((11894915186384 / 21435909 : ℚ)) * X ^ 5 + C ((11894915186384 / 21435909 : ℚ)) * X ^ 6 + C ((9882969175088 / 21435909 : ℚ)) * X ^ 7 + C ((6497127827968 / 21435909 : ℚ)) * X ^ 8 + C ((2813128699664 / 21435909 : ℚ)) * X ^ 9
def CU_003_3_pim : Polynomial ℚ := C ((-13093825214080 / 78598333 : ℚ)) + C ((-26187650428160 / 78598333 : ℚ)) * X + C ((-105376507409744 / 235794999 : ℚ)) * X ^ 2 + C ((-111202795737248 / 235794999 : ℚ)) * X ^ 3 + C ((-94196096208656 / 235794999 : ℚ)) * X ^ 4 + C ((-59750266891280 / 235794999 : ℚ)) * X ^ 5 + C ((-18812684393200 / 235794999 : ℚ)) * X ^ 6 + C ((15633144924176 / 235794999 : ℚ)) * X ^ 7 + C ((32639844452768 / 235794999 : ℚ)) * X ^ 8 + C ((26813556125264 / 235794999 : ℚ)) * X ^ 9
theorem CU_003_3_neg_re : -CU_3_re_003 = CU_003_3_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_3_re_003, CU_003_3_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CU_003_3_neg_im : -CU_3_im_003 = CU_003_3_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_3_im_003, CU_003_3_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CU_003_3_mul : -CU_3_c_003 = ofLadj CU_003_3_pre CU_003_3_pim := by
  rw [CU_3_c_003, ofLadj_neg, CU_003_3_neg_re, CU_003_3_neg_im]

@[expose] public def CU_coeff_003 : Ki := CU_0_c_001 * Fplus_dU_c_002 + CU_1_c_001 * Fplus_dV_c_002 + CU_2_c_001 * Fplus_dW_c_002 + (-CU_3_c_003)

theorem CU_coeff_003_sum :
    CU_coeff_003 = ofLadj (CU_003_0_pre + CU_003_1_pre + CU_003_2_pre + CU_003_3_pre) (CU_003_0_pim + CU_003_1_pim + CU_003_2_pim + CU_003_3_pim) := by
  simp only [CU_coeff_003, CU_003_0_mul, CU_003_1_mul, CU_003_2_mul, CU_003_3_mul]
  simpa [add_assoc] using ofLadj_add4 CU_003_0_pre CU_003_0_pim CU_003_1_pre CU_003_1_pim CU_003_2_pre CU_003_2_pim CU_003_3_pre CU_003_3_pim

def CU_003_qre : Polynomial ℚ := C ((102907516556404 / 235794999 : ℚ)) + C ((2342253043617772 / 235794999 : ℚ)) * X + C ((2531528154029708 / 235794999 : ℚ)) * X ^ 2 + C ((1063354576238842 / 78598333 : ℚ)) * X ^ 3 + C ((4299649018426844 / 235794999 : ℚ)) * X ^ 4 + C ((82097682057536 / 7145303 : ℚ)) * X ^ 5 + C ((216669531872408 / 21435909 : ℚ)) * X ^ 6 + C ((477430000807510 / 78598333 : ℚ)) * X ^ 7 + C ((-184499732513432 / 78598333 : ℚ)) * X ^ 8
def CU_003_qim : Polynomial ℚ := C ((-637119003789992 / 78598333 : ℚ)) + C ((-637119003789992 / 78598333 : ℚ)) * X + C ((-867612045836212 / 235794999 : ℚ)) * X ^ 2 + C ((-379021093482686 / 78598333 : ℚ)) * X ^ 3 + C ((62760650036440 / 21435909 : ℚ)) * X ^ 4 + C ((59531904570004 / 7145303 : ℚ)) * X ^ 5 + C ((1680231804764564 / 235794999 : ℚ)) * X ^ 6 + C ((2819507971979474 / 235794999 : ℚ)) * X ^ 7 + C ((1611047576796640 / 235794999 : ℚ)) * X ^ 8
theorem CU_coeff_003_poly_re :
    CU_003_0_pre + CU_003_1_pre + CU_003_2_pre + CU_003_3_pre = (0 : Polynomial ℚ) + Phi11 * CU_003_qre := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [CU_003_0_pre, CU_003_1_pre, CU_003_2_pre, CU_003_3_pre, CU_003_qre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try grind
theorem CU_coeff_003_poly_im :
    CU_003_0_pim + CU_003_1_pim + CU_003_2_pim + CU_003_3_pim = (0 : Polynomial ℚ) + Phi11 * CU_003_qim := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [CU_003_0_pim, CU_003_1_pim, CU_003_2_pim, CU_003_3_pim, CU_003_qim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try grind
public theorem CU_coeff_003_eq :
    CU_coeff_003 = (0 : Ki) := by
  rw [CU_coeff_003_sum, CU_coeff_003_poly_re,
    CU_coeff_003_poly_im, ofLadj_add_Phi11]
  exact ofLadj_zero

end V14Formalization.D12SigmaPlusSegreCore
