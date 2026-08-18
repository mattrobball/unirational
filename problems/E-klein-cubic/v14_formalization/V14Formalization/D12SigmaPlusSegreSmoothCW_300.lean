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

def CW_300_0_pre : Polynomial ℚ := C ((805777420935 / 2879985977 : ℚ)) + C ((-1174712641913 / 5759971954 : ℚ)) * X ^ 2 + C ((-7517368641311 / 11519943908 : ℚ)) * X ^ 3 + C ((-23516245664751 / 11519943908 : ℚ)) * X ^ 4 + C ((-39482755693747 / 11519943908 : ℚ)) * X ^ 5 + C ((-14055835586159 / 2879985977 : ℚ)) * X ^ 6 + C ((-34801512479645 / 5759971954 : ℚ)) * X ^ 7 + C ((-74638791416381 / 11519943908 : ℚ)) * X ^ 8 + C ((-76791044190235 / 11519943908 : ℚ)) * X ^ 9 + C ((-78450797441437 / 11519943908 : ℚ)) * X ^ 10 + C ((-41106414477695 / 5759971954 : ℚ)) * X ^ 11 + C ((-78450797441437 / 11519943908 : ℚ)) * X ^ 12 + C ((-74441618906409 / 11519943908 : ℚ)) * X ^ 13 + C ((-33560711387535 / 5759971954 : ℚ)) * X ^ 14 + C ((-405463150559 / 95206148 : ℚ)) * X ^ 15 + C ((-31899024130661 / 11519943908 : ℚ)) * X ^ 16 + C ((-3789609369943 / 2879985977 : ℚ)) * X ^ 17 + C ((-743565480775 / 2879985977 : ℚ)) * X ^ 18
def CW_300_0_pim : Polynomial ℚ := C ((5213138089221 / 5759971954 : ℚ)) + C ((5213138089221 / 2879985977 : ℚ)) * X + C ((8438357102558 / 2879985977 : ℚ)) * X ^ 2 + C ((51635812326511 / 11519943908 : ℚ)) * X ^ 3 + C ((62351253466629 / 11519943908 : ℚ)) * X ^ 4 + C ((67758609919823 / 11519943908 : ℚ)) * X ^ 5 + C ((34530810661231 / 5759971954 : ℚ)) * X ^ 6 + C ((29506710039051 / 5759971954 : ℚ)) * X ^ 7 + C ((52509236009727 / 11519943908 : ℚ)) * X ^ 8 + C ((52194345706143 / 11519943908 : ℚ)) * X ^ 9 + C ((50742730271597 / 11519943908 : ℚ)) * X ^ 10 + C ((1737712696407 / 523633814 : ℚ)) * X ^ 11 + C ((25716628370311 / 11519943908 : ℚ)) * X ^ 12 + C ((1033103352947 / 1047267628 : ℚ)) * X ^ 13 + C ((-3416568668723 / 5759971954 : ℚ)) * X ^ 14 + C ((-16711968949139 / 11519943908 : ℚ)) * X ^ 15 + C ((-20208320334927 / 11519943908 : ℚ)) * X ^ 16 + C ((-9649999954283 / 5759971954 : ℚ)) * X ^ 17 + C ((-1835198399200 / 2879985977 : ℚ)) * X ^ 18
theorem CW_300_0_pre_eq :
    CW_0_re_100 * Fplus_dU_re_200 - CW_0_im_100 * Fplus_dU_im_200 = CW_300_0_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_0_re_100_def, CW_0_im_100_def, Fplus_dU_re_200_def, Fplus_dU_im_200_def, CW_300_0_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CW_300_0_pim_eq :
    CW_0_re_100 * Fplus_dU_im_200 + CW_0_im_100 * Fplus_dU_re_200 = CW_300_0_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_0_re_100_def, CW_0_im_100_def, Fplus_dU_re_200_def, Fplus_dU_im_200_def, CW_300_0_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CW_300_0_mul :
    CW_0_c_100 * Fplus_dU_c_200 = ofLadj CW_300_0_pre CW_300_0_pim := by
  rw [CW_0_c_100_def, Fplus_dU_c_200_def, ofLadj_mul, CW_300_0_pre_eq, CW_300_0_pim_eq]

