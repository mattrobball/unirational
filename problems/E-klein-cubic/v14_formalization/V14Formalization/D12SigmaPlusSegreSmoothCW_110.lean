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

def CW_110_0_pre : Polynomial ℚ := C ((-438912298351 / 17279915862 : ℚ)) + C ((12538754009260 / 8639957931 : ℚ)) * X + C ((24865020045629 / 8639957931 : ℚ)) * X ^ 2 + C ((40948473075944 / 8639957931 : ℚ)) * X ^ 3 + C ((6299628216842 / 785450721 : ℚ)) * X ^ 4 + C ((88370384396698 / 8639957931 : ℚ)) * X ^ 5 + C ((214225449177065 / 17279915862 : ℚ)) * X ^ 6 + C ((76590693895135 / 5759971954 : ℚ)) * X ^ 7 + C ((106730555304809 / 8639957931 : ℚ)) * X ^ 8 + C ((101118369417980 / 8639957931 : ℚ)) * X ^ 9 + C ((96594437312702 / 8639957931 : ℚ)) * X ^ 10 + C ((95343109515118 / 8639957931 : ℚ)) * X ^ 11 + C ((84055683303442 / 8639957931 : ℚ)) * X ^ 12 + C ((25417783124117 / 2879985977 : ℚ)) * X ^ 13 + C ((21927360742955 / 2879985977 : ℚ)) * X ^ 14 + C ((42750591591029 / 8639957931 : ℚ)) * X ^ 15 + C ((17800157685485 / 5759971954 : ℚ)) * X ^ 16 + C ((2652632112131 / 2879985977 : ℚ)) * X ^ 17 + C ((-172093264631 / 523633814 : ℚ)) * X ^ 18
def CW_110_0_pim : Polynomial ℚ := C ((-23859473602771 / 17279915862 : ℚ)) + C ((-23859473602771 / 8639957931 : ℚ)) * X + C ((-30814799659949 / 8639957931 : ℚ)) * X ^ 2 + C ((-1289604672539 / 261816907 : ℚ)) * X ^ 3 + C ((-42404362212142 / 8639957931 : ℚ)) * X ^ 4 + C ((-86470529290 / 23801537 : ℚ)) * X ^ 5 + C ((-37858596007483 / 17279915862 : ℚ)) * X ^ 6 + C ((3694077425215 / 5759971954 : ℚ)) * X ^ 7 + C ((6112928229975 / 2879985977 : ℚ)) * X ^ 8 + C ((1604214955042 / 785450721 : ℚ)) * X ^ 9 + C ((13793259319567 / 8639957931 : ℚ)) * X ^ 10 + C ((20197257963283 / 8639957931 : ℚ)) * X ^ 11 + C ((26601256606999 / 8639957931 : ℚ)) * X ^ 12 + C ((29703477478282 / 8639957931 : ℚ)) * X ^ 13 + C ((40753211827657 / 8639957931 : ℚ)) * X ^ 14 + C ((42901123517870 / 8639957931 : ℚ)) * X ^ 15 + C ((73746536727601 / 17279915862 : ℚ)) * X ^ 16 + C ((29979874096006 / 8639957931 : ℚ)) * X ^ 17 + C ((6998109920163 / 5759971954 : ℚ)) * X ^ 18
theorem CW_110_0_pre_eq :
    CW_0_re_000 * Fplus_dU_re_110 - CW_0_im_000 * Fplus_dU_im_110 = CW_110_0_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_0_re_000, CW_0_im_000, Fplus_dU_re_110, Fplus_dU_im_110, CW_110_0_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CW_110_0_pim_eq :
    CW_0_re_000 * Fplus_dU_im_110 + CW_0_im_000 * Fplus_dU_re_110 = CW_110_0_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_0_re_000, CW_0_im_000, Fplus_dU_re_110, Fplus_dU_im_110, CW_110_0_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CW_110_0_mul :
    CW_0_c_000 * Fplus_dU_c_110 = ofLadj CW_110_0_pre CW_110_0_pim := by
  rw [CW_0_c_000, Fplus_dU_c_110, ofLadj_mul, CW_110_0_pre_eq, CW_110_0_pim_eq]

