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

def CW_112_0_pre : Polynomial ℚ := C ((-195989941813 / 2879985977 : ℚ)) + C ((3686894077244 / 2879985977 : ℚ)) * X + C ((19499342687390 / 8639957931 : ℚ)) * X ^ 2 + C ((68032501433999 / 17279915862 : ℚ)) * X ^ 3 + C ((105856639114675 / 17279915862 : ℚ)) * X ^ 4 + C ((20423970378476 / 2879985977 : ℚ)) * X ^ 5 + C ((74200995635332 / 8639957931 : ℚ)) * X ^ 6 + C ((78916241742475 / 8639957931 : ℚ)) * X ^ 7 + C ((51584498760967 / 5759971954 : ℚ)) * X ^ 8 + C ((78609103611452 / 8639957931 : ℚ)) * X ^ 9 + C ((26413561434471 / 2879985977 : ℚ)) * X ^ 10 + C ((80293149445199 / 8639957931 : ℚ)) * X ^ 11 + C ((22726667357227 / 2879985977 : ℚ)) * X ^ 12 + C ((19703253641354 / 2879985977 : ℚ)) * X ^ 13 + C ((43360497424451 / 8639957931 : ℚ)) * X ^ 14 + C ((47033571821711 / 17279915862 : ℚ)) * X ^ 15 + C ((4851270147522 / 2879985977 : ℚ)) * X ^ 16 + C ((1624725942662 / 8639957931 : ℚ)) * X ^ 17 + C ((-2471136274282 / 8639957931 : ℚ)) * X ^ 18
def CW_112_0_pim : Polynomial ℚ := C ((-8414437615520 / 8639957931 : ℚ)) + C ((-16828875231040 / 8639957931 : ℚ)) * X + C ((-19130051744780 / 8639957931 : ℚ)) * X ^ 2 + C ((-54185661318517 / 17279915862 : ℚ)) * X ^ 3 + C ((-42137432678327 / 17279915862 : ℚ)) * X ^ 4 + C ((-15210053489425 / 8639957931 : ℚ)) * X ^ 5 + C ((-3071600829673 / 2879985977 : ℚ)) * X ^ 6 + C ((1192969034758 / 2879985977 : ℚ)) * X ^ 7 + C ((16322569564577 / 17279915862 : ℚ)) * X ^ 8 + C ((8444530399490 / 8639957931 : ℚ)) * X ^ 9 + C ((9111940932409 / 8639957931 : ℚ)) * X ^ 10 + C ((18575246613230 / 8639957931 : ℚ)) * X ^ 11 + C ((9346184098017 / 2879985977 : ℚ)) * X ^ 12 + C ((10335713113570 / 2879985977 : ℚ)) * X ^ 13 + C ((39253163872390 / 8639957931 : ℚ)) * X ^ 14 + C ((65247551518979 / 17279915862 : ℚ)) * X ^ 15 + C ((2364906573289 / 785450721 : ℚ)) * X ^ 16 + C ((18732501667685 / 8639957931 : ℚ)) * X ^ 17 + C ((1729217156940 / 2879985977 : ℚ)) * X ^ 18
theorem CW_112_0_pre_eq :
    CW_0_re_110 * Fplus_dU_re_002 - CW_0_im_110 * Fplus_dU_im_002 = CW_112_0_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_0_re_110, CW_0_im_110, Fplus_dU_re_002, Fplus_dU_im_002, CW_112_0_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CW_112_0_pim_eq :
    CW_0_re_110 * Fplus_dU_im_002 + CW_0_im_110 * Fplus_dU_re_002 = CW_112_0_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_0_re_110, CW_0_im_110, Fplus_dU_re_002, Fplus_dU_im_002, CW_112_0_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CW_112_0_mul :
    CW_0_c_110 * Fplus_dU_c_002 = ofLadj CW_112_0_pre CW_112_0_pim := by
  rw [CW_0_c_110, Fplus_dU_c_002, ofLadj_mul, CW_112_0_pre_eq, CW_112_0_pim_eq]

