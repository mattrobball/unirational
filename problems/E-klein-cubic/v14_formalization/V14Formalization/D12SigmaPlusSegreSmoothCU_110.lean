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

def CU_110_0_pre : Polynomial ℚ := C ((-5441785935 / 78598333 : ℚ)) + C ((-2603497153688 / 235794999 : ℚ)) * X + C ((-1742137989950 / 78598333 : ℚ)) * X ^ 2 + C ((-8765248478966 / 235794999 : ℚ)) * X ^ 3 + C ((-14604890097668 / 235794999 : ℚ)) * X ^ 4 + C ((-18578433642113 / 235794999 : ℚ)) * X ^ 5 + C ((-22681530064672 / 235794999 : ℚ)) * X ^ 6 + C ((-2210044143644 / 21435909 : ℚ)) * X ^ 7 + C ((-22516725566101 / 235794999 : ℚ)) * X ^ 8 + C ((-21306336204583 / 235794999 : ℚ)) * X ^ 9 + C ((-20377439099984 / 235794999 : ℚ)) * X ^ 10 + C ((-20049451413842 / 235794999 : ℚ)) * X ^ 11 + C ((-5924647315432 / 78598333 : ℚ)) * X ^ 12 + C ((-16079922234733 / 235794999 : ℚ)) * X ^ 13 + C ((-13751477087135 / 235794999 : ℚ)) * X ^ 14 + C ((-9036795413213 / 235794999 : ℚ)) * X ^ 15 + C ((-518149242785 / 21435909 : ℚ)) * X ^ 16 + C ((-1596545248076 / 235794999 : ℚ)) * X ^ 17 + C ((222933356401 / 78598333 : ℚ)) * X ^ 18
def CU_110_0_pim : Polynomial ℚ := C ((2459359703939 / 235794999 : ℚ)) + C ((4918719407878 / 235794999 : ℚ)) * X + C ((2170115671074 / 78598333 : ℚ)) * X ^ 2 + C ((2962789120924 / 78598333 : ℚ)) * X ^ 3 + C ((8722696208570 / 235794999 : ℚ)) * X ^ 4 + C ((198243982677 / 7145303 : ℚ)) * X ^ 5 + C ((3897857847982 / 235794999 : ℚ)) * X ^ 6 + C ((-1388754692096 / 235794999 : ℚ)) * X ^ 7 + C ((-4126979791433 / 235794999 : ℚ)) * X ^ 8 + C ((-1319162764479 / 78598333 : ℚ)) * X ^ 9 + C ((-3135604781480 / 235794999 : ℚ)) * X ^ 10 + C ((-4438959160522 / 235794999 : ℚ)) * X ^ 11 + C ((-1914104513188 / 78598333 : ℚ)) * X ^ 12 + C ((-6512057632951 / 235794999 : ℚ)) * X ^ 13 + C ((-8720586484505 / 235794999 : ℚ)) * X ^ 14 + C ((-9063997851571 / 235794999 : ℚ)) * X ^ 15 + C ((-2643266215393 / 78598333 : ℚ)) * X ^ 16 + C ((-6469309543310 / 235794999 : ℚ)) * X ^ 17 + C ((-67549775093 / 7145303 : ℚ)) * X ^ 18
theorem CU_110_0_pre_eq :
    CU_0_re_000 * Fplus_dU_re_110 - CU_0_im_000 * Fplus_dU_im_110 = CU_110_0_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_0_re_000, CU_0_im_000, Fplus_dU_re_110, Fplus_dU_im_110, CU_110_0_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CU_110_0_pim_eq :
    CU_0_re_000 * Fplus_dU_im_110 + CU_0_im_000 * Fplus_dU_re_110 = CU_110_0_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_0_re_000, CU_0_im_000, Fplus_dU_re_110, Fplus_dU_im_110, CU_110_0_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CU_110_0_mul :
    CU_0_c_000 * Fplus_dU_c_110 = ofLadj CU_110_0_pre CU_110_0_pim := by
  rw [CU_0_c_000, Fplus_dU_c_110, ofLadj_mul, CU_110_0_pre_eq, CU_110_0_pim_eq]

