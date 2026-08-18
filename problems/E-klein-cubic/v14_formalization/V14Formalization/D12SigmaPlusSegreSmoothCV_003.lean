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

def CV_003_0_pre : Polynomial ℚ := C ((85681098936364 / 8639957931 : ℚ)) + C ((1388934059702560 / 8639957931 : ℚ)) * X + C ((2773863750783203 / 8639957931 : ℚ)) * X ^ 2 + C ((1501334962558336 / 2879985977 : ℚ)) * X ^ 3 + C ((6843313177773706 / 8639957931 : ℚ)) * X ^ 4 + C ((8272167290272001 / 8639957931 : ℚ)) * X ^ 5 + C ((9576885585855637 / 8639957931 : ℚ)) * X ^ 6 + C ((10445332190772638 / 8639957931 : ℚ)) * X ^ 7 + C ((10270310696278409 / 8639957931 : ℚ)) * X ^ 8 + C ((10408451320538393 / 8639957931 : ℚ)) * X ^ 9 + C ((10513403050455683 / 8639957931 : ℚ)) * X ^ 10 + C ((3489103524792368 / 2879985977 : ℚ)) * X ^ 11 + C ((9124468990753123 / 8639957931 : ℚ)) * X ^ 12 + C ((231351138477430 / 261816907 : ℚ)) * X ^ 13 + C ((5766305808603401 / 8639957931 : ℚ)) * X ^ 14 + C ((1100170332029510 / 2879985977 : ℚ)) * X ^ 15 + C ((598768506051480 / 2879985977 : ℚ)) * X ^ 16 + C ((491587222570804 / 8639957931 : ℚ)) * X ^ 17 + C ((-301508016910402 / 8639957931 : ℚ)) * X ^ 18
def CV_003_0_pim : Polynomial ℚ := C ((-994601009677634 / 8639957931 : ℚ)) + C ((-1989202019355268 / 8639957931 : ℚ)) * X + C ((-808254774783543 / 2879985977 : ℚ)) * X ^ 2 + C ((-1009554833587746 / 2879985977 : ℚ)) * X ^ 3 + C ((-876585736605596 / 2879985977 : ℚ)) * X ^ 4 + C ((-1582740334730312 / 8639957931 : ℚ)) * X ^ 5 + C ((-256789209653695 / 2879985977 : ℚ)) * X ^ 6 + C ((689946194865998 / 8639957931 : ℚ)) * X ^ 7 + C ((1534208611745617 / 8639957931 : ℚ)) * X ^ 8 + C ((1553824033679692 / 8639957931 : ℚ)) * X ^ 9 + C ((13596454474967 / 71404611 : ℚ)) * X ^ 10 + C ((2773353869439400 / 8639957931 : ℚ)) * X ^ 11 + C ((1300512249135931 / 2879985977 : ℚ)) * X ^ 12 + C ((1476148670064823 / 2879985977 : ℚ)) * X ^ 13 + C ((1683987202847051 / 2879985977 : ℚ)) * X ^ 14 + C ((37978853177402 / 71404611 : ℚ)) * X ^ 15 + C ((38550129339770 / 97078179 : ℚ)) * X ^ 16 + C ((2479652171975399 / 8639957931 : ℚ)) * X ^ 17 + C ((300625166669560 / 2879985977 : ℚ)) * X ^ 18
theorem CV_003_0_pre_eq :
    CV_0_re_001 * Fplus_dU_re_002 - CV_0_im_001 * Fplus_dU_im_002 = CV_003_0_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_0_re_001_def, CV_0_im_001_def, Fplus_dU_re_002_def, Fplus_dU_im_002_def, CV_003_0_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CV_003_0_pim_eq :
    CV_0_re_001 * Fplus_dU_im_002 + CV_0_im_001 * Fplus_dU_re_002 = CV_003_0_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_0_re_001_def, CV_0_im_001_def, Fplus_dU_re_002_def, Fplus_dU_im_002_def, CV_003_0_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CV_003_0_mul :
    CV_0_c_001 * Fplus_dU_c_002 = ofLadj CV_003_0_pre CV_003_0_pim := by
  rw [CV_0_c_001_def, Fplus_dU_c_002_def, ofLadj_mul, CV_003_0_pre_eq, CV_003_0_pim_eq]

