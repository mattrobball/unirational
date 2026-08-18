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

def CU_102_0_pre : Polynomial ℚ := C ((-356273885493184 / 235794999 : ℚ)) + C ((-2546105785209088 / 235794999 : ℚ)) * X + C ((-39668931909664 / 1948719 : ℚ)) * X ^ 2 + C ((-2516722940354104 / 78598333 : ℚ)) * X ^ 3 + C ((-10748255316190792 / 235794999 : ℚ)) * X ^ 4 + C ((-4106510899066816 / 78598333 : ℚ)) * X ^ 5 + C ((-13488224570551880 / 235794999 : ℚ)) * X ^ 6 + C ((-14029685095994068 / 235794999 : ℚ)) * X ^ 7 + C ((-4331975690792192 / 78598333 : ℚ)) * X ^ 8 + C ((-4266313926820388 / 78598333 : ℚ)) * X ^ 9 + C ((-12648465410186296 / 235794999 : ℚ)) * X ^ 10 + C ((-12236085376744448 / 235794999 : ℚ)) * X ^ 11 + C ((-3367453208325736 / 78598333 : ℚ)) * X ^ 12 + C ((-7999001019391820 / 235794999 : ℚ)) * X ^ 13 + C ((-1815252750438088 / 78598333 : ℚ)) * X ^ 14 + C ((-2428737486991348 / 235794999 : ℚ)) * X ^ 15 + C ((-965124238398368 / 235794999 : ℚ)) * X ^ 16 + C ((67855878317688 / 78598333 : ℚ)) * X ^ 17 + C ((852692292811928 / 235794999 : ℚ)) * X ^ 18
def CU_102_0_pim : Polynomial ℚ := C ((34594688181600 / 7145303 : ℚ)) + C ((69189376363200 / 7145303 : ℚ)) * X + C ((724238233433296 / 78598333 : ℚ)) * X ^ 2 + C ((2165880129224672 / 235794999 : ℚ)) * X ^ 3 + C ((588173309407864 / 235794999 : ℚ)) * X ^ 4 + C ((-617833549592844 / 78598333 : ℚ)) * X ^ 5 + C ((-3724318884954836 / 235794999 : ℚ)) * X ^ 6 + C ((-6108368730323020 / 235794999 : ℚ)) * X ^ 7 + C ((-2475866671251416 / 78598333 : ℚ)) * X ^ 8 + C ((-2466432121437580 / 78598333 : ℚ)) * X ^ 9 + C ((-7268973413230996 / 235794999 : ℚ)) * X ^ 10 + C ((-2739856858685984 / 78598333 : ℚ)) * X ^ 11 + C ((-9170167738884908 / 235794999 : ℚ)) * X ^ 12 + C ((-2976436689372484 / 78598333 : ℚ)) * X ^ 13 + C ((-8894171847600728 / 235794999 : ℚ)) * X ^ 14 + C ((-7399105405648516 / 235794999 : ℚ)) * X ^ 15 + C ((-5124895670876812 / 235794999 : ℚ)) * X ^ 16 + C ((-1151058842506708 / 78598333 : ℚ)) * X ^ 17 + C ((-112417355051512 / 21435909 : ℚ)) * X ^ 18
theorem CU_102_0_pre_eq :
    CU_0_re_001 * Fplus_dU_re_101 - CU_0_im_001 * Fplus_dU_im_101 = CU_102_0_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_0_re_001, CU_0_im_001, Fplus_dU_re_101, Fplus_dU_im_101, CU_102_0_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CU_102_0_pim_eq :
    CU_0_re_001 * Fplus_dU_im_101 + CU_0_im_001 * Fplus_dU_re_101 = CU_102_0_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_0_re_001, CU_0_im_001, Fplus_dU_re_101, Fplus_dU_im_101, CU_102_0_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CU_102_0_mul :
    CU_0_c_001 * Fplus_dU_c_101 = ofLadj CU_102_0_pre CU_102_0_pim := by
  rw [CU_0_c_001, Fplus_dU_c_101, ofLadj_mul, CU_102_0_pre_eq, CU_102_0_pim_eq]

