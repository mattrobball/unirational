/-
Auto-generated Fplus / det(bilinearN) coefficient identities.
-/
import V14Formalization.D12SigmaPlusSegreEval
import V14Formalization.D12SigmaPlusSegreMul

noncomputable section
open Matrix Polynomial
namespace V14Formalization.D12SigmaPlusSegreCore
open D12PolynomialData

def DC002_0_pre : Polynomial ℚ := C (-44) + C (-50) * X ^ 2 + C (-61) * X ^ 3 + C (2) * X ^ 4 + C (-54) * X ^ 5 + C (-44) * X ^ 6 + C (28) * X ^ 7 + C (-85) * X ^ 8 + C (-41) * X ^ 9 + C (2) * X ^ 10 + C (-86) * X ^ 11 + C (2) * X ^ 12 + C (9) * X ^ 13 + C (-24) * X ^ 14 + C (38) * X ^ 15 + C (8) * X ^ 16 + C (-2) * X ^ 17 + C (12) * X ^ 18
def DC002_0_pim : Polynomial ℚ := C (-16) + C (-32) * X + C (26) * X ^ 2 + C (-27) * X ^ 3 + C (-14) * X ^ 4 + C (44) * X ^ 5 + C (-77) * X ^ 6 + C (5) * X ^ 7 + C (-27) * X ^ 8 + C (-121) * X ^ 9 + C (1) * X ^ 10 + C (-24) * X ^ 11 + C (-49) * X ^ 12 + C (15) * X ^ 13 + C (-26) * X ^ 14 + C (-39) * X ^ 15 + C (-9) * X ^ 16 + C (-38) * X ^ 17 + C (-32) * X ^ 18
theorem DC002_0_pre_eq :
    N_re_0_0 * N_re_1_1 - N_im_0_0 * N_im_1_1 =
      DC002_0_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [N_re_0_0, N_im_0_0, N_re_1_1, N_im_1_1, DC002_0_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring

theorem DC002_0_pim_eq :
    N_re_0_0 * N_im_1_1 + N_im_0_0 * N_re_1_1 =
      DC002_0_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [N_re_0_0, N_im_0_0, N_re_1_1, N_im_1_1, DC002_0_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring

theorem DC002_0_mul :
    N_entry_0_0 * N_entry_1_1 =
      ofLadj DC002_0_pre DC002_0_pim := by
  rw [N_entry_0_0, N_entry_1_1, ofLadj_mul,
    DC002_0_pre_eq, DC002_0_pim_eq]

def DC002_1_pre : Polynomial ℚ := C (-3) + C (32) * X + C (38) * X ^ 2 + C (21) * X ^ 3 + C (88) * X ^ 4 + C (25) * X ^ 5 + C (34) * X ^ 6 + C (80) * X ^ 7 + C (-23) * X ^ 8 + C (17) * X ^ 9 + C (57) * X ^ 10 + C (-64) * X ^ 11 + C (25) * X ^ 12 + C (-21) * X ^ 13 + C (-44) * X ^ 14 + C (7) * X ^ 15 + C (-11) * X ^ 16 + C (-20) * X ^ 17 + C (15) * X ^ 18
def DC002_1_pim : Polynomial ℚ := C (-19) + C (-38) * X + C (-15) * X ^ 2 + C (-84) * X ^ 3 + C (-90) * X ^ 4 + C (-79) * X ^ 5 + C (-182) * X ^ 6 + C (-139) * X ^ 7 + C (-143) * X ^ 8 + C (-230) * X ^ 9 + C (-115) * X ^ 10 + C (-134) * X ^ 11 + C (-153) * X ^ 12 + C (-61) * X ^ 13 + C (-79) * X ^ 14 + C (-74) * X ^ 15 + C (-4) * X ^ 16 + C (-41) * X ^ 17 + C (-3) * X ^ 18
theorem DC002_1_pre_eq :
    N_re_0_1 * N_re_1_0 - N_im_0_1 * N_im_1_0 =
      DC002_1_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [N_re_0_1, N_im_0_1, N_re_1_0, N_im_1_0, DC002_1_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring

theorem DC002_1_pim_eq :
    N_re_0_1 * N_im_1_0 + N_im_0_1 * N_re_1_0 =
      DC002_1_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [N_re_0_1, N_im_0_1, N_re_1_0, N_im_1_0, DC002_1_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring

theorem DC002_1_mul :
    N_entry_0_1 * N_entry_1_0 =
      ofLadj DC002_1_pre DC002_1_pim := by
  rw [N_entry_0_1, N_entry_1_0, ofLadj_mul,
    DC002_1_pre_eq, DC002_1_pim_eq]

def DC002_1_spre : Polynomial ℚ := C (3) + C (-32) * X + C (-38) * X ^ 2 + C (-21) * X ^ 3 + C (-88) * X ^ 4 + C (-25) * X ^ 5 + C (-34) * X ^ 6 + C (-80) * X ^ 7 + C (23) * X ^ 8 + C (-17) * X ^ 9 + C (-57) * X ^ 10 + C (64) * X ^ 11 + C (-25) * X ^ 12 + C (21) * X ^ 13 + C (44) * X ^ 14 + C (-7) * X ^ 15 + C (11) * X ^ 16 + C (20) * X ^ 17 + C (-15) * X ^ 18
def DC002_1_spim : Polynomial ℚ := C (19) + C (38) * X + C (15) * X ^ 2 + C (84) * X ^ 3 + C (90) * X ^ 4 + C (79) * X ^ 5 + C (182) * X ^ 6 + C (139) * X ^ 7 + C (143) * X ^ 8 + C (230) * X ^ 9 + C (115) * X ^ 10 + C (134) * X ^ 11 + C (153) * X ^ 12 + C (61) * X ^ 13 + C (79) * X ^ 14 + C (74) * X ^ 15 + C (4) * X ^ 16 + C (41) * X ^ 17 + C (3) * X ^ 18
theorem DC002_1_spre_eq : -DC002_1_pre = DC002_1_spre := by
  refine Polynomial.funext fun r => ?_
  simp only [DC002_1_pre, DC002_1_spre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem DC002_1_spim_eq : -DC002_1_pim = DC002_1_spim := by
  refine Polynomial.funext fun r => ?_
  simp only [DC002_1_pim, DC002_1_spim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem DC002_1_smul :
    -(N_entry_0_1 * N_entry_1_0) =
      ofLadj DC002_1_spre DC002_1_spim := by
  rw [DC002_1_mul, ofLadj_neg, DC002_1_spre_eq, DC002_1_spim_eq]

def DC002_2_pre : Polynomial ℚ := C (-44) + C (-44) * X ^ 2 + C (-66) * X ^ 3 + C (-14) * X ^ 4 + C (-68) * X ^ 5 + C (-62) * X ^ 6 + C (-2) * X ^ 7 + C (-100) * X ^ 8 + C (-44) * X ^ 9 + C (-74) * X ^ 11 + C (-34) * X ^ 14 + C (20) * X ^ 15 + C (-10) * X ^ 16 + C (-16) * X ^ 17 + C (8) * X ^ 18
def DC002_2_pim : Polynomial ℚ := C (-12) + C (-24) * X + C (24) * X ^ 2 + C (-28) * X ^ 3 + C (-14) * X ^ 4 + C (48) * X ^ 5 + C (-62) * X ^ 6 + C (20) * X ^ 7 + C (4) * X ^ 8 + C (-86) * X ^ 9 + C (18) * X ^ 10 + C (-18) * X ^ 11 + C (-54) * X ^ 12 + C (2) * X ^ 13 + C (-36) * X ^ 14 + C (-42) * X ^ 15 + C (-14) * X ^ 16 + C (-32) * X ^ 17 + C (-24) * X ^ 18
theorem DC002_2_pre_eq :
    N_re_0_0 * N_re_2_2 - N_im_0_0 * N_im_2_2 =
      DC002_2_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [N_re_0_0, N_im_0_0, N_re_2_2, N_im_2_2, DC002_2_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring

theorem DC002_2_pim_eq :
    N_re_0_0 * N_im_2_2 + N_im_0_0 * N_re_2_2 =
      DC002_2_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [N_re_0_0, N_im_0_0, N_re_2_2, N_im_2_2, DC002_2_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring

theorem DC002_2_mul :
    N_entry_0_0 * N_entry_2_2 =
      ofLadj DC002_2_pre DC002_2_pim := by
  rw [N_entry_0_0, N_entry_2_2, ofLadj_mul,
    DC002_2_pre_eq, DC002_2_pim_eq]

def DC002_3_pre : Polynomial ℚ := C (6) + C (24) * X + C (20) * X ^ 2 + C (-6) * X ^ 3 + C (50) * X ^ 4 + C (5) * X ^ 5 + C (13) * X ^ 6 + C (80) * X ^ 7 + C (9) * X ^ 8 + C (65) * X ^ 9 + C (111) * X ^ 10 + C (-12) * X ^ 11 + C (87) * X ^ 12 + C (45) * X ^ 13 + C (15) * X ^ 14 + C (62) * X ^ 15 + C (24) * X ^ 16 + C (16) * X ^ 17 + C (32) * X ^ 18
def DC002_3_pim : Polynomial ℚ := C (-12) + C (-24) * X + C ((-67 / 2 : ℚ)) * X ^ 3 + C (-32) * X ^ 4 + C ((7 / 2 : ℚ)) * X ^ 5 + C ((-141 / 2 : ℚ)) * X ^ 6 + C (-16) * X ^ 7 + C ((-17 / 2 : ℚ)) * X ^ 8 + C (-97) * X ^ 9 + C (4) * X ^ 10 + C (-32) * X ^ 11 + C (-68) * X ^ 12 + C (9) * X ^ 13 + C (-46) * X ^ 14 + C (-40) * X ^ 15 + C (15) * X ^ 16 + C (-36) * X ^ 17
theorem DC002_3_pre_eq :
    N_re_0_2 * N_re_2_0 - N_im_0_2 * N_im_2_0 =
      DC002_3_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [N_re_0_2, N_im_0_2, N_re_2_0, N_im_2_0, DC002_3_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring

theorem DC002_3_pim_eq :
    N_re_0_2 * N_im_2_0 + N_im_0_2 * N_re_2_0 =
      DC002_3_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [N_re_0_2, N_im_0_2, N_re_2_0, N_im_2_0, DC002_3_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring

theorem DC002_3_mul :
    N_entry_0_2 * N_entry_2_0 =
      ofLadj DC002_3_pre DC002_3_pim := by
  rw [N_entry_0_2, N_entry_2_0, ofLadj_mul,
    DC002_3_pre_eq, DC002_3_pim_eq]

def DC002_3_spre : Polynomial ℚ := C (-6) + C (-24) * X + C (-20) * X ^ 2 + C (6) * X ^ 3 + C (-50) * X ^ 4 + C (-5) * X ^ 5 + C (-13) * X ^ 6 + C (-80) * X ^ 7 + C (-9) * X ^ 8 + C (-65) * X ^ 9 + C (-111) * X ^ 10 + C (12) * X ^ 11 + C (-87) * X ^ 12 + C (-45) * X ^ 13 + C (-15) * X ^ 14 + C (-62) * X ^ 15 + C (-24) * X ^ 16 + C (-16) * X ^ 17 + C (-32) * X ^ 18
def DC002_3_spim : Polynomial ℚ := C (12) + C (24) * X + C ((67 / 2 : ℚ)) * X ^ 3 + C (32) * X ^ 4 + C ((-7 / 2 : ℚ)) * X ^ 5 + C ((141 / 2 : ℚ)) * X ^ 6 + C (16) * X ^ 7 + C ((17 / 2 : ℚ)) * X ^ 8 + C (97) * X ^ 9 + C (-4) * X ^ 10 + C (32) * X ^ 11 + C (68) * X ^ 12 + C (-9) * X ^ 13 + C (46) * X ^ 14 + C (40) * X ^ 15 + C (-15) * X ^ 16 + C (36) * X ^ 17
theorem DC002_3_spre_eq : -DC002_3_pre = DC002_3_spre := by
  refine Polynomial.funext fun r => ?_
  simp only [DC002_3_pre, DC002_3_spre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem DC002_3_spim_eq : -DC002_3_pim = DC002_3_spim := by
  refine Polynomial.funext fun r => ?_
  simp only [DC002_3_pim, DC002_3_spim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem DC002_3_smul :
    -(N_entry_0_2 * N_entry_2_0) =
      ofLadj DC002_3_spre DC002_3_spim := by
  rw [DC002_3_mul, ofLadj_neg, DC002_3_spre_eq, DC002_3_spim_eq]

def DC002_4_pre : Polynomial ℚ := C (109) + C (-48) * X + C (68) * X ^ 2 + C (189) * X ^ 3 + C (-125) * X ^ 4 + C (184) * X ^ 5 + C (167) * X ^ 6 + C (-212) * X ^ 7 + C (358) * X ^ 8 + C (21) * X ^ 9 + C (-180) * X ^ 10 + C (308) * X ^ 11 + C (-132) * X ^ 12 + C (-47) * X ^ 13 + C (169) * X ^ 14 + C (-155) * X ^ 15 + C (35) * X ^ 16 + C (52) * X ^ 17 + C (-68) * X ^ 18
def DC002_4_pim : Polynomial ℚ := C (77) + C (154) * X + C (-24) * X ^ 2 + C (240) * X ^ 3 + C (212) * X ^ 4 + C (-22) * X ^ 5 + C (479) * X ^ 6 + C (140) * X ^ 7 + C (149) * X ^ 8 + C (685) * X ^ 9 + C (60) * X ^ 10 + C (260) * X ^ 11 + C (460) * X ^ 12 + C (13) * X ^ 13 + C (285) * X ^ 14 + C (238) * X ^ 15 + C (33) * X ^ 16 + C (184) * X ^ 17 + C (84) * X ^ 18
theorem DC002_4_pre_eq :
    N_re_1_1 * N_re_2_2 - N_im_1_1 * N_im_2_2 =
      DC002_4_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [N_re_1_1, N_im_1_1, N_re_2_2, N_im_2_2, DC002_4_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring

theorem DC002_4_pim_eq :
    N_re_1_1 * N_im_2_2 + N_im_1_1 * N_re_2_2 =
      DC002_4_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [N_re_1_1, N_im_1_1, N_re_2_2, N_im_2_2, DC002_4_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring

theorem DC002_4_mul :
    N_entry_1_1 * N_entry_2_2 =
      ofLadj DC002_4_pre DC002_4_pim := by
  rw [N_entry_1_1, N_entry_2_2, ofLadj_mul,
    DC002_4_pre_eq, DC002_4_pim_eq]

def DC002_5_pre : Polynomial ℚ := C (103) + C (-78) * X + C (40) * X ^ 2 + C (159) * X ^ 3 + C (-156) * X ^ 4 + C (175) * X ^ 5 + C (166) * X ^ 6 + C (-195) * X ^ 7 + C (376) * X ^ 8 + C (38) * X ^ 9 + C (-163) * X ^ 10 + C (328) * X ^ 11 + C (-85) * X ^ 12 + C (-2) * X ^ 13 + C (217) * X ^ 14 + C (-104) * X ^ 15 + C (64) * X ^ 16 + C (73) * X ^ 17 + C (-65) * X ^ 18
def DC002_5_pim : Polynomial ℚ := C (106) + C (212) * X + C (44) * X ^ 2 + C (357) * X ^ 3 + C (346) * X ^ 4 + C (136) * X ^ 5 + C (645) * X ^ 6 + C (306) * X ^ 7 + C (320) * X ^ 8 + C (856) * X ^ 9 + C (232) * X ^ 10 + C (404) * X ^ 11 + C (576) * X ^ 12 + C (120) * X ^ 13 + C (343) * X ^ 14 + C (278) * X ^ 15 + C (50) * X ^ 16 + C (189) * X ^ 17 + C (90) * X ^ 18
theorem DC002_5_pre_eq :
    N_re_1_2 * N_re_2_1 - N_im_1_2 * N_im_2_1 =
      DC002_5_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [N_re_1_2, N_im_1_2, N_re_2_1, N_im_2_1, DC002_5_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring

theorem DC002_5_pim_eq :
    N_re_1_2 * N_im_2_1 + N_im_1_2 * N_re_2_1 =
      DC002_5_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [N_re_1_2, N_im_1_2, N_re_2_1, N_im_2_1, DC002_5_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring

theorem DC002_5_mul :
    N_entry_1_2 * N_entry_2_1 =
      ofLadj DC002_5_pre DC002_5_pim := by
  rw [N_entry_1_2, N_entry_2_1, ofLadj_mul,
    DC002_5_pre_eq, DC002_5_pim_eq]

def DC002_5_spre : Polynomial ℚ := C (-103) + C (78) * X + C (-40) * X ^ 2 + C (-159) * X ^ 3 + C (156) * X ^ 4 + C (-175) * X ^ 5 + C (-166) * X ^ 6 + C (195) * X ^ 7 + C (-376) * X ^ 8 + C (-38) * X ^ 9 + C (163) * X ^ 10 + C (-328) * X ^ 11 + C (85) * X ^ 12 + C (2) * X ^ 13 + C (-217) * X ^ 14 + C (104) * X ^ 15 + C (-64) * X ^ 16 + C (-73) * X ^ 17 + C (65) * X ^ 18
def DC002_5_spim : Polynomial ℚ := C (-106) + C (-212) * X + C (-44) * X ^ 2 + C (-357) * X ^ 3 + C (-346) * X ^ 4 + C (-136) * X ^ 5 + C (-645) * X ^ 6 + C (-306) * X ^ 7 + C (-320) * X ^ 8 + C (-856) * X ^ 9 + C (-232) * X ^ 10 + C (-404) * X ^ 11 + C (-576) * X ^ 12 + C (-120) * X ^ 13 + C (-343) * X ^ 14 + C (-278) * X ^ 15 + C (-50) * X ^ 16 + C (-189) * X ^ 17 + C (-90) * X ^ 18
theorem DC002_5_spre_eq : -DC002_5_pre = DC002_5_spre := by
  refine Polynomial.funext fun r => ?_
  simp only [DC002_5_pre, DC002_5_spre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem DC002_5_spim_eq : -DC002_5_pim = DC002_5_spim := by
  refine Polynomial.funext fun r => ?_
  simp only [DC002_5_pim, DC002_5_spim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem DC002_5_smul :
    -(N_entry_1_2 * N_entry_2_1) =
      ofLadj DC002_5_spre DC002_5_spim := by
  rw [DC002_5_mul, ofLadj_neg, DC002_5_spre_eq, DC002_5_spim_eq]

def detCoeff_002 : Ki :=
  N_entry_0_0 * N_entry_1_1 + (-(N_entry_0_1 * N_entry_1_0)) + N_entry_0_0 * N_entry_2_2 + (-(N_entry_0_2 * N_entry_2_0)) + N_entry_1_1 * N_entry_2_2 + (-(N_entry_1_2 * N_entry_2_1))

theorem detCoeff_002_sum :
    detCoeff_002 = ofLadj (DC002_0_pre + DC002_1_spre + DC002_2_pre + DC002_3_spre + DC002_4_pre + DC002_5_spre) (DC002_0_pim + DC002_1_spim + DC002_2_pim + DC002_3_spim + DC002_4_pim + DC002_5_spim) := by
  simp only [detCoeff_002, DC002_0_mul, DC002_1_smul, DC002_2_mul, DC002_3_smul, DC002_4_mul, DC002_5_smul]
  simpa [add_assoc] using ofLadj_add6 DC002_0_pre DC002_0_pim DC002_1_spre DC002_1_spim DC002_2_pre DC002_2_pim DC002_3_spre DC002_3_spim DC002_4_pre DC002_4_pim DC002_5_spre DC002_5_spim

def DC002_qre : Polynomial ℚ := C (-79) + C (53) * X + C (-97) * X ^ 2 + C (17) * X ^ 3 + C (-15) * X ^ 4 + C (-18) * X ^ 5 + C (-9) * X ^ 6 + C (-5) * X ^ 7 + C (-30) * X ^ 8
def DC002_qim : Polynomial ℚ := C (-22) + C (-22) * X + C (40) * X ^ 2 + C (-43) * X ^ 3 + C (12) * X ^ 4 + C (44) * X ^ 5 + C (-53) * X ^ 6 + C (61) * X ^ 7 + C (-59) * X ^ 8

theorem detCoeff_002_sum_poly_re :
    DC002_0_pre + DC002_1_spre + DC002_2_pre + DC002_3_spre + DC002_4_pre + DC002_5_spre = Fplus_re_002 + Phi11 * DC002_qre := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [DC002_0_pre, DC002_1_spre, DC002_2_pre, DC002_3_spre, DC002_4_pre, DC002_5_spre, Fplus_re_002, DC002_qre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try ring

theorem detCoeff_002_sum_poly_im :
    DC002_0_pim + DC002_1_spim + DC002_2_pim + DC002_3_spim + DC002_4_pim + DC002_5_spim = Fplus_im_002 + Phi11 * DC002_qim := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [DC002_0_pim, DC002_1_spim, DC002_2_pim, DC002_3_spim, DC002_4_pim, DC002_5_spim, Fplus_im_002, DC002_qim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try ring

theorem detCoeff_002_eq :
    detCoeff_002 = ofLadj Fplus_re_002 Fplus_im_002 := by
  rw [detCoeff_002_sum, detCoeff_002_sum_poly_re,
    detCoeff_002_sum_poly_im, ofLadj_add_Phi11]

end V14Formalization.D12SigmaPlusSegreCore
