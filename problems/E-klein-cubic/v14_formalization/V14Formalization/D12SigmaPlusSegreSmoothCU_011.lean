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

def CU_011_0_pre : Polynomial ℚ := C ((-1078775108566 / 235794999 : ℚ)) + C ((-13017485768440 / 235794999 : ℚ)) * X + C ((-8863720067712 / 78598333 : ℚ)) * X ^ 2 + C ((-44644411918138 / 235794999 : ℚ)) * X ^ 3 + C ((-65964246909028 / 235794999 : ℚ)) * X ^ 4 + C ((-78009867691348 / 235794999 : ℚ)) * X ^ 5 + C ((-88704267105484 / 235794999 : ℚ)) * X ^ 6 + C ((-93908600336266 / 235794999 : ℚ)) * X ^ 7 + C ((-89152260269096 / 235794999 : ℚ)) * X ^ 8 + C ((-29166811263232 / 78598333 : ℚ)) * X ^ 9 + C ((-86171292911366 / 235794999 : ℚ)) * X ^ 10 + C ((-28186191349550 / 78598333 : ℚ)) * X ^ 11 + C ((-73153807142926 / 235794999 : ℚ)) * X ^ 12 + C ((-20303091195520 / 78598333 : ℚ)) * X ^ 13 + C ((-44507848350958 / 235794999 : ℚ)) * X ^ 14 + C ((-24734189489440 / 235794999 : ℚ)) * X ^ 15 + C ((-13679060895974 / 235794999 : ℚ)) * X ^ 16 + C ((-2984661481838 / 235794999 : ℚ)) * X ^ 17 + C ((3210163937798 / 235794999 : ℚ)) * X ^ 18
def CU_011_0_pim : Polynomial ℚ := C ((8716989933374 / 235794999 : ℚ)) + C ((17433979866748 / 235794999 : ℚ)) * X + C ((21223645336424 / 235794999 : ℚ)) * X ^ 2 + C ((8291623287254 / 78598333 : ℚ)) * X ^ 3 + C ((17923889540576 / 235794999 : ℚ)) * X ^ 4 + C ((2072841706306 / 78598333 : ℚ)) * X ^ 5 + C ((-1238633271434 / 78598333 : ℚ)) * X ^ 6 + C ((-18758961291844 / 235794999 : ℚ)) * X ^ 7 + C ((-26880145806550 / 235794999 : ℚ)) * X ^ 8 + C ((-26657278719080 / 235794999 : ℚ)) * X ^ 9 + C ((-25582562705890 / 235794999 : ℚ)) * X ^ 10 + C ((-32608784417362 / 235794999 : ℚ)) * X ^ 11 + C ((-39635006128834 / 235794999 : ℚ)) * X ^ 12 + C ((-42349955585320 / 235794999 : ℚ)) * X ^ 13 + C ((-15259437674396 / 78598333 : ℚ)) * X ^ 14 + C ((-1196616453750 / 7145303 : ℚ)) * X ^ 15 + C ((-29217981414862 / 235794999 : ℚ)) * X ^ 16 + C ((-7022744285910 / 78598333 : ℚ)) * X ^ 17 + C ((-7460174242958 / 235794999 : ℚ)) * X ^ 18
theorem CU_011_0_pre_eq :
    CU_0_re_000 * Fplus_dU_re_011 - CU_0_im_000 * Fplus_dU_im_011 = CU_011_0_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_0_re_000, CU_0_im_000, Fplus_dU_re_011, Fplus_dU_im_011, CU_011_0_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CU_011_0_pim_eq :
    CU_0_re_000 * Fplus_dU_im_011 + CU_0_im_000 * Fplus_dU_re_011 = CU_011_0_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_0_re_000, CU_0_im_000, Fplus_dU_re_011, Fplus_dU_im_011, CU_011_0_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CU_011_0_mul :
    CU_0_c_000 * Fplus_dU_c_011 = ofLadj CU_011_0_pre CU_011_0_pim := by
  rw [CU_0_c_000, Fplus_dU_c_011, ofLadj_mul, CU_011_0_pre_eq, CU_011_0_pim_eq]

