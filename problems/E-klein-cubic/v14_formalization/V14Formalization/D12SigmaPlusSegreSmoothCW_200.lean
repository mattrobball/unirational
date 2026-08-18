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

def CW_200_0_pre : Polynomial ℚ := interpQ 34559831724 [-8624943389547, 0, 6631721306250, 20908815080775, 64348575202053, 107758847724993, 153559912067463, 190082968522332, 203676080732781, 209548770320115, 214107760636227, 224254804265427, 214107760636227, 202917049013865, 182767265652006, 133787728990314, 87087899310342, 41286834967872, 8053335670035]
def CW_200_0_pim : Polynomial ℚ := interpQ 34559831724 [-28212196520835, -56424393041670, -91769034061392, -140224313828184, -169244935836744, -184157113646853, -187687103035725, -160018634554278, -142207727242920, -141319779464046, -137329903613580, -103444720576395, -69559537539210, -30225020669022, 19118206876644, 45746825748477, 55447047434451, 53083335053667, 20202910448085]
theorem CW_200_0_pre_eq :
    CW_0_re_000 * Fplus_dU_re_200 - CW_0_im_000 * Fplus_dU_im_200 = CW_200_0_pre := by
  simp only [CW_0_re_000_def, CW_0_im_000_def, Fplus_dU_re_200_def, Fplus_dU_im_200_def, CW_200_0_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_200_0_pim_eq :
    CW_0_re_000 * Fplus_dU_im_200 + CW_0_im_000 * Fplus_dU_re_200 = CW_200_0_pim := by
  simp only [CW_0_re_000_def, CW_0_im_000_def, Fplus_dU_re_200_def, Fplus_dU_im_200_def, CW_200_0_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_200_0_mul :
    CW_0_c_000 * Fplus_dU_c_200 = ofLadj CW_200_0_pre CW_200_0_pim := by
  rw [CW_0_c_000_def, Fplus_dU_c_200_def, ofLadj_mul, CW_200_0_pre_eq, CW_200_0_pim_eq]

def CW_200_1_pre : Polynomial ℚ := interpQ 34559831724 [-522451895314, 17379904162520, 34399113684453, 56062943205832, 95382447788082, 121775684430852, 147165798306021, 157938632504476, 146849927325704, 139202565166180, 133073801567898, 131657796958544, 115693897405378, 104803451481727, 90786984119872, 58849101827557, 36720593727077, 11330479851908, -3707082888837]
def CW_200_1_pim : Polynomial ℚ := interpQ 34559831724 [-16598109838189, -33196219676378, -42402391385535, -58767700313795, -58914995728096, -43350852392402, -26367466753217, 7001128735083, 24541741986805, 23518553117512, 18259039396826, 27327094339654, 36395149282482, 40341807270953, 55683927329920, 58839001055587, 50192018077020, 40984270071529, 14532834940356]
theorem CW_200_1_pre_eq :
    CW_1_re_000 * Fplus_dV_re_200 - CW_1_im_000 * Fplus_dV_im_200 = CW_200_1_pre := by
  simp only [CW_1_re_000_def, CW_1_im_000_def, Fplus_dV_re_200_def, Fplus_dV_im_200_def, CW_200_1_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_200_1_pim_eq :
    CW_1_re_000 * Fplus_dV_im_200 + CW_1_im_000 * Fplus_dV_re_200 = CW_200_1_pim := by
  simp only [CW_1_re_000_def, CW_1_im_000_def, Fplus_dV_re_200_def, Fplus_dV_im_200_def, CW_200_1_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_200_1_mul :
    CW_1_c_000 * Fplus_dV_c_200 = ofLadj CW_200_1_pre CW_200_1_pim := by
  rw [CW_1_c_000_def, Fplus_dV_c_200_def, ofLadj_mul, CW_200_1_pre_eq, CW_200_1_pim_eq]

def CW_200_2_pre : Polynomial ℚ := interpQ 34559831724 [-5047296600208, -34363181293120, -64674834120940, -102826875487810, -145661966903788, -166316250885384, -183122873624818, -190095573742170, -175852527172281, -173210717004107, -171150822472033, -165326909542778, -136787641178913, -108535882883167, -73025651684471, -32673333806350, -13459208036844, 3347414702590, 11760273032032]
def CW_200_2_pim : Polynomial ℚ := interpQ 34559831724 [15248525466968, 30497050933936, 29665430536836, 29306982615264, 6982141434656, -25072860469706, -50525121118857, -83671965732371, -101057732374970, -100739695480391, -99019161293243, -111626690958568, -124234220623893, -121682066039645, -121005581223494, -99714851031837, -69904872219627, -47253477175010, -16351655653648]
theorem CW_200_2_pre_eq :
    CW_2_re_000 * Fplus_dW_re_200 - CW_2_im_000 * Fplus_dW_im_200 = CW_200_2_pre := by
  simp only [CW_2_re_000_def, CW_2_im_000_def, Fplus_dW_re_200_def, Fplus_dW_im_200_def, CW_200_2_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_200_2_pim_eq :
    CW_2_re_000 * Fplus_dW_im_200 + CW_2_im_000 * Fplus_dW_re_200 = CW_200_2_pim := by
  simp only [CW_2_re_000_def, CW_2_im_000_def, Fplus_dW_re_200_def, Fplus_dW_im_200_def, CW_200_2_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_200_2_mul :
    CW_2_c_000 * Fplus_dW_c_200 = ofLadj CW_200_2_pre CW_200_2_pim := by
  rw [CW_2_c_000_def, Fplus_dW_c_200_def, ofLadj_mul, CW_200_2_pre_eq, CW_200_2_pim_eq]

def CW_200_3_pre : Polynomial ℚ := interpQ 34559831724 [-360260064032, 0, 490121249904, 1357258845888, 1998186634224, 2463173461056, 2463173461056, 1998186634224, 1357258845888, 490121249904]
def CW_200_3_pim : Polynomial ℚ := interpQ 34559831724 [-783927422632, -1567854845264, -2018751162192, -2201546966352, -1783211152040, -1243392292880, -324462552384, 215356306776, 633692121088, 450896316928]
theorem CW_200_3_neg_re : -CW_3_re_200 = CW_200_3_pre := by
  simp only [CW_3_re_200_def, CW_200_3_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_200_3_neg_im : -CW_3_im_200 = CW_200_3_pim := by
  simp only [CW_3_im_200_def, CW_200_3_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_200_3_mul : -CW_3_c_200 = ofLadj CW_200_3_pre CW_200_3_pim := by
  rw [CW_3_c_200_def, ofLadj_neg, CW_200_3_neg_re, CW_200_3_neg_im]

@[expose] public def CW_coeff_200 : Ki := CW_0_c_000 * Fplus_dU_c_200 + CW_1_c_000 * Fplus_dV_c_200 + CW_2_c_000 * Fplus_dW_c_200 + (-CW_3_c_200)

theorem CW_coeff_200_sum :
    CW_coeff_200 = ofLadj (CW_200_0_pre + CW_200_1_pre + CW_200_2_pre + CW_200_3_pre) (CW_200_0_pim + CW_200_1_pim + CW_200_2_pim + CW_200_3_pim) := by
  simp only [CW_coeff_200, CW_200_0_mul, CW_200_1_mul, CW_200_2_mul, CW_200_3_mul]
  simpa [add_assoc] using ofLadj_add4 CW_200_0_pre CW_200_0_pim CW_200_1_pre CW_200_1_pim CW_200_2_pre CW_200_2_pim CW_200_3_pre CW_200_3_pim

def CW_200_qre : Polynomial ℚ := interpQ 34559831724 [-14554951949101, -2428325181499, -6170600749733, -1343980474982, 40565101075886, 49614212010946, 54384555478205, 39858203709140, 16106525813230]
def CW_200_qim : Polynomial ℚ := interpQ 34559831724 [-30345708314688, -30345708314688, -45833329442907, -65361832420784, -51074422789157, -30863217519617, -11079934658342, 28430038215393, 18384089734793]
theorem CW_coeff_200_poly_re :
    CW_200_0_pre + CW_200_1_pre + CW_200_2_pre + CW_200_3_pre = (0 : Polynomial ℚ) + Phi11 * CW_200_qre := by
  rw [phi11_interpQ]
  simp only [CW_200_0_pre, CW_200_1_pre, CW_200_2_pre, CW_200_3_pre, CW_200_qre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_coeff_200_poly_im :
    CW_200_0_pim + CW_200_1_pim + CW_200_2_pim + CW_200_3_pim = (0 : Polynomial ℚ) + Phi11 * CW_200_qim := by
  rw [phi11_interpQ]
  simp only [CW_200_0_pim, CW_200_1_pim, CW_200_2_pim, CW_200_3_pim, CW_200_qim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
public theorem CW_coeff_200_eq :
    CW_coeff_200 = (0 : Ki) := by
  rw [CW_coeff_200_sum, CW_coeff_200_poly_re,
    CW_coeff_200_poly_im, ofLadj_add_Phi11]
  exact ofLadj_zero

end V14Formalization.D12SigmaPlusSegreCore
