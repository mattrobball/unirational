/-
Auto-generated Fplus chart Nullstellensatz identities.
-/
module

public import V14Formalization.D12SigmaPlusSegreEval
public import V14Formalization.D12SigmaPlusSegreMul
public import V14Formalization.D12SigmaPlusSegrePartials
public import V14Formalization.D12SigmaPlusSegreBezoutData

noncomputable section
open Matrix Polynomial
namespace V14Formalization.D12SigmaPlusSegreCore
open D12PolynomialData

def CW_040_0_pre : Polynomial ℚ := C ((842550631660 / 2879985977 : ℚ)) + C ((-3689654057860 / 8639957931 : ℚ)) * X + C ((-2341398642386 / 8639957931 : ℚ)) * X ^ 2 + C ((-2570681917994 / 2879985977 : ℚ)) * X ^ 3 + C ((-15293188629808 / 8639957931 : ℚ)) * X ^ 4 + C ((-16173670661330 / 8639957931 : ℚ)) * X ^ 5 + C ((-24434404919488 / 8639957931 : ℚ)) * X ^ 6 + C ((-8351858888442 / 2879985977 : ℚ)) * X ^ 7 + C ((-797577342930 / 261816907 : ℚ)) * X ^ 8 + C ((-8611595687194 / 2879985977 : ℚ)) * X ^ 9 + C ((-28576874437366 / 8639957931 : ℚ)) * X ^ 10 + C ((-29344230543152 / 8639957931 : ℚ)) * X ^ 11 + C ((-8295740126502 / 2879985977 : ℚ)) * X ^ 12 + C ((-23493388419196 / 8639957931 : ℚ)) * X ^ 13 + C ((-6202668854236 / 2879985977 : ℚ)) * X ^ 14 + C ((-809867242012 / 785450721 : ℚ)) * X ^ 15 + C ((-8018642060782 / 8639957931 : ℚ)) * X ^ 16 + C ((242092197376 / 8639957931 : ℚ)) * X ^ 17 + C ((284616124462 / 2879985977 : ℚ)) * X ^ 18
def CW_040_0_pim : Polynomial ℚ := C ((4150931069606 / 8639957931 : ℚ)) + C ((8301862139212 / 8639957931 : ℚ)) * X + C ((7716345647644 / 8639957931 : ℚ)) * X ^ 2 + C ((16587512929186 / 8639957931 : ℚ)) * X ^ 3 + C ((12553403218346 / 8639957931 : ℚ)) * X ^ 4 + C ((15365147353466 / 8639957931 : ℚ)) * X ^ 5 + C ((13382074322690 / 8639957931 : ℚ)) * X ^ 6 + C ((897641421092 / 785450721 : ℚ)) * X ^ 7 + C ((2793987767046 / 2879985977 : ℚ)) * X ^ 8 + C ((9601244799698 / 8639957931 : ℚ)) * X ^ 9 + C ((2679626239498 / 2879985977 : ℚ)) * X ^ 10 + C ((1035480842624 / 2879985977 : ℚ)) * X ^ 11 + C ((-608664554250 / 2879985977 : ℚ)) * X ^ 12 + C ((-2802843252386 / 8639957931 : ℚ)) * X ^ 13 + C ((-3484909678456 / 2879985977 : ℚ)) * X ^ 14 + C ((-2578928375280 / 2879985977 : ℚ)) * X ^ 15 + C ((-7617143463040 / 8639957931 : ℚ)) * X ^ 16 + C ((-6615331018160 / 8639957931 : ℚ)) * X ^ 17 + C ((-175926529562 / 8639957931 : ℚ)) * X ^ 18
theorem CW_040_0_pre_eq :
    CW_0_re_020 * Fplus_dU_re_020 - CW_0_im_020 * Fplus_dU_im_020 = CW_040_0_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_0_re_020, CW_0_im_020, Fplus_dU_re_020, Fplus_dU_im_020, CW_040_0_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CW_040_0_pim_eq :
    CW_0_re_020 * Fplus_dU_im_020 + CW_0_im_020 * Fplus_dU_re_020 = CW_040_0_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_0_re_020, CW_0_im_020, Fplus_dU_re_020, Fplus_dU_im_020, CW_040_0_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CW_040_0_mul :
    CW_0_c_020 * Fplus_dU_c_020 = ofLadj CW_040_0_pre CW_040_0_pim := by
  rw [CW_0_c_020, Fplus_dU_c_020, ofLadj_mul, CW_040_0_pre_eq, CW_040_0_pim_eq]

