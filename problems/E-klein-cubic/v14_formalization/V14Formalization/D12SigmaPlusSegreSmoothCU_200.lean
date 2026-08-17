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

def CU_200_0_pre : Polynomial ℚ := C ((271949541693 / 157196666 : ℚ)) + C ((-125580089357 / 78598333 : ℚ)) * X ^ 2 + C ((-793841773713 / 157196666 : ℚ)) * X ^ 3 + C ((-2289200118253 / 157196666 : ℚ)) * X ^ 4 + C ((-1904062397272 / 78598333 : ℚ)) * X ^ 5 + C ((-2733208772931 / 78598333 : ℚ)) * X ^ 6 + C ((-3374666601052 / 78598333 : ℚ)) * X ^ 7 + C ((-7211591370495 / 157196666 : ℚ)) * X ^ 8 + C ((-7423377650875 / 157196666 : ℚ)) * X ^ 9 + C ((-7582850766015 / 157196666 : ℚ)) * X ^ 10 + C ((-7909375940075 / 157196666 : ℚ)) * X ^ 11 + C ((-7582850766015 / 157196666 : ℚ)) * X ^ 12 + C ((-7172217472161 / 157196666 : ℚ)) * X ^ 13 + C ((-3208874798391 / 78598333 : ℚ)) * X ^ 14 + C ((-2363807457172 / 78598333 : ℚ)) * X ^ 15 + C ((-1549497710870 / 78598333 : ℚ)) * X ^ 16 + C ((-720351335211 / 78598333 : ℚ)) * X ^ 17 + C ((-267481830493 / 157196666 : ℚ)) * X ^ 18
def CU_200_0_pim : Polynomial ℚ := C ((976311432633 / 157196666 : ℚ)) + C ((976311432633 / 78598333 : ℚ)) * X + C ((1613097924876 / 78598333 : ℚ)) * X ^ 2 + C ((2453359072106 / 78598333 : ℚ)) * X ^ 3 + C ((268008283846 / 7145303 : ℚ)) * X ^ 4 + C ((3224917010534 / 78598333 : ℚ)) * X ^ 5 + C ((3290164345695 / 78598333 : ℚ)) * X ^ 6 + C ((2783824398419 / 78598333 : ℚ)) * X ^ 7 + C ((4929602900151 / 157196666 : ℚ)) * X ^ 8 + C ((2449608073367 / 78598333 : ℚ)) * X ^ 9 + C ((216190850945 / 7145303 : ℚ)) * X ^ 10 + C ((325437144211 / 14290606 : ℚ)) * X ^ 11 + C ((9931481206 / 649573 : ℚ)) * X ^ 12 + C ((493414020711 / 78598333 : ℚ)) * X ^ 13 + C ((-724081006455 / 157196666 : ℚ)) * X ^ 14 + C ((-1623392968883 / 157196666 : ℚ)) * X ^ 15 + C ((-1996410458007 / 157196666 : ℚ)) * X ^ 16 + C ((-1921512216543 / 157196666 : ℚ)) * X ^ 17 + C ((-728198034659 / 157196666 : ℚ)) * X ^ 18
theorem CU_200_0_pre_eq :
    CU_0_re_000 * Fplus_dU_re_200 - CU_0_im_000 * Fplus_dU_im_200 = CU_200_0_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_0_re_000, CU_0_im_000, Fplus_dU_re_200, Fplus_dU_im_200, CU_200_0_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CU_200_0_pim_eq :
    CU_0_re_000 * Fplus_dU_im_200 + CU_0_im_000 * Fplus_dU_re_200 = CU_200_0_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_0_re_000, CU_0_im_000, Fplus_dU_re_200, Fplus_dU_im_200, CU_200_0_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CU_200_0_mul :
    CU_0_c_000 * Fplus_dU_c_200 = ofLadj CU_200_0_pre CU_200_0_pim := by
  rw [CU_0_c_000, Fplus_dU_c_200, ofLadj_mul, CU_200_0_pre_eq, CU_200_0_pim_eq]

