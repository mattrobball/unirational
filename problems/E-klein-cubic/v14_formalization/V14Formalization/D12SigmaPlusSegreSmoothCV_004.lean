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

def CV_004_0_pre : Polynomial ℚ := C ((-41133733983596 / 2879985977 : ℚ)) + C ((-60783090395440 / 261816907 : ℚ)) * X + C ((-1334937660429680 / 2879985977 : ℚ)) * X ^ 2 + C ((-6502342120435826 / 8639957931 : ℚ)) * X ^ 3 + C ((-898177029735232 / 785450721 : ℚ)) * X ^ 4 + C ((-11943720097526374 / 8639957931 : ℚ)) * X ^ 5 + C ((-13826671102608190 / 8639957931 : ℚ)) * X ^ 6 + C ((-15080919901723538 / 8639957931 : ℚ)) * X ^ 7 + C ((-14827953457452556 / 8639957931 : ℚ)) * X ^ 8 + C ((-15027098726411248 / 8639957931 : ℚ)) * X ^ 9 + C ((-15178942185251458 / 8639957931 : ℚ)) * X ^ 10 + C ((-15112341004719292 / 8639957931 : ℚ)) * X ^ 11 + C ((-13173100202201938 / 8639957931 : ℚ)) * X ^ 12 + C ((-11022285745122208 / 8639957931 : ℚ)) * X ^ 13 + C ((-8325611337016730 / 8639957931 : ℚ)) * X ^ 14 + C ((-1588390700115166 / 2879985977 : ℚ)) * X ^ 15 + C ((-2592639641761168 / 8639957931 : ℚ)) * X ^ 16 + C ((-64517148789032 / 785450721 : ℚ)) * X ^ 17 + C ((145266824763496 / 2879985977 : ℚ)) * X ^ 18
def CV_004_0_pim : Polynomial ℚ := C ((478830968316876 / 2879985977 : ℚ)) + C ((957661936633752 / 2879985977 : ℚ)) * X + C ((1167354956308712 / 2879985977 : ℚ)) * X ^ 2 + C ((4374127870863298 / 8639957931 : ℚ)) * X ^ 3 + C ((1266482766981032 / 2879985977 : ℚ)) * X ^ 4 + C ((762135807430854 / 2879985977 : ℚ)) * X ^ 5 + C ((1114588240972928 / 8639957931 : ℚ)) * X ^ 6 + C ((-993651070944020 / 8639957931 : ℚ)) * X ^ 7 + C ((-2211799677855302 / 8639957931 : ℚ)) * X ^ 8 + C ((-2240291329564636 / 8639957931 : ℚ)) * X ^ 9 + C ((-2372038451553014 / 8639957931 : ℚ)) * X ^ 10 + C ((-4001464396726552 / 8639957931 : ℚ)) * X ^ 11 + C ((-1876963447300030 / 2879985977 : ℚ)) * X ^ 12 + C ((-581065138446668 / 785450721 : ℚ)) * X ^ 13 + C ((-7292271176559844 / 8639957931 : ℚ)) * X ^ 14 + C ((-2211397503950204 / 2879985977 : ℚ)) * X ^ 15 + C ((-55638572298566 / 97078179 : ℚ)) * X ^ 16 + C ((-108457748855908 / 261816907 : ℚ)) * X ^ 17 + C ((-39440839445464 / 261816907 : ℚ)) * X ^ 18
theorem CV_004_0_pre_eq :
    CV_0_re_002 * Fplus_dU_re_002 - CV_0_im_002 * Fplus_dU_im_002 = CV_004_0_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_0_re_002, CV_0_im_002, Fplus_dU_re_002, Fplus_dU_im_002, CV_004_0_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CV_004_0_pim_eq :
    CV_0_re_002 * Fplus_dU_im_002 + CV_0_im_002 * Fplus_dU_re_002 = CV_004_0_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_0_re_002, CV_0_im_002, Fplus_dU_re_002, Fplus_dU_im_002, CV_004_0_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CV_004_0_mul :
    CV_0_c_002 * Fplus_dU_c_002 = ofLadj CV_004_0_pre CV_004_0_pim := by
  rw [CV_0_c_002, Fplus_dU_c_002, ofLadj_mul, CV_004_0_pre_eq, CV_004_0_pim_eq]

