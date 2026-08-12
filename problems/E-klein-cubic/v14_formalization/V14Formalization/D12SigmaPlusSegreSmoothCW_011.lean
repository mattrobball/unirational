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

def CW_011_0_pre : Polynomial ℚ := C ((4173517992179 / 8639957931 : ℚ)) + C ((62693770046300 / 8639957931 : ℚ)) * X + C ((126904485566572 / 8639957931 : ℚ)) * X ^ 2 + C ((210172095176315 / 8639957931 : ℚ)) * X ^ 3 + C ((313108948975648 / 8639957931 : ℚ)) * X ^ 4 + C ((33720555257533 / 785450721 : ℚ)) * X ^ 5 + C ((419844629020409 / 8639957931 : ℚ)) * X ^ 6 + C ((148309645940636 / 2879985977 : ℚ)) * X ^ 7 + C ((423514941236660 / 8639957931 : ℚ)) * X ^ 8 + C ((415496083166293 / 8639957931 : ℚ)) * X ^ 9 + C ((136453094270659 / 2879985977 : ℚ)) * X ^ 10 + C ((402822675853925 / 8639957931 : ℚ)) * X ^ 11 + C ((346665512765677 / 8639957931 : ℚ)) * X ^ 12 + C ((96197199199907 / 2879985977 : ℚ)) * X ^ 13 + C ((71114282020115 / 2879985977 : ℚ)) * X ^ 14 + C ((117777388157269 / 8639957931 : ℚ)) * X ^ 15 + C ((64435286205883 / 8639957931 : ℚ)) * X ^ 16 + C ((1410615001667 / 785450721 : ℚ)) * X ^ 17 + C ((-14042600688991 / 8639957931 : ℚ)) * X ^ 18
def CW_011_0_pim : Polynomial ℚ := C ((-14135965748065 / 2879985977 : ℚ)) + C ((-28271931496130 / 2879985977 : ℚ)) * X + C ((-100591745273060 / 8639957931 : ℚ)) * X ^ 2 + C ((-39851071183845 / 2879985977 : ℚ)) * X ^ 3 + C ((-8055144269300 / 785450721 : ℚ)) * X ^ 4 + C ((-31639968065050 / 8639957931 : ℚ)) * X ^ 5 + C ((15073976038078 / 8639957931 : ℚ)) * X ^ 6 + C ((28133107534919 / 2879985977 : ℚ)) * X ^ 7 + C ((41000965318103 / 2879985977 : ℚ)) * X ^ 8 + C ((121836825378143 / 8639957931 : ℚ)) * X ^ 9 + C ((38856178540506 / 2879985977 : ℚ)) * X ^ 10 + C ((50380435284485 / 2879985977 : ℚ)) * X ^ 11 + C ((61904692028464 / 2879985977 : ℚ)) * X ^ 12 + C ((65407245704479 / 2879985977 : ℚ)) * X ^ 13 + C ((71339044938582 / 2879985977 : ℚ)) * X ^ 14 + C ((186419725537780 / 8639957931 : ℚ)) * X ^ 15 + C ((136253325794909 / 8639957931 : ℚ)) * X ^ 16 + C ((8889043950053 / 785450721 : ℚ)) * X ^ 17 + C ((11751452012761 / 2879985977 : ℚ)) * X ^ 18
theorem CW_011_0_pre_eq :
    CW_0_re_000 * Fplus_dU_re_011 - CW_0_im_000 * Fplus_dU_im_011 = CW_011_0_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_0_re_000, CW_0_im_000, Fplus_dU_re_011, Fplus_dU_im_011, CW_011_0_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CW_011_0_pim_eq :
    CW_0_re_000 * Fplus_dU_im_011 + CW_0_im_000 * Fplus_dU_re_011 = CW_011_0_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_0_re_000, CW_0_im_000, Fplus_dU_re_011, Fplus_dU_im_011, CW_011_0_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CW_011_0_mul :
    CW_0_c_000 * Fplus_dU_c_011 = ofLadj CW_011_0_pre CW_011_0_pim := by
  rw [CW_0_c_000, Fplus_dU_c_011, ofLadj_mul, CW_011_0_pre_eq, CW_011_0_pim_eq]