def CU_200_1_pre : Polynomial ℚ := C ((-28347772287 / 157196666 : ℚ)) + C ((6590440943144 / 235794999 : ℚ)) * X + C ((8790873136307 / 157196666 : ℚ)) * X ^ 2 + C ((42957836281027 / 471589998 : ℚ)) * X ^ 3 + C ((12103536015768 / 78598333 : ℚ)) * X ^ 4 + C ((46494052739476 / 235794999 : ℚ)) * X ^ 5 + C ((18685106328263 / 78598333 : ℚ)) * X ^ 6 + C ((120456215834099 / 471589998 : ℚ)) * X ^ 7 + C ((112133172025733 / 471589998 : ℚ)) * X ^ 8 + C ((53082649487171 / 235794999 : ℚ)) * X ^ 9 + C ((101619738903751 / 471589998 : ℚ)) * X ^ 10 + C ((49999489420829 / 235794999 : ℚ)) * X ^ 11 + C ((29479619005821 / 157196666 : ℚ)) * X ^ 12 + C ((79792679565421 / 471589998 : ℚ)) * X ^ 13 + C ((34587667872353 / 235794999 : ℚ)) * X ^ 14 + C ((44986920655877 / 471589998 : ℚ)) * X ^ 15 + C ((27880107934709 / 471589998 : ℚ)) * X ^ 16 + C ((8757575444083 / 471589998 : ℚ)) * X ^ 17 + C ((-474679847269 / 78598333 : ℚ)) * X ^ 18
def CU_200_1_pim : Polynomial ℚ := C ((-6249530652170 / 235794999 : ℚ)) + C ((-12499061304340 / 235794999 : ℚ)) * X + C ((-10771854543299 / 157196666 : ℚ)) * X ^ 2 + C ((-44315651955901 / 471589998 : ℚ)) * X ^ 3 + C ((-44595810600703 / 471589998 : ℚ)) * X ^ 4 + C ((-16367581110733 / 235794999 : ℚ)) * X ^ 5 + C ((-9804394350815 / 235794999 : ℚ)) * X ^ 6 + C ((5537548023605 / 471589998 : ℚ)) * X ^ 7 + C ((3202773032922 / 78598333 : ℚ)) * X ^ 8 + C ((9176942635775 / 235794999 : ℚ)) * X ^ 9 + C ((7206751289755 / 235794999 : ℚ)) * X ^ 10 + C ((10565436667774 / 235794999 : ℚ)) * X ^ 11 + C ((13924122045793 / 235794999 : ℚ)) * X ^ 12 + C ((2838663856433 / 42871818 : ℚ)) * X ^ 13 + C ((14120879273595 / 157196666 : ℚ)) * X ^ 14 + C ((45151745375257 / 471589998 : ℚ)) * X ^ 15 + C ((38350047957685 / 471589998 : ℚ)) * X ^ 16 + C ((31257527027827 / 471589998 : ℚ)) * X ^ 17 + C ((3723380421419 / 157196666 : ℚ)) * X ^ 18
theorem CU_200_1_pre_eq :
    CU_1_re_000 * Fplus_dV_re_200 - CU_1_im_000 * Fplus_dV_im_200 = CU_200_1_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_1_re_000, CU_1_im_000, Fplus_dV_re_200, Fplus_dV_im_200, CU_200_1_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CU_200_1_pim_eq :
    CU_1_re_000 * Fplus_dV_im_200 + CU_1_im_000 * Fplus_dV_re_200 = CU_200_1_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_1_re_000, CU_1_im_000, Fplus_dV_re_200, Fplus_dV_im_200, CU_200_1_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CU_200_1_mul :
    CU_1_c_000 * Fplus_dV_c_200 = ofLadj CU_200_1_pre CU_200_1_pim := by
  rw [CU_1_c_000, Fplus_dV_c_200, ofLadj_mul, CU_200_1_pre_eq, CU_200_1_pim_eq]

def CU_200_2_pre : Polynomial ℚ := C ((-5954714510900 / 235794999 : ℚ)) + C ((-42657426890624 / 235794999 : ℚ)) * X + C ((-26798343233136 / 78598333 : ℚ)) * X ^ 2 + C ((-126296598770698 / 235794999 : ℚ)) * X ^ 3 + C ((-16352525885833 / 21435909 : ℚ)) * X ^ 4 + C ((-206252719971107 / 235794999 : ℚ)) * X ^ 5 + C ((-75226448963174 / 78598333 : ℚ)) * X ^ 6 + C ((-469617992335981 / 471589998 : ℚ)) * X ^ 7 + C ((-39558519801791 / 42871818 : ℚ)) * X ^ 8 + C ((-71423414321195 / 78598333 : ℚ)) * X ^ 9 + C ((-141172168837053 / 157196666 : ℚ)) * X ^ 10 + C ((-204868537811653 / 235794999 : ℚ)) * X ^ 11 + C ((-338201652729911 / 471589998 : ℚ)) * X ^ 12 + C ((-4056824644369 / 7145303 : ℚ)) * X ^ 13 + C ((-182550520278305 / 471589998 : ℚ)) * X ^ 14 + C ((-27149147356607 / 157196666 : ℚ)) * X ^ 15 + C ((-16143366364024 / 235794999 : ℚ)) * X ^ 16 + C ((1094420184797 / 78598333 : ℚ)) * X ^ 17 + C ((4735830129639 / 78598333 : ℚ)) * X ^ 18
def CU_200_2_pim : Polynomial ℚ := C ((6378765519496 / 78598333 : ℚ)) + C ((12757531038992 / 78598333 : ℚ)) * X + C ((36339597132434 / 235794999 : ℚ)) * X ^ 2 + C ((12083091868021 / 78598333 : ℚ)) * X ^ 3 + C ((3330385101157 / 78598333 : ℚ)) * X ^ 4 + C ((-61938219220237 / 471589998 : ℚ)) * X ^ 5 + C ((-41501221632897 / 157196666 : ℚ)) * X ^ 6 + C ((-68013118111041 / 157196666 : ℚ)) * X ^ 7 + C ((-248276988593915 / 471589998 : ℚ)) * X ^ 8 + C ((-41220512567947 / 78598333 : ℚ)) * X ^ 9 + C ((-121476820218905 / 235794999 : ℚ)) * X ^ 10 + C ((-45807384483496 / 78598333 : ℚ)) * X ^ 11 + C ((-153367486682071 / 235794999 : ℚ)) * X ^ 12 + C ((-149249773212593 / 235794999 : ℚ)) * X ^ 13 + C ((-297364990182211 / 471589998 : ℚ)) * X ^ 14 + C ((-247628154904613 / 471589998 : ℚ)) * X ^ 15 + C ((-57102826300365 / 157196666 : ℚ)) * X ^ 16 + C ((-115393064547977 / 471589998 : ℚ)) * X ^ 17 + C ((-20729114468603 / 235794999 : ℚ)) * X ^ 18
theorem CU_200_2_pre_eq :
    CU_2_re_000 * Fplus_dW_re_200 - CU_2_im_000 * Fplus_dW_im_200 = CU_200_2_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_2_re_000, CU_2_im_000, Fplus_dW_re_200, Fplus_dW_im_200, CU_200_2_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CU_200_2_pim_eq :
    CU_2_re_000 * Fplus_dW_im_200 + CU_2_im_000 * Fplus_dW_re_200 = CU_200_2_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_2_re_000, CU_2_im_000, Fplus_dW_re_200, Fplus_dW_im_200, CU_200_2_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CU_200_2_mul :
    CU_2_c_000 * Fplus_dW_c_200 = ofLadj CU_200_2_pre CU_200_2_pim := by
  rw [CU_2_c_000, Fplus_dW_c_200, ofLadj_mul, CU_200_2_pre_eq, CU_200_2_pim_eq]

