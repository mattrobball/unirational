/-
Auto-generated Fplus chart Nullstellensatz identities.
-/
import V14Formalization.D12SigmaPlusSegreEval
import V14Formalization.D12SigmaPlusSegreMul
import V14Formalization.D12SigmaPlusSegrePartials
import V14Formalization.D12SigmaPlusSegreBezoutData

noncomputable section
open Matrix Polynomial
namespace V14Formalization.D12SigmaPlusSegreCore
open D12PolynomialData

def CW_101_0_pre : Polynomial ℚ := C ((-6788791749562 / 8639957931 : ℚ)) + C ((-50155016037040 / 8639957931 : ℚ)) * X + C ((-31430223539620 / 2879985977 : ℚ)) * X ^ 2 + C ((-99398859138855 / 5759971954 : ℚ)) * X ^ 3 + C ((-212512677704512 / 8639957931 : ℚ)) * X ^ 4 + C ((-242654341448191 / 8639957931 : ℚ)) * X ^ 5 + C ((-533601674706857 / 17279915862 : ℚ)) * X ^ 6 + C ((-553394737788451 / 17279915862 : ℚ)) * X ^ 7 + C ((-170739654927573 / 5759971954 : ℚ)) * X ^ 8 + C ((-504504522143393 / 17279915862 : ℚ)) * X ^ 9 + C ((-249229387964441 / 8639957931 : ℚ)) * X ^ 10 + C ((-80452873838187 / 2879985977 : ℚ)) * X ^ 11 + C ((-199074371927401 / 8639957931 : ℚ)) * X ^ 12 + C ((-28720289173243 / 1570901442 : ℚ)) * X ^ 13 + C ((-35670397894359 / 2879985977 : ℚ)) * X ^ 14 + C ((-94387677679819 / 17279915862 : ℚ)) * X ^ 15 + C ((-19214974853639 / 8639957931 : ℚ)) * X ^ 16 + C ((9863042103197 / 17279915862 : ℚ)) * X ^ 17 + C ((16990852349804 / 8639957931 : ℚ)) * X ^ 18
def CW_101_0_pim : Polynomial ℚ := C ((7547146395674 / 2879985977 : ℚ)) + C ((15094292791348 / 2879985977 : ℚ)) * X + C ((14350354144586 / 2879985977 : ℚ)) * X ^ 2 + C ((87307822200421 / 17279915862 : ℚ)) * X ^ 3 + C ((11396119908293 / 8639957931 : ℚ)) * X ^ 4 + C ((-36181609789613 / 8639957931 : ℚ)) * X ^ 5 + C ((-146347891844579 / 17279915862 : ℚ)) * X ^ 6 + C ((-242065116424249 / 17279915862 : ℚ)) * X ^ 7 + C ((-293110174049885 / 17279915862 : ℚ)) * X ^ 8 + C ((-292034276589163 / 17279915862 : ℚ)) * X ^ 9 + C ((-143439199851049 / 8639957931 : ℚ)) * X ^ 10 + C ((-54096977637774 / 2879985977 : ℚ)) * X ^ 11 + C ((-181142665975595 / 8639957931 : ℚ)) * X ^ 12 + C ((-32060529380323 / 1570901442 : ℚ)) * X ^ 13 + C ((-176397811527868 / 8639957931 : ℚ)) * X ^ 14 + C ((-291439935454933 / 17279915862 : ℚ)) * X ^ 15 + C ((-9227880744491 / 785450721 : ℚ)) * X ^ 16 + C ((-136873487102593 / 17279915862 : ℚ)) * X ^ 17 + C ((-23942581421302 / 8639957931 : ℚ)) * X ^ 18
theorem CW_101_0_pre_eq :
    CW_0_re_000 * Fplus_dU_re_101 - CW_0_im_000 * Fplus_dU_im_101 = CW_101_0_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_0_re_000, CW_0_im_000, Fplus_dU_re_101, Fplus_dU_im_101, CW_101_0_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CW_101_0_pim_eq :
    CW_0_re_000 * Fplus_dU_im_101 + CW_0_im_000 * Fplus_dU_re_101 = CW_101_0_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_0_re_000, CW_0_im_000, Fplus_dU_re_101, Fplus_dU_im_101, CW_101_0_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CW_101_0_mul :
    CW_0_c_000 * Fplus_dU_c_101 = ofLadj CW_101_0_pre CW_101_0_pim := by
  rw [CW_0_c_000, Fplus_dU_c_101, ofLadj_mul, CW_101_0_pre_eq, CW_101_0_pim_eq]