def CU_110_1_pre : Polynomial ℚ := C ((28839121307 / 235794999 : ℚ)) + C ((32952204715720 / 235794999 : ℚ)) * X + C ((62426961104389 / 235794999 : ℚ)) * X ^ 2 + C ((107444076463322 / 235794999 : ℚ)) * X ^ 3 + C ((15940625444992 / 21435909 : ℚ)) * X ^ 4 + C ((226302551168077 / 235794999 : ℚ)) * X ^ 5 + C ((25072842066548 / 21435909 : ℚ)) * X ^ 6 + C ((315808745502028 / 235794999 : ℚ)) * X ^ 7 + C ((107032464096791 / 78598333 : ℚ)) * X ^ 8 + C ((332311056614401 / 235794999 : ℚ)) * X ^ 9 + C ((340851194285251 / 235794999 : ℚ)) * X ^ 10 + C ((344034331359700 / 235794999 : ℚ)) * X ^ 11 + C ((102632996523177 / 78598333 : ℚ)) * X ^ 12 + C ((89961365170004 / 78598333 : ℚ)) * X ^ 13 + C ((213653315827051 / 235794999 : ℚ)) * X ^ 14 + C ((45155316170044 / 78598333 : ℚ)) * X ^ 15 + C ((78380065091411 / 235794999 : ℚ)) * X ^ 16 + C ((28881353527460 / 235794999 : ℚ)) * X ^ 17 + C ((-454174281544 / 21435909 : ℚ)) * X ^ 18
def CU_110_1_pim : Polynomial ℚ := C ((-10141282714319 / 78598333 : ℚ)) + C ((-20282565428638 / 78598333 : ℚ)) * X + C ((-82215219620453 / 235794999 : ℚ)) * X ^ 2 + C ((-38477177076990 / 78598333 : ℚ)) * X ^ 3 + C ((-40284675765810 / 78598333 : ℚ)) * X ^ 4 + C ((-35801771362345 / 78598333 : ℚ)) * X ^ 5 + C ((-31399279113714 / 78598333 : ℚ)) * X ^ 6 + C ((-56112364071668 / 235794999 : ℚ)) * X ^ 7 + C ((-28789456138777 / 235794999 : ℚ)) * X ^ 8 + C ((-9056210239017 / 78598333 : ℚ)) * X ^ 9 + C ((-19768335169469 / 235794999 : ℚ)) * X ^ 10 + C ((652199662392 / 7145303 : ℚ)) * X ^ 11 + C ((62813512887341 / 235794999 : ℚ)) * X ^ 12 + C ((91581331769462 / 235794999 : ℚ)) * X ^ 13 + C ((126418468801705 / 235794999 : ℚ)) * X ^ 14 + C ((11557089955046 / 21435909 : ℚ)) * X ^ 15 + C ((9470501457737 / 21435909 : ℚ)) * X ^ 16 + C ((79625116825028 / 235794999 : ℚ)) * X ^ 17 + C ((32035883295550 / 235794999 : ℚ)) * X ^ 18
theorem CU_110_1_pre_eq :
    CU_1_re_000 * Fplus_dV_re_110 - CU_1_im_000 * Fplus_dV_im_110 = CU_110_1_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_1_re_000, CU_1_im_000, Fplus_dV_re_110, Fplus_dV_im_110, CU_110_1_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CU_110_1_pim_eq :
    CU_1_re_000 * Fplus_dV_im_110 + CU_1_im_000 * Fplus_dV_re_110 = CU_110_1_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_1_re_000, CU_1_im_000, Fplus_dV_re_110, Fplus_dV_im_110, CU_110_1_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CU_110_1_mul :
    CU_1_c_000 * Fplus_dV_c_110 = ofLadj CU_110_1_pre CU_110_1_pim := by
  rw [CU_1_c_000, Fplus_dV_c_110, ofLadj_mul, CU_110_1_pre_eq, CU_110_1_pim_eq]

