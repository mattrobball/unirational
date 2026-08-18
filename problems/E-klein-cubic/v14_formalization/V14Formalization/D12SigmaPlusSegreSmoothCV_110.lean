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

def CV_110_0_pre : Polynomial ℚ := C ((1702371588773 / 17279915862 : ℚ)) + C ((-65370537411868 / 8639957931 : ℚ)) * X + C ((-130113530187475 / 8639957931 : ℚ)) * X ^ 2 + C ((-424465412443747 / 17279915862 : ℚ)) * X ^ 3 + C ((-359473311110267 / 8639957931 : ℚ)) * X ^ 4 + C ((-919723392768731 / 17279915862 : ℚ)) * X ^ 5 + C ((-100899648698383 / 1570901442 : ℚ)) * X ^ 6 + C ((-198662610091992 / 2879985977 : ℚ)) * X ^ 7 + C ((-554622488421299 / 8639957931 : ℚ)) * X ^ 8 + C ((-95493204158849 / 1570901442 : ℚ)) * X ^ 9 + C ((-502536217928267 / 8639957931 : ℚ)) * X ^ 10 + C ((-495111790871672 / 8639957931 : ℚ)) * X ^ 11 + C ((-437165680516399 / 8639957931 : ℚ)) * X ^ 12 + C ((-790198185372389 / 17279915862 : ℚ)) * X ^ 13 + C ((-228259854799617 / 5759971954 : ℚ)) * X ^ 14 + C ((-444725122640549 / 17279915862 : ℚ)) * X ^ 15 + C ((-276162733322611 / 17279915862 : ℚ)) * X ^ 16 + C ((-85989990409129 / 17279915862 : ℚ)) * X ^ 17 + C ((9434638563623 / 5759971954 : ℚ)) * X ^ 18
def CV_110_0_pim : Polynomial ℚ := C ((41407826851657 / 5759971954 : ℚ)) + C ((41407826851657 / 2879985977 : ℚ)) * X + C ((160082705545205 / 8639957931 : ℚ)) * X ^ 2 + C ((440385837378727 / 17279915862 : ℚ)) * X ^ 3 + C ((221356675319630 / 8639957931 : ℚ)) * X ^ 4 + C ((325271373674237 / 17279915862 : ℚ)) * X ^ 5 + C ((196050571426309 / 17279915862 : ℚ)) * X ^ 6 + C ((-26969920083209 / 8639957931 : ℚ)) * X ^ 7 + C ((-93999598173733 / 8639957931 : ℚ)) * X ^ 8 + C ((-16359191503693 / 1570901442 : ℚ)) * X ^ 9 + C ((-70309807374835 / 8639957931 : ℚ)) * X ^ 10 + C ((-103840257867545 / 8639957931 : ℚ)) * X ^ 11 + C ((-45790236120085 / 2879985977 : ℚ)) * X ^ 12 + C ((-307128374910025 / 17279915862 : ℚ)) * X ^ 13 + C ((-419300711391499 / 17279915862 : ℚ)) * X ^ 14 + C ((-40528496543653 / 1570901442 : ℚ)) * X ^ 15 + C ((-379213420668295 / 17279915862 : ℚ)) * X ^ 16 + C ((-309022594792489 / 17279915862 : ℚ)) * X ^ 17 + C ((-36624706284299 / 5759971954 : ℚ)) * X ^ 18
theorem CV_110_0_pre_eq :
    CV_0_re_000 * Fplus_dU_re_110 - CV_0_im_000 * Fplus_dU_im_110 = CV_110_0_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_0_re_000_def, CV_0_im_000_def, Fplus_dU_re_110_def, Fplus_dU_im_110_def, CV_110_0_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CV_110_0_pim_eq :
    CV_0_re_000 * Fplus_dU_im_110 + CV_0_im_000 * Fplus_dU_re_110 = CV_110_0_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_0_re_000_def, CV_0_im_000_def, Fplus_dU_re_110_def, Fplus_dU_im_110_def, CV_110_0_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CV_110_0_mul :
    CV_0_c_000 * Fplus_dU_c_110 = ofLadj CV_110_0_pre CV_110_0_pim := by
  rw [CV_0_c_000_def, Fplus_dU_c_110_def, ofLadj_mul, CV_110_0_pre_eq, CV_110_0_pim_eq]

