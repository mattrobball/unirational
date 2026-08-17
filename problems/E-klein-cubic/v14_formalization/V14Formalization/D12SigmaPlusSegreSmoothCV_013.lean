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

def CV_013_0_pre : Polynomial ℚ := C ((-70764359462648 / 2879985977 : ℚ)) + C ((-86832986279200 / 261816907 : ℚ)) * X + C ((-1943387013907864 / 2879985977 : ℚ)) * X ^ 2 + C ((-9580756229916692 / 8639957931 : ℚ)) * X ^ 3 + C ((-14263235347959992 / 8639957931 : ℚ)) * X ^ 4 + C ((-1540960494270664 / 785450721 : ℚ)) * X ^ 5 + C ((-6371189083348128 / 2879985977 : ℚ)) * X ^ 6 + C ((-20302147449976504 / 8639957931 : ℚ)) * X ^ 7 + C ((-586132444255788 / 261816907 : ℚ)) * X ^ 8 + C ((-18976868373725320 / 8639957931 : ℚ)) * X ^ 9 + C ((-18697603748116124 / 8639957931 : ℚ)) * X ^ 10 + C ((-6127130310287040 / 2879985977 : ℚ)) * X ^ 11 + C ((-15832115200902524 / 8639957931 : ℚ)) * X ^ 12 + C ((-13146707332001728 / 8639957931 : ℚ)) * X ^ 13 + C ((-9761614430524312 / 8639957931 : ℚ)) * X ^ 14 + C ((-492288926279200 / 785450721 : ℚ)) * X ^ 15 + C ((-975824909380012 / 2879985977 : ℚ)) * X ^ 16 + C ((-764472915072956 / 8639957931 : ℚ)) * X ^ 17 + C ((207911304315104 / 2879985977 : ℚ)) * X ^ 18
def CV_013_0_pim : Polynomial ℚ := C ((643108689778200 / 2879985977 : ℚ)) + C ((1286217379556400 / 2879985977 : ℚ)) * X + C ((1526095152896344 / 2879985977 : ℚ)) * X ^ 2 + C ((5391755712136108 / 8639957931 : ℚ)) * X ^ 3 + C ((1352223413572848 / 2879985977 : ℚ)) * X ^ 4 + C ((471095776133064 / 2879985977 : ℚ)) * X ^ 5 + C ((-705493208677904 / 8639957931 : ℚ)) * X ^ 6 + C ((-1272144895010432 / 2879985977 : ℚ)) * X ^ 7 + C ((-1867531122454032 / 2879985977 : ℚ)) * X ^ 8 + C ((-5549953001633012 / 8639957931 : ℚ)) * X ^ 9 + C ((-5308120068197512 / 8639957931 : ℚ)) * X ^ 10 + C ((-6883040903832040 / 8639957931 : ℚ)) * X ^ 11 + C ((-8457961739466568 / 8639957931 : ℚ)) * X ^ 12 + C ((-2978587375350300 / 2879985977 : ℚ)) * X ^ 13 + C ((-3232197337922964 / 2879985977 : ℚ)) * X ^ 14 + C ((-8515058410498976 / 8639957931 : ℚ)) * X ^ 15 + C ((-2060758806599116 / 2879985977 : ℚ)) * X ^ 16 + C ((-1477649122972940 / 2879985977 : ℚ)) * X ^ 17 + C ((-544202271394384 / 2879985977 : ℚ)) * X ^ 18
theorem CV_013_0_pre_eq :
    CV_0_re_002 * Fplus_dU_re_011 - CV_0_im_002 * Fplus_dU_im_011 = CV_013_0_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_0_re_002, CV_0_im_002, Fplus_dU_re_011, Fplus_dU_im_011, CV_013_0_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CV_013_0_pim_eq :
    CV_0_re_002 * Fplus_dU_im_011 + CV_0_im_002 * Fplus_dU_re_011 = CV_013_0_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_0_re_002, CV_0_im_002, Fplus_dU_re_011, Fplus_dU_im_011, CV_013_0_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CV_013_0_mul :
    CV_0_c_002 * Fplus_dU_c_011 = ofLadj CV_013_0_pre CV_013_0_pim := by
  rw [CV_0_c_002, Fplus_dU_c_011, ofLadj_mul, CV_013_0_pre_eq, CV_013_0_pim_eq]

