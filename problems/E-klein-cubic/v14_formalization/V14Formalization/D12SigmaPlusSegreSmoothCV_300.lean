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

def CV_300_0_pre : Polynomial ℚ := C ((-256105466325 / 5759971954 : ℚ)) + C ((50003549587 / 2879985977 : ℚ)) * X ^ 2 + C ((445708278809 / 5759971954 : ℚ)) * X ^ 3 + C ((772907317368 / 2879985977 : ℚ)) * X ^ 4 + C ((5247754359939 / 11519943908 : ℚ)) * X ^ 5 + C ((1879693643701 / 2879985977 : ℚ)) * X ^ 6 + C ((9309539560729 / 11519943908 : ℚ)) * X ^ 7 + C ((4998790201505 / 5759971954 : ℚ)) * X ^ 8 + C ((10256990904653 / 11519943908 : ℚ)) * X ^ 9 + C ((238352906303 / 261816907 : ℚ)) * X ^ 10 + C ((2759542501275 / 2879985977 : ℚ)) * X ^ 11 + C ((238352906303 / 261816907 : ℚ)) * X ^ 12 + C ((10056976706305 / 11519943908 : ℚ)) * X ^ 13 + C ((2276540961348 / 2879985977 : ℚ)) * X ^ 14 + C ((6592042397121 / 11519943908 : ℚ)) * X ^ 15 + C ((2126718831387 / 5759971954 : ℚ)) * X ^ 16 + C ((1982417447909 / 11519943908 : ℚ)) * X ^ 17 + C ((8503002406 / 261816907 : ℚ)) * X ^ 18
def CV_300_0_pim : Polynomial ℚ := C ((-718094733357 / 5759971954 : ℚ)) + C ((-718094733357 / 2879985977 : ℚ)) * X + C ((-2288570617067 / 5759971954 : ℚ)) * X ^ 2 + C ((-3536597090987 / 5759971954 : ℚ)) * X ^ 3 + C ((-4263021620111 / 5759971954 : ℚ)) * X ^ 4 + C ((-9251612670689 / 11519943908 : ℚ)) * X ^ 5 + C ((-2356257575238 / 2879985977 : ℚ)) * X ^ 6 + C ((-8084887619789 / 11519943908 : ℚ)) * X ^ 7 + C ((-3617447186511 / 5759971954 : ℚ)) * X ^ 8 + C ((-651529736031 / 1047267628 : ℚ)) * X ^ 9 + C ((-3483621978775 / 5759971954 : ℚ)) * X ^ 10 + C ((-239364911119 / 523633814 : ℚ)) * X ^ 11 + C ((-1782406065843 / 5759971954 : ℚ)) * X ^ 12 + C ((-1660466692189 / 11519943908 : ℚ)) * X ^ 13 + C ((225913383083 / 2879985977 : ℚ)) * X ^ 14 + C ((2254396756265 / 11519943908 : ℚ)) * X ^ 15 + C ((1357908738667 / 5759971954 : ℚ)) * X ^ 16 + C ((2556390471643 / 11519943908 : ℚ)) * X ^ 17 + C ((476049540541 / 5759971954 : ℚ)) * X ^ 18
theorem CV_300_0_pre_eq :
    CV_0_re_100 * Fplus_dU_re_200 - CV_0_im_100 * Fplus_dU_im_200 = CV_300_0_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_0_re_100, CV_0_im_100, Fplus_dU_re_200, Fplus_dU_im_200, CV_300_0_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CV_300_0_pim_eq :
    CV_0_re_100 * Fplus_dU_im_200 + CV_0_im_100 * Fplus_dU_re_200 = CV_300_0_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_0_re_100, CV_0_im_100, Fplus_dU_re_200, Fplus_dU_im_200, CV_300_0_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CV_300_0_mul :
    CV_0_c_100 * Fplus_dU_c_200 = ofLadj CV_300_0_pre CV_300_0_pim := by
  rw [CV_0_c_100, Fplus_dU_c_200, ofLadj_mul, CV_300_0_pre_eq, CV_300_0_pim_eq]