def CV_110_1_pre : Polynomial ℚ := C ((65304345726 / 2879985977 : ℚ)) + C ((-135038344212800 / 8639957931 : ℚ)) * X + C ((-510223881445427 / 17279915862 : ℚ)) * X ^ 2 + C ((-439790930320607 / 8639957931 : ℚ)) * X ^ 3 + C ((-1435939105688795 / 17279915862 : ℚ)) * X ^ 4 + C ((-1852225815470207 / 17279915862 : ℚ)) * X ^ 5 + C ((-376508581436968 / 2879985977 : ℚ)) * X ^ 6 + C ((-2585761649051785 / 17279915862 : ℚ)) * X ^ 7 + C ((-876360530360547 / 5759971954 : ℚ)) * X ^ 8 + C ((-82440904775039 / 523633814 : ℚ)) * X ^ 9 + C ((-2791018612023209 / 17279915862 : ℚ)) * X ^ 10 + C ((-1408533318106994 / 8639957931 : ℚ)) * X ^ 11 + C ((-2520941923597609 / 17279915862 : ℚ)) * X ^ 12 + C ((-1105162988065430 / 8639957931 : ℚ)) * X ^ 13 + C ((-1749499730440427 / 17279915862 : ℚ)) * X ^ 14 + C ((-554253037565387 / 8639957931 : ℚ)) * X ^ 15 + C ((-2405182275835 / 64718786 : ℚ)) * X ^ 16 + C ((-117678997248172 / 8639957931 : ℚ)) * X ^ 17 + C ((20658234116108 / 8639957931 : ℚ)) * X ^ 18
def CV_110_1_pim : Polynomial ℚ := C ((124769504078050 / 8639957931 : ℚ)) + C ((249539008156100 / 8639957931 : ℚ)) * X + C ((224560007266773 / 5759971954 : ℚ)) * X ^ 2 + C ((473677787620732 / 8639957931 : ℚ)) * X ^ 3 + C ((990242963622841 / 17279915862 : ℚ)) * X ^ 4 + C ((80127926040907 / 1570901442 : ℚ)) * X ^ 5 + C ((128837720506918 / 2879985977 : ℚ)) * X ^ 6 + C ((153601127871803 / 5759971954 : ℚ)) * X ^ 7 + C ((79154121514989 / 5759971954 : ℚ)) * X ^ 8 + C ((224502781188865 / 17279915862 : ℚ)) * X ^ 9 + C ((54525226720175 / 5759971954 : ℚ)) * X ^ 10 + C ((-87429225670880 / 8639957931 : ℚ)) * X ^ 11 + C ((-513292582844045 / 17279915862 : ℚ)) * X ^ 12 + C ((-374410844680252 / 8639957931 : ℚ)) * X ^ 13 + C ((-345152275385917 / 5759971954 : ℚ)) * X ^ 14 + C ((-173364317086054 / 2879985977 : ℚ)) * X ^ 15 + C ((-852898837489693 / 17279915862 : ℚ)) * X ^ 16 + C ((-326086779186556 / 8639957931 : ℚ)) * X ^ 17 + C ((-130749665546623 / 8639957931 : ℚ)) * X ^ 18
theorem CV_110_1_pre_eq :
    CV_1_re_000 * Fplus_dV_re_110 - CV_1_im_000 * Fplus_dV_im_110 = CV_110_1_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_1_re_000_def, CV_1_im_000_def, Fplus_dV_re_110_def, Fplus_dV_im_110_def, CV_110_1_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CV_110_1_pim_eq :
    CV_1_re_000 * Fplus_dV_im_110 + CV_1_im_000 * Fplus_dV_re_110 = CV_110_1_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_1_re_000_def, CV_1_im_000_def, Fplus_dV_re_110_def, Fplus_dV_im_110_def, CV_110_1_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CV_110_1_mul :
    CV_1_c_000 * Fplus_dV_c_110 = ofLadj CV_110_1_pre CV_110_1_pim := by
  rw [CV_1_c_000_def, Fplus_dV_c_110_def, ofLadj_mul, CV_110_1_pre_eq, CV_110_1_pim_eq]

