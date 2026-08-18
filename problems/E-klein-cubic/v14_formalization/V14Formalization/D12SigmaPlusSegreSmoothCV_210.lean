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

def CV_210_0_pre : Polynomial ℚ := interpQ 8639957931 [-118849599187, 1914919288952, 3633811161092, 5973205137598, 10355169178714, 13181324917031, 15979916814099, 17087349559837, 15890332879602, 15076437795945, 14321258265442, 14231753146456, 12406338976490, 11442626634853, 9917127742004, 6324249735186, 3918941482175, 1120349585107, -407930645937]
def CV_210_0_pim : Polynomial ℚ := interpQ 8639957931 [-1846291355383, -3692582710766, -4629440092321, -6570631438621, -6570730749500, -4843090525079, -3030666199148, 633582034501, 2413286609079, 2391612452241, 1798402803047, 2788986420150, 3779570037253, 4123217769614, 6042734959076, 6343301051957, 5415760781595, 4343386072166, 1479237792576]
theorem CV_210_0_pre_eq :
    CV_0_re_100 * Fplus_dU_re_110 - CV_0_im_100 * Fplus_dU_im_110 = CV_210_0_pre := by
  simp only [CV_0_re_100_def, CV_0_im_100_def, Fplus_dU_re_110_def, Fplus_dU_im_110_def, CV_210_0_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_210_0_pim_eq :
    CV_0_re_100 * Fplus_dU_im_110 + CV_0_im_100 * Fplus_dU_re_110 = CV_210_0_pim := by
  simp only [CV_0_re_100_def, CV_0_im_100_def, Fplus_dU_re_110_def, Fplus_dU_im_110_def, CV_210_0_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_210_0_mul :
    CV_0_c_100 * Fplus_dU_c_110 = ofLadj CV_210_0_pre CV_210_0_pim := by
  rw [CV_0_c_100_def, Fplus_dU_c_110_def, ofLadj_mul, CV_210_0_pre_eq, CV_210_0_pim_eq]

def CV_210_1_pre : Polynomial ℚ := interpQ 8639957931 [-174804263555, 19637307150000, 36941544030954, 63837545306061, 104210995516254, 134280635800299, 163927126580569, 187643836993390, 190747099859800, 197362585605872, 202582928067286, 204573812970138, 182945620917286, 160421041574918, 126909554553739, 80395603921076, 46770855037727, 17124364257457, -3037237556060]
def CV_210_1_pim : Polynomial ℚ := interpQ 8639957931 [-18187043739575, -36374087479150, -48944205300610, -68941692992570, -71937697582755, -64157039214067, -56383537044029, -33620114914590, -17457729785202, -16588047314456, -12150289661935, 12522564066180, 37195417794295, 54203293268276, 75070463430982, 75284255958063, 61792528120853, 47419088790453, 18944597192492]
theorem CV_210_1_pre_eq :
    CV_1_re_100 * Fplus_dV_re_110 - CV_1_im_100 * Fplus_dV_im_110 = CV_210_1_pre := by
  simp only [CV_1_re_100_def, CV_1_im_100_def, Fplus_dV_re_110_def, Fplus_dV_im_110_def, CV_210_1_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_210_1_pim_eq :
    CV_1_re_100 * Fplus_dV_im_110 + CV_1_im_100 * Fplus_dV_re_110 = CV_210_1_pim := by
  simp only [CV_1_re_100_def, CV_1_im_100_def, Fplus_dV_re_110_def, Fplus_dV_im_110_def, CV_210_1_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_210_1_mul :
    CV_1_c_100 * Fplus_dV_c_110 = ofLadj CV_210_1_pre CV_210_1_pim := by
  rw [CV_1_c_100_def, Fplus_dV_c_110_def, ofLadj_mul, CV_210_1_pre_eq, CV_210_1_pim_eq]

def CV_210_2_pre : Polynomial ℚ := interpQ 8639957931 [3599868538806, 50403848204280, 102266735497521, 167709010581188, 249875147387861, 296667364485689, 334682791964265, 355493725328567, 338921304042466, 332524865367347, 327626133638444, 322232125540730, 277222285434164, 230258129869826, 171212293461278, 94926441194917, 51592090908139, 13576663429563, -10692136745789]
def CV_210_2_pim : Polynomial ℚ := interpQ 8639957931 [-33992764552678, -67985529105356, -80221220500105, -94839172906420, -71354362490551, -25318483763355, 11644546036095, 65836119003076, 97089136508103, 96147730963007, 91922834398420, 119716116332724, 147509398267028, 155520193097190, 169196739958409, 148451635881648, 107807755731685, 77312885555667, 28513311165919]
theorem CV_210_2_pre_eq :
    CV_2_re_100 * Fplus_dW_re_110 - CV_2_im_100 * Fplus_dW_im_110 = CV_210_2_pre := by
  simp only [CV_2_re_100_def, CV_2_im_100_def, Fplus_dW_re_110_def, Fplus_dW_im_110_def, CV_210_2_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_210_2_pim_eq :
    CV_2_re_100 * Fplus_dW_im_110 + CV_2_im_100 * Fplus_dW_re_110 = CV_210_2_pim := by
  simp only [CV_2_re_100_def, CV_2_im_100_def, Fplus_dW_re_110_def, Fplus_dW_im_110_def, CV_210_2_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_210_2_mul :
    CV_2_c_100 * Fplus_dW_c_110 = ofLadj CV_210_2_pre CV_210_2_pim := by
  rw [CV_2_c_100_def, Fplus_dW_c_110_def, ofLadj_mul, CV_210_2_pre_eq, CV_210_2_pim_eq]

theorem CV_210_3_mul : CV_3_c_200 = ofLadj CV_3_re_200 CV_3_im_200 := CV_3_c_200_def

@[expose] public def CV_coeff_210 : Ki := CV_0_c_100 * Fplus_dU_c_110 + CV_1_c_100 * Fplus_dV_c_110 + CV_2_c_100 * Fplus_dW_c_110 + CV_3_c_200

theorem CV_coeff_210_sum :
    CV_coeff_210 = ofLadj (CV_210_0_pre + CV_210_1_pre + CV_210_2_pre + CV_3_re_200) (CV_210_0_pim + CV_210_1_pim + CV_210_2_pim + CV_3_im_200) := by
  simp only [CV_coeff_210, CV_210_0_mul, CV_210_1_mul, CV_210_2_mul, CV_210_3_mul]
  simpa [add_assoc] using ofLadj_add4 CV_210_0_pre CV_210_0_pim CV_210_1_pre CV_210_1_pim CV_210_2_pre CV_210_2_pim CV_3_re_200 CV_3_im_200

def CV_210_qre : Polynomial ℚ := interpQ 8639957931 [3492628313848, 68463446329384, 70452447248343, 94082822322576, 126392680905842, 79364407423138, 70460510155914, 45958682219913, -14137304947786]
def CV_210_qim : Polynomial ℚ := interpQ 8639957931 [-53456719279522, -53456719279522, -25362318036504, -36463234213387, 20230745456799, 55063148257535, 45940684215847, 80138214267299, 48937146150987]
theorem CV_coeff_210_poly_re :
    CV_210_0_pre + CV_210_1_pre + CV_210_2_pre + CV_3_re_200 = (0 : Polynomial ℚ) + Phi11 * CV_210_qre := by
  rw [phi11_interpQ]
  simp only [CV_210_0_pre, CV_210_1_pre, CV_210_2_pre, CV_3_re_200_def, CV_210_qre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_coeff_210_poly_im :
    CV_210_0_pim + CV_210_1_pim + CV_210_2_pim + CV_3_im_200 = (0 : Polynomial ℚ) + Phi11 * CV_210_qim := by
  rw [phi11_interpQ]
  simp only [CV_210_0_pim, CV_210_1_pim, CV_210_2_pim, CV_3_im_200_def, CV_210_qim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
public theorem CV_coeff_210_eq :
    CV_coeff_210 = (0 : Ki) := by
  rw [CV_coeff_210_sum, CV_coeff_210_poly_re,
    CV_coeff_210_poly_im, ofLadj_add_Phi11]
  exact ofLadj_zero

end V14Formalization.D12SigmaPlusSegreCore
