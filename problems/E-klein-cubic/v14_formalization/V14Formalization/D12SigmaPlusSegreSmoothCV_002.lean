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

def CV_002_0_pre : Polynomial ℚ := C ((-25973079712951 / 17279915862 : ℚ)) + C ((-228796880941538 / 8639957931 : ℚ)) * X + C ((-910399862665079 / 17279915862 : ℚ)) * X ^ 2 + C ((-1479229646770067 / 17279915862 : ℚ)) * X ^ 3 + C ((-2250021209440933 / 17279915862 : ℚ)) * X ^ 4 + C ((-905985053342777 / 5759971954 : ℚ)) * X ^ 5 + C ((-1574140982462129 / 8639957931 : ℚ)) * X ^ 6 + C ((-1716357520282972 / 8639957931 : ℚ)) * X ^ 7 + C ((-1687534804767854 / 8639957931 : ℚ)) * X ^ 8 + C ((-155470057951166 / 785450721 : ℚ)) * X ^ 9 + C ((-1151679343305549 / 5759971954 : ℚ)) * X ^ 10 + C ((-573655936365575 / 2879985977 : ℚ)) * X ^ 11 + C ((-2997444268033571 / 17279915862 : ℚ)) * X ^ 12 + C ((-836647137420191 / 5759971954 : ℚ)) * X ^ 13 + C ((-1895839962765641 / 17279915862 : ℚ)) * X ^ 14 + C ((-1083354971132723 / 17279915862 : ℚ)) * X ^ 15 + C ((-813544220782 / 23801537 : ℚ)) * X ^ 16 + C ((-160306299391805 / 17279915862 : ℚ)) * X ^ 17 + C ((49669429996144 / 8639957931 : ℚ)) * X ^ 18
def CV_002_0_pim : Polynomial ℚ := C ((29868641695283 / 1570901442 : ℚ)) + C ((29868641695283 / 785450721 : ℚ)) * X + C ((266144457908625 / 5759971954 : ℚ)) * X ^ 2 + C ((166778564101856 / 2879985977 : ℚ)) * X ^ 3 + C ((434253791323925 / 8639957931 : ℚ)) * X ^ 4 + C ((262266057699832 / 8639957931 : ℚ)) * X ^ 5 + C ((129507039309916 / 8639957931 : ℚ)) * X ^ 6 + C ((-111074066704357 / 8639957931 : ℚ)) * X ^ 7 + C ((-82916743766211 / 2879985977 : ℚ)) * X ^ 8 + C ((-168079157549437 / 5759971954 : ℚ)) * X ^ 9 + C ((-89009777939794 / 2879985977 : ℚ)) * X ^ 10 + C ((-453325391477726 / 8639957931 : ℚ)) * X ^ 11 + C ((-639621449136070 / 8639957931 : ℚ)) * X ^ 12 + C ((-241731224948707 / 2879985977 : ℚ)) * X ^ 13 + C ((-276560395104758 / 2879985977 : ℚ)) * X ^ 14 + C ((-251314848243456 / 2879985977 : ℚ)) * X ^ 15 + C ((-2108110705783 / 32359393 : ℚ)) * X ^ 16 + C ((-407003262873026 / 8639957931 : ℚ)) * X ^ 17 + C ((-147330904196539 / 8639957931 : ℚ)) * X ^ 18
theorem CV_002_0_pre_eq :
    CV_0_re_000 * Fplus_dU_re_002 - CV_0_im_000 * Fplus_dU_im_002 = CV_002_0_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_0_re_000_def, CV_0_im_000_def, Fplus_dU_re_002_def, Fplus_dU_im_002_def, CV_002_0_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CV_002_0_pim_eq :
    CV_0_re_000 * Fplus_dU_im_002 + CV_0_im_000 * Fplus_dU_re_002 = CV_002_0_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_0_re_000_def, CV_0_im_000_def, Fplus_dU_re_002_def, Fplus_dU_im_002_def, CV_002_0_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CV_002_0_mul :
    CV_0_c_000 * Fplus_dU_c_002 = ofLadj CV_002_0_pre CV_002_0_pim := by
  rw [CV_0_c_000_def, Fplus_dU_c_002_def, ofLadj_mul, CV_002_0_pre_eq, CV_002_0_pim_eq]