def CV_013_1_pre : Polynomial ℚ := C ((147586005252808 / 2879985977 : ℚ)) + C ((6082765530604000 / 8639957931 : ℚ)) * X + C ((12073461254285240 / 8639957931 : ℚ)) * X ^ 2 + C ((19779781801018016 / 8639957931 : ℚ)) * X ^ 3 + C ((29496279389188676 / 8639957931 : ℚ)) * X ^ 4 + C ((35132588947442216 / 8639957931 : ℚ)) * X ^ 5 + C ((39741618058575736 / 8639957931 : ℚ)) * X ^ 6 + C ((42507876127232732 / 8639957931 : ℚ)) * X ^ 7 + C ((40512283011545992 / 8639957931 : ℚ)) * X ^ 8 + C ((40054447105714444 / 8639957931 : ℚ)) * X ^ 9 + C ((13235076707854132 / 2879985977 : ℚ)) * X ^ 10 + C ((39131974892107568 / 8639957931 : ℚ)) * X ^ 11 + C ((33622464592958396 / 8639957931 : ℚ)) * X ^ 12 + C ((2543725986493564 / 785450721 : ℚ)) * X ^ 13 + C ((20732501210527976 / 8639957931 : ℚ)) * X ^ 14 + C ((11436450209232812 / 8639957931 : ℚ)) * X ^ 15 + C ((6050167615707568 / 8639957931 : ℚ)) * X ^ 16 + C ((1441138504574048 / 8639957931 : ℚ)) * X ^ 17 + C ((-1575146528811244 / 8639957931 : ℚ)) * X ^ 18
def CV_013_1_pim : Polynomial ℚ := C ((-4136962559360296 / 8639957931 : ℚ)) + C ((-8273925118720592 / 8639957931 : ℚ)) * X + C ((-3236309302137652 / 2879985977 : ℚ)) * X ^ 2 + C ((-11653911691532228 / 8639957931 : ℚ)) * X ^ 3 + C ((-8939578862345512 / 8639957931 : ℚ)) * X ^ 4 + C ((-1149960286453700 / 2879985977 : ℚ)) * X ^ 5 + C ((343233514010584 / 2879985977 : ℚ)) * X ^ 6 + C ((7720346471364548 / 8639957931 : ℚ)) * X ^ 7 + C ((11639763319780736 / 8639957931 : ℚ)) * X ^ 8 + C ((11574185056648468 / 8639957931 : ℚ)) * X ^ 9 + C ((11271264840024652 / 8639957931 : ℚ)) * X ^ 10 + C ((14964645574038616 / 8639957931 : ℚ)) * X ^ 11 + C ((18658026308052580 / 8639957931 : ℚ)) * X ^ 12 + C ((19790108879121128 / 8639957931 : ℚ)) * X ^ 13 + C ((7223171467036044 / 2879985977 : ℚ)) * X ^ 14 + C ((19146960732083224 / 8639957931 : ℚ)) * X ^ 15 + C ((14046556063461928 / 8639957931 : ℚ)) * X ^ 16 + C ((10028990283224060 / 8639957931 : ℚ)) * X ^ 17 + C ((3727637688254380 / 8639957931 : ℚ)) * X ^ 18
theorem CV_013_1_pre_eq :
    CV_1_re_002 * Fplus_dV_re_011 - CV_1_im_002 * Fplus_dV_im_011 = CV_013_1_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_1_re_002, CV_1_im_002, Fplus_dV_re_011, Fplus_dV_im_011, CV_013_1_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CV_013_1_pim_eq :
    CV_1_re_002 * Fplus_dV_im_011 + CV_1_im_002 * Fplus_dV_re_011 = CV_013_1_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_1_re_002, CV_1_im_002, Fplus_dV_re_011, Fplus_dV_im_011, CV_013_1_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CV_013_1_mul :
    CV_1_c_002 * Fplus_dV_c_011 = ofLadj CV_013_1_pre CV_013_1_pim := by
  rw [CV_1_c_002, Fplus_dV_c_011, ofLadj_mul, CV_013_1_pre_eq, CV_013_1_pim_eq]