def CW_040_1_pre : Polynomial ℚ := C ((-160537801184 / 2879985977 : ℚ)) + C ((477290527184 / 2879985977 : ℚ)) * X + C ((461125168938 / 2879985977 : ℚ)) * X ^ 2 + C ((1161051872594 / 2879985977 : ℚ)) * X ^ 3 + C ((2006593156254 / 2879985977 : ℚ)) * X ^ 4 + C ((1573071904722 / 2879985977 : ℚ)) * X ^ 5 + C ((2651735819980 / 2879985977 : ℚ)) * X ^ 6 + C ((2514856900418 / 2879985977 : ℚ)) * X ^ 7 + C ((2562327783662 / 2879985977 : ℚ)) * X ^ 8 + C ((2926025228446 / 2879985977 : ℚ)) * X ^ 9 + C ((3054074992798 / 2879985977 : ℚ)) * X ^ 10 + C ((3205400501216 / 2879985977 : ℚ)) * X ^ 11 + C ((2576784465614 / 2879985977 : ℚ)) * X ^ 12 + C ((2464900059508 / 2879985977 : ℚ)) * X ^ 13 + C ((127388719188 / 261816907 : ℚ)) * X ^ 14 + C ((301108410682 / 2879985977 : ℚ)) * X ^ 15 + C ((704624924208 / 2879985977 : ℚ)) * X ^ 16 + C ((-374038991050 / 2879985977 : ℚ)) * X ^ 17 + C ((-207155333482 / 2879985977 : ℚ)) * X ^ 18
def CW_040_1_pim : Polynomial ℚ := C ((-378575480082 / 2879985977 : ℚ)) + C ((-757150960164 / 2879985977 : ℚ)) * X + C ((-604016434056 / 2879985977 : ℚ)) * X ^ 2 + C ((-1430958823808 / 2879985977 : ℚ)) * X ^ 3 + C ((-522446688440 / 2879985977 : ℚ)) * X ^ 4 + C ((-702790836252 / 2879985977 : ℚ)) * X ^ 5 + C ((-712040397434 / 2879985977 : ℚ)) * X ^ 6 + C ((22757672382 / 2879985977 : ℚ)) * X ^ 7 + C ((-233413663040 / 2879985977 : ℚ)) * X ^ 8 + C ((-138704764388 / 2879985977 : ℚ)) * X ^ 9 + C ((125586650628 / 2879985977 : ℚ)) * X ^ 10 + C ((671596867548 / 2879985977 : ℚ)) * X ^ 11 + C ((1217607084468 / 2879985977 : ℚ)) * X ^ 12 + C ((1328763973376 / 2879985977 : ℚ)) * X ^ 13 + C ((2250415261780 / 2879985977 : ℚ)) * X ^ 14 + C ((1108979372276 / 2879985977 : ℚ)) * X ^ 15 + C ((1061991905632 / 2879985977 : ℚ)) * X ^ 16 + C ((938882102986 / 2879985977 : ℚ)) * X ^ 17 + C ((-23247581286 / 2879985977 : ℚ)) * X ^ 18
theorem CW_040_1_pre_eq :
    CW_1_re_020 * Fplus_dV_re_020 - CW_1_im_020 * Fplus_dV_im_020 = CW_040_1_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_1_re_020, CW_1_im_020, Fplus_dV_re_020, Fplus_dV_im_020, CW_040_1_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CW_040_1_pim_eq :
    CW_1_re_020 * Fplus_dV_im_020 + CW_1_im_020 * Fplus_dV_re_020 = CW_040_1_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_1_re_020, CW_1_im_020, Fplus_dV_re_020, Fplus_dV_im_020, CW_040_1_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CW_040_1_mul :
    CW_1_c_020 * Fplus_dV_c_020 = ofLadj CW_040_1_pre CW_040_1_pim := by
  rw [CW_1_c_020, Fplus_dV_c_020, ofLadj_mul, CW_040_1_pre_eq, CW_040_1_pim_eq]

