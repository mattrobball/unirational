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

def CW_121_0_pre : Polynomial ℚ := interpQ 8639957931 [-520610190306, 15800974616760, 28772133536868, 50490873578118, 76701076280200, 87582569299273, 102968813178341, 106566780967332, 101393346197094, 99349828216683, 97934825053596, 97747115880888, 82133850436836, 70577694679815, 50902472618976, 26445685975842, 16752820115974, 1366576236906, -3420018711290]
def CW_121_0_pim : Polynomial ℚ := interpQ 8639957931 [-11343440538596, -22686881077192, -25212780990718, -34032458748972, -22854605237780, -11808958206017, -555859078905, 17837331311210, 25172869955408, 24809213659485, 23604335547700, 32969320541438, 42334305535176, 43655327336917, 52111348799248, 41800957957356, 32329471845908, 23287105444698, 6468075974898]
theorem CW_121_0_pre_eq :
    CW_0_re_110 * Fplus_dU_re_011 - CW_0_im_110 * Fplus_dU_im_011 = CW_121_0_pre := by
  simp only [CW_0_re_110_def, CW_0_im_110_def, Fplus_dU_re_011_def, Fplus_dU_im_011_def, CW_121_0_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_121_0_pim_eq :
    CW_0_re_110 * Fplus_dU_im_011 + CW_0_im_110 * Fplus_dU_re_011 = CW_121_0_pim := by
  simp only [CW_0_re_110_def, CW_0_im_110_def, Fplus_dU_re_011_def, Fplus_dU_im_011_def, CW_121_0_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_121_0_mul :
    CW_0_c_110 * Fplus_dU_c_011 = ofLadj CW_121_0_pre CW_121_0_pim := by
  rw [CW_0_c_110_def, Fplus_dU_c_011_def, ofLadj_mul, CW_121_0_pre_eq, CW_121_0_pim_eq]

def CW_121_1_pre : Polynomial ℚ := interpQ 8639957931 [-1918957331752, 11806892985152, 16467835328400, 27333485270950, 45235791194184, 42273347400920, 55805267335174, 51747537049354, 49177785352152, 48697872383124, 47662177493806, 49871056027080, 35855284508654, 32230037054724, 21844300081202, 4888024364282, 8161511575828, -5370408358426, -1623721490888]
def CW_121_1_pim : Polynomial ℚ := interpQ 8639957931 [-7674705254792, -15349410509584, -10078170708728, -21072132248614, -7210722729268, -3298359152708, 1668617491546, 14492285589926, 14022386894128, 14187905810864, 13513963497522, 20462133347576, 27410303197630, 21465121083432, 32624601540054, 18698822471854, 15937043345156, 11267554501574, -405529146944]
theorem CW_121_1_pre_eq :
    CW_0_re_020 * Fplus_dU_re_101 - CW_0_im_020 * Fplus_dU_im_101 = CW_121_1_pre := by
  simp only [CW_0_re_020_def, CW_0_im_020_def, Fplus_dU_re_101_def, Fplus_dU_im_101_def, CW_121_1_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_121_1_pim_eq :
    CW_0_re_020 * Fplus_dU_im_101 + CW_0_im_020 * Fplus_dU_re_101 = CW_121_1_pim := by
  simp only [CW_0_re_020_def, CW_0_im_020_def, Fplus_dU_re_101_def, Fplus_dU_im_101_def, CW_121_1_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_121_1_mul :
    CW_0_c_020 * Fplus_dU_c_101 = ofLadj CW_121_1_pre CW_121_1_pim := by
  rw [CW_0_c_020_def, Fplus_dU_c_101_def, ofLadj_mul, CW_121_1_pre_eq, CW_121_1_pim_eq]

def CW_121_2_pre : Polynomial ℚ := interpQ 8639957931 [1795923352776, -21387008149416, -38241421854747, -65612871301773, -100611156320381, -114170448896626, -135457928169476, -141404955992170, -134896424952955, -132877346389063, -132275615136509, -132837971053656, -110888606987093, -94635924534316, -69283553651182, -35321205994645, -22925961358728, -1638482085878, 5472593677144]
def CW_121_2_pim : Polynomial ℚ := interpQ 8639957931 [15926070864804, 31852141729608, 33720482847091, 47002646398739, 31783345738843, 17503982496608, 3205145791268, -21297829041406, -32622079152611, -31925346171513, -31180772647273, -45482687419150, -59784602191027, -60908369784270, -73493800354820, -59532754859051, -45904830890034, -33917530506534, -10065994947078]
theorem CW_121_2_pre_eq :
    CW_1_re_110 * Fplus_dV_re_011 - CW_1_im_110 * Fplus_dV_im_011 = CW_121_2_pre := by
  simp only [CW_1_re_110_def, CW_1_im_110_def, Fplus_dV_re_011_def, Fplus_dV_im_011_def, CW_121_2_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_121_2_pim_eq :
    CW_1_re_110 * Fplus_dV_im_011 + CW_1_im_110 * Fplus_dV_re_011 = CW_121_2_pim := by
  simp only [CW_1_re_110_def, CW_1_im_110_def, Fplus_dV_re_011_def, Fplus_dV_im_011_def, CW_121_2_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_121_2_mul :
    CW_1_c_110 * Fplus_dV_c_011 = ofLadj CW_121_2_pre CW_121_2_pim := by
  rw [CW_1_c_110_def, Fplus_dV_c_011_def, ofLadj_mul, CW_121_2_pre_eq, CW_121_2_pim_eq]

def CW_121_3_pre : Polynomial ℚ := interpQ 8639957931 [2165098877800, -4772905271840, -5734933945792, -14136657923836, -22746397331260, -21955361678562, -30943020682694, -29073596965678, -27084488601300, -26446359614504, -26045694329706, -27766969952672, -21272789057866, -20711425668712, -12947830677464, -4789600650394, -6119987470144, 2867671533988, 1537598984024]
def CW_121_3_pim : Polynomial ℚ := interpQ 8639957931 [4263045328004, 8526090656008, 8114829230920, 15217104950644, 7026338006384, 7156601248034, 4117449648398, -3647864470186, -3819734295464, -3651741158908, -3397896122150, -6954613939072, -10511331755994, -9846225294148, -16780507877316, -8892211793154, -9390034718860, -7267153399708, 130601034820]
theorem CW_121_3_pre_eq :
    CW_1_re_020 * Fplus_dV_re_101 - CW_1_im_020 * Fplus_dV_im_101 = CW_121_3_pre := by
  simp only [CW_1_re_020_def, CW_1_im_020_def, Fplus_dV_re_101_def, Fplus_dV_im_101_def, CW_121_3_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_121_3_pim_eq :
    CW_1_re_020 * Fplus_dV_im_101 + CW_1_im_020 * Fplus_dV_re_101 = CW_121_3_pim := by
  simp only [CW_1_re_020_def, CW_1_im_020_def, Fplus_dV_re_101_def, Fplus_dV_im_101_def, CW_121_3_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_121_3_mul :
    CW_1_c_020 * Fplus_dV_c_101 = ofLadj CW_121_3_pre CW_121_3_pim := by
  rw [CW_1_c_020_def, Fplus_dV_c_101_def, ofLadj_mul, CW_121_3_pre_eq, CW_121_3_pim_eq]

def CW_121_4_pre : Polynomial ℚ := interpQ 8639957931 [-563906030268, -169926673296, -953676100556, -1172114371244, -1451175913171, -2275132240845, -1958563428295, -2575796269146, -2349951171661, -2385808524862, -2048862092265, -1678673013526, -1878935418969, -1432132424306, -1177836800417, -1102310497779, -240559042332, -557127854882, 22309858196]
def CW_121_4_pim : Polynomial ℚ := interpQ 8639957931 [39570582810, 79141165620, 588858740616, -137000198586, 577873999365, -222319866581, -373857205907, -682302991928, -965007377369, -1157484797596, -1051108073319, -931248379304, -811388685289, -1214729536008, -681348017033, -1207278404833, -714446118542, -472732401958, -471648195592]
theorem CW_121_4_pre_eq :
    CW_2_re_110 * Fplus_dW_re_011 - CW_2_im_110 * Fplus_dW_im_011 = CW_121_4_pre := by
  simp only [CW_2_re_110_def, CW_2_im_110_def, Fplus_dW_re_011_def, Fplus_dW_im_011_def, CW_121_4_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_121_4_pim_eq :
    CW_2_re_110 * Fplus_dW_im_011 + CW_2_im_110 * Fplus_dW_re_011 = CW_121_4_pim := by
  simp only [CW_2_re_110_def, CW_2_im_110_def, Fplus_dW_re_011_def, Fplus_dW_im_011_def, CW_121_4_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_121_4_mul :
    CW_2_c_110 * Fplus_dW_c_011 = ofLadj CW_121_4_pre CW_121_4_pim := by
  rw [CW_2_c_110_def, Fplus_dW_c_011_def, ofLadj_mul, CW_121_4_pre_eq, CW_121_4_pim_eq]

def CW_121_5_pre : Polynomial ℚ := interpQ 8639957931 [10458629076920, 203706884864, 17148417784372, 23986857126062, 22522305896550, 40893412823096, 34701620594822, 46418077001168, 44008756981260, 43848301661812, 45021358440236, 33461159994516, 44817651555372, 26699883877440, 20021899855198, 20476629654514, 2324374224966, 8516166453240, -3419141450104]
def CW_121_5_pim : Polynomial ℚ := interpQ 8639957931 [3916485379012, 7832970758024, -5892693377868, 14249367939574, 4940778048938, 16455374162488, 23313238738786, 25742980706752, 38563439791548, 38045936452760, 38886209075752, 35134721897160, 31383234718568, 45949171477452, 25289606821222, 35147776202614, 22202510767198, 16131290883872, 12270879594040]
theorem CW_121_5_pre_eq :
    CW_2_re_020 * Fplus_dW_re_101 - CW_2_im_020 * Fplus_dW_im_101 = CW_121_5_pre := by
  simp only [CW_2_re_020_def, CW_2_im_020_def, Fplus_dW_re_101_def, Fplus_dW_im_101_def, CW_121_5_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_121_5_pim_eq :
    CW_2_re_020 * Fplus_dW_im_101 + CW_2_im_020 * Fplus_dW_re_101 = CW_121_5_pim := by
  simp only [CW_2_re_020_def, CW_2_im_020_def, Fplus_dW_re_101_def, Fplus_dW_im_101_def, CW_121_5_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_121_5_mul :
    CW_2_c_020 * Fplus_dW_c_101 = ofLadj CW_121_5_pre CW_121_5_pim := by
  rw [CW_2_c_020_def, Fplus_dW_c_101_def, ofLadj_mul, CW_121_5_pre_eq, CW_121_5_pim_eq]

theorem CW_121_6_mul : CW_3_c_120 = ofLadj CW_3_re_120 CW_3_im_120 := CW_3_c_120_def

@[expose] public def CW_coeff_121 : Ki := CW_0_c_110 * Fplus_dU_c_011 + CW_0_c_020 * Fplus_dU_c_101 + CW_1_c_110 * Fplus_dV_c_011 + CW_1_c_020 * Fplus_dV_c_101 + CW_2_c_110 * Fplus_dW_c_011 + CW_2_c_020 * Fplus_dW_c_101 + CW_3_c_120

theorem CW_coeff_121_sum :
    CW_coeff_121 = ofLadj (CW_121_0_pre + CW_121_1_pre + CW_121_2_pre + CW_121_3_pre + CW_121_4_pre + CW_121_5_pre + CW_3_re_120) (CW_121_0_pim + CW_121_1_pim + CW_121_2_pim + CW_121_3_pim + CW_121_4_pim + CW_121_5_pim + CW_3_im_120) := by
  simp only [CW_coeff_121, CW_121_0_mul, CW_121_1_mul, CW_121_2_mul, CW_121_3_mul, CW_121_4_mul, CW_121_5_mul, CW_121_6_mul]
  simp [ofLadj_add, add_assoc]

def CW_121_qre : Polynomial ℚ := interpQ 8639957931 [11452471546528, -9970737154304, 16038322052289, 3368681558332, -1237771425507, 12645024806256, -7232197879384, 6614775057866, -1430379132918]
def CW_121_qim : Polynomial ℚ := interpQ 8639957931 [5177105229584, 5177105229584, -9079774464311, 20030394372020, -6945410663431, 11555597343960, 5431179708882, 1102150207800, 7926384314144]
theorem CW_coeff_121_poly_re :
    CW_121_0_pre + CW_121_1_pre + CW_121_2_pre + CW_121_3_pre + CW_121_4_pre + CW_121_5_pre + CW_3_re_120 = (0 : Polynomial ℚ) + Phi11 * CW_121_qre := by
  rw [phi11_interpQ]
  simp only [CW_121_0_pre, CW_121_1_pre, CW_121_2_pre, CW_121_3_pre, CW_121_4_pre, CW_121_5_pre, CW_3_re_120_def, CW_121_qre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_coeff_121_poly_im :
    CW_121_0_pim + CW_121_1_pim + CW_121_2_pim + CW_121_3_pim + CW_121_4_pim + CW_121_5_pim + CW_3_im_120 = (0 : Polynomial ℚ) + Phi11 * CW_121_qim := by
  rw [phi11_interpQ]
  simp only [CW_121_0_pim, CW_121_1_pim, CW_121_2_pim, CW_121_3_pim, CW_121_4_pim, CW_121_5_pim, CW_3_im_120_def, CW_121_qim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
public theorem CW_coeff_121_eq :
    CW_coeff_121 = (0 : Ki) := by
  rw [CW_coeff_121_sum, CW_coeff_121_poly_re,
    CW_coeff_121_poly_im, ofLadj_add_Phi11]
  exact ofLadj_zero

end V14Formalization.D12SigmaPlusSegreCore
