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

def CV_020_0_pre : Polynomial ℚ := interpQ 17279915862 [899834475441, -163426343529670, -307781119539329, -530937077009249, -867567379290110, -1118771570704255, -1364674644154361, -1561958809346999, -1588262123632274, -1643239574859843, -1686187949269101, -1702365503917616, -1522761605739431, -1335458455320514, -1057325046623025, -669415830603392, -387996465165039, -142093391714933, 24975599453497]
def CV_020_0_pim : Polynomial ℚ := interpQ 17279915862 [151193692105472, 302387384210944, 407232780436110, 573666708779804, 599381859065855, 533696730866270, 468430726979493, 279874343449291, 145095411822851, 137465416894904, 100625752570281, -104345618315676, -309316989201633, -451002049751422, -625065973023063, -627962433116049, -514678728770832, -393752581495339, -157597621819505]
theorem CV_020_0_pre_eq :
    CV_0_re_000 * Fplus_dU_re_020 - CV_0_im_000 * Fplus_dU_im_020 = CV_020_0_pre := by
  simp only [CV_0_re_000_def, CV_0_im_000_def, Fplus_dU_re_020_def, Fplus_dU_im_020_def, CV_020_0_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_020_0_pim_eq :
    CV_0_re_000 * Fplus_dU_im_020 + CV_0_im_000 * Fplus_dU_re_020 = CV_020_0_pim := by
  simp only [CV_0_re_000_def, CV_0_im_000_def, Fplus_dU_re_020_def, Fplus_dU_im_020_def, CV_020_0_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_020_0_mul :
    CV_0_c_000 * Fplus_dU_c_020 = ofLadj CV_020_0_pre CV_020_0_pim := by
  rw [CV_0_c_000_def, Fplus_dU_c_020_def, ofLadj_mul, CV_020_0_pre_eq, CV_020_0_pim_eq]

def CV_020_1_pre : Polynomial ℚ := interpQ 17279915862 [16542915670632, 162046013055360, 281733666620805, 455248605966270, 688115898842811, 781799880973164, 897327752427402, 1029512527961328, 1054143543834429, 1136524147067334, 1199388841626699, 1206289014576174, 1037342828571339, 854790480446529, 598894937868159, 290351580303006, 151711216257894, 36183344803656, -51045048815511]
def CV_020_1_pim : Polynomial ℚ := interpQ 17279915862 [-93007300324284, -186014600648568, -214011051091074, -278209627246356, -208824394415964, -94539307942413, -63983596364109, 52870365003384, 141224134695342, 153065133317436, 207566106920715, 380393292999168, 553220479077621, 635717903123406, 711757477900782, 607788958738551, 423513669765624, 309781219890666, 122937056023797]
theorem CV_020_1_pre_eq :
    CV_1_re_000 * Fplus_dV_re_020 - CV_1_im_000 * Fplus_dV_im_020 = CV_020_1_pre := by
  simp only [CV_1_re_000_def, CV_1_im_000_def, Fplus_dV_re_020_def, Fplus_dV_im_020_def, CV_020_1_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_020_1_pim_eq :
    CV_1_re_000 * Fplus_dV_im_020 + CV_1_im_000 * Fplus_dV_re_020 = CV_020_1_pim := by
  simp only [CV_1_re_000_def, CV_1_im_000_def, Fplus_dV_re_020_def, Fplus_dV_im_020_def, CV_020_1_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_020_1_mul :
    CV_1_c_000 * Fplus_dV_c_020 = ofLadj CV_020_1_pre CV_020_1_pim := by
  rw [CV_1_c_000_def, Fplus_dV_c_020_def, ofLadj_mul, CV_020_1_pre_eq, CV_020_1_pim_eq]

def CV_020_2_pre : Polynomial ℚ := interpQ 17279915862 [24323167196310, 358442784268240, 708413161448797, 1160254267563583, 1733274983433837, 2060877103267854, 2334487585315015, 2494634185696102, 2379274107040530, 2351870955035194, 2331954634885087, 2299483379157606, 1973511850616847, 1643457793586397, 1219019839476947, 670396274556533, 357535362613067, 83924880565906, -90962927705732]
def CV_020_2_pim : Polynomial ℚ := interpQ 17279915862 [-244509076286110, -489018152572220, -570088436731066, -689321866074742, -526993487272581, -207453086176508, 55706720639015, 447778330203970, 676935475666273, 672724471972126, 655063162693470, 873530032005896, 1091996901318322, 1155405876198512, 1270428301848041, 1119864519184654, 822715744442325, 587072532534740, 217392549323529]
theorem CV_020_2_pre_eq :
    CV_2_re_000 * Fplus_dW_re_020 - CV_2_im_000 * Fplus_dW_im_020 = CV_020_2_pre := by
  simp only [CV_2_re_000_def, CV_2_im_000_def, Fplus_dW_re_020_def, Fplus_dW_im_020_def, CV_020_2_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_020_2_pim_eq :
    CV_2_re_000 * Fplus_dW_im_020 + CV_2_im_000 * Fplus_dW_re_020 = CV_020_2_pim := by
  simp only [CV_2_re_000_def, CV_2_im_000_def, Fplus_dW_re_020_def, Fplus_dW_im_020_def, CV_020_2_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_020_2_mul :
    CV_2_c_000 * Fplus_dW_c_020 = ofLadj CV_020_2_pre CV_020_2_pim := by
  rw [CV_2_c_000_def, Fplus_dW_c_020_def, ofLadj_mul, CV_020_2_pre_eq, CV_020_2_pim_eq]

theorem CV_020_3_mul : CV_3_c_010 = ofLadj CV_3_re_010 CV_3_im_010 := CV_3_c_010_def

@[expose] public def CV_coeff_020 : Ki := CV_0_c_000 * Fplus_dU_c_020 + CV_1_c_000 * Fplus_dV_c_020 + CV_2_c_000 * Fplus_dW_c_020 + CV_3_c_010

theorem CV_coeff_020_sum :
    CV_coeff_020 = ofLadj (CV_020_0_pre + CV_020_1_pre + CV_020_2_pre + CV_3_re_010) (CV_020_0_pim + CV_020_1_pim + CV_020_2_pim + CV_3_im_010) := by
  simp only [CV_coeff_020, CV_020_0_mul, CV_020_1_mul, CV_020_2_mul, CV_020_3_mul]
  simpa [add_assoc] using ofLadj_add4 CV_020_0_pre CV_020_0_pim CV_020_1_pre CV_020_1_pim CV_020_2_pre CV_020_2_pim CV_3_re_010 CV_3_im_010

def CV_020_qre : Polynomial ℚ := interpQ 17279915862 [41748637426521, 315313816367409, 325303254736343, 402200087990331, 469257706465934, 170081910550225, 143235280051293, 95047210722375, -117032377067746]
def CV_020_qim : Polynomial ℚ := interpQ 17279915862 [-186322684504922, -186322684504922, -4221338376186, -16998077155264, 257428761918604, 368140359370039, 228449514507050, 320369187402246, 182731983527821]
theorem CV_coeff_020_poly_re :
    CV_020_0_pre + CV_020_1_pre + CV_020_2_pre + CV_3_re_010 = (0 : Polynomial ℚ) + Phi11 * CV_020_qre := by
  rw [phi11_interpQ]
  simp only [CV_020_0_pre, CV_020_1_pre, CV_020_2_pre, CV_3_re_010_def, CV_020_qre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_coeff_020_poly_im :
    CV_020_0_pim + CV_020_1_pim + CV_020_2_pim + CV_3_im_010 = (0 : Polynomial ℚ) + Phi11 * CV_020_qim := by
  rw [phi11_interpQ]
  simp only [CV_020_0_pim, CV_020_1_pim, CV_020_2_pim, CV_3_im_010_def, CV_020_qim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
public theorem CV_coeff_020_eq :
    CV_coeff_020 = (0 : Ki) := by
  rw [CV_coeff_020_sum, CV_coeff_020_poly_re,
    CV_coeff_020_poly_im, ofLadj_add_Phi11]
  exact ofLadj_zero

end V14Formalization.D12SigmaPlusSegreCore