def CU_110_2_pre : Polynomial ℚ := C ((711120269056 / 21435909 : ℚ)) + C ((106643567226560 / 235794999 : ℚ)) * X + C ((216920408499904 / 235794999 : ℚ)) * X ^ 2 + C ((118684236312652 / 78598333 : ℚ)) * X ^ 3 + C ((48210583232290 / 21435909 : ℚ)) * X ^ 4 + C ((630411865966748 / 235794999 : ℚ)) * X ^ 5 + C ((236834590742674 / 78598333 : ℚ)) * X ^ 6 + C ((68621158050233 / 21435909 : ℚ)) * X ^ 7 + C ((239761290690326 / 78598333 : ℚ)) * X ^ 8 + C ((705671338109372 / 235794999 : ℚ)) * X ^ 9 + C ((695309902464233 / 235794999 : ℚ)) * X ^ 10 + C ((227881253882944 / 78598333 : ℚ)) * X ^ 11 + C ((17838373795081 / 7145303 : ℚ)) * X ^ 12 + C ((488750929609468 / 235794999 : ℚ)) * X ^ 13 + C ((121077054377674 / 78598333 : ℚ)) * X ^ 14 + C ((67154679630479 / 78598333 : ℚ)) * X ^ 15 + C ((108761443595722 / 235794999 : ℚ)) * X ^ 16 + C ((9556512444816 / 78598333 : ℚ)) * X ^ 17 + C ((-23052284105936 / 235794999 : ℚ)) * X ^ 18
def CU_110_2_pim : Polynomial ℚ := C ((-23945181340732 / 78598333 : ℚ)) + C ((-47890362681464 / 78598333 : ℚ)) * X + C ((-170203933781974 / 235794999 : ℚ)) * X ^ 2 + C ((-200511051339506 / 235794999 : ℚ)) * X ^ 3 + C ((-13749055303418 / 21435909 : ℚ)) * X ^ 4 + C ((-17563482883940 / 78598333 : ℚ)) * X ^ 5 + C ((26011261358948 / 235794999 : ℚ)) * X ^ 6 + C ((141403570610975 / 235794999 : ℚ)) * X ^ 7 + C ((207870648761740 / 235794999 : ℚ)) * X ^ 8 + C ((205906532019790 / 235794999 : ℚ)) * X ^ 9 + C ((196891727486689 / 235794999 : ℚ)) * X ^ 10 + C ((85191480221436 / 78598333 : ℚ)) * X ^ 11 + C ((314257153841927 / 235794999 : ℚ)) * X ^ 12 + C ((110591731682136 / 78598333 : ℚ)) * X ^ 13 + C ((360118195861990 / 235794999 : ℚ)) * X ^ 14 + C ((316575146864773 / 235794999 : ℚ)) * X ^ 15 + C ((76526981607024 / 78598333 : ℚ)) * X ^ 16 + C ((164576035756024 / 235794999 : ℚ)) * X ^ 17 + C ((5521698558734 / 21435909 : ℚ)) * X ^ 18
theorem CU_110_2_pre_eq :
    CU_2_re_000 * Fplus_dW_re_110 - CU_2_im_000 * Fplus_dW_im_110 = CU_110_2_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_2_re_000, CU_2_im_000, Fplus_dW_re_110, Fplus_dW_im_110, CU_110_2_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CU_110_2_pim_eq :
    CU_2_re_000 * Fplus_dW_im_110 + CU_2_im_000 * Fplus_dW_re_110 = CU_110_2_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_2_re_000, CU_2_im_000, Fplus_dW_re_110, Fplus_dW_im_110, CU_110_2_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CU_110_2_mul :
    CU_2_c_000 * Fplus_dW_c_110 = ofLadj CU_110_2_pre CU_110_2_pim := by
  rw [CU_2_c_000, Fplus_dW_c_110, ofLadj_mul, CU_110_2_pre_eq, CU_110_2_pim_eq]

def CU_110_3_pre : Polynomial ℚ := C ((29107211972 / 21435909 : ℚ)) + C ((-81127351790 / 21435909 : ℚ)) * X ^ 2 + C ((-189171013250 / 21435909 : ℚ)) * X ^ 3 + C ((-287994517390 / 21435909 : ℚ)) * X ^ 4 + C ((-344926623610 / 21435909 : ℚ)) * X ^ 5 + C ((-344926623610 / 21435909 : ℚ)) * X ^ 6 + C ((-287994517390 / 21435909 : ℚ)) * X ^ 7 + C ((-189171013250 / 21435909 : ℚ)) * X ^ 8 + C ((-81127351790 / 21435909 : ℚ)) * X ^ 9
def CU_110_3_pim : Polynomial ℚ := C ((1129749634232 / 235794999 : ℚ)) + C ((2259499268464 / 235794999 : ℚ)) * X + C ((3052124742026 / 235794999 : ℚ)) * X ^ 2 + C ((3225924564254 / 235794999 : ℚ)) * X ^ 3 + C ((2719588443490 / 235794999 : ℚ)) * X ^ 4 + C ((1714836636254 / 235794999 : ℚ)) * X ^ 5 + C ((544662632210 / 235794999 : ℚ)) * X ^ 6 + C ((-153363058342 / 78598333 : ℚ)) * X ^ 7 + C ((-966425295790 / 235794999 : ℚ)) * X ^ 8 + C ((-792625473562 / 235794999 : ℚ)) * X ^ 9
theorem CU_110_3_neg_re : -CU_3_re_110 = CU_110_3_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_3_re_110, CU_110_3_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CU_110_3_neg_im : -CU_3_im_110 = CU_110_3_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_3_im_110, CU_110_3_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CU_110_3_mul : -CU_3_c_110 = ofLadj CU_110_3_pre CU_110_3_pim := by
  rw [CU_3_c_110, ofLadj_neg, CU_110_3_neg_re, CU_110_3_neg_im]