def CW_040_2_pre : Polynomial ℚ := C ((-9880423390492 / 8639957931 : ℚ)) + C ((-203706884864 / 8639957931 : ℚ)) * X + C ((-1430431405366 / 785450721 : ℚ)) * X ^ 2 + C ((-7480200886030 / 2879985977 : ℚ)) * X ^ 3 + C ((-20243874344098 / 8639957931 : ℚ)) * X ^ 4 + C ((-37984356322282 / 8639957931 : ℚ)) * X ^ 5 + C ((-9906803555808 / 2879985977 : ℚ)) * X ^ 6 + C ((-13833716771376 / 2879985977 : ℚ)) * X ^ 7 + C ((-35908017795896 / 8639957931 : ℚ)) * X ^ 8 + C ((-37484375385356 / 8639957931 : ℚ)) * X ^ 9 + C ((-35126437302628 / 8639957931 : ℚ)) * X ^ 10 + C ((-26978672823032 / 8639957931 : ℚ)) * X ^ 11 + C ((-34922730417764 / 8639957931 : ℚ)) * X ^ 12 + C ((-7249876642110 / 2879985977 : ℚ)) * X ^ 13 + C ((-13467415137806 / 8639957931 : ℚ)) * X ^ 14 + C ((-17018588826370 / 8639957931 : ℚ)) * X ^ 15 + C ((802491796004 / 8639957931 : ℚ)) * X ^ 16 + C ((-7461453858854 / 8639957931 : ℚ)) * X ^ 17 + C ((4238687143660 / 8639957931 : ℚ)) * X ^ 18
def CW_040_2_pim : Polynomial ℚ := C ((-1307920208300 / 2879985977 : ℚ)) + C ((-2615840416600 / 2879985977 : ℚ)) * X + C ((5441130721964 / 8639957931 : ℚ)) * X ^ 2 + C ((-5099767331816 / 2879985977 : ℚ)) * X ^ 3 + C ((-5217297181940 / 8639957931 : ℚ)) * X ^ 4 + C ((-6252897946340 / 2879985977 : ℚ)) * X ^ 5 + C ((-24201892987714 / 8639957931 : ℚ)) * X ^ 6 + C ((-29081551683370 / 8639957931 : ℚ)) * X ^ 7 + C ((-12899448423582 / 2879985977 : ℚ)) * X ^ 8 + C ((-40201753465262 / 8639957931 : ℚ)) * X ^ 9 + C ((-13144087209702 / 2879985977 : ℚ)) * X ^ 10 + C ((-35229300093704 / 8639957931 : ℚ)) * X ^ 11 + C ((-31026338558302 / 8639957931 : ℚ)) * X ^ 12 + C ((-43545498693910 / 8639957931 : ℚ)) * X ^ 13 + C ((-2209861288274 / 785450721 : ℚ)) * X ^ 14 + C ((-10791847306934 / 2879985977 : ℚ)) * X ^ 15 + C ((-21083536218274 / 8639957931 : ℚ)) * X ^ 16 + C ((-14261998392200 / 8639957931 : ℚ)) * X ^ 17 + C ((-11631730651096 / 8639957931 : ℚ)) * X ^ 18
theorem CW_040_2_pre_eq :
    CW_2_re_020 * Fplus_dW_re_020 - CW_2_im_020 * Fplus_dW_im_020 = CW_040_2_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_2_re_020, CW_2_im_020, Fplus_dW_re_020, Fplus_dW_im_020, CW_040_2_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CW_040_2_pim_eq :
    CW_2_re_020 * Fplus_dW_im_020 + CW_2_im_020 * Fplus_dW_re_020 = CW_040_2_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_2_re_020, CW_2_im_020, Fplus_dW_re_020, Fplus_dW_im_020, CW_040_2_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem CW_040_2_mul :
    CW_2_c_020 * Fplus_dW_c_020 = ofLadj CW_040_2_pre CW_040_2_pim := by
  rw [CW_2_c_020, Fplus_dW_c_020, ofLadj_mul, CW_040_2_pre_eq, CW_040_2_pim_eq]