def CW_110_1_pre : Polynomial ℚ := C ((-958456314289 / 17279915862 : ℚ)) + C ((21724880203150 / 8639957931 : ℚ)) * X + C ((81241642837775 / 17279915862 : ℚ)) * X ^ 2 + C ((46772617056195 / 5759971954 : ℚ)) * X ^ 3 + C ((76676674812901 / 5759971954 : ℚ)) * X ^ 4 + C ((49334219606680 / 2879985977 : ℚ)) * X ^ 5 + C ((361709026154887 / 17279915862 : ℚ)) * X ^ 6 + C ((68937624009098 / 2879985977 : ℚ)) * X ^ 7 + C ((420840304274351 / 17279915862 : ℚ)) * X ^ 8 + C ((72510780598090 / 2879985977 : ℚ)) * X ^ 9 + C ((446955403647263 / 17279915862 : ℚ)) * X ^ 10 + C ((75288759202471 / 2879985977 : ℚ)) * X ^ 11 + C ((134501881080321 / 5759971954 : ℚ)) * X ^ 12 + C ((353823040750765 / 17279915862 : ℚ)) * X ^ 13 + C ((140261226552883 / 8639957931 : ℚ)) * X ^ 14 + C ((16099210016173 / 1570901442 : ℚ)) * X ^ 15 + C ((103186901739329 / 17279915862 : ℚ)) * X ^ 16 + C ((18741596612261 / 8639957931 : ℚ)) * X ^ 17 + C ((-3252204718991 / 8639957931 : ℚ)) * X ^ 18
def CW_110_1_pim : Polynomial ℚ := C ((-40409030585315 / 17279915862 : ℚ)) + C ((-40409030585315 / 8639957931 : ℚ)) * X + C ((-107837796955717 / 17279915862 : ℚ)) * X ^ 2 + C ((-153184419555371 / 17279915862 : ℚ)) * X ^ 3 + C ((-159259255514221 / 17279915862 : ℚ)) * X ^ 4 + C ((-6470240979784 / 785450721 : ℚ)) * X ^ 5 + C ((-41663852962245 / 5759971954 : ℚ)) * X ^ 6 + C ((-37577861126770 / 8639957931 : ℚ)) * X ^ 7 + C ((-13089072438765 / 5759971954 : ℚ)) * X ^ 8 + C ((-6266349081298 / 2879985977 : ℚ)) * X ^ 9 + C ((-9214285125537 / 5759971954 : ℚ)) * X ^ 10 + C ((4506743910525 / 2879985977 : ℚ)) * X ^ 11 + C ((27241260767637 / 5759971954 : ℚ)) * X ^ 12 + C ((39566252399725 / 5759971954 : ℚ)) * X ^ 13 + C ((82857251313668 / 8639957931 : ℚ)) * X ^ 14 + C ((165997350253411 / 17279915862 : ℚ)) * X ^ 15 + C ((45366849333415 / 5759971954 : ℚ)) * X ^ 16 + C ((17416529699568 / 2879985977 : ℚ)) * X ^ 17 + C ((1894567875910 / 785450721 : ℚ)) * X ^ 18
theorem CW_110_1_pre_eq :
    CW_1_re_000 * Fplus_dV_re_110 - CW_1_im_000 * Fplus_dV_im_110 = CW_110_1_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_1_re_000, CW_1_im_000, Fplus_dV_re_110, Fplus_dV_im_110, CW_110_1_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CW_110_1_pim_eq :
    CW_1_re_000 * Fplus_dV_im_110 + CW_1_im_000 * Fplus_dV_re_110 = CW_110_1_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_1_re_000, CW_1_im_000, Fplus_dV_re_110, Fplus_dV_im_110, CW_110_1_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CW_110_1_mul :
    CW_1_c_000 * Fplus_dV_c_110 = ofLadj CW_110_1_pre CW_110_1_pim := by
  rw [CW_1_c_000, Fplus_dV_c_110, ofLadj_mul, CW_110_1_pre_eq, CW_110_1_pim_eq]

