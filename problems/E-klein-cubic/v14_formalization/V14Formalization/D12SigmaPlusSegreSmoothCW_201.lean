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

def CW_201_0_pre : Polynomial ℚ := C ((2485160734592 / 2879985977 : ℚ)) + C ((18535602095008 / 2879985977 : ℚ)) * X + C ((104173455288142 / 8639957931 : ℚ)) * X ^ 2 + C ((14930409426463 / 785450721 : ℚ)) * X ^ 3 + C ((234539684546624 / 8639957931 : ℚ)) * X ^ 4 + C ((89278429510189 / 2879985977 : ℚ)) * X ^ 5 + C ((294266289611708 / 8639957931 : ℚ)) * X ^ 6 + C ((101742473756830 / 2879985977 : ℚ)) * X ^ 7 + C ((282822137668171 / 8639957931 : ℚ)) * X ^ 8 + C ((92852286817196 / 2879985977 : ℚ)) * X ^ 9 + C ((275243336673407 / 8639957931 : ℚ)) * X ^ 10 + C ((266629632464896 / 8639957931 : ℚ)) * X ^ 11 + C ((219636530388383 / 8639957931 : ℚ)) * X ^ 12 + C ((174383405163446 / 8639957931 : ℚ)) * X ^ 13 + C ((118587633977078 / 8639957931 : ℚ)) * X ^ 14 + C ((52272414725566 / 8639957931 : ℚ)) * X ^ 15 + C ((21314195514745 / 8639957931 : ℚ)) * X ^ 16 + C ((-5116805566396 / 8639957931 : ℚ)) * X ^ 17 + C ((-6138440666100 / 2879985977 : ℚ)) * X ^ 18
def CW_201_0_pim : Polynomial ℚ := C ((-2286366539564 / 785450721 : ℚ)) + C ((-4572733079128 / 785450721 : ℚ)) * X + C ((-47523496582202 / 8639957931 : ℚ)) * X ^ 2 + C ((-16191530468118 / 2879985977 : ℚ)) * X ^ 3 + C ((-1209499960784 / 785450721 : ℚ)) * X ^ 4 + C ((39282110380588 / 8639957931 : ℚ)) * X ^ 5 + C ((26658951039312 / 2879985977 : ℚ)) * X ^ 6 + C ((132384443794696 / 8639957931 : ℚ)) * X ^ 7 + C ((53462590584274 / 2879985977 : ℚ)) * X ^ 8 + C ((14526837287222 / 785450721 : ℚ)) * X ^ 9 + C ((52313665192574 / 2879985977 : ℚ)) * X ^ 10 + C ((59310333100780 / 2879985977 : ℚ)) * X ^ 11 + C ((66307001008986 / 2879985977 : ℚ)) * X ^ 12 + C ((193290221157032 / 8639957931 : ℚ)) * X ^ 13 + C ((193748754385804 / 8639957931 : ℚ)) * X ^ 14 + C ((160219754056700 / 8639957931 : ℚ)) * X ^ 15 + C ((111339618632918 / 8639957931 : ℚ)) * X ^ 16 + C ((74963352602830 / 8639957931 : ℚ)) * X ^ 17 + C ((26262236451500 / 8639957931 : ℚ)) * X ^ 18
theorem CW_201_0_pre_eq :
    CW_0_re_100 * Fplus_dU_re_101 - CW_0_im_100 * Fplus_dU_im_101 = CW_201_0_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_0_re_100, CW_0_im_100, Fplus_dU_re_101, Fplus_dU_im_101, CW_201_0_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CW_201_0_pim_eq :
    CW_0_re_100 * Fplus_dU_im_101 + CW_0_im_100 * Fplus_dU_re_101 = CW_201_0_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_0_re_100, CW_0_im_100, Fplus_dU_re_101, Fplus_dU_im_101, CW_201_0_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CW_201_0_mul :
    CW_0_c_100 * Fplus_dU_c_101 = ofLadj CW_201_0_pre CW_201_0_pim := by
  rw [CW_0_c_100, Fplus_dU_c_101, ofLadj_mul, CW_201_0_pre_eq, CW_201_0_pim_eq]

