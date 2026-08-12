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

def CV_021_0_pre : Polynomial ℚ := C ((501106510253 / 8639957931 : ℚ)) + C ((496047878465200 / 8639957931 : ℚ)) * X + C ((939699255905257 / 8639957931 : ℚ)) * X ^ 2 + C ((1617918268633676 / 8639957931 : ℚ)) * X ^ 3 + C ((880048274307310 / 2879985977 : ℚ)) * X ^ 4 + C ((3406488240244165 / 8639957931 : ℚ)) * X ^ 5 + C ((4152901862216485 / 8639957931 : ℚ)) * X ^ 6 + C ((4754488333852562 / 8639957931 : ℚ)) * X ^ 7 + C ((4834323551793775 / 8639957931 : ℚ)) * X ^ 8 + C ((5003069318516149 / 8639957931 : ℚ)) * X ^ 9 + C ((5131854448681750 / 8639957931 : ℚ)) * X ^ 10 + C ((156950876405168 / 261816907 : ℚ)) * X ^ 11 + C ((1545268856738850 / 2879985977 : ℚ)) * X ^ 12 + C ((123132426139724 / 261816907 : ℚ)) * X ^ 13 + C ((3216405283160099 / 8639957931 : ℚ)) * X ^ 14 + C ((2039185281961913 / 8639957931 : ℚ)) * X ^ 15 + C ((4422368389707 / 32359393 : ℚ)) * X ^ 16 + C ((144786246026483 / 2879985977 : ℚ)) * X ^ 17 + C ((-25052742989573 / 2879985977 : ℚ)) * X ^ 18
def CV_021_0_pim : Polynomial ℚ := C ((-152655807046125 / 2879985977 : ℚ)) + C ((-305311614092250 / 2879985977 : ℚ)) * X + C ((-1237583624947612 / 8639957931 : ℚ)) * X ^ 2 + C ((-1738131241659359 / 8639957931 : ℚ)) * X ^ 3 + C ((-1818516418606241 / 8639957931 : ℚ)) * X ^ 4 + C ((-539116101287308 / 2879985977 : ℚ)) * X ^ 5 + C ((-1417899710898601 / 8639957931 : ℚ)) * X ^ 6 + C ((-281448208197118 / 2879985977 : ℚ)) * X ^ 7 + C ((-144309692074851 / 2879985977 : ℚ)) * X ^ 8 + C ((-136265907957928 / 2879985977 : ℚ)) * X ^ 9 + C ((-297106689104680 / 8639957931 : ℚ)) * X ^ 10 + C ((108120696001220 / 2879985977 : ℚ)) * X ^ 11 + C ((945830865112000 / 8639957931 : ℚ)) * X ^ 12 + C ((1379170682551966 / 8639957931 : ℚ)) * X ^ 13 + C ((15734294641442 / 71404611 : ℚ)) * X ^ 14 + C ((173955186769724 / 785450721 : ℚ)) * X ^ 15 + C ((1568838084923350 / 8639957931 : ℚ)) * X ^ 16 + C ((36339371623265 / 261816907 : ℚ)) * X ^ 17 + C ((482143322461201 / 8639957931 : ℚ)) * X ^ 18
theorem CV_021_0_pre_eq :
    CV_0_re_001 * Fplus_dU_re_020 - CV_0_im_001 * Fplus_dU_im_020 = CV_021_0_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_0_re_001, CV_0_im_001, Fplus_dU_re_020, Fplus_dU_im_020, CV_021_0_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CV_021_0_pim_eq :
    CV_0_re_001 * Fplus_dU_im_020 + CV_0_im_001 * Fplus_dU_re_020 = CV_021_0_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_0_re_001, CV_0_im_001, Fplus_dU_re_020, Fplus_dU_im_020, CV_021_0_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CV_021_0_mul :
    CV_0_c_001 * Fplus_dU_c_020 = ofLadj CV_021_0_pre CV_021_0_pim := by
  rw [CV_0_c_001, Fplus_dU_c_020, ofLadj_mul, CV_021_0_pre_eq, CV_021_0_pim_eq]

