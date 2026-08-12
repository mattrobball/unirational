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

def CW_022_0_pre : Polynomial ℚ := C ((4723263026558 / 8639957931 : ℚ)) + C ((-10331031362008 / 8639957931 : ℚ)) * X + C ((-11576060983930 / 8639957931 : ℚ)) * X ^ 2 + C ((-23958395392154 / 8639957931 : ℚ)) * X ^ 3 + C ((-14153877261256 / 2879985977 : ℚ)) * X ^ 4 + C ((-14139279241248 / 2879985977 : ℚ)) * X ^ 5 + C ((-58593797130184 / 8639957931 : ℚ)) * X ^ 6 + C ((-19435082234048 / 2879985977 : ℚ)) * X ^ 7 + C ((-19029164430088 / 2879985977 : ℚ)) * X ^ 8 + C ((-19480551741968 / 2879985977 : ℚ)) * X ^ 9 + C ((-19526087584524 / 2879985977 : ℚ)) * X ^ 10 + C ((-64141867210592 / 8639957931 : ℚ)) * X ^ 11 + C ((-48247231391564 / 8639957931 : ℚ)) * X ^ 12 + C ((-46865594241974 / 8639957931 : ℚ)) * X ^ 13 + C ((-33129097898110 / 8639957931 : ℚ)) * X ^ 14 + C ((-1285977310040 / 785450721 : ℚ)) * X ^ 15 + C ((-13528195815850 / 8639957931 : ℚ)) * X ^ 16 + C ((882587863530 / 2879985977 : ℚ)) * X ^ 17 + C ((1697864507936 / 8639957931 : ℚ)) * X ^ 18
def CW_022_0_pim : Polynomial ℚ := C ((9482607641338 / 8639957931 : ℚ)) + C ((18965215282676 / 8639957931 : ℚ)) * X + C ((1493849158246 / 785450721 : ℚ)) * X ^ 2 + C ((10628691556080 / 2879985977 : ℚ)) * X ^ 3 + C ((21163661273246 / 8639957931 : ℚ)) * X ^ 4 + C ((7002528037918 / 2879985977 : ℚ)) * X ^ 5 + C ((17789370448478 / 8639957931 : ℚ)) * X ^ 6 + C ((1767048772674 / 2879985977 : ℚ)) * X ^ 7 + C ((2037985426530 / 2879985977 : ℚ)) * X ^ 8 + C ((5589265501174 / 8639957931 : ℚ)) * X ^ 9 + C ((1757207359150 / 2879985977 : ℚ)) * X ^ 10 + C ((-5175060179512 / 8639957931 : ℚ)) * X ^ 11 + C ((-15621742436474 / 8639957931 : ℚ)) * X ^ 12 + C ((-4468837106076 / 2879985977 : ℚ)) * X ^ 13 + C ((-9794978674726 / 2879985977 : ℚ)) * X ^ 14 + C ((-17789916783044 / 8639957931 : ℚ)) * X ^ 15 + C ((-17449127993744 / 8639957931 : ℚ)) * X ^ 16 + C ((-4244243881612 / 2879985977 : ℚ)) * X ^ 17 + C ((-19931961524 / 2879985977 : ℚ)) * X ^ 18
theorem CW_022_0_pre_eq :
    CW_0_re_020 * Fplus_dU_re_002 - CW_0_im_020 * Fplus_dU_im_002 = CW_022_0_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_0_re_020, CW_0_im_020, Fplus_dU_re_002, Fplus_dU_im_002, CW_022_0_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CW_022_0_pim_eq :
    CW_0_re_020 * Fplus_dU_im_002 + CW_0_im_020 * Fplus_dU_re_002 = CW_022_0_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_0_re_020, CW_0_im_020, Fplus_dU_re_002, Fplus_dU_im_002, CW_022_0_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CW_022_0_mul :
    CW_0_c_020 * Fplus_dU_c_002 = ofLadj CW_022_0_pre CW_022_0_pim := by
  rw [CW_0_c_020, Fplus_dU_c_002, ofLadj_mul, CW_022_0_pre_eq, CW_022_0_pim_eq]

