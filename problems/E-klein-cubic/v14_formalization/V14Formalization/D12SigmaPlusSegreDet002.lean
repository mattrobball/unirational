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

def DC002_0_pre : Polynomial ℚ := interpQ 2 [-88, 0, -100, -122, 4, -108, -88, 56, -170, -82, 4, -172, 4, 18, -48, 76, 16, -4, 24]
def DC002_0_pim : Polynomial ℚ := interpQ 2 [-32, -64, 52, -54, -28, 88, -154, 10, -54, -242, 2, -48, -98, 30, -52, -78, -18, -76, -64]
theorem DC002_0_pre_eq :
    N_re_0_0 * N_re_1_1 - N_im_0_0 * N_im_1_1 =
      DC002_0_pre := by
  simp only [z_N_re_0_0, z_N_im_0_0, z_N_re_1_1, z_N_im_1_1, DC002_0_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC002_0_pim_eq :
    N_re_0_0 * N_im_1_1 + N_im_0_0 * N_re_1_1 =
      DC002_0_pim := by
  simp only [z_N_re_0_0, z_N_im_0_0, z_N_re_1_1, z_N_im_1_1, DC002_0_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC002_0_mul :
    N_entry_0_0 * N_entry_1_1 =
      ofLadj DC002_0_pre DC002_0_pim := by
  rw [N_entry_0_0, N_entry_1_1, ofLadj_mul,
    DC002_0_pre_eq, DC002_0_pim_eq]

def DC002_1_pre : Polynomial ℚ := interpQ 2 [-6, 64, 76, 42, 176, 50, 68, 160, -46, 34, 114, -128, 50, -42, -88, 14, -22, -40, 30]
def DC002_1_pim : Polynomial ℚ := interpQ 2 [-38, -76, -30, -168, -180, -158, -364, -278, -286, -460, -230, -268, -306, -122, -158, -148, -8, -82, -6]
theorem DC002_1_pre_eq :
    N_re_0_1 * N_re_1_0 - N_im_0_1 * N_im_1_0 =
      DC002_1_pre := by
  simp only [z_N_re_0_1, z_N_im_0_1, z_N_re_1_0, z_N_im_1_0, DC002_1_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC002_1_pim_eq :
    N_re_0_1 * N_im_1_0 + N_im_0_1 * N_re_1_0 =
      DC002_1_pim := by
  simp only [z_N_re_0_1, z_N_im_0_1, z_N_re_1_0, z_N_im_1_0, DC002_1_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC002_1_mul :
    N_entry_0_1 * N_entry_1_0 =
      ofLadj DC002_1_pre DC002_1_pim := by
  rw [N_entry_0_1, N_entry_1_0, ofLadj_mul,
    DC002_1_pre_eq, DC002_1_pim_eq]

def DC002_1_spre : Polynomial ℚ := interpQ 2 [6, -64, -76, -42, -176, -50, -68, -160, 46, -34, -114, 128, -50, 42, 88, -14, 22, 40, -30]
def DC002_1_spim : Polynomial ℚ := interpQ 2 [38, 76, 30, 168, 180, 158, 364, 278, 286, 460, 230, 268, 306, 122, 158, 148, 8, 82, 6]
theorem DC002_1_spre_eq : -DC002_1_pre = DC002_1_spre := by
  simp only [DC002_1_pre, DC002_1_spre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem DC002_1_spim_eq : -DC002_1_pim = DC002_1_spim := by
  simp only [DC002_1_pim, DC002_1_spim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem DC002_1_smul :
    -(N_entry_0_1 * N_entry_1_0) =
      ofLadj DC002_1_spre DC002_1_spim := by
  rw [DC002_1_mul, ofLadj_neg, DC002_1_spre_eq, DC002_1_spim_eq]

def DC002_2_pre : Polynomial ℚ := interpQ 2 [-88, 0, -88, -132, -28, -136, -124, -4, -200, -88, 0, -148, 0, 0, -68, 40, -20, -32, 16]
def DC002_2_pim : Polynomial ℚ := interpQ 2 [-24, -48, 48, -56, -28, 96, -124, 40, 8, -172, 36, -36, -108, 4, -72, -84, -28, -64, -48]
theorem DC002_2_pre_eq :
    N_re_0_0 * N_re_2_2 - N_im_0_0 * N_im_2_2 =
      DC002_2_pre := by
  simp only [z_N_re_0_0, z_N_im_0_0, z_N_re_2_2, z_N_im_2_2, DC002_2_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC002_2_pim_eq :
    N_re_0_0 * N_im_2_2 + N_im_0_0 * N_re_2_2 =
      DC002_2_pim := by
  simp only [z_N_re_0_0, z_N_im_0_0, z_N_re_2_2, z_N_im_2_2, DC002_2_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC002_2_mul :
    N_entry_0_0 * N_entry_2_2 =
      ofLadj DC002_2_pre DC002_2_pim := by
  rw [N_entry_0_0, N_entry_2_2, ofLadj_mul,
    DC002_2_pre_eq, DC002_2_pim_eq]

def DC002_3_pre : Polynomial ℚ := interpQ 2 [12, 48, 40, -12, 100, 10, 26, 160, 18, 130, 222, -24, 174, 90, 30, 124, 48, 32, 64]
def DC002_3_pim : Polynomial ℚ := interpQ 2 [-24, -48, 0, -67, -64, 7, -141, -32, -17, -194, 8, -64, -136, 18, -92, -80, 30, -72]
theorem DC002_3_pre_eq :
    N_re_0_2 * N_re_2_0 - N_im_0_2 * N_im_2_0 =
      DC002_3_pre := by
  simp only [z_N_re_0_2, z_N_im_0_2, z_N_re_2_0, z_N_im_2_0, DC002_3_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC002_3_pim_eq :
    N_re_0_2 * N_im_2_0 + N_im_0_2 * N_re_2_0 =
      DC002_3_pim := by
  simp only [z_N_re_0_2, z_N_im_0_2, z_N_re_2_0, z_N_im_2_0, DC002_3_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC002_3_mul :
    N_entry_0_2 * N_entry_2_0 =
      ofLadj DC002_3_pre DC002_3_pim := by
  rw [N_entry_0_2, N_entry_2_0, ofLadj_mul,
    DC002_3_pre_eq, DC002_3_pim_eq]

def DC002_3_spre : Polynomial ℚ := interpQ 2 [-12, -48, -40, 12, -100, -10, -26, -160, -18, -130, -222, 24, -174, -90, -30, -124, -48, -32, -64]
def DC002_3_spim : Polynomial ℚ := interpQ 2 [24, 48, 0, 67, 64, -7, 141, 32, 17, 194, -8, 64, 136, -18, 92, 80, -30, 72]
theorem DC002_3_spre_eq : -DC002_3_pre = DC002_3_spre := by
  simp only [DC002_3_pre, DC002_3_spre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem DC002_3_spim_eq : -DC002_3_pim = DC002_3_spim := by
  simp only [DC002_3_pim, DC002_3_spim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem DC002_3_smul :
    -(N_entry_0_2 * N_entry_2_0) =
      ofLadj DC002_3_spre DC002_3_spim := by
  rw [DC002_3_mul, ofLadj_neg, DC002_3_spre_eq, DC002_3_spim_eq]

def DC002_4_pre : Polynomial ℚ := interpQ 2 [218, -96, 136, 378, -250, 368, 334, -424, 716, 42, -360, 616, -264, -94, 338, -310, 70, 104, -136]
def DC002_4_pim : Polynomial ℚ := interpQ 2 [154, 308, -48, 480, 424, -44, 958, 280, 298, 1370, 120, 520, 920, 26, 570, 476, 66, 368, 168]
theorem DC002_4_pre_eq :
    N_re_1_1 * N_re_2_2 - N_im_1_1 * N_im_2_2 =
      DC002_4_pre := by
  simp only [z_N_re_1_1, z_N_im_1_1, z_N_re_2_2, z_N_im_2_2, DC002_4_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC002_4_pim_eq :
    N_re_1_1 * N_im_2_2 + N_im_1_1 * N_re_2_2 =
      DC002_4_pim := by
  simp only [z_N_re_1_1, z_N_im_1_1, z_N_re_2_2, z_N_im_2_2, DC002_4_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC002_4_mul :
    N_entry_1_1 * N_entry_2_2 =
      ofLadj DC002_4_pre DC002_4_pim := by
  rw [N_entry_1_1, N_entry_2_2, ofLadj_mul,
    DC002_4_pre_eq, DC002_4_pim_eq]

def DC002_5_pre : Polynomial ℚ := interpQ 2 [206, -156, 80, 318, -312, 350, 332, -390, 752, 76, -326, 656, -170, -4, 434, -208, 128, 146, -130]
def DC002_5_pim : Polynomial ℚ := interpQ 2 [212, 424, 88, 714, 692, 272, 1290, 612, 640, 1712, 464, 808, 1152, 240, 686, 556, 100, 378, 180]
theorem DC002_5_pre_eq :
    N_re_1_2 * N_re_2_1 - N_im_1_2 * N_im_2_1 =
      DC002_5_pre := by
  simp only [z_N_re_1_2, z_N_im_1_2, z_N_re_2_1, z_N_im_2_1, DC002_5_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC002_5_pim_eq :
    N_re_1_2 * N_im_2_1 + N_im_1_2 * N_re_2_1 =
      DC002_5_pim := by
  simp only [z_N_re_1_2, z_N_im_1_2, z_N_re_2_1, z_N_im_2_1, DC002_5_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC002_5_mul :
    N_entry_1_2 * N_entry_2_1 =
      ofLadj DC002_5_pre DC002_5_pim := by
  rw [N_entry_1_2, N_entry_2_1, ofLadj_mul,
    DC002_5_pre_eq, DC002_5_pim_eq]

def DC002_5_spre : Polynomial ℚ := interpQ 2 [-206, 156, -80, -318, 312, -350, -332, 390, -752, -76, 326, -656, 170, 4, -434, 208, -128, -146, 130]
def DC002_5_spim : Polynomial ℚ := interpQ 2 [-212, -424, -88, -714, -692, -272, -1290, -612, -640, -1712, -464, -808, -1152, -240, -686, -556, -100, -378, -180]
theorem DC002_5_spre_eq : -DC002_5_pre = DC002_5_spre := by
  simp only [DC002_5_pre, DC002_5_spre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem DC002_5_spim_eq : -DC002_5_pim = DC002_5_spim := by
  simp only [DC002_5_pim, DC002_5_spim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem DC002_5_smul :
    -(N_entry_1_2 * N_entry_2_1) =
      ofLadj DC002_5_spre DC002_5_spim := by
  rw [DC002_5_mul, ofLadj_neg, DC002_5_spre_eq, DC002_5_spim_eq]

@[expose] public def detCoeff_002 : Ki :=
  N_entry_0_0 * N_entry_1_1 + (-(N_entry_0_1 * N_entry_1_0)) + N_entry_0_0 * N_entry_2_2 + (-(N_entry_0_2 * N_entry_2_0)) + N_entry_1_1 * N_entry_2_2 + (-(N_entry_1_2 * N_entry_2_1))

theorem detCoeff_002_sum :
    detCoeff_002 = ofLadj (DC002_0_pre + DC002_1_spre + DC002_2_pre + DC002_3_spre + DC002_4_pre + DC002_5_spre) (DC002_0_pim + DC002_1_spim + DC002_2_pim + DC002_3_spim + DC002_4_pim + DC002_5_spim) := by
  simp only [detCoeff_002, DC002_0_mul, DC002_1_smul, DC002_2_mul, DC002_3_smul, DC002_4_mul, DC002_5_smul]
  simpa [add_assoc] using ofLadj_add6 DC002_0_pre DC002_0_pim DC002_1_spre DC002_1_spim DC002_2_pre DC002_2_pim DC002_3_spre DC002_3_spim DC002_4_pre DC002_4_pim DC002_5_spre DC002_5_spim

def DC002_qre : Polynomial ℚ := interpQ 2 [-158, 106, -194, 34, -30, -36, -18, -10, -60]
def DC002_qim : Polynomial ℚ := interpQ 2 [-44, -44, 80, -86, 24, 88, -106, 122, -118]

theorem detCoeff_002_sum_poly_re :
    DC002_0_pre + DC002_1_spre + DC002_2_pre + DC002_3_spre + DC002_4_pre + DC002_5_spre = Fplus_re_002 + Phi11 * DC002_qre := by
  rw [phi11_interpQ]
  simp only [DC002_0_pre, DC002_1_spre, DC002_2_pre, DC002_3_spre, DC002_4_pre, DC002_5_spre, z_Fplus_re_002, DC002_qre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem detCoeff_002_sum_poly_im :
    DC002_0_pim + DC002_1_spim + DC002_2_pim + DC002_3_spim + DC002_4_pim + DC002_5_spim = Fplus_im_002 + Phi11 * DC002_qim := by
  rw [phi11_interpQ]
  simp only [DC002_0_pim, DC002_1_spim, DC002_2_pim, DC002_3_spim, DC002_4_pim, DC002_5_spim, z_Fplus_im_002, DC002_qim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

public theorem detCoeff_002_eq :
    detCoeff_002 = ofLadj Fplus_re_002 Fplus_im_002 := by
  rw [detCoeff_002_sum, detCoeff_002_sum_poly_re,
    detCoeff_002_sum_poly_im, ofLadj_add_Phi11]

end V14Formalization.D12SigmaPlusSegreCore
