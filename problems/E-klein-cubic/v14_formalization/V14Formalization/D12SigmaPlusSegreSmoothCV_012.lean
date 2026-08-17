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

def CV_012_0_pre : Polynomial ℚ := C ((147311323812832 / 8639957931 : ℚ)) + C ((1984191513860800 / 8639957931 : ℚ)) * X + C ((4038049647407242 / 8639957931 : ℚ)) * X ^ 2 + C ((2212046491888626 / 2879985977 : ℚ)) * X ^ 3 + C ((9879169772840900 / 8639957931 : ℚ)) * X ^ 4 + C ((3913230224545508 / 2879985977 : ℚ)) * X ^ 5 + C ((13238588369137706 / 8639957931 : ℚ)) * X ^ 6 + C ((14061397074125320 / 8639957931 : ℚ)) * X ^ 7 + C ((4465661919332258 / 2879985977 : ℚ)) * X ^ 8 + C ((4381335416065758 / 2879985977 : ℚ)) * X ^ 9 + C ((4316799829649974 / 2879985977 : ℚ)) * X ^ 10 + C ((12731235598077608 / 8639957931 : ℚ)) * X ^ 11 + C ((10966207975089122 / 8639957931 : ℚ)) * X ^ 12 + C ((9105956600790032 / 8639957931 : ℚ)) * X ^ 13 + C ((2253615427443632 / 2879985977 : ℚ)) * X ^ 14 + C ((1250207713572490 / 2879985977 : ℚ)) * X ^ 15 + C ((676121129017398 / 2879985977 : ℚ)) * X ^ 16 + C ((529465691551012 / 8639957931 : ℚ)) * X ^ 17 + C ((-431604160566950 / 8639957931 : ℚ)) * X ^ 18
def CV_012_0_pim : Polynomial ℚ := C ((-1335821806088300 / 8639957931 : ℚ)) + C ((-2671643612176600 / 8639957931 : ℚ)) * X + C ((-1056621064253166 / 2879985977 : ℚ)) * X ^ 2 + C ((-3733137822376862 / 8639957931 : ℚ)) * X ^ 3 + C ((-2807301638377108 / 8639957931 : ℚ)) * X ^ 4 + C ((-325871310299016 / 2879985977 : ℚ)) * X ^ 5 + C ((490841700814034 / 8639957931 : ℚ)) * X ^ 6 + C ((2645638402090978 / 8639957931 : ℚ)) * X ^ 7 + C ((3883416100457282 / 8639957931 : ℚ)) * X ^ 8 + C ((3846861620032822 / 8639957931 : ℚ)) * X ^ 9 + C ((3679498610022442 / 8639957931 : ℚ)) * X ^ 10 + C ((4769783501271040 / 8639957931 : ℚ)) * X ^ 11 + C ((532733490229058 / 785450721 : ℚ)) * X ^ 12 + C ((2063641654364052 / 2879985977 : ℚ)) * X ^ 13 + C ((6717645112285060 / 8639957931 : ℚ)) * X ^ 14 + C ((5898286861268932 / 8639957931 : ℚ)) * X ^ 15 + C ((4283513084027114 / 8639957931 : ℚ)) * X ^ 16 + C ((1023727512140460 / 2879985977 : ℚ)) * X ^ 17 + C ((377099921794226 / 2879985977 : ℚ)) * X ^ 18
theorem CV_012_0_pre_eq :
    CV_0_re_001 * Fplus_dU_re_011 - CV_0_im_001 * Fplus_dU_im_011 = CV_012_0_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_0_re_001, CV_0_im_001, Fplus_dU_re_011, Fplus_dU_im_011, CV_012_0_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CV_012_0_pim_eq :
    CV_0_re_001 * Fplus_dU_im_011 + CV_0_im_001 * Fplus_dU_re_011 = CV_012_0_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_0_re_001, CV_0_im_001, Fplus_dU_re_011, Fplus_dU_im_011, CV_012_0_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CV_012_0_mul :
    CV_0_c_001 * Fplus_dU_c_011 = ofLadj CV_012_0_pre CV_012_0_pim := by
  rw [CV_0_c_001, Fplus_dU_c_011, ofLadj_mul, CV_012_0_pre_eq, CV_012_0_pim_eq]