def CV_002_1_pre : Polynomial ℚ := C ((4635250888 / 32359393 : ℚ)) + C ((-27007668842560 / 8639957931 : ℚ)) * X + C ((-115095630157327 / 17279915862 : ℚ)) * X ^ 2 + C ((-98421733999687 / 8639957931 : ℚ)) * X ^ 3 + C ((-104512699610889 / 5759971954 : ℚ)) * X ^ 4 + C ((-67599450651621 / 2879985977 : ℚ)) * X ^ 5 + C ((-477852749781559 / 17279915862 : ℚ)) * X ^ 6 + C ((-83173767533338 / 2879985977 : ℚ)) * X ^ 7 + C ((-6833137978009 / 261816907 : ℚ)) * X ^ 8 + C ((-208556689837316 / 8639957931 : ℚ)) * X ^ 9 + C ((-130450626531957 / 5759971954 : ℚ)) * X ^ 10 + C ((-192069296766937 / 8639957931 : ℚ)) * X ^ 11 + C ((-337336541910751 / 17279915862 : ℚ)) * X ^ 12 + C ((-1131152619915 / 64718786 : ℚ)) * X ^ 13 + C ((-127071819274610 / 8639957931 : ℚ)) * X ^ 14 + C ((-84244745047762 / 8639957931 : ℚ)) * X ^ 15 + C ((-94909364781581 / 17279915862 : ℚ)) * X ^ 16 + C ((-11326659454874 / 8639957931 : ℚ)) * X ^ 17 + C ((17015016271837 / 17279915862 : ℚ)) * X ^ 18
def CV_002_1_pim : Polynomial ℚ := C ((29005051141994 / 8639957931 : ℚ)) + C ((58010102283988 / 8639957931 : ℚ)) * X + C ((71878584106750 / 8639957931 : ℚ)) * X ^ 2 + C ((91350404478898 / 8639957931 : ℚ)) * X ^ 3 + C ((89415606009010 / 8639957931 : ℚ)) * X ^ 4 + C ((63162767588603 / 8639957931 : ℚ)) * X ^ 5 + C ((26790632518003 / 8639957931 : ℚ)) * X ^ 6 + C ((-15527178274043 / 5759971954 : ℚ)) * X ^ 7 + C ((-50909492558095 / 8639957931 : ℚ)) * X ^ 8 + C ((-96930848354441 / 17279915862 : ℚ)) * X ^ 9 + C ((-74579035315721 / 17279915862 : ℚ)) * X ^ 10 + C ((-49895047745248 / 8639957931 : ℚ)) * X ^ 11 + C ((-125001155665271 / 17279915862 : ℚ)) * X ^ 12 + C ((-130386306272075 / 17279915862 : ℚ)) * X ^ 13 + C ((-82220905127311 / 8639957931 : ℚ)) * X ^ 14 + C ((-7946847497014 / 785450721 : ℚ)) * X ^ 15 + C ((-13727633931545 / 1570901442 : ℚ)) * X ^ 16 + C ((-112462813379233 / 17279915862 : ℚ)) * X ^ 17 + C ((-13659672891533 / 5759971954 : ℚ)) * X ^ 18
theorem CV_002_1_pre_eq :
    CV_1_re_000 * Fplus_dV_re_002 - CV_1_im_000 * Fplus_dV_im_002 = CV_002_1_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_1_re_000_def, CV_1_im_000_def, Fplus_dV_re_002_def, Fplus_dV_im_002_def, CV_002_1_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CV_002_1_pim_eq :
    CV_1_re_000 * Fplus_dV_im_002 + CV_1_im_000 * Fplus_dV_re_002 = CV_002_1_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_1_re_000_def, CV_1_im_000_def, Fplus_dV_re_002_def, Fplus_dV_im_002_def, CV_002_1_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CV_002_1_mul :
    CV_1_c_000 * Fplus_dV_c_002 = ofLadj CV_002_1_pre CV_002_1_pim := by
  rw [CV_1_c_000_def, Fplus_dV_c_002_def, ofLadj_mul, CV_002_1_pre_eq, CV_002_1_pim_eq]

