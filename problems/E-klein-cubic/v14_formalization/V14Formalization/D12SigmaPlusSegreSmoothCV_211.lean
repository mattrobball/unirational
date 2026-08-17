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

def CV_211_0_pre : Polynomial ℚ := C ((-192346050756 / 2879985977 : ℚ)) + C ((2444790445312 / 8639957931 : ℚ)) * X + C ((4307705098019 / 8639957931 : ℚ)) * X ^ 2 + C ((20726854991 / 23801537 : ℚ)) * X ^ 3 + C ((4369289251218 / 2879985977 : ℚ)) * X ^ 4 + C ((5589387335186 / 2879985977 : ℚ)) * X ^ 5 + C ((20439996768373 / 8639957931 : ℚ)) * X ^ 6 + C ((21878433508075 / 8639957931 : ℚ)) * X ^ 7 + C ((20195314001818 / 8639957931 : ℚ)) * X ^ 8 + C ((1693824236062 / 785450721 : ℚ)) * X ^ 9 + C ((18353633560652 / 8639957931 : ℚ)) * X ^ 10 + C ((6013665535892 / 2879985977 : ℚ)) * X ^ 11 + C ((15908843115340 / 8639957931 : ℚ)) * X ^ 12 + C ((4774787166221 / 2879985977 : ℚ)) * X ^ 13 + C ((12671465640085 / 8639957931 : ℚ)) * X ^ 14 + C ((7833324777376 / 8639957931 : ℚ)) * X ^ 15 + C ((4998532685368 / 8639957931 : ℚ)) * X ^ 16 + C ((442232640851 / 2879985977 : ℚ)) * X ^ 17 + C ((-312413659015 / 2879985977 : ℚ)) * X ^ 18
def CV_211_0_pim : Polynomial ℚ := C ((-2478687572104 / 8639957931 : ℚ)) + C ((-4957375144208 / 8639957931 : ℚ)) * X + C ((-6220734185581 / 8639957931 : ℚ)) * X ^ 2 + C ((-2838823181151 / 2879985977 : ℚ)) * X ^ 3 + C ((-9038328059837 / 8639957931 : ℚ)) * X ^ 4 + C ((-6151372166650 / 8639957931 : ℚ)) * X ^ 5 + C ((-4587573443900 / 8639957931 : ℚ)) * X ^ 6 + C ((999078053980 / 8639957931 : ℚ)) * X ^ 7 + C ((944265757827 / 2879985977 : ℚ)) * X ^ 8 + C ((2968765090466 / 8639957931 : ℚ)) * X ^ 9 + C ((2004963310927 / 8639957931 : ℚ)) * X ^ 10 + C ((3498173949016 / 8639957931 : ℚ)) * X ^ 11 + C ((4991384587105 / 8639957931 : ℚ)) * X ^ 12 + C ((5290941848939 / 8639957931 : ℚ)) * X ^ 13 + C ((2574215007932 / 2879985977 : ℚ)) * X ^ 14 + C ((8251589195176 / 8639957931 : ℚ)) * X ^ 15 + C ((6836217923959 / 8639957931 : ℚ)) * X ^ 16 + C ((5941700440415 / 8639957931 : ℚ)) * X ^ 17 + C ((608877854835 / 2879985977 : ℚ)) * X ^ 18
theorem CV_211_0_pre_eq :
    CV_0_re_101 * Fplus_dU_re_110 - CV_0_im_101 * Fplus_dU_im_110 = CV_211_0_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_0_re_101, CV_0_im_101, Fplus_dU_re_110, Fplus_dU_im_110, CV_211_0_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CV_211_0_pim_eq :
    CV_0_re_101 * Fplus_dU_im_110 + CV_0_im_101 * Fplus_dU_re_110 = CV_211_0_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_0_re_101, CV_0_im_101, Fplus_dU_re_110, Fplus_dU_im_110, CV_211_0_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CV_211_0_mul :
    CV_0_c_101 * Fplus_dU_c_110 = ofLadj CV_211_0_pre CV_211_0_pim := by
  rw [CV_0_c_101, Fplus_dU_c_110, ofLadj_mul, CV_211_0_pre_eq, CV_211_0_pim_eq]

