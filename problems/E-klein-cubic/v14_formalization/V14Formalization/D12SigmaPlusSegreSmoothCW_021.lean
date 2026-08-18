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

def CW_021_0_pre : Polynomial ℚ := interpQ 8639957931 [1945670275616, 44638992220160, 87962152688012, 146669150873660, 219284632846350, 257428248641342, 293658285547232, 310229115314608, 295666829002574, 289990946175718, 285761458671960, 282089364628704, 241122466451800, 202028793487706, 148997678128914, 81465993727054, 46420717079658, 10190680173768, -9478488741204]
def CW_021_0_pim : Polynomial ℚ := interpQ 8639957931 [-30622594406856, -61245188813712, -71053826823952, -86859277449904, -63296845471810, -25509678122058, 6454810801200, 55340855287640, 81005911565694, 80181973357268, 76564129958968, 101669945866408, 126775761773848, 132966556385788, 147948068803314, 126776312109010, 93650140958386, 67499429281576, 23274380994264]
theorem CW_021_0_pre_eq :
    CW_0_re_010 * Fplus_dU_re_011 - CW_0_im_010 * Fplus_dU_im_011 = CW_021_0_pre := by
  simp only [CW_0_re_010_def, CW_0_im_010_def, Fplus_dU_re_011_def, Fplus_dU_im_011_def, CW_021_0_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_021_0_pim_eq :
    CW_0_re_010 * Fplus_dU_im_011 + CW_0_im_010 * Fplus_dU_re_011 = CW_021_0_pim := by
  simp only [CW_0_re_010_def, CW_0_im_010_def, Fplus_dU_re_011_def, Fplus_dU_im_011_def, CW_021_0_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_021_0_mul :
    CW_0_c_010 * Fplus_dU_c_011 = ofLadj CW_021_0_pre CW_021_0_pim := by
  rw [CW_0_c_010_def, Fplus_dU_c_011_def, ofLadj_mul, CW_021_0_pre_eq, CW_021_0_pim_eq]

def CW_021_1_pre : Polynomial ℚ := interpQ 8639957931 [-2699804936732, -69511645258160, -136003716180388, -221080674662284, -334569861593906, -398319843546984, -449791510612058, -479749753619482, -457971907921702, -452378747854940, -448749307571242, -444447819335412, -379237662313082, -316375031674552, -236891233259418, -128099415105666, -67063561329078, -15591894264004, 17080476919910]
def CW_021_1_pim : Polynomial ℚ := interpQ 8639957931 [48247425062308, 96494850124616, 109678196295822, 136070179043166, 105675743309856, 41956381122896, -9071109753016, -83404490300668, -127637696991766, -126583622452420, -122962702947718, -166340876422892, -209719049898066, -219281476564570, -244619384772568, -216962064501210, -157459049674832, -111613124416216, -41496091229146]
theorem CW_021_1_pre_eq :
    CW_1_re_010 * Fplus_dV_re_011 - CW_1_im_010 * Fplus_dV_im_011 = CW_021_1_pre := by
  simp only [CW_1_re_010_def, CW_1_im_010_def, Fplus_dV_re_011_def, Fplus_dV_im_011_def, CW_021_1_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_021_1_pim_eq :
    CW_1_re_010 * Fplus_dV_im_011 + CW_1_im_010 * Fplus_dV_re_011 = CW_021_1_pim := by
  simp only [CW_1_re_010_def, CW_1_im_010_def, Fplus_dV_re_011_def, Fplus_dV_im_011_def, CW_021_1_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_021_1_mul :
    CW_1_c_010 * Fplus_dV_c_011 = ofLadj CW_021_1_pre CW_021_1_pim := by
  rw [CW_1_c_010_def, Fplus_dV_c_011_def, ofLadj_mul, CW_021_1_pre_eq, CW_021_1_pim_eq]

def CW_021_2_pre : Polynomial ℚ := interpQ 8639957931 [-889652764744, -430165406560, -1999477100162, -1908747794840, -2689502861004, -4484994416024, -3453863893552, -4634633200158, -4358397920704, -4686204070786, -3989808228950, -3351384074116, -3559642822390, -2686726970624, -2449650125864, -2037520302984, -393746305654, -1424876828126, -92389963830]
def CW_021_2_pim : Polynomial ℚ := interpQ 8639957931 [234637553284, 469275106568, 1139985641388, -239250673150, 1625139735552, -161417504484, -566174666440, -736080888400, -1044671132700, -1490735007284, -1479339779190, -1336835880512, -1194331981834, -1853647288560, -920474848606, -2126529738298, -895822117672, -580982365860, -966925763310]
theorem CW_021_2_pre_eq :
    CW_2_re_010 * Fplus_dW_re_011 - CW_2_im_010 * Fplus_dW_im_011 = CW_021_2_pre := by
  simp only [CW_2_re_010_def, CW_2_im_010_def, Fplus_dW_re_011_def, Fplus_dW_im_011_def, CW_021_2_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_021_2_pim_eq :
    CW_2_re_010 * Fplus_dW_im_011 + CW_2_im_010 * Fplus_dW_re_011 = CW_021_2_pim := by
  simp only [CW_2_re_010_def, CW_2_im_010_def, Fplus_dW_re_011_def, Fplus_dW_im_011_def, CW_021_2_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_021_2_mul :
    CW_2_c_010 * Fplus_dW_c_011 = ofLadj CW_021_2_pre CW_021_2_pim := by
  rw [CW_2_c_010_def, Fplus_dW_c_011_def, ofLadj_mul, CW_021_2_pre_eq, CW_021_2_pim_eq]

def CW_021_3_pre : Polynomial ℚ := interpQ 8639957931 [278296106132, 0, 979422358200, 1533936728016, 2571900855612, 2818178635844, 2818178635844, 2571900855612, 1533936728016, 979422358200]
def CW_021_3_pim : Polynomial ℚ := interpQ 8639957931 [-717657768640, -1435315537280, -2177755321464, -2012762530456, -2050597927032, -913869939240, -521445598040, 615282389752, 577446993176, 742439784184]
theorem CW_021_3_neg_re : -CW_3_re_021 = CW_021_3_pre := by
  simp only [CW_3_re_021_def, CW_021_3_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_021_3_neg_im : -CW_3_im_021 = CW_021_3_pim := by
  simp only [CW_3_im_021_def, CW_021_3_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_021_3_mul : -CW_3_c_021 = ofLadj CW_021_3_pre CW_021_3_pim := by
  rw [CW_3_c_021_def, ofLadj_neg, CW_021_3_neg_re, CW_021_3_neg_im]

theorem CW_021_4_mul : CW_3_c_020 = ofLadj CW_3_re_020 CW_3_im_020 := CW_3_c_020_def

@[expose] public def CW_coeff_021 : Ki := CW_0_c_010 * Fplus_dU_c_011 + CW_1_c_010 * Fplus_dV_c_011 + CW_2_c_010 * Fplus_dW_c_011 + (-CW_3_c_021) + CW_3_c_020

theorem CW_coeff_021_sum :
    CW_coeff_021 = ofLadj (CW_021_0_pre + CW_021_1_pre + CW_021_2_pre + CW_021_3_pre + CW_3_re_020) (CW_021_0_pim + CW_021_1_pim + CW_021_2_pim + CW_021_3_pim + CW_3_im_020) := by
  simp only [CW_coeff_021, CW_021_0_mul, CW_021_1_mul, CW_021_2_mul, CW_021_3_mul, CW_021_4_mul]
  simp [ofLadj_add, add_assoc]

def CW_021_qre : Polynomial ℚ := interpQ 8639957931 [-1267818347408, -24035000097152, -24641873526202, -26689759901102, -41672263574772, -27634351126522, -14210499636712, -14335689133238, 7509598214876]
def CW_021_qim : Polynomial ℚ := interpQ 8639957931 [18129853669056, 18129853669056, 4030947361290, 9423223350518, -5279508687362, -27607551296380, -20010053333618, -25506041502308, -19188635998192]
theorem CW_coeff_021_poly_re :
    CW_021_0_pre + CW_021_1_pre + CW_021_2_pre + CW_021_3_pre + CW_3_re_020 = (0 : Polynomial ℚ) + Phi11 * CW_021_qre := by
  rw [phi11_interpQ]
  simp only [CW_021_0_pre, CW_021_1_pre, CW_021_2_pre, CW_021_3_pre, CW_3_re_020_def, CW_021_qre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_coeff_021_poly_im :
    CW_021_0_pim + CW_021_1_pim + CW_021_2_pim + CW_021_3_pim + CW_3_im_020 = (0 : Polynomial ℚ) + Phi11 * CW_021_qim := by
  rw [phi11_interpQ]
  simp only [CW_021_0_pim, CW_021_1_pim, CW_021_2_pim, CW_021_3_pim, CW_3_im_020_def, CW_021_qim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
public theorem CW_coeff_021_eq :
    CW_coeff_021 = (0 : Ki) := by
  rw [CW_coeff_021_sum, CW_coeff_021_poly_re,
    CW_coeff_021_poly_im, ofLadj_add_Phi11]
  exact ofLadj_zero

end V14Formalization.D12SigmaPlusSegreCore