def CV_002_2_pre : Polynomial ℚ := C ((1920221437375 / 5759971954 : ℚ)) + C ((-2502253121471 / 2879985977 : ℚ)) * X ^ 2 + C ((-5797577194812 / 2879985977 : ℚ)) * X ^ 3 + C ((-17610046461861 / 5759971954 : ℚ)) * X ^ 4 + C ((-10609628890530 / 2879985977 : ℚ)) * X ^ 5 + C ((-10609628890530 / 2879985977 : ℚ)) * X ^ 6 + C ((-17610046461861 / 5759971954 : ℚ)) * X ^ 7 + C ((-5797577194812 / 2879985977 : ℚ)) * X ^ 8 + C ((-2502253121471 / 2879985977 : ℚ)) * X ^ 9
def CV_002_2_pim : Polynomial ℚ := C ((3200382002395 / 2879985977 : ℚ)) + C ((6400764004790 / 2879985977 : ℚ)) * X + C ((17096013197171 / 5759971954 : ℚ)) * X ^ 2 + C ((18100455315171 / 5759971954 : ℚ)) * X ^ 3 + C ((15268009644251 / 5759971954 : ℚ)) * X ^ 4 + C ((4890252096443 / 2879985977 : ℚ)) * X ^ 5 + C ((1510511908347 / 2879985977 : ℚ)) * X ^ 6 + C ((-2466481634671 / 5759971954 : ℚ)) * X ^ 7 + C ((-5298927305591 / 5759971954 : ℚ)) * X ^ 8 + C ((-4294485187591 / 5759971954 : ℚ)) * X ^ 9
theorem CV_002_2_pre_eq :
    CV_2_re_000 * Fplus_dW_re_002 - CV_2_im_000 * Fplus_dW_im_002 = CV_002_2_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_2_re_000_def, CV_2_im_000_def, Fplus_dW_re_002_def, Fplus_dW_im_002_def, CV_002_2_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CV_002_2_pim_eq :
    CV_2_re_000 * Fplus_dW_im_002 + CV_2_im_000 * Fplus_dW_re_002 = CV_002_2_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_2_re_000_def, CV_2_im_000_def, Fplus_dW_re_002_def, Fplus_dW_im_002_def, CV_002_2_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CV_002_2_mul :
    CV_2_c_000 * Fplus_dW_c_002 = ofLadj CV_002_2_pre CV_002_2_pim := by
  rw [CV_2_c_000_def, Fplus_dW_c_002_def, ofLadj_mul, CV_002_2_pre_eq, CV_002_2_pim_eq]

def CV_002_3_pre : Polynomial ℚ := C ((-39068278160 / 261816907 : ℚ)) + C ((92094906312 / 261816907 : ℚ)) * X ^ 2 + C ((656921351848 / 785450721 : ℚ)) * X ^ 3 + C ((992909062496 / 785450721 : ℚ)) * X ^ 4 + C ((1198281674456 / 785450721 : ℚ)) * X ^ 5 + C ((1198281674456 / 785450721 : ℚ)) * X ^ 6 + C ((992909062496 / 785450721 : ℚ)) * X ^ 7 + C ((656921351848 / 785450721 : ℚ)) * X ^ 8 + C ((92094906312 / 261816907 : ℚ)) * X ^ 9
def CV_002_3_pim : Polynomial ℚ := C ((-3982138727504 / 8639957931 : ℚ)) + C ((-7964277455008 / 8639957931 : ℚ)) * X + C ((-10671314260528 / 8639957931 : ℚ)) * X ^ 2 + C ((-11253540792880 / 8639957931 : ℚ)) * X ^ 3 + C ((-9530396079032 / 8639957931 : ℚ)) * X ^ 4 + C ((-6050887987448 / 8639957931 : ℚ)) * X ^ 5 + C ((-1913389467560 / 8639957931 : ℚ)) * X ^ 6 + C ((1566118624024 / 8639957931 : ℚ)) * X ^ 7 + C ((1096421112624 / 2879985977 : ℚ)) * X ^ 8 + C ((902345601840 / 2879985977 : ℚ)) * X ^ 9
theorem CV_002_3_neg_re : -CV_3_re_002 = CV_002_3_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_3_re_002_def, CV_002_3_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CV_002_3_neg_im : -CV_3_im_002 = CV_002_3_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_3_im_002_def, CV_002_3_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CV_002_3_mul : -CV_3_c_002 = ofLadj CV_002_3_pre CV_002_3_pim := by
  rw [CV_3_c_002_def, ofLadj_neg, CV_002_3_neg_re, CV_002_3_neg_im]

