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

def CU_011_0_pre : Polynomial ℚ := interpQ 235794999 [-1078775108566, -13017485768440, -26591160203136, -44644411918138, -65964246909028, -78009867691348, -88704267105484, -93908600336266, -89152260269096, -87500433789696, -86171292911366, -84558574048650, -73153807142926, -60909273586560, -44507848350958, -24734189489440, -13679060895974, -2984661481838, 3210163937798]
def CU_011_0_pim : Polynomial ℚ := interpQ 235794999 [8716989933374, 17433979866748, 21223645336424, 24874869861762, 17923889540576, 6218525118918, -3715899814302, -18758961291844, -26880145806550, -26657278719080, -25582562705890, -32608784417362, -39635006128834, -42349955585320, -45778313023188, -39488342973750, -29217981414862, -21068232857730, -7460174242958]
theorem CU_011_0_pre_eq :
    CU_0_re_000 * Fplus_dU_re_011 - CU_0_im_000 * Fplus_dU_im_011 = CU_011_0_pre := by
  simp only [CU_0_re_000_def, CU_0_im_000_def, Fplus_dU_re_011_def, Fplus_dU_im_011_def, CU_011_0_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_011_0_pim_eq :
    CU_0_re_000 * Fplus_dU_im_011 + CU_0_im_000 * Fplus_dU_re_011 = CU_011_0_pim := by
  simp only [CU_0_re_000_def, CU_0_im_000_def, Fplus_dU_re_011_def, Fplus_dU_im_011_def, CU_011_0_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_011_0_mul :
    CU_0_c_000 * Fplus_dU_c_011 = ofLadj CU_011_0_pre CU_011_0_pim := by
  rw [CU_0_c_000_def, Fplus_dU_c_011_def, ofLadj_mul, CU_011_0_pre_eq, CU_011_0_pim_eq]

def CU_011_1_pre : Polynomial ℚ := interpQ 235794999 [-13296238371516, -184532346408032, -366251925146050, -600005435063130, -894804433401098, -1065948823144260, -1205516577177904, -1289627050381506, -1228979947878982, -1215101940608074, -1204485035652252, -1187265073777696, -1019952689244220, -848850015462024, -628974512815852, -346950624610196, -183375898882156, -43808144848512, 47871992370212]
def CU_011_1_pim : Polynomial ℚ := interpQ 235794999 [125558551187180, 251117102374360, 294602790323412, 353550963709064, 271450004030950, 104616163647446, -31120897194188, -234165089002392, -353085094421890, -351099523361140, -341895484363934, -454002809333128, -566110134302322, -600391783254168, -657354385579070, -581071536537396, -426061628878480, -304322153866674, -113101894783058]
theorem CU_011_1_pre_eq :
    CU_1_re_000 * Fplus_dV_re_011 - CU_1_im_000 * Fplus_dV_im_011 = CU_011_1_pre := by
  simp only [CU_1_re_000_def, CU_1_im_000_def, Fplus_dV_re_011_def, Fplus_dV_im_011_def, CU_011_1_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_011_1_pim_eq :
    CU_1_re_000 * Fplus_dV_im_011 + CU_1_im_000 * Fplus_dV_re_011 = CU_011_1_pim := by
  simp only [CU_1_re_000_def, CU_1_im_000_def, Fplus_dV_re_011_def, Fplus_dV_im_011_def, CU_011_1_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_011_1_mul :
    CU_1_c_000 * Fplus_dV_c_011 = ofLadj CU_011_1_pre CU_011_1_pim := by
  rw [CU_1_c_000_def, Fplus_dV_c_011_def, ofLadj_mul, CU_011_1_pre_eq, CU_011_1_pim_eq]

def CU_011_2_pre : Polynomial ℚ := interpQ 235794999 [-947344587680, 21328713445312, 45530393686044, 77666950565520, 123741551165372, 160189879576114, 188540176128206, 196946838615256, 178031912788550, 164747185788106, 154528873503606, 151645819096244, 133200160058294, 119216792102062, 100364962223030, 66536140033346, 37424001048744, 9073704496652, -6669147416538]
def CU_011_2_pim : Polynomial ℚ := interpQ 235794999 [-22898594182564, -45797188365128, -56713177491454, -71994708375502, -70657408116674, -49794839734096, -21079129370136, 18345591398946, 40122434361720, 38230698359424, 29448536674100, 39384095737940, 49319654801780, 51453482242782, 64843277124534, 69047206475934, 59519231058610, 44325741156374, 16235613352546]
theorem CU_011_2_pre_eq :
    CU_2_re_000 * Fplus_dW_re_011 - CU_2_im_000 * Fplus_dW_im_011 = CU_011_2_pre := by
  simp only [CU_2_re_000_def, CU_2_im_000_def, Fplus_dW_re_011_def, Fplus_dW_im_011_def, CU_011_2_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_011_2_pim_eq :
    CU_2_re_000 * Fplus_dW_im_011 + CU_2_im_000 * Fplus_dW_re_011 = CU_011_2_pim := by
  simp only [CU_2_re_000_def, CU_2_im_000_def, Fplus_dW_re_011_def, Fplus_dW_im_011_def, CU_011_2_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_011_2_mul :
    CU_2_c_000 * Fplus_dW_c_011 = ofLadj CU_011_2_pre CU_011_2_pim := by
  rw [CU_2_c_000_def, Fplus_dW_c_011_def, ofLadj_mul, CU_011_2_pre_eq, CU_011_2_pim_eq]

def CU_011_3_pre : Polynomial ℚ := interpQ 235794999 [-627268262148, 0, 1727733549652, 3972840299516, 6048348151032, 7272314928868, 7272314928868, 6048348151032, 3972840299516, 1727733549652]
def CU_011_3_pim : Polynomial ℚ := interpQ 235794999 [-2178959321164, -4357918642328, -5854511967400, -6171214113324, -5233322815364, -3308980193260, -1048938449068, 875404173036, 1813295470996, 1496593325072]
theorem CU_011_3_neg_re : -CU_3_re_011 = CU_011_3_pre := by
  simp only [CU_3_re_011_def, CU_011_3_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_011_3_neg_im : -CU_3_im_011 = CU_011_3_pim := by
  simp only [CU_3_im_011_def, CU_011_3_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_011_3_mul : -CU_3_c_011 = ofLadj CU_011_3_pre CU_011_3_pim := by
  rw [CU_3_c_011_def, ofLadj_neg, CU_011_3_neg_re, CU_011_3_neg_im]

@[expose] public def CU_coeff_011 : Ki := CU_0_c_000 * Fplus_dU_c_011 + CU_1_c_000 * Fplus_dV_c_011 + CU_2_c_000 * Fplus_dW_c_011 + (-CU_3_c_011)

theorem CU_coeff_011_sum :
    CU_coeff_011 = ofLadj (CU_011_0_pre + CU_011_1_pre + CU_011_2_pre + CU_011_3_pre) (CU_011_0_pim + CU_011_1_pim + CU_011_2_pim + CU_011_3_pim) := by
  simp only [CU_coeff_011, CU_011_0_mul, CU_011_1_mul, CU_011_2_mul, CU_011_3_mul]
  simpa [add_assoc] using ofLadj_add4 CU_011_0_pre CU_011_0_pim CU_011_1_pre CU_011_1_pim CU_011_2_pre CU_011_2_pim CU_011_3_pre CU_011_3_pim

def CU_011_qre : Polynomial ℚ := interpQ 235794999 [-15949626329910, -160271492401250, -169363839382330, -217425098002742, -267968724877490, -145517715336904, -121911856895688, -82132110725170, 44413008891472]
def CU_011_qim : Polynomial ℚ := interpQ 235794999 [109197987616826, 109197987616826, 34862770967330, 47001164881018, -86776748442512, -155752293800480, -114695733666702, -176738189894560, -104326455673470]
theorem CU_coeff_011_poly_re :
    CU_011_0_pre + CU_011_1_pre + CU_011_2_pre + CU_011_3_pre = (0 : Polynomial ℚ) + Phi11 * CU_011_qre := by
  rw [phi11_interpQ]
  simp only [CU_011_0_pre, CU_011_1_pre, CU_011_2_pre, CU_011_3_pre, CU_011_qre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_coeff_011_poly_im :
    CU_011_0_pim + CU_011_1_pim + CU_011_2_pim + CU_011_3_pim = (0 : Polynomial ℚ) + Phi11 * CU_011_qim := by
  rw [phi11_interpQ]
  simp only [CU_011_0_pim, CU_011_1_pim, CU_011_2_pim, CU_011_3_pim, CU_011_qim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
public theorem CU_coeff_011_eq :
    CU_coeff_011 = (0 : Ki) := by
  rw [CU_coeff_011_sum, CU_coeff_011_poly_re,
    CU_coeff_011_poly_im, ofLadj_add_Phi11]
  exact ofLadj_zero

end V14Formalization.D12SigmaPlusSegreCore
