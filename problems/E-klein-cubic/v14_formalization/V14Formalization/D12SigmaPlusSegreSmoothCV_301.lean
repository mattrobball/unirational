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

def CV_301_0_pre : Polynomial ℚ := interpQ 34559831724 [-3055463392104, 0, -611337046362, 2917218016926, 11193357503220, 19307451729378, 28610102167356, 35262370082733, 37963530773781, 37754800181835, 40435552161228, 42044830494810, 40435552161228, 38366137228197, 35046312756855, 24761387293647, 16608123370086, 7305472932108, 692374714134]
def CV_301_0_pim : Polynomial ℚ := interpQ 34559831724 [-5500778501952, -11001557003904, -18091593496818, -26516496065142, -34127402546310, -34830153943512, -37501538707026, -30344502527163, -28456285014795, -27130535911659, -27161160991824, -20169521173824, -13177881355824, -6118469943075, 3632181728385, 9084002846259, 10660412992212, 10330680306774, 4047302875662]
theorem CV_301_0_pre_eq :
    CV_0_re_101 * Fplus_dU_re_200 - CV_0_im_101 * Fplus_dU_im_200 = CV_301_0_pre := by
  simp only [CV_0_re_101_def, CV_0_im_101_def, Fplus_dU_re_200_def, Fplus_dU_im_200_def, CV_301_0_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_301_0_pim_eq :
    CV_0_re_101 * Fplus_dU_im_200 + CV_0_im_101 * Fplus_dU_re_200 = CV_301_0_pim := by
  simp only [CV_0_re_101_def, CV_0_im_101_def, Fplus_dU_re_200_def, Fplus_dU_im_200_def, CV_301_0_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_301_0_mul :
    CV_0_c_101 * Fplus_dU_c_200 = ofLadj CV_301_0_pre CV_301_0_pim := by
  rw [CV_0_c_101_def, Fplus_dU_c_200_def, ofLadj_mul, CV_301_0_pre_eq, CV_301_0_pim_eq]

def CV_301_1_pre : Polynomial ℚ := interpQ 34559831724 [2207930875743, -26516410369240, -50867502423984, -84974830793656, -145131356666839, -185432879560520, -224808231232176, -241054048952460, -223659682063327, -210209246017494, -202682622840545, -199702453070946, -176166212471305, -159341743593510, -138684851269671, -88736716961468, -55626315827798, -16250964156142, 7185975324153]
def CV_301_1_pim : Polynomial ℚ := interpQ 34559831724 [25726725778243, 51453451556486, 65790011534928, 90564073785818, 92314695290501, 66378825694198, 42872722303838, -11317144554442, -36273852344651, -35692647382158, -26890780130597, -41213755320898, -55536730511199, -61071423238080, -85264280526477, -90459280522930, -76653846198530, -63571760884816, -21512329298439]
theorem CV_301_1_pre_eq :
    CV_1_re_101 * Fplus_dV_re_200 - CV_1_im_101 * Fplus_dV_im_200 = CV_301_1_pre := by
  simp only [CV_1_re_101_def, CV_1_im_101_def, Fplus_dV_re_200_def, Fplus_dV_im_200_def, CV_301_1_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_301_1_pim_eq :
    CV_1_re_101 * Fplus_dV_im_200 + CV_1_im_101 * Fplus_dV_re_200 = CV_301_1_pim := by
  simp only [CV_1_re_101_def, CV_1_im_101_def, Fplus_dV_re_200_def, Fplus_dV_im_200_def, CV_301_1_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_301_1_mul :
    CV_1_c_101 * Fplus_dV_c_200 = ofLadj CV_301_1_pre CV_301_1_pim := by
  rw [CV_1_c_101_def, Fplus_dV_c_200_def, ofLadj_mul, CV_301_1_pre_eq, CV_301_1_pim_eq]

def CV_301_2_pre : Polynomial ℚ := interpQ 34559831724 [23845205786360, 171778065667520, 323694522209464, 509056420628262, 724747766677056, 830314022684218, 909393438480855, 945962676186993, 876305163233671, 863063457779784, 852856082623442, 825268961250262, 681078016955922, 539368935570320, 367248742605409, 163774574098509, 65438609548761, -13640806247876, -57440335411428]
def CV_301_2_pim : Polynomial ℚ := interpQ 34559831724 [-77149648379000, -154299296758000, -146532913431432, -146341591581794, -39751020344852, 124619799403308, 250438245942305, 411289075911059, 500210215287239, 498303261221610, 489532019050214, 553787055525224, 618042092000234, 601504466502270, 599406190587003, 498419083205125, 345305039980117, 232911728966718, 83317675521116]
theorem CV_301_2_pre_eq :
    CV_2_re_101 * Fplus_dW_re_200 - CV_2_im_101 * Fplus_dW_im_200 = CV_301_2_pre := by
  simp only [CV_2_re_101_def, CV_2_im_101_def, Fplus_dW_re_200_def, Fplus_dW_im_200_def, CV_301_2_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_301_2_pim_eq :
    CV_2_re_101 * Fplus_dW_im_200 + CV_2_im_101 * Fplus_dW_re_200 = CV_301_2_pim := by
  simp only [CV_2_re_101_def, CV_2_im_101_def, Fplus_dW_re_200_def, Fplus_dW_im_200_def, CV_301_2_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_301_2_mul :
    CV_2_c_101 * Fplus_dW_c_200 = ofLadj CV_301_2_pre CV_301_2_pim := by
  rw [CV_2_c_101_def, Fplus_dW_c_200_def, ofLadj_mul, CV_301_2_pre_eq, CV_301_2_pim_eq]

@[expose] public def CV_coeff_301 : Ki := CV_0_c_101 * Fplus_dU_c_200 + CV_1_c_101 * Fplus_dV_c_200 + CV_2_c_101 * Fplus_dW_c_200

theorem CV_coeff_301_sum :
    CV_coeff_301 = ofLadj (CV_301_0_pre + CV_301_1_pre + CV_301_2_pre) (CV_301_0_pim + CV_301_1_pim + CV_301_2_pim) := by
  simp only [CV_coeff_301, CV_301_0_mul, CV_301_1_mul, CV_301_2_mul]
  simpa [add_assoc] using ofLadj_add3 CV_301_0_pre CV_301_0_pim CV_301_1_pre CV_301_1_pim CV_301_2_pre CV_301_2_pim

def CV_301_qre : Polynomial ℚ := interpQ 34559831724 [22997673269999, 122263982028281, 126954027440838, 154783125112414, 163810959661905, 73378827339639, 49006714562959, 26975687901231, -49561985373141]
def CV_301_qim : Polynomial ℚ := interpQ 34559831724 [-56923701102709, -56923701102709, 15012906812096, 16540481532204, 100730286260457, 137732198754655, 99640958385123, 113817999290337, 65852649098339]
theorem CV_coeff_301_poly_re :
    CV_301_0_pre + CV_301_1_pre + CV_301_2_pre = (0 : Polynomial ℚ) + Phi11 * CV_301_qre := by
  rw [phi11_interpQ]
  simp only [CV_301_0_pre, CV_301_1_pre, CV_301_2_pre, CV_301_qre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_coeff_301_poly_im :
    CV_301_0_pim + CV_301_1_pim + CV_301_2_pim = (0 : Polynomial ℚ) + Phi11 * CV_301_qim := by
  rw [phi11_interpQ]
  simp only [CV_301_0_pim, CV_301_1_pim, CV_301_2_pim, CV_301_qim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
public theorem CV_coeff_301_eq :
    CV_coeff_301 = (0 : Ki) := by
  rw [CV_coeff_301_sum, CV_coeff_301_poly_re,
    CV_coeff_301_poly_im, ofLadj_add_Phi11]
  exact ofLadj_zero

end V14Formalization.D12SigmaPlusSegreCore