def CW_101_1_pre : Polynomial ℚ := C ((2518277925671 / 8639957931 : ℚ)) + C ((43449760406300 / 8639957931 : ℚ)) * X + C ((87823301696677 / 8639957931 : ℚ)) * X ^ 2 + C ((48118204385989 / 2879985977 : ℚ)) * X ^ 3 + C ((71836551276635 / 2879985977 : ℚ)) * X ^ 4 + C ((510838055538587 / 17279915862 : ℚ)) * X ^ 5 + C ((192407338900477 / 5759971954 : ℚ)) * X ^ 6 + C ((204150533418681 / 5759971954 : ℚ)) * X ^ 7 + C ((291840148880161 / 8639957931 : ℚ)) * X ^ 8 + C ((572572963792399 / 17279915862 : ℚ)) * X ^ 9 + C ((94027370538279 / 2879985977 : ℚ)) * X ^ 10 + C ((277963112077331 / 8639957931 : ℚ)) * X ^ 11 + C ((21693850109867 / 785450721 : ℚ)) * X ^ 12 + C ((396926360399045 / 17279915862 : ℚ)) * X ^ 13 + C ((147485535722194 / 8639957931 : ℚ)) * X ^ 14 + C ((162767937938789 / 17279915862 : ℚ)) * X ^ 15 + C ((14829178696382 / 2879985977 : ℚ)) * X ^ 16 + C ((11295555507724 / 8639957931 : ℚ)) * X ^ 17 + C ((-9332177328722 / 8639957931 : ℚ)) * X ^ 18
def CW_101_1_pim : Polynomial ℚ := C ((-895351226780 / 261816907 : ℚ)) + C ((-1790702453560 / 261816907 : ℚ)) * X + C ((-69239055964627 / 8639957931 : ℚ)) * X ^ 2 + C ((-27538408046573 / 2879985977 : ℚ)) * X ^ 3 + C ((-61843790557679 / 8639957931 : ℚ)) * X ^ 4 + C ((-4041570478123 / 1570901442 : ℚ)) * X ^ 5 + C ((18884620638617 / 17279915862 : ℚ)) * X ^ 6 + C ((113067263564357 / 17279915862 : ℚ)) * X ^ 7 + C ((27788185532852 / 2879985977 : ℚ)) * X ^ 8 + C ((165097718539333 / 17279915862 : ℚ)) * X ^ 9 + C ((78879259898536 / 8639957931 : ℚ)) * X ^ 10 + C ((103077544174175 / 8639957931 : ℚ)) * X ^ 11 + C ((3856843286358 / 261816907 : ℚ)) * X ^ 12 + C ((89168069383887 / 5759971954 : ℚ)) * X ^ 13 + C ((146312574922033 / 8639957931 : ℚ)) * X ^ 14 + C ((255846471008375 / 17279915862 : ℚ)) * X ^ 15 + C ((92978016394930 / 8639957931 : ℚ)) * X ^ 16 + C ((22290072765436 / 2879985977 : ℚ)) * X ^ 17 + C ((24448830652183 / 8639957931 : ℚ)) * X ^ 18
theorem CW_101_1_pre_eq :
    CW_1_re_000 * Fplus_dV_re_101 - CW_1_im_000 * Fplus_dV_im_101 = CW_101_1_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_1_re_000, CW_1_im_000, Fplus_dV_re_101, Fplus_dV_im_101, CW_101_1_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CW_101_1_pim_eq :
    CW_1_re_000 * Fplus_dV_im_101 + CW_1_im_000 * Fplus_dV_re_101 = CW_101_1_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_1_re_000, CW_1_im_000, Fplus_dV_re_101, Fplus_dV_im_101, CW_101_1_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CW_101_1_mul :
    CW_1_c_000 * Fplus_dV_c_101 = ofLadj CW_101_1_pre CW_101_1_pim := by
  rw [CW_1_c_000, Fplus_dV_c_101, ofLadj_mul, CW_101_1_pre_eq, CW_101_1_pim_eq]

