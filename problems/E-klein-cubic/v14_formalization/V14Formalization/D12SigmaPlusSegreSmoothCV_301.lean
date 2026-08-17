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

def CV_301_0_pre : Polynomial ℚ := C ((-254621949342 / 2879985977 : ℚ)) + C ((-101889507727 / 5759971954 : ℚ)) * X ^ 2 + C ((486203002821 / 5759971954 : ℚ)) * X ^ 3 + C ((932779791935 / 2879985977 : ℚ)) * X ^ 4 + C ((3217908621563 / 5759971954 : ℚ)) * X ^ 5 + C ((2384175180613 / 2879985977 : ℚ)) * X ^ 6 + C ((11754123360911 / 11519943908 : ℚ)) * X ^ 7 + C ((12654510257927 / 11519943908 : ℚ)) * X ^ 8 + C ((1144084853995 / 1047267628 : ℚ)) * X ^ 9 + C ((3369629346769 / 2879985977 : ℚ)) * X ^ 10 + C ((637042886285 / 523633814 : ℚ)) * X ^ 11 + C ((3369629346769 / 2879985977 : ℚ)) * X ^ 12 + C ((12788712409399 / 11519943908 : ℚ)) * X ^ 13 + C ((11682104252285 / 11519943908 : ℚ)) * X ^ 14 + C ((8253795764549 / 11519943908 : ℚ)) * X ^ 15 + C ((2768020561681 / 5759971954 : ℚ)) * X ^ 16 + C ((608789411009 / 2879985977 : ℚ)) * X ^ 17 + C ((115395785689 / 5759971954 : ℚ)) * X ^ 18
def CV_301_0_pim : Polynomial ℚ := C ((-458398208496 / 2879985977 : ℚ)) + C ((-916796416992 / 2879985977 : ℚ)) * X + C ((-3015265582803 / 5759971954 : ℚ)) * X ^ 2 + C ((-4419416010857 / 5759971954 : ℚ)) * X ^ 3 + C ((-5687900424385 / 5759971954 : ℚ)) * X ^ 4 + C ((-2902512828626 / 2879985977 : ℚ)) * X ^ 5 + C ((-6250256451171 / 5759971954 : ℚ)) * X ^ 6 + C ((-919530379611 / 1047267628 : ℚ)) * X ^ 7 + C ((-862311667115 / 1047267628 : ℚ)) * X ^ 8 + C ((-9043511970553 / 11519943908 : ℚ)) * X ^ 9 + C ((-2263430082652 / 2879985977 : ℚ)) * X ^ 10 + C ((-152799402832 / 261816907 : ℚ)) * X ^ 11 + C ((-1098156779652 / 2879985977 : ℚ)) * X ^ 12 + C ((-2039489981025 / 11519943908 : ℚ)) * X ^ 13 + C ((1210727242795 / 11519943908 : ℚ)) * X ^ 14 + C ((275272813523 / 1047267628 : ℚ)) * X ^ 15 + C ((888367749351 / 2879985977 : ℚ)) * X ^ 16 + C ((1721780051129 / 5759971954 : ℚ)) * X ^ 17 + C ((674550479277 / 5759971954 : ℚ)) * X ^ 18
theorem CV_301_0_pre_eq :
    CV_0_re_101 * Fplus_dU_re_200 - CV_0_im_101 * Fplus_dU_im_200 = CV_301_0_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_0_re_101, CV_0_im_101, Fplus_dU_re_200, Fplus_dU_im_200, CV_301_0_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CV_301_0_pim_eq :
    CV_0_re_101 * Fplus_dU_im_200 + CV_0_im_101 * Fplus_dU_re_200 = CV_301_0_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_0_re_101, CV_0_im_101, Fplus_dU_re_200, Fplus_dU_im_200, CV_301_0_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CV_301_0_mul :
    CV_0_c_101 * Fplus_dU_c_200 = ofLadj CV_301_0_pre CV_301_0_pim := by
  rw [CV_0_c_101, Fplus_dU_c_200, ofLadj_mul, CV_301_0_pre_eq, CV_301_0_pim_eq]