def CW_022_1_pre : Polynomial ℚ := C ((146799411388 / 2879985977 : ℚ)) + C ((-477290527184 / 8639957931 : ℚ)) * X + C ((-405745553470 / 8639957931 : ℚ)) * X ^ 2 + C ((-1448932832480 / 8639957931 : ℚ)) * X ^ 3 + C ((-841483625208 / 2879985977 : ℚ)) * X ^ 4 + C ((-2758561265810 / 8639957931 : ℚ)) * X ^ 5 + C ((-373722964652 / 785450721 : ℚ)) * X ^ 6 + C ((-3780886164248 / 8639957931 : ℚ)) * X ^ 7 + C ((-3395328246278 / 8639957931 : ℚ)) * X ^ 8 + C ((-2814092428088 / 8639957931 : ℚ)) * X ^ 9 + C ((-2837361565064 / 8639957931 : ℚ)) * X ^ 10 + C ((-1008810264092 / 2879985977 : ℚ)) * X ^ 11 + C ((-786690345960 / 2879985977 : ℚ)) * X ^ 12 + C ((-2408346874618 / 8639957931 : ℚ)) * X ^ 13 + C ((-58981679206 / 261816907 : ℚ)) * X ^ 14 + C ((-1049279955142 / 8639957931 : ℚ)) * X ^ 15 + C ((-316887515526 / 2879985977 : ℚ)) * X ^ 16 + C ((401728798784 / 8639957931 : ℚ)) * X ^ 17 + C ((207155333482 / 8639957931 : ℚ)) * X ^ 18
def CW_022_1_pim : Polynomial ℚ := C ((617220743674 / 8639957931 : ℚ)) + C ((1234441487348 / 8639957931 : ℚ)) * X + C ((1200950645072 / 8639957931 : ℚ)) * X ^ 2 + C ((2382615291968 / 8639957931 : ℚ)) * X ^ 3 + C ((44580603258 / 261816907 : ℚ)) * X ^ 4 + C ((1716951342470 / 8639957931 : ℚ)) * X ^ 5 + C ((325772030580 / 2879985977 : ℚ)) * X ^ 6 + C ((-98643514862 / 8639957931 : ℚ)) * X ^ 7 + C ((-535495992586 / 8639957931 : ℚ)) * X ^ 8 + C ((-8709489654 / 261816907 : ℚ)) * X ^ 9 + C ((-24353525366 / 2879985977 : ℚ)) * X ^ 10 + C ((-432951603956 / 8639957931 : ℚ)) * X ^ 11 + C ((-792842631814 / 8639957931 : ℚ)) * X ^ 12 + C ((-544999207054 / 8639957931 : ℚ)) * X ^ 13 + C ((-492860339982 / 2879985977 : ℚ)) * X ^ 14 + C ((-342408564834 / 2879985977 : ℚ)) * X ^ 15 + C ((-442341736624 / 2879985977 : ℚ)) * X ^ 16 + C ((-998703944902 / 8639957931 : ℚ)) * X ^ 17 + C ((7749193762 / 2879985977 : ℚ)) * X ^ 18
theorem CW_022_1_pre_eq :
    CW_1_re_020 * Fplus_dV_re_002 - CW_1_im_020 * Fplus_dV_im_002 = CW_022_1_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_1_re_020, CW_1_im_020, Fplus_dV_re_002, Fplus_dV_im_002, CW_022_1_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CW_022_1_pim_eq :
    CW_1_re_020 * Fplus_dV_im_002 + CW_1_im_020 * Fplus_dV_re_002 = CW_022_1_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_1_re_020, CW_1_im_020, Fplus_dV_re_002, Fplus_dV_im_002, CW_022_1_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CW_022_1_mul :
    CW_1_c_020 * Fplus_dV_c_002 = ofLadj CW_022_1_pre CW_022_1_pim := by
  rw [CW_1_c_020, Fplus_dV_c_002, ofLadj_mul, CW_022_1_pre_eq, CW_022_1_pim_eq]

def CW_022_2_pre : Polynomial ℚ := C ((289102843214 / 2879985977 : ℚ)) + C ((273181897852 / 2879985977 : ℚ)) * X ^ 2 + C ((200377981974 / 2879985977 : ℚ)) * X ^ 3 + C ((445796520650 / 2879985977 : ℚ)) * X ^ 4 + C ((352603889730 / 2879985977 : ℚ)) * X ^ 5 + C ((352603889730 / 2879985977 : ℚ)) * X ^ 6 + C ((445796520650 / 2879985977 : ℚ)) * X ^ 7 + C ((200377981974 / 2879985977 : ℚ)) * X ^ 8 + C ((273181897852 / 2879985977 : ℚ)) * X ^ 9
def CW_022_2_pim : Polynomial ℚ := C ((-3637622944 / 2879985977 : ℚ)) + C ((-7275245888 / 2879985977 : ℚ)) * X + C ((-20029535776 / 261816907 : ℚ)) * X ^ 2 + C ((-73124648396 / 2879985977 : ℚ)) * X ^ 3 + C ((-223238376298 / 2879985977 : ℚ)) * X ^ 4 + C ((112103103168 / 2879985977 : ℚ)) * X ^ 5 + C ((-119378349056 / 2879985977 : ℚ)) * X ^ 6 + C ((215963130410 / 2879985977 : ℚ)) * X ^ 7 + C ((65849402508 / 2879985977 : ℚ)) * X ^ 8 + C ((213049647648 / 2879985977 : ℚ)) * X ^ 9
theorem CW_022_2_pre_eq :
    CW_2_re_020 * Fplus_dW_re_002 - CW_2_im_020 * Fplus_dW_im_002 = CW_022_2_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_2_re_020, CW_2_im_020, Fplus_dW_re_002, Fplus_dW_im_002, CW_022_2_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CW_022_2_pim_eq :
    CW_2_re_020 * Fplus_dW_im_002 + CW_2_im_020 * Fplus_dW_re_002 = CW_022_2_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_2_re_020, CW_2_im_020, Fplus_dW_re_002, Fplus_dW_im_002, CW_022_2_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CW_022_2_mul :
    CW_2_c_020 * Fplus_dW_c_002 = ofLadj CW_022_2_pre CW_022_2_pim := by
  rw [CW_2_c_020, Fplus_dW_c_002, ofLadj_mul, CW_022_2_pre_eq, CW_022_2_pim_eq]