def CU_coeff_110 : Ki := CU_0_c_000 * Fplus_dU_c_110 + CU_1_c_000 * Fplus_dV_c_110 + CU_2_c_000 * Fplus_dW_c_110 + (-CU_3_c_110)

theorem CU_coeff_110_sum :
    CU_coeff_110 = ofLadj (CU_110_0_pre + CU_110_1_pre + CU_110_2_pre + CU_110_3_pre) (CU_110_0_pim + CU_110_1_pim + CU_110_2_pim + CU_110_3_pim) := by
  simp only [CU_coeff_110, CU_110_0_mul, CU_110_1_mul, CU_110_2_mul, CU_110_3_mul]
  simpa [add_assoc] using ofLadj_add4 CU_110_0_pre CU_110_0_pim CU_110_1_pre CU_110_1_pim CU_110_2_pre CU_110_2_pim CU_110_3_pre CU_110_3_pim

def CU_110_qre : Polynomial ℚ := C ((8155016054810 / 235794999 : ℚ)) + C ((128837258733782 / 235794999 : ℚ)) * X + C ((45412093325387 / 78598333 : ℚ)) * X ^ 2 + C ((179422101011809 / 235794999 : ℚ)) * X ^ 3 + C ((235239809884582 / 235794999 : ℚ)) * X ^ 4 + C ((146451324971858 / 235794999 : ℚ)) * X ^ 5 + C ((125487521402666 / 235794999 : ℚ)) * X ^ 6 + C ((83333746747549 / 235794999 : ℚ)) * X ^ 7 + C ((-27379401133717 / 235794999 : ℚ)) * X ^ 8
def CU_110_qim : Polynomial ℚ := C ((-98670282826982 / 235794999 : ℚ)) + C ((-98670282826982 / 235794999 : ℚ)) * X + C ((-15172038664405 / 78598333 : ℚ)) * X ^ 2 + C ((-60971608996271 / 235794999 : ℚ)) * X ^ 3 + C ((43176939660482 / 235794999 : ℚ)) * X ^ 4 + C ((36270825436236 / 78598333 : ℚ)) * X ^ 5 + C ((29364939724086 / 78598333 : ℚ)) * X ^ 6 + C ((147186418174187 / 235794999 : ℚ)) * X ^ 7 + C ((90545424863555 / 235794999 : ℚ)) * X ^ 8
theorem CU_coeff_110_poly_re :
    CU_110_0_pre + CU_110_1_pre + CU_110_2_pre + CU_110_3_pre = (0 : Polynomial ℚ) + Phi11 * CU_110_qre := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [CU_110_0_pre, CU_110_1_pre, CU_110_2_pre, CU_110_3_pre, CU_110_qre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try ring
theorem CU_coeff_110_poly_im :
    CU_110_0_pim + CU_110_1_pim + CU_110_2_pim + CU_110_3_pim = (0 : Polynomial ℚ) + Phi11 * CU_110_qim := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [CU_110_0_pim, CU_110_1_pim, CU_110_2_pim, CU_110_3_pim, CU_110_qim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try ring
theorem CU_coeff_110_eq :
    CU_coeff_110 = (0 : Ki) := by
  rw [CU_coeff_110_sum, CU_coeff_110_poly_re,
    CU_coeff_110_poly_im, ofLadj_add_Phi11]
  exact ofLadj_zero

end V14Formalization.D12SigmaPlusSegreCore
