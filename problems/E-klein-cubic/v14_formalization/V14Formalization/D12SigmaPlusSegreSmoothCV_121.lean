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

def CV_121_0_pre : Polynomial ℚ := C ((-678860698778 / 8639957931 : ℚ)) + C ((3055988056640 / 8639957931 : ℚ)) * X + C ((1658126636458 / 2879985977 : ℚ)) * X ^ 2 + C ((9468973633874 / 8639957931 : ℚ)) * X ^ 3 + C ((10375909785871 / 5759971954 : ℚ)) * X ^ 4 + C ((20319005142173 / 8639957931 : ℚ)) * X ^ 5 + C ((8210630378092 / 2879985977 : ℚ)) * X ^ 6 + C ((57286557840473 / 17279915862 : ℚ)) * X ^ 7 + C ((57168775675073 / 17279915862 : ℚ)) * X ^ 8 + C ((29557691230724 / 8639957931 : ℚ)) * X ^ 9 + C ((10168562766374 / 2879985977 : ℚ)) * X ^ 10 + C ((10465518683808 / 2879985977 : ℚ)) * X ^ 11 + C ((27449700242482 / 8639957931 : ℚ)) * X ^ 12 + C ((24583311321350 / 8639957931 : ℚ)) * X ^ 13 + C ((38230828407325 / 17279915862 : ℚ)) * X ^ 14 + C ((12010828015501 / 8639957931 : ℚ)) * X ^ 15 + C ((75590674520 / 97078179 : ℚ)) * X ^ 16 + C ((804894680059 / 2879985977 : ℚ)) * X ^ 17 + C ((-356195408643 / 2879985977 : ℚ)) * X ^ 18
def CV_121_0_pim : Polynomial ℚ := C ((-1007319921238 / 2879985977 : ℚ)) + C ((-2014639842476 / 2879985977 : ℚ)) * X + C ((-7858557594467 / 8639957931 : ℚ)) * X ^ 2 + C ((-11182744983917 / 8639957931 : ℚ)) * X ^ 3 + C ((-23905239146911 / 17279915862 : ℚ)) * X ^ 4 + C ((-10206848338919 / 8639957931 : ℚ)) * X ^ 5 + C ((-3252645165446 / 2879985977 : ℚ)) * X ^ 6 + C ((-11106922547551 / 17279915862 : ℚ)) * X ^ 7 + C ((-2331257178825 / 5759971954 : ℚ)) * X ^ 8 + C ((-3244643598214 / 8639957931 : ℚ)) * X ^ 9 + C ((-2638848334109 / 8639957931 : ℚ)) * X ^ 10 + C ((1469528782462 / 8639957931 : ℚ)) * X ^ 11 + C ((5577905899033 / 8639957931 : ℚ)) * X ^ 12 + C ((7998339230177 / 8639957931 : ℚ)) * X ^ 13 + C ((23149537579301 / 17279915862 : ℚ)) * X ^ 14 + C ((11718966430814 / 8639957931 : ℚ)) * X ^ 15 + C ((3093321856916 / 2879985977 : ℚ)) * X ^ 16 + C ((7579956302005 / 8639957931 : ℚ)) * X ^ 17 + C ((2682252453913 / 8639957931 : ℚ)) * X ^ 18
theorem CV_121_0_pre_eq :
    CV_0_re_101 * Fplus_dU_re_020 - CV_0_im_101 * Fplus_dU_im_020 = CV_121_0_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_0_re_101, CV_0_im_101, Fplus_dU_re_020, Fplus_dU_im_020, CV_121_0_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CV_121_0_pim_eq :
    CV_0_re_101 * Fplus_dU_im_020 + CV_0_im_101 * Fplus_dU_re_020 = CV_121_0_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_0_re_101, CV_0_im_101, Fplus_dU_re_020, Fplus_dU_im_020, CV_121_0_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CV_121_0_mul :
    CV_0_c_101 * Fplus_dU_c_020 = ofLadj CV_121_0_pre CV_121_0_pim := by
  rw [CV_0_c_101, Fplus_dU_c_020, ofLadj_mul, CV_121_0_pre_eq, CV_121_0_pim_eq]