def CV_013_2_pre : Polynomial ℚ := C ((87210239048 / 97078179 : ℚ)) + C ((-162804631785056 / 8639957931 : ℚ)) * X + C ((-115658937247004 / 2879985977 : ℚ)) * X ^ 2 + C ((-593612445887344 / 8639957931 : ℚ)) * X ^ 3 + C ((-945304212952588 / 8639957931 : ℚ)) * X ^ 4 + C ((-1223448447283804 / 8639957931 : ℚ)) * X ^ 5 + C ((-480274556397824 / 2879985977 : ℚ)) * X ^ 6 + C ((-1505172860234000 / 8639957931 : ℚ)) * X ^ 7 + C ((-1359861015834812 / 8639957931 : ℚ)) * X ^ 8 + C ((-1257728812174100 / 8639957931 : ℚ)) * X ^ 9 + C ((-393321765628128 / 2879985977 : ℚ)) * X ^ 10 + C ((-1158516006254152 / 8639957931 : ℚ)) * X ^ 11 + C ((-1017160665099328 / 8639957931 : ℚ)) * X ^ 12 + C ((-930288049472 / 8825289 : ℚ)) * X ^ 13 + C ((-766248569947468 / 8639957931 : ℚ)) * X ^ 14 + C ((-169405164023516 / 2879985977 : ℚ)) * X ^ 15 + C ((-285845585496544 / 8639957931 : ℚ)) * X ^ 16 + C ((-68470363586876 / 8639957931 : ℚ)) * X ^ 17 + C ((51653155210864 / 8639957931 : ℚ)) * X ^ 18
def CV_013_2_pim : Polynomial ℚ := C ((174920349090440 / 8639957931 : ℚ)) + C ((349840698180880 / 8639957931 : ℚ)) * X + C ((433709348664820 / 8639957931 : ℚ)) * X ^ 2 + C ((550601588190184 / 8639957931 : ℚ)) * X ^ 3 + C ((16356381075916 / 261816907 : ℚ)) * X ^ 4 + C ((380509970056016 / 8639957931 : ℚ)) * X ^ 5 + C ((53911110548524 / 2879985977 : ℚ)) * X ^ 6 + C ((-141034193741072 / 8639957931 : ℚ)) * X ^ 7 + C ((-307357143538912 / 8639957931 : ℚ)) * X ^ 8 + C ((-26619634905200 / 785450721 : ℚ)) * X ^ 9 + C ((-225258245927276 / 8639957931 : ℚ)) * X ^ 10 + C ((-301293559905208 / 8639957931 : ℚ)) * X ^ 11 + C ((-125776291294380 / 2879985977 : ℚ)) * X ^ 12 + C ((-393639786337156 / 8639957931 : ℚ)) * X ^ 13 + C ((-495990866280808 / 8639957931 : ℚ)) * X ^ 14 + C ((-527817376596644 / 8639957931 : ℚ)) * X ^ 15 + C ((-455434464035536 / 8639957931 : ℚ)) * X ^ 16 + C ((-339555259295588 / 8639957931 : ℚ)) * X ^ 17 + C ((-41218475599016 / 2879985977 : ℚ)) * X ^ 18
theorem CV_013_2_pre_eq :
    CV_2_re_002 * Fplus_dW_re_011 - CV_2_im_002 * Fplus_dW_im_011 = CV_013_2_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_2_re_002, CV_2_im_002, Fplus_dW_re_011, Fplus_dW_im_011, CV_013_2_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CV_013_2_pim_eq :
    CV_2_re_002 * Fplus_dW_im_011 + CV_2_im_002 * Fplus_dW_re_011 = CV_013_2_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_2_re_002, CV_2_im_002, Fplus_dW_re_011, Fplus_dW_im_011, CV_013_2_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CV_013_2_mul :
    CV_2_c_002 * Fplus_dW_c_011 = ofLadj CV_013_2_pre CV_013_2_pim := by
  rw [CV_2_c_002, Fplus_dW_c_011, ofLadj_mul, CV_013_2_pre_eq, CV_013_2_pim_eq]

