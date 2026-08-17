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

def CU_031_0_pre : Polynomial ℚ := C ((84012233456 / 235794999 : ℚ)) + C ((112959468766160 / 78598333 : ℚ)) * X + C ((641623257611156 / 235794999 : ℚ)) * X ^ 2 + C ((1104186467931856 / 235794999 : ℚ)) * X ^ 3 + C ((600830739092684 / 78598333 : ℚ)) * X ^ 4 + C ((775401589950480 / 78598333 : ℚ)) * X ^ 5 + C ((944980959096452 / 78598333 : ℚ)) * X ^ 6 + C ((3246142256602856 / 235794999 : ℚ)) * X ^ 7 + C ((1100226159935048 / 78598333 : ℚ)) * X ^ 8 + C ((3415803718867708 / 235794999 : ℚ)) * X ^ 9 + C ((3503727987968192 / 235794999 : ℚ)) * X ^ 10 + C ((3536601280067404 / 235794999 : ℚ)) * X ^ 11 + C ((3164849581669712 / 235794999 : ℚ)) * X ^ 12 + C ((2774180461256552 / 235794999 : ℚ)) * X ^ 13 + C ((2196492011873288 / 235794999 : ℚ)) * X ^ 14 + C ((1392425124189340 / 235794999 : ℚ)) * X ^ 15 + C ((805660953941612 / 235794999 : ℚ)) * X ^ 16 + C ((296922846503696 / 235794999 : ℚ)) * X ^ 17 + C ((-51224915135464 / 235794999 : ℚ)) * X ^ 18
def CU_031_0_pim : Polynomial ℚ := C ((-312939465748168 / 235794999 : ℚ)) + C ((-625878931496336 / 235794999 : ℚ)) * X + C ((-845203209781772 / 235794999 : ℚ)) * X ^ 2 + C ((-395712064058216 / 78598333 : ℚ)) * X ^ 3 + C ((-414296395066364 / 78598333 : ℚ)) * X ^ 4 + C ((-1104615275872580 / 235794999 : ℚ)) * X ^ 5 + C ((-968891813423432 / 235794999 : ℚ)) * X ^ 6 + C ((-577675069138312 / 235794999 : ℚ)) * X ^ 7 + C ((-98942156397024 / 78598333 : ℚ)) * X ^ 8 + C ((-25478394365224 / 21435909 : ℚ)) * X ^ 9 + C ((-204203048166188 / 235794999 : ℚ)) * X ^ 10 + C ((220471288824964 / 235794999 : ℚ)) * X ^ 11 + C ((645145625816116 / 235794999 : ℚ)) * X ^ 12 + C ((940529193952828 / 235794999 : ℚ)) * X ^ 13 + C ((433008769173104 / 78598333 : ℚ)) * X ^ 14 + C ((1306488288621716 / 235794999 : ℚ)) * X ^ 15 + C ((1070428407745492 / 235794999 : ℚ)) * X ^ 16 + C ((272714109234704 / 78598333 : ℚ)) * X ^ 17 + C ((329139611869280 / 235794999 : ℚ)) * X ^ 18
theorem CU_031_0_pre_eq :
    CU_0_re_011 * Fplus_dU_re_020 - CU_0_im_011 * Fplus_dU_im_020 = CU_031_0_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_0_re_011, CU_0_im_011, Fplus_dU_re_020, Fplus_dU_im_020, CU_031_0_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CU_031_0_pim_eq :
    CU_0_re_011 * Fplus_dU_im_020 + CU_0_im_011 * Fplus_dU_re_020 = CU_031_0_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_0_re_011, CU_0_im_011, Fplus_dU_re_020, Fplus_dU_im_020, CU_031_0_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CU_031_0_mul :
    CU_0_c_011 * Fplus_dU_c_020 = ofLadj CU_031_0_pre CU_031_0_pim := by
  rw [CU_0_c_011, Fplus_dU_c_020, ofLadj_mul, CU_031_0_pre_eq, CU_031_0_pim_eq]