@[expose] public def CV_coeff_002 : Ki := CV_0_c_000 * Fplus_dU_c_002 + CV_1_c_000 * Fplus_dV_c_002 + CV_2_c_000 * Fplus_dW_c_002 + (-CV_3_c_002)

theorem CV_coeff_002_sum :
    CV_coeff_002 = ofLadj (CV_002_0_pre + CV_002_1_pre + CV_002_2_pre + CV_002_3_pre) (CV_002_0_pim + CV_002_1_pim + CV_002_2_pim + CV_002_3_pim) := by
  simp only [CV_coeff_002, CV_002_0_mul, CV_002_1_mul, CV_002_2_mul, CV_002_3_mul]
  simpa [add_assoc] using ofLadj_add4 CV_002_0_pre CV_002_0_pim CV_002_1_pre CV_002_1_pim CV_002_2_pre CV_002_2_pim CV_002_3_pre CV_002_3_pim

def CV_002_qre : Polynomial ℚ := C ((-10157848892597 / 8639957931 : ℚ)) + C ((-245646700891501 / 8639957931 : ℚ)) * X + C ((-89006068806 / 2941763 : ℚ)) * X ^ 2 + C ((-220658520154339 / 5759971954 : ℚ)) * X ^ 3 + C ((-449069570043307 / 8639957931 : ℚ)) * X ^ 4 + C ((-283150996079467 / 8639957931 : ℚ)) * X ^ 5 + C ((-251291425383880 / 8639957931 : ℚ)) * X ^ 6 + C ((-49885582427613 / 2879985977 : ℚ)) * X ^ 7 + C ((38784625421375 / 5759971954 : ℚ)) * X ^ 8
def CV_002_qim : Polynomial ℚ := C ((397803175491463 / 17279915862 : ℚ)) + C ((397803175491463 / 17279915862 : ℚ)) * X + C ((88264801013453 / 8639957931 : ℚ)) * X ^ 2 + C ((81010174972951 / 5759971954 : ℚ)) * X ^ 3 + C ((-70542223244063 / 8639957931 : ℚ)) * X ^ 4 + C ((-135328214753309 / 5759971954 : ℚ)) * X ^ 5 + C ((-175132875504916 / 8639957931 : ℚ)) * X ^ 6 + C ((-8951947152388 / 261816907 : ℚ)) * X ^ 7 + C ((-335640827067677 / 17279915862 : ℚ)) * X ^ 8
theorem CV_coeff_002_poly_re :
    CV_002_0_pre + CV_002_1_pre + CV_002_2_pre + CV_002_3_pre = (0 : Polynomial ℚ) + Phi11 * CV_002_qre := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [CV_002_0_pre, CV_002_1_pre, CV_002_2_pre, CV_002_3_pre, CV_002_qre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try grind
theorem CV_coeff_002_poly_im :
    CV_002_0_pim + CV_002_1_pim + CV_002_2_pim + CV_002_3_pim = (0 : Polynomial ℚ) + Phi11 * CV_002_qim := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [CV_002_0_pim, CV_002_1_pim, CV_002_2_pim, CV_002_3_pim, CV_002_qim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try grind
public theorem CV_coeff_002_eq :
    CV_coeff_002 = (0 : Ki) := by
  rw [CV_coeff_002_sum, CV_coeff_002_poly_re,
    CV_coeff_002_poly_im, ofLadj_add_Phi11]
  exact ofLadj_zero

end V14Formalization.D12SigmaPlusSegreCore