def CW_101_2_pre : Polynomial ℚ := C ((2201697823262 / 8639957931 : ℚ)) + C ((30067783631480 / 8639957931 : ℚ)) * X + C ((59890172205466 / 8639957931 : ℚ)) * X ^ 2 + C ((98629055896079 / 8639957931 : ℚ)) * X ^ 3 + C ((148817056989571 / 8639957931 : ℚ)) * X ^ 4 + C ((59732644397518 / 2879985977 : ℚ)) * X ^ 5 + C ((12647731912023 / 523633814 : ℚ)) * X ^ 6 + C ((227212106679218 / 8639957931 : ℚ)) * X ^ 7 + C ((446192793532069 / 17279915862 : ℚ)) * X ^ 8 + C ((226159001228194 / 8639957931 : ℚ)) * X ^ 9 + C ((228412473135548 / 8639957931 : ℚ)) * X ^ 10 + C ((75679468016150 / 2879985977 : ℚ)) * X ^ 11 + C ((66114896501356 / 2879985977 : ℚ)) * X ^ 12 + C ((55422943007576 / 2879985977 : ℚ)) * X ^ 13 + C ((82978227246637 / 5759971954 : ℚ)) * X ^ 14 + C ((71508052585639 / 8639957931 : ℚ)) * X ^ 15 + C ((79119368213917 / 17279915862 : ℚ)) * X ^ 16 + C ((915458250103 / 785450721 : ℚ)) * X ^ 17 + C ((-2295665701336 / 2879985977 : ℚ)) * X ^ 18
def CW_101_2_pim : Polynomial ℚ := C ((-21396330399172 / 8639957931 : ℚ)) + C ((-42792660798344 / 8639957931 : ℚ)) * X + C ((-52921733340394 / 8639957931 : ℚ)) * X ^ 2 + C ((-65853279736810 / 8639957931 : ℚ)) * X ^ 3 + C ((-18698403562266 / 2879985977 : ℚ)) * X ^ 4 + C ((-11474542417224 / 2879985977 : ℚ)) * X ^ 5 + C ((-33439601112815 / 17279915862 : ℚ)) * X ^ 6 + C ((5313195072019 / 2879985977 : ℚ)) * X ^ 7 + C ((67772882490581 / 17279915862 : ℚ)) * X ^ 8 + C ((34327171967014 / 8639957931 : ℚ)) * X ^ 9 + C ((36332480072815 / 8639957931 : ℚ)) * X ^ 10 + C ((5511413614282 / 785450721 : ℚ)) * X ^ 11 + C ((28306206480463 / 2879985977 : ℚ)) * X ^ 12 + C ((97053000089240 / 8639957931 : ℚ)) * X ^ 13 + C ((220850554414759 / 17279915862 : ℚ)) * X ^ 14 + C ((99362616235033 / 8639957931 : ℚ)) * X ^ 15 + C ((150324918896929 / 17279915862 : ℚ)) * X ^ 16 + C ((54439407075475 / 8639957931 : ℚ)) * X ^ 17 + C ((19251447951568 / 8639957931 : ℚ)) * X ^ 18
theorem CW_101_2_pre_eq :
    CW_2_re_000 * Fplus_dW_re_101 - CW_2_im_000 * Fplus_dW_im_101 = CW_101_2_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_2_re_000, CW_2_im_000, Fplus_dW_re_101, Fplus_dW_im_101, CW_101_2_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CW_101_2_pim_eq :
    CW_2_re_000 * Fplus_dW_im_101 + CW_2_im_000 * Fplus_dW_re_101 = CW_101_2_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_2_re_000, CW_2_im_000, Fplus_dW_re_101, Fplus_dW_im_101, CW_101_2_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CW_101_2_mul :
    CW_2_c_000 * Fplus_dW_c_101 = ofLadj CW_101_2_pre CW_101_2_pim := by
  rw [CW_2_c_000, Fplus_dW_c_101, ofLadj_mul, CW_101_2_pre_eq, CW_101_2_pim_eq]