def CW_011_1_pre : Polynomial ℚ := C ((-6773039452682 / 8639957931 : ℚ)) + C ((-121659329137640 / 8639957931 : ℚ)) * X + C ((-239768581441736 / 8639957931 : ℚ)) * X ^ 2 + C ((-392906653983064 / 8639957931 : ℚ)) * X ^ 3 + C ((-587857879966121 / 8639957931 : ℚ)) * X ^ 4 + C ((-698088019895540 / 8639957931 : ℚ)) * X ^ 5 + C ((-791572453405688 / 8639957931 : ℚ)) * X ^ 6 + C ((-281850708921865 / 2879985977 : ℚ)) * X ^ 7 + C ((-806187861215062 / 8639957931 : ℚ)) * X ^ 8 + C ((-265612164566413 / 2879985977 : ℚ)) * X ^ 9 + C ((-23943990737737 / 261816907 : ℚ)) * X ^ 10 + C ((-260158261114568 / 2879985977 : ℚ)) * X ^ 11 + C ((-668492365207681 / 8639957931 : ℚ)) * X ^ 12 + C ((-557067912257503 / 8639957931 : ℚ)) * X ^ 13 + C ((-137760402410666 / 2879985977 : ℚ)) * X ^ 14 + C ((-75514669655327 / 2879985977 : ℚ)) * X ^ 15 + C ((-11036116535668 / 785450721 : ℚ)) * X ^ 16 + C ((-27912848382200 / 8639957931 : ℚ)) * X ^ 17 + C ((31150237833493 / 8639957931 : ℚ)) * X ^ 18
def CW_011_1_pim : Polynomial ℚ := C ((83599448562598 / 8639957931 : ℚ)) + C ((167198897125196 / 8639957931 : ℚ)) * X + C ((193532992952051 / 8639957931 : ℚ)) * X ^ 2 + C ((235643923017955 / 8639957931 : ℚ)) * X ^ 3 + C ((179671489570603 / 8639957931 : ℚ)) * X ^ 4 + C ((71274783782756 / 8639957931 : ℚ)) * X ^ 5 + C ((-5696355743668 / 2879985977 : ℚ)) * X ^ 6 + C ((-150576750126439 / 8639957931 : ℚ)) * X ^ 7 + C ((-76118254743771 / 2879985977 : ℚ)) * X ^ 8 + C ((-226788546481231 / 8639957931 : ℚ)) * X ^ 9 + C ((-220778391585616 / 8639957931 : ℚ)) * X ^ 10 + C ((-295569085352698 / 8639957931 : ℚ)) * X ^ 11 + C ((-370359779119780 / 8639957931 : ℚ)) * X ^ 12 + C ((-35516701822820 / 785450721 : ℚ)) * X ^ 13 + C ((-39202584760622 / 785450721 : ℚ)) * X ^ 14 + C ((-379460081982892 / 8639957931 : ℚ)) * X ^ 15 + C ((-278539335633842 / 8639957931 : ℚ)) * X ^ 16 + C ((-66528551499370 / 2879985977 : ℚ)) * X ^ 17 + C ((-73573931041472 / 8639957931 : ℚ)) * X ^ 18
theorem CW_011_1_pre_eq :
    CW_1_re_000 * Fplus_dV_re_011 - CW_1_im_000 * Fplus_dV_im_011 = CW_011_1_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_1_re_000, CW_1_im_000, Fplus_dV_re_011, Fplus_dV_im_011, CW_011_1_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CW_011_1_pim_eq :
    CW_1_re_000 * Fplus_dV_im_011 + CW_1_im_000 * Fplus_dV_re_011 = CW_011_1_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_1_re_000, CW_1_im_000, Fplus_dV_re_011, Fplus_dV_im_011, CW_011_1_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CW_011_1_mul :
    CW_1_c_000 * Fplus_dV_c_011 = ofLadj CW_011_1_pre CW_011_1_pim := by
  rw [CW_1_c_000, Fplus_dV_c_011, ofLadj_mul, CW_011_1_pre_eq, CW_011_1_pim_eq]