def CV_300_1_pre : Polynomial ℚ := C ((-129735011905 / 17279915862 : ℚ)) + C ((1309153810000 / 2879985977 : ℚ)) * X + C ((15621655669549 / 17279915862 : ℚ)) * X ^ 2 + C ((51033233466907 / 34559831724 : ℚ)) * X ^ 3 + C ((86375399367391 / 34559831724 : ℚ)) * X ^ 4 + C ((10035409734425 / 3141802884 : ℚ)) * X ^ 5 + C ((133348530958727 / 34559831724 : ℚ)) * X ^ 6 + C ((71602778147653 / 17279915862 : ℚ)) * X ^ 7 + C ((4036038764039 / 1047267628 : ℚ)) * X ^ 8 + C ((42044626839095 / 11519943908 : ℚ)) * X ^ 9 + C ((120770330199647 / 34559831724 : ℚ)) * X ^ 10 + C ((19845873263443 / 5759971954 : ℚ)) * X ^ 11 + C ((105060484479647 / 34559831724 : ℚ)) * X ^ 12 + C ((94890569178187 / 34559831724 : ℚ)) * X ^ 13 + C ((20539011436595 / 8639957931 : ℚ)) * X ^ 14 + C ((53403038397727 / 34559831724 : ℚ)) * X ^ 15 + C ((11105550181791 / 11519943908 : ℚ)) * X ^ 16 + C ((10357626665321 / 34559831724 : ℚ)) * X ^ 17 + C ((-285593210849 / 2879985977 : ℚ)) * X ^ 18
def CV_300_1_pim : Polynomial ℚ := C ((-3735595283665 / 8639957931 : ℚ)) + C ((-7471190567330 / 8639957931 : ℚ)) * X + C ((-3206986808626 / 2879985977 : ℚ)) * X ^ 2 + C ((-52916596773767 / 34559831724 : ℚ)) * X ^ 3 + C ((-53141616314887 / 34559831724 : ℚ)) * X ^ 4 + C ((-39094321778753 / 34559831724 : ℚ)) * X ^ 5 + C ((-23660579417389 / 34559831724 : ℚ)) * X ^ 6 + C ((1631669087471 / 8639957931 : ℚ)) * X ^ 7 + C ((22559359484687 / 34559831724 : ℚ)) * X ^ 8 + C ((21553141192915 / 34559831724 : ℚ)) * X ^ 9 + C ((5597453194027 / 11519943908 : ℚ)) * X ^ 10 + C ((2078533723912 / 2879985977 : ℚ)) * X ^ 11 + C ((11030816597269 / 11519943908 : ℚ)) * X ^ 12 + C ((12310249205055 / 11519943908 : ℚ)) * X ^ 13 + C ((12589321098412 / 8639957931 : ℚ)) * X ^ 14 + C ((17803174724349 / 11519943908 : ℚ)) * X ^ 15 + C ((15180070886055 / 11519943908 : ℚ)) * X ^ 16 + C ((37214735642545 / 34559831724 : ℚ)) * X ^ 17 + C ((1100455241377 / 2879985977 : ℚ)) * X ^ 18
theorem CV_300_1_pre_eq :
    CV_1_re_100 * Fplus_dV_re_200 - CV_1_im_100 * Fplus_dV_im_200 = CV_300_1_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_1_re_100, CV_1_im_100, Fplus_dV_re_200, Fplus_dV_im_200, CV_300_1_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CV_300_1_pim_eq :
    CV_1_re_100 * Fplus_dV_im_200 + CV_1_im_100 * Fplus_dV_re_200 = CV_300_1_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_1_re_100, CV_1_im_100, Fplus_dV_re_200, Fplus_dV_im_200, CV_300_1_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CV_300_1_mul :
    CV_1_c_100 * Fplus_dV_c_200 = ofLadj CV_300_1_pre CV_300_1_pim := by
  rw [CV_1_c_100, Fplus_dV_c_200, ofLadj_mul, CV_300_1_pre_eq, CV_300_1_pim_eq]

def CV_300_2_pre : Polynomial ℚ := C ((-930037147454 / 2879985977 : ℚ)) + C ((-6720513093904 / 2879985977 : ℚ)) * X + C ((-37920795805987 / 8639957931 : ℚ)) * X ^ 2 + C ((-119000820942749 / 17279915862 : ℚ)) * X ^ 3 + C ((-84788391256895 / 8639957931 : ℚ)) * X ^ 4 + C ((-388329422501567 / 34559831724 : ℚ)) * X ^ 5 + C ((-106369117428896 / 8639957931 : ℚ)) * X ^ 6 + C ((-442518910911283 / 34559831724 : ℚ)) * X ^ 7 + C ((-410387933109371 / 34559831724 : ℚ)) * X ^ 8 + C ((-202055382959149 / 17279915862 : ℚ)) * X ^ 9 + C ((-399438826518697 / 34559831724 : ℚ)) * X ^ 10 + C ((-32203259474317 / 2879985977 : ℚ)) * X ^ 11 + C ((-318792669391849 / 34559831724 : ℚ)) * X ^ 12 + C ((-126213791347175 / 17279915862 : ℚ)) * X ^ 13 + C ((-172386291223873 / 34559831724 : ℚ)) * X ^ 14 + C ((-76881800424371 / 34559831724 : ℚ)) * X ^ 15 + C ((-15543111938837 / 17279915862 : ℚ)) * X ^ 16 + C ((6060823336343 / 34559831724 : ℚ)) * X ^ 17 + C ((2206962121611 / 2879985977 : ℚ)) * X ^ 18
def CV_300_2_pim : Polynomial ℚ := C ((9060759482686 / 8639957931 : ℚ)) + C ((18121518965372 / 8639957931 : ℚ)) * X + C ((17124778058987 / 8639957931 : ℚ)) * X ^ 2 + C ((34378639047845 / 17279915862 : ℚ)) * X ^ 3 + C ((4757297076683 / 8639957931 : ℚ)) * X ^ 4 + C ((-57747230689481 / 34559831724 : ℚ)) * X ^ 5 + C ((-9701140924036 / 2879985977 : ℚ)) * X ^ 6 + C ((-63768146734397 / 11519943908 : ℚ)) * X ^ 7 + C ((-232797133178597 / 34559831724 : ℚ)) * X ^ 8 + C ((-57998779179217 / 8639957931 : ℚ)) * X ^ 9 + C ((-75944361507469 / 11519943908 : ℚ)) * X ^ 10 + C ((-21506572146834 / 2879985977 : ℚ)) * X ^ 11 + C ((-96108215667203 / 11519943908 : ℚ)) * X ^ 12 + C ((-70043912795402 / 8639957931 : ℚ)) * X ^ 13 + C ((-93210600193207 / 11519943908 : ℚ)) * X ^ 14 + C ((-232424613525997 / 34559831724 : ℚ)) * X ^ 15 + C ((-80516865711421 / 17279915862 : ℚ)) * X ^ 16 + C ((-3287181892781 / 1047267628 : ℚ)) * X ^ 17 + C ((-9742947560018 / 8639957931 : ℚ)) * X ^ 18
theorem CV_300_2_pre_eq :
    CV_2_re_100 * Fplus_dW_re_200 - CV_2_im_100 * Fplus_dW_im_200 = CV_300_2_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_2_re_100, CV_2_im_100, Fplus_dW_re_200, Fplus_dW_im_200, CV_300_2_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CV_300_2_pim_eq :
    CV_2_re_100 * Fplus_dW_im_200 + CV_2_im_100 * Fplus_dW_re_200 = CV_300_2_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_2_re_100, CV_2_im_100, Fplus_dW_re_200, Fplus_dW_im_200, CV_300_2_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CV_300_2_mul :
    CV_2_c_100 * Fplus_dW_c_200 = ofLadj CV_300_2_pre CV_300_2_pim := by
  rw [CV_2_c_100, Fplus_dW_c_200, ofLadj_mul, CV_300_2_pre_eq, CV_300_2_pim_eq]

