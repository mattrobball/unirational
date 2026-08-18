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

def CU_002_0_pre : Polynomial ℚ := interpQ 235794999 [-646362759319, -9112240037908, -18269361732289, -30358707705439, -45707450512584, -54957491866923, -64222246824125, -69825751731434, -68407231446524, -69359499999239, -70049710887883, -69656062719580, -60937470849975, -51090138266950, -38048523741085, -21844419180748, -12108423352750, -2843668395548, 2273882038102]
def CU_002_0_pim : Polynomial ℚ := interpQ 235794999 [6492417526415, 12984835052830, 16233512545247, 20172191587780, 16925903593269, 10349095709124, 4847000980406, -5418879433005, -10962418299647, -11108608055518, -11738714360840, -19116165648148, -26493616935456, -30372400733195, -34457269531599, -30795290704182, -23432742215139, -17010850717857, -5959229699548]
theorem CU_002_0_pre_eq :
    CU_0_re_000 * Fplus_dU_re_002 - CU_0_im_000 * Fplus_dU_im_002 = CU_002_0_pre := by
  simp only [CU_0_re_000_def, CU_0_im_000_def, Fplus_dU_re_002_def, Fplus_dU_im_002_def, CU_002_0_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_002_0_pim_eq :
    CU_0_re_000 * Fplus_dU_im_002 + CU_0_im_000 * Fplus_dU_re_002 = CU_002_0_pim := by
  simp only [CU_0_re_000_def, CU_0_im_000_def, Fplus_dU_re_002_def, Fplus_dU_im_002_def, CU_002_0_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_002_0_mul :
    CU_0_c_000 * Fplus_dU_c_002 = ofLadj CU_002_0_pre CU_002_0_pim := by
  rw [CU_0_c_000_def, Fplus_dU_c_002_def, ofLadj_mul, CU_002_0_pre_eq, CU_002_0_pim_eq]

def CU_002_1_pre : Polynomial ℚ := interpQ 235794999 [-283969071890, 6590440943144, 14077497232750, 24042832269383, 38281614279966, 49540968203914, 58331060090645, 60941269358402, 55074128534284, 50951601363535, 47796282950056, 46906052422952, 41205842006912, 36874104130785, 31031296264901, 20585875421799, 11582687877475, 2792595990744, -2073779656637]
def CU_002_1_pim : Polynomial ℚ := interpQ 235794999 [-7073335770063, -14146671540126, -17543796913891, -22259329589062, -21822406875953, -15383783030079, -6508248978015, 5711710198929, 12461632521597, 11870937727334, 9141672926276, 12213046903560, 15284420880844, 15952281453551, 20077119334459, 21367258292939, 18438502172599, 13732952102489, 5022860651079]
theorem CU_002_1_pre_eq :
    CU_1_re_000 * Fplus_dV_re_002 - CU_1_im_000 * Fplus_dV_im_002 = CU_002_1_pre := by
  simp only [CU_1_re_000_def, CU_1_im_000_def, Fplus_dV_re_002_def, Fplus_dV_im_002_def, CU_002_1_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_002_1_pim_eq :
    CU_1_re_000 * Fplus_dV_im_002 + CU_1_im_000 * Fplus_dV_re_002 = CU_002_1_pim := by
  simp only [CU_1_re_000_def, CU_1_im_000_def, Fplus_dV_re_002_def, Fplus_dV_im_002_def, CU_002_1_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_002_1_mul :
    CU_1_c_000 * Fplus_dV_c_002 = ofLadj CU_002_1_pre CU_002_1_pim := by
  rw [CU_1_c_000_def, Fplus_dV_c_002_def, ofLadj_mul, CU_002_1_pre_eq, CU_002_1_pim_eq]

def CU_002_2_pre : Polynomial ℚ := interpQ 235794999 [-2354821105878, 0, 6305653896165, 14523130519725, 22091454338796, 26609170758729, 26609170758729, 22091454338796, 14523130519725, 6305653896165]
def CU_002_2_pim : Polynomial ℚ := interpQ 235794999 [-7998267541992, -15996535083984, -21432993424308, -22606380238398, -19171483192269, -12167222064189, -3829313019795, 3174948108285, 6609845154414, 5436458340324]
theorem CU_002_2_pre_eq :
    CU_2_re_000 * Fplus_dW_re_002 - CU_2_im_000 * Fplus_dW_im_002 = CU_002_2_pre := by
  simp only [CU_2_re_000_def, CU_2_im_000_def, Fplus_dW_re_002_def, Fplus_dW_im_002_def, CU_002_2_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_002_2_pim_eq :
    CU_2_re_000 * Fplus_dW_im_002 + CU_2_im_000 * Fplus_dW_re_002 = CU_002_2_pim := by
  simp only [CU_2_re_000_def, CU_2_im_000_def, Fplus_dW_re_002_def, Fplus_dW_im_002_def, CU_002_2_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_002_2_mul :
    CU_2_c_000 * Fplus_dW_c_002 = ofLadj CU_002_2_pre CU_002_2_pim := by
  rw [CU_2_c_000_def, Fplus_dW_c_002_def, ofLadj_mul, CU_002_2_pre_eq, CU_002_2_pim_eq]

def CU_002_3_pre : Polynomial ℚ := interpQ 235794999 [3781735295888, 0, -10151183198288, -23443455545312, -35660502285056, -42920339558272, -42920339558272, -35660502285056, -23443455545312, -10151183198288]
def CU_002_3_pim : Polynomial ℚ := interpQ 235794999 [12885263095664, 25770526191328, 34566355638032, 36476627002256, 30898977451632, 19599107993120, 6171418198208, -5128451260304, -10706100810928, -8795829446704]
theorem CU_002_3_neg_re : -CU_3_re_002 = CU_002_3_pre := by
  simp only [CU_3_re_002_def, CU_002_3_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_002_3_neg_im : -CU_3_im_002 = CU_002_3_pim := by
  simp only [CU_3_im_002_def, CU_002_3_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_002_3_mul : -CU_3_c_002 = ofLadj CU_002_3_pre CU_002_3_pim := by
  rw [CU_3_c_002_def, ofLadj_neg, CU_002_3_neg_re, CU_002_3_neg_im]

@[expose] public def CU_coeff_002 : Ki := CU_0_c_000 * Fplus_dU_c_002 + CU_1_c_000 * Fplus_dV_c_002 + CU_2_c_000 * Fplus_dW_c_002 + (-CU_3_c_002)

theorem CU_coeff_002_sum :
    CU_coeff_002 = ofLadj (CU_002_0_pre + CU_002_1_pre + CU_002_2_pre + CU_002_3_pre) (CU_002_0_pim + CU_002_1_pim + CU_002_2_pim + CU_002_3_pim) := by
  simp only [CU_coeff_002, CU_002_0_mul, CU_002_1_mul, CU_002_2_mul, CU_002_3_mul]
  simpa [add_assoc] using ofLadj_add4 CU_002_0_pre CU_002_0_pim CU_002_1_pre CU_002_1_pim CU_002_2_pre CU_002_2_pim CU_002_3_pre CU_002_3_pim

def CU_002_qre : Polynomial ℚ := interpQ 235794999 [496582358801, -3018381453565, -5515594706898, -7198806659981, -5758683717235, -732808283674, -474663070471, -251174786269, 200102381465]
def CU_002_qim : Polynomial ℚ := interpQ 235794999 [4306077310024, 4306077310024, 3210923225032, -39969082504, -4952117785897, -4433792368703, -1716341427172, -2341529566899, -936369048469]
theorem CU_coeff_002_poly_re :
    CU_002_0_pre + CU_002_1_pre + CU_002_2_pre + CU_002_3_pre = (0 : Polynomial ℚ) + Phi11 * CU_002_qre := by
  rw [phi11_interpQ]
  simp only [CU_002_0_pre, CU_002_1_pre, CU_002_2_pre, CU_002_3_pre, CU_002_qre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_coeff_002_poly_im :
    CU_002_0_pim + CU_002_1_pim + CU_002_2_pim + CU_002_3_pim = (0 : Polynomial ℚ) + Phi11 * CU_002_qim := by
  rw [phi11_interpQ]
  simp only [CU_002_0_pim, CU_002_1_pim, CU_002_2_pim, CU_002_3_pim, CU_002_qim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
public theorem CU_coeff_002_eq :
    CU_coeff_002 = (0 : Ki) := by
  rw [CU_coeff_002_sum, CU_coeff_002_poly_re,
    CU_coeff_002_poly_im, ofLadj_add_Phi11]
  exact ofLadj_zero

end V14Formalization.D12SigmaPlusSegreCore