def CW_201_1_pre : Polynomial ℚ := C ((-2651009789324 / 8639957931 : ℚ)) + C ((-43108480874960 / 8639957931 : ℚ)) * X + C ((-87096741934501 / 8639957931 : ℚ)) * X ^ 2 + C ((-143246637580294 / 8639957931 : ℚ)) * X ^ 3 + C ((-71205548905021 / 2879985977 : ℚ)) * X ^ 4 + C ((-23011574086448 / 785450721 : ℚ)) * X ^ 5 + C ((-286102164042290 / 8639957931 : ℚ)) * X ^ 6 + C ((-303630231140267 / 8639957931 : ℚ)) * X ^ 7 + C ((-289388187308521 / 8639957931 : ℚ)) * X ^ 8 + C ((-283892437643425 / 8639957931 : ℚ)) * X ^ 9 + C ((-279721319070088 / 8639957931 : ℚ)) * X ^ 10 + C ((-275481160492478 / 8639957931 : ℚ)) * X ^ 11 + C ((-236612838195128 / 8639957931 : ℚ)) * X ^ 12 + C ((-65598565236308 / 2879985977 : ℚ)) * X ^ 13 + C ((-48713849909409 / 2879985977 : ℚ)) * X ^ 14 + C ((-80772295475125 / 8639957931 : ℚ)) * X ^ 15 + C ((-14748178642777 / 2879985977 : ℚ)) * X ^ 16 + C ((-1024516985179 / 785450721 : ℚ)) * X ^ 17 + C ((9241288950079 / 8639957931 : ℚ)) * X ^ 18
def CW_201_1_pim : Polynomial ℚ := C ((9750322623522 / 2879985977 : ℚ)) + C ((19500645247044 / 2879985977 : ℚ)) * X + C ((68692399958243 / 8639957931 : ℚ)) * X ^ 2 + C ((27260891737930 / 2879985977 : ℚ)) * X ^ 3 + C ((5560789726879 / 785450721 : ℚ)) * X ^ 4 + C ((7356065779712 / 2879985977 : ℚ)) * X ^ 5 + C ((-3097430954280 / 2879985977 : ℚ)) * X ^ 6 + C ((-18662183220028 / 2879985977 : ℚ)) * X ^ 7 + C ((-82506762307492 / 8639957931 : ℚ)) * X ^ 8 + C ((-81711744185321 / 8639957931 : ℚ)) * X ^ 9 + C ((-78093870606814 / 8639957931 : ℚ)) * X ^ 10 + C ((-34010927539846 / 2879985977 : ℚ)) * X ^ 11 + C ((-125971694632262 / 8639957931 : ℚ)) * X ^ 12 + C ((-44181428423622 / 2879985977 : ℚ)) * X ^ 13 + C ((-144839542404242 / 8639957931 : ℚ)) * X ^ 14 + C ((-126567100564832 / 8639957931 : ℚ)) * X ^ 15 + C ((-92089815453529 / 8639957931 : ℚ)) * X ^ 16 + C ((-6022701683701 / 785450721 : ℚ)) * X ^ 17 + C ((-8059555422899 / 2879985977 : ℚ)) * X ^ 18
theorem CW_201_1_pre_eq :
    CW_1_re_100 * Fplus_dV_re_101 - CW_1_im_100 * Fplus_dV_im_101 = CW_201_1_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_1_re_100, CW_1_im_100, Fplus_dV_re_101, Fplus_dV_im_101, CW_201_1_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CW_201_1_pim_eq :
    CW_1_re_100 * Fplus_dV_im_101 + CW_1_im_100 * Fplus_dV_re_101 = CW_201_1_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_1_re_100, CW_1_im_100, Fplus_dV_re_101, Fplus_dV_im_101, CW_201_1_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CW_201_1_mul :
    CW_1_c_100 * Fplus_dV_c_101 = ofLadj CW_201_1_pre CW_201_1_pim := by
  rw [CW_1_c_100, Fplus_dV_c_101, ofLadj_mul, CW_201_1_pre_eq, CW_201_1_pim_eq]