def CV_110_2_pre : Polynomial ℚ := C ((-8961162775450 / 8639957931 : ℚ)) + C ((-128015280095800 / 8639957931 : ℚ)) * X + C ((-23587979203879 / 785450721 : ℚ)) * X ^ 2 + C ((-142069131627611 / 2879985977 : ℚ)) * X ^ 3 + C ((-635446713684394 / 8639957931 : ℚ)) * X ^ 4 + C ((-502673962337671 / 5759971954 : ℚ)) * X ^ 5 + C ((-1702473970951475 / 17279915862 : ℚ)) * X ^ 6 + C ((-602313618891125 / 5759971954 : ℚ)) * X ^ 7 + C ((-287088518146571 / 2879985977 : ℚ)) * X ^ 8 + C ((-563337433876739 / 5759971954 : ℚ)) * X ^ 9 + C ((-832545551389187 / 8639957931 : ℚ)) * X ^ 10 + C ((-819031478509000 / 8639957931 : ℚ)) * X ^ 11 + C ((-64048206481217 / 785450721 : ℚ)) * X ^ 12 + C ((-1171076759144879 / 17279915862 : ℚ)) * X ^ 13 + C ((-145019386518960 / 2879985977 : ℚ)) * X ^ 14 + C ((-3980205001001 / 142809222 : ℚ)) * X ^ 15 + C ((-43689678802685 / 2879985977 : ℚ)) * X ^ 16 + C ((-33842994438824 / 8639957931 : ℚ)) * X ^ 17 + C ((27221312091733 / 8639957931 : ℚ)) * X ^ 18
def CV_110_2_pim : Polynomial ℚ := C ((86410275244355 / 8639957931 : ℚ)) + C ((172820550488710 / 8639957931 : ℚ)) * X + C ((203812461733127 / 8639957931 : ℚ)) * X ^ 2 + C ((21970943129737 / 785450721 : ℚ)) * X ^ 3 + C ((181258200704938 / 8639957931 : ℚ)) * X ^ 4 + C ((43072126724643 / 5759971954 : ℚ)) * X ^ 5 + C ((-59660331377923 / 17279915862 : ℚ)) * X ^ 6 + C ((-335958347075423 / 17279915862 : ℚ)) * X ^ 7 + C ((-7490769839664 / 261816907 : ℚ)) * X ^ 8 + C ((-489506327887919 / 17279915862 : ℚ)) * X ^ 9 + C ((-234025133759837 / 8639957931 : ℚ)) * X ^ 10 + C ((-27696350233460 / 785450721 : ℚ)) * X ^ 11 + C ((-125098190458761 / 2879985977 : ℚ)) * X ^ 12 + C ((-791116904873155 / 17279915862 : ℚ)) * X ^ 13 + C ((-143661374788535 / 2879985977 : ℚ)) * X ^ 14 + C ((-755101344783821 / 17279915862 : ℚ)) * X ^ 15 + C ((-274585413418333 / 8639957931 : ℚ)) * X ^ 16 + C ((-196691765627080 / 8639957931 : ℚ)) * X ^ 17 + C ((-24075836474242 / 2879985977 : ℚ)) * X ^ 18
theorem CV_110_2_pre_eq :
    CV_2_re_000 * Fplus_dW_re_110 - CV_2_im_000 * Fplus_dW_im_110 = CV_110_2_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_2_re_000_def, CV_2_im_000_def, Fplus_dW_re_110_def, Fplus_dW_im_110_def, CV_110_2_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CV_110_2_pim_eq :
    CV_2_re_000 * Fplus_dW_im_110 + CV_2_im_000 * Fplus_dW_re_110 = CV_110_2_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_2_re_000_def, CV_2_im_000_def, Fplus_dW_re_110_def, Fplus_dW_im_110_def, CV_110_2_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CV_110_2_mul :
    CV_2_c_000 * Fplus_dW_c_110 = ofLadj CV_110_2_pre CV_110_2_pim := by
  rw [CV_2_c_000_def, Fplus_dW_c_110_def, ofLadj_mul, CV_110_2_pre_eq, CV_110_2_pim_eq]