theorem CV_013_3_mul : CV_3_c_003 = ofLadj CV_3_re_003 CV_3_im_003 := rfl

@[expose] public def CV_coeff_013 : Ki := CV_0_c_002 * Fplus_dU_c_011 + CV_1_c_002 * Fplus_dV_c_011 + CV_2_c_002 * Fplus_dW_c_011 + CV_3_c_003

theorem CV_coeff_013_sum :
    CV_coeff_013 = ofLadj (CV_013_0_pre + CV_013_1_pre + CV_013_2_pre + CV_3_re_003) (CV_013_0_pim + CV_013_1_pim + CV_013_2_pim + CV_3_im_003) := by
  simp only [CV_coeff_013, CV_013_0_mul, CV_013_1_mul, CV_013_2_mul, CV_013_3_mul]
  simpa [add_assoc] using ofLadj_add4 CV_013_0_pre CV_013_0_pim CV_013_1_pre CV_013_1_pim CV_013_2_pre CV_013_2_pim CV_3_re_003 CV_3_im_003

def CV_013_qre : Polynomial ℚ := C ((78531041189864 / 2879985977 : ℚ)) + C ((2818879228035752 / 8639957931 : ℚ)) * X + C ((949887402654052 / 2879985977 : ℚ)) * X ^ 2 + C ((3718888308938192 / 8639957931 : ℚ)) * X ^ 3 + C ((1563860560655044 / 2879985977 : ℚ)) * X ^ 4 + C ((892069742006692 / 2879985977 : ℚ)) * X ^ 5 + C ((2228652076156772 / 8639957931 : ℚ)) * X ^ 6 + C ((1507954686569284 / 8639957931 : ℚ)) * X ^ 7 + C ((-299919820218356 / 2879985977 : ℚ)) * X ^ 8
def CV_013_qim : Polynomial ℚ := C ((-2042424584401504 / 8639957931 : ℚ)) + C ((-2042424584401504 / 8639957931 : ℚ)) * X + C ((-637971272030200 / 8639957931 : ℚ)) * X ^ 2 + C ((-1016224554325360 / 8639957931 : ℚ)) * X ^ 3 + C ((1372846576070828 / 8639957931 : ℚ)) * X ^ 4 + C ((898413255119520 / 2879985977 : ℚ)) * X ^ 5 + C ((717452508206464 / 2879985977 : ℚ)) * X ^ 6 + C ((3285112207735472 / 8639957931 : ℚ)) * X ^ 7 + C ((1971375447274180 / 8639957931 : ℚ)) * X ^ 8
theorem CV_coeff_013_poly_re :
    CV_013_0_pre + CV_013_1_pre + CV_013_2_pre + CV_3_re_003 = (0 : Polynomial ℚ) + Phi11 * CV_013_qre := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [CV_013_0_pre, CV_013_1_pre, CV_013_2_pre, CV_3_re_003, CV_013_qre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try ring
theorem CV_coeff_013_poly_im :
    CV_013_0_pim + CV_013_1_pim + CV_013_2_pim + CV_3_im_003 = (0 : Polynomial ℚ) + Phi11 * CV_013_qim := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [CV_013_0_pim, CV_013_1_pim, CV_013_2_pim, CV_3_im_003, CV_013_qim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try ring
public theorem CV_coeff_013_eq :
    CV_coeff_013 = (0 : Ki) := by
  rw [CV_coeff_013_sum, CV_coeff_013_poly_re,
    CV_coeff_013_poly_im, ofLadj_add_Phi11]
  exact ofLadj_zero

end V14Formalization.D12SigmaPlusSegreCore