def CV_004_1_pre : Polynomial ℚ := C ((102218411102 / 97078179 : ℚ)) + C ((-217241626093000 / 8639957931 : ℚ)) * X + C ((-464083499249648 / 8639957931 : ℚ)) * X ^ 2 + C ((-264208331480856 / 2879985977 : ℚ)) * X ^ 3 + C ((-1261984710951050 / 8639957931 : ℚ)) * X ^ 4 + C ((-544262196503210 / 2879985977 : ℚ)) * X ^ 5 + C ((-1922881863277006 / 8639957931 : ℚ)) * X ^ 6 + C ((-2008768681095482 / 8639957931 : ℚ)) * X ^ 7 + C ((-165044392298806 / 785450721 : ℚ)) * X ^ 8 + C ((-1679534397661064 / 8639957931 : ℚ)) * X ^ 9 + C ((-1575587907597896 / 8639957931 : ℚ)) * X ^ 10 + C ((-515352966908476 / 2879985977 : ℚ)) * X ^ 11 + C ((-1358346281504896 / 8639957931 : ℚ)) * X ^ 12 + C ((-4552250555848 / 32359393 : ℚ)) * X ^ 13 + C ((-1022863320844298 / 8639957931 : ℚ)) * X ^ 14 + C ((-678552208175984 / 8639957931 : ℚ)) * X ^ 15 + C ((-382013944702540 / 8639957931 : ℚ)) * X ^ 16 + C ((-30639556978388 / 2879985977 : ℚ)) * X ^ 17 + C ((68231761968448 / 8639957931 : ℚ)) * X ^ 18
def CV_004_1_pim : Polynomial ℚ := C ((77697862456944 / 2879985977 : ℚ)) + C ((155395724913888 / 2879985977 : ℚ)) * X + C ((578197342152560 / 8639957931 : ℚ)) * X ^ 2 + C ((733789240048240 / 8639957931 : ℚ)) * X ^ 3 + C ((718857776694028 / 8639957931 : ℚ)) * X ^ 4 + C ((507160560792470 / 8639957931 : ℚ)) * X ^ 5 + C ((214353342567256 / 8639957931 : ℚ)) * X ^ 6 + C ((-188182003182790 / 8639957931 : ℚ)) * X ^ 7 + C ((-410890188697918 / 8639957931 : ℚ)) * X ^ 8 + C ((-391297530144386 / 8639957931 : ℚ)) * X ^ 9 + C ((-301342642020454 / 8639957931 : ℚ)) * X ^ 10 + C ((-402554926087772 / 8639957931 : ℚ)) * X ^ 11 + C ((-167922403385030 / 2879985977 : ℚ)) * X ^ 12 + C ((-525822489442054 / 8639957931 : ℚ)) * X ^ 13 + C ((-661821728784202 / 8639957931 : ℚ)) * X ^ 14 + C ((-704054909323522 / 8639957931 : ℚ)) * X ^ 15 + C ((-607879722978178 / 8639957931 : ℚ)) * X ^ 16 + C ((-150852285938476 / 2879985977 : ℚ)) * X ^ 17 + C ((-55181180540532 / 2879985977 : ℚ)) * X ^ 18
theorem CV_004_1_pre_eq :
    CV_1_re_002 * Fplus_dV_re_002 - CV_1_im_002 * Fplus_dV_im_002 = CV_004_1_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_1_re_002, CV_1_im_002, Fplus_dV_re_002, Fplus_dV_im_002, CV_004_1_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CV_004_1_pim_eq :
    CV_1_re_002 * Fplus_dV_im_002 + CV_1_im_002 * Fplus_dV_re_002 = CV_004_1_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_1_re_002, CV_1_im_002, Fplus_dV_re_002, Fplus_dV_im_002, CV_004_1_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CV_004_1_mul :
    CV_1_c_002 * Fplus_dV_c_002 = ofLadj CV_004_1_pre CV_004_1_pim := by
  rw [CV_1_c_002, Fplus_dV_c_002, ofLadj_mul, CV_004_1_pre_eq, CV_004_1_pim_eq]

