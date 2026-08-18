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

def CV_200_0_pre : Polynomial ℚ := C ((14737560126303 / 11519943908 : ℚ)) + C ((-3030297491454 / 2879985977 : ℚ)) * X ^ 2 + C ((-35838959995357 / 11519943908 : ℚ)) * X ^ 3 + C ((-55614557250573 / 5759971954 : ℚ)) * X ^ 4 + C ((-46714553021113 / 2879985977 : ℚ)) * X ^ 5 + C ((-132476866259037 / 5759971954 : ℚ)) * X ^ 6 + C ((-164109155919303 / 5759971954 : ℚ)) * X ^ 7 + C ((-88035777918774 / 2879985977 : ℚ)) * X ^ 8 + C ((-181129877955633 / 5759971954 : ℚ)) * X ^ 9 + C ((-370238869077131 / 11519943908 : ℚ)) * X ^ 10 + C ((-387734267692545 / 11519943908 : ℚ)) * X ^ 11 + C ((-370238869077131 / 11519943908 : ℚ)) * X ^ 12 + C ((-175069282972725 / 5759971954 : ℚ)) * X ^ 13 + C ((-316304151679739 / 11519943908 : ℚ)) * X ^ 14 + C ((-231416310257141 / 11519943908 : ℚ)) * X ^ 15 + C ((-75116641333607 / 5759971954 : ℚ)) * X ^ 16 + C ((-1639494596218 / 261816907 : ℚ)) * X ^ 17 + C ((-1311555719971 / 1047267628 : ℚ)) * X ^ 18
def CV_200_0_pim : Polynomial ℚ := C ((49027903058901 / 11519943908 : ℚ)) + C ((49027903058901 / 5759971954 : ℚ)) * X + C ((79562472414281 / 5759971954 : ℚ)) * X ^ 2 + C ((121220520320157 / 5759971954 : ℚ)) * X ^ 3 + C ((293728505343607 / 11519943908 : ℚ)) * X ^ 4 + C ((79574717959982 / 2879985977 : ℚ)) * X ^ 5 + C ((324865571780087 / 11519943908 : ℚ)) * X ^ 6 + C ((277612606044171 / 11519943908 : ℚ)) * X ^ 7 + C ((61749400978531 / 2879985977 : ℚ)) * X ^ 8 + C ((61372877830756 / 2879985977 : ℚ)) * X ^ 9 + C ((238744765266417 / 11519943908 : ℚ)) * X ^ 10 + C ((16342634352967 / 1047267628 : ℚ)) * X ^ 11 + C ((120793190498857 / 11519943908 : ℚ)) * X ^ 12 + C ((26488652865745 / 5759971954 : ℚ)) * X ^ 13 + C ((-15922441335681 / 5759971954 : ℚ)) * X ^ 14 + C ((-78786801339089 / 11519943908 : ℚ)) * X ^ 15 + C ((-47353508235071 / 5759971954 : ℚ)) * X ^ 16 + C ((-90863665266797 / 11519943908 : ℚ)) * X ^ 17 + C ((-34960548165613 / 11519943908 : ℚ)) * X ^ 18
theorem CV_200_0_pre_eq :
    CV_0_re_000 * Fplus_dU_re_200 - CV_0_im_000 * Fplus_dU_im_200 = CV_200_0_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_0_re_000_def, CV_0_im_000_def, Fplus_dU_re_200_def, Fplus_dU_im_200_def, CV_200_0_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CV_200_0_pim_eq :
    CV_0_re_000 * Fplus_dU_im_200 + CV_0_im_000 * Fplus_dU_re_200 = CV_200_0_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_0_re_000_def, CV_0_im_000_def, Fplus_dU_re_200_def, Fplus_dU_im_200_def, CV_200_0_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CV_200_0_mul :
    CV_0_c_000 * Fplus_dU_c_200 = ofLadj CV_200_0_pre CV_200_0_pim := by
  rw [CV_0_c_000_def, Fplus_dU_c_200_def, ofLadj_mul, CV_200_0_pre_eq, CV_200_0_pim_eq]

