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

def CU_120_0_pre : Polynomial ℚ := interpQ 235794999 [892031552140, -130788936989504, -261585889634296, -426074211971960, -720413350661488, -922423527974720, -1112137649354528, -1194897001744948, -1112332559458808, -1053159533710520, -1008034040219844, -992032446916032, -877245103230340, -791573644076224, -686258347486848, -446246542508616, -276571045173120, -86856923793312, 28237108574844]
def CU_120_0_pim : Polynomial ℚ := interpQ 235794999 [124037252951392, 248074505902784, 320600866698344, 439751176737996, 442526376324432, 324843450547664, 194667789636208, -54790808946512, -190401028997564, -181870637663728, -142769628270788, -209453995733104, -276138363195420, -309563714598040, -420183633303856, -447810421934392, -380350272481980, -309994453265316, -110758631006952]
theorem CU_120_0_pre_eq :
    CU_0_re_010 * Fplus_dU_re_110 - CU_0_im_010 * Fplus_dU_im_110 = CU_120_0_pre := by
  simp only [CU_0_re_010_def, CU_0_im_010_def, Fplus_dU_re_110_def, Fplus_dU_im_110_def, CU_120_0_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_120_0_pim_eq :
    CU_0_re_010 * Fplus_dU_im_110 + CU_0_im_010 * Fplus_dU_re_110 = CU_120_0_pim := by
  simp only [CU_0_re_010_def, CU_0_im_010_def, Fplus_dU_re_110_def, Fplus_dU_im_110_def, CU_120_0_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_120_0_mul :
    CU_0_c_010 * Fplus_dU_c_110 = ofLadj CU_120_0_pre CU_120_0_pim := by
  rw [CU_0_c_010_def, Fplus_dU_c_110_def, ofLadj_mul, CU_120_0_pre_eq, CU_120_0_pim_eq]

def CU_120_1_pre : Polynomial ℚ := interpQ 235794999 [-20462497632, -276534924821560, -523488759196720, -900818367390496, -1470646860533644, -1897934028248140, -2312965242731292, -2648456513950648, -2693001968382040, -2786893966755496, -2858662700395128, -2885525072602580, -2582127775573568, -2263405207558776, -1792183600991544, -1136060041718840, -657315511393592, -242284296910440, 41749611698164]
def CU_120_1_pim : Polynomial ℚ := interpQ 235794999 [255382118071196, 510764236142392, 689625320821716, 968727672116168, 1014243619362312, 901398850945056, 790682185110076, 471590501906668, 242450796706144, 228960015340564, 166913045929500, -179642397721108, -526197841371716, -767105895462104, -1059699028122136, -1065855068743400, -873209263997084, -667392331357872, -268499611825404]
theorem CU_120_1_pre_eq :
    CU_1_re_010 * Fplus_dV_re_110 - CU_1_im_010 * Fplus_dV_im_110 = CU_120_1_pre := by
  simp only [CU_1_re_010_def, CU_1_im_010_def, Fplus_dV_re_110_def, Fplus_dV_im_110_def, CU_120_1_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_120_1_pim_eq :
    CU_1_re_010 * Fplus_dV_im_110 + CU_1_im_010 * Fplus_dV_re_110 = CU_120_1_pim := by
  simp only [CU_1_re_010_def, CU_1_im_010_def, Fplus_dV_re_110_def, Fplus_dV_im_110_def, CU_120_1_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_120_1_mul :
    CU_1_c_010 * Fplus_dV_c_110 = ofLadj CU_120_1_pre CU_120_1_pim := by
  rw [CU_1_c_010_def, Fplus_dV_c_110_def, ofLadj_mul, CU_120_1_pre_eq, CU_120_1_pim_eq]

def CU_120_2_pre : Polynomial ℚ := interpQ 235794999 [-20556623184596, -271908948962960, -553864774904032, -911687232054596, -1356126372692436, -1611384530938980, -1817854137084144, -1930637075247688, -1838749569166480, -1804070495913264, -1777446005039380, -1746917320732852, -1505537056076420, -1250205721009232, -927062337111884, -514563833903328, -278407779817160, -71938173671996, 59946868651924]
def CU_120_2_pim : Polynomial ℚ := interpQ 235794999 [182903958567836, 365807917135672, 435294462751952, 511853407138572, 383960841100732, 133161548292416, -68585159244964, -365506749717060, -535327605083276, -530377291227908, -507450667698848, -656568041921108, -805685416143368, -852245338230588, -923853968761840, -810448871609772, -589206189837216, -422698365916780, -155333386480444]
theorem CU_120_2_pre_eq :
    CU_2_re_010 * Fplus_dW_re_110 - CU_2_im_010 * Fplus_dW_im_110 = CU_120_2_pre := by
  simp only [CU_2_re_010_def, CU_2_im_010_def, Fplus_dW_re_110_def, Fplus_dW_im_110_def, CU_120_2_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_120_2_pim_eq :
    CU_2_re_010 * Fplus_dW_im_110 + CU_2_im_010 * Fplus_dW_re_110 = CU_120_2_pim := by
  simp only [CU_2_re_010_def, CU_2_im_010_def, Fplus_dW_re_110_def, Fplus_dW_im_110_def, CU_120_2_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_120_2_mul :
    CU_2_c_010 * Fplus_dW_c_110 = ofLadj CU_120_2_pre CU_120_2_pim := by
  rw [CU_2_c_010_def, Fplus_dW_c_110_def, ofLadj_mul, CU_120_2_pre_eq, CU_120_2_pim_eq]

theorem CU_120_3_mul : CU_3_c_020 = ofLadj CU_3_re_020 CU_3_im_020 := CU_3_c_020_def

@[expose] public def CU_coeff_120 : Ki := CU_0_c_010 * Fplus_dU_c_110 + CU_1_c_010 * Fplus_dV_c_110 + CU_2_c_010 * Fplus_dW_c_110 + CU_3_c_020

theorem CU_coeff_120_sum :
    CU_coeff_120 = ofLadj (CU_120_0_pre + CU_120_1_pre + CU_120_2_pre + CU_3_re_020) (CU_120_0_pim + CU_120_1_pim + CU_120_2_pim + CU_3_im_020) := by
  simp only [CU_coeff_120, CU_120_0_mul, CU_120_1_mul, CU_120_2_mul, CU_120_3_mul]
  simpa [add_assoc] using ofLadj_add4 CU_120_0_pre CU_120_0_pim CU_120_1_pre CU_120_1_pim CU_120_2_pre CU_120_2_pim CU_3_re_020 CU_3_im_020

def CU_120_qre : Polynomial ℚ := interpQ 235794999 [-19667905402888, -659564905371136, -659725362236096, -899680287053956, -1308633867459492, -884576081746912, -811214942008124, -531012983300680, 129933588924932]
def CU_120_qim : Polynomial ℚ := interpQ 235794999 [562357185335184, 562357185335184, 320893327580228, 474821681897100, -79622267900268, -481348635971284, -442680575776312, -865493521227168, -534591629312800]
theorem CU_coeff_120_poly_re :
    CU_120_0_pre + CU_120_1_pre + CU_120_2_pre + CU_3_re_020 = (0 : Polynomial ℚ) + Phi11 * CU_120_qre := by
  rw [phi11_interpQ]
  simp only [CU_120_0_pre, CU_120_1_pre, CU_120_2_pre, CU_3_re_020_def, CU_120_qre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_coeff_120_poly_im :
    CU_120_0_pim + CU_120_1_pim + CU_120_2_pim + CU_3_im_020 = (0 : Polynomial ℚ) + Phi11 * CU_120_qim := by
  rw [phi11_interpQ]
  simp only [CU_120_0_pim, CU_120_1_pim, CU_120_2_pim, CU_3_im_020_def, CU_120_qim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
public theorem CU_coeff_120_eq :
    CU_coeff_120 = (0 : Ki) := by
  rw [CU_coeff_120_sum, CU_coeff_120_poly_re,
    CU_coeff_120_poly_im, ofLadj_add_Phi11]
  exact ofLadj_zero

end V14Formalization.D12SigmaPlusSegreCore