def CV_021_1_pre : Polynomial ℚ := C ((-15905487837478 / 2879985977 : ℚ)) + C ((-155812553581304 / 2879985977 : ℚ)) * X + C ((-271107669687577 / 2879985977 : ℚ)) * X ^ 2 + C ((-438063069367397 / 2879985977 : ℚ)) * X ^ 3 + C ((-661965039167478 / 2879985977 : ℚ)) * X ^ 4 + C ((-68412687189381 / 261816907 : ℚ)) * X ^ 5 + C ((-78466210710421 / 261816907 : ℚ)) * X ^ 6 + C ((-990708332770776 / 2879985977 : ℚ)) * X ^ 7 + C ((-92202703968150 / 261816907 : ℚ)) * X ^ 8 + C ((-1093512579805781 / 2879985977 : ℚ)) * X ^ 9 + C ((-1153984686559008 / 2879985977 : ℚ)) * X ^ 10 + C ((-1160691949785878 / 2879985977 : ℚ)) * X ^ 11 + C ((-998172132977704 / 2879985977 : ℚ)) * X ^ 12 + C ((-822404910118204 / 2879985977 : ℚ)) * X ^ 13 + C ((-576166674282253 / 2879985977 : ℚ)) * X ^ 14 + C ((-279467254482082 / 2879985977 : ℚ)) * X ^ 15 + C ((-145594009120755 / 2879985977 : ℚ)) * X ^ 16 + C ((-35005250389315 / 2879985977 : ℚ)) * X ^ 17 + C ((49276039121216 / 2879985977 : ℚ)) * X ^ 18
def CV_021_1_pim : Polynomial ℚ := C ((89430102069576 / 2879985977 : ℚ)) + C ((178860204139152 / 2879985977 : ℚ)) * X + C ((205886779928593 / 2879985977 : ℚ)) * X ^ 2 + C ((267297722874986 / 2879985977 : ℚ)) * X ^ 3 + C ((200940640820373 / 2879985977 : ℚ)) * X ^ 4 + C ((90586999644811 / 2879985977 : ℚ)) * X ^ 5 + C ((61224748630465 / 2879985977 : ℚ)) * X ^ 6 + C ((-4651516324561 / 261816907 : ℚ)) * X ^ 7 + C ((-136430707224842 / 2879985977 : ℚ)) * X ^ 8 + C ((-147785055795549 / 2879985977 : ℚ)) * X ^ 9 + C ((-18202928379435 / 261816907 : ℚ)) * X ^ 10 + C ((-366484061668796 / 2879985977 : ℚ)) * X ^ 11 + C ((-532735911163807 / 2879985977 : ℚ)) * X ^ 12 + C ((-55655422121044 / 261816907 : ℚ)) * X ^ 13 + C ((-684974934848584 / 2879985977 : ℚ)) * X ^ 14 + C ((-585398738909000 / 2879985977 : ℚ)) * X ^ 15 + C ((-407647851262189 / 2879985977 : ℚ)) * X ^ 16 + C ((-298271816211527 / 2879985977 : ℚ)) * X ^ 17 + C ((-10771194685422 / 261816907 : ℚ)) * X ^ 18
theorem CV_021_1_pre_eq :
    CV_1_re_001 * Fplus_dV_re_020 - CV_1_im_001 * Fplus_dV_im_020 = CV_021_1_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_1_re_001, CV_1_im_001, Fplus_dV_re_020, Fplus_dV_im_020, CV_021_1_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CV_021_1_pim_eq :
    CV_1_re_001 * Fplus_dV_im_020 + CV_1_im_001 * Fplus_dV_re_020 = CV_021_1_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_1_re_001, CV_1_im_001, Fplus_dV_re_020, Fplus_dV_im_020, CV_021_1_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CV_021_1_mul :
    CV_1_c_001 * Fplus_dV_c_020 = ofLadj CV_021_1_pre CV_021_1_pim := by
  rw [CV_1_c_001, Fplus_dV_c_020, ofLadj_mul, CV_021_1_pre_eq, CV_021_1_pim_eq]

