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

def CV_003_0_pre : Polynomial ℚ := interpQ 8639957931 [85681098936364, 1388934059702560, 2773863750783203, 4504004887675008, 6843313177773706, 8272167290272001, 9576885585855637, 10445332190772638, 10270310696278409, 10408451320538393, 10513403050455683, 10467310574377104, 9124468990753123, 7634587569755190, 5766305808603401, 3300510996088530, 1796305518154440, 491587222570804, -301508016910402]
def CV_003_0_pim : Polynomial ℚ := interpQ 8639957931 [-994601009677634, -1989202019355268, -2424764324350629, -3028664500763238, -2629757209816788, -1582740334730312, -770367628961085, 689946194865998, 1534208611745617, 1553824033679692, 1645170991471007, 2773353869439400, 3901536747407793, 4428446010194469, 5051961608541153, 4595441234465642, 3430961511239530, 2479652171975399, 901875500008680]
theorem CV_003_0_pre_eq :
    CV_0_re_001 * Fplus_dU_re_002 - CV_0_im_001 * Fplus_dU_im_002 = CV_003_0_pre := by
  simp only [CV_0_re_001_def, CV_0_im_001_def, Fplus_dU_re_002_def, Fplus_dU_im_002_def, CV_003_0_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_003_0_pim_eq :
    CV_0_re_001 * Fplus_dU_im_002 + CV_0_im_001 * Fplus_dU_re_002 = CV_003_0_pim := by
  simp only [CV_0_re_001_def, CV_0_im_001_def, Fplus_dU_re_002_def, Fplus_dU_im_002_def, CV_003_0_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_003_0_mul :
    CV_0_c_001 * Fplus_dU_c_002 = ofLadj CV_003_0_pre CV_003_0_pim := by
  rw [CV_0_c_001_def, Fplus_dU_c_002_def, ofLadj_mul, CV_003_0_pre_eq, CV_003_0_pim_eq]

def CV_003_1_pre : Polynomial ℚ := interpQ 8639957931 [-7142162720370, 155812553581304, 332342346787119, 568299097404949, 904964118147018, 1171085010650112, 1379184821930119, 1440755793136836, 1301831905148442, 1204133347623895, 1129638469624480, 1108884943726252, 973825916043176, 871791000836776, 733532807743493, 486515635868602, 273722400219093, 65622588939086, -49276039121216]
def CV_003_1_pim : Polynomial ℚ := interpQ 8639957931 [-167336378860228, -334672757720456, -414961585290555, -526802983763926, -516271276658039, -364058276895574, -154393276229352, 135063393991682, 294469642784850, 280507164246795, 215890563895430, 288577784878144, 361265005860858, 376937233079592, 474816153014908, 505207553162547, 436031423058902, 324902942101856, 118483141539642]
theorem CV_003_1_pre_eq :
    CV_1_re_001 * Fplus_dV_re_002 - CV_1_im_001 * Fplus_dV_im_002 = CV_003_1_pre := by
  simp only [CV_1_re_001_def, CV_1_im_001_def, Fplus_dV_re_002_def, Fplus_dV_im_002_def, CV_003_1_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_003_1_pim_eq :
    CV_1_re_001 * Fplus_dV_im_002 + CV_1_im_001 * Fplus_dV_re_002 = CV_003_1_pim := by
  simp only [CV_1_re_001_def, CV_1_im_001_def, Fplus_dV_re_002_def, Fplus_dV_im_002_def, CV_003_1_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_003_1_mul :
    CV_1_c_001 * Fplus_dV_c_002 = ofLadj CV_003_1_pre CV_003_1_pim := by
  rw [CV_1_c_001_def, Fplus_dV_c_002_def, ofLadj_mul, CV_003_1_pre_eq, CV_003_1_pim_eq]

def CV_003_2_pre : Polynomial ℚ := interpQ 8639957931 [-14326459315347, 0, 38268010664739, 88508661945024, 134602314397035, 162000014094309, 162000014094309, 134602314397035, 88508661945024, 38268010664739]
def CV_003_2_pim : Polynomial ℚ := interpQ 8639957931 [-48641153879493, -97282307758986, -130483120040544, -137739325615092, -116609118752925, -74007860129397, -23274447629589, 19326810993939, 40457017856106, 33200812281558]
theorem CV_003_2_pre_eq :
    CV_2_re_001 * Fplus_dW_re_002 - CV_2_im_001 * Fplus_dW_im_002 = CV_003_2_pre := by
  simp only [CV_2_re_001_def, CV_2_im_001_def, Fplus_dW_re_002_def, Fplus_dW_im_002_def, CV_003_2_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_003_2_pim_eq :
    CV_2_re_001 * Fplus_dW_im_002 + CV_2_im_001 * Fplus_dW_re_002 = CV_003_2_pim := by
  simp only [CV_2_re_001_def, CV_2_im_001_def, Fplus_dW_re_002_def, Fplus_dW_im_002_def, CV_003_2_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_003_2_mul :
    CV_2_c_001 * Fplus_dW_c_002 = ofLadj CV_003_2_pre CV_003_2_pim := by
  rw [CV_2_c_001_def, Fplus_dW_c_002_def, ofLadj_mul, CV_003_2_pre_eq, CV_003_2_pim_eq]

def CV_003_3_pre : Polynomial ℚ := interpQ 8639957931 [2633525076160, 0, -7811158746864, -17609743291712, -26864722194728, -32238713309792, -32238713309792, -26864722194728, -17609743291712, -7811158746864]
def CV_003_3_pim : Polynomial ℚ := interpQ 8639957931 [9708443466248, 19416886932496, 25887341774104, 27490603952632, 23050372966000, 14875092823288, 4541794109208, -3633486033504, -8073717020136, -6470454841608]
theorem CV_003_3_neg_re : -CV_3_re_003 = CV_003_3_pre := by
  simp only [CV_3_re_003_def, CV_003_3_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_003_3_neg_im : -CV_3_im_003 = CV_003_3_pim := by
  simp only [CV_3_im_003_def, CV_003_3_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_003_3_mul : -CV_3_c_003 = ofLadj CV_003_3_pre CV_003_3_pim := by
  rw [CV_3_c_003_def, ofLadj_neg, CV_003_3_neg_re, CV_003_3_neg_im]

@[expose] public def CV_coeff_003 : Ki := CV_0_c_001 * Fplus_dU_c_002 + CV_1_c_001 * Fplus_dV_c_002 + CV_2_c_001 * Fplus_dW_c_002 + (-CV_3_c_003)

theorem CV_coeff_003_sum :
    CV_coeff_003 = ofLadj (CV_003_0_pre + CV_003_1_pre + CV_003_2_pre + CV_003_3_pre) (CV_003_0_pim + CV_003_1_pim + CV_003_2_pim + CV_003_3_pim) := by
  simp only [CV_coeff_003, CV_003_0_mul, CV_003_1_mul, CV_003_2_mul, CV_003_3_mul]
  simpa [add_assoc] using ofLadj_add4 CV_003_0_pre CV_003_0_pim CV_003_1_pre CV_003_1_pim CV_003_2_pre CV_003_2_pim CV_003_3_pre CV_003_3_pim

def CV_003_qre : Polynomial ℚ := interpQ 8639957931 [66846001976807, 1477900611307057, 1591916336204333, 2006539954245072, 2712811984389762, 1716998713583599, 1512818106863643, 907993867541508, -350784056031618]
def CV_003_qim : Polynomial ℚ := interpQ 8639957931 [-1200870098951107, -1200870098951107, -542581490005410, -721394518282000, 426128973927872, 1233655853329757, 1062437820221177, 1784196472528933, 1020358641548322]
theorem CV_coeff_003_poly_re :
    CV_003_0_pre + CV_003_1_pre + CV_003_2_pre + CV_003_3_pre = (0 : Polynomial ℚ) + Phi11 * CV_003_qre := by
  rw [phi11_interpQ]
  simp only [CV_003_0_pre, CV_003_1_pre, CV_003_2_pre, CV_003_3_pre, CV_003_qre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_coeff_003_poly_im :
    CV_003_0_pim + CV_003_1_pim + CV_003_2_pim + CV_003_3_pim = (0 : Polynomial ℚ) + Phi11 * CV_003_qim := by
  rw [phi11_interpQ]
  simp only [CV_003_0_pim, CV_003_1_pim, CV_003_2_pim, CV_003_3_pim, CV_003_qim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
public theorem CV_coeff_003_eq :
    CV_coeff_003 = (0 : Ki) := by
  rw [CV_coeff_003_sum, CV_coeff_003_poly_re,
    CV_coeff_003_poly_im, ofLadj_add_Phi11]
  exact ofLadj_zero

end V14Formalization.D12SigmaPlusSegreCore
