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

def CV_022_0_pre : Polynomial ℚ := C ((-188344781792 / 2879985977 : ℚ)) + C ((-21708246569800 / 261816907 : ℚ)) * X + C ((-452176618609352 / 2879985977 : ℚ)) * X ^ 2 + C ((-2335563825222406 / 8639957931 : ℚ)) * X ^ 3 + C ((-3811436651274424 / 8639957931 : ℚ)) * X ^ 4 + C ((-4918280617672744 / 8639957931 : ℚ)) * X ^ 5 + C ((-5995481187657862 / 8639957931 : ℚ)) * X ^ 6 + C ((-2288119882634646 / 2879985977 : ℚ)) * X ^ 7 + C ((-6979310888493478 / 8639957931 : ℚ)) * X ^ 8 + C ((-7222920023407856 / 8639957931 : ℚ)) * X ^ 9 + C ((-2469609644646946 / 2879985977 : ℚ)) * X ^ 10 + C ((-2492561654367128 / 2879985977 : ℚ)) * X ^ 11 + C ((-2230818932379146 / 2879985977 : ℚ)) * X ^ 12 + C ((-5866390167579800 / 8639957931 : ℚ)) * X ^ 13 + C ((-1547915687757024 / 2879985977 : ℚ)) * X ^ 14 + C ((-2944115310965714 / 8639957931 : ℚ)) * X ^ 15 + C ((-6382875759092 / 32359393 : ℚ)) * X ^ 16 + C ((-209009085897482 / 2879985977 : ℚ)) * X ^ 17 + C ((36269228554600 / 2879985977 : ℚ)) * X ^ 18
def CV_022_0_pim : Polynomial ℚ := C ((220474850511500 / 2879985977 : ℚ)) + C ((440949701023000 / 2879985977 : ℚ)) * X + C ((595782020190256 / 2879985977 : ℚ)) * X ^ 2 + C ((836701043411448 / 2879985977 : ℚ)) * X ^ 3 + C ((2626706809105216 / 8639957931 : ℚ)) * X ^ 4 + C ((2335597368131006 / 8639957931 : ℚ)) * X ^ 5 + C ((2048222360377760 / 8639957931 : ℚ)) * X ^ 6 + C ((406731759358472 / 2879985977 : ℚ)) * X ^ 7 + C ((626544073672612 / 8639957931 : ℚ)) * X ^ 8 + C ((591547892768938 / 8639957931 : ℚ)) * X ^ 9 + C ((143475258460618 / 2879985977 : ℚ)) * X ^ 10 + C ((-467108986552060 / 8639957931 : ℚ)) * X ^ 11 + C ((-124058522589634 / 785450721 : ℚ)) * X ^ 12 + C ((-60310994647722 / 261816907 : ℚ)) * X ^ 13 + C ((-916005357980692 / 2879985977 : ℚ)) * X ^ 14 + C ((-920801491907048 / 2879985977 : ℚ)) * X ^ 15 + C ((-2264306004688312 / 8639957931 : ℚ)) * X ^ 16 + C ((-1730882593855574 / 8639957931 : ℚ)) * X ^ 17 + C ((-231955493831536 / 2879985977 : ℚ)) * X ^ 18
theorem CV_022_0_pre_eq :
    CV_0_re_002 * Fplus_dU_re_020 - CV_0_im_002 * Fplus_dU_im_020 = CV_022_0_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_0_re_002_def, CV_0_im_002_def, Fplus_dU_re_020_def, Fplus_dU_im_020_def, CV_022_0_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CV_022_0_pim_eq :
    CV_0_re_002 * Fplus_dU_im_020 + CV_0_im_002 * Fplus_dU_re_020 = CV_022_0_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_0_re_002_def, CV_0_im_002_def, Fplus_dU_re_020_def, Fplus_dU_im_020_def, CV_022_0_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CV_022_0_mul :
    CV_0_c_002 * Fplus_dU_c_020 = ofLadj CV_022_0_pre CV_022_0_pim := by
  rw [CV_0_c_002_def, Fplus_dU_c_020_def, ofLadj_mul, CV_022_0_pre_eq, CV_022_0_pim_eq]