def CV_012_1_pre : Polynomial ℚ := C ((-307067756102296 / 8639957931 : ℚ)) + C ((-4362751500276512 / 8639957931 : ℚ)) * X + C ((-2883605326616056 / 2879985977 : ℚ)) * X ^ 2 + C ((-4727988428899084 / 2879985977 : ℚ)) * X ^ 3 + C ((-7052000183186782 / 2879985977 : ℚ)) * X ^ 4 + C ((-763554350385226 / 261816907 : ℚ)) * X ^ 5 + C ((-28502773541359048 / 8639957931 : ℚ)) * X ^ 6 + C ((-10162753820172722 / 2879985977 : ℚ)) * X ^ 7 + C ((-9682981025299770 / 2879985977 : ℚ)) * X ^ 8 + C ((-28720624741981064 / 8639957931 : ℚ)) * X ^ 9 + C ((-28469623630777700 / 8639957931 : ℚ)) * X ^ 10 + C ((-28069290294204640 / 8639957931 : ℚ)) * X ^ 11 + C ((-8035624043500396 / 2879985977 : ℚ)) * X ^ 12 + C ((-20069808762132896 / 8639957931 : ℚ)) * X ^ 13 + C ((-4954992596400686 / 2879985977 : ℚ)) * X ^ 14 + C ((-8194925798510410 / 8639957931 : ℚ)) * X ^ 15 + C ((-1444324718144896 / 2879985977 : ℚ)) * X ^ 16 + C ((-1027494175788098 / 8639957931 : ℚ)) * X ^ 17 + C ((1137335112447410 / 8639957931 : ℚ)) * X ^ 18
def CV_012_1_pim : Polynomial ℚ := C ((990493506230680 / 2879985977 : ℚ)) + C ((1980987012461360 / 2879985977 : ℚ)) * X + C ((2323313681421068 / 2879985977 : ℚ)) * X ^ 2 + C ((8372022290392336 / 8639957931 : ℚ)) * X ^ 3 + C ((2141422525224022 / 2879985977 : ℚ)) * X ^ 4 + C ((826966862432896 / 2879985977 : ℚ)) * X ^ 5 + C ((-724543885547740 / 8639957931 : ℚ)) * X ^ 6 + C ((-5534585727768070 / 8639957931 : ℚ)) * X ^ 7 + C ((-8340601496126384 / 8639957931 : ℚ)) * X ^ 8 + C ((-8293164804359222 / 8639957931 : ℚ)) * X ^ 9 + C ((-8075960818031930 / 8639957931 : ℚ)) * X ^ 10 + C ((-10728991387470200 / 8639957931 : ℚ)) * X ^ 11 + C ((-13382021956908470 / 8639957931 : ℚ)) * X ^ 12 + C ((-14191797977460302 / 8639957931 : ℚ)) * X ^ 13 + C ((-5182147510607424 / 2879985977 : ℚ)) * X ^ 14 + C ((-13736839794488650 / 8639957931 : ℚ)) * X ^ 15 + C ((-10072333512673508 / 8639957931 : ℚ)) * X ^ 16 + C ((-7199044926633760 / 8639957931 : ℚ)) * X ^ 17 + C ((-2667863790971666 / 8639957931 : ℚ)) * X ^ 18
theorem CV_012_1_pre_eq :
    CV_1_re_001 * Fplus_dV_re_011 - CV_1_im_001 * Fplus_dV_im_011 = CV_012_1_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_1_re_001, CV_1_im_001, Fplus_dV_re_011, Fplus_dV_im_011, CV_012_1_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CV_012_1_pim_eq :
    CV_1_re_001 * Fplus_dV_im_011 + CV_1_im_001 * Fplus_dV_re_011 = CV_012_1_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_1_re_001, CV_1_im_001, Fplus_dV_re_011, Fplus_dV_im_011, CV_012_1_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CV_012_1_mul :
    CV_1_c_001 * Fplus_dV_c_011 = ofLadj CV_012_1_pre CV_012_1_pim := by
  rw [CV_1_c_001, Fplus_dV_c_011, ofLadj_mul, CV_012_1_pre_eq, CV_012_1_pim_eq]