@[expose] public def CW_coeff_040 : Ki := CW_0_c_020 * Fplus_dU_c_020 + CW_1_c_020 * Fplus_dV_c_020 + CW_2_c_020 * Fplus_dW_c_020

theorem CW_coeff_040_sum :
    CW_coeff_040 = ofLadj (CW_040_0_pre + CW_040_1_pre + CW_040_2_pre) (CW_040_0_pim + CW_040_1_pim + CW_040_2_pim) := by
  simp only [CW_coeff_040, CW_040_0_mul, CW_040_1_mul, CW_040_2_mul]
  simpa [add_assoc] using ofLadj_add3 CW_040_0_pre CW_040_0_pim CW_040_1_pre CW_040_1_pim CW_040_2_pre CW_040_2_pim

def CW_040_qre : Polynomial ℚ := C ((-7834384899064 / 8639957931 : ℚ)) + C ((5372895537892 / 8639957931 : ℚ)) * X + C ((-14231279233426 / 8639957931 : ℚ)) * X ^ 2 + C ((-9976724199692 / 8639957931 : ℚ)) * X ^ 3 + C ((-2847790710854 / 8639957931 : ℚ)) * X ^ 4 + C ((-19921527764302 / 8639957931 : ℚ)) * X ^ 5 + C ((3239203142474 / 8639957931 : ℚ)) * X ^ 6 + C ((-12812548151228 / 8639957931 : ℚ)) * X ^ 7 + C ((4471069516600 / 8639957931 : ℚ)) * X ^ 8
def CW_040_qim : Polynomial ℚ := C ((-908555995540 / 8639957931 : ℚ)) + C ((-908555995540 / 8639957931 : ℚ)) * X + C ((13162539058520 / 8639957931 : ℚ)) * X ^ 2 + C ((-14350092605126 / 8639957931 : ℚ)) * X ^ 3 + C ((8773431508772 / 8639957931 : ℚ)) * X ^ 4 + C ((-11270684965396 / 8639957931 : ℚ)) * X ^ 5 + C ((-7454020863016 / 8639957931 : ℚ)) * X ^ 6 + C ((-6183283176886 / 8639957931 : ℚ)) * X ^ 7 + C ((-3959133308172 / 2879985977 : ℚ)) * X ^ 8
theorem CW_coeff_040_poly_re :
    CW_040_0_pre + CW_040_1_pre + CW_040_2_pre = (0 : Polynomial ℚ) + Phi11 * CW_040_qre := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [CW_040_0_pre, CW_040_1_pre, CW_040_2_pre, CW_040_qre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try grind
theorem CW_coeff_040_poly_im :
    CW_040_0_pim + CW_040_1_pim + CW_040_2_pim = (0 : Polynomial ℚ) + Phi11 * CW_040_qim := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [CW_040_0_pim, CW_040_1_pim, CW_040_2_pim, CW_040_qim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try grind
public theorem CW_coeff_040_eq :
    CW_coeff_040 = (0 : Ki) := by
  rw [CW_coeff_040_sum, CW_coeff_040_poly_re,
    CW_coeff_040_poly_im, ofLadj_add_Phi11]
  exact ofLadj_zero

end V14Formalization.D12SigmaPlusSegreCore
