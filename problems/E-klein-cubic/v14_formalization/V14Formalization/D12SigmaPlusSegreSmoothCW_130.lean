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

def CW_130_0_pre : Polynomial ℚ := interpQ 17279915862 [-1191732979423, 7900487308380, 12341931496250, 24059828729804, 40217164919346, 49760670538585, 63924584878387, 71122417038458, 72717633539773, 74517501309765, 77525038233857, 78139280907700, 69624550925477, 62175569813515, 48657804809969, 29295060342494, 18716589695178, 4552675355376, -1610191776618]
def CW_130_0_pim : Polynomial ℚ := interpQ 17279915862 [-7646842096393, -15293684192786, -19153974898008, -30068764082202, -28243613367968, -27899069230913, -24195823287155, -14855350549400, -9281394922111, -9622538432199, -7269181853841, 2658807481054, 12586796815949, 18800444099529, 29374089773635, 27449809754948, 23640658670394, 18478164616996, 5673084931742]
theorem CW_130_0_pre_eq :
    CW_0_re_110 * Fplus_dU_re_020 - CW_0_im_110 * Fplus_dU_im_020 = CW_130_0_pre := by
  simp only [CW_0_re_110_def, CW_0_im_110_def, Fplus_dU_re_020_def, Fplus_dU_im_020_def, CW_130_0_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_130_0_pim_eq :
    CW_0_re_110 * Fplus_dU_im_020 + CW_0_im_110 * Fplus_dU_re_020 = CW_130_0_pim := by
  simp only [CW_0_re_110_def, CW_0_im_110_def, Fplus_dU_re_020_def, Fplus_dU_im_020_def, CW_130_0_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_130_0_mul :
    CW_0_c_110 * Fplus_dU_c_020 = ofLadj CW_130_0_pre CW_130_0_pim := by
  rw [CW_0_c_110_def, Fplus_dU_c_020_def, ofLadj_mul, CW_130_0_pre_eq, CW_130_0_pim_eq]

def CW_130_1_pre : Polynomial ℚ := interpQ 17279915862 [4206599051236, -5903446492576, -4840328093144, -11917894632544, -26908254660464, -28176238507844, -41473246107440, -41082008287072, -35646405301988, -36217613526028, -31023063727176, -38276076600968, -25119617234600, -31377285432884, -23728510669444, -12941214150188, -11896506994764, 1400500604832, 1232539476420]
def CW_130_1_pim : Polynomial ℚ := interpQ 17279915862 [6789075873684, 13578151747368, 12262760159216, 25122849511944, 20222578554608, 18559217468724, 16382990008544, 1398051312040, 3473302631460, 1333960937196, 4467481723272, -637966123352, -5743413969976, -1294501595748, -16293932642740, -9184471464364, -13105058369956, -9534929606648, -133938901620]
theorem CW_130_1_pre_eq :
    CW_0_re_020 * Fplus_dU_re_110 - CW_0_im_020 * Fplus_dU_im_110 = CW_130_1_pre := by
  simp only [CW_0_re_020_def, CW_0_im_020_def, Fplus_dU_re_110_def, Fplus_dU_im_110_def, CW_130_1_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_130_1_pim_eq :
    CW_0_re_020 * Fplus_dU_im_110 + CW_0_im_020 * Fplus_dU_re_110 = CW_130_1_pim := by
  simp only [CW_0_re_020_def, CW_0_im_020_def, Fplus_dU_re_110_def, Fplus_dU_im_110_def, CW_130_1_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_130_1_mul :
    CW_0_c_020 * Fplus_dU_c_110 = ofLadj CW_130_1_pre CW_130_1_pim := by
  rw [CW_0_c_020_def, Fplus_dU_c_110_def, ofLadj_mul, CW_130_1_pre_eq, CW_130_1_pim_eq]

def CW_130_2_pre : Polynomial ℚ := interpQ 17279915862 [114739548237, -4582930317732, -7120865498040, -12091608851760, -19058143922070, -19999561870908, -24623937446022, -27492769743900, -28197062610258, -30541656308880, -32198316616749, -32915992004538, -27615386299017, -23420790810840, -16105453758498, -7005486219864, -4870399701552, -246024126438, 1429139601966]
def CW_130_2_pim : Polynomial ℚ := interpQ 17279915862 [2921701222701, 5843402445402, 5830321025490, 9145803930960, 5825879506956, 3587377187112, 3282048539364, -591510498096, -2204566026918, -2612585395074, -4230988012419, -9255261912918, -14279535813417, -15884857010850, -19608359284476, -15216455097132, -11034516615336, -8502030491574, -2685035292162]
theorem CW_130_2_pre_eq :
    CW_1_re_110 * Fplus_dV_re_020 - CW_1_im_110 * Fplus_dV_im_020 = CW_130_2_pre := by
  simp only [CW_1_re_110_def, CW_1_im_110_def, Fplus_dV_re_020_def, Fplus_dV_im_020_def, CW_130_2_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_130_2_pim_eq :
    CW_1_re_110 * Fplus_dV_im_020 + CW_1_im_110 * Fplus_dV_re_020 = CW_130_2_pim := by
  simp only [CW_1_re_110_def, CW_1_im_110_def, Fplus_dV_re_020_def, Fplus_dV_im_020_def, CW_130_2_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_130_2_mul :
    CW_1_c_110 * Fplus_dV_c_020 = ofLadj CW_130_2_pre CW_130_2_pim := by
  rw [CW_1_c_110_def, Fplus_dV_c_020_def, ofLadj_mul, CW_130_2_pre_eq, CW_130_2_pim_eq]

def CW_130_3_pre : Polynomial ℚ := interpQ 17279915862 [3564401042700, -4772905271840, -2585646952612, -12448743835508, -22319205197896, -22822926777720, -37461268954764, -37295934628996, -38338007499136, -37816090738968, -41884424045572, -42363916421720, -37111518773732, -35230443786356, -25889263663628, -12508634335108, -12349687146436, 2288655030608, 2468095095992]
def CW_130_3_pim : Polynomial ℚ := interpQ 17279915862 [5456271645964, 10912543291928, 11132069702652, 23954249310100, 15687509157816, 21620111788640, 18143684013500, 10843287182252, 8883334941600, 10588827236656, 7645498090100, 1397970286648, -4849557516804, -8012413074084, -19129100386476, -12511949484012, -13745601081788, -12309710855128, -310362990832]
theorem CW_130_3_pre_eq :
    CW_1_re_020 * Fplus_dV_re_110 - CW_1_im_020 * Fplus_dV_im_110 = CW_130_3_pre := by
  simp only [CW_1_re_020_def, CW_1_im_020_def, Fplus_dV_re_110_def, Fplus_dV_im_110_def, CW_130_3_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_130_3_pim_eq :
    CW_1_re_020 * Fplus_dV_im_110 + CW_1_im_020 * Fplus_dV_re_110 = CW_130_3_pim := by
  simp only [CW_1_re_020_def, CW_1_im_020_def, Fplus_dV_re_110_def, Fplus_dV_im_110_def, CW_130_3_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_130_3_mul :
    CW_1_c_020 * Fplus_dV_c_110 = ofLadj CW_130_3_pre CW_130_3_pim := by
  rw [CW_1_c_020_def, Fplus_dV_c_110_def, ofLadj_mul, CW_130_3_pre_eq, CW_130_3_pim_eq]

def CW_130_4_pre : Polynomial ℚ := interpQ 17279915862 [5026850433060, 2378973426144, 10236454080042, 12949523149790, 14753919266776, 25054099169716, 20205713246435, 26257127699682, 25237315547915, 25640617556809, 24679560888906, 20645275122778, 22300587462762, 15404163476767, 12287792398125, 11203942215732, 625936358755, 5474322282036, -299266217174]
def CW_130_4_pim : Polynomial ℚ := interpQ 17279915862 [380608543788, 761217087576, -4019664139112, 4098558580000, -2413349387606, 5884707931760, 9122119588101, 10254685400386, 14838417761141, 15441080990225, 14947493004044, 14481854033272, 14016215062500, 18303508303007, 10787948812979, 16556195516970, 9347663910175, 5370433724084, 5327393624370]
theorem CW_130_4_pre_eq :
    CW_2_re_110 * Fplus_dW_re_020 - CW_2_im_110 * Fplus_dW_im_020 = CW_130_4_pre := by
  simp only [CW_2_re_110_def, CW_2_im_110_def, Fplus_dW_re_020_def, Fplus_dW_im_020_def, CW_130_4_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_130_4_pim_eq :
    CW_2_re_110 * Fplus_dW_im_020 + CW_2_im_110 * Fplus_dW_re_020 = CW_130_4_pim := by
  simp only [CW_2_re_110_def, CW_2_im_110_def, Fplus_dW_re_020_def, Fplus_dW_im_020_def, CW_130_4_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_130_4_mul :
    CW_2_c_110 * Fplus_dW_c_020 = ofLadj CW_130_4_pre CW_130_4_pim := by
  rw [CW_2_c_110_def, Fplus_dW_c_020_def, ofLadj_mul, CW_130_4_pre_eq, CW_130_4_pim_eq]

def CW_130_5_pre : Polynomial ℚ := interpQ 17279915862 [13949688933152, 291009835520, 22421333802784, 31559599015104, 30328536793176, 54239947338596, 44496233320572, 59196085280424, 53148485731996, 53339201115604, 51823164675036, 38022842376088, 51532154839516, 30917867312820, 21588886716892, 23864274356368, 640037306696, 10383751324720, -5003274130880]
def CW_130_5_pim : Polynomial ℚ := interpQ 17279915862 [5607450962968, 11214901925936, -6326570272648, 21570645934288, 9430652499696, 27529390071164, 36742730951996, 42115510259856, 56755517961220, 57335867009588, 56904309395236, 50310942428976, 43717575462716, 60827490046948, 33510622888380, 44861826156480, 28079730616416, 19484935144312, 15428797867856]
theorem CW_130_5_pre_eq :
    CW_2_re_020 * Fplus_dW_re_110 - CW_2_im_020 * Fplus_dW_im_110 = CW_130_5_pre := by
  simp only [CW_2_re_020_def, CW_2_im_020_def, Fplus_dW_re_110_def, Fplus_dW_im_110_def, CW_130_5_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_130_5_pim_eq :
    CW_2_re_020 * Fplus_dW_im_110 + CW_2_im_020 * Fplus_dW_re_110 = CW_130_5_pim := by
  simp only [CW_2_re_020_def, CW_2_im_020_def, Fplus_dW_re_110_def, Fplus_dW_im_110_def, CW_130_5_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_130_5_mul :
    CW_2_c_020 * Fplus_dW_c_110 = ofLadj CW_130_5_pre CW_130_5_pim := by
  rw [CW_2_c_020_def, Fplus_dW_c_110_def, ofLadj_mul, CW_130_5_pre_eq, CW_130_5_pim_eq]

@[expose] public def CW_coeff_130 : Ki := CW_0_c_110 * Fplus_dU_c_020 + CW_0_c_020 * Fplus_dU_c_110 + CW_1_c_110 * Fplus_dV_c_020 + CW_1_c_020 * Fplus_dV_c_110 + CW_2_c_110 * Fplus_dW_c_020 + CW_2_c_020 * Fplus_dW_c_110

theorem CW_coeff_130_sum :
    CW_coeff_130 = ofLadj (CW_130_0_pre + CW_130_1_pre + CW_130_2_pre + CW_130_3_pre + CW_130_4_pre + CW_130_5_pre) (CW_130_0_pim + CW_130_1_pim + CW_130_2_pim + CW_130_3_pim + CW_130_4_pim + CW_130_5_pim) := by
  simp only [CW_coeff_130, CW_130_0_mul, CW_130_1_mul, CW_130_2_mul, CW_130_3_mul, CW_130_4_mul, CW_130_5_mul]
  simpa [add_assoc] using ofLadj_add6 CW_130_0_pre CW_130_0_pim CW_130_1_pre CW_130_1_pim CW_130_2_pre CW_130_2_pim CW_130_3_pre CW_130_3_pim CW_130_4_pre CW_130_4_pim CW_130_5_pre CW_130_5_pim

def CW_130_qre : Polynomial ℚ := interpQ 17279915862 [25670546028962, -30359357541066, 35141690347384, 1657824739606, -15096686376018, 41041972691557, -32987910953257, 25636838421428, -1782957950294]
def CW_130_qim : Polynomial ℚ := interpQ 17279915862 [13508266152712, 13508266152712, -27291590727834, 54098401607500, -33313686221588, 28772078252985, 10196014597863, -10313076707312, 23299939239354]
theorem CW_coeff_130_poly_re :
    CW_130_0_pre + CW_130_1_pre + CW_130_2_pre + CW_130_3_pre + CW_130_4_pre + CW_130_5_pre = (0 : Polynomial ℚ) + Phi11 * CW_130_qre := by
  rw [phi11_interpQ]
  simp only [CW_130_0_pre, CW_130_1_pre, CW_130_2_pre, CW_130_3_pre, CW_130_4_pre, CW_130_5_pre, CW_130_qre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_coeff_130_poly_im :
    CW_130_0_pim + CW_130_1_pim + CW_130_2_pim + CW_130_3_pim + CW_130_4_pim + CW_130_5_pim = (0 : Polynomial ℚ) + Phi11 * CW_130_qim := by
  rw [phi11_interpQ]
  simp only [CW_130_0_pim, CW_130_1_pim, CW_130_2_pim, CW_130_3_pim, CW_130_4_pim, CW_130_5_pim, CW_130_qim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
public theorem CW_coeff_130_eq :
    CW_coeff_130 = (0 : Ki) := by
  rw [CW_coeff_130_sum, CW_coeff_130_poly_re,
    CW_coeff_130_poly_im, ofLadj_add_Phi11]
  exact ofLadj_zero

end V14Formalization.D12SigmaPlusSegreCore