theorem CU_200_3_mul : CU_3_c_100 = ofLadj CU_3_re_100 CU_3_im_100 := rfl

@[expose] public def CU_coeff_200 : Ki := CU_0_c_000 * Fplus_dU_c_200 + CU_1_c_000 * Fplus_dV_c_200 + CU_2_c_000 * Fplus_dW_c_200 + CU_3_c_100

theorem CU_coeff_200_sum :
    CU_coeff_200 = ofLadj (CU_200_0_pre + CU_200_1_pre + CU_200_2_pre + CU_3_re_100) (CU_200_0_pim + CU_200_1_pim + CU_200_2_pim + CU_3_im_100) := by
  simp only [CU_coeff_200, CU_200_0_mul, CU_200_1_mul, CU_200_2_mul, CU_200_3_mul]
  simpa [add_assoc] using ofLadj_add4 CU_200_0_pre CU_200_0_pim CU_200_1_pre CU_200_1_pim CU_200_2_pre CU_200_2_pim CU_3_re_100 CU_3_im_100

def CU_200_qre : Polynomial ℚ := C ((-5589547651790 / 235794999 : ℚ)) + C ((-30477438295690 / 235794999 : ℚ)) * X + C ((-21012316210359 / 157196666 : ℚ)) * X ^ 2 + C ((-76845966055471 / 471589998 : ℚ)) * X ^ 3 + C ((-27328355722323 / 157196666 : ℚ)) * X ^ 4 + C ((-36939755098417 / 471589998 : ℚ)) * X ^ 5 + C ((-12352799800079 / 235794999 : ℚ)) * X ^ 6 + C ((-6881233830571 / 235794999 : ℚ)) * X ^ 7 + C ((8254818734247 / 157196666 : ℚ)) * X ^ 8
def CU_200_qim : Polynomial ℚ := C ((28702466110535 / 471589998 : ℚ)) + C ((28702466110535 / 471589998 : ℚ)) * X + C ((-223112546571 / 14290606 : ℚ)) * X ^ 2 + C ((-3569582249683 / 235794999 : ℚ)) * X ^ 3 + C ((-8304667824131 / 78598333 : ℚ)) * X ^ 4 + C ((-34199463059287 / 235794999 : ℚ)) * X ^ 5 + C ((-24523794073826 / 235794999 : ℚ)) * X ^ 6 + C ((-19142464130951 / 157196666 : ℚ)) * X ^ 7 + C ((-16236340888463 / 235794999 : ℚ)) * X ^ 8
theorem CU_coeff_200_poly_re :
    CU_200_0_pre + CU_200_1_pre + CU_200_2_pre + CU_3_re_100 = (0 : Polynomial ℚ) + Phi11 * CU_200_qre := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [CU_200_0_pre, CU_200_1_pre, CU_200_2_pre, CU_3_re_100, CU_200_qre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try ring
theorem CU_coeff_200_poly_im :
    CU_200_0_pim + CU_200_1_pim + CU_200_2_pim + CU_3_im_100 = (0 : Polynomial ℚ) + Phi11 * CU_200_qim := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [CU_200_0_pim, CU_200_1_pim, CU_200_2_pim, CU_3_im_100, CU_200_qim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try ring
public theorem CU_coeff_200_eq :
    CU_coeff_200 = (0 : Ki) := by
  rw [CU_coeff_200_sum, CU_coeff_200_poly_re,
    CU_coeff_200_poly_im, ofLadj_add_Phi11]
  exact ofLadj_zero

end V14Formalization.D12SigmaPlusSegreCore