def CV_301_1_pre : Polynomial ℚ := C ((8269404029 / 129437572 : ℚ)) + C ((-6771299890 / 8825289 : ℚ)) * X + C ((-47628747588 / 32359393 : ℚ)) * X ^ 2 + C ((-238693344926 / 97078179 : ℚ)) * X ^ 3 + C ((-1630689400751 / 388312716 : ℚ)) * X ^ 4 + C ((-520878875170 / 97078179 : ℚ)) * X ^ 5 + C ((-210494598532 / 32359393 : ℚ)) * X ^ 6 + C ((-225706038345 / 32359393 : ℚ)) * X ^ 7 + C ((-2513030135543 / 388312716 : ℚ)) * X ^ 8 + C ((-393650273441 / 64718786 : ℚ)) * X ^ 9 + C ((-2277332840905 / 388312716 : ℚ)) * X ^ 10 + C ((-373974631219 / 64718786 : ℚ)) * X ^ 11 + C ((-1979395645745 / 388312716 : ℚ)) * X ^ 12 + C ((-298392778265 / 64718786 : ℚ)) * X ^ 13 + C ((-519418918613 / 129437572 : ℚ)) * X ^ 14 + C ((-249260440903 / 97078179 : ℚ)) * X ^ 15 + C ((-312507392291 / 194156358 : ℚ)) * X ^ 16 + C ((-91297551439 / 194156358 : ℚ)) * X ^ 17 + C ((26913765259 / 129437572 : ℚ)) * X ^ 18
def CV_301_1_pim : Polynomial ℚ := C ((289064334587 / 388312716 : ℚ)) + C ((289064334587 / 194156358 : ℚ)) * X + C ((61601134396 / 32359393 : ℚ)) * X ^ 2 + C ((508786931381 / 194156358 : ℚ)) * X ^ 3 + C ((1037243767309 / 388312716 : ℚ)) * X ^ 4 + C ((372914751091 / 194156358 : ℚ)) * X ^ 5 + C ((240857990471 / 194156358 : ℚ)) * X ^ 6 + C ((-63579463789 / 194156358 : ℚ)) * X ^ 7 + C ((-407571374659 / 388312716 : ℚ)) * X ^ 8 + C ((-66840163637 / 64718786 : ℚ)) * X ^ 9 + C ((-302143596973 / 388312716 : ℚ)) * X ^ 10 + C ((-231537951241 / 194156358 : ℚ)) * X ^ 11 + C ((-208002735997 / 129437572 : ℚ)) * X ^ 12 + C ((-57182980560 / 32359393 : ℚ)) * X ^ 13 + C ((-319341874631 / 129437572 : ℚ)) * X ^ 14 + C ((-46199836835 / 17650578 : ℚ)) * X ^ 15 + C ((-430639585385 / 194156358 : ℚ)) * X ^ 16 + C ((-178572362036 / 97078179 : ℚ)) * X ^ 17 + C ((-80570521717 / 129437572 : ℚ)) * X ^ 18
theorem CV_301_1_pre_eq :
    CV_1_re_101 * Fplus_dV_re_200 - CV_1_im_101 * Fplus_dV_im_200 = CV_301_1_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_1_re_101, CV_1_im_101, Fplus_dV_re_200, Fplus_dV_im_200, CV_301_1_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CV_301_1_pim_eq :
    CV_1_re_101 * Fplus_dV_im_200 + CV_1_im_101 * Fplus_dV_re_200 = CV_301_1_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_1_re_101, CV_1_im_101, Fplus_dV_re_200, Fplus_dV_im_200, CV_301_1_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CV_301_1_mul :
    CV_1_c_101 * Fplus_dV_c_200 = ofLadj CV_301_1_pre CV_301_1_pim := by
  rw [CV_1_c_101, Fplus_dV_c_200, ofLadj_mul, CV_301_1_pre_eq, CV_301_1_pim_eq]

def CV_301_2_pre : Polynomial ℚ := C ((5961301446590 / 8639957931 : ℚ)) + C ((42944516416880 / 8639957931 : ℚ)) * X + C ((80923630552366 / 8639957931 : ℚ)) * X ^ 2 + C ((84842736771377 / 5759971954 : ℚ)) * X ^ 3 + C ((60395647223088 / 2879985977 : ℚ)) * X ^ 4 + C ((415157011342109 / 17279915862 : ℚ)) * X ^ 5 + C ((303131146160285 / 11519943908 : ℚ)) * X ^ 6 + C ((315320892062331 / 11519943908 : ℚ)) * X ^ 7 + C ((876305163233671 / 34559831724 : ℚ)) * X ^ 8 + C ((71921954814982 / 2879985977 : ℚ)) * X ^ 9 + C ((426428041311721 / 17279915862 : ℚ)) * X ^ 10 + C ((412634480625131 / 17279915862 : ℚ)) * X ^ 11 + C ((113513002825987 / 5759971954 : ℚ)) * X ^ 12 + C ((134842233892580 / 8639957931 : ℚ)) * X ^ 13 + C ((367248742605409 / 34559831724 : ℚ)) * X ^ 14 + C ((4962865881773 / 1047267628 : ℚ)) * X ^ 15 + C ((21812869849587 / 11519943908 : ℚ)) * X ^ 16 + C ((-3410201561969 / 8639957931 : ℚ)) * X ^ 17 + C ((-4786694617619 / 2879985977 : ℚ)) * X ^ 18
def CV_301_2_pim : Polynomial ℚ := C ((-19287412094750 / 8639957931 : ℚ)) + C ((-38574824189500 / 8639957931 : ℚ)) * X + C ((-1110097829026 / 261816907 : ℚ)) * X ^ 2 + C ((-73170795790897 / 17279915862 : ℚ)) * X ^ 3 + C ((-9937755086213 / 8639957931 : ℚ)) * X ^ 4 + C ((85826308129 / 23801537 : ℚ)) * X ^ 5 + C ((250438245942305 / 34559831724 : ℚ)) * X ^ 6 + C ((411289075911059 / 34559831724 : ℚ)) * X ^ 7 + C ((500210215287239 / 34559831724 : ℚ)) * X ^ 8 + C ((83050543536935 / 5759971954 : ℚ)) * X ^ 9 + C ((244766009525107 / 17279915862 : ℚ)) * X ^ 10 + C ((138446763881306 / 8639957931 : ℚ)) * X ^ 11 + C ((28092822363647 / 1570901442 : ℚ)) * X ^ 12 + C ((100250744417045 / 5759971954 : ℚ)) * X ^ 13 + C ((199802063529001 / 11519943908 : ℚ)) * X ^ 14 + C ((498419083205125 / 34559831724 : ℚ)) * X ^ 15 + C ((345305039980117 / 34559831724 : ℚ)) * X ^ 16 + C ((38818621494453 / 5759971954 : ℚ)) * X ^ 17 + C ((20829418880279 / 8639957931 : ℚ)) * X ^ 18
theorem CV_301_2_pre_eq :
    CV_2_re_101 * Fplus_dW_re_200 - CV_2_im_101 * Fplus_dW_im_200 = CV_301_2_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_2_re_101, CV_2_im_101, Fplus_dW_re_200, Fplus_dW_im_200, CV_301_2_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CV_301_2_pim_eq :
    CV_2_re_101 * Fplus_dW_im_200 + CV_2_im_101 * Fplus_dW_re_200 = CV_301_2_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_2_re_101, CV_2_im_101, Fplus_dW_re_200, Fplus_dW_im_200, CV_301_2_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CV_301_2_mul :
    CV_2_c_101 * Fplus_dW_c_200 = ofLadj CV_301_2_pre CV_301_2_pim := by
  rw [CV_2_c_101, Fplus_dW_c_200, ofLadj_mul, CV_301_2_pre_eq, CV_301_2_pim_eq]

