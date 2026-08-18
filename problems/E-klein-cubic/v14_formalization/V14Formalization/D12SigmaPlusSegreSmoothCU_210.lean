/-
Auto-generated Fplus chart Nullstellensatz identities.
-/
module

public import V14Formalization.D12SigmaPlusSegreEval
public import V14Formalization.D12SigmaPlusSegreMul
public import V14Formalization.D12SigmaPlusSegrePartials
public import V14Formalization.D12SigmaPlusSegreBezoutData
public import V14Formalization.D12PolyZReflection
public import V14Formalization.D12SigmaPlusSegreFplusZ

noncomputable section
open Matrix Polynomial
namespace V14Formalization.D12SigmaPlusSegreCore
open D12PolynomialData
open V14Formalization.D12PolyZReflection

def CU_210_0_pre : Polynomial ℚ := interpQ 235794999 [21593099442546, 0, -19065720717822, -54481217208141, -167735378790975, -281684111141568, -398810968137411, -494093620650783, -530164968591933, -545557858045914, -557304319294356, -583290091067706, -557304319294356, -526492137328092, -475683751383792, -348290987731956, -225928737276204, -108801880280361, -21932745872148]
def CU_210_0_pim : Polynomial ℚ := interpQ 235794999 [73568777056596, 147137554113192, 239155560117066, 363972830091627, 441224142081477, 478023183759972, 487858581187131, 416949189032649, 370636163086335, 368420185738986, 358244624009982, 269752182540852, 181259741071722, 79066173338844, -47967073983066, -118756826943996, -142483293102240, -136756552649967, -52774584975234]
theorem CU_210_0_pre_eq :
    CU_0_re_010 * Fplus_dU_re_200 - CU_0_im_010 * Fplus_dU_im_200 = CU_210_0_pre := by
  simp only [CU_0_re_010_def, CU_0_im_010_def, Fplus_dU_re_200_def, Fplus_dU_im_200_def, CU_210_0_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_210_0_pim_eq :
    CU_0_re_010 * Fplus_dU_im_200 + CU_0_im_010 * Fplus_dU_re_200 = CU_210_0_pim := by
  simp only [CU_0_re_010_def, CU_0_im_010_def, Fplus_dU_re_200_def, Fplus_dU_im_200_def, CU_210_0_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_210_0_mul :
    CU_0_c_010 * Fplus_dU_c_200 = ofLadj CU_210_0_pre CU_210_0_pim := by
  rw [CU_0_c_010_def, Fplus_dU_c_200_def, ofLadj_mul, CU_210_0_pre_eq, CU_210_0_pim_eq]

def CU_210_1_pre : Polynomial ℚ := interpQ 235794999 [402456139931, -55306984964312, -110585309923112, -180074509239330, -304554310155972, -389960464945026, -470121058056291, -505106208586793, -470223372268956, -445221445099418, -426134514807274, -419401709875992, -370827529842962, -334636135176306, -290148863029626, -188638350093920, -116902635349237, -36742042237972, 11913548336901]
def CU_210_1_pim : Polynomial ℚ := interpQ 235794999 [52459098238347, 104918196476694, 135531988667964, 185945329577802, 187155322709600, 137363227076894, 82343566951823, -23079330295173, -80383331418634, -76785980281974, -60256950107932, -88470115260318, -116683280412704, -130768042429932, -177584032203110, -189286290854966, -160733350288063, -130995477784596, -46811735603403]
theorem CU_210_1_pre_eq :
    CU_1_re_010 * Fplus_dV_re_200 - CU_1_im_010 * Fplus_dV_im_200 = CU_210_1_pre := by
  simp only [CU_1_re_010_def, CU_1_im_010_def, Fplus_dV_re_200_def, Fplus_dV_im_200_def, CU_210_1_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_210_1_pim_eq :
    CU_1_re_010 * Fplus_dV_im_200 + CU_1_im_010 * Fplus_dV_re_200 = CU_210_1_pim := by
  simp only [CU_1_re_010_def, CU_1_im_010_def, Fplus_dV_re_200_def, Fplus_dV_im_200_def, CU_210_1_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_210_1_mul :
    CU_1_c_010 * Fplus_dV_c_200 = ofLadj CU_210_1_pre CU_210_1_pim := by
  rw [CU_1_c_010_def, Fplus_dV_c_200_def, ofLadj_mul, CU_210_1_pre_eq, CU_210_1_pim_eq]

def CU_210_2_pre : Polynomial ℚ := interpQ 235794999 [15335741382260, 108763579585184, 205234104488108, 323279497997155, 459830021955920, 527019134611434, 577226801086339, 600324644697464, 555873491297642, 547452933858145, 541004865684133, 523246714893156, 432241286098949, 342218829370037, 232593993300487, 103787096708116, 41228652823394, -8979013651511, -36707526033428]
def CU_210_2_pim : Polynomial ℚ := interpQ 235794999 [-48689778020468, -97379556040936, -92996649858368, -92399187737881, -24621744349762, 79681251249262, 159857215706043, 262181814844564, 318628327883506, 317420753916423, 311859910944947, 352357169926220, 392854428907493, 382910679753449, 381105643665879, 316852570648134, 219711402787426, 148084914068773, 52922142668568]
theorem CU_210_2_pre_eq :
    CU_2_re_010 * Fplus_dW_re_200 - CU_2_im_010 * Fplus_dW_im_200 = CU_210_2_pre := by
  simp only [CU_2_re_010_def, CU_2_im_010_def, Fplus_dW_re_200_def, Fplus_dW_im_200_def, CU_210_2_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_210_2_pim_eq :
    CU_2_re_010 * Fplus_dW_im_200 + CU_2_im_010 * Fplus_dW_re_200 = CU_210_2_pim := by
  simp only [CU_2_re_010_def, CU_2_im_010_def, Fplus_dW_re_200_def, Fplus_dW_im_200_def, CU_210_2_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_210_2_mul :
    CU_2_c_010 * Fplus_dW_c_200 = ofLadj CU_210_2_pre CU_210_2_pim := by
  rw [CU_2_c_010_def, Fplus_dW_c_200_def, ofLadj_mul, CU_210_2_pre_eq, CU_210_2_pim_eq]

theorem CU_210_3_mul : CU_3_c_110 = ofLadj CU_3_re_110 CU_3_im_110 := CU_3_c_110_def

@[expose] public def CU_coeff_210 : Ki := CU_0_c_010 * Fplus_dU_c_200 + CU_1_c_010 * Fplus_dV_c_200 + CU_2_c_010 * Fplus_dW_c_200 + CU_3_c_110

theorem CU_coeff_210_sum :
    CU_coeff_210 = ofLadj (CU_210_0_pre + CU_210_1_pre + CU_210_2_pre + CU_3_re_110) (CU_210_0_pim + CU_210_1_pim + CU_210_2_pim + CU_3_im_110) := by
  simp only [CU_coeff_210, CU_210_0_mul, CU_210_1_mul, CU_210_2_mul, CU_210_3_mul]
  simpa [add_assoc] using ofLadj_add4 CU_210_0_pre CU_210_0_pim CU_210_1_pre CU_210_1_pim CU_210_2_pre CU_210_2_pim CU_3_re_110 CU_3_im_110

def CU_210_qre : Polynomial ℚ := interpQ 235794999 [37011117633045, 16445476987827, 23018880095992, 14329177978570, -100096379995171, -131539521315713, -147079783632203, -107796212601169, -46726723568675]
def CU_210_qim : Polynomial ℚ := interpQ 235794999 [76208347640243, 76208347640243, 126222078904150, 175654273182658, 146745084630531, 92314693452049, 36161875762913, -73002938455721, -46664177910069]
theorem CU_coeff_210_poly_re :
    CU_210_0_pre + CU_210_1_pre + CU_210_2_pre + CU_3_re_110 = (0 : Polynomial ℚ) + Phi11 * CU_210_qre := by
  rw [phi11_interpQ]
  simp only [CU_210_0_pre, CU_210_1_pre, CU_210_2_pre, CU_3_re_110_def, CU_210_qre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_coeff_210_poly_im :
    CU_210_0_pim + CU_210_1_pim + CU_210_2_pim + CU_3_im_110 = (0 : Polynomial ℚ) + Phi11 * CU_210_qim := by
  rw [phi11_interpQ]
  simp only [CU_210_0_pim, CU_210_1_pim, CU_210_2_pim, CU_3_im_110_def, CU_210_qim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
public theorem CU_coeff_210_eq :
    CU_coeff_210 = (0 : Ki) := by
  rw [CU_coeff_210_sum, CU_coeff_210_poly_re,
    CU_coeff_210_poly_im, ofLadj_add_Phi11]
  exact ofLadj_zero

end V14Formalization.D12SigmaPlusSegreCore