def CV_200_1_pre : Polynomial ℚ := C ((238920837379 / 8639957931 : ℚ)) + C ((-27007668842560 / 8639957931 : ℚ)) * X + C ((-107802145870295 / 17279915862 : ℚ)) * X ^ 2 + C ((-7991908825921 / 785450721 : ℚ)) * X ^ 3 + C ((-594825565052327 / 34559831724 : ℚ)) * X ^ 4 + C ((-63431332030714 / 2879985977 : ℚ)) * X ^ 5 + C ((-306140753943785 / 11519943908 : ℚ)) * X ^ 6 + C ((-986490543970121 / 34559831724 : ℚ)) * X ^ 7 + C ((-229518818378771 / 8639957931 : ℚ)) * X ^ 8 + C ((-144890826680445 / 5759971954 : ℚ)) * X ^ 9 + C ((-207964745765866 / 8639957931 : ℚ)) * X ^ 10 + C ((-409535118085871 / 17279915862 : ℚ)) * X ^ 11 + C ((-60319025641102 / 2879985977 : ℚ)) * X ^ 12 + C ((-14857742462320 / 785450721 : ℚ)) * X ^ 13 + C ((-47202607097880 / 2879985977 : ℚ)) * X ^ 14 + C ((-30685595862443 / 2879985977 : ℚ)) * X ^ 15 + C ((-57121765286636 / 8639957931 : ℚ)) * X ^ 16 + C ((-71240783683757 / 34559831724 : ℚ)) * X ^ 17 + C ((3906304761413 / 5759971954 : ℚ)) * X ^ 18
def CV_200_1_pim : Polynomial ℚ := C ((776639167778 / 261816907 : ℚ)) + C ((1553278335556 / 261816907 : ℚ)) * X + C ((264808095256709 / 34559831724 : ℚ)) * X ^ 2 + C ((30307345043336 / 2879985977 : ℚ)) * X ^ 3 + C ((365508857884817 / 34559831724 : ℚ)) * X ^ 4 + C ((268630654561127 / 34559831724 : ℚ)) * X ^ 5 + C ((13444032377664 / 2879985977 : ℚ)) * X ^ 6 + C ((-11294644323968 / 8639957931 : ℚ)) * X ^ 7 + C ((-156676120033223 / 34559831724 : ℚ)) * X ^ 8 + C ((-13619768325653 / 3141802884 : ℚ)) * X ^ 9 + C ((-117402588329945 / 34559831724 : ℚ)) * X ^ 10 + C ((-14381043511536 / 2879985977 : ℚ)) * X ^ 11 + C ((-227742455946919 / 34559831724 : ℚ)) * X ^ 12 + C ((-11595588529909 / 1570901442 : ℚ)) * X ^ 13 + C ((-347124324470281 / 34559831724 : ℚ)) * X ^ 14 + C ((-30773511706184 / 2879985977 : ℚ)) * X ^ 15 + C ((-52354760395987 / 5759971954 : ℚ)) * X ^ 16 + C ((-255942784700645 / 34559831724 : ℚ)) * X ^ 17 + C ((-30386814699403 / 11519943908 : ℚ)) * X ^ 18
theorem CV_200_1_pre_eq :
    CV_1_re_000 * Fplus_dV_re_200 - CV_1_im_000 * Fplus_dV_im_200 = CV_200_1_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_1_re_000_def, CV_1_im_000_def, Fplus_dV_re_200_def, Fplus_dV_im_200_def, CV_200_1_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CV_200_1_pim_eq :
    CV_1_re_000 * Fplus_dV_im_200 + CV_1_im_000 * Fplus_dV_re_200 = CV_200_1_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_1_re_000_def, CV_1_im_000_def, Fplus_dV_re_200_def, Fplus_dV_im_200_def, CV_200_1_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CV_200_1_mul :
    CV_1_c_000 * Fplus_dV_c_200 = ofLadj CV_200_1_pre CV_200_1_pim := by
  rw [CV_1_c_000_def, Fplus_dV_c_200_def, ofLadj_mul, CV_200_1_pre_eq, CV_200_1_pim_eq]

