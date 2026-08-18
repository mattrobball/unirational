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

def CV_020_0_pre : Polynomial ℚ := C ((27267711377 / 523633814 : ℚ)) + C ((-81713171764835 / 8639957931 : ℚ)) * X + C ((-307781119539329 / 17279915862 : ℚ)) * X ^ 2 + C ((-530937077009249 / 17279915862 : ℚ)) * X ^ 3 + C ((-433783689645055 / 8639957931 : ℚ)) * X ^ 4 + C ((-1118771570704255 / 17279915862 : ℚ)) * X ^ 5 + C ((-1364674644154361 / 17279915862 : ℚ)) * X ^ 6 + C ((-1561958809346999 / 17279915862 : ℚ)) * X ^ 7 + C ((-794131061816137 / 8639957931 : ℚ)) * X ^ 8 + C ((-547746524953281 / 5759971954 : ℚ)) * X ^ 9 + C ((-562062649756367 / 5759971954 : ℚ)) * X ^ 10 + C ((-851182751958808 / 8639957931 : ℚ)) * X ^ 11 + C ((-1522761605739431 / 17279915862 : ℚ)) * X ^ 12 + C ((-667729227660257 / 8639957931 : ℚ)) * X ^ 13 + C ((-352441682207675 / 5759971954 : ℚ)) * X ^ 14 + C ((-334707915301696 / 8639957931 : ℚ)) * X ^ 15 + C ((-1453170281517 / 64718786 : ℚ)) * X ^ 16 + C ((-142093391714933 / 17279915862 : ℚ)) * X ^ 17 + C ((2270509041227 / 1570901442 : ℚ)) * X ^ 18
def CV_020_0_pim : Polynomial ℚ := C ((75596846052736 / 8639957931 : ℚ)) + C ((151193692105472 / 8639957931 : ℚ)) * X + C ((67872130072685 / 2879985977 : ℚ)) * X ^ 2 + C ((286833354389902 / 8639957931 : ℚ)) * X ^ 3 + C ((599381859065855 / 17279915862 : ℚ)) * X ^ 4 + C ((266848365433135 / 8639957931 : ℚ)) * X ^ 5 + C ((156143575659831 / 5759971954 : ℚ)) * X ^ 6 + C ((279874343449291 / 17279915862 : ℚ)) * X ^ 7 + C ((145095411822851 / 17279915862 : ℚ)) * X ^ 8 + C ((68732708447452 / 8639957931 : ℚ)) * X ^ 9 + C ((33541917523427 / 5759971954 : ℚ)) * X ^ 10 + C ((-17390936385946 / 2879985977 : ℚ)) * X ^ 11 + C ((-103105663067211 / 5759971954 : ℚ)) * X ^ 12 + C ((-225501024875711 / 8639957931 : ℚ)) * X ^ 13 + C ((-18941393121911 / 523633814 : ℚ)) * X ^ 14 + C ((-209320811038683 / 5759971954 : ℚ)) * X ^ 15 + C ((-85779788128472 / 2879985977 : ℚ)) * X ^ 16 + C ((-35795689226849 / 1570901442 : ℚ)) * X ^ 17 + C ((-157597621819505 / 17279915862 : ℚ)) * X ^ 18
theorem CV_020_0_pre_eq :
    CV_0_re_000 * Fplus_dU_re_020 - CV_0_im_000 * Fplus_dU_im_020 = CV_020_0_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_0_re_000_def, CV_0_im_000_def, Fplus_dU_re_020_def, Fplus_dU_im_020_def, CV_020_0_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CV_020_0_pim_eq :
    CV_0_re_000 * Fplus_dU_im_020 + CV_0_im_000 * Fplus_dU_re_020 = CV_020_0_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_0_re_000_def, CV_0_im_000_def, Fplus_dU_re_020_def, Fplus_dU_im_020_def, CV_020_0_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CV_020_0_mul :
    CV_0_c_000 * Fplus_dU_c_020 = ofLadj CV_020_0_pre CV_020_0_pim := by
  rw [CV_0_c_000_def, Fplus_dU_c_020_def, ofLadj_mul, CV_020_0_pre_eq, CV_020_0_pim_eq]

