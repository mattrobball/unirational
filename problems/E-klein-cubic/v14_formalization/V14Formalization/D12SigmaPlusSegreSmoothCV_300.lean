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

def CV_300_0_pre : Polynomial ℚ := interpQ 34559831724 [-1536632797950, 0, 600042595044, 2674249672854, 9274887808416, 15743263079817, 22556323724412, 27928618682187, 29992741209030, 30770972713959, 31462583631996, 33114510015300, 31462583631996, 30170930118915, 27318491536176, 19776127191363, 12760312988322, 5947252343727, 1122396317592]
def CV_300_0_pim : Polynomial ℚ := interpQ 34559831724 [-4308568400142, -8617136800284, -13731423702402, -21219582545922, -25578129720666, -27754838012067, -28275090902856, -24254662859367, -21704683119066, -21500481289023, -20901731872650, -15798084133854, -10694436395058, -4981400076567, 2710960596996, 6763190268795, 8147452432002, 7669171414929, 2856297243246]
theorem CV_300_0_pre_eq :
    CV_0_re_100 * Fplus_dU_re_200 - CV_0_im_100 * Fplus_dU_im_200 = CV_300_0_pre := by
  simp only [CV_0_re_100_def, CV_0_im_100_def, Fplus_dU_re_200_def, Fplus_dU_im_200_def, CV_300_0_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_300_0_pim_eq :
    CV_0_re_100 * Fplus_dU_im_200 + CV_0_im_100 * Fplus_dU_re_200 = CV_300_0_pim := by
  simp only [CV_0_re_100_def, CV_0_im_100_def, Fplus_dU_re_200_def, Fplus_dU_im_200_def, CV_300_0_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_300_0_mul :
    CV_0_c_100 * Fplus_dU_c_200 = ofLadj CV_300_0_pre CV_300_0_pim := by
  rw [CV_0_c_100_def, Fplus_dU_c_200_def, ofLadj_mul, CV_300_0_pre_eq, CV_300_0_pim_eq]

def CV_300_1_pre : Polynomial ℚ := interpQ 34559831724 [-259470023810, 15709845720000, 31243311339098, 51033233466907, 86375399367391, 110389507078675, 133348530958727, 143205556295306, 133189279213287, 126133880517285, 120770330199647, 119075239580658, 105060484479647, 94890569178187, 82156045746380, 53403038397727, 33316650545373, 10357626665321, -3427118530188]
def CV_300_1_pim : Polynomial ℚ := interpQ 34559831724 [-14942381134660, -29884762269320, -38483841703512, -52916596773767, -53141616314887, -39094321778753, -23660579417389, 6526676349884, 22559359484687, 21553141192915, 16792359582081, 24942404686944, 33092449791807, 36930747615165, 50357284393648, 53409524173047, 45540212658165, 37214735642545, 13205462896524]
theorem CV_300_1_pre_eq :
    CV_1_re_100 * Fplus_dV_re_200 - CV_1_im_100 * Fplus_dV_im_200 = CV_300_1_pre := by
  simp only [CV_1_re_100_def, CV_1_im_100_def, Fplus_dV_re_200_def, Fplus_dV_im_200_def, CV_300_1_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_300_1_pim_eq :
    CV_1_re_100 * Fplus_dV_im_200 + CV_1_im_100 * Fplus_dV_re_200 = CV_300_1_pim := by
  simp only [CV_1_re_100_def, CV_1_im_100_def, Fplus_dV_re_200_def, Fplus_dV_im_200_def, CV_300_1_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_300_1_mul :
    CV_1_c_100 * Fplus_dV_c_200 = ofLadj CV_300_1_pre CV_300_1_pim := by
  rw [CV_1_c_100_def, Fplus_dV_c_200_def, ofLadj_mul, CV_300_1_pre_eq, CV_300_1_pim_eq]

def CV_300_2_pre : Polynomial ℚ := interpQ 34559831724 [-11160445769448, -80646157126848, -151683183223948, -238001641885498, -339153565027580, -388329422501567, -425476469715584, -442518910911283, -410387933109371, -404110765918298, -399438826518697, -386439113691804, -318792669391849, -252427582694350, -172386291223873, -76881800424371, -31086223877674, 6060823336343, 26483545459332]
def CV_300_2_pim : Polynomial ℚ := interpQ 34559831724 [36243037930744, 72486075861488, 68499112235948, 68757278095690, 19029188306732, -57747230689481, -116413691088432, -191304440203191, -232797133178597, -231995116716868, -227833084522407, -258078865762008, -288324647001609, -280175651181608, -279631800579621, -232424613525997, -161033731422842, -108477002461773, -38971790240072]
theorem CV_300_2_pre_eq :
    CV_2_re_100 * Fplus_dW_re_200 - CV_2_im_100 * Fplus_dW_im_200 = CV_300_2_pre := by
  simp only [CV_2_re_100_def, CV_2_im_100_def, Fplus_dW_re_200_def, Fplus_dW_im_200_def, CV_300_2_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_300_2_pim_eq :
    CV_2_re_100 * Fplus_dW_im_200 + CV_2_im_100 * Fplus_dW_re_200 = CV_300_2_pim := by
  simp only [CV_2_re_100_def, CV_2_im_100_def, Fplus_dW_re_200_def, Fplus_dW_im_200_def, CV_300_2_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_300_2_mul :
    CV_2_c_100 * Fplus_dW_c_200 = ofLadj CV_300_2_pre CV_300_2_pim := by
  rw [CV_2_c_100_def, Fplus_dW_c_200_def, ofLadj_mul, CV_300_2_pre_eq, CV_300_2_pim_eq]

@[expose] public def CV_coeff_300 : Ki := CV_0_c_100 * Fplus_dU_c_200 + CV_1_c_100 * Fplus_dV_c_200 + CV_2_c_100 * Fplus_dW_c_200

theorem CV_coeff_300_sum :
    CV_coeff_300 = ofLadj (CV_300_0_pre + CV_300_1_pre + CV_300_2_pre) (CV_300_0_pim + CV_300_1_pim + CV_300_2_pim) := by
  simp only [CV_coeff_300, CV_300_0_mul, CV_300_1_mul, CV_300_2_mul]
  simpa [add_assoc] using ofLadj_add3 CV_300_0_pre CV_300_0_pim CV_300_1_pre CV_300_1_pim CV_300_2_pre CV_300_2_pim

def CV_300_qre : Polynomial ℚ := interpQ 34559831724 [-12956548591208, -51979762815640, -54903517882958, -64454329455931, -59209119106036, -18693374491302, -7374962689370, -1813120901345, 24178823246736]
def CV_300_qim : Polynomial ℚ := interpQ 34559831724 [16992088395942, 16992088395942, -17700329961850, -21662748054033, -54311656504822, -64905832751480, -43752970928376, -40683065303997, -22910030100302]
theorem CV_coeff_300_poly_re :
    CV_300_0_pre + CV_300_1_pre + CV_300_2_pre = (0 : Polynomial ℚ) + Phi11 * CV_300_qre := by
  rw [phi11_interpQ]
  simp only [CV_300_0_pre, CV_300_1_pre, CV_300_2_pre, CV_300_qre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_coeff_300_poly_im :
    CV_300_0_pim + CV_300_1_pim + CV_300_2_pim = (0 : Polynomial ℚ) + Phi11 * CV_300_qim := by
  rw [phi11_interpQ]
  simp only [CV_300_0_pim, CV_300_1_pim, CV_300_2_pim, CV_300_qim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
public theorem CV_coeff_300_eq :
    CV_coeff_300 = (0 : Ki) := by
  rw [CV_coeff_300_sum, CV_coeff_300_poly_re,
    CV_coeff_300_poly_im, ofLadj_add_Phi11]
  exact ofLadj_zero

end V14Formalization.D12SigmaPlusSegreCore