def CV_211_1_pre : Polynomial ℚ := C ((27464104006 / 97078179 : ℚ)) + C ((-33856499450 / 8825289 : ℚ)) * X + C ((-671367969700 / 97078179 : ℚ)) * X ^ 2 + C ((-1196413579243 / 97078179 : ℚ)) * X ^ 3 + C ((-1958087368243 / 97078179 : ℚ)) * X ^ 4 + C ((-843892255672 / 32359393 : ℚ)) * X ^ 5 + C ((-3087269967349 / 97078179 : ℚ)) * X ^ 6 + C ((-3547055511895 / 97078179 : ℚ)) * X ^ 7 + C ((-3586698146840 / 97078179 : ℚ)) * X ^ 8 + C ((-3709832064887 / 97078179 : ℚ)) * X ^ 9 + C ((-3813832609102 / 97078179 : ℚ)) * X ^ 10 + C ((-3871699457420 / 97078179 : ℚ)) * X ^ 11 + C ((-1147137038384 / 32359393 : ℚ)) * X ^ 12 + C ((-3038464095187 / 97078179 : ℚ)) * X ^ 13 + C ((-2390284567597 / 97078179 : ℚ)) * X ^ 14 + C ((-1508158538251 / 97078179 : ℚ)) * X ^ 15 + C ((-289035847143 / 32359393 : ℚ)) * X ^ 16 + C ((-311514341096 / 97078179 : ℚ)) * X ^ 17 + C ((80809605401 / 97078179 : ℚ)) * X ^ 18
def CV_211_1_pim : Polynomial ℚ := C ((117339960295 / 32359393 : ℚ)) + C ((234679920590 / 32359393 : ℚ)) * X + C ((938136403169 / 97078179 : ℚ)) * X ^ 2 + C ((442882642061 / 32359393 : ℚ)) * X ^ 3 + C ((464510183191 / 32359393 : ℚ)) * X ^ 4 + C ((409350405051 / 32359393 : ℚ)) * X ^ 5 + C ((1105086241877 / 97078179 : ℚ)) * X ^ 6 + C ((215429295161 / 32359393 : ℚ)) * X ^ 7 + C ((118569507553 / 32359393 : ℚ)) * X ^ 8 + C ((111461879394 / 32359393 : ℚ)) * X ^ 9 + C ((84043331257 / 32359393 : ℚ)) * X ^ 10 + C ((-225044458850 / 97078179 : ℚ)) * X ^ 11 + C ((-63838082861 / 8825289 : ℚ)) * X ^ 12 + C ((-30865793857 / 2941763 : ℚ)) * X ^ 13 + C ((-1430405604772 / 97078179 : ℚ)) * X ^ 14 + C ((-478901964557 / 32359393 : ℚ)) * X ^ 15 + C ((-389340841812 / 32359393 : ℚ)) * X ^ 16 + C ((-303721362508 / 32359393 : ℚ)) * X ^ 17 + C ((-349161697315 / 97078179 : ℚ)) * X ^ 18
theorem CV_211_1_pre_eq :
    CV_1_re_101 * Fplus_dV_re_110 - CV_1_im_101 * Fplus_dV_im_110 = CV_211_1_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_1_re_101, CV_1_im_101, Fplus_dV_re_110, Fplus_dV_im_110, CV_211_1_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CV_211_1_pim_eq :
    CV_1_re_101 * Fplus_dV_im_110 + CV_1_im_101 * Fplus_dV_re_110 = CV_211_1_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_1_re_101, CV_1_im_101, Fplus_dV_re_110, Fplus_dV_im_110, CV_211_1_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CV_211_1_mul :
    CV_1_c_101 * Fplus_dV_c_110 = ofLadj CV_211_1_pre CV_211_1_pim := by
  rw [CV_1_c_101, Fplus_dV_c_110, ofLadj_mul, CV_211_1_pre_eq, CV_211_1_pim_eq]