def CU_102_1_pre : Polynomial ℚ := C ((53465195011680 / 78598333 : ℚ)) + C ((724393327054080 / 78598333 : ℚ)) * X + C ((4421220215480360 / 235794999 : ℚ)) * X ^ 2 + C ((7266488888480204 / 235794999 : ℚ)) * X ^ 3 + C ((10818167180878348 / 235794999 : ℚ)) * X ^ 4 + C ((35416040887724 / 649573 : ℚ)) * X ^ 5 + C ((14496922001747168 / 235794999 : ℚ)) * X ^ 6 + C ((5132710666329100 / 78598333 : ℚ)) * X ^ 7 + C ((14669825616959132 / 235794999 : ℚ)) * X ^ 8 + C ((4797504986029408 / 78598333 : ℚ)) * X ^ 9 + C ((14180778196963540 / 235794999 : ℚ)) * X ^ 10 + C ((1267403694094688 / 21435909 : ℚ)) * X ^ 11 + C ((12007598215801300 / 235794999 : ℚ)) * X ^ 12 + C ((9971294742607864 / 235794999 : ℚ)) * X ^ 13 + C ((2467778909492976 / 78598333 : ℚ)) * X ^ 14 + C ((1368834180724256 / 78598333 : ℚ)) * X ^ 15 + C ((740041826582592 / 78598333 : ℚ)) * X ^ 16 + C ((579226320244420 / 235794999 : ℚ)) * X ^ 17 + C ((-473462275936184 / 235794999 : ℚ)) * X ^ 18
def CU_102_1_pim : Polynomial ℚ := C ((-487816469879048 / 78598333 : ℚ)) + C ((-975632939758096 / 78598333 : ℚ)) * X + C ((-1157529756077064 / 78598333 : ℚ)) * X ^ 2 + C ((-1363355929238836 / 78598333 : ℚ)) * X ^ 3 + C ((-1025673409434108 / 78598333 : ℚ)) * X ^ 4 + C ((-97456684845172 / 21435909 : ℚ)) * X ^ 5 + C ((534796290722512 / 235794999 : ℚ)) * X ^ 6 + C ((2895282442486660 / 235794999 : ℚ)) * X ^ 7 + C ((1416555728530520 / 78598333 : ℚ)) * X ^ 8 + C ((4209795523328512 / 235794999 : ℚ)) * X ^ 9 + C ((1342111343645404 / 78598333 : ℚ)) * X ^ 10 + C ((1740319872297224 / 78598333 : ℚ)) * X ^ 11 + C ((2138528400949044 / 78598333 : ℚ)) * X ^ 12 + C ((6777814159411736 / 235794999 : ℚ)) * X ^ 13 + C ((2451807005544668 / 78598333 : ℚ)) * X ^ 14 + C ((6458755107782752 / 235794999 : ℚ)) * X ^ 15 + C ((4689443948335912 / 235794999 : ℚ)) * X ^ 16 + C ((1120934569582508 / 78598333 : ℚ)) * X ^ 17 + C ((1238003092541968 / 235794999 : ℚ)) * X ^ 18
theorem CU_102_1_pre_eq :
    CU_1_re_001 * Fplus_dV_re_101 - CU_1_im_001 * Fplus_dV_im_101 = CU_102_1_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_1_re_001, CU_1_im_001, Fplus_dV_re_101, Fplus_dV_im_101, CU_102_1_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CU_102_1_pim_eq :
    CU_1_re_001 * Fplus_dV_im_101 + CU_1_im_001 * Fplus_dV_re_101 = CU_102_1_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_1_re_001, CU_1_im_001, Fplus_dV_re_101, Fplus_dV_im_101, CU_102_1_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CU_102_1_mul :
    CU_1_c_001 * Fplus_dV_c_101 = ofLadj CU_102_1_pre CU_102_1_pim := by
  rw [CU_1_c_001, Fplus_dV_c_101, ofLadj_mul, CU_102_1_pre_eq, CU_102_1_pim_eq]