def CW_011_2_pre : Polynomial ℚ := C ((-107316825614 / 8639957931 : ℚ)) + C ((4295397661640 / 8639957931 : ℚ)) * X + C ((3040531156706 / 2879985977 : ℚ)) * X ^ 2 + C ((15886185164186 / 8639957931 : ℚ)) * X ^ 3 + C ((25100350439150 / 8639957931 : ℚ)) * X ^ 4 + C ((32272094548454 / 8639957931 : ℚ)) * X ^ 5 + C ((12745394921289 / 2879985977 : ℚ)) * X ^ 6 + C ((40000729903697 / 8639957931 : ℚ)) * X ^ 7 + C ((36068281433396 / 8639957931 : ℚ)) * X ^ 8 + C ((33231826103884 / 8639957931 : ℚ)) * X ^ 9 + C ((31264719347116 / 8639957931 : ℚ)) * X ^ 10 + C ((10232976975842 / 2879985977 : ℚ)) * X ^ 11 + C ((26969321685476 / 8639957931 : ℚ)) * X ^ 12 + C ((24110232633766 / 8639957931 : ℚ)) * X ^ 13 + C ((6727365423070 / 2879985977 : ℚ)) * X ^ 14 + C ((1226432661425 / 785450721 : ℚ)) * X ^ 15 + C ((2558873895348 / 2879985977 : ℚ)) * X ^ 16 + C ((1712531470631 / 8639957931 : ℚ)) * X ^ 17 + C ((-1409620188872 / 8639957931 : ℚ)) * X ^ 18
def CW_011_2_pim : Polynomial ℚ := C ((-1530229740632 / 2879985977 : ℚ)) + C ((-3060459481264 / 2879985977 : ℚ)) * X + C ((-3841353140610 / 2879985977 : ℚ)) * X ^ 2 + C ((-1325348513155 / 785450721 : ℚ)) * X ^ 3 + C ((-4690493947749 / 2879985977 : ℚ)) * X ^ 4 + C ((-3356106278020 / 2879985977 : ℚ)) * X ^ 5 + C ((-4301558975822 / 8639957931 : ℚ)) * X ^ 6 + C ((3873065494853 / 8639957931 : ℚ)) * X ^ 7 + C ((8315834112098 / 8639957931 : ℚ)) * X ^ 8 + C ((2624096710850 / 2879985977 : ℚ)) * X ^ 9 + C ((2005685351104 / 2879985977 : ℚ)) * X ^ 10 + C ((2682388195022 / 2879985977 : ℚ)) * X ^ 11 + C ((3359091038940 / 2879985977 : ℚ)) * X ^ 12 + C ((3521573338540 / 2879985977 : ℚ)) * X ^ 13 + C ((4391983419649 / 2879985977 : ℚ)) * X ^ 14 + C ((1262669736010 / 785450721 : ℚ)) * X ^ 15 + C ((4063233845039 / 2879985977 : ℚ)) * X ^ 16 + C ((9093127001105 / 8639957931 : ℚ)) * X ^ 17 + C ((3221999978624 / 8639957931 : ℚ)) * X ^ 18
theorem CW_011_2_pre_eq :
    CW_2_re_000 * Fplus_dW_re_011 - CW_2_im_000 * Fplus_dW_im_011 = CW_011_2_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_2_re_000, CW_2_im_000, Fplus_dW_re_011, Fplus_dW_im_011, CW_011_2_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CW_011_2_pim_eq :
    CW_2_re_000 * Fplus_dW_im_011 + CW_2_im_000 * Fplus_dW_re_011 = CW_011_2_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_2_re_000, CW_2_im_000, Fplus_dW_re_011, Fplus_dW_im_011, CW_011_2_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CW_011_2_mul :
    CW_2_c_000 * Fplus_dW_c_011 = ofLadj CW_011_2_pre CW_011_2_pim := by
  rw [CW_2_c_000, Fplus_dW_c_011, ofLadj_mul, CW_011_2_pre_eq, CW_011_2_pim_eq]

def CW_011_3_pre : Polynomial ℚ := C ((12029332922 / 785450721 : ℚ)) + C ((-129009796106 / 785450721 : ℚ)) * X ^ 2 + C ((-265732149202 / 785450721 : ℚ)) * X ^ 3 + C ((-418477281988 / 785450721 : ℚ)) * X ^ 4 + C ((-162196990048 / 261816907 : ℚ)) * X ^ 5 + C ((-162196990048 / 261816907 : ℚ)) * X ^ 6 + C ((-418477281988 / 785450721 : ℚ)) * X ^ 7 + C ((-265732149202 / 785450721 : ℚ)) * X ^ 8 + C ((-129009796106 / 785450721 : ℚ)) * X ^ 9
def CW_011_3_pim : Polynomial ℚ := C ((1586952906884 / 8639957931 : ℚ)) + C ((3173905813768 / 8639957931 : ℚ)) * X + C ((1429091584672 / 2879985977 : ℚ)) * X ^ 2 + C ((4330671559648 / 8639957931 : ℚ)) * X ^ 3 + C ((1321589557720 / 2879985977 : ℚ)) * X ^ 4 + C ((2337011509384 / 8639957931 : ℚ)) * X ^ 5 + C ((278964768128 / 2879985977 : ℚ)) * X ^ 6 + C ((-790862859392 / 8639957931 : ℚ)) * X ^ 7 + C ((-385588581960 / 2879985977 : ℚ)) * X ^ 8 + C ((-1113368940248 / 8639957931 : ℚ)) * X ^ 9
theorem CW_011_3_neg_re : -CW_3_re_011 = CW_011_3_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_3_re_011, CW_011_3_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CW_011_3_neg_im : -CW_3_im_011 = CW_011_3_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_3_im_011, CW_011_3_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CW_011_3_mul : -CW_3_c_011 = ofLadj CW_011_3_pre CW_011_3_pim := by
  rw [CW_3_c_011, ofLadj_neg, CW_011_3_neg_re, CW_011_3_neg_im]

