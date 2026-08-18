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

def CW_031_0_pre : Polynomial ℚ := interpQ 8639957931 [6051707098220, -14758616231440, -18247483096504, -37028349740836, -62421285910800, -62386607174984, -82607946250280, -79947520831752, -76499208668556, -74525033460288, -73673320670244, -78847800013916, -58914704438804, -56277550363784, -39470858927720, -15363045381500, -16380791038324, 3840548036972, 2163189539452]
def CW_031_0_pim : Polynomial ℚ := interpQ 8639957931 [12914070220564, 25828140441128, 22251050802304, 41562715567428, 24302422164400, 21979674929260, 14522094141988, -2517889871332, -3553466344720, -3047289245848, -2129953335612, -13401808293532, -24673663251452, -20179237702392, -38984725368644, -22774355571480, -21427922216572, -16049323000612, 14347132476]
theorem CW_031_0_pre_eq :
    CW_0_re_020 * Fplus_dU_re_011 - CW_0_im_020 * Fplus_dU_im_011 = CW_031_0_pre := by
  simp only [CW_0_re_020_def, CW_0_im_020_def, Fplus_dU_re_011_def, Fplus_dU_im_011_def, CW_031_0_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_031_0_pim_eq :
    CW_0_re_020 * Fplus_dU_im_011 + CW_0_im_020 * Fplus_dU_re_011 = CW_031_0_pim := by
  simp only [CW_0_re_020_def, CW_0_im_020_def, Fplus_dU_re_011_def, Fplus_dU_im_011_def, CW_031_0_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_031_0_mul :
    CW_0_c_020 * Fplus_dU_c_011 = ofLadj CW_031_0_pre CW_031_0_pim := by
  rw [CW_0_c_020_def, Fplus_dU_c_011_def, ofLadj_mul, CW_031_0_pre_eq, CW_031_0_pim_eq]

def CW_031_1_pre : Polynomial ℚ := interpQ 8639957931 [-6174221031032, 13364134761152, 15327970445132, 38137492748196, 62397989703168, 58998187006660, 85919973385676, 79839184631244, 75370730889052, 73263353824152, 73977992599996, 77621998032232, 60613857838844, 57935383379020, 37233238140856, 12764133907640, 17710940590796, -9210845788220, -4677061020436]
def CW_031_1_pim : Polynomial ℚ := interpQ 8639957931 [-12031985023848, -24063970047696, -22017013092728, -43307902900888, -19252881314440, -21213946700932, -11963986694704, 9416021192920, 10617280947004, 9328146202316, 9698353462700, 20236583872896, 30774814283092, 29098064588508, 49099819651980, 26812884223376, 27777167095776, 21809963997956, -566826403760]
theorem CW_031_1_pre_eq :
    CW_1_re_020 * Fplus_dV_re_011 - CW_1_im_020 * Fplus_dV_im_011 = CW_031_1_pre := by
  simp only [CW_1_re_020_def, CW_1_im_020_def, Fplus_dV_re_011_def, Fplus_dV_im_011_def, CW_031_1_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_031_1_pim_eq :
    CW_1_re_020 * Fplus_dV_im_011 + CW_1_im_020 * Fplus_dV_re_011 = CW_031_1_pim := by
  simp only [CW_1_re_020_def, CW_1_im_020_def, Fplus_dV_re_011_def, Fplus_dV_im_011_def, CW_031_1_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_031_1_mul :
    CW_1_c_020 * Fplus_dV_c_011 = ofLadj CW_031_1_pre CW_031_1_pim := by
  rw [CW_1_c_020_def, Fplus_dV_c_011_def, ofLadj_mul, CW_031_1_pre_eq, CW_031_1_pim_eq]

def CW_031_2_pre : Polynomial ℚ := interpQ 8639957931 [2320097991600, 29100983552, 3226136393980, 4365189786012, 4454712995340, 6871782715088, 6025113929760, 8977069288332, 7197124434464, 7149080924464, 6141193365248, 5080065046184, 6112092381696, 3922944530484, 2831934648452, 3790422202808, 798082150684, 1644750936012, -731934090184]
def CW_031_2_pim : Polynomial ℚ := interpQ 8639957931 [549104702876, 1098209405752, -1801716284900, 2028521511604, 32944273564, 2601716410968, 2412604016156, 4338779544236, 6116995819448, 6589643364384, 5537466539804, 5015088701944, 4492710864084, 6340459730156, 2982869478588, 4691472309432, 3501801799768, 2612264582748, 2065190682408]
theorem CW_031_2_pre_eq :
    CW_2_re_020 * Fplus_dW_re_011 - CW_2_im_020 * Fplus_dW_im_011 = CW_031_2_pre := by
  simp only [CW_2_re_020_def, CW_2_im_020_def, Fplus_dW_re_011_def, Fplus_dW_im_011_def, CW_031_2_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_031_2_pim_eq :
    CW_2_re_020 * Fplus_dW_im_011 + CW_2_im_020 * Fplus_dW_re_011 = CW_031_2_pim := by
  simp only [CW_2_re_020_def, CW_2_im_020_def, Fplus_dW_re_011_def, Fplus_dW_im_011_def, CW_031_2_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_031_2_mul :
    CW_2_c_020 * Fplus_dW_c_011 = ofLadj CW_031_2_pre CW_031_2_pim := by
  rw [CW_2_c_020_def, Fplus_dW_c_011_def, ofLadj_mul, CW_031_2_pre_eq, CW_031_2_pim_eq]

theorem CW_031_3_mul : CW_3_c_030 = ofLadj CW_3_re_030 CW_3_im_030 := CW_3_c_030_def

@[expose] public def CW_coeff_031 : Ki := CW_0_c_020 * Fplus_dU_c_011 + CW_1_c_020 * Fplus_dV_c_011 + CW_2_c_020 * Fplus_dW_c_011 + CW_3_c_030

theorem CW_coeff_031_sum :
    CW_coeff_031 = ofLadj (CW_031_0_pre + CW_031_1_pre + CW_031_2_pre + CW_3_re_030) (CW_031_0_pim + CW_031_1_pim + CW_031_2_pim + CW_3_im_030) := by
  simp only [CW_coeff_031, CW_031_0_mul, CW_031_1_mul, CW_031_2_mul, CW_031_3_mul]
  simpa [add_assoc] using ofLadj_add4 CW_031_0_pre CW_031_0_pim CW_031_1_pre CW_031_1_pim CW_031_2_pre CW_031_2_pim CW_3_re_030 CW_3_im_030

def CW_031_qre : Polynomial ℚ := interpQ 8639957931 [2591602230500, -3956982717236, 2230468236016, 4986463684132, -597196867360, -936720974208, 5853778518392, -479741244068, -3245805571168]
def CW_031_qim : Polynomial ℚ := interpQ 8639957931 [1256002385584, 1256002385584, -4665424720548, 2161322854348, 4367962800596, -1121045717644, 1478141098880, 6860194168968, 1512711411124]
theorem CW_coeff_031_poly_re :
    CW_031_0_pre + CW_031_1_pre + CW_031_2_pre + CW_3_re_030 = (0 : Polynomial ℚ) + Phi11 * CW_031_qre := by
  rw [phi11_interpQ]
  simp only [CW_031_0_pre, CW_031_1_pre, CW_031_2_pre, CW_3_re_030_def, CW_031_qre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_coeff_031_poly_im :
    CW_031_0_pim + CW_031_1_pim + CW_031_2_pim + CW_3_im_030 = (0 : Polynomial ℚ) + Phi11 * CW_031_qim := by
  rw [phi11_interpQ]
  simp only [CW_031_0_pim, CW_031_1_pim, CW_031_2_pim, CW_3_im_030_def, CW_031_qim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
public theorem CW_coeff_031_eq :
    CW_coeff_031 = (0 : Ki) := by
  rw [CW_coeff_031_sum, CW_coeff_031_poly_re,
    CW_coeff_031_poly_im, ofLadj_add_Phi11]
  exact ofLadj_zero

end V14Formalization.D12SigmaPlusSegreCore