def CU_031_1_pre : Polynomial ℚ := C ((-12503873177236 / 78598333 : ℚ)) + C ((-121142661053008 / 78598333 : ℚ)) * X + C ((-210927356339468 / 78598333 : ℚ)) * X ^ 2 + C ((-340615100137080 / 78598333 : ℚ)) * X ^ 3 + C ((-514632883746488 / 78598333 : ℚ)) * X ^ 4 + C ((-585133767302488 / 78598333 : ℚ)) * X ^ 5 + C ((-671095306175672 / 78598333 : ℚ)) * X ^ 6 + C ((-770242595355732 / 78598333 : ℚ)) * X ^ 7 + C ((-788689478426660 / 78598333 : ℚ)) * X ^ 8 + C ((-850257607866868 / 78598333 : ℚ)) * X ^ 9 + C ((-81571601085804 / 7145303 : ℚ)) * X ^ 10 + C ((-902324926101872 / 78598333 : ℚ)) * X ^ 11 + C ((-776144950890836 / 78598333 : ℚ)) * X ^ 12 + C ((-639330251527400 / 78598333 : ℚ)) * X ^ 13 + C ((-448074378289580 / 78598333 : ℚ)) * X ^ 14 + C ((-217466459523448 / 78598333 : ℚ)) * X ^ 15 + C ((-113311523164636 / 78598333 : ℚ)) * X ^ 16 + C ((-27349984291452 / 78598333 : ℚ)) * X ^ 17 + C ((3467568371436 / 7145303 : ℚ)) * X ^ 18
def CU_031_1_pim : Polynomial ℚ := C ((69462226569512 / 78598333 : ℚ)) + C ((138924453139024 / 78598333 : ℚ)) * X + C ((160012620896504 / 78598333 : ℚ)) * X ^ 2 + C ((207561338708732 / 78598333 : ℚ)) * X ^ 3 + C ((156097862203856 / 78598333 : ℚ)) * X ^ 4 + C ((70335541754784 / 78598333 : ℚ)) * X ^ 5 + C ((47369789010200 / 78598333 : ℚ)) * X ^ 6 + C ((-39819491283240 / 78598333 : ℚ)) * X ^ 7 + C ((-106240995385456 / 78598333 : ℚ)) * X ^ 8 + C ((-115088080584964 / 78598333 : ℚ)) * X ^ 9 + C ((-155817382025648 / 78598333 : ℚ)) * X ^ 10 + C ((-284987770574440 / 78598333 : ℚ)) * X ^ 11 + C ((-414158159123232 / 78598333 : ℚ)) * X ^ 12 + C ((-475975628321396 / 78598333 : ℚ)) * X ^ 13 + C ((-532371431333132 / 78598333 : ℚ)) * X ^ 14 + C ((-455078600562420 / 78598333 : ℚ)) * X ^ 15 + C ((-316978024867932 / 78598333 : ℚ)) * X ^ 16 + C ((-231778393906908 / 78598333 : ℚ)) * X ^ 17 + C ((-92250858368052 / 78598333 : ℚ)) * X ^ 18
theorem CU_031_1_pre_eq :
    CU_1_re_011 * Fplus_dV_re_020 - CU_1_im_011 * Fplus_dV_im_020 = CU_031_1_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_1_re_011, CU_1_im_011, Fplus_dV_re_020, Fplus_dV_im_020, CU_031_1_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CU_031_1_pim_eq :
    CU_1_re_011 * Fplus_dV_im_020 + CU_1_im_011 * Fplus_dV_re_020 = CU_031_1_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_1_re_011, CU_1_im_011, Fplus_dV_re_020, Fplus_dV_im_020, CU_031_1_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CU_031_1_mul :
    CU_1_c_011 * Fplus_dV_c_020 = ofLadj CU_031_1_pre CU_031_1_pim := by
  rw [CU_1_c_011, Fplus_dV_c_020, ofLadj_mul, CU_031_1_pre_eq, CU_031_1_pim_eq]

def CU_031_2_pre : Polynomial ℚ := C ((-66497033689136 / 235794999 : ℚ)) + C ((-924876597203552 / 235794999 : ℚ)) * X + C ((-1835310994754668 / 235794999 : ℚ)) * X ^ 2 + C ((-3006419826727340 / 235794999 : ℚ)) * X ^ 3 + C ((-4483879340523424 / 235794999 : ℚ)) * X ^ 4 + C ((-5341429850778700 / 235794999 : ℚ)) * X ^ 5 + C ((-6040776195659476 / 235794999 : ℚ)) * X ^ 6 + C ((-2154070765876324 / 78598333 : ℚ)) * X ^ 7 + C ((-2052814574382364 / 78598333 : ℚ)) * X ^ 8 + C ((-6088864573889032 / 235794999 : ℚ)) * X ^ 9 + C ((-6035698830758588 / 235794999 : ℚ)) * X ^ 10 + C ((-540866867217848 / 21435909 : ℚ)) * X ^ 11 + C ((-1703607411185012 / 78598333 : ℚ)) * X ^ 12 + C ((-1417851193044788 / 78598333 : ℚ)) * X ^ 13 + C ((-3152023896419752 / 235794999 : ℚ)) * X ^ 14 + C ((-579524549918696 / 78598333 : ℚ)) * X ^ 15 + C ((-918933680234908 / 235794999 : ℚ)) * X ^ 16 + C ((-219587335354132 / 235794999 : ℚ)) * X ^ 17 + C ((239759307349460 / 235794999 : ℚ)) * X ^ 18
def CU_031_2_pim : Polynomial ℚ := C ((57214452110720 / 21435909 : ℚ)) + C ((114428904221440 / 21435909 : ℚ)) * X + C ((492122309744924 / 78598333 : ℚ)) * X ^ 2 + C ((590709369565732 / 78598333 : ℚ)) * X ^ 3 + C ((1360785579833888 / 235794999 : ℚ)) * X ^ 4 + C ((524756150498480 / 235794999 : ℚ)) * X ^ 5 + C ((-155309931583432 / 235794999 : ℚ)) * X ^ 6 + C ((-1172533041529340 / 235794999 : ℚ)) * X ^ 7 + C ((-1768320141167036 / 235794999 : ℚ)) * X ^ 8 + C ((-586114338914040 / 78598333 : ℚ)) * X ^ 9 + C ((-570738134090448 / 78598333 : ℚ)) * X ^ 10 + C ((-758061253598136 / 78598333 : ℚ)) * X ^ 11 + C ((-945384373105824 / 78598333 : ℚ)) * X ^ 12 + C ((-3007673487645628 / 235794999 : ℚ)) * X ^ 13 + C ((-3293457542683136 / 235794999 : ℚ)) * X ^ 14 + C ((-970437354898432 / 78598333 : ℚ)) * X ^ 15 + C ((-711503809848808 / 78598333 : ℚ)) * X ^ 16 + C ((-1524584364521600 / 235794999 : ℚ)) * X ^ 17 + C ((-566590048762228 / 235794999 : ℚ)) * X ^ 18
theorem CU_031_2_pre_eq :
    CU_2_re_011 * Fplus_dW_re_020 - CU_2_im_011 * Fplus_dW_im_020 = CU_031_2_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_2_re_011, CU_2_im_011, Fplus_dW_re_020, Fplus_dW_im_020, CU_031_2_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CU_031_2_pim_eq :
    CU_2_re_011 * Fplus_dW_im_020 + CU_2_im_011 * Fplus_dW_re_020 = CU_031_2_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_2_re_011, CU_2_im_011, Fplus_dW_re_020, Fplus_dW_im_020, CU_031_2_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CU_031_2_mul :
    CU_2_c_011 * Fplus_dW_c_020 = ofLadj CU_031_2_pre CU_031_2_pim := by
  rw [CU_2_c_011, Fplus_dW_c_020, ofLadj_mul, CU_031_2_pre_eq, CU_031_2_pim_eq]