def CW_300_1_pre : Polynomial ℚ := C ((214691498165 / 17279915862 : ℚ)) + C ((-4310848087496 / 8639957931 : ℚ)) * X + C ((-34119347130409 / 34559831724 : ℚ)) * X ^ 2 + C ((-4639106804653 / 2879985977 : ℚ)) * X ^ 3 + C ((-8594020123717 / 3141802884 : ℚ)) * X ^ 4 + C ((-60335247337261 / 17279915862 : ℚ)) * X ^ 5 + C ((-145891472416093 / 34559831724 : ℚ)) * X ^ 6 + C ((-52191852711203 / 11519943908 : ℚ)) * X ^ 7 + C ((-48528778533255 / 11519943908 : ℚ)) * X ^ 8 + C ((-69004676779309 / 17279915862 : ℚ)) * X ^ 9 + C ((-21996438279527 / 5759971954 : ℚ)) * X ^ 10 + C ((-21746444680475 / 5759971954 : ℚ)) * X ^ 11 + C ((-57367618663589 / 17279915862 : ℚ)) * X ^ 12 + C ((-103890006428209 / 34559831724 : ℚ)) * X ^ 13 + C ((-29972351314643 / 11519943908 : ℚ)) * X ^ 14 + C ((-58368252526825 / 34559831724 : ℚ)) * X ^ 15 + C ((-36488858194817 / 34559831724 : ℚ)) * X ^ 16 + C ((-1877980075541 / 5759971954 : ℚ)) * X ^ 17 + C ((111305583209 / 1047267628 : ℚ)) * X ^ 18
def CW_300_1_pim : Polynomial ℚ := C ((4110580011118 / 8639957931 : ℚ)) + C ((8221160022236 / 8639957931 : ℚ)) * X + C ((42080423124961 / 34559831724 : ℚ)) * X ^ 2 + C ((2646194233951 / 1570901442 : ℚ)) * X ^ 3 + C ((58317395412083 / 34559831724 : ℚ)) * X ^ 4 + C ((651379536745 / 523633814 : ℚ)) * X ^ 5 + C ((26156668827821 / 34559831724 : ℚ)) * X ^ 6 + C ((-6910070591627 / 34559831724 : ℚ)) * X ^ 7 + C ((-24278025172703 / 34559831724 : ℚ)) * X ^ 8 + C ((-527745964961 / 785450721 : ℚ)) * X ^ 9 + C ((-4500394761113 / 8639957931 : ℚ)) * X ^ 10 + C ((-6754599791957 / 8639957931 : ℚ)) * X ^ 11 + C ((-9008804822801 / 8639957931 : ℚ)) * X ^ 12 + C ((-40011758913389 / 34559831724 : ℚ)) * X ^ 13 + C ((-55090406220931 / 34559831724 : ℚ)) * X ^ 14 + C ((-58186435114547 / 34559831724 : ℚ)) * X ^ 15 + C ((-49706733687521 / 34559831724 : ℚ)) * X ^ 16 + C ((-20296571406091 / 17279915862 : ℚ)) * X ^ 17 + C ((-4791015984207 / 11519943908 : ℚ)) * X ^ 18
theorem CW_300_1_pre_eq :
    CW_1_re_100 * Fplus_dV_re_200 - CW_1_im_100 * Fplus_dV_im_200 = CW_300_1_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_1_re_100_def, CW_1_im_100_def, Fplus_dV_re_200_def, Fplus_dV_im_200_def, CW_300_1_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CW_300_1_pim_eq :
    CW_1_re_100 * Fplus_dV_im_200 + CW_1_im_100 * Fplus_dV_re_200 = CW_300_1_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_1_re_100_def, CW_1_im_100_def, Fplus_dV_re_200_def, Fplus_dV_im_200_def, CW_300_1_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CW_300_1_mul :
    CW_1_c_100 * Fplus_dV_c_200 = ofLadj CW_300_1_pre CW_300_1_pim := by
  rw [CW_1_c_100_def, Fplus_dV_c_200_def, ofLadj_mul, CW_300_1_pre_eq, CW_300_1_pim_eq]