def CV_020_1_pre : Polynomial ℚ := C ((2757152611772 / 2879985977 : ℚ)) + C ((27007668842560 / 2879985977 : ℚ)) * X + C ((93911222206935 / 5759971954 : ℚ)) * X ^ 2 + C ((75874767661045 / 2879985977 : ℚ)) * X ^ 3 + C ((229371966280937 / 5759971954 : ℚ)) * X ^ 4 + C ((130299980162194 / 2879985977 : ℚ)) * X ^ 5 + C ((149554625404567 / 2879985977 : ℚ)) * X ^ 6 + C ((171585421326888 / 2879985977 : ℚ)) * X ^ 7 + C ((351381181278143 / 5759971954 : ℚ)) * X ^ 8 + C ((189420691177889 / 2879985977 : ℚ)) * X ^ 9 + C ((399796280542233 / 5759971954 : ℚ)) * X ^ 10 + C ((201048169096029 / 2879985977 : ℚ)) * X ^ 11 + C ((345780942857113 / 5759971954 : ℚ)) * X ^ 12 + C ((25902741831713 / 523633814 : ℚ)) * X ^ 13 + C ((199631645956053 / 5759971954 : ℚ)) * X ^ 14 + C ((48391930050501 / 2879985977 : ℚ)) * X ^ 15 + C ((25285202709649 / 2879985977 : ℚ)) * X ^ 16 + C ((6030557467276 / 2879985977 : ℚ)) * X ^ 17 + C ((-17015016271837 / 5759971954 : ℚ)) * X ^ 18
def CV_020_1_pim : Polynomial ℚ := C ((-15501216720714 / 2879985977 : ℚ)) + C ((-31002433441428 / 2879985977 : ℚ)) * X + C ((-35668508515179 / 2879985977 : ℚ)) * X ^ 2 + C ((-46368271207726 / 2879985977 : ℚ)) * X ^ 3 + C ((-34804065735994 / 2879985977 : ℚ)) * X ^ 4 + C ((-31513102647471 / 5759971954 : ℚ)) * X ^ 5 + C ((-21327865454703 / 5759971954 : ℚ)) * X ^ 6 + C ((8811727500564 / 2879985977 : ℚ)) * X ^ 7 + C ((23537355782557 / 2879985977 : ℚ)) * X ^ 8 + C ((25510855552906 / 2879985977 : ℚ)) * X ^ 9 + C ((69188702306905 / 5759971954 : ℚ)) * X ^ 10 + C ((63398882166528 / 2879985977 : ℚ)) * X ^ 11 + C ((184406826359207 / 5759971954 : ℚ)) * X ^ 12 + C ((105952983853901 / 2879985977 : ℚ)) * X ^ 13 + C ((118626246316797 / 2879985977 : ℚ)) * X ^ 14 + C ((202596319579517 / 5759971954 : ℚ)) * X ^ 15 + C ((70585611627604 / 2879985977 : ℚ)) * X ^ 16 + C ((51630203315111 / 2879985977 : ℚ)) * X ^ 17 + C ((40979018674599 / 5759971954 : ℚ)) * X ^ 18
theorem CV_020_1_pre_eq :
    CV_1_re_000 * Fplus_dV_re_020 - CV_1_im_000 * Fplus_dV_im_020 = CV_020_1_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_1_re_000_def, CV_1_im_000_def, Fplus_dV_re_020_def, Fplus_dV_im_020_def, CV_020_1_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CV_020_1_pim_eq :
    CV_1_re_000 * Fplus_dV_im_020 + CV_1_im_000 * Fplus_dV_re_020 = CV_020_1_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_1_re_000_def, CV_1_im_000_def, Fplus_dV_re_020_def, Fplus_dV_im_020_def, CV_020_1_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CV_020_1_mul :
    CV_1_c_000 * Fplus_dV_c_020 = ofLadj CV_020_1_pre CV_020_1_pim := by
  rw [CV_1_c_000_def, Fplus_dV_c_020_def, ofLadj_mul, CV_020_1_pre_eq, CV_020_1_pim_eq]