def CV_121_1_pre : Polynomial ℚ := C ((8872860573 / 64718786 : ℚ)) + C ((6771299890 / 2941763 : ℚ)) * X + C ((252596624281 / 64718786 : ℚ)) * X ^ 2 + C ((207635867451 / 32359393 : ℚ)) * X ^ 3 + C ((630484369159 / 64718786 : ℚ)) * X ^ 4 + C ((32433860523 / 2941763 : ℚ)) * X ^ 5 + C ((37160091677 / 2941763 : ℚ)) * X ^ 6 + C ((472070483189 / 32359393 : ℚ)) * X ^ 7 + C ((959624008487 / 64718786 : ℚ)) * X ^ 8 + C ((518728875154 / 32359393 : ℚ)) * X ^ 9 + C ((547010530897 / 32359393 : ℚ)) * X ^ 10 + C ((554361089709 / 32359393 : ℚ)) * X ^ 11 + C ((472526232107 / 32359393 : ℚ)) * X ^ 12 + C ((6486455587 / 534866 : ℚ)) * X ^ 13 + C ((544352273585 / 64718786 : ℚ)) * X ^ 14 + C ((259863221513 / 64718786 : ℚ)) * X ^ 15 + C ((67220963255 / 32359393 : ℚ)) * X ^ 16 + C ((15232420561 / 32359393 : ℚ)) * X ^ 17 + C ((-26896687853 / 32359393 : ℚ)) * X ^ 18
def CV_121_1_pim : Polynomial ℚ := C ((-88668943201 / 64718786 : ℚ)) + C ((-88668943201 / 32359393 : ℚ)) * X + C ((-198939867823 / 64718786 : ℚ)) * X ^ 2 + C ((-132715032376 / 32359393 : ℚ)) * X ^ 3 + C ((-198346055269 / 64718786 : ℚ)) * X ^ 4 + C ((-4122561717 / 2941763 : ℚ)) * X ^ 5 + C ((-35653793650 / 32359393 : ℚ)) * X ^ 6 + C ((21335833639 / 32359393 : ℚ)) * X ^ 7 + C ((119636048527 / 64718786 : ℚ)) * X ^ 8 + C ((64742602578 / 32359393 : ℚ)) * X ^ 9 + C ((90422251721 / 32359393 : ℚ)) * X ^ 10 + C ((171632199713 / 32359393 : ℚ)) * X ^ 11 + C ((252842147705 / 32359393 : ℚ)) * X ^ 12 + C ((578645575117 / 64718786 : ℚ)) * X ^ 13 + C ((59544084425 / 5883526 : ℚ)) * X ^ 14 + C ((557449323089 / 64718786 : ℚ)) * X ^ 15 + C ((191499032997 / 32359393 : ℚ)) * X ^ 16 + C ((144098395765 / 32359393 : ℚ)) * X ^ 17 + C ((53707988676 / 32359393 : ℚ)) * X ^ 18
theorem CV_121_1_pre_eq :
    CV_1_re_101 * Fplus_dV_re_020 - CV_1_im_101 * Fplus_dV_im_020 = CV_121_1_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_1_re_101, CV_1_im_101, Fplus_dV_re_020, Fplus_dV_im_020, CV_121_1_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CV_121_1_pim_eq :
    CV_1_re_101 * Fplus_dV_im_020 + CV_1_im_101 * Fplus_dV_re_020 = CV_121_1_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_1_re_101, CV_1_im_101, Fplus_dV_re_020, Fplus_dV_im_020, CV_121_1_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CV_121_1_mul :
    CV_1_c_101 * Fplus_dV_c_020 = ofLadj CV_121_1_pre CV_121_1_pim := by
  rw [CV_1_c_101, Fplus_dV_c_020, ofLadj_mul, CV_121_1_pre_eq, CV_121_1_pim_eq]