def CW_201_2_pre : Polynomial ℚ := C ((296503158781 / 8639957931 : ℚ)) + C ((-1267552756204 / 785450721 : ℚ)) * X + C ((-26533510810814 / 8639957931 : ℚ)) * X ^ 2 + C ((-3987772267723 / 785450721 : ℚ)) * X ^ 3 + C ((-22500110799998 / 2879985977 : ℚ)) * X ^ 4 + C ((-26622010760184 / 2879985977 : ℚ)) * X ^ 5 + C ((-31447604399928 / 2879985977 : ℚ)) * X ^ 6 + C ((-34030808842527 / 2879985977 : ℚ)) * X ^ 7 + C ((-9110134531703 / 785450721 : ℚ)) * X ^ 8 + C ((-3080567778674 / 261816907 : ℚ)) * X ^ 9 + C ((-9330805618534 / 785450721 : ℚ)) * X ^ 10 + C ((-103456356762214 / 8639957931 : ℚ)) * X ^ 11 + C ((-2687750954110 / 261816907 : ℚ)) * X ^ 12 + C ((-75125225885428 / 8639957931 : ℚ)) * X ^ 13 + C ((-5122362263980 / 785450721 : ℚ)) * X ^ 14 + C ((-10513374074669 / 2879985977 : ℚ)) * X ^ 15 + C ((-18412651720792 / 8639957931 : ℚ)) * X ^ 16 + C ((-3935870801560 / 8639957931 : ℚ)) * X ^ 17 + C ((1017323967860 / 2879985977 : ℚ)) * X ^ 18
def CW_201_2_pim : Polynomial ℚ := C ((10434292813147 / 8639957931 : ℚ)) + C ((20868585626294 / 8639957931 : ℚ)) * X + C ((24158184113090 / 8639957931 : ℚ)) * X ^ 2 + C ((32092940143378 / 8639957931 : ℚ)) * X ^ 3 + C ((8834534977271 / 2879985977 : ℚ)) * X ^ 4 + C ((5773579142312 / 2879985977 : ℚ)) * X ^ 5 + C ((9928741895048 / 8639957931 : ℚ)) * X ^ 6 + C ((-5256952510240 / 8639957931 : ℚ)) * X ^ 7 + C ((-12784719980249 / 8639957931 : ℚ)) * X ^ 8 + C ((-13032875460080 / 8639957931 : ℚ)) * X ^ 9 + C ((-4636419512033 / 2879985977 : ℚ)) * X ^ 10 + C ((-25691560852160 / 8639957931 : ℚ)) * X ^ 11 + C ((-37473863168221 / 8639957931 : ℚ)) * X ^ 12 + C ((-41639844731036 / 8639957931 : ℚ)) * X ^ 13 + C ((-49822756241155 / 8639957931 : ℚ)) * X ^ 14 + C ((-43528382203927 / 8639957931 : ℚ)) * X ^ 15 + C ((-33293829964460 / 8639957931 : ℚ)) * X ^ 16 + C ((-24470185435550 / 8639957931 : ℚ)) * X ^ 17 + C ((-2744268765224 / 2879985977 : ℚ)) * X ^ 18
theorem CW_201_2_pre_eq :
    CW_2_re_100 * Fplus_dW_re_101 - CW_2_im_100 * Fplus_dW_im_101 = CW_201_2_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_2_re_100, CW_2_im_100, Fplus_dW_re_101, Fplus_dW_im_101, CW_201_2_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CW_201_2_pim_eq :
    CW_2_re_100 * Fplus_dW_im_101 + CW_2_im_100 * Fplus_dW_re_101 = CW_201_2_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_2_re_100, CW_2_im_100, Fplus_dW_re_101, Fplus_dW_im_101, CW_201_2_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CW_201_2_mul :
    CW_2_c_100 * Fplus_dW_c_101 = ofLadj CW_201_2_pre CW_201_2_pim := by
  rw [CW_2_c_100, Fplus_dW_c_101, ofLadj_mul, CW_201_2_pre_eq, CW_201_2_pim_eq]

