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

def CW_310_0_pre : Polynomial ℚ := C ((-279428365281 / 2879985977 : ℚ)) + C ((-69187754753 / 2879985977 : ℚ)) * X ^ 2 + C ((1278239917403 / 11519943908 : ℚ)) * X ^ 3 + C ((4722622427011 / 11519943908 : ℚ)) * X ^ 4 + C ((7905818987911 / 11519943908 : ℚ)) * X ^ 5 + C ((12039473617001 / 11519943908 : ℚ)) * X ^ 6 + C ((3686550461301 / 2879985977 : ℚ)) * X ^ 7 + C ((15721897955757 / 11519943908 : ℚ)) * X ^ 8 + C ((16112973032111 / 11519943908 : ℚ)) * X ^ 9 + C ((8266200369689 / 5759971954 : ℚ)) * X ^ 10 + C ((8831501369329 / 5759971954 : ℚ)) * X ^ 11 + C ((8266200369689 / 5759971954 : ℚ)) * X ^ 12 + C ((16389724051123 / 11519943908 : ℚ)) * X ^ 13 + C ((7221829019177 / 5759971954 : ℚ)) * X ^ 14 + C ((10399090454935 / 11519943908 : ℚ)) * X ^ 15 + C ((319011961361 / 523633814 : ℚ)) * X ^ 16 + C ((721152130213 / 2879985977 : ℚ)) * X ^ 17 + C ((187755518371 / 5759971954 : ℚ)) * X ^ 18
def CW_310_0_pim : Polynomial ℚ := C ((-1185073096257 / 5759971954 : ℚ)) + C ((-1185073096257 / 2879985977 : ℚ)) * X + C ((-3669082810627 / 5759971954 : ℚ)) * X ^ 2 + C ((-11856003837577 / 11519943908 : ℚ)) * X ^ 3 + C ((-13650063350735 / 11519943908 : ℚ)) * X ^ 4 + C ((-15372776656775 / 11519943908 : ℚ)) * X ^ 5 + C ((-15504345683945 / 11519943908 : ℚ)) * X ^ 6 + C ((-6580093447623 / 5759971954 : ℚ)) * X ^ 7 + C ((-11866985454755 / 11519943908 : ℚ)) * X ^ 8 + C ((-11888781531755 / 11519943908 : ℚ)) * X ^ 9 + C ((-5739767777859 / 5759971954 : ℚ)) * X ^ 10 + C ((-395024365419 / 523633814 : ℚ)) * X ^ 11 + C ((-2950768261359 / 5759971954 : ℚ)) * X ^ 12 + C ((-263128846405 / 1047267628 : ℚ)) * X ^ 13 + C ((400406207217 / 2879985977 : ℚ)) * X ^ 14 + C ((3342507823931 / 11519943908 : ℚ)) * X ^ 15 + C ((2274006019137 / 5759971954 : ℚ)) * X ^ 16 + C ((2103872919491 / 5759971954 : ℚ)) * X ^ 17 + C ((673188979293 / 5759971954 : ℚ)) * X ^ 18
theorem CW_310_0_pre_eq :
    CW_0_re_110 * Fplus_dU_re_200 - CW_0_im_110 * Fplus_dU_im_200 = CW_310_0_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_0_re_110, CW_0_im_110, Fplus_dU_re_200, Fplus_dU_im_200, CW_310_0_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CW_310_0_pim_eq :
    CW_0_re_110 * Fplus_dU_im_200 + CW_0_im_110 * Fplus_dU_re_200 = CW_310_0_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_0_re_110, CW_0_im_110, Fplus_dU_re_200, Fplus_dU_im_200, CW_310_0_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CW_310_0_mul :
    CW_0_c_110 * Fplus_dU_c_200 = ofLadj CW_310_0_pre CW_310_0_pim := by
  rw [CW_0_c_110, Fplus_dU_c_200, ofLadj_mul, CW_310_0_pre_eq, CW_310_0_pim_eq]