def CV_121_2_pre : Polynomial ℚ := C ((956281376200 / 785450721 : ℚ)) + C ((150305807459080 / 8639957931 : ℚ)) * X + C ((99332505837139 / 2879985977 : ℚ)) * X ^ 2 + C ((488470764059251 / 8639957931 : ℚ)) * X ^ 3 + C ((242820213270112 / 2879985977 : ℚ)) * X ^ 4 + C ((1734398823575203 / 17279915862 : ℚ)) * X ^ 5 + C ((327112083365989 / 2879985977 : ℚ)) * X ^ 6 + C ((1049708927301389 / 8639957931 : ℚ)) * X ^ 7 + C ((2000675095439393 / 17279915862 : ℚ)) * X ^ 8 + C ((1978037545118405 / 17279915862 : ℚ)) * X ^ 9 + C ((59419103391067 / 523633814 : ℚ)) * X ^ 10 + C ((966641224352032 / 8639957931 : ℚ)) * X ^ 11 + C ((1660218796987051 / 17279915862 : ℚ)) * X ^ 12 + C ((1382042510095571 / 17279915862 : ℚ)) * X ^ 13 + C ((341244522440297 / 5759971954 : ℚ)) * X ^ 14 + C ((94081809837922 / 2879985977 : ℚ)) * X ^ 15 + C ((149700382938091 / 8639957931 : ℚ)) * X ^ 16 + C ((23709029751817 / 5759971954 : ℚ)) * X ^ 17 + C ((-39002857977287 / 8639957931 : ℚ)) * X ^ 18
def CV_121_2_pim : Polynomial ℚ := C ((-34132787306780 / 2879985977 : ℚ)) + C ((-68265574613560 / 2879985977 : ℚ)) * X + C ((-239933481857161 / 8639957931 : ℚ)) * X ^ 2 + C ((-288323230924219 / 8639957931 : ℚ)) * X ^ 3 + C ((-73653282730365 / 2879985977 : ℚ)) * X ^ 4 + C ((-171226209388675 / 17279915862 : ℚ)) * X ^ 5 + C ((24600926959505 / 8639957931 : ℚ)) * X ^ 6 + C ((17286092950190 / 785450721 : ℚ)) * X ^ 7 + C ((191214816217581 / 5759971954 : ℚ)) * X ^ 8 + C ((570347527973435 / 17279915862 : ℚ)) * X ^ 9 + C ((555434820651659 / 17279915862 : ℚ)) * X ^ 10 + C ((369150285714206 / 8639957931 : ℚ)) * X ^ 11 + C ((307055440735055 / 5759971954 : ℚ)) * X ^ 12 + C ((976527130916351 / 17279915862 : ℚ)) * X ^ 13 + C ((1070009708371159 / 17279915862 : ℚ)) * X ^ 14 + C ((472410194845223 / 8639957931 : ℚ)) * X ^ 15 + C ((346631987498629 / 8639957931 : ℚ)) * X ^ 16 + C ((165256025215957 / 5759971954 : ℚ)) * X ^ 17 + C ((91906478481514 / 8639957931 : ℚ)) * X ^ 18
theorem CV_121_2_pre_eq :
    CV_2_re_101 * Fplus_dW_re_020 - CV_2_im_101 * Fplus_dW_im_020 = CV_121_2_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_2_re_101, CV_2_im_101, Fplus_dW_re_020, Fplus_dW_im_020, CV_121_2_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CV_121_2_pim_eq :
    CV_2_re_101 * Fplus_dW_im_020 + CV_2_im_101 * Fplus_dW_re_020 = CV_121_2_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_2_re_101, CV_2_im_101, Fplus_dW_re_020, Fplus_dW_im_020, CV_121_2_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CV_121_2_mul :
    CV_2_c_101 * Fplus_dW_c_020 = ofLadj CV_121_2_pre CV_121_2_pim := by
  rw [CV_2_c_101, Fplus_dW_c_020, ofLadj_mul, CV_121_2_pre_eq, CV_121_2_pim_eq]