def CU_102_2_pre : Polynomial ℚ := C ((16476351739992 / 78598333 : ℚ)) + C ((268415658718368 / 78598333 : ℚ)) * X + C ((146154733751768 / 21435909 : ℚ)) * X ^ 2 + C ((2611872899607352 / 235794999 : ℚ)) * X ^ 3 + C ((3968028004678832 / 235794999 : ℚ)) * X ^ 4 + C ((1598741736703916 / 78598333 : ℚ)) * X ^ 5 + C ((5553524420428916 / 235794999 : ℚ)) * X ^ 6 + C ((2018942101392440 / 78598333 : ℚ)) * X ^ 7 + C ((5954699715511612 / 235794999 : ℚ)) * X ^ 8 + C ((6034702800720596 / 235794999 : ℚ)) * X ^ 9 + C ((6095718765045388 / 235794999 : ℚ)) * X ^ 10 + C ((6069032706987104 / 235794999 : ℚ)) * X ^ 11 + C ((5290471788890284 / 235794999 : ℚ)) * X ^ 12 + C ((4427000729451148 / 235794999 : ℚ)) * X ^ 13 + C ((1114275605301420 / 78598333 : ℚ)) * X ^ 14 + C ((637729393109784 / 78598333 : ℚ)) * X ^ 15 + C ((1041352224664016 / 235794999 : ℚ)) * X ^ 16 + C ((94684338115616 / 78598333 : ℚ)) * X ^ 17 + C ((-175610120169136 / 235794999 : ℚ)) * X ^ 18
def CU_102_2_pim : Polynomial ℚ := C ((-576724260481624 / 235794999 : ℚ)) + C ((-1153448520963248 / 235794999 : ℚ)) * X + C ((-468859899925608 / 78598333 : ℚ)) * X ^ 2 + C ((-1756855759282400 / 235794999 : ℚ)) * X ^ 3 + C ((-1524934847051144 / 235794999 : ℚ)) * X ^ 4 + C ((-917921832142780 / 235794999 : ℚ)) * X ^ 5 + C ((-447268335270620 / 235794999 : ℚ)) * X ^ 6 + C ((400700813600392 / 235794999 : ℚ)) * X ^ 7 + C ((80874980546048 / 21435909 : ℚ)) * X ^ 8 + C ((7447484454892 / 1948719 : ℚ)) * X ^ 9 + C ((954072009810688 / 235794999 : ℚ)) * X ^ 10 + C ((1608280876486168 / 235794999 : ℚ)) * X ^ 11 + C ((205680885741968 / 21435909 : ℚ)) * X ^ 12 + C ((2568547312743980 / 235794999 : ℚ)) * X ^ 13 + C ((2930344205284960 / 235794999 : ℚ)) * X ^ 14 + C ((2664817874650880 / 235794999 : ℚ)) * X ^ 15 + C ((1989855677112944 / 235794999 : ℚ)) * X ^ 16 + C ((1438447722309544 / 235794999 : ℚ)) * X ^ 17 + C ((522529390808960 / 235794999 : ℚ)) * X ^ 18
theorem CU_102_2_pre_eq :
    CU_2_re_001 * Fplus_dW_re_101 - CU_2_im_001 * Fplus_dW_im_101 = CU_102_2_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_2_re_001, CU_2_im_001, Fplus_dW_re_101, Fplus_dW_im_101, CU_102_2_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CU_102_2_pim_eq :
    CU_2_re_001 * Fplus_dW_im_101 + CU_2_im_001 * Fplus_dW_re_101 = CU_102_2_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_2_re_001, CU_2_im_001, Fplus_dW_re_101, Fplus_dW_im_101, CU_102_2_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CU_102_2_mul :
    CU_2_c_001 * Fplus_dW_c_101 = ofLadj CU_102_2_pre CU_102_2_pim := by
  rw [CU_2_c_001, Fplus_dW_c_101, ofLadj_mul, CU_102_2_pre_eq, CU_102_2_pim_eq]

def CU_102_3_pre : Polynomial ℚ := C ((117411123408 / 7145303 : ℚ)) + C ((-315018476464 / 7145303 : ℚ)) * X ^ 2 + C ((-2182742165168 / 21435909 : ℚ)) * X ^ 3 + C ((-3320186758144 / 21435909 : ℚ)) * X ^ 4 + C ((-1332048754672 / 7145303 : ℚ)) * X ^ 5 + C ((-1332048754672 / 7145303 : ℚ)) * X ^ 6 + C ((-3320186758144 / 21435909 : ℚ)) * X ^ 7 + C ((-2182742165168 / 21435909 : ℚ)) * X ^ 8 + C ((-315018476464 / 7145303 : ℚ)) * X ^ 9
def CU_102_3_pim : Polynomial ℚ := C ((13196933417648 / 235794999 : ℚ)) + C ((26393866835296 / 235794999 : ℚ)) * X + C ((35401846823800 / 235794999 : ℚ)) * X ^ 2 + C ((12453099324720 / 78598333 : ℚ)) * X ^ 3 + C ((31645794128024 / 235794999 : ℚ)) * X ^ 4 + C ((6691265051728 / 78598333 : ℚ)) * X ^ 5 + C ((6320071680112 / 235794999 : ℚ)) * X ^ 6 + C ((-5251927292728 / 235794999 : ℚ)) * X ^ 7 + C ((-10965431138864 / 235794999 : ℚ)) * X ^ 8 + C ((-3002659996168 / 78598333 : ℚ)) * X ^ 9
theorem CU_102_3_neg_re : -CU_3_re_102 = CU_102_3_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_3_re_102, CU_102_3_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CU_102_3_neg_im : -CU_3_im_102 = CU_102_3_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_3_im_102, CU_102_3_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CU_102_3_mul : -CU_3_c_102 = ofLadj CU_102_3_pre CU_102_3_pim := by
  rw [CU_3_c_102, ofLadj_neg, CU_102_3_neg_re, CU_102_3_neg_im]