def CV_021_2_pre : Polynomial ℚ := C ((-64625512530368 / 8639957931 : ℚ)) + C ((-302656068583512 / 2879985977 : ℚ)) * X + C ((-600260298297175 / 2879985977 : ℚ)) * X ^ 2 + C ((-984075695560575 / 2879985977 : ℚ)) * X ^ 3 + C ((-1467658094789280 / 2879985977 : ℚ)) * X ^ 4 + C ((-1747627371330343 / 2879985977 : ℚ)) * X ^ 5 + C ((-5932228610256434 / 8639957931 : ℚ)) * X ^ 6 + C ((-6344583543814207 / 8639957931 : ℚ)) * X ^ 7 + C ((-6045908594227892 / 8639957931 : ℚ)) * X ^ 8 + C ((-5977512546003077 / 8639957931 : ℚ)) * X ^ 9 + C ((-5925433733365001 / 8639957931 : ℚ)) * X ^ 10 + C ((-5841185418316496 / 8639957931 : ℚ)) * X ^ 11 + C ((-5017465527614465 / 8639957931 : ℚ)) * X ^ 12 + C ((-4176731651111552 / 8639957931 : ℚ)) * X ^ 13 + C ((-3093681507546167 / 8639957931 : ℚ)) * X ^ 14 + C ((-568549808675362 / 2879985977 : ℚ)) * X ^ 15 + C ((-903155615932730 / 8639957931 : ℚ)) * X ^ 16 + C ((-71269706555775 / 2879985977 : ℚ)) * X ^ 17 + C ((235959833420281 / 8639957931 : ℚ)) * X ^ 18
def CV_021_2_pim : Polynomial ℚ := C ((618123220772540 / 8639957931 : ℚ)) + C ((1236246441545080 / 8639957931 : ℚ)) * X + C ((1449922622951497 / 8639957931 : ℚ)) * X ^ 2 + C ((580633143902585 / 2879985977 : ℚ)) * X ^ 3 + C ((445059177949455 / 2879985977 : ℚ)) * X ^ 4 + C ((172130009700720 / 2879985977 : ℚ)) * X ^ 5 + C ((-151476683003983 / 8639957931 : ℚ)) * X ^ 6 + C ((-383958626017937 / 2879985977 : ℚ)) * X ^ 7 + C ((-1736068711878652 / 8639957931 : ℚ)) * X ^ 8 + C ((-1726173915168358 / 8639957931 : ℚ)) * X ^ 9 + C ((-560350564872636 / 2879985977 : ℚ)) * X ^ 10 + C ((-2232883239868246 / 8639957931 : ℚ)) * X ^ 11 + C ((-2784714785118584 / 8639957931 : ℚ)) * X ^ 12 + C ((-2953268745974551 / 8639957931 : ℚ)) * X ^ 13 + C ((-1078450252673505 / 2879985977 : ℚ)) * X ^ 14 + C ((-2857381261419878 / 8639957931 : ℚ)) * X ^ 15 + C ((-698846541425125 / 2879985977 : ℚ)) * X ^ 16 + C ((-499297920004738 / 2879985977 : ℚ)) * X ^ 17 + C ((-555440432566088 / 8639957931 : ℚ)) * X ^ 18
theorem CV_021_2_pre_eq :
    CV_2_re_001 * Fplus_dW_re_020 - CV_2_im_001 * Fplus_dW_im_020 = CV_021_2_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_2_re_001, CV_2_im_001, Fplus_dW_re_020, Fplus_dW_im_020, CV_021_2_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CV_021_2_pim_eq :
    CV_2_re_001 * Fplus_dW_im_020 + CV_2_im_001 * Fplus_dW_re_020 = CV_021_2_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_2_re_001, CV_2_im_001, Fplus_dW_re_020, Fplus_dW_im_020, CV_021_2_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CV_021_2_mul :
    CV_2_c_001 * Fplus_dW_c_020 = ofLadj CV_021_2_pre CV_021_2_pim := by
  rw [CV_2_c_001, Fplus_dW_c_020, ofLadj_mul, CV_021_2_pre_eq, CV_021_2_pim_eq]

