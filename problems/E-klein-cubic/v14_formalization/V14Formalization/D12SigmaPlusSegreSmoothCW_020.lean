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

def CW_020_0_pre : Polynomial ℚ := interpQ 17279915862 [-309058612118, 31346885023150, 58792137362342, 102440088106991, 167175257091991, 215022330207784, 263387436822624, 300849651507731, 305802080332819, 316340728182753, 324751155544328, 327669381878199, 293404270521178, 257548590820411, 203361992225828, 128522929557853, 74968469558904, 26603362944064, -5151464857887]
def CW_020_0_pim : Polynomial ℚ := interpQ 17279915862 [-29040669877885, -58081339755770, -78369643917865, -110838905317679, -114806209885202, -103009096579421, -90059512624106, -53175052574206, -27303755018749, -25902812742248, -18572095480133, 20713604136215, 59999303752563, 87618325176773, 121488528853088, 121177858947007, 99892443248075, 76522034472112, 30149272029061]
theorem CW_020_0_pre_eq :
    CW_0_re_000 * Fplus_dU_re_020 - CW_0_im_000 * Fplus_dU_im_020 = CW_020_0_pre := by
  simp only [CW_0_re_000_def, CW_0_im_000_def, Fplus_dU_re_020_def, Fplus_dU_im_020_def, CW_020_0_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_020_0_pim_eq :
    CW_0_re_000 * Fplus_dU_im_020 + CW_0_im_000 * Fplus_dU_re_020 = CW_020_0_pim := by
  simp only [CW_0_re_000_def, CW_0_im_000_def, Fplus_dU_re_020_def, Fplus_dU_im_020_def, CW_020_0_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_020_0_mul :
    CW_0_c_000 * Fplus_dU_c_020 = ofLadj CW_020_0_pre CW_020_0_pim := by
  rw [CW_0_c_000_def, Fplus_dU_c_020_def, ofLadj_mul, CW_020_0_pre_eq, CW_020_0_pim_eq]

def CW_020_1_pre : Polynomial ℚ := interpQ 17279915862 [-2345382972993, -26069856243780, -45034114701105, -72763267501920, -110488012596750, -124871913813852, -143756132749194, -164909031260562, -168916116716982, -181998231283362, -192134887499388, -193645931070900, -166065031255608, -136964116582257, -96152849215062, -46324535631369, -24560749303023, -5676530367681, 8096483032443]
def CW_020_1_pim : Polynomial ℚ := interpQ 17279915862 [15120968665866, 30241937331732, 34208362649586, 45208752808527, 33694434812850, 15464896715073, 10939671966483, -7879160089767, -22018430096649, -23915245424862, -32582345036238, -60543033692316, -88503722348394, -101137247277624, -114034452764778, -97054852437252, -67605507741411, -49643190993045, -19604552338731]
theorem CW_020_1_pre_eq :
    CW_1_re_000 * Fplus_dV_re_020 - CW_1_im_000 * Fplus_dV_im_020 = CW_020_1_pre := by
  simp only [CW_1_re_000_def, CW_1_im_000_def, Fplus_dV_re_020_def, Fplus_dV_im_020_def, CW_020_1_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_020_1_pim_eq :
    CW_1_re_000 * Fplus_dV_im_020 + CW_1_im_000 * Fplus_dV_re_020 = CW_020_1_pim := by
  simp only [CW_1_re_000_def, CW_1_im_000_def, Fplus_dV_re_020_def, Fplus_dV_im_020_def, CW_020_1_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_020_1_mul :
    CW_1_c_000 * Fplus_dV_c_020 = ofLadj CW_020_1_pre CW_020_1_pim := by
  rw [CW_1_c_000_def, Fplus_dV_c_020_def, ofLadj_mul, CW_020_1_pre_eq, CW_020_1_pim_eq]

def CW_020_2_pre : Polynomial ℚ := interpQ 17279915862 [-4993978767036, -60135567262960, -119014943142300, -197698981467586, -292955922522682, -347555541425147, -395459856863870, -422210744929901, -401848626637353, -397375073360923, -393882697033624, -387446113499196, -333747129770664, -278360130218623, -204149645169767, -113003914275103, -61034335988022, -13130020549299, 16250908132116]
def CW_020_2_pim : Polynomial ℚ := interpQ 17279915862 [40644961967524, 81289923935048, 96836348663870, 115728339099060, 86743733566892, 34352266836252, -10292823347740, -78483995376317, -116487060862670, -115889318305646, -113096999057009, -149171184314864, -185245369572719, -197999475052904, -216293722931070, -189044545145691, -140435637033820, -100676251149372, -36267637739564]
theorem CW_020_2_pre_eq :
    CW_2_re_000 * Fplus_dW_re_020 - CW_2_im_000 * Fplus_dW_im_020 = CW_020_2_pre := by
  simp only [CW_2_re_000_def, CW_2_im_000_def, Fplus_dW_re_020_def, Fplus_dW_im_020_def, CW_020_2_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_020_2_pim_eq :
    CW_2_re_000 * Fplus_dW_im_020 + CW_2_im_000 * Fplus_dW_re_020 = CW_020_2_pim := by
  simp only [CW_2_re_000_def, CW_2_im_000_def, Fplus_dW_re_020_def, Fplus_dW_im_020_def, CW_020_2_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_020_2_mul :
    CW_2_c_000 * Fplus_dW_c_020 = ofLadj CW_020_2_pre CW_020_2_pim := by
  rw [CW_2_c_000_def, Fplus_dW_c_020_def, ofLadj_mul, CW_020_2_pre_eq, CW_020_2_pim_eq]

def CW_020_3_pre : Polynomial ℚ := interpQ 17279915862 [-195345944640, 0, 1766147472848, 3696234032832, 5807769387376, 6765311774672, 6765311774672, 5807769387376, 3696234032832, 1766147472848]
def CW_020_3_pim : Polynomial ℚ := interpQ 17279915862 [-1976086457920, -3952172915840, -5408109815216, -5509979320528, -4961859431984, -2910805018128, -1041367897712, 1009686516144, 1557806404688, 1455936899376]
theorem CW_020_3_neg_re : -CW_3_re_020 = CW_020_3_pre := by
  simp only [CW_3_re_020_def, CW_020_3_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_020_3_neg_im : -CW_3_im_020 = CW_020_3_pim := by
  simp only [CW_3_im_020_def, CW_020_3_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_020_3_mul : -CW_3_c_020 = ofLadj CW_020_3_pre CW_020_3_pim := by
  rw [CW_3_c_020_def, ofLadj_neg, CW_020_3_neg_re, CW_020_3_neg_im]

@[expose] public def CW_coeff_020 : Ki := CW_0_c_000 * Fplus_dU_c_020 + CW_1_c_000 * Fplus_dV_c_020 + CW_2_c_000 * Fplus_dW_c_020 + (-CW_3_c_020)

theorem CW_coeff_020_sum :
    CW_coeff_020 = ofLadj (CW_020_0_pre + CW_020_1_pre + CW_020_2_pre + CW_020_3_pre) (CW_020_0_pim + CW_020_1_pim + CW_020_2_pim + CW_020_3_pim) := by
  simp only [CW_coeff_020, CW_020_0_mul, CW_020_1_mul, CW_020_2_mul, CW_020_3_mul]
  simpa [add_assoc] using ofLadj_add4 CW_020_0_pre CW_020_0_pim CW_020_1_pre CW_020_1_pim CW_020_2_pre CW_020_2_pim CW_020_3_pre CW_020_3_pim

def CW_020_qre : Polynomial ℚ := interpQ 17279915862 [-7843766296787, -47014772186803, -48632234524625, -60835153821468, -66134981810382, -20178904616478, -18423427759225, -11399114279588, 19195926306672]
def CW_020_qim : Polynomial ℚ := interpQ 17279915862 [24749174297585, 24749174297585, -2231391014795, -2678750310995, -43918108206824, -56772837108780, -34351293856851, -48074489621071, -25722918049234]
theorem CW_coeff_020_poly_re :
    CW_020_0_pre + CW_020_1_pre + CW_020_2_pre + CW_020_3_pre = (0 : Polynomial ℚ) + Phi11 * CW_020_qre := by
  rw [phi11_interpQ]
  simp only [CW_020_0_pre, CW_020_1_pre, CW_020_2_pre, CW_020_3_pre, CW_020_qre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_coeff_020_poly_im :
    CW_020_0_pim + CW_020_1_pim + CW_020_2_pim + CW_020_3_pim = (0 : Polynomial ℚ) + Phi11 * CW_020_qim := by
  rw [phi11_interpQ]
  simp only [CW_020_0_pim, CW_020_1_pim, CW_020_2_pim, CW_020_3_pim, CW_020_qim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
public theorem CW_coeff_020_eq :
    CW_coeff_020 = (0 : Ki) := by
  rw [CW_coeff_020_sum, CW_coeff_020_poly_re,
    CW_coeff_020_poly_im, ofLadj_add_Phi11]
  exact ofLadj_zero

end V14Formalization.D12SigmaPlusSegreCore