theorem CU_102_4_mul : CU_3_c_002 = ofLadj CU_3_re_002 CU_3_im_002 := rfl

@[expose] public def CU_coeff_102 : Ki := CU_0_c_001 * Fplus_dU_c_101 + CU_1_c_001 * Fplus_dV_c_101 + CU_2_c_001 * Fplus_dW_c_101 + (-CU_3_c_102) + CU_3_c_002

theorem CU_coeff_102_sum :
    CU_coeff_102 = ofLadj (CU_102_0_pre + CU_102_1_pre + CU_102_2_pre + CU_102_3_pre + CU_3_re_002) (CU_102_0_pim + CU_102_1_pim + CU_102_2_pim + CU_102_3_pim + CU_3_im_002) := by
  simp only [CU_coeff_102, CU_102_0_mul, CU_102_1_mul, CU_102_2_mul, CU_102_3_mul, CU_102_4_mul]
  simp [ofLadj_add, add_assoc]

def CU_102_qre : Polynomial ℚ := C ((-48785471153864 / 78598333 : ℚ)) + C ((578677585569848 / 235794999 : ℚ)) * X + C ((796415927047184 / 235794999 : ℚ)) * X ^ 2 + C ((366296386532756 / 78598333 : ℚ)) * X ^ 3 + C ((1709452058558152 / 235794999 : ℚ)) * X ^ 4 + C ((1294599768497348 / 235794999 : ℚ)) * X ^ 5 + C ((1229506496469092 / 235794999 : ℚ)) * X ^ 6 + C ((863227072837724 / 235794999 : ℚ)) * X ^ 7 + C ((203619896706608 / 235794999 : ℚ)) * X ^ 8
def CU_102_qim : Polynomial ℚ := C ((-898237289803984 / 235794999 : ℚ)) + C ((-898237289803984 / 235794999 : ℚ)) * X + C ((-909144196914392 / 235794999 : ℚ)) * X ^ 2 + C ((-974541970279972 / 235794999 : ℚ)) * X ^ 3 + C ((-110958067488960 / 78598333 : ℚ)) * X ^ 4 + C ((56687874071024 / 78598333 : ℚ)) * X ^ 5 + C ((206329051035100 / 235794999 : ℚ)) * X ^ 6 + C ((274711108584216 / 78598333 : ℚ)) * X ^ 7 + C ((523941577784296 / 235794999 : ℚ)) * X ^ 8
theorem CU_coeff_102_poly_re :
    CU_102_0_pre + CU_102_1_pre + CU_102_2_pre + CU_102_3_pre + CU_3_re_002 = (0 : Polynomial ℚ) + Phi11 * CU_102_qre := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [CU_102_0_pre, CU_102_1_pre, CU_102_2_pre, CU_102_3_pre, CU_3_re_002, CU_102_qre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try grind
theorem CU_coeff_102_poly_im :
    CU_102_0_pim + CU_102_1_pim + CU_102_2_pim + CU_102_3_pim + CU_3_im_002 = (0 : Polynomial ℚ) + Phi11 * CU_102_qim := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [CU_102_0_pim, CU_102_1_pim, CU_102_2_pim, CU_102_3_pim, CU_3_im_002, CU_102_qim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try grind
public theorem CU_coeff_102_eq :
    CU_coeff_102 = (0 : Ki) := by
  rw [CU_coeff_102_sum, CU_coeff_102_poly_re,
    CU_coeff_102_poly_im, ofLadj_add_Phi11]
  exact ofLadj_zero

end V14Formalization.D12SigmaPlusSegreCore