def CW_112_1_pre : Polynomial ℚ := C ((-152801297323 / 5759971954 : ℚ)) + C ((254607239874 / 2879985977 : ℚ)) * X + C ((1407676458824 / 8639957931 : ℚ)) * X ^ 2 + C ((5170020921803 / 17279915862 : ℚ)) * X ^ 3 + C ((4235007396944 / 8639957931 : ℚ)) * X ^ 4 + C ((5323404612082 / 8639957931 : ℚ)) * X ^ 5 + C ((6547732274359 / 8639957931 : ℚ)) * X ^ 6 + C ((2214242814018 / 2879985977 : ℚ)) * X ^ 7 + C ((6005833988644 / 8639957931 : ℚ)) * X ^ 8 + C ((3649835052321 / 5759971954 : ℚ)) * X ^ 9 + C ((948901160549 / 1570901442 : ℚ)) * X ^ 10 + C ((1746792126023 / 2879985977 : ℚ)) * X ^ 11 + C ((8910269326795 / 17279915862 : ℚ)) * X ^ 12 + C ((8134152239315 / 17279915862 : ℚ)) * X ^ 13 + C ((207322638045 / 523633814 : ℚ)) * X ^ 14 + C ((2169531111449 / 8639957931 : ℚ)) * X ^ 15 + C ((125069495872 / 785450721 : ℚ)) * X ^ 16 + C ((151436792315 / 8639957931 : ℚ)) * X ^ 17 + C ((-238189933661 / 8639957931 : ℚ)) * X ^ 18
def CW_112_1_pim : Polynomial ℚ := C ((-579240709063 / 5759971954 : ℚ)) + C ((-579240709063 / 2879985977 : ℚ)) * X + C ((-655985675713 / 2879985977 : ℚ)) * X ^ 2 + C ((-5647825413199 / 17279915862 : ℚ)) * X ^ 3 + C ((-2494557294545 / 8639957931 : ℚ)) * X ^ 4 + C ((-2001491424035 / 8639957931 : ℚ)) * X ^ 5 + C ((-965456119271 / 8639957931 : ℚ)) * X ^ 6 + C ((148402576277 / 2879985977 : ℚ)) * X ^ 7 + C ((107053744924 / 785450721 : ℚ)) * X ^ 8 + C ((2045032821259 / 17279915862 : ℚ)) * X ^ 9 + C ((1444196092003 / 17279915862 : ℚ)) * X ^ 10 + C ((1160632792342 / 8639957931 : ℚ)) * X ^ 11 + C ((1066111692455 / 5759971954 : ℚ)) * X ^ 12 + C ((1019322716003 / 5759971954 : ℚ)) * X ^ 13 + C ((4459729939861 / 17279915862 : ℚ)) * X ^ 14 + C ((728462380394 / 2879985977 : ℚ)) * X ^ 15 + C ((61129646987 / 261816907 : ℚ)) * X ^ 16 + C ((511070883410 / 2879985977 : ℚ)) * X ^ 17 + C ((447505882027 / 8639957931 : ℚ)) * X ^ 18
theorem CW_112_1_pre_eq :
    CW_1_re_110 * Fplus_dV_re_002 - CW_1_im_110 * Fplus_dV_im_002 = CW_112_1_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_1_re_110, CW_1_im_110, Fplus_dV_re_002, Fplus_dV_im_002, CW_112_1_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CW_112_1_pim_eq :
    CW_1_re_110 * Fplus_dV_im_002 + CW_1_im_110 * Fplus_dV_re_002 = CW_112_1_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_1_re_110, CW_1_im_110, Fplus_dV_re_002, Fplus_dV_im_002, CW_112_1_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CW_112_1_mul :
    CW_1_c_110 * Fplus_dV_c_002 = ofLadj CW_112_1_pre CW_112_1_pim := by
  rw [CW_1_c_110, Fplus_dV_c_002, ofLadj_mul, CW_112_1_pre_eq, CW_112_1_pim_eq]

def CW_112_2_pre : Polynomial ℚ := C ((-732337587 / 32359393 : ℚ)) + C ((-782379061 / 32359393 : ℚ)) * X ^ 2 + C ((-602704859 / 32359393 : ℚ)) * X ^ 3 + C ((-2424967323 / 64718786 : ℚ)) * X ^ 4 + C ((-2423207885 / 64718786 : ℚ)) * X ^ 5 + C ((-2423207885 / 64718786 : ℚ)) * X ^ 6 + C ((-2424967323 / 64718786 : ℚ)) * X ^ 7 + C ((-602704859 / 32359393 : ℚ)) * X ^ 8 + C ((-782379061 / 32359393 : ℚ)) * X ^ 9
def CW_112_2_pim : Polynomial ℚ := C ((238661058 / 32359393 : ℚ)) + C ((477322116 / 32359393 : ℚ)) * X + C ((779893897 / 32359393 : ℚ)) * X ^ 2 + C ((417292207 / 32359393 : ℚ)) * X ^ 3 + C ((2067406195 / 64718786 : ℚ)) * X ^ 4 + C ((177000779 / 64718786 : ℚ)) * X ^ 5 + C ((777643453 / 64718786 : ℚ)) * X ^ 6 + C ((-1112761963 / 64718786 : ℚ)) * X ^ 7 + C ((60029909 / 32359393 : ℚ)) * X ^ 8 + C ((-302571781 / 32359393 : ℚ)) * X ^ 9
theorem CW_112_2_pre_eq :
    CW_2_re_110 * Fplus_dW_re_002 - CW_2_im_110 * Fplus_dW_im_002 = CW_112_2_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_2_re_110, CW_2_im_110, Fplus_dW_re_002, Fplus_dW_im_002, CW_112_2_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CW_112_2_pim_eq :
    CW_2_re_110 * Fplus_dW_im_002 + CW_2_im_110 * Fplus_dW_re_002 = CW_112_2_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_2_re_110, CW_2_im_110, Fplus_dW_re_002, Fplus_dW_im_002, CW_112_2_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CW_112_2_mul :
    CW_2_c_110 * Fplus_dW_c_002 = ofLadj CW_112_2_pre CW_112_2_pim := by
  rw [CW_2_c_110, Fplus_dW_c_002, ofLadj_mul, CW_112_2_pre_eq, CW_112_2_pim_eq]