theorem CW_201_3_mul : CW_3_c_200 = ofLadj CW_3_re_200 CW_3_im_200 := rfl

@[expose] public def CW_coeff_201 : Ki := CW_0_c_100 * Fplus_dU_c_101 + CW_1_c_100 * Fplus_dV_c_101 + CW_2_c_100 * Fplus_dW_c_101 + CW_3_c_200

theorem CW_coeff_201_sum :
    CW_coeff_201 = ofLadj (CW_201_0_pre + CW_201_1_pre + CW_201_2_pre + CW_3_re_200) (CW_201_0_pim + CW_201_1_pim + CW_201_2_pim + CW_3_im_200) := by
  simp only [CW_coeff_201, CW_201_0_mul, CW_201_1_mul, CW_201_2_mul, CW_201_3_mul]
  simpa [add_assoc] using ofLadj_add4 CW_201_0_pre CW_201_0_pim CW_201_1_pre CW_201_1_pim CW_201_2_pre CW_201_2_pim CW_3_re_200 CW_3_im_200

def CW_201_qre : Polynomial ℚ := C ((5191040589241 / 8639957931 : ℚ)) + C ((-6635795497421 / 8639957931 : ℚ)) * X + C ((-8134572861469 / 8639957931 : ℚ)) * X ^ 2 + C ((-13637615775977 / 8639957931 : ℚ)) * X ^ 3 + C ((-7953299227121 / 2879985977 : ℚ)) * X ^ 4 + C ((-566576086036 / 261816907 : ℚ)) * X ^ 5 + C ((-21020628929453 / 8639957931 : ℚ)) * X ^ 6 + C ((-14200302060284 / 8639957931 : ℚ)) * X ^ 7 + C ((-6122061144641 / 8639957931 : ℚ)) * X ^ 8
def CW_201_qim : Polynomial ℚ := C ((14731210604167 / 8639957931 : ℚ)) + C ((14731210604167 / 8639957931 : ℚ)) * X + C ((45094639315 / 23801537 : ℚ)) * X ^ 2 + C ((20019635414723 / 8639957931 : ℚ)) * X ^ 3 + C ((8962184452466 / 8639957931 : ℚ)) * X ^ 4 + C ((1389432691004 / 2879985977 : ℚ)) * X ^ 5 + C ((1712524568360 / 8639957931 : ℚ)) * X ^ 6 + C ((-9607315240562 / 8639957931 : ℚ)) * X ^ 7 + C ((-6149236112869 / 8639957931 : ℚ)) * X ^ 8
theorem CW_coeff_201_poly_re :
    CW_201_0_pre + CW_201_1_pre + CW_201_2_pre + CW_3_re_200 = (0 : Polynomial ℚ) + Phi11 * CW_201_qre := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [CW_201_0_pre, CW_201_1_pre, CW_201_2_pre, CW_3_re_200, CW_201_qre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try ring
theorem CW_coeff_201_poly_im :
    CW_201_0_pim + CW_201_1_pim + CW_201_2_pim + CW_3_im_200 = (0 : Polynomial ℚ) + Phi11 * CW_201_qim := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [CW_201_0_pim, CW_201_1_pim, CW_201_2_pim, CW_3_im_200, CW_201_qim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try ring
public theorem CW_coeff_201_eq :
    CW_coeff_201 = (0 : Ki) := by
  rw [CW_coeff_201_sum, CW_coeff_201_poly_re,
    CW_coeff_201_poly_im, ofLadj_add_Phi11]
  exact ofLadj_zero

end V14Formalization.D12SigmaPlusSegreCore