theorem CV_121_3_mul : CV_3_c_111 = ofLadj CV_3_re_111 CV_3_im_111 := rfl

@[expose] public def CV_coeff_121 : Ki := CV_0_c_101 * Fplus_dU_c_020 + CV_1_c_101 * Fplus_dV_c_020 + CV_2_c_101 * Fplus_dW_c_020 + CV_3_c_111

theorem CV_coeff_121_sum :
    CV_coeff_121 = ofLadj (CV_121_0_pre + CV_121_1_pre + CV_121_2_pre + CV_3_re_111) (CV_121_0_pim + CV_121_1_pim + CV_121_2_pim + CV_3_im_111) := by
  simp only [CV_coeff_121, CV_121_0_mul, CV_121_1_mul, CV_121_2_mul, CV_121_3_mul]
  simpa [add_assoc] using ofLadj_add4 CV_121_0_pre CV_121_0_pim CV_121_1_pre CV_121_1_pim CV_121_2_pre CV_121_2_pim CV_3_re_111 CV_3_im_111

def CV_121_qre : Polynomial ℚ := C ((21841029290935 / 17279915862 : ℚ)) + C ((324657177294365 / 17279915862 : ℚ)) * X + C ((108893384009891 / 5759971954 : ℚ)) * X ^ 2 + C ((433460600612069 / 17279915862 : ℚ)) * X ^ 3 + C ((274705228786453 / 8639957931 : ℚ)) * X ^ 4 + C ((309144094883593 / 17279915862 : ℚ)) * X ^ 5 + C ((264661330403533 / 17279915862 : ℚ)) * X ^ 6 + C ((16236026330483 / 1570901442 : ℚ)) * X ^ 7 + C ((-47252859859967 / 8639957931 : ℚ)) * X ^ 8
def CV_121_qim : Polynomial ℚ := C ((-234448617237623 / 17279915862 : ℚ)) + C ((-234448617237623 / 17279915862 : ℚ)) * X + C ((-79682337055243 / 17279915862 : ℚ)) * X ^ 2 + C ((-40339347991247 / 5759971954 : ℚ)) * X ^ 3 + C ((75471465044924 / 8639957931 : ℚ)) * X ^ 4 + C ((101004300685895 / 5759971954 : ℚ)) * X ^ 5 + C ((75402619389587 / 5759971954 : ℚ)) * X ^ 6 + C ((370019003766553 / 17279915862 : ℚ)) * X ^ 7 + C ((108928763911919 / 8639957931 : ℚ)) * X ^ 8
theorem CV_coeff_121_poly_re :
    CV_121_0_pre + CV_121_1_pre + CV_121_2_pre + CV_3_re_111 = (0 : Polynomial ℚ) + Phi11 * CV_121_qre := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [CV_121_0_pre, CV_121_1_pre, CV_121_2_pre, CV_3_re_111, CV_121_qre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try ring
theorem CV_coeff_121_poly_im :
    CV_121_0_pim + CV_121_1_pim + CV_121_2_pim + CV_3_im_111 = (0 : Polynomial ℚ) + Phi11 * CV_121_qim := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [CV_121_0_pim, CV_121_1_pim, CV_121_2_pim, CV_3_im_111, CV_121_qim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try ring
public theorem CV_coeff_121_eq :
    CV_coeff_121 = (0 : Ki) := by
  rw [CV_coeff_121_sum, CV_coeff_121_poly_re,
    CV_coeff_121_poly_im, ofLadj_add_Phi11]
  exact ofLadj_zero

end V14Formalization.D12SigmaPlusSegreCore
