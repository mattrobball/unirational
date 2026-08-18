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

def CU_121_0_pre : Polynomial ℚ := interpQ 235794999 [-1924215844792, 271102725038784, 542152426272304, 882919421962160, 1493086923195880, 1911786355982044, 2304836632816828, 2476363106718492, 2305313857369252, 2182710608276500, 2089161916135656, 2056086698421752, 1818059191096872, 1640558182004196, 1422394435407092, 924826663019804, 573146867006296, 180096590171512, -58449520502808]
def CU_121_0_pim : Polynomial ℚ := interpQ 235794999 [-257129140724504, -514258281449008, -664431809947544, -911483777461472, -917358084864264, -673325683755972, -403558225507164, 113349388179580, 394353118409492, 376695929507316, 295662805984624, 433924619846816, 572186433709008, 641326838684852, 870721617296604, 928066553165804, 788139088586984, 642335778920776, 229533101763504]
theorem CU_121_0_pre_eq :
    CU_0_re_011 * Fplus_dU_re_110 - CU_0_im_011 * Fplus_dU_im_110 = CU_121_0_pre := by
  simp only [CU_0_re_011_def, CU_0_im_011_def, Fplus_dU_re_110_def, Fplus_dU_im_110_def, CU_121_0_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_121_0_pim_eq :
    CU_0_re_011 * Fplus_dU_im_110 + CU_0_im_011 * Fplus_dU_re_110 = CU_121_0_pim := by
  simp only [CU_0_re_011_def, CU_0_im_011_def, Fplus_dU_re_110_def, Fplus_dU_im_110_def, CU_121_0_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_121_0_mul :
    CU_0_c_011 * Fplus_dU_c_110 = ofLadj CU_121_0_pre CU_121_0_pim := by
  rw [CU_0_c_011_def, Fplus_dU_c_110_def, ofLadj_mul, CU_121_0_pre_eq, CU_121_0_pim_eq]

def CU_121_1_pre : Polynomial ℚ := interpQ 235794999 [283093585124, 605713305265040, 1146923162331900, 1974827246744116, 3222886606343084, 4158914313367908, 5069570175135232, 5804430103331288, 5901579355762764, 6107558483750892, 6264768944617032, 6323195099474280, 5659055639351992, 4960635321418992, 3926752109018648, 2489463836605860, 1440893052160372, 530237190393048, -92079660382344]
def CU_121_1_pim : Polynomial ℚ := interpQ 235794999 [-559310789690324, -1118621579380648, -1511276278679108, -2122467189784156, -2221266439556420, -1974843673951516, -1731944992608128, -1031603264255936, -529611181408468, -499969387922268, -363761639770536, 395226233921632, 1154214107613800, 1683076555063992, 2323909259655240, 2336245060820156, 1914844767489892, 1463774787532368, 588455531454816]
theorem CU_121_1_pre_eq :
    CU_1_re_011 * Fplus_dV_re_110 - CU_1_im_011 * Fplus_dV_im_110 = CU_121_1_pre := by
  simp only [CU_1_re_011_def, CU_1_im_011_def, Fplus_dV_re_110_def, Fplus_dV_im_110_def, CU_121_1_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_121_1_pim_eq :
    CU_1_re_011 * Fplus_dV_im_110 + CU_1_im_011 * Fplus_dV_re_110 = CU_121_1_pim := by
  simp only [CU_1_re_011_def, CU_1_im_011_def, Fplus_dV_re_110_def, Fplus_dV_im_110_def, CU_121_1_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_121_1_mul :
    CU_1_c_011 * Fplus_dV_c_110 = ofLadj CU_121_1_pre CU_121_1_pim := by
  rw [CU_1_c_011_def, Fplus_dV_c_110_def, ofLadj_mul, CU_121_1_pre_eq, CU_121_1_pim_eq]

def CU_121_2_pre : Polynomial ℚ := interpQ 235794999 [48882100665448, 660626140859680, 1344274342413456, 2208384643919136, 3287978719004800, 3908019248002416, 4405842057850640, 4680231697702272, 4459114389783076, 4374810294642876, 4310477221874940, 4237658658752048, 3649851081015260, 3030535952229420, 2250729745863940, 1248602955611112, 674542194007104, 176719384158880, -143650023086360]
def CU_121_2_pim : Polynomial ℚ := interpQ 235794999 [-444823365578088, -889646731156176, -1055325099283712, -1242607023538808, -935700676270640, -325611602740808, 162692320814632, 879471942114136, 1291428351643956, 1279302104120660, 1223502067076532, 1586666906804024, 1949831746531516, 2059710077614924, 2234865754346724, 1963359779031472, 1424915950782600, 1021690413595448, 376556037576904]
theorem CU_121_2_pre_eq :
    CU_2_re_011 * Fplus_dW_re_110 - CU_2_im_011 * Fplus_dW_im_110 = CU_121_2_pre := by
  simp only [CU_2_re_011_def, CU_2_im_011_def, Fplus_dW_re_110_def, Fplus_dW_im_110_def, CU_121_2_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_121_2_pim_eq :
    CU_2_re_011 * Fplus_dW_im_110 + CU_2_im_011 * Fplus_dW_re_110 = CU_121_2_pim := by
  simp only [CU_2_re_011_def, CU_2_im_011_def, Fplus_dW_re_110_def, Fplus_dW_im_110_def, CU_121_2_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_121_2_mul :
    CU_2_c_011 * Fplus_dW_c_110 = ofLadj CU_121_2_pre CU_121_2_pim := by
  rw [CU_2_c_011_def, Fplus_dW_c_110_def, ofLadj_mul, CU_121_2_pre_eq, CU_121_2_pim_eq]

theorem CU_121_3_mul : CU_3_c_021 = ofLadj CU_3_re_021 CU_3_im_021 := CU_3_c_021_def

@[expose] public def CU_coeff_121 : Ki := CU_0_c_011 * Fplus_dU_c_110 + CU_1_c_011 * Fplus_dV_c_110 + CU_2_c_011 * Fplus_dW_c_110 + CU_3_c_021

theorem CU_coeff_121_sum :
    CU_coeff_121 = ofLadj (CU_121_0_pre + CU_121_1_pre + CU_121_2_pre + CU_3_re_021) (CU_121_0_pim + CU_121_1_pim + CU_121_2_pim + CU_3_im_021) := by
  simp only [CU_coeff_121, CU_121_0_mul, CU_121_1_mul, CU_121_2_mul, CU_121_3_mul]
  simpa [add_assoc] using ofLadj_add4 CU_121_0_pre CU_121_0_pim CU_121_1_pre CU_121_1_pim CU_121_2_pre CU_121_2_pim CU_3_re_021 CU_3_im_021

def CU_121_qre : Polynomial ℚ := interpQ 235794999 [47467625979548, 1489974545183956, 1495236455811516, 2031853165362928, 2936982835052904, 1974311342063004, 1801528948450332, 1181232368694952, -294179203971512]
def CU_121_qim : Polynomial ℚ := interpQ 235794999 [-1260414527281852, -1260414527281852, -707881183509444, -1045383159934800, 201825238281136, 1099771586157956, 1000098826810884, 1933256309253368, 1194544670795224]
theorem CU_coeff_121_poly_re :
    CU_121_0_pre + CU_121_1_pre + CU_121_2_pre + CU_3_re_021 = (0 : Polynomial ℚ) + Phi11 * CU_121_qre := by
  rw [phi11_interpQ]
  simp only [CU_121_0_pre, CU_121_1_pre, CU_121_2_pre, CU_3_re_021_def, CU_121_qre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_coeff_121_poly_im :
    CU_121_0_pim + CU_121_1_pim + CU_121_2_pim + CU_3_im_021 = (0 : Polynomial ℚ) + Phi11 * CU_121_qim := by
  rw [phi11_interpQ]
  simp only [CU_121_0_pim, CU_121_1_pim, CU_121_2_pim, CU_3_im_021_def, CU_121_qim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
public theorem CU_coeff_121_eq :
    CU_coeff_121 = (0 : Ki) := by
  rw [CU_coeff_121_sum, CU_coeff_121_poly_re,
    CU_coeff_121_poly_im, ofLadj_add_Phi11]
  exact ofLadj_zero

end V14Formalization.D12SigmaPlusSegreCore