def CW_coeff_011 : Ki := CW_0_c_000 * Fplus_dU_c_011 + CW_1_c_000 * Fplus_dV_c_011 + CW_2_c_000 * Fplus_dW_c_011 + (-CW_3_c_011)

theorem CW_coeff_011_sum :
    CW_coeff_011 = ofLadj (CW_011_0_pre + CW_011_1_pre + CW_011_2_pre + CW_011_3_pre) (CW_011_0_pim + CW_011_1_pim + CW_011_2_pim + CW_011_3_pim) := by
  simp only [CW_coeff_011, CW_011_0_mul, CW_011_1_mul, CW_011_2_mul, CW_011_3_mul]
  simpa [add_assoc] using ofLadj_add4 CW_011_0_pre CW_011_0_pim CW_011_1_pre CW_011_1_pim CW_011_2_pre CW_011_2_pim CW_011_3_pre CW_011_3_pim

def CW_011_qre : Polynomial ℚ := C ((-2574515623975 / 8639957931 : ℚ)) + C ((-17365215268575 / 2879985977 : ℚ)) * X + C ((-50491448732512 / 8639957931 : ℚ)) * X ^ 2 + C ((-21536605707191 / 2879985977 : ℚ)) * X ^ 3 + C ((-7680036669946 / 785450721 : ℚ)) * X ^ 4 + C ((-1393651137352 / 261816907 : ℚ)) * X ^ 5 + C ((-3509256555199 / 785450721 : ℚ)) * X ^ 6 + C ((-8793856282954 / 2879985977 : ℚ)) * X ^ 7 + C ((15698016955630 / 8639957931 : ℚ)) * X ^ 8
def CW_011_qim : Polynomial ℚ := C ((12729271667797 / 2879985977 : ℚ)) + C ((12729271667797 / 2879985977 : ℚ)) * X + C ((3109611001465 / 2879985977 : ℚ)) * X ^ 2 + C ((6712694790062 / 2879985977 : ℚ)) * X ^ 3 + C ((-8294785981049 / 2879985977 : ℚ)) * X ^ 4 + C ((-49054681045186 / 8639957931 : ℚ)) * X ^ 5 + C ((-1132826189618 / 261816907 : ℚ)) * X ^ 6 + C ((-19205156340619 / 2879985977 : ℚ)) * X ^ 7 + C ((-11699191674855 / 2879985977 : ℚ)) * X ^ 8
theorem CW_coeff_011_poly_re :
    CW_011_0_pre + CW_011_1_pre + CW_011_2_pre + CW_011_3_pre = (0 : Polynomial ℚ) + Phi11 * CW_011_qre := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [CW_011_0_pre, CW_011_1_pre, CW_011_2_pre, CW_011_3_pre, CW_011_qre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try ring
theorem CW_coeff_011_poly_im :
    CW_011_0_pim + CW_011_1_pim + CW_011_2_pim + CW_011_3_pim = (0 : Polynomial ℚ) + Phi11 * CW_011_qim := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [CW_011_0_pim, CW_011_1_pim, CW_011_2_pim, CW_011_3_pim, CW_011_qim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try ring
theorem CW_coeff_011_eq :
    CW_coeff_011 = (0 : Ki) := by
  rw [CW_coeff_011_sum, CW_coeff_011_poly_re,
    CW_coeff_011_poly_im, ofLadj_add_Phi11]
  exact ofLadj_zero

end V14Formalization.D12SigmaPlusSegreCore
