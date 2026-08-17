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

def CU_211_0_pre : Polynomial ℚ := C ((-14935692236676 / 78598333 : ℚ)) + C ((13160619829712 / 78598333 : ℚ)) * X ^ 2 + C ((37609483795324 / 78598333 : ℚ)) * X ^ 3 + C ((115865712669908 / 78598333 : ℚ)) * X ^ 4 + C ((194587053461384 / 78598333 : ℚ)) * X ^ 5 + C ((275479630738804 / 78598333 : ℚ)) * X ^ 6 + C ((341304909902850 / 78598333 : ℚ)) * X ^ 7 + C ((366232269191380 / 78598333 : ℚ)) * X ^ 8 + C ((376863540144042 / 78598333 : ℚ)) * X ^ 9 + C ((384980440761666 / 78598333 : ℚ)) * X ^ 10 + C ((402950357160284 / 78598333 : ℚ)) * X ^ 11 + C ((384980440761666 / 78598333 : ℚ)) * X ^ 12 + C ((363702920314330 / 78598333 : ℚ)) * X ^ 13 + C ((328622785396056 / 78598333 : ℚ)) * X ^ 14 + C ((240599238008918 / 78598333 : ℚ)) * X ^ 15 + C ((14187673975430 / 7145303 : ℚ)) * X ^ 16 + C ((75171836452310 / 78598333 : ℚ)) * X ^ 17 + C ((15160040775976 / 78598333 : ℚ)) * X ^ 18
def CU_211_0_pim : Polynomial ℚ := C ((-50831760944772 / 78598333 : ℚ)) + C ((-101663521889544 / 78598333 : ℚ)) * X + C ((-165216012717412 / 78598333 : ℚ)) * X ^ 2 + C ((-251458165717496 / 78598333 : ℚ)) * X ^ 3 + C ((-304840420345704 / 78598333 : ℚ)) * X ^ 4 + C ((-330250263111984 / 78598333 : ℚ)) * X ^ 5 + C ((-337040843972356 / 78598333 : ℚ)) * X ^ 6 + C ((-288071533480574 / 78598333 : ℚ)) * X ^ 7 + C ((-256083383496126 / 78598333 : ℚ)) * X ^ 8 + C ((-254553799502598 / 78598333 : ℚ)) * X ^ 9 + C ((-247525317209902 / 78598333 : ℚ)) * X ^ 10 + C ((-16943920314924 / 7145303 : ℚ)) * X ^ 11 + C ((-125240929718426 / 78598333 : ℚ)) * X ^ 12 + C ((-4969086963442 / 7145303 : ℚ)) * X ^ 13 + C ((33111780395750 / 78598333 : ℚ)) * X ^ 14 + C ((82032819389658 / 78598333 : ℚ)) * X ^ 15 + C ((98410854178422 / 78598333 : ℚ)) * X ^ 16 + C ((94450484088046 / 78598333 : ℚ)) * X ^ 17 + C ((36449365618748 / 78598333 : ℚ)) * X ^ 18
theorem CU_211_0_pre_eq :
    CU_0_re_011 * Fplus_dU_re_200 - CU_0_im_011 * Fplus_dU_im_200 = CU_211_0_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_0_re_011, CU_0_im_011, Fplus_dU_re_200, Fplus_dU_im_200, CU_211_0_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CU_211_0_pim_eq :
    CU_0_re_011 * Fplus_dU_im_200 + CU_0_im_011 * Fplus_dU_re_200 = CU_211_0_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_0_re_011, CU_0_im_011, Fplus_dU_re_200, Fplus_dU_im_200, CU_211_0_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CU_211_0_mul :
    CU_0_c_011 * Fplus_dU_c_200 = ofLadj CU_211_0_pre CU_211_0_pim := by
  rw [CU_0_c_011, Fplus_dU_c_200, ofLadj_mul, CU_211_0_pre_eq, CU_211_0_pim_eq]

