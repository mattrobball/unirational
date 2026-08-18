/-
Auto-generated Fplus chart Nullstellensatz identities.
-/
module

public import V14Formalization.D12SigmaPlusSegreEval
public import V14Formalization.D12SigmaPlusSegreMul
public import V14Formalization.D12SigmaPlusSegrePartials
public import V14Formalization.D12SigmaPlusSegreBezoutData
public import V14Formalization.D12PolyZReflection
public import V14Formalization.D12SigmaPlusSegreFplusZ

noncomputable section
open Matrix Polynomial
namespace V14Formalization.D12SigmaPlusSegreCore
open D12PolynomialData
open V14Formalization.D12PolyZReflection

def CV_012_0_pre : Polynomial ℚ := interpQ 8639957931 [147311323812832, 1984191513860800, 4038049647407242, 6636139475665878, 9879169772840900, 11739690673636524, 13238588369137706, 14061397074125320, 13396985757996774, 13144006248197274, 12950399488949922, 12731235598077608, 10966207975089122, 9105956600790032, 6760846282330896, 3750623140717470, 2028363387052194, 529465691551012, -431604160566950]
def CV_012_0_pim : Polynomial ℚ := interpQ 8639957931 [-1335821806088300, -2671643612176600, -3169863192759498, -3733137822376862, -2807301638377108, -977613930897048, 490841700814034, 2645638402090978, 3883416100457282, 3846861620032822, 3679498610022442, 4769783501271040, 5860068392519638, 6190924963092156, 6717645112285060, 5898286861268932, 4283513084027114, 3071182536421380, 1131299765382678]
theorem CV_012_0_pre_eq :
    CV_0_re_001 * Fplus_dU_re_011 - CV_0_im_001 * Fplus_dU_im_011 = CV_012_0_pre := by
  simp only [CV_0_re_001_def, CV_0_im_001_def, Fplus_dU_re_011_def, Fplus_dU_im_011_def, CV_012_0_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_012_0_pim_eq :
    CV_0_re_001 * Fplus_dU_im_011 + CV_0_im_001 * Fplus_dU_re_011 = CV_012_0_pim := by
  simp only [CV_0_re_001_def, CV_0_im_001_def, Fplus_dU_re_011_def, Fplus_dU_im_011_def, CV_012_0_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_012_0_mul :
    CV_0_c_001 * Fplus_dU_c_011 = ofLadj CV_012_0_pre CV_012_0_pim := by
  rw [CV_0_c_001_def, Fplus_dU_c_011_def, ofLadj_mul, CV_012_0_pre_eq, CV_012_0_pim_eq]

def CV_012_1_pre : Polynomial ℚ := interpQ 8639957931 [-307067756102296, -4362751500276512, -8650815979848168, -14183965286697252, -21156000549560346, -25197293562712458, -28502773541359048, -30488261460518166, -29048943075899310, -28720624741981064, -28469623630777700, -28069290294204640, -24106872130501188, -20069808762132896, -14864977789202058, -8194925798510410, -4332974154434688, -1027494175788098, 1137335112447410]
def CV_012_1_pim : Polynomial ℚ := interpQ 8639957931 [2971480518692040, 5942961037384080, 6969941044263204, 8372022290392336, 6424267575672066, 2480900587298688, -724543885547740, -5534585727768070, -8340601496126384, -8293164804359222, -8075960818031930, -10728991387470200, -13382021956908470, -14191797977460302, -15546442531822272, -13736839794488650, -10072333512673508, -7199044926633760, -2667863790971666]
theorem CV_012_1_pre_eq :
    CV_1_re_001 * Fplus_dV_re_011 - CV_1_im_001 * Fplus_dV_im_011 = CV_012_1_pre := by
  simp only [CV_1_re_001_def, CV_1_im_001_def, Fplus_dV_re_011_def, Fplus_dV_im_011_def, CV_012_1_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_012_1_pim_eq :
    CV_1_re_001 * Fplus_dV_im_011 + CV_1_im_001 * Fplus_dV_re_011 = CV_012_1_pim := by
  simp only [CV_1_re_001_def, CV_1_im_001_def, Fplus_dV_re_011_def, Fplus_dV_im_011_def, CV_012_1_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_012_1_mul :
    CV_1_c_001 * Fplus_dV_c_011 = ofLadj CV_012_1_pre CV_012_1_pim := by
  rw [CV_1_c_001_def, Fplus_dV_c_011_def, ofLadj_mul, CV_012_1_pre_eq, CV_012_1_pim_eq]

def CV_012_2_pre : Polynomial ℚ := interpQ 8639957931 [-5776455587930, 129709743678648, 276768110015088, 473173890353490, 753419227648268, 974669279080230, 1148140096999808, 1199306635952094, 1083764739462142, 1002425071834956, 940491861979192, 923124170766756, 810782118300544, 725656961819868, 610590849108652, 404997790850536, 228098578166860, 54627760247282, -40889617453290]
def CV_012_2_pim : Polynomial ℚ := interpQ 8639957931 [-139260716555546, -278521433111092, -345319442707722, -438514204809350, -429378539558368, -303086185240648, -128366795520208, 112353920642344, 245225394046320, 233460812123954, 179683632824130, 240230975604856, 300778318385582, 313799148682388, 395229328861650, 420295240830794, 363003205168908, 270390293690568, 98669896183850]
theorem CV_012_2_pre_eq :
    CV_2_re_001 * Fplus_dW_re_011 - CV_2_im_001 * Fplus_dW_im_011 = CV_012_2_pre := by
  simp only [CV_2_re_001_def, CV_2_im_001_def, Fplus_dW_re_011_def, Fplus_dW_im_011_def, CV_012_2_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_012_2_pim_eq :
    CV_2_re_001 * Fplus_dW_im_011 + CV_2_im_001 * Fplus_dW_re_011 = CV_012_2_pim := by
  simp only [CV_2_re_001_def, CV_2_im_001_def, Fplus_dW_re_011_def, Fplus_dW_im_011_def, CV_012_2_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_012_2_mul :
    CV_2_c_001 * Fplus_dW_c_011 = ofLadj CV_012_2_pre CV_012_2_pim := by
  rw [CV_2_c_001_def, Fplus_dW_c_011_def, ofLadj_mul, CV_012_2_pre_eq, CV_012_2_pim_eq]

def CV_012_3_pre : Polynomial ℚ := interpQ 8639957931 [441880209804, 0, -1499725991456, -3313566537864, -5093864147548, -6105382218232, -6105382218232, -5093864147548, -3313566537864, -1499725991456]
def CV_012_3_pim : Polynomial ℚ := interpQ 8639957931 [1818200633248, 3636401266496, 4865567443888, 5165711491200, 4361323387944, 2787289143688, 849112122808, -724922121448, -1529310224704, -1229166177392]
theorem CV_012_3_neg_re : -CV_3_re_012 = CV_012_3_pre := by
  simp only [CV_3_re_012_def, CV_012_3_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_012_3_neg_im : -CV_3_im_012 = CV_012_3_pim := by
  simp only [CV_3_im_012_def, CV_012_3_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_012_3_mul : -CV_3_c_012 = ofLadj CV_012_3_pre CV_012_3_pim := by
  rw [CV_3_c_012_def, ofLadj_neg, CV_012_3_neg_re, CV_012_3_neg_im]

theorem CV_012_4_mul : CV_3_c_002 = ofLadj CV_3_re_002 CV_3_im_002 := CV_3_c_002_def

@[expose] public def CV_coeff_012 : Ki := CV_0_c_001 * Fplus_dU_c_011 + CV_1_c_001 * Fplus_dV_c_011 + CV_2_c_001 * Fplus_dW_c_011 + (-CV_3_c_012) + CV_3_c_002

theorem CV_coeff_012_sum :
    CV_coeff_012 = ofLadj (CV_012_0_pre + CV_012_1_pre + CV_012_2_pre + CV_012_3_pre + CV_3_re_002) (CV_012_0_pim + CV_012_1_pim + CV_012_2_pim + CV_012_3_pim + CV_3_im_002) := by
  simp only [CV_coeff_012, CV_012_0_mul, CV_012_1_mul, CV_012_2_mul, CV_012_3_mul, CV_012_4_mul]
  simp [ofLadj_add, add_assoc]

def CV_012_qre : Polynomial ℚ := interpQ 8639957931 [-163801754488310, -2085048488248754, -2091686837588526, -2744654541760486, -3454235790820106, -1962792677726770, -1633111465225830, -1108242058416974, 664841334427170]
def CV_012_qim : Polynomial ℚ := interpQ 8639957931 [1502198335408946, 1502198335408946, 465898619682508, 746494224989804, -1015310398286638, -1992440468911438, -1568345126955674, -2419577967116674, -1437894129405138]
theorem CV_coeff_012_poly_re :
    CV_012_0_pre + CV_012_1_pre + CV_012_2_pre + CV_012_3_pre + CV_3_re_002 = (0 : Polynomial ℚ) + Phi11 * CV_012_qre := by
  rw [phi11_interpQ]
  simp only [CV_012_0_pre, CV_012_1_pre, CV_012_2_pre, CV_012_3_pre, CV_3_re_002_def, CV_012_qre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_coeff_012_poly_im :
    CV_012_0_pim + CV_012_1_pim + CV_012_2_pim + CV_012_3_pim + CV_3_im_002 = (0 : Polynomial ℚ) + Phi11 * CV_012_qim := by
  rw [phi11_interpQ]
  simp only [CV_012_0_pim, CV_012_1_pim, CV_012_2_pim, CV_012_3_pim, CV_3_im_002_def, CV_012_qim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
public theorem CV_coeff_012_eq :
    CV_coeff_012 = (0 : Ki) := by
  rw [CV_coeff_012_sum, CV_coeff_012_poly_re,
    CV_coeff_012_poly_im, ofLadj_add_Phi11]
  exact ofLadj_zero

end V14Formalization.D12SigmaPlusSegreCore