@[expose] public def CV_coeff_301 : Ki := CV_0_c_101 * Fplus_dU_c_200 + CV_1_c_101 * Fplus_dV_c_200 + CV_2_c_101 * Fplus_dW_c_200

theorem CV_coeff_301_sum :
    CV_coeff_301 = ofLadj (CV_301_0_pre + CV_301_1_pre + CV_301_2_pre) (CV_301_0_pim + CV_301_1_pim + CV_301_2_pim) := by
  simp only [CV_coeff_301, CV_301_0_mul, CV_301_1_mul, CV_301_2_mul]
  simpa [add_assoc] using ofLadj_add3 CV_301_0_pre CV_301_0_pim CV_301_1_pre CV_301_1_pim CV_301_2_pre CV_301_2_pim

def CV_301_qre : Polynomial ℚ := C ((22997673269999 / 34559831724 : ℚ)) + C ((122263982028281 / 34559831724 : ℚ)) * X + C ((21159004573473 / 5759971954 : ℚ)) * X ^ 2 + C ((77391562556207 / 17279915862 : ℚ)) * X ^ 3 + C ((54603653220635 / 11519943908 : ℚ)) * X ^ 4 + C ((24459609113213 / 11519943908 : ℚ)) * X ^ 5 + C ((49006714562959 / 34559831724 : ℚ)) * X ^ 6 + C ((8991895967077 / 11519943908 : ℚ)) * X ^ 7 + C ((-16520661791047 / 11519943908 : ℚ)) * X ^ 8
def CV_301_qim : Polynomial ℚ := C ((-56923701102709 / 34559831724 : ℚ)) + C ((-56923701102709 / 34559831724 : ℚ)) * X + C ((3753226703024 / 8639957931 : ℚ)) * X ^ 2 + C ((1378373461017 / 2879985977 : ℚ)) * X ^ 3 + C ((33576762086819 / 11519943908 : ℚ)) * X ^ 4 + C ((137732198754655 / 34559831724 : ℚ)) * X ^ 5 + C ((33213652795041 / 11519943908 : ℚ)) * X ^ 6 + C ((37939333096779 / 11519943908 : ℚ)) * X ^ 7 + C ((65852649098339 / 34559831724 : ℚ)) * X ^ 8
theorem CV_coeff_301_poly_re :
    CV_301_0_pre + CV_301_1_pre + CV_301_2_pre = (0 : Polynomial ℚ) + Phi11 * CV_301_qre := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [CV_301_0_pre, CV_301_1_pre, CV_301_2_pre, CV_301_qre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try ring
theorem CV_coeff_301_poly_im :
    CV_301_0_pim + CV_301_1_pim + CV_301_2_pim = (0 : Polynomial ℚ) + Phi11 * CV_301_qim := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [CV_301_0_pim, CV_301_1_pim, CV_301_2_pim, CV_301_qim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try ring
public theorem CV_coeff_301_eq :
    CV_coeff_301 = (0 : Ki) := by
  rw [CV_coeff_301_sum, CV_coeff_301_poly_re,
    CV_coeff_301_poly_im, ofLadj_add_Phi11]
  exact ofLadj_zero

end V14Formalization.D12SigmaPlusSegreCore
