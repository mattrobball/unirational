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

def CU_210_0_pre : Polynomial ℚ := C ((7197699814182 / 78598333 : ℚ)) + C ((-6355240239274 / 78598333 : ℚ)) * X ^ 2 + C ((-18160405736047 / 78598333 : ℚ)) * X ^ 3 + C ((-55911792930325 / 78598333 : ℚ)) * X ^ 4 + C ((-93894703713856 / 78598333 : ℚ)) * X ^ 5 + C ((-132936989379137 / 78598333 : ℚ)) * X ^ 6 + C ((-164697873550261 / 78598333 : ℚ)) * X ^ 7 + C ((-176721656197311 / 78598333 : ℚ)) * X ^ 8 + C ((-181852619348638 / 78598333 : ℚ)) * X ^ 9 + C ((-185768106431452 / 78598333 : ℚ)) * X ^ 10 + C ((-17675457305082 / 7145303 : ℚ)) * X ^ 11 + C ((-185768106431452 / 78598333 : ℚ)) * X ^ 12 + C ((-175497379109364 / 78598333 : ℚ)) * X ^ 13 + C ((-158561250461264 / 78598333 : ℚ)) * X ^ 14 + C ((-116096995910652 / 78598333 : ℚ)) * X ^ 15 + C ((-75309579092068 / 78598333 : ℚ)) * X ^ 16 + C ((-36267293426787 / 78598333 : ℚ)) * X ^ 17 + C ((-7310915290716 / 78598333 : ℚ)) * X ^ 18
def CU_210_0_pim : Polynomial ℚ := C ((24522925685532 / 78598333 : ℚ)) + C ((49045851371064 / 78598333 : ℚ)) * X + C ((79718520039022 / 78598333 : ℚ)) * X ^ 2 + C ((121324276697209 / 78598333 : ℚ)) * X ^ 3 + C ((147074714027159 / 78598333 : ℚ)) * X ^ 4 + C ((159341061253324 / 78598333 : ℚ)) * X ^ 5 + C ((14783593369307 / 7145303 : ℚ)) * X ^ 6 + C ((138983063010883 / 78598333 : ℚ)) * X ^ 7 + C ((123545387695445 / 78598333 : ℚ)) * X ^ 8 + C ((122806728579662 / 78598333 : ℚ)) * X ^ 9 + C ((119414874669994 / 78598333 : ℚ)) * X ^ 10 + C ((8174308561844 / 7145303 : ℚ)) * X ^ 11 + C ((60419913690574 / 78598333 : ℚ)) * X ^ 12 + C ((26355391112948 / 78598333 : ℚ)) * X ^ 13 + C ((-15989024661022 / 78598333 : ℚ)) * X ^ 14 + C ((-39585608981332 / 78598333 : ℚ)) * X ^ 15 + C ((-47494431034080 / 78598333 : ℚ)) * X ^ 16 + C ((-45585517549989 / 78598333 : ℚ)) * X ^ 17 + C ((-17591528325078 / 78598333 : ℚ)) * X ^ 18
theorem CU_210_0_pre_eq :
    CU_0_re_010 * Fplus_dU_re_200 - CU_0_im_010 * Fplus_dU_im_200 = CU_210_0_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_0_re_010, CU_0_im_010, Fplus_dU_re_200, Fplus_dU_im_200, CU_210_0_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CU_210_0_pim_eq :
    CU_0_re_010 * Fplus_dU_im_200 + CU_0_im_010 * Fplus_dU_re_200 = CU_210_0_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_0_re_010, CU_0_im_010, Fplus_dU_re_200, Fplus_dU_im_200, CU_210_0_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CU_210_0_mul :
    CU_0_c_010 * Fplus_dU_c_200 = ofLadj CU_210_0_pre CU_210_0_pim := by
  rw [CU_0_c_010, Fplus_dU_c_200, ofLadj_mul, CU_210_0_pre_eq, CU_210_0_pim_eq]