def CW_101_3_pre : Polynomial ℚ := C ((-28080165877 / 785450721 : ℚ)) + C ((97452248477 / 785450721 : ℚ)) * X ^ 2 + C ((73882834276 / 261816907 : ℚ)) * X ^ 3 + C ((10338790512 / 23801537 : ℚ)) * X ^ 4 + C ((12314963994 / 23801537 : ℚ)) * X ^ 5 + C ((12314963994 / 23801537 : ℚ)) * X ^ 6 + C ((10338790512 / 23801537 : ℚ)) * X ^ 7 + C ((73882834276 / 261816907 : ℚ)) * X ^ 8 + C ((97452248477 / 785450721 : ℚ)) * X ^ 9
def CW_101_3_pim : Polynomial ℚ := C ((-1338139201763 / 8639957931 : ℚ)) + C ((-2676278403526 / 8639957931 : ℚ)) * X + C ((-3589925581729 / 8639957931 : ℚ)) * X ^ 2 + C ((-3752907704924 / 8639957931 : ℚ)) * X ^ 3 + C ((-3250462555268 / 8639957931 : ℚ)) * X ^ 4 + C ((-2027372862730 / 8639957931 : ℚ)) * X ^ 5 + C ((-216301846932 / 2879985977 : ℚ)) * X ^ 6 + C ((574184151742 / 8639957931 : ℚ)) * X ^ 7 + C ((1076629301398 / 8639957931 : ℚ)) * X ^ 8 + C ((304549059401 / 2879985977 : ℚ)) * X ^ 9
theorem CW_101_3_neg_re : -CW_3_re_101 = CW_101_3_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_3_re_101, CW_101_3_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CW_101_3_neg_im : -CW_3_im_101 = CW_101_3_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CW_3_im_101, CW_101_3_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CW_101_3_mul : -CW_3_c_101 = ofLadj CW_101_3_pre CW_101_3_pim := by
  rw [CW_3_c_101, ofLadj_neg, CW_101_3_neg_re, CW_101_3_neg_im]

def CW_coeff_101 : Ki := CW_0_c_000 * Fplus_dU_c_101 + CW_1_c_000 * Fplus_dV_c_101 + CW_2_c_000 * Fplus_dW_c_101 + (-CW_3_c_101)

theorem CW_coeff_101_sum :
    CW_coeff_101 = ofLadj (CW_101_0_pre + CW_101_1_pre + CW_101_2_pre + CW_101_3_pre) (CW_101_0_pim + CW_101_1_pim + CW_101_2_pim + CW_101_3_pim) := by
  simp only [CW_coeff_101, CW_101_0_mul, CW_101_1_mul, CW_101_2_mul, CW_101_3_mul]
  simpa [add_assoc] using ofLadj_add4 CW_101_0_pre CW_101_0_pim CW_101_1_pre CW_101_1_pim CW_101_2_pre CW_101_2_pim CW_101_3_pre CW_101_3_pim

def CW_101_qre : Polynomial ℚ := C ((-2377697825276 / 8639957931 : ℚ)) + C ((25740225826016 / 8639957931 : ℚ)) * X + C ((943401515630 / 261816907 : ℚ)) * X ^ 2 + C ((83657471720683 / 17279915862 : ℚ)) * X ^ 3 + C ((118487000387897 / 17279915862 : ℚ)) * X ^ 4 + C ((27243958248439 / 5759971954 : ℚ)) * X ^ 5 + C ((38535128032010 / 8639957931 : ℚ)) * X ^ 6 + C ((51050878786763 / 17279915862 : ℚ)) * X ^ 7 + C ((257225972358 / 2879985977 : ℚ)) * X ^ 8
def CW_101_qim : Polynomial ℚ := C ((-9879873632551 / 2879985977 : ℚ)) + C ((-9879873632551 / 2879985977 : ℚ)) * X + C ((-7806803552562 / 2879985977 : ℚ)) * X ^ 2 + C ((-51735696056501 / 17279915862 : ℚ)) * X ^ 3 + C ((-2451686820419 / 17279915862 : ℚ)) * X ^ 4 + C ((29864192715521 / 17279915862 : ℚ)) * X ^ 5 + C ((4586968611169 / 2879985977 : ℚ)) * X ^ 6 + C ((66230369276075 / 17279915862 : ℚ)) * X ^ 7 + C ((19757697182449 / 8639957931 : ℚ)) * X ^ 8
theorem CW_coeff_101_poly_re :
    CW_101_0_pre + CW_101_1_pre + CW_101_2_pre + CW_101_3_pre = (0 : Polynomial ℚ) + Phi11 * CW_101_qre := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [CW_101_0_pre, CW_101_1_pre, CW_101_2_pre, CW_101_3_pre, CW_101_qre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try ring
theorem CW_coeff_101_poly_im :
    CW_101_0_pim + CW_101_1_pim + CW_101_2_pim + CW_101_3_pim = (0 : Polynomial ℚ) + Phi11 * CW_101_qim := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [CW_101_0_pim, CW_101_1_pim, CW_101_2_pim, CW_101_3_pim, CW_101_qim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try ring
theorem CW_coeff_101_eq :
    CW_coeff_101 = (0 : Ki) := by
  rw [CW_coeff_101_sum, CW_coeff_101_poly_re,
    CW_coeff_101_poly_im, ofLadj_add_Phi11]
  exact ofLadj_zero

end V14Formalization.D12SigmaPlusSegreCore