def CV_003_1_pre : Polynomial ℚ := C ((-26749673110 / 32359393 : ℚ)) + C ((155812553581304 / 8639957931 : ℚ)) * X + C ((110780782262373 / 2879985977 : ℚ)) * X ^ 2 + C ((568299097404949 / 8639957931 : ℚ)) * X ^ 3 + C ((301654706049006 / 2879985977 : ℚ)) * X ^ 4 + C ((390361670216704 / 2879985977 : ℚ)) * X ^ 5 + C ((1379184821930119 / 8639957931 : ℚ)) * X ^ 6 + C ((43659266458692 / 261816907 : ℚ)) * X ^ 7 + C ((433943968382814 / 2879985977 : ℚ)) * X ^ 8 + C ((1204133347623895 / 8639957931 : ℚ)) * X ^ 9 + C ((1129638469624480 / 8639957931 : ℚ)) * X ^ 10 + C ((100807722156932 / 785450721 : ℚ)) * X ^ 11 + C ((973825916043176 / 8639957931 : ℚ)) * X ^ 12 + C ((9795404503784 / 97078179 : ℚ)) * X ^ 13 + C ((733532807743493 / 8639957931 : ℚ)) * X ^ 14 + C ((486515635868602 / 8639957931 : ℚ)) * X ^ 15 + C ((91240800073031 / 2879985977 : ℚ)) * X ^ 16 + C ((65622588939086 / 8639957931 : ℚ)) * X ^ 17 + C ((-49276039121216 / 8639957931 : ℚ)) * X ^ 18
def CV_003_1_pim : Polynomial ℚ := C ((-167336378860228 / 8639957931 : ℚ)) + C ((-334672757720456 / 8639957931 : ℚ)) * X + C ((-138320528430185 / 2879985977 : ℚ)) * X ^ 2 + C ((-526802983763926 / 8639957931 : ℚ)) * X ^ 3 + C ((-516271276658039 / 8639957931 : ℚ)) * X ^ 4 + C ((-364058276895574 / 8639957931 : ℚ)) * X ^ 5 + C ((-51464425409784 / 2879985977 : ℚ)) * X ^ 6 + C ((135063393991682 / 8639957931 : ℚ)) * X ^ 7 + C ((98156547594950 / 2879985977 : ℚ)) * X ^ 8 + C ((93502388082265 / 2879985977 : ℚ)) * X ^ 9 + C ((215890563895430 / 8639957931 : ℚ)) * X ^ 10 + C ((288577784878144 / 8639957931 : ℚ)) * X ^ 11 + C ((10947424420026 / 261816907 : ℚ)) * X ^ 12 + C ((125645744359864 / 2879985977 : ℚ)) * X ^ 13 + C ((474816153014908 / 8639957931 : ℚ)) * X ^ 14 + C ((168402517720849 / 2879985977 : ℚ)) * X ^ 15 + C ((39639220278082 / 785450721 : ℚ)) * X ^ 16 + C ((324902942101856 / 8639957931 : ℚ)) * X ^ 17 + C ((3590398228474 / 261816907 : ℚ)) * X ^ 18
theorem CV_003_1_pre_eq :
    CV_1_re_001 * Fplus_dV_re_002 - CV_1_im_001 * Fplus_dV_im_002 = CV_003_1_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_1_re_001_def, CV_1_im_001_def, Fplus_dV_re_002_def, Fplus_dV_im_002_def, CV_003_1_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CV_003_1_pim_eq :
    CV_1_re_001 * Fplus_dV_im_002 + CV_1_im_001 * Fplus_dV_re_002 = CV_003_1_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_1_re_001_def, CV_1_im_001_def, Fplus_dV_re_002_def, Fplus_dV_im_002_def, CV_003_1_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CV_003_1_mul :
    CV_1_c_001 * Fplus_dV_c_002 = ofLadj CV_003_1_pre CV_003_1_pim := by
  rw [CV_1_c_001_def, Fplus_dV_c_002_def, ofLadj_mul, CV_003_1_pre_eq, CV_003_1_pim_eq]