def CU_211_1_pre : Polynomial ℚ := C ((-832470887276 / 235794999 : ℚ)) + C ((121142661053008 / 235794999 : ℚ)) * X + C ((242273306770718 / 235794999 : ℚ)) * X ^ 2 + C ((394779163335928 / 235794999 : ℚ)) * X ^ 3 + C ((667416719329612 / 235794999 : ℚ)) * X ^ 4 + C ((284821768188554 / 78598333 : ℚ)) * X ^ 5 + C ((343464225948480 / 78598333 : ℚ)) * X ^ 6 + C ((369006673774718 / 78598333 : ℚ)) * X ^ 7 + C ((1030452421466932 / 235794999 : ℚ)) * X ^ 8 + C ((975640416795386 / 235794999 : ℚ)) * X ^ 9 + C ((933808955107090 / 235794999 : ℚ)) * X ^ 10 + C ((919026208486324 / 235794999 : ℚ)) * X ^ 11 + C ((270888764684694 / 78598333 : ℚ)) * X ^ 12 + C ((244455703341556 / 78598333 : ℚ)) * X ^ 13 + C ((211891086043668 / 78598333 : ℚ)) * X ^ 14 + C ((37580956005424 / 21435909 : ℚ)) * X ^ 15 + C ((85427490641458 / 78598333 : ℚ)) * X ^ 16 + C ((26785032881532 / 78598333 : ℚ)) * X ^ 17 + C ((-8737595311626 / 78598333 : ℚ)) * X ^ 18
def CU_211_1_pim : Polynomial ℚ := C ((-114890724464390 / 235794999 : ℚ)) + C ((-229781448928780 / 235794999 : ℚ)) * X + C ((-297014541511702 / 235794999 : ℚ)) * X ^ 2 + C ((-135806912140962 / 78598333 : ℚ)) * X ^ 3 + C ((-136615546969360 / 78598333 : ℚ)) * X ^ 4 + C ((-300946360679684 / 235794999 : ℚ)) * X ^ 5 + C ((-60118898461266 / 78598333 : ℚ)) * X ^ 6 + C ((50910416256278 / 235794999 : ℚ)) * X ^ 7 + C ((176505292151960 / 235794999 : ℚ)) * X ^ 8 + C ((56205769028436 / 78598333 : ℚ)) * X ^ 9 + C ((132368056264282 / 235794999 : ℚ)) * X ^ 10 + C ((194130774784684 / 235794999 : ℚ)) * X ^ 11 + C ((255893493305086 / 235794999 : ℚ)) * X ^ 12 + C ((26079757733362 / 21435909 : ℚ)) * X ^ 13 + C ((389395544911514 / 235794999 : ℚ)) * X ^ 14 + C ((414831436193066 / 235794999 : ℚ)) * X ^ 15 + C ((117498102952168 / 78598333 : ℚ)) * X ^ 16 + C ((95762949282522 / 78598333 : ℚ)) * X ^ 17 + C ((34194963033108 / 78598333 : ℚ)) * X ^ 18
theorem CU_211_1_pre_eq :
    CU_1_re_011 * Fplus_dV_re_200 - CU_1_im_011 * Fplus_dV_im_200 = CU_211_1_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_1_re_011, CU_1_im_011, Fplus_dV_re_200, Fplus_dV_im_200, CU_211_1_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CU_211_1_pim_eq :
    CU_1_re_011 * Fplus_dV_im_200 + CU_1_im_011 * Fplus_dV_re_200 = CU_211_1_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_1_re_011, CU_1_im_011, Fplus_dV_re_200, Fplus_dV_im_200, CU_211_1_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CU_211_1_mul :
    CU_1_c_011 * Fplus_dV_c_200 = ofLadj CU_211_1_pre CU_211_1_pim := by
  rw [CU_1_c_011, Fplus_dV_c_200, ofLadj_mul, CU_211_1_pre_eq, CU_211_1_pim_eq]

def CU_211_2_pre : Polynomial ℚ := C ((-36994005448600 / 235794999 : ℚ)) + C ((-264250456343872 / 235794999 : ℚ)) * X + C ((-498192618884560 / 235794999 : ℚ)) * X ^ 2 + C ((-783268050823766 / 235794999 : ℚ)) * X ^ 3 + C ((-1115142768568232 / 235794999 : ℚ)) * X ^ 4 + C ((-1278465282610268 / 235794999 : ℚ)) * X ^ 5 + C ((-466438135676328 / 78598333 : ℚ)) * X ^ 6 + C ((-132338689342538 / 21435909 : ℚ)) * X ^ 7 + C ((-449529094926200 / 78598333 : ℚ)) * X ^ 8 + C ((-442711196366072 / 78598333 : ℚ)) * X ^ 9 + C ((-1312540846249340 / 235794999 : ℚ)) * X ^ 10 + C ((-38476605659920 / 7145303 : ℚ)) * X ^ 11 + C ((-1048290389905468 / 235794999 : ℚ)) * X ^ 12 + C ((-829940970213656 / 235794999 : ℚ)) * X ^ 13 + C ((-565319233954834 / 235794999 : ℚ)) * X ^ 14 + C ((-252225685304366 / 235794999 : ℚ)) * X ^ 15 + C ((-100059939980806 / 235794999 : ℚ)) * X ^ 16 + C ((6929728145970 / 78598333 : ℚ)) * X ^ 17 + C ((29452376298440 / 78598333 : ℚ)) * X ^ 18
def CU_211_2_pim : Polynomial ℚ := C ((39490997851288 / 78598333 : ℚ)) + C ((78981995702576 / 78598333 : ℚ)) * X + C ((20487548946248 / 21435909 : ℚ)) * X ^ 2 + C ((224558435004958 / 235794999 : ℚ)) * X ^ 3 + C ((61284760316852 / 235794999 : ℚ)) * X ^ 4 + C ((-192338236724608 / 235794999 : ℚ)) * X ^ 5 + C ((-386418690007726 / 235794999 : ℚ)) * X ^ 6 + C ((-633443531455846 / 235794999 : ℚ)) * X ^ 7 + C ((-770482641871120 / 235794999 : ℚ)) * X ^ 8 + C ((-23258628514144 / 7145303 : ℚ)) * X ^ 9 + C ((-251336008397970 / 78598333 : ℚ)) * X ^ 10 + C ((-852673389205304 / 235794999 : ℚ)) * X ^ 11 + C ((-86485341201518 / 21435909 : ℚ)) * X ^ 12 + C ((-926229088744856 / 235794999 : ℚ)) * X ^ 13 + C ((-922476584436718 / 235794999 : ℚ)) * X ^ 14 + C ((-255932228992266 / 78598333 : ℚ)) * X ^ 15 + C ((-531538147492232 / 235794999 : ℚ)) * X ^ 16 + C ((-119368572359438 / 78598333 : ℚ)) * X ^ 17 + C ((-128445333187088 / 235794999 : ℚ)) * X ^ 18
theorem CU_211_2_pre_eq :
    CU_2_re_011 * Fplus_dW_re_200 - CU_2_im_011 * Fplus_dW_im_200 = CU_211_2_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_2_re_011, CU_2_im_011, Fplus_dW_re_200, Fplus_dW_im_200, CU_211_2_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CU_211_2_pim_eq :
    CU_2_re_011 * Fplus_dW_im_200 + CU_2_im_011 * Fplus_dW_re_200 = CU_211_2_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_2_re_011, CU_2_im_011, Fplus_dW_re_200, Fplus_dW_im_200, CU_211_2_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CU_211_2_mul :
    CU_2_c_011 * Fplus_dW_c_200 = ofLadj CU_211_2_pre CU_211_2_pim := by
  rw [CU_2_c_011, Fplus_dW_c_200, ofLadj_mul, CU_211_2_pre_eq, CU_211_2_pim_eq]