def CW_310_1_pre : Polynomial ℚ := C ((-235576365331 / 11519943908 : ℚ)) + C ((254607239874 / 2879985977 : ℚ)) * X + C ((1733253868289 / 11519943908 : ℚ)) * X ^ 2 + C ((756105886078 / 2879985977 : ℚ)) * X ^ 3 + C ((5408802551891 / 11519943908 : ℚ)) * X ^ 4 + C ((4945286053556 / 8639957931 : ℚ)) * X ^ 5 + C ((12554293798919 / 17279915862 : ℚ)) * X ^ 6 + C ((6620105750396 / 8639957931 : ℚ)) * X ^ 7 + C ((2192882358805 / 3141802884 : ℚ)) * X ^ 8 + C ((5798368924153 / 8639957931 : ℚ)) * X ^ 9 + C ((5440430222212 / 8639957931 : ℚ)) * X ^ 10 + C ((11350865082805 / 17279915862 : ℚ)) * X ^ 11 + C ((4676608502590 / 8639957931 : ℚ)) * X ^ 12 + C ((17993714091745 / 34559831724 : ℚ)) * X ^ 13 + C ((15048435313919 / 34559831724 : ℚ)) * X ^ 14 + C ((9522121153751 / 34559831724 : ℚ)) * X ^ 15 + C ((3298211310835 / 17279915862 : ℚ)) * X ^ 16 + C ((105748269838 / 2879985977 : ℚ)) * X ^ 17 + C ((-60991182680 / 2879985977 : ℚ)) * X ^ 18
def CW_310_1_pim : Polynomial ℚ := C ((-93743436199 / 1047267628 : ℚ)) + C ((-93743436199 / 523633814 : ℚ)) * X + C ((-7257502112143 / 34559831724 : ℚ)) * X ^ 2 + C ((-2780662024088 / 8639957931 : ℚ)) * X ^ 3 + C ((-10338872979319 / 34559831724 : ℚ)) * X ^ 4 + C ((-1359392122811 / 5759971954 : ℚ)) * X ^ 5 + C ((-474095459127 / 2879985977 : ℚ)) * X ^ 6 + C ((155883131127 / 5759971954 : ℚ)) * X ^ 7 + C ((995635969795 / 11519943908 : ℚ)) * X ^ 8 + C ((769941863186 / 8639957931 : ℚ)) * X ^ 9 + C ((971434687543 / 17279915862 : ℚ)) * X ^ 10 + C ((1939354724873 / 17279915862 : ℚ)) * X ^ 11 + C ((969091587401 / 5759971954 : ℚ)) * X ^ 12 + C ((5748086769757 / 34559831724 : ℚ)) * X ^ 13 + C ((9706092297325 / 34559831724 : ℚ)) * X ^ 14 + C ((2983829212735 / 11519943908 : ℚ)) * X ^ 15 + C ((4242442087415 / 17279915862 : ℚ)) * X ^ 16 + C ((3465483090959 / 17279915862 : ℚ)) * X ^ 17 + C ((337073110785 / 5759971954 : ℚ)) * X ^ 18
theorem CW_310_1_pre_eq :
    CW_1_re_110 * Fplus_dV_re_200 - CW_1_im_110 * Fplus_dV_im_200 = CW_310_1_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_1_re_110, CW_1_im_110, Fplus_dV_re_200, Fplus_dV_im_200, CW_310_1_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CW_310_1_pim_eq :
    CW_1_re_110 * Fplus_dV_im_200 + CW_1_im_110 * Fplus_dV_re_200 = CW_310_1_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_1_re_110, CW_1_im_110, Fplus_dV_re_200, Fplus_dV_im_200, CW_310_1_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CW_310_1_mul :
    CW_1_c_110 * Fplus_dV_c_200 = ofLadj CW_310_1_pre CW_310_1_pim := by
  rw [CW_1_c_110, Fplus_dV_c_200, ofLadj_mul, CW_310_1_pre_eq, CW_310_1_pim_eq]

def CW_310_2_pre : Polynomial ℚ := C ((1782889918 / 32359393 : ℚ)) + C ((1272858976 / 32359393 : ℚ)) * X + C ((12126103411 / 97078179 : ℚ)) * X ^ 2 + C ((5743736833 / 32359393 : ℚ)) * X ^ 3 + C ((18059083165 / 97078179 : ℚ)) * X ^ 4 + C ((21212514425 / 64718786 : ℚ)) * X ^ 5 + C ((47023269187 / 194156358 : ℚ)) * X ^ 6 + C ((124959588827 / 388312716 : ℚ)) * X ^ 7 + C ((38414823993 / 129437572 : ℚ)) * X ^ 8 + C ((28122929852 / 97078179 : ℚ)) * X ^ 9 + C ((114440839475 / 388312716 : ℚ)) * X ^ 10 + C ((14998431621 / 64718786 : ℚ)) * X ^ 11 + C ((99166531763 / 388312716 : ℚ)) * X ^ 12 + C ((15996826441 / 97078179 : ℚ)) * X ^ 13 + C ((1403625151 / 11767052 : ℚ)) * X ^ 14 + C ((4087289845 / 35301156 : ℚ)) * X ^ 15 + C ((-476577187 / 17650578 : ℚ)) * X ^ 16 + C ((3790641677 / 64718786 : ℚ)) * X ^ 17 + C ((-1940766968 / 97078179 : ℚ)) * X ^ 18
def CW_310_2_pim : Polynomial ℚ := C ((499128000 / 32359393 : ℚ)) + C ((998256000 / 32359393 : ℚ)) * X + C ((-2520845783 / 97078179 : ℚ)) * X ^ 2 + C ((19498684241 / 194156358 : ℚ)) * X ^ 3 + C ((3182159330 / 97078179 : ℚ)) * X ^ 4 + C ((1256145131 / 8825289 : ℚ)) * X ^ 5 + C ((20809283285 / 97078179 : ℚ)) * X ^ 6 + C ((27432995497 / 129437572 : ℚ)) * X ^ 7 + C ((113139628759 / 388312716 : ℚ)) * X ^ 8 + C ((9402580194 / 32359393 : ℚ)) * X ^ 9 + C ((37270096617 / 129437572 : ℚ)) * X ^ 10 + C ((26177473148 / 97078179 : ℚ)) * X ^ 11 + C ((97609495333 / 388312716 : ℚ)) * X ^ 12 + C ((9887606499 / 32359393 : ℚ)) * X ^ 13 + C ((69261859943 / 388312716 : ℚ)) * X ^ 14 + C ((96995300053 / 388312716 : ℚ)) * X ^ 15 + C ((26303801063 / 194156358 : ℚ)) * X ^ 16 + C ((5047289359 / 64718786 : ℚ)) * X ^ 17 + C ((7343983330 / 97078179 : ℚ)) * X ^ 18
theorem CW_310_2_pre_eq :
    CW_2_re_110 * Fplus_dW_re_200 - CW_2_im_110 * Fplus_dW_im_200 = CW_310_2_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_2_re_110, CW_2_im_110, Fplus_dW_re_200, Fplus_dW_im_200, CW_310_2_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CW_310_2_pim_eq :
    CW_2_re_110 * Fplus_dW_im_200 + CW_2_im_110 * Fplus_dW_re_200 = CW_310_2_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_2_re_110, CW_2_im_110, Fplus_dW_re_200, Fplus_dW_im_200, CW_310_2_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CW_310_2_mul :
    CW_2_c_110 * Fplus_dW_c_200 = ofLadj CW_310_2_pre CW_310_2_pim := by
  rw [CW_2_c_110, Fplus_dW_c_200, ofLadj_mul, CW_310_2_pre_eq, CW_310_2_pim_eq]