def CV_012_2_pre : Polynomial ℚ := C ((-64903995370 / 97078179 : ℚ)) + C ((43236581226216 / 2879985977 : ℚ)) * X + C ((92256036671696 / 2879985977 : ℚ)) * X ^ 2 + C ((157724630117830 / 2879985977 : ℚ)) * X ^ 3 + C ((753419227648268 / 8639957931 : ℚ)) * X ^ 4 + C ((324889759693410 / 2879985977 : ℚ)) * X ^ 5 + C ((104376372454528 / 785450721 : ℚ)) * X ^ 6 + C ((399768878650698 / 2879985977 : ℚ)) * X ^ 7 + C ((1083764739462142 / 8639957931 : ℚ)) * X ^ 8 + C ((30376517328332 / 261816907 : ℚ)) * X ^ 9 + C ((940491861979192 / 8639957931 : ℚ)) * X ^ 10 + C ((307708056922252 / 2879985977 : ℚ)) * X ^ 11 + C ((810782118300544 / 8639957931 : ℚ)) * X ^ 12 + C ((2717816336404 / 32359393 : ℚ)) * X ^ 13 + C ((610590849108652 / 8639957931 : ℚ)) * X ^ 14 + C ((404997790850536 / 8639957931 : ℚ)) * X ^ 15 + C ((228098578166860 / 8639957931 : ℚ)) * X ^ 16 + C ((54627760247282 / 8639957931 : ℚ)) * X ^ 17 + C ((-13629872484430 / 2879985977 : ℚ)) * X ^ 18
def CV_012_2_pim : Polynomial ℚ := C ((-139260716555546 / 8639957931 : ℚ)) + C ((-278521433111092 / 8639957931 : ℚ)) * X + C ((-115106480902574 / 2879985977 : ℚ)) * X ^ 2 + C ((-438514204809350 / 8639957931 : ℚ)) * X ^ 3 + C ((-429378539558368 / 8639957931 : ℚ)) * X ^ 4 + C ((-303086185240648 / 8639957931 : ℚ)) * X ^ 5 + C ((-128366795520208 / 8639957931 : ℚ)) * X ^ 6 + C ((112353920642344 / 8639957931 : ℚ)) * X ^ 7 + C ((81741798015440 / 2879985977 : ℚ)) * X ^ 8 + C ((233460812123954 / 8639957931 : ℚ)) * X ^ 9 + C ((59894544274710 / 2879985977 : ℚ)) * X ^ 10 + C ((240230975604856 / 8639957931 : ℚ)) * X ^ 11 + C ((300778318385582 / 8639957931 : ℚ)) * X ^ 12 + C ((313799148682388 / 8639957931 : ℚ)) * X ^ 13 + C ((131743109620550 / 2879985977 : ℚ)) * X ^ 14 + C ((420295240830794 / 8639957931 : ℚ)) * X ^ 15 + C ((121001068389636 / 2879985977 : ℚ)) * X ^ 16 + C ((90130097896856 / 2879985977 : ℚ)) * X ^ 17 + C ((98669896183850 / 8639957931 : ℚ)) * X ^ 18
theorem CV_012_2_pre_eq :
    CV_2_re_001 * Fplus_dW_re_011 - CV_2_im_001 * Fplus_dW_im_011 = CV_012_2_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_2_re_001, CV_2_im_001, Fplus_dW_re_011, Fplus_dW_im_011, CV_012_2_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CV_012_2_pim_eq :
    CV_2_re_001 * Fplus_dW_im_011 + CV_2_im_001 * Fplus_dW_re_011 = CV_012_2_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_2_re_001, CV_2_im_001, Fplus_dW_re_011, Fplus_dW_im_011, CV_012_2_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CV_012_2_mul :
    CV_2_c_001 * Fplus_dW_c_011 = ofLadj CV_012_2_pre CV_012_2_pim := by
  rw [CV_2_c_001, Fplus_dW_c_011, ofLadj_mul, CV_012_2_pre_eq, CV_012_2_pim_eq]

def CV_012_3_pre : Polynomial ℚ := C ((13390309388 / 261816907 : ℚ)) + C ((-136338726496 / 785450721 : ℚ)) * X ^ 2 + C ((-100411107208 / 261816907 : ℚ)) * X ^ 3 + C ((-463078558868 / 785450721 : ℚ)) * X ^ 4 + C ((-555034747112 / 785450721 : ℚ)) * X ^ 5 + C ((-555034747112 / 785450721 : ℚ)) * X ^ 6 + C ((-463078558868 / 785450721 : ℚ)) * X ^ 7 + C ((-100411107208 / 261816907 : ℚ)) * X ^ 8 + C ((-136338726496 / 785450721 : ℚ)) * X ^ 9
def CV_012_3_pim : Polynomial ℚ := C ((1818200633248 / 8639957931 : ℚ)) + C ((3636401266496 / 8639957931 : ℚ)) * X + C ((4865567443888 / 8639957931 : ℚ)) * X ^ 2 + C ((1721903830400 / 2879985977 : ℚ)) * X ^ 3 + C ((1453774462648 / 2879985977 : ℚ)) * X ^ 4 + C ((2787289143688 / 8639957931 : ℚ)) * X ^ 5 + C ((849112122808 / 8639957931 : ℚ)) * X ^ 6 + C ((-724922121448 / 8639957931 : ℚ)) * X ^ 7 + C ((-1529310224704 / 8639957931 : ℚ)) * X ^ 8 + C ((-1229166177392 / 8639957931 : ℚ)) * X ^ 9
theorem CV_012_3_neg_re : -CV_3_re_012 = CV_012_3_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_3_re_012, CV_012_3_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CV_012_3_neg_im : -CV_3_im_012 = CV_012_3_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_3_im_012, CV_012_3_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CV_012_3_mul : -CV_3_c_012 = ofLadj CV_012_3_pre CV_012_3_pim := by
  rw [CV_3_c_012, ofLadj_neg, CV_012_3_neg_re, CV_012_3_neg_im]