def CV_020_2_pre : Polynomial ℚ := C ((4053861199385 / 2879985977 : ℚ)) + C ((179221392134120 / 8639957931 : ℚ)) * X + C ((708413161448797 / 17279915862 : ℚ)) * X ^ 2 + C ((1160254267563583 / 17279915862 : ℚ)) * X ^ 3 + C ((577758327811279 / 5759971954 : ℚ)) * X ^ 4 + C ((343479517211309 / 2879985977 : ℚ)) * X ^ 5 + C ((2334487585315015 / 17279915862 : ℚ)) * X ^ 6 + C ((1247317092848051 / 8639957931 : ℚ)) * X ^ 7 + C ((396545684506755 / 2879985977 : ℚ)) * X ^ 8 + C ((1175935477517597 / 8639957931 : ℚ)) * X ^ 9 + C ((2331954634885087 / 17279915862 : ℚ)) * X ^ 10 + C ((383247229859601 / 2879985977 : ℚ)) * X ^ 11 + C ((657837283538949 / 5759971954 : ℚ)) * X ^ 12 + C ((547819264528799 / 5759971954 : ℚ)) * X ^ 13 + C ((1219019839476947 / 17279915862 : ℚ)) * X ^ 14 + C ((670396274556533 / 17279915862 : ℚ)) * X ^ 15 + C ((357535362613067 / 17279915862 : ℚ)) * X ^ 16 + C ((41962440282953 / 8639957931 : ℚ)) * X ^ 17 + C ((-45481463852866 / 8639957931 : ℚ)) * X ^ 18
def CV_020_2_pim : Polynomial ℚ := C ((-122254538143055 / 8639957931 : ℚ)) + C ((-244509076286110 / 8639957931 : ℚ)) * X + C ((-25913110760503 / 785450721 : ℚ)) * X ^ 2 + C ((-344660933037371 / 8639957931 : ℚ)) * X ^ 3 + C ((-175664495757527 / 5759971954 : ℚ)) * X ^ 4 + C ((-103726543088254 / 8639957931 : ℚ)) * X ^ 5 + C ((55706720639015 / 17279915862 : ℚ)) * X ^ 6 + C ((223889165101985 / 8639957931 : ℚ)) * X ^ 7 + C ((676935475666273 / 17279915862 : ℚ)) * X ^ 8 + C ((336362235986063 / 8639957931 : ℚ)) * X ^ 9 + C ((109177193782245 / 2879985977 : ℚ)) * X ^ 10 + C ((436765016002948 / 8639957931 : ℚ)) * X ^ 11 + C ((545998450659161 / 8639957931 : ℚ)) * X ^ 12 + C ((577702938099256 / 8639957931 : ℚ)) * X ^ 13 + C ((1270428301848041 / 17279915862 : ℚ)) * X ^ 14 + C ((559932259592327 / 8639957931 : ℚ)) * X ^ 15 + C ((274238581480775 / 5759971954 : ℚ)) * X ^ 16 + C ((293536266267370 / 8639957931 : ℚ)) * X ^ 17 + C ((72464183107843 / 5759971954 : ℚ)) * X ^ 18
theorem CV_020_2_pre_eq :
    CV_2_re_000 * Fplus_dW_re_020 - CV_2_im_000 * Fplus_dW_im_020 = CV_020_2_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_2_re_000_def, CV_2_im_000_def, Fplus_dW_re_020_def, Fplus_dW_im_020_def, CV_020_2_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CV_020_2_pim_eq :
    CV_2_re_000 * Fplus_dW_im_020 + CV_2_im_000 * Fplus_dW_re_020 = CV_020_2_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_2_re_000_def, CV_2_im_000_def, Fplus_dW_re_020_def, Fplus_dW_im_020_def, CV_020_2_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CV_020_2_mul :
    CV_2_c_000 * Fplus_dW_c_020 = ofLadj CV_020_2_pre CV_020_2_pim := by
  rw [CV_2_c_000_def, Fplus_dW_c_020_def, ofLadj_mul, CV_020_2_pre_eq, CV_020_2_pim_eq]