theorem CW_112_3_mul : CW_3_c_111 = ofLadj CW_3_re_111 CW_3_im_111 := rfl

@[expose] public def CW_coeff_112 : Ki := CW_0_c_110 * Fplus_dU_c_002 + CW_1_c_110 * Fplus_dV_c_002 + CW_2_c_110 * Fplus_dW_c_002 + CW_3_c_111

theorem CW_coeff_112_sum :
    CW_coeff_112 = ofLadj (CW_112_0_pre + CW_112_1_pre + CW_112_2_pre + CW_3_re_111) (CW_112_0_pim + CW_112_1_pim + CW_112_2_pim + CW_3_im_111) := by
  simp only [CW_coeff_112, CW_112_0_mul, CW_112_1_mul, CW_112_2_mul, CW_112_3_mul]
  simpa [add_assoc] using ofLadj_add4 CW_112_0_pre CW_112_0_pim CW_112_1_pre CW_112_1_pim CW_112_2_pre CW_112_2_pim CW_3_re_111 CW_3_im_111

def CW_112_qre : Polynomial ℚ := C ((-5916722517 / 47603074 : ℚ)) + C ((8598926058793 / 5759971954 : ℚ)) * X + C ((9458299691359 / 8639957931 : ℚ)) * X ^ 2 + C ((1490501462866 / 785450721 : ℚ)) * X ^ 3 + C ((21095003929889 / 8639957931 : ℚ)) * X ^ 4 + C ((1773953113663 / 1570901442 : ℚ)) * X ^ 5 + C ((14153412162181 / 8639957931 : ℚ)) * X ^ 6 + C ((4485488942920 / 8639957931 : ℚ)) * X ^ 7 + C ((-903108735981 / 2879985977 : ℚ)) * X ^ 8
def CW_112_qim : Polynomial ℚ := C ((-6601226951441 / 5759971954 : ℚ)) + C ((-6601226951441 / 5759971954 : ℚ)) * X + C ((-966134527327 / 2879985977 : ℚ)) * X ^ 2 + C ((-2982301809202 / 2879985977 : ℚ)) * X ^ 3 + C ((6673865941649 / 8639957931 : ℚ)) * X ^ 4 + C ((1232347680713 / 1570901442 : ℚ)) * X ^ 5 + C ((235319282995 / 261816907 : ℚ)) * X ^ 6 + C ((1330050633188 / 785450721 : ℚ)) * X ^ 7 + C ((512287032077 / 785450721 : ℚ)) * X ^ 8
theorem CW_coeff_112_poly_re :
    CW_112_0_pre + CW_112_1_pre + CW_112_2_pre + CW_3_re_111 = (0 : Polynomial ℚ) + Phi11 * CW_112_qre := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [CW_112_0_pre, CW_112_1_pre, CW_112_2_pre, CW_3_re_111, CW_112_qre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try grind
theorem CW_coeff_112_poly_im :
    CW_112_0_pim + CW_112_1_pim + CW_112_2_pim + CW_3_im_111 = (0 : Polynomial ℚ) + Phi11 * CW_112_qim := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [CW_112_0_pim, CW_112_1_pim, CW_112_2_pim, CW_3_im_111, CW_112_qim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try grind
public theorem CW_coeff_112_eq :
    CW_coeff_112 = (0 : Ki) := by
  rw [CW_coeff_112_sum, CW_coeff_112_poly_re,
    CW_coeff_112_poly_im, ofLadj_add_Phi11]
  exact ofLadj_zero

end V14Formalization.D12SigmaPlusSegreCore
