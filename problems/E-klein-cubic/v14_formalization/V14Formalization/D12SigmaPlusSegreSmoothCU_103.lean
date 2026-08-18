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

def CU_103_0_pre : Polynomial ℚ := interpQ 235794999 [859274129501600, 6141691498263296, 11578130044330336, 18210208718557640, 25924557572015680, 29715404312653752, 32532720565309280, 33839525768773672, 31346832198837240, 30871647507813816, 30508777801884760, 29514217218372864, 24367086303621464, 19293517463483480, 13136623480279600, 5858990649497480, 2327747609049032, -489568643606496, -2055977547260512]
def CU_103_0_pim : Polynomial ℚ := interpQ 235794999 [-2753900141891552, -5507800283783104, -5240305872154432, -5224021787736968, -1420326343353776, 4470075156167368, 8982164648748304, 14730932484356536, 17913372577284936, 17845065230505192, 17530689515266472, 19823902699315488, 22117115883364504, 21535245756497112, 21450654325299904, 17846361881166424, 12359855590789080, 8327909719143120, 2983037092678688]
theorem CU_103_0_pre_eq :
    CU_0_re_002 * Fplus_dU_re_101 - CU_0_im_002 * Fplus_dU_im_101 = CU_103_0_pre := by
  simp only [CU_0_re_002_def, CU_0_im_002_def, Fplus_dU_re_101_def, Fplus_dU_im_101_def, CU_103_0_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_103_0_pim_eq :
    CU_0_re_002 * Fplus_dU_im_101 + CU_0_im_002 * Fplus_dU_re_101 = CU_103_0_pim := by
  simp only [CU_0_re_002_def, CU_0_im_002_def, Fplus_dU_re_101_def, Fplus_dU_im_101_def, CU_103_0_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_103_0_mul :
    CU_0_c_002 * Fplus_dU_c_101 = ofLadj CU_103_0_pre CU_103_0_pim := by
  rw [CU_0_c_002_def, Fplus_dU_c_101_def, ofLadj_mul, CU_103_0_pre_eq, CU_103_0_pim_eq]

def CU_103_1_pre : Polynomial ℚ := interpQ 235794999 [-428215370424624, -5800591956619200, -11801163745548640, -19395358335948000, -28875349259224096, -34315030598639536, -38694433910435184, -41100138687936952, -39156258992802520, -38416068011147072, -37850916417397408, -37212015754274736, -32050324460778208, -26614904265598432, -19760900656854520, -10961133157498056, -5925748155808704, -1546344844013056, 1263656271214800]
def CU_103_1_pim : Polynomial ℚ := interpQ 235794999 [3906160431775760, 7812320863551520, 9268833888577360, 10916732230482112, 8213204470488432, 2861231196280656, -1427598114318992, -7727830299022712, -11343047286769784, -11236623206727536, -10746919651444064, -13935566003377520, -17124212355310976, -18091021825053344, -19632496086915848, -17239616213915288, -12516732324216688, -8975711900948496, -3304569100753952]
theorem CU_103_1_pre_eq :
    CU_1_re_002 * Fplus_dV_re_101 - CU_1_im_002 * Fplus_dV_im_101 = CU_103_1_pre := by
  simp only [CU_1_re_002_def, CU_1_im_002_def, Fplus_dV_re_101_def, Fplus_dV_im_101_def, CU_103_1_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_103_1_pim_eq :
    CU_1_re_002 * Fplus_dV_im_101 + CU_1_im_002 * Fplus_dV_re_101 = CU_103_1_pim := by
  simp only [CU_1_re_002_def, CU_1_im_002_def, Fplus_dV_re_101_def, Fplus_dV_im_101_def, CU_103_1_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_103_1_mul :
    CU_1_c_002 * Fplus_dV_c_101 = ofLadj CU_103_1_pre CU_103_1_pim := by
  rw [CU_1_c_002_def, Fplus_dV_c_101_def, ofLadj_mul, CU_103_1_pre_eq, CU_103_1_pim_eq]

def CU_103_2_pre : Polynomial ℚ := interpQ 235794999 [-188650617956192, -3077676654077312, -6144573621077648, -9978947593437712, -15162161932128432, -18328483253529224, -21219247159961832, -23143545556671008, -22754519308088544, -23060049589131912, -23293275892648824, -23191554436543072, -20215599238571512, -16915475968054264, -12775571714650832, -7311605719898080, -3978460354836568, -1087696448403960, 669777904644496]
def CU_103_2_pim : Polynomial ℚ := interpQ 235794999 [2204360854863936, 4408721709727872, 5374462056581696, 6713014156030512, 5829936919405712, 3508232894273880, 1710174604691928, -1527405206589664, -3396243553131344, -3440186574721352, -3642327970891368, -6142797423397312, -8643266875903256, -9811148618927096, -11193643739965920, -10182314917069120, -7600970887254536, -5494309748778024, -1997089932813680]
theorem CU_103_2_pre_eq :
    CU_2_re_002 * Fplus_dW_re_101 - CU_2_im_002 * Fplus_dW_im_101 = CU_103_2_pre := by
  simp only [CU_2_re_002_def, CU_2_im_002_def, Fplus_dW_re_101_def, Fplus_dW_im_101_def, CU_103_2_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_103_2_pim_eq :
    CU_2_re_002 * Fplus_dW_im_101 + CU_2_im_002 * Fplus_dW_re_101 = CU_103_2_pim := by
  simp only [CU_2_re_002_def, CU_2_im_002_def, Fplus_dW_re_101_def, Fplus_dW_im_101_def, CU_103_2_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_103_2_mul :
    CU_2_c_002 * Fplus_dW_c_101 = ofLadj CU_103_2_pre CU_103_2_pim := by
  rw [CU_2_c_002_def, Fplus_dW_c_101_def, ofLadj_mul, CU_103_2_pre_eq, CU_103_2_pim_eq]

theorem CU_103_3_mul : CU_3_c_003 = ofLadj CU_3_re_003 CU_3_im_003 := CU_3_c_003_def

@[expose] public def CU_coeff_103 : Ki := CU_0_c_002 * Fplus_dU_c_101 + CU_1_c_002 * Fplus_dV_c_101 + CU_2_c_002 * Fplus_dW_c_101 + CU_3_c_003

theorem CU_coeff_103_sum :
    CU_coeff_103 = ofLadj (CU_103_0_pre + CU_103_1_pre + CU_103_2_pre + CU_3_re_003) (CU_103_0_pim + CU_103_1_pim + CU_103_2_pim + CU_3_im_003) := by
  simp only [CU_coeff_103, CU_103_0_mul, CU_103_1_mul, CU_103_2_mul, CU_103_3_mul]
  simpa [add_assoc] using ofLadj_add4 CU_103_0_pre CU_103_0_pim CU_103_1_pre CU_103_1_pim CU_103_2_pre CU_103_2_pim CU_3_re_003 CU_3_im_003

def CU_103_qre : Polynomial ℚ := interpQ 235794999 [253938464283472, -2990515576716688, -3661974625559040, -4837013878943464, -6986100663327096, -4837287326302416, -4452850965572728, -3001066564622296, -122543371401216]
def CU_103_qim : Polynomial ℚ := interpQ 235794999 [3395902620390384, 3395902620390384, 2716561339633600, 3008560814098536, 200083748236120, -1817721629135840, -1615735690098744, -3823489989694456, -2318621940888944]
theorem CU_coeff_103_poly_re :
    CU_103_0_pre + CU_103_1_pre + CU_103_2_pre + CU_3_re_003 = (0 : Polynomial ℚ) + Phi11 * CU_103_qre := by
  rw [phi11_interpQ]
  simp only [CU_103_0_pre, CU_103_1_pre, CU_103_2_pre, CU_3_re_003_def, CU_103_qre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_coeff_103_poly_im :
    CU_103_0_pim + CU_103_1_pim + CU_103_2_pim + CU_3_im_003 = (0 : Polynomial ℚ) + Phi11 * CU_103_qim := by
  rw [phi11_interpQ]
  simp only [CU_103_0_pim, CU_103_1_pim, CU_103_2_pim, CU_3_im_003_def, CU_103_qim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
public theorem CU_coeff_103_eq :
    CU_coeff_103 = (0 : Ki) := by
  rw [CU_coeff_103_sum, CU_coeff_103_poly_re,
    CU_coeff_103_poly_im, ofLadj_add_Phi11]
  exact ofLadj_zero

end V14Formalization.D12SigmaPlusSegreCore