theorem CV_020_3_mul : CV_3_c_010 = ofLadj CV_3_re_010 CV_3_im_010 := CV_3_c_010_def

@[expose] public def CV_coeff_020 : Ki := CV_0_c_000 * Fplus_dU_c_020 + CV_1_c_000 * Fplus_dV_c_020 + CV_2_c_000 * Fplus_dW_c_020 + CV_3_c_010

theorem CV_coeff_020_sum :
    CV_coeff_020 = ofLadj (CV_020_0_pre + CV_020_1_pre + CV_020_2_pre + CV_3_re_010) (CV_020_0_pim + CV_020_1_pim + CV_020_2_pim + CV_3_im_010) := by
  simp only [CV_coeff_020, CV_020_0_mul, CV_020_1_mul, CV_020_2_mul, CV_020_3_mul]
  simpa [add_assoc] using ofLadj_add4 CV_020_0_pre CV_020_0_pim CV_020_1_pre CV_020_1_pim CV_020_2_pre CV_020_2_pim CV_3_re_010 CV_3_im_010

def CV_020_qre : Polynomial ℚ := C ((13916212475507 / 5759971954 : ℚ)) + C ((105104605455803 / 5759971954 : ℚ)) * X + C ((325303254736343 / 17279915862 : ℚ)) * X ^ 2 + C ((134066695996777 / 5759971954 : ℚ)) * X ^ 3 + C ((234628853232967 / 8639957931 : ℚ)) * X ^ 4 + C ((170081910550225 / 17279915862 : ℚ)) * X ^ 5 + C ((47745093350431 / 5759971954 : ℚ)) * X ^ 6 + C ((31682403574125 / 5759971954 : ℚ)) * X ^ 7 + C ((-58516188533873 / 8639957931 : ℚ)) * X ^ 8
def CV_020_qim : Polynomial ℚ := C ((-93161342252461 / 8639957931 : ℚ)) + C ((-93161342252461 / 8639957931 : ℚ)) * X + C ((-703556396031 / 2879985977 : ℚ)) * X ^ 2 + C ((-8499038577632 / 8639957931 : ℚ)) * X ^ 3 + C ((128714380959302 / 8639957931 : ℚ)) * X ^ 4 + C ((368140359370039 / 17279915862 : ℚ)) * X ^ 5 + C ((114224757253525 / 8639957931 : ℚ)) * X ^ 6 + C ((53394864567041 / 2879985977 : ℚ)) * X ^ 7 + C ((182731983527821 / 17279915862 : ℚ)) * X ^ 8
theorem CV_coeff_020_poly_re :
    CV_020_0_pre + CV_020_1_pre + CV_020_2_pre + CV_3_re_010 = (0 : Polynomial ℚ) + Phi11 * CV_020_qre := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [CV_020_0_pre, CV_020_1_pre, CV_020_2_pre, CV_3_re_010_def, CV_020_qre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try grind
theorem CV_coeff_020_poly_im :
    CV_020_0_pim + CV_020_1_pim + CV_020_2_pim + CV_3_im_010 = (0 : Polynomial ℚ) + Phi11 * CV_020_qim := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [CV_020_0_pim, CV_020_1_pim, CV_020_2_pim, CV_3_im_010_def, CV_020_qim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try grind
public theorem CV_coeff_020_eq :
    CV_coeff_020 = (0 : Ki) := by
  rw [CV_coeff_020_sum, CV_coeff_020_poly_re,
    CV_coeff_020_poly_im, ofLadj_add_Phi11]
  exact ofLadj_zero

end V14Formalization.D12SigmaPlusSegreCore