def CU_210_1_pre : Polynomial ℚ := C ((402456139931 / 235794999 : ℚ)) + C ((-55306984964312 / 235794999 : ℚ)) * X + C ((-110585309923112 / 235794999 : ℚ)) * X ^ 2 + C ((-60024836413110 / 78598333 : ℚ)) * X ^ 3 + C ((-101518103385324 / 78598333 : ℚ)) * X ^ 4 + C ((-129986821648342 / 78598333 : ℚ)) * X ^ 5 + C ((-156707019352097 / 78598333 : ℚ)) * X ^ 6 + C ((-45918746235163 / 21435909 : ℚ)) * X ^ 7 + C ((-156741124089652 / 78598333 : ℚ)) * X ^ 8 + C ((-445221445099418 / 235794999 : ℚ)) * X ^ 9 + C ((-426134514807274 / 235794999 : ℚ)) * X ^ 10 + C ((-139800569958664 / 78598333 : ℚ)) * X ^ 11 + C ((-370827529842962 / 235794999 : ℚ)) * X ^ 12 + C ((-111545378392102 / 78598333 : ℚ)) * X ^ 13 + C ((-96716287676542 / 78598333 : ℚ)) * X ^ 14 + C ((-188638350093920 / 235794999 : ℚ)) * X ^ 15 + C ((-116902635349237 / 235794999 : ℚ)) * X ^ 16 + C ((-36742042237972 / 235794999 : ℚ)) * X ^ 17 + C ((3971182778967 / 78598333 : ℚ)) * X ^ 18
def CU_210_1_pim : Polynomial ℚ := C ((17486366079449 / 78598333 : ℚ)) + C ((34972732158898 / 78598333 : ℚ)) * X + C ((45177329555988 / 78598333 : ℚ)) * X ^ 2 + C ((61981776525934 / 78598333 : ℚ)) * X ^ 3 + C ((187155322709600 / 235794999 : ℚ)) * X ^ 4 + C ((137363227076894 / 235794999 : ℚ)) * X ^ 5 + C ((82343566951823 / 235794999 : ℚ)) * X ^ 6 + C ((-7693110098391 / 78598333 : ℚ)) * X ^ 7 + C ((-80383331418634 / 235794999 : ℚ)) * X ^ 8 + C ((-25595326760658 / 78598333 : ℚ)) * X ^ 9 + C ((-60256950107932 / 235794999 : ℚ)) * X ^ 10 + C ((-243719325786 / 649573 : ℚ)) * X ^ 11 + C ((-116683280412704 / 235794999 : ℚ)) * X ^ 12 + C ((-43589347476644 / 78598333 : ℚ)) * X ^ 13 + C ((-177584032203110 / 235794999 : ℚ)) * X ^ 14 + C ((-189286290854966 / 235794999 : ℚ)) * X ^ 15 + C ((-160733350288063 / 235794999 : ℚ)) * X ^ 16 + C ((-43665159261532 / 78598333 : ℚ)) * X ^ 17 + C ((-15603911867801 / 78598333 : ℚ)) * X ^ 18
theorem CU_210_1_pre_eq :
    CU_1_re_010 * Fplus_dV_re_200 - CU_1_im_010 * Fplus_dV_im_200 = CU_210_1_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_1_re_010, CU_1_im_010, Fplus_dV_re_200, Fplus_dV_im_200, CU_210_1_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CU_210_1_pim_eq :
    CU_1_re_010 * Fplus_dV_im_200 + CU_1_im_010 * Fplus_dV_re_200 = CU_210_1_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_1_re_010, CU_1_im_010, Fplus_dV_re_200, Fplus_dV_im_200, CU_210_1_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CU_210_1_mul :
    CU_1_c_010 * Fplus_dV_c_200 = ofLadj CU_210_1_pre CU_210_1_pim := by
  rw [CU_1_c_010, Fplus_dV_c_200, ofLadj_mul, CU_210_1_pre_eq, CU_210_1_pim_eq]

def CU_210_2_pre : Polynomial ℚ := C ((15335741382260 / 235794999 : ℚ)) + C ((108763579585184 / 235794999 : ℚ)) * X + C ((205234104488108 / 235794999 : ℚ)) * X ^ 2 + C ((323279497997155 / 235794999 : ℚ)) * X ^ 3 + C ((41802729268720 / 21435909 : ℚ)) * X ^ 4 + C ((175673044870478 / 78598333 : ℚ)) * X ^ 5 + C ((577226801086339 / 235794999 : ℚ)) * X ^ 6 + C ((600324644697464 / 235794999 : ℚ)) * X ^ 7 + C ((555873491297642 / 235794999 : ℚ)) * X ^ 8 + C ((547452933858145 / 235794999 : ℚ)) * X ^ 9 + C ((541004865684133 / 235794999 : ℚ)) * X ^ 10 + C ((174415571631052 / 78598333 : ℚ)) * X ^ 11 + C ((432241286098949 / 235794999 : ℚ)) * X ^ 12 + C ((342218829370037 / 235794999 : ℚ)) * X ^ 13 + C ((232593993300487 / 235794999 : ℚ)) * X ^ 14 + C ((103787096708116 / 235794999 : ℚ)) * X ^ 15 + C ((41228652823394 / 235794999 : ℚ)) * X ^ 16 + C ((-8979013651511 / 235794999 : ℚ)) * X ^ 17 + C ((-36707526033428 / 235794999 : ℚ)) * X ^ 18
def CU_210_2_pim : Polynomial ℚ := C ((-48689778020468 / 235794999 : ℚ)) + C ((-97379556040936 / 235794999 : ℚ)) * X + C ((-92996649858368 / 235794999 : ℚ)) * X ^ 2 + C ((-92399187737881 / 235794999 : ℚ)) * X ^ 3 + C ((-24621744349762 / 235794999 : ℚ)) * X ^ 4 + C ((79681251249262 / 235794999 : ℚ)) * X ^ 5 + C ((53285738568681 / 78598333 : ℚ)) * X ^ 6 + C ((262181814844564 / 235794999 : ℚ)) * X ^ 7 + C ((318628327883506 / 235794999 : ℚ)) * X ^ 8 + C ((105806917972141 / 78598333 : ℚ)) * X ^ 9 + C ((311859910944947 / 235794999 : ℚ)) * X ^ 10 + C ((352357169926220 / 235794999 : ℚ)) * X ^ 11 + C ((392854428907493 / 235794999 : ℚ)) * X ^ 12 + C ((382910679753449 / 235794999 : ℚ)) * X ^ 13 + C ((11548655868663 / 7145303 : ℚ)) * X ^ 14 + C ((105617523549378 / 78598333 : ℚ)) * X ^ 15 + C ((19973763889766 / 21435909 : ℚ)) * X ^ 16 + C ((13462264915343 / 21435909 : ℚ)) * X ^ 17 + C ((17640714222856 / 78598333 : ℚ)) * X ^ 18
theorem CU_210_2_pre_eq :
    CU_2_re_010 * Fplus_dW_re_200 - CU_2_im_010 * Fplus_dW_im_200 = CU_210_2_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_2_re_010, CU_2_im_010, Fplus_dW_re_200, Fplus_dW_im_200, CU_210_2_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CU_210_2_pim_eq :
    CU_2_re_010 * Fplus_dW_im_200 + CU_2_im_010 * Fplus_dW_re_200 = CU_210_2_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_2_re_010, CU_2_im_010, Fplus_dW_re_200, Fplus_dW_im_200, CU_210_2_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CU_210_2_mul :
    CU_2_c_010 * Fplus_dW_c_200 = ofLadj CU_210_2_pre CU_210_2_pim := by
  rw [CU_2_c_010, Fplus_dW_c_200, ofLadj_mul, CU_210_2_pre_eq, CU_210_2_pim_eq]