def CV_211_2_pre : Polynomial ℚ := C ((-7741012130030 / 8639957931 : ℚ)) + C ((-107361291042200 / 8639957931 : ℚ)) * X + C ((-6614347332686 / 261816907 : ℚ)) * X ^ 2 + C ((-358816557222949 / 8639957931 : ℚ)) * X ^ 3 + C ((-534167603157025 / 8639957931 : ℚ)) * X ^ 4 + C ((-634497974769929 / 8639957931 : ℚ)) * X ^ 5 + C ((-715713678808598 / 8639957931 : ℚ)) * X ^ 6 + C ((-253416511800102 / 2879985977 : ℚ)) * X ^ 7 + C ((-724314889975274 / 8639957931 : ℚ)) * X ^ 8 + C ((-710613880738429 / 8639957931 : ℚ)) * X ^ 9 + C ((-233387129402770 / 2879985977 : ℚ)) * X ^ 10 + C ((-229498600793266 / 2879985977 : ℚ)) * X ^ 11 + C ((-592800097166110 / 8639957931 : ℚ)) * X ^ 12 + C ((-492340418759791 / 8639957931 : ℚ)) * X ^ 13 + C ((-365498332752325 / 8639957931 : ℚ)) * X ^ 14 + C ((-67569154936075 / 2879985977 : ℚ)) * X ^ 15 + C ((-36617843284196 / 2879985977 : ℚ)) * X ^ 16 + C ((-9545941937973 / 2879985977 : ℚ)) * X ^ 17 + C ((23374467435056 / 8639957931 : ℚ)) * X ^ 18
def CV_211_2_pim : Polynomial ℚ := C ((72374820721370 / 8639957931 : ℚ)) + C ((144749641442740 / 8639957931 : ℚ)) * X + C ((57175616098848 / 2879985977 : ℚ)) * X ^ 2 + C ((202169997993649 / 8639957931 : ℚ)) * X ^ 3 + C ((50651339235951 / 2879985977 : ℚ)) * X ^ 4 + C ((17714026481619 / 2879985977 : ℚ)) * X ^ 5 + C ((-25966262989268 / 8639957931 : ℚ)) * X ^ 6 + C ((-47542517419568 / 2879985977 : ℚ)) * X ^ 7 + C ((-6347171174255 / 261816907 : ℚ)) * X ^ 8 + C ((-207505967178703 / 8639957931 : ℚ)) * X ^ 9 + C ((-198452637425531 / 8639957931 : ℚ)) * X ^ 10 + C ((-257543844593450 / 8639957931 : ℚ)) * X ^ 11 + C ((-28785004705579 / 785450721 : ℚ)) * X ^ 12 + C ((-334358928862001 / 8639957931 : ℚ)) * X ^ 13 + C ((-363051396987394 / 8639957931 : ℚ)) * X ^ 14 + C ((-318580799998427 / 8639957931 : ℚ)) * X ^ 15 + C ((-21036555318800 / 785450721 : ℚ)) * X ^ 16 + C ((-5033689566453 / 261816907 : ℚ)) * X ^ 17 + C ((-61083713194882 / 8639957931 : ℚ)) * X ^ 18
theorem CV_211_2_pre_eq :
    CV_2_re_101 * Fplus_dW_re_110 - CV_2_im_101 * Fplus_dW_im_110 = CV_211_2_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_2_re_101, CV_2_im_101, Fplus_dW_re_110, Fplus_dW_im_110, CV_211_2_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CV_211_2_pim_eq :
    CV_2_re_101 * Fplus_dW_im_110 + CV_2_im_101 * Fplus_dW_re_110 = CV_211_2_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CV_2_re_101, CV_2_im_101, Fplus_dW_re_110, Fplus_dW_im_110, CV_211_2_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CV_211_2_mul :
    CV_2_c_101 * Fplus_dW_c_110 = ofLadj CV_211_2_pre CV_211_2_pim := by
  rw [CV_2_c_101, Fplus_dW_c_110, ofLadj_mul, CV_211_2_pre_eq, CV_211_2_pim_eq]

