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

def CW_300_0_pre : Polynomial ℚ := interpQ 34559831724 [9669329051220, 0, -7048275851478, -22552105923933, -70548736994253, -118448267081241, -168670027033908, -208809074877870, -223916374249143, -230373132570705, -235352392324311, -246638486866170, -235352392324311, -223324856719227, -201364268325210, -147183123652917, -95697072391983, -45475312439316, -8922785769300]
def CW_300_0_pim : Polynomial ℚ := interpQ 34559831724 [31278828535326, 62557657070652, 101260285230696, 154907436979533, 187053760399887, 203275829759469, 207184863967386, 177040260234306, 157527708029181, 156583037118429, 152228190814791, 114689037962862, 77149885110933, 34092410647251, -20499412012338, -50135906847417, -60624961004781, -57899999725698, -22022380790400]
theorem CW_300_0_pre_eq :
    CW_0_re_100 * Fplus_dU_re_200 - CW_0_im_100 * Fplus_dU_im_200 = CW_300_0_pre := by
  simp only [CW_0_re_100_def, CW_0_im_100_def, Fplus_dU_re_200_def, Fplus_dU_im_200_def, CW_300_0_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_300_0_pim_eq :
    CW_0_re_100 * Fplus_dU_im_200 + CW_0_im_100 * Fplus_dU_re_200 = CW_300_0_pim := by
  simp only [CW_0_re_100_def, CW_0_im_100_def, Fplus_dU_re_200_def, Fplus_dU_im_200_def, CW_300_0_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_300_0_mul :
    CW_0_c_100 * Fplus_dU_c_200 = ofLadj CW_300_0_pre CW_300_0_pim := by
  rw [CW_0_c_100_def, Fplus_dU_c_200_def, ofLadj_mul, CW_300_0_pre_eq, CW_300_0_pim_eq]

def CW_300_1_pre : Polynomial ℚ := interpQ 34559831724 [429382996330, -17243392349984, -34119347130409, -55669281655836, -94534221360887, -120670494674522, -145891472416093, -156575558133609, -145586335599765, -138009353558618, -131978629677162, -130478668082850, -114735237327178, -103890006428209, -89917053943929, -58368252526825, -36488858194817, -11267880453246, 3673084245897]
def CW_300_1_pim : Polynomial ℚ := interpQ 34559831724 [16442320044472, 32884640088944, 42080423124961, 58216273146922, 58317395412083, 42991049425170, 26156668827821, -6910070591627, -24278025172703, -23220822458284, -18001579044452, -27018399167828, -36035219291204, -40011758913389, -55090406220931, -58186435114547, -49706733687521, -40593142812182, -14373047952621]
theorem CW_300_1_pre_eq :
    CW_1_re_100 * Fplus_dV_re_200 - CW_1_im_100 * Fplus_dV_im_200 = CW_300_1_pre := by
  simp only [CW_1_re_100_def, CW_1_im_100_def, Fplus_dV_re_200_def, Fplus_dV_im_200_def, CW_300_1_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_300_1_pim_eq :
    CW_1_re_100 * Fplus_dV_im_200 + CW_1_im_100 * Fplus_dV_re_200 = CW_300_1_pim := by
  simp only [CW_1_re_100_def, CW_1_im_100_def, Fplus_dV_re_200_def, Fplus_dV_im_200_def, CW_300_1_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_300_1_mul :
    CW_1_c_100 * Fplus_dV_c_200 = ofLadj CW_300_1_pre CW_300_1_pim := by
  rw [CW_1_c_100_def, Fplus_dV_c_200_def, ofLadj_mul, CW_300_1_pre_eq, CW_300_1_pim_eq]

def CW_300_2_pre : Polynomial ℚ := interpQ 34559831724 [1462221741556, 15934948935136, 29288698570980, 46239254313865, 66679917850272, 74574473525429, 83568570336213, 85960441218946, 79698493490524, 78578269770939, 77526805643089, 75752004801530, 61591856707953, 49289571199959, 33459239176659, 14150200326226, 6926002458750, -2068094352034, -5130323042448]
def CW_300_2_pim : Polynomial ℚ := interpQ 34559831724 [-7656616178828, -15313232357656, -13607978538872, -15452111787525, -4230346735254, 9817756908105, 20652584851735, 36032669058390, 43481405679930, 43368873876263, 42504476766069, 48995917340404, 55487357914739, 52917706985761, 54649308430747, 43912621421656, 30978147135966, 21230113427346, 6963658578360]
theorem CW_300_2_pre_eq :
    CW_2_re_100 * Fplus_dW_re_200 - CW_2_im_100 * Fplus_dW_im_200 = CW_300_2_pre := by
  simp only [CW_2_re_100_def, CW_2_im_100_def, Fplus_dW_re_200_def, Fplus_dW_im_200_def, CW_300_2_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_300_2_pim_eq :
    CW_2_re_100 * Fplus_dW_im_200 + CW_2_im_100 * Fplus_dW_re_200 = CW_300_2_pim := by
  simp only [CW_2_re_100_def, CW_2_im_100_def, Fplus_dW_re_200_def, Fplus_dW_im_200_def, CW_300_2_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_300_2_mul :
    CW_2_c_100 * Fplus_dW_c_200 = ofLadj CW_300_2_pre CW_300_2_pim := by
  rw [CW_2_c_100_def, Fplus_dW_c_200_def, ofLadj_mul, CW_300_2_pre_eq, CW_300_2_pim_eq]

@[expose] public def CW_coeff_300 : Ki := CW_0_c_100 * Fplus_dU_c_200 + CW_1_c_100 * Fplus_dV_c_200 + CW_2_c_100 * Fplus_dW_c_200

theorem CW_coeff_300_sum :
    CW_coeff_300 = ofLadj (CW_300_0_pre + CW_300_1_pre + CW_300_2_pre) (CW_300_0_pim + CW_300_1_pim + CW_300_2_pim) := by
  simp only [CW_coeff_300, CW_300_0_mul, CW_300_1_mul, CW_300_2_mul]
  simpa [add_assoc] using ofLadj_add3 CW_300_0_pre CW_300_0_pim CW_300_1_pre CW_300_1_pim CW_300_2_pre CW_300_2_pim

def CW_300_qre : Polynomial ℚ := interpQ 34559831724 [11560933789106, -12869377203954, -10570480996059, -20103208854997, -66420907238964, -66141247725466, -66448640883454, -48431262678745, -10380024565851]
def CW_300_qim : Polynomial ℚ := interpQ 34559831724 [40064532400970, 40064532400970, 49603665014845, 67938868522145, 43469210737786, 14943827016028, -2090518445802, -47831258945873, -29431770164661]
theorem CW_coeff_300_poly_re :
    CW_300_0_pre + CW_300_1_pre + CW_300_2_pre = (0 : Polynomial ℚ) + Phi11 * CW_300_qre := by
  rw [phi11_interpQ]
  simp only [CW_300_0_pre, CW_300_1_pre, CW_300_2_pre, CW_300_qre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_coeff_300_poly_im :
    CW_300_0_pim + CW_300_1_pim + CW_300_2_pim = (0 : Polynomial ℚ) + Phi11 * CW_300_qim := by
  rw [phi11_interpQ]
  simp only [CW_300_0_pim, CW_300_1_pim, CW_300_2_pim, CW_300_qim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
public theorem CW_coeff_300_eq :
    CW_coeff_300 = (0 : Ki) := by
  rw [CW_coeff_300_sum, CW_coeff_300_poly_re,
    CW_coeff_300_poly_im, ofLadj_add_Phi11]
  exact ofLadj_zero

end V14Formalization.D12SigmaPlusSegreCore
