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

def CU_200_0_pre : Polynomial ℚ := interpQ 471589998 [815848625079, 0, -753480536142, -2381525321139, -6867600354759, -11424374383632, -16399252637586, -20247999606312, -21634774111485, -22270132952625, -22748552298045, -23728127820225, -22748552298045, -21516652416483, -19253248790346, -14182844743032, -9296986265220, -4322108011266, -802445491479]
def CU_200_0_pim : Polynomial ℚ := interpQ 471589998 [2928934297899, 5857868595798, 9678587549256, 14720154432636, 17688546733836, 19349502063204, 19740986074170, 16702946390514, 14788808700453, 14697648440202, 14268596162370, 10739425758963, 7210255355556, 2960484124266, -2172243019365, -4870178906649, -5989231374021, -5764536649629, -2184594103977]
theorem CU_200_0_pre_eq :
    CU_0_re_000 * Fplus_dU_re_200 - CU_0_im_000 * Fplus_dU_im_200 = CU_200_0_pre := by
  simp only [CU_0_re_000_def, CU_0_im_000_def, Fplus_dU_re_200_def, Fplus_dU_im_200_def, CU_200_0_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_200_0_pim_eq :
    CU_0_re_000 * Fplus_dU_im_200 + CU_0_im_000 * Fplus_dU_re_200 = CU_200_0_pim := by
  simp only [CU_0_re_000_def, CU_0_im_000_def, Fplus_dU_re_200_def, Fplus_dU_im_200_def, CU_200_0_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_200_0_mul :
    CU_0_c_000 * Fplus_dU_c_200 = ofLadj CU_200_0_pre CU_200_0_pim := by
  rw [CU_0_c_000_def, Fplus_dU_c_200_def, ofLadj_mul, CU_200_0_pre_eq, CU_200_0_pim_eq]

def CU_200_1_pre : Polynomial ℚ := interpQ 471589998 [-85043316861, 13180881886288, 26372619408921, 42957836281027, 72621216094608, 92988105478952, 112110637969578, 120456215834099, 112133172025733, 106165298974342, 101619738903751, 99998978841658, 88438857017463, 79792679565421, 69175335744706, 44986920655877, 27880107934709, 8757575444083, -2848079083614]
def CU_200_1_pim : Polynomial ℚ := interpQ 471589998 [-12499061304340, -24998122608680, -32315563629897, -44315651955901, -44595810600703, -32735162221466, -19608788701630, 5537548023605, 19216638197532, 18353885271550, 14413502579510, 21130873335548, 27848244091586, 31225302420763, 42362637820785, 45151745375257, 38350047957685, 31257527027827, 11170141264257]
theorem CU_200_1_pre_eq :
    CU_1_re_000 * Fplus_dV_re_200 - CU_1_im_000 * Fplus_dV_im_200 = CU_200_1_pre := by
  simp only [CU_1_re_000_def, CU_1_im_000_def, Fplus_dV_re_200_def, Fplus_dV_im_200_def, CU_200_1_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_200_1_pim_eq :
    CU_1_re_000 * Fplus_dV_im_200 + CU_1_im_000 * Fplus_dV_re_200 = CU_200_1_pim := by
  simp only [CU_1_re_000_def, CU_1_im_000_def, Fplus_dV_re_200_def, Fplus_dV_im_200_def, CU_200_1_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_200_1_mul :
    CU_1_c_000 * Fplus_dV_c_200 = ofLadj CU_200_1_pre CU_200_1_pim := by
  rw [CU_1_c_000_def, Fplus_dV_c_200_def, ofLadj_mul, CU_200_1_pre_eq, CU_200_1_pim_eq]

def CU_200_2_pre : Polynomial ℚ := interpQ 471589998 [-11909429021800, -85314853781248, -160790059398816, -252593197541396, -359755569488326, -412505439942214, -451358693779044, -469617992335981, -435143717819701, -428540485927170, -423516506511159, -409737075623306, -338201652729911, -267750426528354, -182550520278305, -81447442069821, -32286732728048, 6566521108782, 28414980777834]
def CU_200_2_pim : Polynomial ℚ := interpQ 471589998 [38272593116976, 76545186233952, 72679194264868, 72498551208126, 19982310606942, -61938219220237, -124503664898691, -204039354333123, -248276988593915, -247323075407682, -242953640437810, -274844306900976, -306734973364142, -298499546425186, -297364990182211, -247628154904613, -171308478901095, -115393064547977, -41458228937206]
theorem CU_200_2_pre_eq :
    CU_2_re_000 * Fplus_dW_re_200 - CU_2_im_000 * Fplus_dW_im_200 = CU_200_2_pre := by
  simp only [CU_2_re_000_def, CU_2_im_000_def, Fplus_dW_re_200_def, Fplus_dW_im_200_def, CU_200_2_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_200_2_pim_eq :
    CU_2_re_000 * Fplus_dW_im_200 + CU_2_im_000 * Fplus_dW_re_200 = CU_200_2_pim := by
  simp only [CU_2_re_000_def, CU_2_im_000_def, Fplus_dW_re_200_def, Fplus_dW_im_200_def, CU_200_2_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_200_2_mul :
    CU_2_c_000 * Fplus_dW_c_200 = ofLadj CU_200_2_pre CU_200_2_pim := by
  rw [CU_2_c_000_def, Fplus_dW_c_200_def, ofLadj_mul, CU_200_2_pre_eq, CU_200_2_pim_eq]

theorem CU_200_3_mul : CU_3_c_100 = ofLadj CU_3_re_100 CU_3_im_100 := CU_3_c_100_def

@[expose] public def CU_coeff_200 : Ki := CU_0_c_000 * Fplus_dU_c_200 + CU_1_c_000 * Fplus_dV_c_200 + CU_2_c_000 * Fplus_dW_c_200 + CU_3_c_100

theorem CU_coeff_200_sum :
    CU_coeff_200 = ofLadj (CU_200_0_pre + CU_200_1_pre + CU_200_2_pre + CU_3_re_100) (CU_200_0_pim + CU_200_1_pim + CU_200_2_pim + CU_3_im_100) := by
  simp only [CU_coeff_200, CU_200_0_mul, CU_200_1_mul, CU_200_2_mul, CU_200_3_mul]
  simpa [add_assoc] using ofLadj_add4 CU_200_0_pre CU_200_0_pim CU_200_1_pre CU_200_1_pim CU_200_2_pre CU_200_2_pim CU_3_re_100 CU_3_im_100

def CU_200_qre : Polynomial ℚ := interpQ 471589998 [-11179095303580, -60954876591380, -63036948631077, -76845966055471, -81985067166969, -36939755098417, -24705599600158, -13762467661142, 24764456202741]
def CU_200_qim : Polynomial ℚ := interpQ 471589998 [28702466110535, 28702466110535, -7362714036843, -7139164499366, -49828006944786, -68398926118574, -49047588147652, -57427392392853, -32472681776926]
theorem CU_coeff_200_poly_re :
    CU_200_0_pre + CU_200_1_pre + CU_200_2_pre + CU_3_re_100 = (0 : Polynomial ℚ) + Phi11 * CU_200_qre := by
  rw [phi11_interpQ]
  simp only [CU_200_0_pre, CU_200_1_pre, CU_200_2_pre, CU_3_re_100_def, CU_200_qre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_coeff_200_poly_im :
    CU_200_0_pim + CU_200_1_pim + CU_200_2_pim + CU_3_im_100 = (0 : Polynomial ℚ) + Phi11 * CU_200_qim := by
  rw [phi11_interpQ]
  simp only [CU_200_0_pim, CU_200_1_pim, CU_200_2_pim, CU_3_im_100_def, CU_200_qim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
public theorem CU_coeff_200_eq :
    CU_coeff_200 = (0 : Ki) := by
  rw [CU_coeff_200_sum, CU_coeff_200_poly_re,
    CU_coeff_200_poly_im, ofLadj_add_Phi11]
  exact ofLadj_zero

end V14Formalization.D12SigmaPlusSegreCore