theorem CV_012_4_mul : CV_3_c_002 = ofLadj CV_3_re_002 CV_3_im_002 := rfl

@[expose] public def CV_coeff_012 : Ki := CV_0_c_001 * Fplus_dU_c_011 + CV_1_c_001 * Fplus_dV_c_011 + CV_2_c_001 * Fplus_dW_c_011 + (-CV_3_c_012) + CV_3_c_002

theorem CV_coeff_012_sum :
    CV_coeff_012 = ofLadj (CV_012_0_pre + CV_012_1_pre + CV_012_2_pre + CV_012_3_pre + CV_3_re_002) (CV_012_0_pim + CV_012_1_pim + CV_012_2_pim + CV_012_3_pim + CV_3_im_002) := by
  simp only [CV_coeff_012, CV_012_0_mul, CV_012_1_mul, CV_012_2_mul, CV_012_3_mul, CV_012_4_mul]
  simp [ofLadj_add, add_assoc]

def CV_012_qre : Polynomial ℚ := C ((-163801754488310 / 8639957931 : ℚ)) + C ((-2085048488248754 / 8639957931 : ℚ)) * X + C ((-697228945862842 / 2879985977 : ℚ)) * X ^ 2 + C ((-2744654541760486 / 8639957931 : ℚ)) * X ^ 3 + C ((-3454235790820106 / 8639957931 : ℚ)) * X ^ 4 + C ((-1962792677726770 / 8639957931 : ℚ)) * X ^ 5 + C ((-544370488408610 / 2879985977 : ℚ)) * X ^ 6 + C ((-1108242058416974 / 8639957931 : ℚ)) * X ^ 7 + C ((221613778142390 / 2879985977 : ℚ)) * X ^ 8
def CV_012_qim : Polynomial ℚ := C ((1502198335408946 / 8639957931 : ℚ)) + C ((1502198335408946 / 8639957931 : ℚ)) * X + C ((465898619682508 / 8639957931 : ℚ)) * X ^ 2 + C ((746494224989804 / 8639957931 : ℚ)) * X ^ 3 + C ((-1015310398286638 / 8639957931 : ℚ)) * X ^ 4 + C ((-1992440468911438 / 8639957931 : ℚ)) * X ^ 5 + C ((-1568345126955674 / 8639957931 : ℚ)) * X ^ 6 + C ((-2419577967116674 / 8639957931 : ℚ)) * X ^ 7 + C ((-479298043135046 / 2879985977 : ℚ)) * X ^ 8
theorem CV_coeff_012_poly_re :
    CV_012_0_pre + CV_012_1_pre + CV_012_2_pre + CV_012_3_pre + CV_3_re_002 = (0 : Polynomial ℚ) + Phi11 * CV_012_qre := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [CV_012_0_pre, CV_012_1_pre, CV_012_2_pre, CV_012_3_pre, CV_3_re_002, CV_012_qre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try ring
theorem CV_coeff_012_poly_im :
    CV_012_0_pim + CV_012_1_pim + CV_012_2_pim + CV_012_3_pim + CV_3_im_002 = (0 : Polynomial ℚ) + Phi11 * CV_012_qim := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [CV_012_0_pim, CV_012_1_pim, CV_012_2_pim, CV_012_3_pim, CV_3_im_002, CV_012_qim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try ring
public theorem CV_coeff_012_eq :
    CV_coeff_012 = (0 : Ki) := by
  rw [CV_coeff_012_sum, CV_coeff_012_poly_re,
    CV_coeff_012_poly_im, ofLadj_add_Phi11]
  exact ofLadj_zero

end V14Formalization.D12SigmaPlusSegreCore
