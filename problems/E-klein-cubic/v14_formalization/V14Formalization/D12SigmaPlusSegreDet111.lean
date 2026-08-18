/-
Auto-generated Fplus / det(bilinearN) coefficient identities.
-/
module

public import V14Formalization.D12SigmaPlusSegreEval
public import V14Formalization.D12SigmaPlusSegreMul
public import V14Formalization.D12PolyZReflection
public import V14Formalization.D12SigmaPlusSegreApplyN
public import V14Formalization.D12SigmaPlusSegreFplusZ

noncomputable section
open Matrix Polynomial
namespace V14Formalization.D12SigmaPlusSegreCore
open D12PolynomialData
open V14Formalization.D12PolyZReflection

def DC111_0_ab_pre : Polynomial ℚ := interpQ 1 [-342, 456, 130, -504, 1168, -452, -316, 1494, -1372, 404, 1338, -1360, 882, 274, -868, 766, -120, -256, 440]
def DC111_0_ab_pim : Polynomial ℚ := interpQ 1 [-456, -912, -118, -1622, -1480, -572, -3064, -1530, -1384, -4182, -976, -1888, -2800, -388, -1682, -1358, -100, -952, -320]
def DC111_0_pre : Polynomial ℚ := interpQ 1 [2052, -31920, -22516, -14628, -120124, -36996, -85644, -240720, -30864, -240572, -335620, -33608, -398108, -282340, -68576, -450392, -157856, -121048, -363460, -52956, -127720, -180920, -6704, -86512, -63436, -616, -33664, -11840]
def DC111_0_pim : Polynomial ℚ := interpQ 1 [14136, 22800, -6944, 63692, 46436, -796, 172268, 46272, 64256, 311184, 4592, 184168, 340052, -29284, 308476, 252336, -16468, 327268, 108796, 15880, 211368, 13512, 38392, 92436, -12932, 21088, 19552, -8880]
theorem DC111_0_ab_pre_eq :
    N_re_0_3 * N_re_1_4 - N_im_0_3 * N_im_1_4 =
      DC111_0_ab_pre := by
  simp only [z_N_re_0_3, z_N_im_0_3, z_N_re_1_4, z_N_im_1_4, DC111_0_ab_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC111_0_ab_pim_eq :
    N_re_0_3 * N_im_1_4 + N_im_0_3 * N_re_1_4 =
      DC111_0_ab_pim := by
  simp only [z_N_re_0_3, z_N_im_0_3, z_N_re_1_4, z_N_im_1_4, DC111_0_ab_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC111_0_ab_mul :
    N_entry_0_3 * N_entry_1_4 =
      ofLadj DC111_0_ab_pre DC111_0_ab_pim := by
  rw [N_entry_0_3, N_entry_1_4, ofLadj_mul,
    DC111_0_ab_pre_eq, DC111_0_ab_pim_eq]

theorem DC111_0_pre_eq :
    DC111_0_ab_pre * N_re_2_5 - DC111_0_ab_pim * N_im_2_5 =
      DC111_0_pre := by
  simp only [DC111_0_ab_pre, DC111_0_ab_pim, z_N_re_2_5, z_N_im_2_5, DC111_0_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC111_0_pim_eq :
    DC111_0_ab_pre * N_im_2_5 + DC111_0_ab_pim * N_re_2_5 =
      DC111_0_pim := by
  simp only [DC111_0_ab_pre, DC111_0_ab_pim, z_N_re_2_5, z_N_im_2_5, DC111_0_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC111_0_mul :
    N_entry_0_3 * N_entry_1_4 * N_entry_2_5 =
      ofLadj DC111_0_pre DC111_0_pim := by
  rw [DC111_0_ab_mul, N_entry_2_5, ofLadj_mul, DC111_0_pre_eq, DC111_0_pim_eq]

def DC111_1_ab_pre : Polynomial ℚ := interpQ 1 [-198, 144, -42, -338, 388, -316, -244, 568, -674, 130, 552, -576, 408, 172, -336, 372, -32, -104, 192]
def DC111_1_ab_pim : Polynomial ℚ := interpQ 1 [-186, -372, 18, -622, -512, -48, -1116, -400, -326, -1562, -168, -600, -1032, -28, -624, -516, -16, -392, -144]
def DC111_1_pre : Polynomial ℚ := interpQ 1 [6816, -25620, -9456, 8608, -92552, 5104, -30248, -179592, 50872, -151576, -239892, 71724, -294608, -181048, 29832, -360484, -77168, -53312, -304212, -10608, -94568, -155496, 7728, -75160, -55640, 1824, -30768, -11496]
def DC111_1_pim : Polynomial ℚ := interpQ 1 [15162, 26940, -5424, 70164, 52226, -2644, 173842, 38836, 48656, 298172, -22768, 152504, 302800, -75004, 258448, 200336, -64694, 279932, 68094, -17152, 178840, -8244, 21388, 79380, -18476, 17992, 18616, -8328]
theorem DC111_1_ab_pre_eq :
    N_re_0_4 * N_re_1_5 - N_im_0_4 * N_im_1_5 =
      DC111_1_ab_pre := by
  simp only [z_N_re_0_4, z_N_im_0_4, z_N_re_1_5, z_N_im_1_5, DC111_1_ab_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC111_1_ab_pim_eq :
    N_re_0_4 * N_im_1_5 + N_im_0_4 * N_re_1_5 =
      DC111_1_ab_pim := by
  simp only [z_N_re_0_4, z_N_im_0_4, z_N_re_1_5, z_N_im_1_5, DC111_1_ab_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC111_1_ab_mul :
    N_entry_0_4 * N_entry_1_5 =
      ofLadj DC111_1_ab_pre DC111_1_ab_pim := by
  rw [N_entry_0_4, N_entry_1_5, ofLadj_mul,
    DC111_1_ab_pre_eq, DC111_1_ab_pim_eq]

theorem DC111_1_pre_eq :
    DC111_1_ab_pre * N_re_2_3 - DC111_1_ab_pim * N_im_2_3 =
      DC111_1_pre := by
  simp only [DC111_1_ab_pre, DC111_1_ab_pim, z_N_re_2_3, z_N_im_2_3, DC111_1_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC111_1_pim_eq :
    DC111_1_ab_pre * N_im_2_3 + DC111_1_ab_pim * N_re_2_3 =
      DC111_1_pim := by
  simp only [DC111_1_ab_pre, DC111_1_ab_pim, z_N_re_2_3, z_N_im_2_3, DC111_1_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC111_1_mul :
    N_entry_0_4 * N_entry_1_5 * N_entry_2_3 =
      ofLadj DC111_1_pre DC111_1_pim := by
  rw [DC111_1_ab_mul, N_entry_2_3, ofLadj_mul, DC111_1_pre_eq, DC111_1_pim_eq]

def DC111_2_ab_pre : Polynomial ℚ := interpQ 1 [-450, 288, -174, -808, 872, -666, -494, 1402, -1436, 348, 1284, -1316, 996, 522, -628, 1010, 32, -140, 480]
def DC111_2_ab_pim : Polynomial ℚ := interpQ 1 [-390, -780, 150, -1214, -946, 160, -2270, -626, -518, -3326, -108, -1092, -2076, 212, -1232, -1032, 36, -890, -360]
def DC111_2_pre : Polynomial ℚ := interpQ 1 [5220, -25056, -9162, 8002, -88892, 4766, -29294, -175104, 47162, -150346, -236826, 70684, -290162, -179152, 28882, -359506, -78092, -56752, -306974, -10666, -96538, -157718, 6144, -79326, -58570, -388, -33680, -12720]
def DC111_2_pim : Polynomial ℚ := interpQ 1 [13980, 24504, -6294, 63806, 44212, -11512, 154926, 20454, 26146, 265404, -51410, 117252, 262104, -114918, 214268, 156250, -105734, 241752, 33046, -47274, 154290, -31594, 3504, 65868, -29010, 12526, 15510, -9960]
theorem DC111_2_ab_pre_eq :
    N_re_0_5 * N_re_1_3 - N_im_0_5 * N_im_1_3 =
      DC111_2_ab_pre := by
  simp only [z_N_re_0_5, z_N_im_0_5, z_N_re_1_3, z_N_im_1_3, DC111_2_ab_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC111_2_ab_pim_eq :
    N_re_0_5 * N_im_1_3 + N_im_0_5 * N_re_1_3 =
      DC111_2_ab_pim := by
  simp only [z_N_re_0_5, z_N_im_0_5, z_N_re_1_3, z_N_im_1_3, DC111_2_ab_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC111_2_ab_mul :
    N_entry_0_5 * N_entry_1_3 =
      ofLadj DC111_2_ab_pre DC111_2_ab_pim := by
  rw [N_entry_0_5, N_entry_1_3, ofLadj_mul,
    DC111_2_ab_pre_eq, DC111_2_ab_pim_eq]

theorem DC111_2_pre_eq :
    DC111_2_ab_pre * N_re_2_4 - DC111_2_ab_pim * N_im_2_4 =
      DC111_2_pre := by
  simp only [DC111_2_ab_pre, DC111_2_ab_pim, z_N_re_2_4, z_N_im_2_4, DC111_2_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC111_2_pim_eq :
    DC111_2_ab_pre * N_im_2_4 + DC111_2_ab_pim * N_re_2_4 =
      DC111_2_pim := by
  simp only [DC111_2_ab_pre, DC111_2_ab_pim, z_N_re_2_4, z_N_im_2_4, DC111_2_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC111_2_mul :
    N_entry_0_5 * N_entry_1_3 * N_entry_2_4 =
      ofLadj DC111_2_pre DC111_2_pim := by
  rw [DC111_2_ab_mul, N_entry_2_4, ofLadj_mul, DC111_2_pre_eq, DC111_2_pim_eq]

def DC111_3_ab_pre : Polynomial ℚ := interpQ 1 [-380, 456, 117, -541, 1172, -481, -345, 1498, -1409, 391, 1338, -1360, 882, 274, -868, 766, -120, -256, 440]
def DC111_3_ab_pim : Polynomial ℚ := interpQ 1 [-475, -950, -115, -1656, -1506, -572, -3102, -1542, -1388, -4223, -976, -1888, -2800, -388, -1682, -1358, -100, -952, -320]
def DC111_3_pre : Polynomial ℚ := interpQ 1 [2660, -32832, -23144, -13542, -122265, -36924, -84184, -242998, -28838, -239585, -337478, -31576, -397436, -282339, -67638, -449216, -157058, -121198, -361963, -52894, -128064, -179156, -6844, -86366, -62166, -552, -33480, -11400]
def DC111_3_pim : Polynomial ℚ := interpQ 1 [15010, 24548, -7253, 65253, 47626, -3633, 171883, 42593, 56491, 306094, -6729, 169862, 325799, -46875, 289698, 233466, -34051, 309825, 92859, 3666, 198840, 4454, 32540, 86752, -15982, 19716, 18280, -9200]
theorem DC111_3_ab_pre_eq :
    N_re_0_3 * N_re_1_5 - N_im_0_3 * N_im_1_5 =
      DC111_3_ab_pre := by
  simp only [z_N_re_0_3, z_N_im_0_3, z_N_re_1_5, z_N_im_1_5, DC111_3_ab_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC111_3_ab_pim_eq :
    N_re_0_3 * N_im_1_5 + N_im_0_3 * N_re_1_5 =
      DC111_3_ab_pim := by
  simp only [z_N_re_0_3, z_N_im_0_3, z_N_re_1_5, z_N_im_1_5, DC111_3_ab_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC111_3_ab_mul :
    N_entry_0_3 * N_entry_1_5 =
      ofLadj DC111_3_ab_pre DC111_3_ab_pim := by
  rw [N_entry_0_3, N_entry_1_5, ofLadj_mul,
    DC111_3_ab_pre_eq, DC111_3_ab_pim_eq]

theorem DC111_3_pre_eq :
    DC111_3_ab_pre * N_re_2_4 - DC111_3_ab_pim * N_im_2_4 =
      DC111_3_pre := by
  simp only [DC111_3_ab_pre, DC111_3_ab_pim, z_N_re_2_4, z_N_im_2_4, DC111_3_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC111_3_pim_eq :
    DC111_3_ab_pre * N_im_2_4 + DC111_3_ab_pim * N_re_2_4 =
      DC111_3_pim := by
  simp only [DC111_3_ab_pre, DC111_3_ab_pim, z_N_re_2_4, z_N_im_2_4, DC111_3_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC111_3_mul :
    N_entry_0_3 * N_entry_1_5 * N_entry_2_4 =
      ofLadj DC111_3_pre DC111_3_pim := by
  rw [DC111_3_ab_mul, N_entry_2_4, ofLadj_mul, DC111_3_pre_eq, DC111_3_pim_eq]

def DC111_3_spre : Polynomial ℚ := interpQ 1 [-2660, 32832, 23144, 13542, 122265, 36924, 84184, 242998, 28838, 239585, 337478, 31576, 397436, 282339, 67638, 449216, 157058, 121198, 361963, 52894, 128064, 179156, 6844, 86366, 62166, 552, 33480, 11400]
def DC111_3_spim : Polynomial ℚ := interpQ 1 [-15010, -24548, 7253, -65253, -47626, 3633, -171883, -42593, -56491, -306094, 6729, -169862, -325799, 46875, -289698, -233466, 34051, -309825, -92859, -3666, -198840, -4454, -32540, -86752, 15982, -19716, -18280, 9200]
theorem DC111_3_spre_eq : -DC111_3_pre = DC111_3_spre := by
  simp only [DC111_3_pre, DC111_3_spre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem DC111_3_spim_eq : -DC111_3_pim = DC111_3_spim := by
  simp only [DC111_3_pim, DC111_3_spim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem DC111_3_smul :
    -(N_entry_0_3 * N_entry_1_5 * N_entry_2_4) =
      ofLadj DC111_3_spre DC111_3_spim := by
  rw [DC111_3_mul, ofLadj_neg, DC111_3_spre_eq, DC111_3_spim_eq]

def DC111_4_ab_pre : Polynomial ℚ := interpQ 1 [-450, 288, -174, -808, 872, -666, -494, 1402, -1436, 348, 1284, -1316, 996, 522, -628, 1010, 32, -140, 480]
def DC111_4_ab_pim : Polynomial ℚ := interpQ 1 [-390, -780, 150, -1214, -946, 160, -2270, -626, -518, -3326, -108, -1092, -2076, 212, -1232, -1032, 36, -890, -360]
def DC111_4_pre : Polynomial ℚ := interpQ 1 [5220, -25056, -8712, 8164, -88556, 6360, -28860, -174280, 49576, -150380, -236016, 72800, -291572, -179112, 29852, -362444, -79232, -57212, -310740, -12320, -97876, -161032, 4976, -80420, -60432, -760, -34020, -13200]
def DC111_4_pim : Polynomial ℚ := interpQ 1 [13980, 24504, -5904, 64976, 45232, -8888, 159276, 24104, 32500, 273480, -44580, 127952, 273848, -105048, 227968, 169488, -95768, 254092, 43528, -40072, 162988, -25256, 7624, 70596, -26404, 13740, 16760, -9600]
theorem DC111_4_ab_pre_eq :
    N_re_0_4 * N_re_1_3 - N_im_0_4 * N_im_1_3 =
      DC111_4_ab_pre := by
  simp only [z_N_re_0_4, z_N_im_0_4, z_N_re_1_3, z_N_im_1_3, DC111_4_ab_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC111_4_ab_pim_eq :
    N_re_0_4 * N_im_1_3 + N_im_0_4 * N_re_1_3 =
      DC111_4_ab_pim := by
  simp only [z_N_re_0_4, z_N_im_0_4, z_N_re_1_3, z_N_im_1_3, DC111_4_ab_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC111_4_ab_mul :
    N_entry_0_4 * N_entry_1_3 =
      ofLadj DC111_4_ab_pre DC111_4_ab_pim := by
  rw [N_entry_0_4, N_entry_1_3, ofLadj_mul,
    DC111_4_ab_pre_eq, DC111_4_ab_pim_eq]

theorem DC111_4_pre_eq :
    DC111_4_ab_pre * N_re_2_5 - DC111_4_ab_pim * N_im_2_5 =
      DC111_4_pre := by
  simp only [DC111_4_ab_pre, DC111_4_ab_pim, z_N_re_2_5, z_N_im_2_5, DC111_4_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC111_4_pim_eq :
    DC111_4_ab_pre * N_im_2_5 + DC111_4_ab_pim * N_re_2_5 =
      DC111_4_pim := by
  simp only [DC111_4_ab_pre, DC111_4_ab_pim, z_N_re_2_5, z_N_im_2_5, DC111_4_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC111_4_mul :
    N_entry_0_4 * N_entry_1_3 * N_entry_2_5 =
      ofLadj DC111_4_pre DC111_4_pim := by
  rw [DC111_4_ab_mul, N_entry_2_5, ofLadj_mul, DC111_4_pre_eq, DC111_4_pim_eq]

def DC111_4_spre : Polynomial ℚ := interpQ 1 [-5220, 25056, 8712, -8164, 88556, -6360, 28860, 174280, -49576, 150380, 236016, -72800, 291572, 179112, -29852, 362444, 79232, 57212, 310740, 12320, 97876, 161032, -4976, 80420, 60432, 760, 34020, 13200]
def DC111_4_spim : Polynomial ℚ := interpQ 1 [-13980, -24504, 5904, -64976, -45232, 8888, -159276, -24104, -32500, -273480, 44580, -127952, -273848, 105048, -227968, -169488, 95768, -254092, -43528, 40072, -162988, 25256, -7624, -70596, 26404, -13740, -16760, 9600]
theorem DC111_4_spre_eq : -DC111_4_pre = DC111_4_spre := by
  simp only [DC111_4_pre, DC111_4_spre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem DC111_4_spim_eq : -DC111_4_pim = DC111_4_spim := by
  simp only [DC111_4_pim, DC111_4_spim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem DC111_4_smul :
    -(N_entry_0_4 * N_entry_1_3 * N_entry_2_5) =
      ofLadj DC111_4_spre DC111_4_spim := by
  rw [DC111_4_mul, ofLadj_neg, DC111_4_spre_eq, DC111_4_spim_eq]

def DC111_5_ab_pre : Polynomial ℚ := interpQ 1 [-180, 144, -36, -324, 384, -308, -236, 564, -660, 136, 552, -576, 408, 172, -336, 372, -32, -104, 192]
def DC111_5_ab_pim : Polynomial ℚ := interpQ 1 [-180, -360, 12, -612, -504, -52, -1100, -396, -324, -1544, -168, -600, -1032, -28, -624, -516, -16, -392, -144]
def DC111_5_pre : Polynomial ℚ := interpQ 1 [5940, -25056, -9744, 7008, -90876, 3760, -31340, -176904, 47904, -150968, -237416, 69032, -292696, -180152, 28464, -358560, -77228, -53624, -303300, -10608, -94568, -155496, 7728, -75160, -55640, 1824, -30768, -11496]
def DC111_5_pim : Polynomial ℚ := interpQ 1 [14400, 25416, -5160, 67752, 50256, -2364, 169268, 37504, 47608, 291548, -23028, 150260, 298572, -74656, 255896, 198280, -64656, 278176, 67440, -17152, 178840, -8244, 21388, 79380, -18476, 17992, 18616, -8328]
theorem DC111_5_ab_pre_eq :
    N_re_0_5 * N_re_1_4 - N_im_0_5 * N_im_1_4 =
      DC111_5_ab_pre := by
  simp only [z_N_re_0_5, z_N_im_0_5, z_N_re_1_4, z_N_im_1_4, DC111_5_ab_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC111_5_ab_pim_eq :
    N_re_0_5 * N_im_1_4 + N_im_0_5 * N_re_1_4 =
      DC111_5_ab_pim := by
  simp only [z_N_re_0_5, z_N_im_0_5, z_N_re_1_4, z_N_im_1_4, DC111_5_ab_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC111_5_ab_mul :
    N_entry_0_5 * N_entry_1_4 =
      ofLadj DC111_5_ab_pre DC111_5_ab_pim := by
  rw [N_entry_0_5, N_entry_1_4, ofLadj_mul,
    DC111_5_ab_pre_eq, DC111_5_ab_pim_eq]

theorem DC111_5_pre_eq :
    DC111_5_ab_pre * N_re_2_3 - DC111_5_ab_pim * N_im_2_3 =
      DC111_5_pre := by
  simp only [DC111_5_ab_pre, DC111_5_ab_pim, z_N_re_2_3, z_N_im_2_3, DC111_5_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC111_5_pim_eq :
    DC111_5_ab_pre * N_im_2_3 + DC111_5_ab_pim * N_re_2_3 =
      DC111_5_pim := by
  simp only [DC111_5_ab_pre, DC111_5_ab_pim, z_N_re_2_3, z_N_im_2_3, DC111_5_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC111_5_mul :
    N_entry_0_5 * N_entry_1_4 * N_entry_2_3 =
      ofLadj DC111_5_pre DC111_5_pim := by
  rw [DC111_5_ab_mul, N_entry_2_3, ofLadj_mul, DC111_5_pre_eq, DC111_5_pim_eq]

def DC111_5_spre : Polynomial ℚ := interpQ 1 [-5940, 25056, 9744, -7008, 90876, -3760, 31340, 176904, -47904, 150968, 237416, -69032, 292696, 180152, -28464, 358560, 77228, 53624, 303300, 10608, 94568, 155496, -7728, 75160, 55640, -1824, 30768, 11496]
def DC111_5_spim : Polynomial ℚ := interpQ 1 [-14400, -25416, 5160, -67752, -50256, 2364, -169268, -37504, -47608, -291548, 23028, -150260, -298572, 74656, -255896, -198280, 64656, -278176, -67440, 17152, -178840, 8244, -21388, -79380, 18476, -17992, -18616, 8328]
theorem DC111_5_spre_eq : -DC111_5_pre = DC111_5_spre := by
  simp only [DC111_5_pre, DC111_5_spre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem DC111_5_spim_eq : -DC111_5_pim = DC111_5_spim := by
  simp only [DC111_5_pim, DC111_5_spim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem DC111_5_smul :
    -(N_entry_0_5 * N_entry_1_4 * N_entry_2_3) =
      ofLadj DC111_5_spre DC111_5_spim := by
  rw [DC111_5_mul, ofLadj_neg, DC111_5_spre_eq, DC111_5_spim_eq]

@[expose] public def detCoeff_111 : Ki :=
  N_entry_0_3 * N_entry_1_4 * N_entry_2_5 + N_entry_0_4 * N_entry_1_5 * N_entry_2_3 + N_entry_0_5 * N_entry_1_3 * N_entry_2_4 + (-(N_entry_0_3 * N_entry_1_5 * N_entry_2_4)) + (-(N_entry_0_4 * N_entry_1_3 * N_entry_2_5)) + (-(N_entry_0_5 * N_entry_1_4 * N_entry_2_3))

theorem detCoeff_111_sum :
    detCoeff_111 = ofLadj (DC111_0_pre + DC111_1_pre + DC111_2_pre + DC111_3_spre + DC111_4_spre + DC111_5_spre) (DC111_0_pim + DC111_1_pim + DC111_2_pim + DC111_3_spim + DC111_4_spim + DC111_5_spim) := by
  simp only [detCoeff_111, DC111_0_mul, DC111_1_mul, DC111_2_mul, DC111_3_smul, DC111_4_smul, DC111_5_smul]
  simpa [add_assoc] using ofLadj_add6 DC111_0_pre DC111_0_pim DC111_1_pre DC111_1_pim DC111_2_pre DC111_2_pim DC111_3_spre DC111_3_spim DC111_4_spre DC111_4_spim DC111_5_spre DC111_5_spim

def DC111_qre : Polynomial ℚ := interpQ 1 [270, 78, 119, -113, -226, -448, -480, -435, -235, -90, 132, 242, 360, 356, 284, 152, 116, 40]
def DC111_qim : Polynomial ℚ := interpQ 1 [-111, -111, -124, 29, 78, 171, 680, 750, 1097, 1182, 1110, 988, 776, 512, 286, 136, 62, -40]

theorem detCoeff_111_sum_poly_re :
    DC111_0_pre + DC111_1_pre + DC111_2_pre + DC111_3_spre + DC111_4_spre + DC111_5_spre = Fplus_re_111 + Phi11 * DC111_qre := by
  rw [phi11_interpQ]
  simp only [DC111_0_pre, DC111_1_pre, DC111_2_pre, DC111_3_spre, DC111_4_spre, DC111_5_spre, z_Fplus_re_111, DC111_qre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem detCoeff_111_sum_poly_im :
    DC111_0_pim + DC111_1_pim + DC111_2_pim + DC111_3_spim + DC111_4_spim + DC111_5_spim = Fplus_im_111 + Phi11 * DC111_qim := by
  rw [phi11_interpQ]
  simp only [DC111_0_pim, DC111_1_pim, DC111_2_pim, DC111_3_spim, DC111_4_spim, DC111_5_spim, z_Fplus_im_111, DC111_qim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

public theorem detCoeff_111_eq :
    detCoeff_111 = ofLadj Fplus_re_111 Fplus_im_111 := by
  rw [detCoeff_111_sum, detCoeff_111_sum_poly_re,
    detCoeff_111_sum_poly_im, ofLadj_add_Phi11]

end V14Formalization.D12SigmaPlusSegreCore