theorem CW_022_3_mul : CW_3_c_021 = ofLadj CW_3_re_021 CW_3_im_021 := rfl

def CW_coeff_022 : Ki := CW_0_c_020 * Fplus_dU_c_002 + CW_1_c_020 * Fplus_dV_c_002 + CW_2_c_020 * Fplus_dW_c_002 + CW_3_c_021

theorem CW_coeff_022_sum :
    CW_coeff_022 = ofLadj (CW_022_0_pre + CW_022_1_pre + CW_022_2_pre + CW_3_re_021) (CW_022_0_pim + CW_022_1_pim + CW_022_2_pim + CW_3_im_021) := by
  simp only [CW_coeff_022, CW_022_0_mul, CW_022_1_mul, CW_022_2_mul, CW_022_3_mul]
  simpa [add_assoc] using ofLadj_add4 CW_022_0_pre CW_022_0_pim CW_022_1_pre CW_022_1_pim CW_022_2_pre CW_022_2_pim CW_3_re_021 CW_3_im_021

def CW_022_qre : Polynomial ℚ := C ((1917557894744 / 2879985977 : ℚ)) + C ((-5520331857808 / 2879985977 : ℚ)) * X + C ((-1333361312852 / 8639957931 : ℚ)) * X ^ 2 + C ((-1290767982244 / 785450721 : ℚ)) * X ^ 3 + C ((-19880462946326 / 8639957931 : ℚ)) * X ^ 4 + C ((-716172003154 / 8639957931 : ℚ)) * X ^ 5 + C ((-531162143994 / 261816907 : ℚ)) * X ^ 6 + C ((1144472547956 / 8639957931 : ℚ)) * X ^ 7 + C ((635006613806 / 2879985977 : ℚ)) * X ^ 8
def CW_022_qim : Polynomial ℚ := C ((3602191094940 / 2879985977 : ℚ)) + C ((3602191094940 / 2879985977 : ℚ)) * X + C ((-223915867546 / 785450721 : ℚ)) * X ^ 2 + C ((16912006518842 / 8639957931 : ℚ)) * X ^ 3 + C ((-1095124960598 / 785450721 : ℚ)) * X ^ 4 + C ((-112918110 / 23801537 : ℚ)) * X ^ 5 + C ((-5044717613878 / 8639957931 : ℚ)) * X ^ 6 + C ((-13694887286452 / 8639957931 : ℚ)) * X ^ 7 + C ((-1107524342 / 261816907 : ℚ)) * X ^ 8
theorem CW_coeff_022_poly_re :
    CW_022_0_pre + CW_022_1_pre + CW_022_2_pre + CW_3_re_021 = (0 : Polynomial ℚ) + Phi11 * CW_022_qre := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [CW_022_0_pre, CW_022_1_pre, CW_022_2_pre, CW_3_re_021, CW_022_qre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try ring
theorem CW_coeff_022_poly_im :
    CW_022_0_pim + CW_022_1_pim + CW_022_2_pim + CW_3_im_021 = (0 : Polynomial ℚ) + Phi11 * CW_022_qim := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [CW_022_0_pim, CW_022_1_pim, CW_022_2_pim, CW_3_im_021, CW_022_qim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try ring
theorem CW_coeff_022_eq :
    CW_coeff_022 = (0 : Ki) := by
  rw [CW_coeff_022_sum, CW_coeff_022_poly_re,
    CW_coeff_022_poly_im, ofLadj_add_Phi11]
  exact ofLadj_zero

end V14Formalization.D12SigmaPlusSegreCore