def CV_022_1_pre : Polynomial ℚ := C ((22606483967586 / 2879985977 : ℚ)) + C ((217241626093000 / 2879985977 : ℚ)) * X + C ((378403726670380 / 2879985977 : ℚ)) * X ^ 2 + C ((610906027572740 / 2879985977 : ℚ)) * X ^ 3 + C ((922898792627056 / 2879985977 : ℚ)) * X ^ 4 + C ((1049382704857646 / 2879985977 : ℚ)) * X ^ 5 + C ((1203668631798498 / 2879985977 : ℚ)) * X ^ 6 + C ((1381270748359454 / 2879985977 : ℚ)) * X ^ 7 + C ((1414533557547922 / 2879985977 : ℚ)) * X ^ 8 + C ((1524909916965146 / 2879985977 : ℚ)) * X ^ 9 + C ((1609264248969534 / 2879985977 : ℚ)) * X ^ 10 + C ((1618034753134792 / 2879985977 : ℚ)) * X ^ 11 + C ((126547511170594 / 261816907 : ℚ)) * X ^ 12 + C ((1146506190294766 / 2879985977 : ℚ)) * X ^ 13 + C ((73057048179562 / 261816907 : ℚ)) * X ^ 14 + C ((390140193763950 / 2879985977 : ℚ)) * X ^ 15 + C ((203364711586382 / 2879985977 : ℚ)) * X ^ 16 + C ((49078784645530 / 2879985977 : ℚ)) * X ^ 17 + C ((-68231761968448 / 2879985977 : ℚ)) * X ^ 18
def CV_022_1_pim : Polynomial ℚ := C ((-124472774324332 / 2879985977 : ℚ)) + C ((-248945548648664 / 2879985977 : ℚ)) * X + C ((-286907950554172 / 2879985977 : ℚ)) * X ^ 2 + C ((-371979572760278 / 2879985977 : ℚ)) * X ^ 3 + C ((-279728847047954 / 2879985977 : ℚ)) * X ^ 4 + C ((-126064183776854 / 2879985977 : ℚ)) * X ^ 5 + C ((-84629770845262 / 2879985977 : ℚ)) * X ^ 6 + C ((71567971295160 / 2879985977 : ℚ)) * X ^ 7 + C ((190727664197838 / 2879985977 : ℚ)) * X ^ 8 + C ((206634786816382 / 2879985977 : ℚ)) * X ^ 9 + C ((279661915179522 / 2879985977 : ℚ)) * X ^ 10 + C ((511175739134272 / 2879985977 : ℚ)) * X ^ 11 + C ((742689563089022 / 2879985977 : ℚ)) * X ^ 12 + C ((853679093357670 / 2879985977 : ℚ)) * X ^ 13 + C ((954657838182320 / 2879985977 : ℚ)) * X ^ 14 + C ((816023263751078 / 2879985977 : ℚ)) * X ^ 15 + C ((568566909179262 / 2879985977 : ℚ)) * X ^ 16 + C ((415532975062734 / 2879985977 : ℚ)) * X ^ 17 + C ((165543541621596 / 2879985977 : ℚ)) * X ^ 18
theorem CV_022_1_pre_eq :
    CV_1_re_002 * Fplus_dV_re_020 - CV_1_im_002 * Fplus_dV_im_020 = CV_022_1_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_1_re_002_def, CV_1_im_002_def, Fplus_dV_re_020_def, Fplus_dV_im_020_def, CV_022_1_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CV_022_1_pim_eq :
    CV_1_re_002 * Fplus_dV_im_020 + CV_1_im_002 * Fplus_dV_re_020 = CV_022_1_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_1_re_002_def, CV_1_im_002_def, Fplus_dV_re_020_def, Fplus_dV_im_020_def, CV_022_1_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CV_022_1_mul :
    CV_1_c_002 * Fplus_dV_c_020 = ofLadj CV_022_1_pre CV_022_1_pim := by
  rw [CV_1_c_002_def, Fplus_dV_c_020_def, ofLadj_mul, CV_022_1_pre_eq, CV_022_1_pim_eq]