def CW_110_2_pre : Polynomial ℚ := C ((1825748353978 / 8639957931 : ℚ)) + C ((21476988308200 / 8639957931 : ℚ)) * X + C ((43593552774886 / 8639957931 : ℚ)) * X ^ 2 + C ((72576950282776 / 8639957931 : ℚ)) * X ^ 3 + C ((107414954209480 / 8639957931 : ℚ)) * X ^ 4 + C ((42393720516134 / 2879985977 : ℚ)) * X ^ 5 + C ((144179585576674 / 8639957931 : ℚ)) * X ^ 6 + C ((50963312443017 / 2879985977 : ℚ)) * X ^ 7 + C ((290974120657793 / 17279915862 : ℚ)) * X ^ 8 + C ((4326278294666 / 261816907 : ℚ)) * X ^ 9 + C ((281277091563265 / 17279915862 : ℚ)) * X ^ 10 + C ((137986307018158 / 8639957931 : ℚ)) * X ^ 11 + C ((238323114946865 / 17279915862 : ℚ)) * X ^ 12 + C ((99173630949092 / 8639957931 : ℚ)) * X ^ 13 + C ((48606740030747 / 5759971954 : ℚ)) * X ^ 14 + C ((40581588418607 / 8639957931 : ℚ)) * X ^ 15 + C ((22367289526666 / 8639957931 : ℚ)) * X ^ 16 + C ((1789621832798 / 2879985977 : ℚ)) * X ^ 17 + C ((-148284687908 / 261816907 : ℚ)) * X ^ 18
def CW_110_2_pim : Polynomial ℚ := C ((-14362650786200 / 8639957931 : ℚ)) + C ((-28725301572400 / 8639957931 : ℚ)) * X + C ((-34585334852012 / 8639957931 : ℚ)) * X ^ 2 + C ((-40579527150487 / 8639957931 : ℚ)) * X ^ 3 + C ((-9938049167729 / 2879985977 : ℚ)) * X ^ 4 + C ((-10629823592491 / 8639957931 : ℚ)) * X ^ 5 + C ((5384240873318 / 8639957931 : ℚ)) * X ^ 6 + C ((9792225753276 / 2879985977 : ℚ)) * X ^ 7 + C ((85065411008195 / 17279915862 : ℚ)) * X ^ 8 + C ((42166415642170 / 8639957931 : ℚ)) * X ^ 9 + C ((26938409063151 / 5759971954 : ℚ)) * X ^ 10 + C ((52048166494840 / 8639957931 : ℚ)) * X ^ 11 + C ((127377438789907 / 17279915862 : ℚ)) * X ^ 12 + C ((67789950627122 / 8639957931 : ℚ)) * X ^ 13 + C ((146835706127339 / 17279915862 : ℚ)) * X ^ 14 + C ((21248713240281 / 2879985977 : ℚ)) * X ^ 15 + C ((15629854224098 / 2879985977 : ℚ)) * X ^ 16 + C ((11242350488053 / 2879985977 : ℚ)) * X ^ 17 + C ((12062361939796 / 8639957931 : ℚ)) * X ^ 18
theorem CW_110_2_pre_eq :
    CW_2_re_000 * Fplus_dW_re_110 - CW_2_im_000 * Fplus_dW_im_110 = CW_110_2_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_2_re_000, CW_2_im_000, Fplus_dW_re_110, Fplus_dW_im_110, CW_110_2_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CW_110_2_pim_eq :
    CW_2_re_000 * Fplus_dW_im_110 + CW_2_im_000 * Fplus_dW_re_110 = CW_110_2_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_2_re_000, CW_2_im_000, Fplus_dW_re_110, Fplus_dW_im_110, CW_110_2_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CW_110_2_mul :
    CW_2_c_000 * Fplus_dW_c_110 = ofLadj CW_110_2_pre CW_110_2_pim := by
  rw [CW_2_c_000, Fplus_dW_c_110, ofLadj_mul, CW_110_2_pre_eq, CW_110_2_pim_eq]

def CW_110_3_pre : Polynomial ℚ := C ((11755355443 / 261816907 : ℚ)) + C ((-21430606614 / 261816907 : ℚ)) * X ^ 2 + C ((-175189350265 / 785450721 : ℚ)) * X ^ 3 + C ((-263002454065 / 785450721 : ℚ)) * X ^ 4 + C ((-318590615612 / 785450721 : ℚ)) * X ^ 5 + C ((-318590615612 / 785450721 : ℚ)) * X ^ 6 + C ((-263002454065 / 785450721 : ℚ)) * X ^ 7 + C ((-175189350265 / 785450721 : ℚ)) * X ^ 8 + C ((-21430606614 / 261816907 : ℚ)) * X ^ 9
def CW_110_3_pim : Polynomial ℚ := C ((1110691916533 / 8639957931 : ℚ)) + C ((2221383833066 / 8639957931 : ℚ)) * X + C ((2855671510816 / 8639957931 : ℚ)) * X ^ 2 + C ((3079820142953 / 8639957931 : ℚ)) * X ^ 3 + C ((860548111003 / 2879985977 : ℚ)) * X ^ 4 + C ((1757616692156 / 8639957931 : ℚ)) * X ^ 5 + C ((154589046970 / 2879985977 : ℚ)) * X ^ 6 + C ((-360260499943 / 8639957931 : ℚ)) * X ^ 7 + C ((-286145436629 / 2879985977 : ℚ)) * X ^ 8 + C ((-634287677750 / 8639957931 : ℚ)) * X ^ 9
theorem CW_110_3_neg_re : -CW_3_re_110 = CW_110_3_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_3_re_110, CW_110_3_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CW_110_3_neg_im : -CW_3_im_110 = CW_110_3_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_3_im_110, CW_110_3_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CW_110_3_mul : -CW_3_c_110 = ofLadj CW_110_3_pre CW_110_3_pim := by
  rw [CW_3_c_110, ofLadj_neg, CW_110_3_neg_re, CW_110_3_neg_im]