theorem CV_211_3_mul : CV_3_c_201 = ofLadj CV_3_re_201 CV_3_im_201 := rfl

@[expose] public def CV_coeff_211 : Ki := CV_0_c_101 * Fplus_dU_c_110 + CV_1_c_101 * Fplus_dV_c_110 + CV_2_c_101 * Fplus_dW_c_110 + CV_3_c_201

theorem CV_coeff_211_sum :
    CV_coeff_211 = ofLadj (CV_211_0_pre + CV_211_1_pre + CV_211_2_pre + CV_3_re_201) (CV_211_0_pim + CV_211_1_pim + CV_211_2_pim + CV_3_im_201) := by
  simp only [CV_coeff_211, CV_211_0_mul, CV_211_1_mul, CV_211_2_mul, CV_211_3_mul]
  simpa [add_assoc] using ofLadj_add4 CV_211_0_pre CV_211_0_pim CV_211_1_pre CV_211_1_pim CV_211_2_pre CV_211_2_pim CV_3_re_201 CV_3_im_201

def CV_211_qre : Polynomial ℚ := C ((-51262804754 / 71404611 : ℚ)) + C ((-131859214183204 / 8639957931 : ℚ)) * X + C ((-44912493855509 / 2879985977 : ℚ)) * X ^ 2 + C ((-182877168104398 / 8639957931 : ℚ)) * X ^ 3 + C ((-236461943693185 / 8639957931 : ℚ)) * X ^ 4 + C ((-147072681580787 / 8639957931 : ℚ)) * X ^ 5 + C ((-126991664105491 / 8639957931 : ℚ)) * X ^ 6 + C ((-84665185587610 / 8639957931 : ℚ)) * X ^ 7 + C ((9876427112900 / 2879985977 : ℚ)) * X ^ 8
def CV_211_qim : Polynomial ℚ := C ((100066522813099 / 8639957931 : ℚ)) + C ((100066522813099 / 8639957931 : ℚ)) * X + C ((15193224425296 / 2879985977 : ℚ)) * X ^ 2 + C ((20971342405745 / 2879985977 : ℚ)) * X ^ 3 + C ((-44438815448336 / 8639957931 : ℚ)) * X ^ 4 + C ((-109676139993325 / 8639957931 : ℚ)) * X ^ 5 + C ((-87256236304475 / 8639957931 : ℚ)) * X ^ 6 + C ((-150931188350758 / 8639957931 : ℚ)) * X ^ 7 + C ((-30110823563804 / 2879985977 : ℚ)) * X ^ 8
theorem CV_coeff_211_poly_re :
    CV_211_0_pre + CV_211_1_pre + CV_211_2_pre + CV_3_re_201 = (0 : Polynomial ℚ) + Phi11 * CV_211_qre := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [CV_211_0_pre, CV_211_1_pre, CV_211_2_pre, CV_3_re_201, CV_211_qre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try ring
theorem CV_coeff_211_poly_im :
    CV_211_0_pim + CV_211_1_pim + CV_211_2_pim + CV_3_im_201 = (0 : Polynomial ℚ) + Phi11 * CV_211_qim := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [CV_211_0_pim, CV_211_1_pim, CV_211_2_pim, CV_3_im_201, CV_211_qim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try ring
public theorem CV_coeff_211_eq :
    CV_coeff_211 = (0 : Ki) := by
  rw [CV_coeff_211_sum, CV_coeff_211_poly_re,
    CV_coeff_211_poly_im, ofLadj_add_Phi11]
  exact ofLadj_zero

end V14Formalization.D12SigmaPlusSegreCore