@[expose] public def CU_coeff_031 : Ki := CU_0_c_011 * Fplus_dU_c_020 + CU_1_c_011 * Fplus_dV_c_020 + CU_2_c_011 * Fplus_dW_c_020

theorem CU_coeff_031_sum :
    CU_coeff_031 = ofLadj (CU_031_0_pre + CU_031_1_pre + CU_031_2_pre) (CU_031_0_pim + CU_031_1_pim + CU_031_2_pim) := by
  simp only [CU_coeff_031, CU_031_0_mul, CU_031_1_mul, CU_031_2_mul]
  simpa [add_assoc] using ofLadj_add3 CU_031_0_pre CU_031_0_pim CU_031_1_pre CU_031_1_pim CU_031_2_pre CU_031_2_pim

def CU_031_qre : Polynomial ℚ := C ((-34641546995796 / 78598333 : ℚ)) + C ((-845501533076708 / 235794999 : ℚ)) * X + C ((-26577079760540 / 7145303 : ℚ)) * X ^ 2 + C ((-1097608853044808 / 235794999 : ℚ)) * X ^ 3 + C ((-433735705092704 / 78598333 : ℚ)) * X ^ 4 + C ((-181780202783296 / 78598333 : ℚ)) * X ^ 5 + C ((-149497618020804 / 78598333 : ℚ)) * X ^ 6 + C ((-102559530065392 / 78598333 : ℚ)) * X ^ 7 + C ((302964148471384 / 235794999 : ℚ)) * X ^ 8
def CU_031_qim : Polynomial ℚ := C ((174935395726096 / 78598333 : ℚ)) + C ((174935395726096 / 78598333 : ℚ)) * X + C ((61589207785936 / 235794999 : ℚ)) * X ^ 2 + C ((96474350506232 / 235794999 : ℚ)) * X ^ 3 + C ((-621485951402380 / 235794999 : ℚ)) * X ^ 4 + C ((-955042481356112 / 235794999 : ℚ)) * X ^ 5 + C ((-204413292622172 / 78598333 : ℚ)) * X ^ 6 + C ((-295858068847036 / 78598333 : ℚ)) * X ^ 7 + C ((-514203011997104 / 235794999 : ℚ)) * X ^ 8
theorem CU_coeff_031_poly_re :
    CU_031_0_pre + CU_031_1_pre + CU_031_2_pre = (0 : Polynomial ℚ) + Phi11 * CU_031_qre := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [CU_031_0_pre, CU_031_1_pre, CU_031_2_pre, CU_031_qre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try ring
theorem CU_coeff_031_poly_im :
    CU_031_0_pim + CU_031_1_pim + CU_031_2_pim = (0 : Polynomial ℚ) + Phi11 * CU_031_qim := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [CU_031_0_pim, CU_031_1_pim, CU_031_2_pim, CU_031_qim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try ring
public theorem CU_coeff_031_eq :
    CU_coeff_031 = (0 : Ki) := by
  rw [CU_coeff_031_sum, CU_coeff_031_poly_re,
    CU_coeff_031_poly_im, ofLadj_add_Phi11]
  exact ofLadj_zero

end V14Formalization.D12SigmaPlusSegreCore