def CW_coeff_110 : Ki := CW_0_c_000 * Fplus_dU_c_110 + CW_1_c_000 * Fplus_dV_c_110 + CW_2_c_000 * Fplus_dW_c_110 + (-CW_3_c_110)

theorem CW_coeff_110_sum :
    CW_coeff_110 = ofLadj (CW_110_0_pre + CW_110_1_pre + CW_110_2_pre + CW_110_3_pre) (CW_110_0_pim + CW_110_1_pim + CW_110_2_pim + CW_110_3_pim) := by
  simp only [CW_coeff_110, CW_110_0_mul, CW_110_1_mul, CW_110_2_mul, CW_110_3_mul]
  simpa [add_assoc] using ofLadj_add4 CW_110_0_pre CW_110_0_pim CW_110_1_pre CW_110_1_pim CW_110_2_pre CW_110_2_pim CW_110_3_pre CW_110_3_pim

def CW_110_qre : Polynomial ℚ := C ((504996925759 / 2879985977 : ℚ)) + C ((18075210581111 / 2879985977 : ℚ)) * X + C ((105263123401061 / 17279915862 : ℚ)) * X ^ 2 + C ((24461693956319 / 2879985977 : ℚ)) * X ^ 3 + C ((107075583729281 / 8639957931 : ℚ)) * X ^ 4 + C ((47477905449353 / 5759971954 : ℚ)) * X ^ 5 + C ((22864206159170 / 2879985977 : ℚ)) * X ^ 6 + C ((86106993466829 / 17279915862 : ℚ)) * X ^ 7 + C ((-21970276572733 / 17279915862 : ℚ)) * X ^ 8
def CW_110_qim : Polynomial ℚ := C ((-45386210963710 / 8639957931 : ℚ)) + C ((-45386210963710 / 8639957931 : ℚ)) * X + C ((-17127293034389 / 5759971954 : ℚ)) * X ^ 2 + C ((-40185509500003 / 8639957931 : ℚ)) * X ^ 3 + C ((2460792613192 / 2879985977 : ℚ)) * X ^ 4 + C ((75665666658403 / 17279915862 : ℚ)) * X ^ 5 + C ((35856590377348 / 8639957931 : ℚ)) * X ^ 6 + C ((145113482407637 / 17279915862 : ℚ)) * X ^ 7 + C ((28933182303367 / 5759971954 : ℚ)) * X ^ 8
theorem CW_coeff_110_poly_re :
    CW_110_0_pre + CW_110_1_pre + CW_110_2_pre + CW_110_3_pre = (0 : Polynomial ℚ) + Phi11 * CW_110_qre := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [CW_110_0_pre, CW_110_1_pre, CW_110_2_pre, CW_110_3_pre, CW_110_qre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try ring
theorem CW_coeff_110_poly_im :
    CW_110_0_pim + CW_110_1_pim + CW_110_2_pim + CW_110_3_pim = (0 : Polynomial ℚ) + Phi11 * CW_110_qim := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [CW_110_0_pim, CW_110_1_pim, CW_110_2_pim, CW_110_3_pim, CW_110_qim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try ring
theorem CW_coeff_110_eq :
    CW_coeff_110 = (0 : Ki) := by
  rw [CW_coeff_110_sum, CW_coeff_110_poly_re,
    CW_coeff_110_poly_im, ofLadj_add_Phi11]
  exact ofLadj_zero

end V14Formalization.D12SigmaPlusSegreCore