def CV_004_2_pre : Polynomial ℚ := C ((550714422972 / 261816907 : ℚ)) + C ((-1451423296274 / 261816907 : ℚ)) * X ^ 2 + C ((-3366312730604 / 261816907 : ℚ)) * X ^ 3 + C ((-5117386251190 / 261816907 : ℚ)) * X ^ 4 + C ((-6162721798474 / 261816907 : ℚ)) * X ^ 5 + C ((-6162721798474 / 261816907 : ℚ)) * X ^ 6 + C ((-5117386251190 / 261816907 : ℚ)) * X ^ 7 + C ((-3366312730604 / 261816907 : ℚ)) * X ^ 8 + C ((-1451423296274 / 261816907 : ℚ)) * X ^ 9
def CV_004_2_pim : Polynomial ℚ := C ((20350578973132 / 2879985977 : ℚ)) + C ((40701157946264 / 2879985977 : ℚ)) * X + C ((54631902567746 / 2879985977 : ℚ)) * X ^ 2 + C ((57598233619680 / 2879985977 : ℚ)) * X ^ 3 + C ((48853416654514 / 2879985977 : ℚ)) * X ^ 4 + C ((30921193630684 / 2879985977 : ℚ)) * X ^ 5 + C ((9779964315580 / 2879985977 : ℚ)) * X ^ 6 + C ((-8152258708250 / 2879985977 : ℚ)) * X ^ 7 + C ((-16897075673416 / 2879985977 : ℚ)) * X ^ 8 + C ((-13930744621482 / 2879985977 : ℚ)) * X ^ 9
theorem CV_004_2_pre_eq :
    CV_2_re_002 * Fplus_dW_re_002 - CV_2_im_002 * Fplus_dW_im_002 = CV_004_2_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_2_re_002, CV_2_im_002, Fplus_dW_re_002, Fplus_dW_im_002, CV_004_2_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CV_004_2_pim_eq :
    CV_2_re_002 * Fplus_dW_im_002 + CV_2_im_002 * Fplus_dW_re_002 = CV_004_2_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_2_re_002, CV_2_im_002, Fplus_dW_re_002, Fplus_dW_im_002, CV_004_2_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CV_004_2_mul :
    CV_2_c_002 * Fplus_dW_c_002 = ofLadj CV_004_2_pre CV_004_2_pim := by
  rw [CV_2_c_002, Fplus_dW_c_002, ofLadj_mul, CV_004_2_pre_eq, CV_004_2_pim_eq]

@[expose] public def CV_coeff_004 : Ki := CV_0_c_002 * Fplus_dU_c_002 + CV_1_c_002 * Fplus_dV_c_002 + CV_2_c_002 * Fplus_dW_c_002

theorem CV_coeff_004_sum :
    CV_coeff_004 = ofLadj (CV_004_0_pre + CV_004_1_pre + CV_004_2_pre) (CV_004_0_pim + CV_004_1_pim + CV_004_2_pim) := by
  simp only [CV_coeff_004, CV_004_0_mul, CV_004_1_mul, CV_004_2_mul]
  simpa [add_assoc] using ofLadj_add3 CV_004_0_pre CV_004_0_pim CV_004_1_pre CV_004_1_pim CV_004_2_pre CV_004_2_pim

def CV_004_qre : Polynomial ℚ := C ((-96130187404634 / 8639957931 : ℚ)) + C ((-2126953421737886 / 8639957931 : ℚ)) * X + C ((-2293709840173210 / 8639957931 : ℚ)) * X ^ 2 + C ((-963087328557532 / 2879985977 : ℚ)) * X ^ 3 + C ((-3904750349339546 / 8639957931 : ℚ)) * X ^ 4 + C ((-823023574019258 / 2879985977 : ℚ)) * X ^ 5 + C ((-2173046278849192 / 8639957931 : ℚ)) * X ^ 6 + C ((-1305639543873452 / 8639957931 : ℚ)) * X ^ 7 + C ((45821112387176 / 785450721 : ℚ)) * X ^ 8
def CV_004_qim : Polynomial ℚ := C ((576879409746952 / 2879985977 : ℚ)) + C ((576879409746952 / 2879985977 : ℚ)) * X + C ((782881460300222 / 8639957931 : ℚ)) * X ^ 2 + C ((345517964329548 / 2879985977 : ℚ)) * X ^ 3 + C ((-615845484169912 / 8639957931 : ℚ)) * X ^ 4 + C ((-1778534763623582 / 8639957931 : ℚ)) * X ^ 5 + C ((-1528050087490160 / 8639957931 : ℚ)) * X ^ 6 + C ((-854857108912828 / 2879985977 : ℚ)) * X ^ 7 + C ((-489030414440636 / 2879985977 : ℚ)) * X ^ 8
theorem CV_coeff_004_poly_re :
    CV_004_0_pre + CV_004_1_pre + CV_004_2_pre = (0 : Polynomial ℚ) + Phi11 * CV_004_qre := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [CV_004_0_pre, CV_004_1_pre, CV_004_2_pre, CV_004_qre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try ring
theorem CV_coeff_004_poly_im :
    CV_004_0_pim + CV_004_1_pim + CV_004_2_pim = (0 : Polynomial ℚ) + Phi11 * CV_004_qim := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [CV_004_0_pim, CV_004_1_pim, CV_004_2_pim, CV_004_qim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try ring
public theorem CV_coeff_004_eq :
    CV_coeff_004 = (0 : Ki) := by
  rw [CV_coeff_004_sum, CV_coeff_004_poly_re,
    CV_coeff_004_poly_im, ofLadj_add_Phi11]
  exact ofLadj_zero

end V14Formalization.D12SigmaPlusSegreCore