def CW_coeff_310 : Ki := CW_0_c_110 * Fplus_dU_c_200 + CW_1_c_110 * Fplus_dV_c_200 + CW_2_c_110 * Fplus_dW_c_200

theorem CW_coeff_310_sum :
    CW_coeff_310 = ofLadj (CW_310_0_pre + CW_310_1_pre + CW_310_2_pre) (CW_310_0_pim + CW_310_1_pim + CW_310_2_pim) := by
  simp only [CW_coeff_310, CW_310_0_mul, CW_310_1_mul, CW_310_2_mul]
  simpa [add_assoc] using ofLadj_add3 CW_310_0_pre CW_310_0_pim CW_310_1_pre CW_310_1_pim CW_310_2_pre CW_310_2_pim

def CW_310_qre : Polynomial ℚ := C ((-65325546877 / 1047267628 : ℚ)) + C ((2190147770599 / 11519943908 : ℚ)) * X + C ((4271701097291 / 34559831724 : ℚ)) * X ^ 2 + C ((5177949980321 / 17279915862 : ℚ)) * X ^ 3 + C ((17781007220657 / 34559831724 : ℚ)) * X ^ 4 + C ((6000925112487 / 11519943908 : ℚ)) * X ^ 5 + C ((1230922206935 / 2879985977 : ℚ)) * X ^ 6 + C ((3060820394668 / 8639957931 : ℚ)) * X ^ 7 + C ((-148137061271 / 17279915862 : ℚ)) * X ^ 8
def CW_310_qim : Polynomial ℚ := C ((-3223634422703 / 11519943908 : ℚ)) + C ((-3223634422703 / 11519943908 : ℚ)) * X + C ((-10827613538435 / 34559831724 : ℚ)) * X ^ 2 + C ((-3262618434883 / 8639957931 : ℚ)) * X ^ 3 + C ((-2312106831953 / 11519943908 : ℚ)) * X ^ 4 + C ((800595935849 / 34559831724 : ℚ)) * X ^ 5 + C ((1140385165574 / 8639957931 : ℚ)) * X ^ 6 + C ((6786712805311 / 17279915862 : ℚ)) * X ^ 7 + C ((2169007651487 / 8639957931 : ℚ)) * X ^ 8
theorem CW_coeff_310_poly_re :
    CW_310_0_pre + CW_310_1_pre + CW_310_2_pre = (0 : Polynomial ℚ) + Phi11 * CW_310_qre := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [CW_310_0_pre, CW_310_1_pre, CW_310_2_pre, CW_310_qre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try ring
theorem CW_coeff_310_poly_im :
    CW_310_0_pim + CW_310_1_pim + CW_310_2_pim = (0 : Polynomial ℚ) + Phi11 * CW_310_qim := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [CW_310_0_pim, CW_310_1_pim, CW_310_2_pim, CW_310_qim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try ring
theorem CW_coeff_310_eq :
    CW_coeff_310 = (0 : Ki) := by
  rw [CW_coeff_310_sum, CW_coeff_310_poly_re,
    CW_coeff_310_poly_im, ofLadj_add_Phi11]
  exact ofLadj_zero

end V14Formalization.D12SigmaPlusSegreCore