def CV_200_2_pre : Polynomial ℚ := C ((7040863697455 / 8639957931 : ℚ)) + C ((51206112038320 / 8639957931 : ℚ)) * X + C ((192502328880811 / 17279915862 : ℚ)) * X ^ 2 + C ((100807908859297 / 5759971954 : ℚ)) * X ^ 3 + C ((431300175885859 / 17279915862 : ℚ)) * X ^ 4 + C ((986899696837609 / 34559831724 : ℚ)) * X ^ 5 + C ((98382900236683 / 3141802884 : ℚ)) * X ^ 6 + C ((281104678298798 / 8639957931 : ℚ)) * X ^ 7 + C ((521379045888433 / 17279915862 : ℚ)) * X ^ 8 + C ((513378551551889 / 17279915862 : ℚ)) * X ^ 9 + C ((1014942740774135 / 34559831724 : ℚ)) * X ^ 10 + C ((491027012880773 / 17279915862 : ℚ)) * X ^ 11 + C ((810118292620855 / 34559831724 : ℚ)) * X ^ 12 + C ((160438111335539 / 8639957931 : ℚ)) * X ^ 13 + C ((109477659655271 / 8639957931 : ℚ)) * X ^ 14 + C ((48631660133180 / 8639957931 : ℚ)) * X ^ 15 + C ((26293804257409 / 11519943908 : ℚ)) * X ^ 16 + C ((-16430792993677 / 34559831724 : ℚ)) * X ^ 17 + C ((-33645860445377 / 17279915862 : ℚ)) * X ^ 18
def CV_200_2_pim : Polynomial ℚ := C ((-23042734889120 / 8639957931 : ℚ)) + C ((-46085469778240 / 8639957931 : ℚ)) * X + C ((-29012865592891 / 5759971954 : ℚ)) * X ^ 2 + C ((-175587674415253 / 34559831724 : ℚ)) * X ^ 3 + C ((-12057951787979 / 8639957931 : ℚ)) * X ^ 4 + C ((146593192629487 / 34559831724 : ℚ)) * X ^ 5 + C ((98714218487655 / 11519943908 : ℚ)) * X ^ 6 + C ((487171589711795 / 34559831724 : ℚ)) * X ^ 7 + C ((17942736023041 / 1047267628 : ℚ)) * X ^ 8 + C ((590143487007365 / 34559831724 : ℚ)) * X ^ 9 + C ((144872564042497 / 8639957931 : ℚ)) * X ^ 10 + C ((14918998496258 / 785450721 : ℚ)) * X ^ 11 + C ((183345402875179 / 8639957931 : ℚ)) * X ^ 12 + C ((64769426827975 / 3141802884 : ℚ)) * X ^ 13 + C ((178001843553161 / 8639957931 : ℚ)) * X ^ 14 + C ((590920123249727 / 34559831724 : ℚ)) * X ^ 15 + C ((102486294586711 / 8639957931 : ℚ)) * X ^ 16 + C ((68962240529612 / 8639957931 : ℚ)) * X ^ 17 + C ((4485003761279 / 1570901442 : ℚ)) * X ^ 18
theorem CV_200_2_pre_eq :
    CV_2_re_000 * Fplus_dW_re_200 - CV_2_im_000 * Fplus_dW_im_200 = CV_200_2_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_2_re_000_def, CV_2_im_000_def, Fplus_dW_re_200_def, Fplus_dW_im_200_def, CV_200_2_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CV_200_2_pim_eq :
    CV_2_re_000 * Fplus_dW_im_200 + CV_2_im_000 * Fplus_dW_re_200 = CV_200_2_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_2_re_000_def, CV_2_im_000_def, Fplus_dW_re_200_def, Fplus_dW_im_200_def, CV_200_2_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CV_200_2_mul :
    CV_2_c_000 * Fplus_dW_c_200 = ofLadj CV_200_2_pre CV_200_2_pim := by
  rw [CV_2_c_000_def, Fplus_dW_c_200_def, ofLadj_mul, CV_200_2_pre_eq, CV_200_2_pim_eq]