def CU_011_1_pre : Polynomial ℚ := C ((-4432079457172 / 78598333 : ℚ)) + C ((-184532346408032 / 235794999 : ℚ)) * X + C ((-366251925146050 / 235794999 : ℚ)) * X ^ 2 + C ((-200001811687710 / 78598333 : ℚ)) * X ^ 3 + C ((-81345857581918 / 21435909 : ℚ)) * X ^ 4 + C ((-32301479489220 / 7145303 : ℚ)) * X ^ 5 + C ((-1205516577177904 / 235794999 : ℚ)) * X ^ 6 + C ((-429875683460502 / 78598333 : ℚ)) * X ^ 7 + C ((-1228979947878982 / 235794999 : ℚ)) * X ^ 8 + C ((-1215101940608074 / 235794999 : ℚ)) * X ^ 9 + C ((-401495011884084 / 78598333 : ℚ)) * X ^ 10 + C ((-1187265073777696 / 235794999 : ℚ)) * X ^ 11 + C ((-1019952689244220 / 235794999 : ℚ)) * X ^ 12 + C ((-282950005154008 / 78598333 : ℚ)) * X ^ 13 + C ((-628974512815852 / 235794999 : ℚ)) * X ^ 14 + C ((-346950624610196 / 235794999 : ℚ)) * X ^ 15 + C ((-183375898882156 / 235794999 : ℚ)) * X ^ 16 + C ((-120683594624 / 649573 : ℚ)) * X ^ 17 + C ((47871992370212 / 235794999 : ℚ)) * X ^ 18
def CU_011_1_pim : Polynomial ℚ := C ((125558551187180 / 235794999 : ℚ)) + C ((251117102374360 / 235794999 : ℚ)) * X + C ((98200930107804 / 78598333 : ℚ)) * X ^ 2 + C ((2921908790984 / 1948719 : ℚ)) * X ^ 3 + C ((271450004030950 / 235794999 : ℚ)) * X ^ 4 + C ((9510560331586 / 21435909 : ℚ)) * X ^ 5 + C ((-31120897194188 / 235794999 : ℚ)) * X ^ 6 + C ((-78055029667464 / 78598333 : ℚ)) * X ^ 7 + C ((-353085094421890 / 235794999 : ℚ)) * X ^ 8 + C ((-351099523361140 / 235794999 : ℚ)) * X ^ 9 + C ((-341895484363934 / 235794999 : ℚ)) * X ^ 10 + C ((-41272982666648 / 21435909 : ℚ)) * X ^ 11 + C ((-188703378100774 / 78598333 : ℚ)) * X ^ 12 + C ((-200130594418056 / 78598333 : ℚ)) * X ^ 13 + C ((-657354385579070 / 235794999 : ℚ)) * X ^ 14 + C ((-193690512179132 / 78598333 : ℚ)) * X ^ 15 + C ((-426061628878480 / 235794999 : ℚ)) * X ^ 16 + C ((-101440717955558 / 78598333 : ℚ)) * X ^ 17 + C ((-113101894783058 / 235794999 : ℚ)) * X ^ 18
theorem CU_011_1_pre_eq :
    CU_1_re_000 * Fplus_dV_re_011 - CU_1_im_000 * Fplus_dV_im_011 = CU_011_1_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_1_re_000, CU_1_im_000, Fplus_dV_re_011, Fplus_dV_im_011, CU_011_1_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CU_011_1_pim_eq :
    CU_1_re_000 * Fplus_dV_im_011 + CU_1_im_000 * Fplus_dV_re_011 = CU_011_1_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_1_re_000, CU_1_im_000, Fplus_dV_re_011, Fplus_dV_im_011, CU_011_1_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CU_011_1_mul :
    CU_1_c_000 * Fplus_dV_c_011 = ofLadj CU_011_1_pre CU_011_1_pim := by
  rw [CU_1_c_000, Fplus_dV_c_011, ofLadj_mul, CU_011_1_pre_eq, CU_011_1_pim_eq]