@[expose] public def CV_coeff_300 : Ki := CV_0_c_100 * Fplus_dU_c_200 + CV_1_c_100 * Fplus_dV_c_200 + CV_2_c_100 * Fplus_dW_c_200

theorem CV_coeff_300_sum :
    CV_coeff_300 = ofLadj (CV_300_0_pre + CV_300_1_pre + CV_300_2_pre) (CV_300_0_pim + CV_300_1_pim + CV_300_2_pim) := by
  simp only [CV_coeff_300, CV_300_0_mul, CV_300_1_mul, CV_300_2_mul]
  simpa [add_assoc] using ofLadj_add3 CV_300_0_pre CV_300_0_pim CV_300_1_pre CV_300_1_pim CV_300_2_pre CV_300_2_pim

def CV_300_qre : Polynomial ℚ := C ((-3239137147802 / 8639957931 : ℚ)) + C ((-1181358245810 / 785450721 : ℚ)) * X + C ((-27451758941479 / 17279915862 : ℚ)) * X ^ 2 + C ((-64454329455931 / 34559831724 : ℚ)) * X ^ 3 + C ((-14802279776509 / 8639957931 : ℚ)) * X ^ 4 + C ((-3115562415217 / 5759971954 : ℚ)) * X ^ 5 + C ((-3687481344685 / 17279915862 : ℚ)) * X ^ 6 + C ((-1813120901345 / 34559831724 : ℚ)) * X ^ 7 + C ((2014901937228 / 2879985977 : ℚ)) * X ^ 8
def CV_300_qim : Polynomial ℚ := C ((257455884787 / 523633814 : ℚ)) + C ((257455884787 / 523633814 : ℚ)) * X + C ((-8850164980925 / 17279915862 : ℚ)) * X ^ 2 + C ((-7220916018011 / 11519943908 : ℚ)) * X ^ 3 + C ((-27155828252411 / 17279915862 : ℚ)) * X ^ 4 + C ((-16226458187870 / 8639957931 : ℚ)) * X ^ 5 + C ((-3646080910698 / 2879985977 : ℚ)) * X ^ 6 + C ((-13561021767999 / 11519943908 : ℚ)) * X ^ 7 + C ((-11455015050151 / 17279915862 : ℚ)) * X ^ 8
theorem CV_coeff_300_poly_re :
    CV_300_0_pre + CV_300_1_pre + CV_300_2_pre = (0 : Polynomial ℚ) + Phi11 * CV_300_qre := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [CV_300_0_pre, CV_300_1_pre, CV_300_2_pre, CV_300_qre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try grind
theorem CV_coeff_300_poly_im :
    CV_300_0_pim + CV_300_1_pim + CV_300_2_pim = (0 : Polynomial ℚ) + Phi11 * CV_300_qim := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [CV_300_0_pim, CV_300_1_pim, CV_300_2_pim, CV_300_qim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try grind
public theorem CV_coeff_300_eq :
    CV_coeff_300 = (0 : Ki) := by
  rw [CV_coeff_300_sum, CV_coeff_300_poly_re,
    CV_coeff_300_poly_im, ofLadj_add_Phi11]
  exact ofLadj_zero

end V14Formalization.D12SigmaPlusSegreCore