theorem CV_021_3_mul : CV_3_c_011 = ofLadj CV_3_re_011 CV_3_im_011 := rfl

def CV_coeff_021 : Ki := CV_0_c_001 * Fplus_dU_c_020 + CV_1_c_001 * Fplus_dV_c_020 + CV_2_c_001 * Fplus_dW_c_020 + CV_3_c_011

theorem CV_coeff_021_sum :
    CV_coeff_021 = ofLadj (CV_021_0_pre + CV_021_1_pre + CV_021_2_pre + CV_3_re_011) (CV_021_0_pim + CV_021_1_pim + CV_021_2_pim + CV_3_im_011) := by
  simp only [CV_coeff_021, CV_021_0_mul, CV_021_1_mul, CV_021_2_mul, CV_021_3_mul]
  simpa [add_assoc] using ofLadj_add4 CV_021_0_pre CV_021_0_pim CV_021_1_pre CV_021_1_pim CV_021_2_pre CV_021_2_pim CV_3_re_011 CV_3_im_011

def CV_021_qre : Polynomial ℚ := C ((-111650998056689 / 8639957931 : ℚ)) + C ((-255902329990853 / 2879985977 : ℚ)) * X + C ((-265199679158585 / 2879985977 : ℚ)) * X ^ 2 + C ((-974800071622445 / 8639957931 : ℚ)) * X ^ 3 + C ((-1100910339722408 / 8639957931 : ℚ)) * X ^ 4 + C ((-345700624267193 / 8639957931 : ℚ)) * X ^ 5 + C ((-274699150487405 / 8639957931 : ℚ)) * X ^ 6 + C ((-193095854571031 / 8639957931 : ℚ)) * X ^ 7 + C ((308629721815210 / 8639957931 : ℚ)) * X ^ 8
def CV_021_qim : Polynomial ℚ := C ((143039438875677 / 2879985977 : ℚ)) + C ((143039438875677 / 2879985977 : ℚ)) * X + C ((-2396787280088 / 785450721 : ℚ)) * X ^ 2 + C ((-24301082465252 / 8639957931 : ℚ)) * X ^ 3 + C ((-228785162423957 / 2879985977 : ℚ)) * X ^ 4 + C ((-949425330541322 / 8639957931 : ℚ)) * X ^ 5 + C ((-557135148057542 / 8639957931 : ℚ)) * X ^ 6 + C ((-764763410357237 / 8639957931 : ℚ)) * X ^ 7 + C ((-428746534723813 / 8639957931 : ℚ)) * X ^ 8
theorem CV_coeff_021_poly_re :
    CV_021_0_pre + CV_021_1_pre + CV_021_2_pre + CV_3_re_011 = (0 : Polynomial ℚ) + Phi11 * CV_021_qre := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [CV_021_0_pre, CV_021_1_pre, CV_021_2_pre, CV_3_re_011, CV_021_qre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try ring
theorem CV_coeff_021_poly_im :
    CV_021_0_pim + CV_021_1_pim + CV_021_2_pim + CV_3_im_011 = (0 : Polynomial ℚ) + Phi11 * CV_021_qim := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [CV_021_0_pim, CV_021_1_pim, CV_021_2_pim, CV_3_im_011, CV_021_qim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try ring
theorem CV_coeff_021_eq :
    CV_coeff_021 = (0 : Ki) := by
  rw [CV_coeff_021_sum, CV_coeff_021_poly_re,
    CV_coeff_021_poly_im, ofLadj_add_Phi11]
  exact ofLadj_zero

end V14Formalization.D12SigmaPlusSegreCore