def CV_110_3_pre : Polynomial ℚ := C ((-12845379 / 261816907 : ℚ)) + C ((-2950692489 / 261816907 : ℚ)) * X ^ 2 + C ((-4916270522 / 261816907 : ℚ)) * X ^ 3 + C ((-8590795266 / 261816907 : ℚ)) * X ^ 4 + C ((-33026437250 / 785450721 : ℚ)) * X ^ 5 + C ((-33026437250 / 785450721 : ℚ)) * X ^ 6 + C ((-8590795266 / 261816907 : ℚ)) * X ^ 7 + C ((-4916270522 / 261816907 : ℚ)) * X ^ 8 + C ((-2950692489 / 261816907 : ℚ)) * X ^ 9
def CV_110_3_pim : Polynomial ℚ := C ((90715452185 / 8639957931 : ℚ)) + C ((181430904370 / 8639957931 : ℚ)) * X + C ((251205338941 / 8639957931 : ℚ)) * X ^ 2 + C ((88237116206 / 2879985977 : ℚ)) * X ^ 3 + C ((88965249922 / 2879985977 : ℚ)) * X ^ 4 + C ((48990431282 / 2879985977 : ℚ)) * X ^ 5 + C ((34459610524 / 8639957931 : ℚ)) * X ^ 6 + C ((-85464845396 / 8639957931 : ℚ)) * X ^ 7 + C ((-83280444248 / 8639957931 : ℚ)) * X ^ 8 + C ((-23258144857 / 2879985977 : ℚ)) * X ^ 9
theorem CV_110_3_neg_re : -CV_3_re_110 = CV_110_3_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_3_re_110_def, CV_110_3_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CV_110_3_neg_im : -CV_3_im_110 = CV_110_3_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_3_im_110_def, CV_110_3_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CV_110_3_mul : -CV_3_c_110 = ofLadj CV_110_3_pre CV_110_3_pim := by
  rw [CV_3_c_110_def, ofLadj_neg, CV_110_3_neg_re, CV_110_3_neg_im]

@[expose] public def CV_coeff_110 : Ki := CV_0_c_000 * Fplus_dU_c_110 + CV_1_c_000 * Fplus_dV_c_110 + CV_2_c_000 * Fplus_dW_c_110 + (-CV_3_c_110)

theorem CV_coeff_110_sum :
    CV_coeff_110 = ofLadj (CV_110_0_pre + CV_110_1_pre + CV_110_2_pre + CV_110_3_pre) (CV_110_0_pim + CV_110_1_pim + CV_110_2_pim + CV_110_3_pim) := by
  simp only [CV_coeff_110, CV_110_0_mul, CV_110_1_mul, CV_110_2_mul, CV_110_3_mul]
  simpa [add_assoc] using ofLadj_add4 CV_110_0_pre CV_110_0_pim CV_110_1_pre CV_110_1_pim CV_110_2_pre CV_110_2_pim CV_110_3_pre CV_110_3_pim

def CV_110_qre : Polynomial ℚ := C ((-5276325227595 / 5759971954 : ℚ)) + C ((-641019347758151 / 17279915862 : ℚ)) * X + C ((-210910968856351 / 5759971954 : ℚ)) * X ^ 2 + C ((-13139474343865 / 261816907 : ℚ)) * X ^ 3 + C ((-211593268510099 / 2879985977 : ℚ)) * X ^ 4 + C ((-38834160413899 / 785450721 : ℚ)) * X ^ 5 + C ((-263816833334515 / 5759971954 : ℚ)) * X ^ 6 + C ((-256548490944836 / 8639957931 : ℚ)) * X ^ 7 + C ((41354336035517 / 5759971954 : ℚ)) * X ^ 8
def CV_110_qim : Polynomial ℚ := C ((546764470104151 / 17279915862 : ℚ)) + C ((546764470104151 / 17279915862 : ℚ)) * X + C ((308443826826563 / 17279915862 : ℚ)) * X ^ 2 + C ((78276469522796 / 2879985977 : ℚ)) * X ^ 3 + C ((-1145834500002 / 261816907 : ℚ)) * X ^ 4 + C ((-76636270714279 / 2879985977 : ℚ)) * X ^ 5 + C ((-426703400574893 / 17279915862 : ℚ)) * X ^ 6 + C ((-139791869271361 / 2879985977 : ℚ)) * X ^ 7 + C ((-515828468791595 / 17279915862 : ℚ)) * X ^ 8
theorem CV_coeff_110_poly_re :
    CV_110_0_pre + CV_110_1_pre + CV_110_2_pre + CV_110_3_pre = (0 : Polynomial ℚ) + Phi11 * CV_110_qre := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [CV_110_0_pre, CV_110_1_pre, CV_110_2_pre, CV_110_3_pre, CV_110_qre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try grind
theorem CV_coeff_110_poly_im :
    CV_110_0_pim + CV_110_1_pim + CV_110_2_pim + CV_110_3_pim = (0 : Polynomial ℚ) + Phi11 * CV_110_qim := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [CV_110_0_pim, CV_110_1_pim, CV_110_2_pim, CV_110_3_pim, CV_110_qim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try grind
public theorem CV_coeff_110_eq :
    CV_coeff_110 = (0 : Ki) := by
  rw [CV_coeff_110_sum, CV_coeff_110_poly_re,
    CV_coeff_110_poly_im, ofLadj_add_Phi11]
  exact ofLadj_zero

end V14Formalization.D12SigmaPlusSegreCore
