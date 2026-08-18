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

def CV_200_0_pre : Polynomial ℚ := interpQ 34559831724 [44212680378909, 0, -36363569897448, -107516879986071, -333687343503438, -560574636253356, -794861197554222, -984654935515818, -1056429335025288, -1086779267733798, -1110716607231393, -1163202803077635, -1110716607231393, -1050415697836350, -948912455039217, -694248930771423, -450699848001642, -216413286700776, -43281338759043]
def CV_200_0_pim : Polynomial ℚ := interpQ 34559831724 [147083709176703, 294167418353406, 477374834485686, 727323121920942, 881185516030821, 954896615519784, 974596715340261, 832837818132513, 740992811742372, 736474533969072, 716234295799251, 539306933647911, 362379571496571, 158931917194470, -95534648014086, -236360404017267, -284121049410426, -272590995800391, -104881644496839]
theorem CV_200_0_pre_eq :
    CV_0_re_000 * Fplus_dU_re_200 - CV_0_im_000 * Fplus_dU_im_200 = CV_200_0_pre := by
  simp only [CV_0_re_000_def, CV_0_im_000_def, Fplus_dU_re_200_def, Fplus_dU_im_200_def, CV_200_0_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_200_0_pim_eq :
    CV_0_re_000 * Fplus_dU_im_200 + CV_0_im_000 * Fplus_dU_re_200 = CV_200_0_pim := by
  simp only [CV_0_re_000_def, CV_0_im_000_def, Fplus_dU_re_200_def, Fplus_dU_im_200_def, CV_200_0_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_200_0_mul :
    CV_0_c_000 * Fplus_dU_c_200 = ofLadj CV_200_0_pre CV_200_0_pim := by
  rw [CV_0_c_000_def, Fplus_dU_c_200_def, ofLadj_mul, CV_200_0_pre_eq, CV_200_0_pim_eq]

def CV_200_1_pre : Polynomial ℚ := interpQ 34559831724 [955683349516, -108030675370240, -215604291740590, -351643988340524, -594825565052327, -761175984368568, -918422261831355, -986490543970121, -918075273515084, -869344960082670, -831858983063464, -819070236171742, -723828307693224, -653740668342080, -566431285174560, -368227150349316, -228487061146544, -71240783683757, 23437828568478]
def CV_200_1_pim : Polynomial ℚ := interpQ 34559831724 [102516370146696, 205032740293392, 264808095256709, 363688140520032, 365508857884817, 268630654561127, 161328388531968, -45178577295872, -156676120033223, -149817451582183, -117402588329945, -172572522138432, -227742455946919, -255102947657998, -347124324470281, -369282140474208, -314128562375922, -255942784700645, -91160444098209]
theorem CV_200_1_pre_eq :
    CV_1_re_000 * Fplus_dV_re_200 - CV_1_im_000 * Fplus_dV_im_200 = CV_200_1_pre := by
  simp only [CV_1_re_000_def, CV_1_im_000_def, Fplus_dV_re_200_def, Fplus_dV_im_200_def, CV_200_1_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_200_1_pim_eq :
    CV_1_re_000 * Fplus_dV_im_200 + CV_1_im_000 * Fplus_dV_re_200 = CV_200_1_pim := by
  simp only [CV_1_re_000_def, CV_1_im_000_def, Fplus_dV_re_200_def, Fplus_dV_im_200_def, CV_200_1_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_200_1_mul :
    CV_1_c_000 * Fplus_dV_c_200 = ofLadj CV_200_1_pre CV_200_1_pim := by
  rw [CV_1_c_000_def, Fplus_dV_c_200_def, ofLadj_mul, CV_200_1_pre_eq, CV_200_1_pim_eq]

def CV_200_2_pre : Polynomial ℚ := interpQ 34559831724 [28163454789820, 204824448153280, 385004657761622, 604847453155782, 862600351771718, 986899696837609, 1082211902603513, 1124418713195192, 1042758091776866, 1026757103103778, 1014942740774135, 982054025761546, 810118292620855, 641752445342156, 437910638621084, 194526640532720, 78881412772227, -16430792993677, -67291720890754]
def CV_200_2_pim : Polynomial ℚ := interpQ 34559831724 [-92170939556480, -184341879112960, -174077193557346, -175587674415253, -48231807151916, 146593192629487, 296142655462965, 487171589711795, 592110288760353, 590143487007365, 579490256169988, 656435933835352, 733381611500716, 712463695107725, 712007374212644, 590920123249727, 409945178346844, 275848962118448, 98670082748138]
theorem CV_200_2_pre_eq :
    CV_2_re_000 * Fplus_dW_re_200 - CV_2_im_000 * Fplus_dW_im_200 = CV_200_2_pre := by
  simp only [CV_2_re_000_def, CV_2_im_000_def, Fplus_dW_re_200_def, Fplus_dW_im_200_def, CV_200_2_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_200_2_pim_eq :
    CV_2_re_000 * Fplus_dW_im_200 + CV_2_im_000 * Fplus_dW_re_200 = CV_200_2_pim := by
  simp only [CV_2_re_000_def, CV_2_im_000_def, Fplus_dW_re_200_def, Fplus_dW_im_200_def, CV_200_2_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_200_2_mul :
    CV_2_c_000 * Fplus_dW_c_200 = ofLadj CV_200_2_pre CV_200_2_pim := by
  rw [CV_2_c_000_def, Fplus_dW_c_200_def, ofLadj_mul, CV_200_2_pre_eq, CV_200_2_pim_eq]

def CV_200_3_pre : Polynomial ℚ := interpQ 34559831724 [-745654551136, 0, 1734275191968, 4113667242784, 6229147851344, 7523570639552, 7523570639552, 6229147851344, 4113667242784, 1734275191968]
def CV_200_3_pim : Polynomial ℚ := interpQ 34559831724 [-2277521472456, -4555042944912, -6076437189952, -6450026114704, -5418181882680, -3494065631600, -1060977313312, 863138937768, 1894983169792, 1521394245040]
theorem CV_200_3_neg_re : -CV_3_re_200 = CV_200_3_pre := by
  simp only [CV_3_re_200_def, CV_200_3_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_200_3_neg_im : -CV_3_im_200 = CV_200_3_pim := by
  simp only [CV_3_im_200_def, CV_200_3_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_200_3_mul : -CV_3_c_200 = ofLadj CV_200_3_pre CV_200_3_pim := by
  rw [CV_3_c_200_def, ofLadj_neg, CV_200_3_neg_re, CV_200_3_neg_im]

@[expose] public def CV_coeff_200 : Ki := CV_0_c_000 * Fplus_dU_c_200 + CV_1_c_000 * Fplus_dV_c_200 + CV_2_c_000 * Fplus_dW_c_200 + (-CV_3_c_200)

theorem CV_coeff_200_sum :
    CV_coeff_200 = ofLadj (CV_200_0_pre + CV_200_1_pre + CV_200_2_pre + CV_200_3_pre) (CV_200_0_pim + CV_200_1_pim + CV_200_2_pim + CV_200_3_pim) := by
  simp only [CV_coeff_200, CV_200_0_mul, CV_200_1_mul, CV_200_2_mul, CV_200_3_mul]
  simpa [add_assoc] using ofLadj_add4 CV_200_0_pre CV_200_0_pim CV_200_1_pre CV_200_1_pim CV_200_2_pre CV_200_2_pim CV_200_3_pre CV_200_3_pim

def CV_200_qre : Polynomial ℚ := interpQ 34559831724 [72586163967109, 24207608815931, 37977298532512, 15029180756419, -209483661004674, -267643944212060, -296220632997749, -216949632296891, -87135231081319]
def CV_200_qim : Polynomial ℚ := interpQ 34559831724 [155151618294463, 155151618294463, 251726062406171, 346944262915920, 284070822970025, 173582012197756, 64380384943084, -155312812535678, -97372005846910]
theorem CV_coeff_200_poly_re :
    CV_200_0_pre + CV_200_1_pre + CV_200_2_pre + CV_200_3_pre = (0 : Polynomial ℚ) + Phi11 * CV_200_qre := by
  rw [phi11_interpQ]
  simp only [CV_200_0_pre, CV_200_1_pre, CV_200_2_pre, CV_200_3_pre, CV_200_qre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_coeff_200_poly_im :
    CV_200_0_pim + CV_200_1_pim + CV_200_2_pim + CV_200_3_pim = (0 : Polynomial ℚ) + Phi11 * CV_200_qim := by
  rw [phi11_interpQ]
  simp only [CV_200_0_pim, CV_200_1_pim, CV_200_2_pim, CV_200_3_pim, CV_200_qim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
public theorem CV_coeff_200_eq :
    CV_coeff_200 = (0 : Ki) := by
  rw [CV_coeff_200_sum, CV_coeff_200_poly_re,
    CV_coeff_200_poly_im, ofLadj_add_Phi11]
  exact ofLadj_zero

end V14Formalization.D12SigmaPlusSegreCore