def CV_003_2_pre : Polynomial ℚ := C ((-4775486438449 / 2879985977 : ℚ)) + C ((12756003554913 / 2879985977 : ℚ)) * X ^ 2 + C ((29502887315008 / 2879985977 : ℚ)) * X ^ 3 + C ((44867438132345 / 2879985977 : ℚ)) * X ^ 4 + C ((54000004698103 / 2879985977 : ℚ)) * X ^ 5 + C ((54000004698103 / 2879985977 : ℚ)) * X ^ 6 + C ((44867438132345 / 2879985977 : ℚ)) * X ^ 7 + C ((29502887315008 / 2879985977 : ℚ)) * X ^ 8 + C ((12756003554913 / 2879985977 : ℚ)) * X ^ 9
def CV_003_2_pim : Polynomial ℚ := C ((-16213717959831 / 2879985977 : ℚ)) + C ((-32427435919662 / 2879985977 : ℚ)) * X + C ((-43494373346848 / 2879985977 : ℚ)) * X ^ 2 + C ((-45913108538364 / 2879985977 : ℚ)) * X ^ 3 + C ((-38869706250975 / 2879985977 : ℚ)) * X ^ 4 + C ((-24669286709799 / 2879985977 : ℚ)) * X ^ 5 + C ((-7758149209863 / 2879985977 : ℚ)) * X ^ 6 + C ((6442270331313 / 2879985977 : ℚ)) * X ^ 7 + C ((13485672618702 / 2879985977 : ℚ)) * X ^ 8 + C ((11066937427186 / 2879985977 : ℚ)) * X ^ 9
theorem CV_003_2_pre_eq :
    CV_2_re_001 * Fplus_dW_re_002 - CV_2_im_001 * Fplus_dW_im_002 = CV_003_2_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_2_re_001_def, CV_2_im_001_def, Fplus_dW_re_002_def, Fplus_dW_im_002_def, CV_003_2_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CV_003_2_pim_eq :
    CV_2_re_001 * Fplus_dW_im_002 + CV_2_im_001 * Fplus_dW_re_002 = CV_003_2_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_2_re_001_def, CV_2_im_001_def, Fplus_dW_re_002_def, Fplus_dW_im_002_def, CV_003_2_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CV_003_2_mul :
    CV_2_c_001 * Fplus_dW_c_002 = ofLadj CV_003_2_pre CV_003_2_pim := by
  rw [CV_2_c_001_def, Fplus_dW_c_002_def, ofLadj_mul, CV_003_2_pre_eq, CV_003_2_pim_eq]

def CV_003_3_pre : Polynomial ℚ := C ((239411370560 / 785450721 : ℚ)) + C ((-236701780208 / 261816907 : ℚ)) * X ^ 2 + C ((-1600885753792 / 785450721 : ℚ)) * X ^ 3 + C ((-2442247472248 / 785450721 : ℚ)) * X ^ 4 + C ((-2930792119072 / 785450721 : ℚ)) * X ^ 5 + C ((-2930792119072 / 785450721 : ℚ)) * X ^ 6 + C ((-2442247472248 / 785450721 : ℚ)) * X ^ 7 + C ((-1600885753792 / 785450721 : ℚ)) * X ^ 8 + C ((-236701780208 / 261816907 : ℚ)) * X ^ 9
def CV_003_3_pim : Polynomial ℚ := C ((9708443466248 / 8639957931 : ℚ)) + C ((19416886932496 / 8639957931 : ℚ)) * X + C ((25887341774104 / 8639957931 : ℚ)) * X ^ 2 + C ((27490603952632 / 8639957931 : ℚ)) * X ^ 3 + C ((23050372966000 / 8639957931 : ℚ)) * X ^ 4 + C ((14875092823288 / 8639957931 : ℚ)) * X ^ 5 + C ((1513931369736 / 2879985977 : ℚ)) * X ^ 6 + C ((-1211162011168 / 2879985977 : ℚ)) * X ^ 7 + C ((-2691239006712 / 2879985977 : ℚ)) * X ^ 8 + C ((-2156818280536 / 2879985977 : ℚ)) * X ^ 9
theorem CV_003_3_neg_re : -CV_3_re_003 = CV_003_3_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_3_re_003_def, CV_003_3_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CV_003_3_neg_im : -CV_3_im_003 = CV_003_3_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_3_im_003_def, CV_003_3_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CV_003_3_mul : -CV_3_c_003 = ofLadj CV_003_3_pre CV_003_3_pim := by
  rw [CV_3_c_003_def, ofLadj_neg, CV_003_3_neg_re, CV_003_3_neg_im]