def CV_200_3_pre : Polynomial ℚ := C ((-712 / 33 : ℚ)) + C ((552 / 11 : ℚ)) * X ^ 2 + C ((3928 / 33 : ℚ)) * X ^ 3 + C ((5948 / 33 : ℚ)) * X ^ 4 + C ((7184 / 33 : ℚ)) * X ^ 5 + C ((7184 / 33 : ℚ)) * X ^ 6 + C ((5948 / 33 : ℚ)) * X ^ 7 + C ((3928 / 33 : ℚ)) * X ^ 8 + C ((552 / 11 : ℚ)) * X ^ 9
def CV_200_3_pim : Polynomial ℚ := C ((-7974 / 121 : ℚ)) + C ((-15948 / 121 : ℚ)) * X + C ((-63824 / 363 : ℚ)) * X ^ 2 + C ((-67748 / 363 : ℚ)) * X ^ 3 + C ((-18970 / 121 : ℚ)) * X ^ 4 + C ((-36700 / 363 : ℚ)) * X ^ 5 + C ((-11144 / 363 : ℚ)) * X ^ 6 + C ((3022 / 121 : ℚ)) * X ^ 7 + C ((19904 / 363 : ℚ)) * X ^ 8 + C ((15980 / 363 : ℚ)) * X ^ 9
theorem CV_200_3_neg_re : -CV_3_re_200 = CV_200_3_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_3_re_200_def, CV_200_3_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CV_200_3_neg_im : -CV_3_im_200 = CV_200_3_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_3_im_200_def, CV_200_3_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CV_200_3_mul : -CV_3_c_200 = ofLadj CV_200_3_pre CV_200_3_pim := by
  rw [CV_3_c_200_def, ofLadj_neg, CV_200_3_neg_re, CV_200_3_neg_im]

@[expose] public def CV_coeff_200 : Ki := CV_0_c_000 * Fplus_dU_c_200 + CV_1_c_000 * Fplus_dV_c_200 + CV_2_c_000 * Fplus_dW_c_200 + (-CV_3_c_200)

theorem CV_coeff_200_sum :
    CV_coeff_200 = ofLadj (CV_200_0_pre + CV_200_1_pre + CV_200_2_pre + CV_200_3_pre) (CV_200_0_pim + CV_200_1_pim + CV_200_2_pim + CV_200_3_pim) := by
  simp only [CV_coeff_200, CV_200_0_mul, CV_200_1_mul, CV_200_2_mul, CV_200_3_mul]
  simpa [add_assoc] using ofLadj_add4 CV_200_0_pre CV_200_0_pim CV_200_1_pre CV_200_1_pim CV_200_2_pre CV_200_2_pim CV_200_3_pre CV_200_3_pim

def CV_200_qre : Polynomial ℚ := C ((72586163967109 / 34559831724 : ℚ)) + C ((24207608815931 / 34559831724 : ℚ)) * X + C ((9494324633128 / 8639957931 : ℚ)) * X ^ 2 + C ((15029180756419 / 34559831724 : ℚ)) * X ^ 3 + C ((-34913943500779 / 5759971954 : ℚ)) * X ^ 4 + C ((-66910986053015 / 8639957931 : ℚ)) * X ^ 5 + C ((-296220632997749 / 34559831724 : ℚ)) * X ^ 6 + C ((-216949632296891 / 34559831724 : ℚ)) * X ^ 7 + C ((-87135231081319 / 34559831724 : ℚ)) * X ^ 8
def CV_200_qim : Polynomial ℚ := C ((155151618294463 / 34559831724 : ℚ)) + C ((155151618294463 / 34559831724 : ℚ)) * X + C ((251726062406171 / 34559831724 : ℚ)) * X ^ 2 + C ((28912021909660 / 2879985977 : ℚ)) * X ^ 3 + C ((284070822970025 / 34559831724 : ℚ)) * X ^ 4 + C ((43395503049439 / 8639957931 : ℚ)) * X ^ 5 + C ((16095096235771 / 8639957931 : ℚ)) * X ^ 6 + C ((-77656406267839 / 17279915862 : ℚ)) * X ^ 7 + C ((-48686002923455 / 17279915862 : ℚ)) * X ^ 8
theorem CV_coeff_200_poly_re :
    CV_200_0_pre + CV_200_1_pre + CV_200_2_pre + CV_200_3_pre = (0 : Polynomial ℚ) + Phi11 * CV_200_qre := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [CV_200_0_pre, CV_200_1_pre, CV_200_2_pre, CV_200_3_pre, CV_200_qre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try grind
theorem CV_coeff_200_poly_im :
    CV_200_0_pim + CV_200_1_pim + CV_200_2_pim + CV_200_3_pim = (0 : Polynomial ℚ) + Phi11 * CV_200_qim := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [CV_200_0_pim, CV_200_1_pim, CV_200_2_pim, CV_200_3_pim, CV_200_qim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try grind
public theorem CV_coeff_200_eq :
    CV_coeff_200 = (0 : Ki) := by
  rw [CV_coeff_200_sum, CV_coeff_200_poly_re,
    CV_coeff_200_poly_im, ofLadj_add_Phi11]
  exact ofLadj_zero

end V14Formalization.D12SigmaPlusSegreCore
