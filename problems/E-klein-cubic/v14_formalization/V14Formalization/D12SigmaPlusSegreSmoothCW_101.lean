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

def CW_101_0_pre : Polynomial ℚ := interpQ 17279915862 [-13577583499124, -100310032074080, -188581341237720, -298196577416565, -425025355409024, -485308682896382, -533601674706857, -553394737788451, -512218964782719, -504504522143393, -498458775928882, -482717243029122, -398148743854802, -315923180905673, -214022387366154, -94387677679819, -38429949707278, 9863042103197, 33981704699608]
def CW_101_0_pim : Polynomial ℚ := interpQ 17279915862 [45282878374044, 90565756748088, 86102124867516, 87307822200421, 22792239816586, -72363219579226, -146347891844579, -242065116424249, -293110174049885, -292034276589163, -286878399702098, -324581865826644, -362285331951190, -352665823183553, -352795623055736, -291439935454933, -203013376378802, -136873487102593, -47885162842604]
theorem CW_101_0_pre_eq :
    CW_0_re_000 * Fplus_dU_re_101 - CW_0_im_000 * Fplus_dU_im_101 = CW_101_0_pre := by
  simp only [CW_0_re_000_def, CW_0_im_000_def, Fplus_dU_re_101_def, Fplus_dU_im_101_def, CW_101_0_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_101_0_pim_eq :
    CW_0_re_000 * Fplus_dU_im_101 + CW_0_im_000 * Fplus_dU_re_101 = CW_101_0_pim := by
  simp only [CW_0_re_000_def, CW_0_im_000_def, Fplus_dU_re_101_def, Fplus_dU_im_101_def, CW_101_0_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_101_0_mul :
    CW_0_c_000 * Fplus_dU_c_101 = ofLadj CW_101_0_pre CW_101_0_pim := by
  rw [CW_0_c_000_def, Fplus_dU_c_101_def, ofLadj_mul, CW_101_0_pre_eq, CW_101_0_pim_eq]

def CW_101_1_pre : Polynomial ℚ := interpQ 17279915862 [5036555851342, 86899520812600, 175646603393354, 288709226315934, 431019307659810, 510838055538587, 577222016701431, 612451600256043, 583680297760322, 572572963792399, 564164223229674, 555926224154662, 477264702417074, 396926360399045, 294971071444388, 162767937938789, 88975072178292, 22591111015448, -18664354657444]
def CW_101_1_pim : Polynomial ℚ := interpQ 17279915862 [-59093180967480, -118186361934960, -138478111929254, -165230448279438, -123687581115358, -44457275259353, 18884620638617, 113067263564357, 166729113197112, 165097718539333, 157758519797072, 206155088348350, 254551656899628, 267504208151661, 292625149844066, 255846471008375, 185956032789860, 133740436592616, 48897661304366]
theorem CW_101_1_pre_eq :
    CW_1_re_000 * Fplus_dV_re_101 - CW_1_im_000 * Fplus_dV_im_101 = CW_101_1_pre := by
  simp only [CW_1_re_000_def, CW_1_im_000_def, Fplus_dV_re_101_def, Fplus_dV_im_101_def, CW_101_1_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_101_1_pim_eq :
    CW_1_re_000 * Fplus_dV_im_101 + CW_1_im_000 * Fplus_dV_re_101 = CW_101_1_pim := by
  simp only [CW_1_re_000_def, CW_1_im_000_def, Fplus_dV_re_101_def, Fplus_dV_im_101_def, CW_101_1_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_101_1_mul :
    CW_1_c_000 * Fplus_dV_c_101 = ofLadj CW_101_1_pre CW_101_1_pim := by
  rw [CW_1_c_000_def, Fplus_dV_c_101_def, ofLadj_mul, CW_101_1_pre_eq, CW_101_1_pim_eq]

def CW_101_2_pre : Polynomial ℚ := interpQ 17279915862 [4403395646524, 60135567262960, 119780344410932, 197258111792158, 297634113979142, 358395866385108, 417375153096759, 454424213358436, 446192793532069, 452318002456388, 456824946271096, 454076808096900, 396689379008136, 332537658045456, 248934681739911, 143016105171278, 79119368213917, 20140081502266, -13773994208016]
def CW_101_2_pim : Polynomial ℚ := interpQ 17279915862 [-42792660798344, -85585321596688, -105843466680788, -131706559473620, -112190421373596, -68847254503344, -33439601112815, 31879170432114, 67772882490581, 68654343934028, 72664960145630, 121251099514204, 169837238882778, 194106000178480, 220850554414759, 198725232470066, 150324918896929, 108878814150950, 38502895903136]
theorem CW_101_2_pre_eq :
    CW_2_re_000 * Fplus_dW_re_101 - CW_2_im_000 * Fplus_dW_im_101 = CW_101_2_pre := by
  simp only [CW_2_re_000_def, CW_2_im_000_def, Fplus_dW_re_101_def, Fplus_dW_im_101_def, CW_101_2_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_101_2_pim_eq :
    CW_2_re_000 * Fplus_dW_im_101 + CW_2_im_000 * Fplus_dW_re_101 = CW_101_2_pim := by
  simp only [CW_2_re_000_def, CW_2_im_000_def, Fplus_dW_re_101_def, Fplus_dW_im_101_def, CW_101_2_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_101_2_mul :
    CW_2_c_000 * Fplus_dW_c_101 = ofLadj CW_101_2_pre CW_101_2_pim := by
  rw [CW_2_c_000_def, Fplus_dW_c_101_def, ofLadj_mul, CW_101_2_pre_eq, CW_101_2_pim_eq]

def CW_101_3_pre : Polynomial ℚ := interpQ 17279915862 [-617763649294, 0, 2143949466494, 4876267062216, 7505961911712, 8940663859644, 8940663859644, 7505961911712, 4876267062216, 2143949466494]
def CW_101_3_pim : Polynomial ℚ := interpQ 17279915862 [-2676278403526, -5352556807052, -7179851163458, -7505815409848, -6500925110536, -4054745725460, -1297811081592, 1148368303484, 2153258602796, 1827294356406]
theorem CW_101_3_neg_re : -CW_3_re_101 = CW_101_3_pre := by
  simp only [CW_3_re_101_def, CW_101_3_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_101_3_neg_im : -CW_3_im_101 = CW_101_3_pim := by
  simp only [CW_3_im_101_def, CW_101_3_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_101_3_mul : -CW_3_c_101 = ofLadj CW_101_3_pre CW_101_3_pim := by
  rw [CW_3_c_101_def, ofLadj_neg, CW_101_3_neg_re, CW_101_3_neg_im]

@[expose] public def CW_coeff_101 : Ki := CW_0_c_000 * Fplus_dU_c_101 + CW_1_c_000 * Fplus_dV_c_101 + CW_2_c_000 * Fplus_dW_c_101 + (-CW_3_c_101)

theorem CW_coeff_101_sum :
    CW_coeff_101 = ofLadj (CW_101_0_pre + CW_101_1_pre + CW_101_2_pre + CW_101_3_pre) (CW_101_0_pim + CW_101_1_pim + CW_101_2_pim + CW_101_3_pim) := by
  simp only [CW_coeff_101, CW_101_0_mul, CW_101_1_mul, CW_101_2_mul, CW_101_3_mul]
  simpa [add_assoc] using ofLadj_add4 CW_101_0_pre CW_101_0_pim CW_101_1_pre CW_101_1_pim CW_101_2_pre CW_101_2_pim CW_101_3_pre CW_101_3_pim

def CW_101_qre : Polynomial ℚ := interpQ 17279915862 [-4755395650552, 51480451652032, 62264500031580, 83657471720683, 118487000387897, 81731874745317, 77070256064020, 51050878786763, 1543355834148]
def CW_101_qim : Polynomial ℚ := interpQ 17279915862 [-59279241795306, -59279241795306, -46840821315372, -51735696056501, -2451686820419, 29864192715521, 27521811667014, 66230369276075, 39515394364898]
theorem CW_coeff_101_poly_re :
    CW_101_0_pre + CW_101_1_pre + CW_101_2_pre + CW_101_3_pre = (0 : Polynomial ℚ) + Phi11 * CW_101_qre := by
  rw [phi11_interpQ]
  simp only [CW_101_0_pre, CW_101_1_pre, CW_101_2_pre, CW_101_3_pre, CW_101_qre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_coeff_101_poly_im :
    CW_101_0_pim + CW_101_1_pim + CW_101_2_pim + CW_101_3_pim = (0 : Polynomial ℚ) + Phi11 * CW_101_qim := by
  rw [phi11_interpQ]
  simp only [CW_101_0_pim, CW_101_1_pim, CW_101_2_pim, CW_101_3_pim, CW_101_qim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
public theorem CW_coeff_101_eq :
    CW_coeff_101 = (0 : Ki) := by
  rw [CW_coeff_101_sum, CW_coeff_101_poly_re,
    CW_coeff_101_poly_im, ofLadj_add_Phi11]
  exact ofLadj_zero

end V14Formalization.D12SigmaPlusSegreCore