@[expose] public def CV_coeff_003 : Ki := CV_0_c_001 * Fplus_dU_c_002 + CV_1_c_001 * Fplus_dV_c_002 + CV_2_c_001 * Fplus_dW_c_002 + (-CV_3_c_003)

theorem CV_coeff_003_sum :
    CV_coeff_003 = ofLadj (CV_003_0_pre + CV_003_1_pre + CV_003_2_pre + CV_003_3_pre) (CV_003_0_pim + CV_003_1_pim + CV_003_2_pim + CV_003_3_pim) := by
  simp only [CV_coeff_003, CV_003_0_mul, CV_003_1_mul, CV_003_2_mul, CV_003_3_mul]
  simpa [add_assoc] using ofLadj_add4 CV_003_0_pre CV_003_0_pim CV_003_1_pre CV_003_1_pim CV_003_2_pre CV_003_2_pim CV_003_3_pre CV_003_3_pim

def CV_003_qre : Polynomial ℚ := C ((66846001976807 / 8639957931 : ℚ)) + C ((1477900611307057 / 8639957931 : ℚ)) * X + C ((1591916336204333 / 8639957931 : ℚ)) * X ^ 2 + C ((668846651415024 / 2879985977 : ℚ)) * X ^ 3 + C ((904270661463254 / 2879985977 : ℚ)) * X ^ 4 + C ((1716998713583599 / 8639957931 : ℚ)) * X ^ 5 + C ((504272702287881 / 2879985977 : ℚ)) * X ^ 6 + C ((27514965683076 / 261816907 : ℚ)) * X ^ 7 + C ((-10629819879746 / 261816907 : ℚ)) * X ^ 8
def CV_003_qim : Polynomial ℚ := C ((-1200870098951107 / 8639957931 : ℚ)) + C ((-1200870098951107 / 8639957931 : ℚ)) * X + C ((-180860496668470 / 2879985977 : ℚ)) * X ^ 2 + C ((-721394518282000 / 8639957931 : ℚ)) * X ^ 3 + C ((426128973927872 / 8639957931 : ℚ)) * X ^ 4 + C ((112150532120887 / 785450721 : ℚ)) * X ^ 5 + C ((1062437820221177 / 8639957931 : ℚ)) * X ^ 6 + C ((1784196472528933 / 8639957931 : ℚ)) * X ^ 7 + C ((340119547182774 / 2879985977 : ℚ)) * X ^ 8
theorem CV_coeff_003_poly_re :
    CV_003_0_pre + CV_003_1_pre + CV_003_2_pre + CV_003_3_pre = (0 : Polynomial ℚ) + Phi11 * CV_003_qre := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [CV_003_0_pre, CV_003_1_pre, CV_003_2_pre, CV_003_3_pre, CV_003_qre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try grind
theorem CV_coeff_003_poly_im :
    CV_003_0_pim + CV_003_1_pim + CV_003_2_pim + CV_003_3_pim = (0 : Polynomial ℚ) + Phi11 * CV_003_qim := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [CV_003_0_pim, CV_003_1_pim, CV_003_2_pim, CV_003_3_pim, CV_003_qim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try grind
public theorem CV_coeff_003_eq :
    CV_coeff_003 = (0 : Ki) := by
  rw [CV_coeff_003_sum, CV_coeff_003_poly_re,
    CV_coeff_003_poly_im, ofLadj_add_Phi11]
  exact ofLadj_zero

end V14Formalization.D12SigmaPlusSegreCore