def CU_011_2_pre : Polynomial ℚ := C ((-947344587680 / 235794999 : ℚ)) + C ((21328713445312 / 235794999 : ℚ)) * X + C ((15176797895348 / 78598333 : ℚ)) * X ^ 2 + C ((25888983521840 / 78598333 : ℚ)) * X ^ 3 + C ((123741551165372 / 235794999 : ℚ)) * X ^ 4 + C ((160189879576114 / 235794999 : ℚ)) * X ^ 5 + C ((188540176128206 / 235794999 : ℚ)) * X ^ 6 + C ((196946838615256 / 235794999 : ℚ)) * X ^ 7 + C ((178031912788550 / 235794999 : ℚ)) * X ^ 8 + C ((164747185788106 / 235794999 : ℚ)) * X ^ 9 + C ((51509624501202 / 78598333 : ℚ)) * X ^ 10 + C ((13785983554204 / 21435909 : ℚ)) * X ^ 11 + C ((133200160058294 / 235794999 : ℚ)) * X ^ 12 + C ((119216792102062 / 235794999 : ℚ)) * X ^ 13 + C ((100364962223030 / 235794999 : ℚ)) * X ^ 14 + C ((66536140033346 / 235794999 : ℚ)) * X ^ 15 + C ((12474667016248 / 78598333 : ℚ)) * X ^ 16 + C ((9073704496652 / 235794999 : ℚ)) * X ^ 17 + C ((-2223049138846 / 78598333 : ℚ)) * X ^ 18
def CU_011_2_pim : Polynomial ℚ := C ((-22898594182564 / 235794999 : ℚ)) + C ((-45797188365128 / 235794999 : ℚ)) * X + C ((-5155743408314 / 21435909 : ℚ)) * X ^ 2 + C ((-6544973488682 / 21435909 : ℚ)) * X ^ 3 + C ((-70657408116674 / 235794999 : ℚ)) * X ^ 4 + C ((-49794839734096 / 235794999 : ℚ)) * X ^ 5 + C ((-7026376456712 / 78598333 : ℚ)) * X ^ 6 + C ((6115197132982 / 78598333 : ℚ)) * X ^ 7 + C ((13374144787240 / 78598333 : ℚ)) * X ^ 8 + C ((12743566119808 / 78598333 : ℚ)) * X ^ 9 + C ((29448536674100 / 235794999 : ℚ)) * X ^ 10 + C ((39384095737940 / 235794999 : ℚ)) * X ^ 11 + C ((4483604981980 / 21435909 : ℚ)) * X ^ 12 + C ((17151160747594 / 78598333 : ℚ)) * X ^ 13 + C ((21614425708178 / 78598333 : ℚ)) * X ^ 14 + C ((23015735491978 / 78598333 : ℚ)) * X ^ 15 + C ((59519231058610 / 235794999 : ℚ)) * X ^ 16 + C ((44325741156374 / 235794999 : ℚ)) * X ^ 17 + C ((16235613352546 / 235794999 : ℚ)) * X ^ 18
theorem CU_011_2_pre_eq :
    CU_2_re_000 * Fplus_dW_re_011 - CU_2_im_000 * Fplus_dW_im_011 = CU_011_2_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_2_re_000, CU_2_im_000, Fplus_dW_re_011, Fplus_dW_im_011, CU_011_2_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CU_011_2_pim_eq :
    CU_2_re_000 * Fplus_dW_im_011 + CU_2_im_000 * Fplus_dW_re_011 = CU_011_2_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_2_re_000, CU_2_im_000, Fplus_dW_re_011, Fplus_dW_im_011, CU_011_2_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CU_011_2_mul :
    CU_2_c_000 * Fplus_dW_c_011 = ofLadj CU_011_2_pre CU_011_2_pim := by
  rw [CU_2_c_000, Fplus_dW_c_011, ofLadj_mul, CU_011_2_pre_eq, CU_011_2_pim_eq]