def CW_300_2_pre : Polynomial ℚ := C ((365555435389 / 8639957931 : ℚ)) + C ((362157930344 / 785450721 : ℚ)) * X + C ((2440724880915 / 2879985977 : ℚ)) * X ^ 2 + C ((46239254313865 / 34559831724 : ℚ)) * X ^ 3 + C ((5556659820856 / 2879985977 : ℚ)) * X ^ 4 + C ((74574473525429 / 34559831724 : ℚ)) * X ^ 5 + C ((27856190112071 / 11519943908 : ℚ)) * X ^ 6 + C ((42980220609473 / 17279915862 : ℚ)) * X ^ 7 + C ((19924623372631 / 8639957931 : ℚ)) * X ^ 8 + C ((26192756590313 / 11519943908 : ℚ)) * X ^ 9 + C ((640717402009 / 285618444 : ℚ)) * X ^ 10 + C ((37876002400765 / 17279915862 : ℚ)) * X ^ 11 + C ((1866419900241 / 1047267628 : ℚ)) * X ^ 12 + C ((16429857066653 / 11519943908 : ℚ)) * X ^ 13 + C ((11153079725553 / 11519943908 : ℚ)) * X ^ 14 + C ((7075100163113 / 17279915862 : ℚ)) * X ^ 15 + C ((1154333743125 / 5759971954 : ℚ)) * X ^ 16 + C ((-1034047176017 / 17279915862 : ℚ)) * X ^ 17 + C ((-427526920204 / 2879985977 : ℚ)) * X ^ 18
def CW_300_2_pim : Polynomial ℚ := C ((-1914154044707 / 8639957931 : ℚ)) + C ((-3828308089414 / 8639957931 : ℚ)) * X + C ((-3401994634718 / 8639957931 : ℚ)) * X ^ 2 + C ((-5150703929175 / 11519943908 : ℚ)) * X ^ 3 + C ((-705057789209 / 5759971954 : ℚ)) * X ^ 4 + C ((3272585636035 / 11519943908 : ℚ)) * X ^ 5 + C ((20652584851735 / 34559831724 : ℚ)) * X ^ 6 + C ((6005444843065 / 5759971954 : ℚ)) * X ^ 7 + C ((7246900946655 / 5759971954 : ℚ)) * X ^ 8 + C ((43368873876263 / 34559831724 : ℚ)) * X ^ 9 + C ((14168158922023 / 11519943908 : ℚ)) * X ^ 10 + C ((12248979335101 / 8639957931 : ℚ)) * X ^ 11 + C ((55487357914739 / 34559831724 : ℚ)) * X ^ 12 + C ((52917706985761 / 34559831724 : ℚ)) * X ^ 13 + C ((54649308430747 / 34559831724 : ℚ)) * X ^ 14 + C ((10978155355414 / 8639957931 : ℚ)) * X ^ 15 + C ((5163024522661 / 5759971954 : ℚ)) * X ^ 16 + C ((3538352237891 / 5759971954 : ℚ)) * X ^ 17 + C ((52754989230 / 261816907 : ℚ)) * X ^ 18
theorem CW_300_2_pre_eq :
    CW_2_re_100 * Fplus_dW_re_200 - CW_2_im_100 * Fplus_dW_im_200 = CW_300_2_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_2_re_100_def, CW_2_im_100_def, Fplus_dW_re_200_def, Fplus_dW_im_200_def, CW_300_2_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CW_300_2_pim_eq :
    CW_2_re_100 * Fplus_dW_im_200 + CW_2_im_100 * Fplus_dW_re_200 = CW_300_2_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_2_re_100_def, CW_2_im_100_def, Fplus_dW_re_200_def, Fplus_dW_im_200_def, CW_300_2_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CW_300_2_mul :
    CW_2_c_100 * Fplus_dW_c_200 = ofLadj CW_300_2_pre CW_300_2_pim := by
  rw [CW_2_c_100_def, Fplus_dW_c_200_def, ofLadj_mul, CW_300_2_pre_eq, CW_300_2_pim_eq]