def CV_022_2_pre : Polynomial ℚ := C ((78940911432320 / 8639957931 : ℚ)) + C ((1139632422495392 / 8639957931 : ℚ)) * X + C ((205324677475628 / 785450721 : ℚ)) * X ^ 2 + C ((3704299708514084 / 8639957931 : ℚ)) * X ^ 3 + C ((5525377174590058 / 8639957931 : ℚ)) * X ^ 4 + C ((2193626540276478 / 2879985977 : ℚ)) * X ^ 5 + C ((7443933321055468 / 8639957931 : ℚ)) * X ^ 6 + C ((7963102554231664 / 8639957931 : ℚ)) * X ^ 7 + C ((7586134966342706 / 8639957931 : ℚ)) * X ^ 8 + C ((7500428863551820 / 8639957931 : ℚ)) * X ^ 9 + C ((7434774504063094 / 8639957931 : ℚ)) * X ^ 10 + C ((7331565571947968 / 8639957931 : ℚ)) * X ^ 11 + C ((52025967616262 / 71404611 : ℚ)) * X ^ 12 + C ((1747285803773304 / 2879985977 : ℚ)) * X ^ 13 + C ((1293945085942874 / 2879985977 : ℚ)) * X ^ 14 + C ((2139702281360372 / 8639957931 : ℚ)) * X ^ 15 + C ((1131019510001416 / 8639957931 : ℚ)) * X ^ 16 + C ((89321936591794 / 2879985977 : ℚ)) * X ^ 17 + C ((-298023098281234 / 8639957931 : ℚ)) * X ^ 18
def CV_022_2_pim : Polynomial ℚ := C ((-776729706224176 / 8639957931 : ℚ)) + C ((-1553459412448352 / 8639957931 : ℚ)) * X + C ((-1821474716465468 / 8639957931 : ℚ)) * X ^ 2 + C ((-729424419967812 / 2879985977 : ℚ)) * X ^ 3 + C ((-559926737240554 / 2879985977 : ℚ)) * X ^ 4 + C ((-216317940702126 / 2879985977 : ℚ)) * X ^ 5 + C ((186859189731508 / 8639957931 : ℚ)) * X ^ 6 + C ((481464131960826 / 2879985977 : ℚ)) * X ^ 7 + C ((725531593495650 / 2879985977 : ℚ)) * X ^ 8 + C ((2164169737582304 / 8639957931 : ℚ)) * X ^ 9 + C ((191585421459760 / 785450721 : ℚ)) * X ^ 10 + C ((2800974604422944 / 8639957931 : ℚ)) * X ^ 11 + C ((3494509572788528 / 8639957931 : ℚ)) * X ^ 12 + C ((3705794775280700 / 8639957931 : ℚ)) * X ^ 13 + C ((4060168275814022 / 8639957931 : ℚ)) * X ^ 14 + C ((3587807108593942 / 8639957931 : ℚ)) * X ^ 15 + C ((2629792728577928 / 8639957931 : ℚ)) * X ^ 16 + C ((1880791700194478 / 8639957931 : ℚ)) * X ^ 17 + C ((63279136694798 / 785450721 : ℚ)) * X ^ 18
theorem CV_022_2_pre_eq :
    CV_2_re_002 * Fplus_dW_re_020 - CV_2_im_002 * Fplus_dW_im_020 = CV_022_2_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_2_re_002_def, CV_2_im_002_def, Fplus_dW_re_020_def, Fplus_dW_im_020_def, CV_022_2_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CV_022_2_pim_eq :
    CV_2_re_002 * Fplus_dW_im_020 + CV_2_im_002 * Fplus_dW_re_020 = CV_022_2_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_2_re_002_def, CV_2_im_002_def, Fplus_dW_re_020_def, Fplus_dW_im_020_def, CV_022_2_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CV_022_2_mul :
    CV_2_c_002 * Fplus_dW_c_020 = ofLadj CV_022_2_pre CV_022_2_pim := by
  rw [CV_2_c_002_def, Fplus_dW_c_020_def, ofLadj_mul, CV_022_2_pre_eq, CV_022_2_pim_eq]