theorem CU_211_3_mul : CU_3_c_111 = ofLadj CU_3_re_111 CU_3_im_111 := rfl

@[expose] public def CU_coeff_211 : Ki := CU_0_c_011 * Fplus_dU_c_200 + CU_1_c_011 * Fplus_dV_c_200 + CU_2_c_011 * Fplus_dW_c_200 + CU_3_c_111

theorem CU_coeff_211_sum :
    CU_coeff_211 = ofLadj (CU_211_0_pre + CU_211_1_pre + CU_211_2_pre + CU_3_re_111) (CU_211_0_pim + CU_211_1_pim + CU_211_2_pim + CU_3_im_111) := by
  simp only [CU_coeff_211, CU_211_0_mul, CU_211_1_mul, CU_211_2_mul, CU_211_3_mul]
  simpa [add_assoc] using ofLadj_add4 CU_211_0_pre CU_211_0_pim CU_211_1_pre CU_211_1_pim CU_211_2_pre CU_211_2_pim CU_3_re_111 CU_3_im_111

def CU_211_qre : Polynomial ℚ := C ((-81939862047068 / 235794999 : ℚ)) + C ((-61167933243796 / 235794999 : ℚ)) * X + C ((-75217674320390 / 235794999 : ℚ)) * X ^ 2 + C ((-61687479610336 / 235794999 : ℚ)) * X ^ 3 + C ((173259835582286 / 235794999 : ℚ)) * X ^ 4 + C ((258546771649294 / 235794999 : ℚ)) * X ^ 5 + C ((297755980693322 / 235794999 : ℚ)) * X ^ 6 + C ((73011775717022 / 78598333 : ℚ)) * X ^ 7 + C ((35874821762790 / 78598333 : ℚ)) * X ^ 8
def CU_211_qim : Polynomial ℚ := C ((-146523935746222 / 235794999 : ℚ)) + C ((-146523935746222 / 235794999 : ℚ)) * X + C ((-89278808531810 / 78598333 : ℚ)) * X ^ 2 + C ((-369585925133506 / 235794999 : ℚ)) * X ^ 3 + C ((-326878905723196 / 235794999 : ℚ)) * X ^ 4 + C ((-223055516514296 / 235794999 : ℚ)) * X ^ 5 + C ((-96345859133852 / 235794999 : ℚ)) * X ^ 6 + C ((129046930264910 / 235794999 : ℚ)) * X ^ 7 + C ((83487652768480 / 235794999 : ℚ)) * X ^ 8
theorem CU_coeff_211_poly_re :
    CU_211_0_pre + CU_211_1_pre + CU_211_2_pre + CU_3_re_111 = (0 : Polynomial ℚ) + Phi11 * CU_211_qre := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [CU_211_0_pre, CU_211_1_pre, CU_211_2_pre, CU_3_re_111, CU_211_qre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try ring
theorem CU_coeff_211_poly_im :
    CU_211_0_pim + CU_211_1_pim + CU_211_2_pim + CU_3_im_111 = (0 : Polynomial ℚ) + Phi11 * CU_211_qim := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [CU_211_0_pim, CU_211_1_pim, CU_211_2_pim, CU_3_im_111, CU_211_qim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try ring
public theorem CU_coeff_211_eq :
    CU_coeff_211 = (0 : Ki) := by
  rw [CU_coeff_211_sum, CU_coeff_211_poly_re,
    CU_coeff_211_poly_im, ofLadj_add_Phi11]
  exact ofLadj_zero

end V14Formalization.D12SigmaPlusSegreCore