@[expose] public def CW_coeff_300 : Ki := CW_0_c_100 * Fplus_dU_c_200 + CW_1_c_100 * Fplus_dV_c_200 + CW_2_c_100 * Fplus_dW_c_200

theorem CW_coeff_300_sum :
    CW_coeff_300 = ofLadj (CW_300_0_pre + CW_300_1_pre + CW_300_2_pre) (CW_300_0_pim + CW_300_1_pim + CW_300_2_pim) := by
  simp only [CW_coeff_300, CW_300_0_mul, CW_300_1_mul, CW_300_2_mul]
  simpa [add_assoc] using ofLadj_add3 CW_300_0_pre CW_300_0_pim CW_300_1_pre CW_300_1_pim CW_300_2_pre CW_300_2_pim

def CW_300_qre : Polynomial ℚ := C ((5780466894553 / 17279915862 : ℚ)) + C ((-2144896200659 / 5759971954 : ℚ)) * X + C ((-3523493665353 / 11519943908 : ℚ)) * X ^ 2 + C ((-20103208854997 / 34559831724 : ℚ)) * X ^ 3 + C ((-5535075603247 / 2879985977 : ℚ)) * X ^ 4 + C ((-33070623862733 / 17279915862 : ℚ)) * X ^ 5 + C ((-33224320441727 / 17279915862 : ℚ)) * X ^ 6 + C ((-48431262678745 / 34559831724 : ℚ)) * X ^ 7 + C ((-3460008188617 / 11519943908 : ℚ)) * X ^ 8
def CW_300_qim : Polynomial ℚ := C ((1821115109135 / 1570901442 : ℚ)) + C ((1821115109135 / 1570901442 : ℚ)) * X + C ((49603665014845 / 34559831724 : ℚ)) * X ^ 2 + C ((67938868522145 / 34559831724 : ℚ)) * X ^ 3 + C ((21734605368893 / 17279915862 : ℚ)) * X ^ 4 + C ((3735956754007 / 8639957931 : ℚ)) * X ^ 5 + C ((-348419740967 / 5759971954 : ℚ)) * X ^ 6 + C ((-47831258945873 / 34559831724 : ℚ)) * X ^ 7 + C ((-9810590054887 / 11519943908 : ℚ)) * X ^ 8
theorem CW_coeff_300_poly_re :
    CW_300_0_pre + CW_300_1_pre + CW_300_2_pre = (0 : Polynomial ℚ) + Phi11 * CW_300_qre := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [CW_300_0_pre, CW_300_1_pre, CW_300_2_pre, CW_300_qre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try grind
theorem CW_coeff_300_poly_im :
    CW_300_0_pim + CW_300_1_pim + CW_300_2_pim = (0 : Polynomial ℚ) + Phi11 * CW_300_qim := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [CW_300_0_pim, CW_300_1_pim, CW_300_2_pim, CW_300_qim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try grind
public theorem CW_coeff_300_eq :
    CW_coeff_300 = (0 : Ki) := by
  rw [CW_coeff_300_sum, CW_coeff_300_poly_re,
    CW_coeff_300_poly_im, ofLadj_add_Phi11]
  exact ofLadj_zero

end V14Formalization.D12SigmaPlusSegreCore