theorem CV_022_3_mul : CV_3_c_012 = ofLadj CV_3_re_012 CV_3_im_012 := CV_3_c_012_def

@[expose] public def CV_coeff_022 : Ki := CV_0_c_002 * Fplus_dU_c_020 + CV_1_c_002 * Fplus_dV_c_020 + CV_2_c_002 * Fplus_dW_c_020 + CV_3_c_012

theorem CV_coeff_022_sum :
    CV_coeff_022 = ofLadj (CV_022_0_pre + CV_022_1_pre + CV_022_2_pre + CV_3_re_012) (CV_022_0_pim + CV_022_1_pim + CV_022_2_pim + CV_3_im_012) := by
  simp only [CV_coeff_022, CV_022_0_mul, CV_022_1_mul, CV_022_2_mul, CV_022_3_mul]
  simpa [add_assoc] using ofLadj_add4 CV_022_0_pre CV_022_0_pim CV_022_1_pre CV_022_1_pim CV_022_2_pre CV_022_2_pim CV_3_re_012 CV_3_im_012

def CV_022_qre : Polynomial ℚ := C ((145753448779898 / 8639957931 : ℚ)) + C ((309743905063698 / 2879985977 : ℚ)) * X + C ((963767338435456 / 8639957931 : ℚ)) * X ^ 2 + C ((1166015030141314 / 8639957931 : ℚ)) * X ^ 3 + C ((427654410932196 / 2879985977 : ℚ)) * X ^ 4 + C ((329121734603510 / 8639957931 : ℚ)) * X ^ 5 + C ((22610082823952 / 785450721 : ℚ)) * X ^ 6 + C ((182085604542304 / 8639957931 : ℚ)) * X ^ 7 + C ((-393910698522778 / 8639957931 : ℚ)) * X ^ 8
def CV_022_qim : Polynomial ℚ := C ((-490541678295920 / 8639957931 : ℚ)) + C ((-490541678295920 / 8639957931 : ℚ)) * X + C ((7396843780976 / 785450721 : ℚ)) * X ^ 2 + C ((33481171853326 / 2879985977 : ℚ)) * X ^ 3 + C ((902653292292874 / 8639957931 : ℚ)) * X ^ 4 + C ((400761657566210 / 2879985977 : ℚ)) * X ^ 5 + C ((674679419900296 / 8639957931 : ℚ)) * X ^ 6 + C ((899673384514148 / 8639957931 : ℚ)) * X ^ 7 + C ((496834647012958 / 8639957931 : ℚ)) * X ^ 8
theorem CV_coeff_022_poly_re :
    CV_022_0_pre + CV_022_1_pre + CV_022_2_pre + CV_3_re_012 = (0 : Polynomial ℚ) + Phi11 * CV_022_qre := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [CV_022_0_pre, CV_022_1_pre, CV_022_2_pre, CV_3_re_012_def, CV_022_qre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try grind
theorem CV_coeff_022_poly_im :
    CV_022_0_pim + CV_022_1_pim + CV_022_2_pim + CV_3_im_012 = (0 : Polynomial ℚ) + Phi11 * CV_022_qim := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [CV_022_0_pim, CV_022_1_pim, CV_022_2_pim, CV_3_im_012_def, CV_022_qim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try grind
public theorem CV_coeff_022_eq :
    CV_coeff_022 = (0 : Ki) := by
  rw [CV_coeff_022_sum, CV_coeff_022_poly_re,
    CV_coeff_022_poly_im, ofLadj_add_Phi11]
  exact ofLadj_zero

end V14Formalization.D12SigmaPlusSegreCore