theorem CU_210_3_mul : CU_3_c_110 = ofLadj CU_3_re_110 CU_3_im_110 := rfl

@[expose] public def CU_coeff_210 : Ki := CU_0_c_010 * Fplus_dU_c_200 + CU_1_c_010 * Fplus_dV_c_200 + CU_2_c_010 * Fplus_dW_c_200 + CU_3_c_110

theorem CU_coeff_210_sum :
    CU_coeff_210 = ofLadj (CU_210_0_pre + CU_210_1_pre + CU_210_2_pre + CU_3_re_110) (CU_210_0_pim + CU_210_1_pim + CU_210_2_pim + CU_3_im_110) := by
  simp only [CU_coeff_210, CU_210_0_mul, CU_210_1_mul, CU_210_2_mul, CU_210_3_mul]
  simpa [add_assoc] using ofLadj_add4 CU_210_0_pre CU_210_0_pim CU_210_1_pre CU_210_1_pim CU_210_2_pre CU_210_2_pim CU_3_re_110 CU_3_im_110

def CU_210_qre : Polynomial ℚ := C ((12337039211015 / 78598333 : ℚ)) + C ((5481825662609 / 78598333 : ℚ)) * X + C ((2092625463272 / 21435909 : ℚ)) * X ^ 2 + C ((14329177978570 / 235794999 : ℚ)) * X ^ 3 + C ((-100096379995171 / 235794999 : ℚ)) * X ^ 4 + C ((-131539521315713 / 235794999 : ℚ)) * X ^ 5 + C ((-147079783632203 / 235794999 : ℚ)) * X ^ 6 + C ((-107796212601169 / 235794999 : ℚ)) * X ^ 7 + C ((-46726723568675 / 235794999 : ℚ)) * X ^ 8
def CU_210_qim : Polynomial ℚ := C ((76208347640243 / 235794999 : ℚ)) + C ((76208347640243 / 235794999 : ℚ)) * X + C ((126222078904150 / 235794999 : ℚ)) * X ^ 2 + C ((175654273182658 / 235794999 : ℚ)) * X ^ 3 + C ((48915028210177 / 78598333 : ℚ)) * X ^ 4 + C ((92314693452049 / 235794999 : ℚ)) * X ^ 5 + C ((36161875762913 / 235794999 : ℚ)) * X ^ 6 + C ((-73002938455721 / 235794999 : ℚ)) * X ^ 7 + C ((-15554725970023 / 78598333 : ℚ)) * X ^ 8
theorem CU_coeff_210_poly_re :
    CU_210_0_pre + CU_210_1_pre + CU_210_2_pre + CU_3_re_110 = (0 : Polynomial ℚ) + Phi11 * CU_210_qre := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [CU_210_0_pre, CU_210_1_pre, CU_210_2_pre, CU_3_re_110, CU_210_qre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try grind
theorem CU_coeff_210_poly_im :
    CU_210_0_pim + CU_210_1_pim + CU_210_2_pim + CU_3_im_110 = (0 : Polynomial ℚ) + Phi11 * CU_210_qim := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [CU_210_0_pim, CU_210_1_pim, CU_210_2_pim, CU_3_im_110, CU_210_qim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try grind
public theorem CU_coeff_210_eq :
    CU_coeff_210 = (0 : Ki) := by
  rw [CU_coeff_210_sum, CU_coeff_210_poly_re,
    CU_coeff_210_poly_im, ofLadj_add_Phi11]
  exact ofLadj_zero

end V14Formalization.D12SigmaPlusSegreCore
