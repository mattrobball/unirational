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

def CV_011_0_pre : Polynomial ℚ := interpQ 8639957931 [-22762931259623, -326852687059340, -662935757091124, -1090138240142762, -1624367395646912, -1929045915231931, -2176371400500079, -2310914758277942, -2201671113900803, -2159877553832436, -2128231179398601, -2093506860732003, -1801378492339261, -1496941796741312, -1111532873758041, -615512418329611, -333572669992476, -86247184724328, 71034944301419]
def CV_011_0_pim : Polynomial ℚ := interpQ 8639957931 [220674212446109, 441348424892218, 522052028023708, 617136516885636, 464124796614166, 163651995823314, -76853940468024, -431652063644711, -633934471297941, -627950225008485, -600346395043338, -780683438985197, -961020482927056, -1014120256093399, -1103220498665871, -967703496507450, -702664656539246, -504151851894220, -184787689540181]
theorem CV_011_0_pre_eq :
    CV_0_re_000 * Fplus_dU_re_011 - CV_0_im_000 * Fplus_dU_im_011 = CV_011_0_pre := by
  simp only [CV_0_re_000_def, CV_0_im_000_def, Fplus_dU_re_011_def, Fplus_dU_im_011_def, CV_011_0_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_011_0_pim_eq :
    CV_0_re_000 * Fplus_dU_im_011 + CV_0_im_000 * Fplus_dU_re_011 = CV_011_0_pim := by
  simp only [CV_0_re_000_def, CV_0_im_000_def, Fplus_dU_re_011_def, Fplus_dU_im_011_def, CV_011_0_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_011_0_mul :
    CV_0_c_000 * Fplus_dU_c_011 = ofLadj CV_011_0_pre CV_011_0_pim := by
  rw [CV_0_c_000_def, Fplus_dU_c_011_def, ofLadj_mul, CV_011_0_pre_eq, CV_011_0_pim_eq]

def CV_011_1_pre : Polynomial ℚ := interpQ 8639957931 [53231685536408, 756214727591680, 1498325303915110, 2456818503636768, 3665119356735976, 4363502131519800, 4938172090922909, 5280581378593072, 5032071476701571, 4975003050164931, 4931785589855062, 4862105674954278, 4175570862263382, 3476677746249821, 2575252973064803, 1419094436117878, 751860290793559, 177190331390450, -196367585739218]
def CV_011_1_pim : Polynomial ℚ := interpQ 8639957931 [-515057074707672, -1030114149415344, -1207425305501542, -1452184188875384, -1112809988268515, -431814409590761, 123997659797607, 956748144606284, 1442193566549068, 1433847176200051, 1396325428233563, 1856191707190464, 2316057986147365, 2455847394267075, 2692259887291900, 2376969699232030, 1744075937994751, 1246010076763987, 461361409395785]
theorem CV_011_1_pre_eq :
    CV_1_re_000 * Fplus_dV_re_011 - CV_1_im_000 * Fplus_dV_im_011 = CV_011_1_pre := by
  simp only [CV_1_re_000_def, CV_1_im_000_def, Fplus_dV_re_011_def, Fplus_dV_im_011_def, CV_011_1_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_011_1_pim_eq :
    CV_1_re_000 * Fplus_dV_im_011 + CV_1_im_000 * Fplus_dV_re_011 = CV_011_1_pim := by
  simp only [CV_1_re_000_def, CV_1_im_000_def, Fplus_dV_re_011_def, Fplus_dV_im_011_def, CV_011_1_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_011_1_mul :
    CV_1_c_000 * Fplus_dV_c_011 = ofLadj CV_011_1_pre CV_011_1_pim := by
  rw [CV_1_c_000_def, Fplus_dV_c_011_def, ofLadj_mul, CV_011_1_pre_eq, CV_011_1_pim_eq]

def CV_011_2_pre : Polynomial ℚ := interpQ 8639957931 [1280121744710, -25603056019160, -54396108745934, -92912434955884, -148222183196548, -191576633385034, -225860806910077, -235629137000864, -213132784680166, -197151224690689, -185027761358651, -181631169670100, -159424705339491, -142755115944755, -120220349724282, -79528004484485, -44996064726720, -10711891201677, 7878949319831]
def CV_011_2_pim : Polynomial ℚ := interpQ 8639957931 [27523277456535, 55046554913070, 67860089113157, 86641917283876, 84617229679498, 60058066881976, 25449157599209, -21623558152185, -47698022804312, -45298982093693, -34852850277198, -46850289703074, -58847729128950, -61215131512542, -77597918972642, -82339692103974, -71193402937027, -52967846037236, -19308003916417]
theorem CV_011_2_pre_eq :
    CV_2_re_000 * Fplus_dW_re_011 - CV_2_im_000 * Fplus_dW_im_011 = CV_011_2_pre := by
  simp only [CV_2_re_000_def, CV_2_im_000_def, Fplus_dW_re_011_def, Fplus_dW_im_011_def, CV_011_2_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_011_2_pim_eq :
    CV_2_re_000 * Fplus_dW_im_011 + CV_2_im_000 * Fplus_dW_re_011 = CV_011_2_pim := by
  simp only [CV_2_re_000_def, CV_2_im_000_def, Fplus_dW_re_011_def, Fplus_dW_im_011_def, CV_011_2_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_011_2_mul :
    CV_2_c_000 * Fplus_dW_c_011 = ofLadj CV_011_2_pre CV_011_2_pim := by
  rw [CV_2_c_000_def, Fplus_dW_c_011_def, ofLadj_mul, CV_011_2_pre_eq, CV_011_2_pim_eq]

def CV_011_3_pre : Polynomial ℚ := interpQ 8639957931 [-189871475860, 0, 552377456004, 1259070977208, 1942857901512, 2355510120612, 2355510120612, 1942857901512, 1259070977208, 552377456004]
def CV_011_3_pim : Polynomial ℚ := interpQ 8639957931 [-672210784138, -1344421568276, -1872635383430, -1909532034488, -1732365732728, -987348719980, -357072848296, 387944164452, 565110466212, 528213815154]
theorem CV_011_3_neg_re : -CV_3_re_011 = CV_011_3_pre := by
  simp only [CV_3_re_011_def, CV_011_3_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_011_3_neg_im : -CV_3_im_011 = CV_011_3_pim := by
  simp only [CV_3_im_011_def, CV_011_3_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_011_3_mul : -CV_3_c_011 = ofLadj CV_011_3_pre CV_011_3_pim := by
  rw [CV_3_c_011_def, ofLadj_neg, CV_011_3_neg_re, CV_011_3_neg_im]

@[expose] public def CV_coeff_011 : Ki := CV_0_c_000 * Fplus_dU_c_011 + CV_1_c_000 * Fplus_dV_c_011 + CV_2_c_000 * Fplus_dW_c_011 + (-CV_3_c_011)

theorem CV_coeff_011_sum :
    CV_coeff_011 = ofLadj (CV_011_0_pre + CV_011_1_pre + CV_011_2_pre + CV_011_3_pre) (CV_011_0_pim + CV_011_1_pim + CV_011_2_pim + CV_011_3_pim) := by
  simp only [CV_coeff_011, CV_011_0_mul, CV_011_1_mul, CV_011_2_mul, CV_011_3_mul]
  simpa [add_assoc] using ofLadj_add4 CV_011_0_pre CV_011_0_pim CV_011_1_pre CV_011_1_pim CV_011_2_pre CV_011_2_pim CV_011_3_pre CV_011_3_pim

def CV_011_qre : Polynomial ℚ := interpQ 8639957931 [31559004545635, 372199979967545, 377786831020876, 493481083981274, 619445736278698, 350762457229419, 293060300609918, 197684947582413, -117453692117968]
def CV_011_qim : Polynomial ℚ := interpQ 8639957931 [-267531795589166, -267531795589166, -84322232569775, -130929462992253, 184514959032781, 356708632102128, 281327499685947, 431624662893344, 257265715939187]
theorem CV_coeff_011_poly_re :
    CV_011_0_pre + CV_011_1_pre + CV_011_2_pre + CV_011_3_pre = (0 : Polynomial ℚ) + Phi11 * CV_011_qre := by
  rw [phi11_interpQ]
  simp only [CV_011_0_pre, CV_011_1_pre, CV_011_2_pre, CV_011_3_pre, CV_011_qre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_coeff_011_poly_im :
    CV_011_0_pim + CV_011_1_pim + CV_011_2_pim + CV_011_3_pim = (0 : Polynomial ℚ) + Phi11 * CV_011_qim := by
  rw [phi11_interpQ]
  simp only [CV_011_0_pim, CV_011_1_pim, CV_011_2_pim, CV_011_3_pim, CV_011_qim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
public theorem CV_coeff_011_eq :
    CV_coeff_011 = (0 : Ki) := by
  rw [CV_coeff_011_sum, CV_coeff_011_poly_re,
    CV_coeff_011_poly_im, ofLadj_add_Phi11]
  exact ofLadj_zero

end V14Formalization.D12SigmaPlusSegreCore