def CU_011_3_pre : Polynomial ℚ := C ((-19008129156 / 7145303 : ℚ)) + C ((157066686332 / 21435909 : ℚ)) * X ^ 2 + C ((361167299956 / 21435909 : ℚ)) * X ^ 3 + C ((183283277304 / 7145303 : ℚ)) * X ^ 4 + C ((661119538988 / 21435909 : ℚ)) * X ^ 5 + C ((661119538988 / 21435909 : ℚ)) * X ^ 6 + C ((183283277304 / 7145303 : ℚ)) * X ^ 7 + C ((361167299956 / 21435909 : ℚ)) * X ^ 8 + C ((157066686332 / 21435909 : ℚ)) * X ^ 9
def CU_011_3_pim : Polynomial ℚ := C ((-2178959321164 / 235794999 : ℚ)) + C ((-4357918642328 / 235794999 : ℚ)) * X + C ((-5854511967400 / 235794999 : ℚ)) * X ^ 2 + C ((-2057071371108 / 78598333 : ℚ)) * X ^ 3 + C ((-5233322815364 / 235794999 : ℚ)) * X ^ 4 + C ((-3308980193260 / 235794999 : ℚ)) * X ^ 5 + C ((-1048938449068 / 235794999 : ℚ)) * X ^ 6 + C ((291801391012 / 78598333 : ℚ)) * X ^ 7 + C ((1813295470996 / 235794999 : ℚ)) * X ^ 8 + C ((1496593325072 / 235794999 : ℚ)) * X ^ 9
theorem CU_011_3_neg_re : -CU_3_re_011 = CU_011_3_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_3_re_011, CU_011_3_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CU_011_3_neg_im : -CU_3_im_011 = CU_011_3_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [CU_3_im_011, CU_011_3_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem CU_011_3_mul : -CU_3_c_011 = ofLadj CU_011_3_pre CU_011_3_pim := by
  rw [CU_3_c_011, ofLadj_neg, CU_011_3_neg_re, CU_011_3_neg_im]

@[expose] public def CU_coeff_011 : Ki := CU_0_c_000 * Fplus_dU_c_011 + CU_1_c_000 * Fplus_dV_c_011 + CU_2_c_000 * Fplus_dW_c_011 + (-CU_3_c_011)

theorem CU_coeff_011_sum :
    CU_coeff_011 = ofLadj (CU_011_0_pre + CU_011_1_pre + CU_011_2_pre + CU_011_3_pre) (CU_011_0_pim + CU_011_1_pim + CU_011_2_pim + CU_011_3_pim) := by
  simp only [CU_coeff_011, CU_011_0_mul, CU_011_1_mul, CU_011_2_mul, CU_011_3_mul]
  simpa [add_assoc] using ofLadj_add4 CU_011_0_pre CU_011_0_pim CU_011_1_pre CU_011_1_pim CU_011_2_pre CU_011_2_pim CU_011_3_pre CU_011_3_pim

def CU_011_qre : Polynomial ℚ := C ((-5316542109970 / 78598333 : ℚ)) + C ((-160271492401250 / 235794999 : ℚ)) * X + C ((-169363839382330 / 235794999 : ℚ)) * X ^ 2 + C ((-217425098002742 / 235794999 : ℚ)) * X ^ 3 + C ((-267968724877490 / 235794999 : ℚ)) * X ^ 4 + C ((-145517715336904 / 235794999 : ℚ)) * X ^ 5 + C ((-40637285631896 / 78598333 : ℚ)) * X ^ 6 + C ((-7466555520470 / 21435909 : ℚ)) * X ^ 7 + C ((44413008891472 / 235794999 : ℚ)) * X ^ 8
def CU_011_qim : Polynomial ℚ := C ((109197987616826 / 235794999 : ℚ)) + C ((109197987616826 / 235794999 : ℚ)) * X + C ((34862770967330 / 235794999 : ℚ)) * X ^ 2 + C ((47001164881018 / 235794999 : ℚ)) * X ^ 3 + C ((-86776748442512 / 235794999 : ℚ)) * X ^ 4 + C ((-155752293800480 / 235794999 : ℚ)) * X ^ 5 + C ((-38231911222234 / 78598333 : ℚ)) * X ^ 6 + C ((-176738189894560 / 235794999 : ℚ)) * X ^ 7 + C ((-34775485224490 / 78598333 : ℚ)) * X ^ 8
theorem CU_coeff_011_poly_re :
    CU_011_0_pre + CU_011_1_pre + CU_011_2_pre + CU_011_3_pre = (0 : Polynomial ℚ) + Phi11 * CU_011_qre := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [CU_011_0_pre, CU_011_1_pre, CU_011_2_pre, CU_011_3_pre, CU_011_qre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try ring
theorem CU_coeff_011_poly_im :
    CU_011_0_pim + CU_011_1_pim + CU_011_2_pim + CU_011_3_pim = (0 : Polynomial ℚ) + Phi11 * CU_011_qim := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [CU_011_0_pim, CU_011_1_pim, CU_011_2_pim, CU_011_3_pim, CU_011_qim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try ring
public theorem CU_coeff_011_eq :
    CU_coeff_011 = (0 : Ki) := by
  rw [CU_coeff_011_sum, CU_coeff_011_poly_re,
    CU_coeff_011_poly_im, ofLadj_add_Phi11]
  exact ofLadj_zero

end V14Formalization.D12SigmaPlusSegreCore
