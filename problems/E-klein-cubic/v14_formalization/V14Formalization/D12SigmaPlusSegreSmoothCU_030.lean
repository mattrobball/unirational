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

def CU_030_0_pre : Polynomial ℚ := interpQ 235794999 [-84577195522, -163486171236880, -309588634411890, -532846392433106, -869710062949954, -1122403246675212, -1367940857658558, -1566336260662824, -1592602595864578, -1648179715441608, -1690583267652674, -1706399177713616, -1527097096415794, -1338591081029718, -1059756203431472, -671862063175682, -388761033562086, -143223422578740, 24764134537188]
def CU_030_0_pim : Polynomial ℚ := interpQ 235794999 [150959411908318, 301918823816636, 407826098808358, 572731986120614, 599586456863174, 532913577482088, 467415947405866, 278573849911008, 143076975915478, 135068252485780, 98357053626214, -106505631991344, -311368317608902, -453986791460190, -626901402202144, -630425715720522, -516578269968854, -394843695085152, -158827031219712]
theorem CU_030_0_pre_eq :
    CU_0_re_010 * Fplus_dU_re_020 - CU_0_im_010 * Fplus_dU_im_020 = CU_030_0_pre := by
  simp only [CU_0_re_010_def, CU_0_im_010_def, Fplus_dU_re_020_def, Fplus_dU_im_020_def, CU_030_0_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_030_0_pim_eq :
    CU_0_re_010 * Fplus_dU_im_020 + CU_0_im_010 * Fplus_dU_re_020 = CU_030_0_pim := by
  simp only [CU_0_re_010_def, CU_0_im_010_def, Fplus_dU_re_020_def, Fplus_dU_im_020_def, CU_030_0_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_030_0_mul :
    CU_0_c_010 * Fplus_dU_c_020 = ofLadj CU_030_0_pre CU_030_0_pim := by
  rw [CU_0_c_010_def, Fplus_dU_c_020_def, ofLadj_mul, CU_030_0_pre_eq, CU_030_0_pim_eq]

def CU_030_1_pre : Polynomial ℚ := interpQ 235794999 [17087320355790, 165920954892936, 288828205639254, 466166302188204, 704554745068224, 801101496025212, 918550119079080, 1054502877224946, 1079826598481514, 1163934232666578, 1228402196458686, 1235458712247840, 1062481241565750, 875106027027324, 613660296293310, 297865502572038, 155079217945620, 37630594891752, -52082629584684]
def CU_030_1_pim : Polynomial ℚ := interpQ 235794999 [-95156936630190, -190313873260380, -219031831106250, -284226889089732, -213954485571348, -96346330690212, -65058087681216, 54095287526418, 145220732917926, 157255760911806, 212853282059538, 389851061950656, 566848841841774, 651164320835376, 728394406812738, 622940008331094, 433720191684792, 317072477327568, 126307440354768]
theorem CU_030_1_pre_eq :
    CU_1_re_010 * Fplus_dV_re_020 - CU_1_im_010 * Fplus_dV_im_020 = CU_030_1_pre := by
  simp only [CU_1_re_010_def, CU_1_im_010_def, Fplus_dV_re_020_def, Fplus_dV_im_020_def, CU_030_1_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_030_1_pim_eq :
    CU_1_re_010 * Fplus_dV_im_020 + CU_1_im_010 * Fplus_dV_re_020 = CU_030_1_pim := by
  simp only [CU_1_re_010_def, CU_1_im_010_def, Fplus_dV_re_020_def, Fplus_dV_im_020_def, CU_030_1_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_030_1_mul :
    CU_1_c_010 * Fplus_dV_c_020 = ofLadj CU_030_1_pre CU_030_1_pim := by
  rw [CU_1_c_010_def, Fplus_dV_c_020_def, ofLadj_mul, CU_030_1_pre_eq, CU_030_1_pim_eq]

def CU_030_2_pre : Polynomial ℚ := interpQ 235794999 [27988928890832, 380672528548144, 756197490771354, 1241282050912646, 1849359308403344, 2202378023945094, 2492513480810160, 2665759770533976, 2539428444564108, 2510897929956074, 2488833518375032, 2452601240595720, 2108160989826888, 1754700439184720, 1298146393651462, 716445017263074, 379257989502416, 89122532637350, -99955444867558]
def CU_030_2_pim : Polynomial ℚ := interpQ 235794999 [-258784631484600, -517569262969200, -609037840263282, -729968480359114, -558490616751156, -214951448475902, 65995129922296, 487475013761228, 733013539526024, 728987234961842, 710100912673676, 940947974606588, 1171795036539500, 1244377291545416, 1361281627077066, 1201655601208186, 882553528327516, 630729476470066, 233686688025718]
theorem CU_030_2_pre_eq :
    CU_2_re_010 * Fplus_dW_re_020 - CU_2_im_010 * Fplus_dW_im_020 = CU_030_2_pre := by
  simp only [CU_2_re_010_def, CU_2_im_010_def, Fplus_dW_re_020_def, Fplus_dW_im_020_def, CU_030_2_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_030_2_pim_eq :
    CU_2_re_010 * Fplus_dW_im_020 + CU_2_im_010 * Fplus_dW_re_020 = CU_030_2_pim := by
  simp only [CU_2_re_010_def, CU_2_im_010_def, Fplus_dW_re_020_def, Fplus_dW_im_020_def, CU_030_2_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_030_2_mul :
    CU_2_c_010 * Fplus_dW_c_020 = ofLadj CU_030_2_pre CU_030_2_pim := by
  rw [CU_2_c_010_def, Fplus_dW_c_020_def, ofLadj_mul, CU_030_2_pre_eq, CU_030_2_pim_eq]

@[expose] public def CU_coeff_030 : Ki := CU_0_c_010 * Fplus_dU_c_020 + CU_1_c_010 * Fplus_dV_c_020 + CU_2_c_010 * Fplus_dW_c_020

theorem CU_coeff_030_sum :
    CU_coeff_030 = ofLadj (CU_030_0_pre + CU_030_1_pre + CU_030_2_pre) (CU_030_0_pim + CU_030_1_pim + CU_030_2_pim) := by
  simp only [CU_coeff_030, CU_030_0_mul, CU_030_1_mul, CU_030_2_mul]
  simpa [add_assoc] using ofLadj_add3 CU_030_0_pre CU_030_0_pim CU_030_1_pre CU_030_1_pim CU_030_2_pre CU_030_2_pim

def CU_030_qre : Polynomial ℚ := interpQ 235794999 [44991672051100, 338115640153100, 352329749794518, 439164898669026, 509602029853870, 196872282773480, 162046468935588, 110803644865416, -127273939915054]
def CU_030_qim : Polynomial ℚ := interpQ 235794999 [-202982156206472, -202982156206472, -14279260148230, -21219810767058, 268604737868902, 394474443775304, 246737191330972, 351791161551708, 201167097160774]
theorem CU_coeff_030_poly_re :
    CU_030_0_pre + CU_030_1_pre + CU_030_2_pre = (0 : Polynomial ℚ) + Phi11 * CU_030_qre := by
  rw [phi11_interpQ]
  simp only [CU_030_0_pre, CU_030_1_pre, CU_030_2_pre, CU_030_qre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_coeff_030_poly_im :
    CU_030_0_pim + CU_030_1_pim + CU_030_2_pim = (0 : Polynomial ℚ) + Phi11 * CU_030_qim := by
  rw [phi11_interpQ]
  simp only [CU_030_0_pim, CU_030_1_pim, CU_030_2_pim, CU_030_qim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
public theorem CU_coeff_030_eq :
    CU_coeff_030 = (0 : Ki) := by
  rw [CU_coeff_030_sum, CU_coeff_030_poly_re,
    CU_coeff_030_poly_im, ofLadj_add_Phi11]
  exact ofLadj_zero

end V14Formalization.D12SigmaPlusSegreCore
