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

def CU_102_0_pre : Polynomial ℚ := interpQ 235794999 [-356273885493184, -2546105785209088, -4799940761069344, -7550168821062312, -10748255316190792, -12319532697200448, -13488224570551880, -14029685095994068, -12995927072376576, -12798941780461164, -12648465410186296, -12236085376744448, -10102359624977208, -7999001019391820, -5445758251314264, -2428737486991348, -965124238398368, 203567634953064, 852692292811928]
def CU_102_0_pim : Polynomial ℚ := interpQ 235794999 [1141624709992800, 2283249419985600, 2172714700299888, 2165880129224672, 588173309407864, -1853500648778532, -3724318884954836, -6108368730323020, -7427600013754248, -7399296364312740, -7268973413230996, -8219570576057952, -9170167738884908, -8929310068117452, -8894171847600728, -7399105405648516, -5124895670876812, -3453176527520124, -1236590905566632]
theorem CU_102_0_pre_eq :
    CU_0_re_001 * Fplus_dU_re_101 - CU_0_im_001 * Fplus_dU_im_101 = CU_102_0_pre := by
  simp only [CU_0_re_001_def, CU_0_im_001_def, Fplus_dU_re_101_def, Fplus_dU_im_101_def, CU_102_0_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_102_0_pim_eq :
    CU_0_re_001 * Fplus_dU_im_101 + CU_0_im_001 * Fplus_dU_re_101 = CU_102_0_pim := by
  simp only [CU_0_re_001_def, CU_0_im_001_def, Fplus_dU_re_101_def, Fplus_dU_im_101_def, CU_102_0_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_102_0_mul :
    CU_0_c_001 * Fplus_dU_c_101 = ofLadj CU_102_0_pre CU_102_0_pim := by
  rw [CU_0_c_001_def, Fplus_dU_c_101_def, ofLadj_mul, CU_102_0_pre_eq, CU_102_0_pim_eq]

def CU_102_1_pre : Polynomial ℚ := interpQ 235794999 [160395585035040, 2173179981162240, 4421220215480360, 7266488888480204, 10818167180878348, 12856022842243812, 14496922001747168, 15398131998987300, 14669825616959132, 14392514958088224, 14180778196963540, 13941440635041568, 12007598215801300, 9971294742607864, 7403336728478928, 4106502542172768, 2220125479747776, 579226320244420, -473462275936184]
def CU_102_1_pim : Polynomial ℚ := interpQ 235794999 [-1463449409637144, -2926898819274288, -3472589268231192, -4090067787716508, -3077020228302324, -1072023533296892, 534796290722512, 2895282442486660, 4249667185591560, 4209795523328512, 4026334030936212, 5220959616891672, 6415585202847132, 6777814159411736, 7355421016634004, 6458755107782752, 4689443948335912, 3362803708747524, 1238003092541968]
theorem CU_102_1_pre_eq :
    CU_1_re_001 * Fplus_dV_re_101 - CU_1_im_001 * Fplus_dV_im_101 = CU_102_1_pre := by
  simp only [CU_1_re_001_def, CU_1_im_001_def, Fplus_dV_re_101_def, Fplus_dV_im_101_def, CU_102_1_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_102_1_pim_eq :
    CU_1_re_001 * Fplus_dV_im_101 + CU_1_im_001 * Fplus_dV_re_101 = CU_102_1_pim := by
  simp only [CU_1_re_001_def, CU_1_im_001_def, Fplus_dV_re_101_def, Fplus_dV_im_101_def, CU_102_1_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_102_1_mul :
    CU_1_c_001 * Fplus_dV_c_101 = ofLadj CU_102_1_pre CU_102_1_pim := by
  rw [CU_1_c_001_def, Fplus_dV_c_101_def, ofLadj_mul, CU_102_1_pre_eq, CU_102_1_pim_eq]

def CU_102_2_pre : Polynomial ℚ := interpQ 235794999 [49429055219976, 805246976155104, 1607702071269448, 2611872899607352, 3968028004678832, 4796225210111748, 5553524420428916, 6056826304177320, 5954699715511612, 6034702800720596, 6095718765045388, 6069032706987104, 5290471788890284, 4427000729451148, 3342826815904260, 1913188179329352, 1041352224664016, 284053014346848, -175610120169136]
def CU_102_2_pim : Polynomial ℚ := interpQ 235794999 [-576724260481624, -1153448520963248, -1406579699776824, -1756855759282400, -1524934847051144, -917921832142780, -447268335270620, 400700813600392, 889624786006528, 901145619041932, 954072009810688, 1608280876486168, 2262489743161648, 2568547312743980, 2930344205284960, 2664817874650880, 1989855677112944, 1438447722309544, 522529390808960]
theorem CU_102_2_pre_eq :
    CU_2_re_001 * Fplus_dW_re_101 - CU_2_im_001 * Fplus_dW_im_101 = CU_102_2_pre := by
  simp only [CU_2_re_001_def, CU_2_im_001_def, Fplus_dW_re_101_def, Fplus_dW_im_101_def, CU_102_2_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_102_2_pim_eq :
    CU_2_re_001 * Fplus_dW_im_101 + CU_2_im_001 * Fplus_dW_re_101 = CU_102_2_pim := by
  simp only [CU_2_re_001_def, CU_2_im_001_def, Fplus_dW_re_101_def, Fplus_dW_im_101_def, CU_102_2_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_102_2_mul :
    CU_2_c_001 * Fplus_dW_c_101 = ofLadj CU_102_2_pre CU_102_2_pim := by
  rw [CU_2_c_001_def, Fplus_dW_c_101_def, ofLadj_mul, CU_102_2_pre_eq, CU_102_2_pim_eq]

def CU_102_3_pre : Polynomial ℚ := interpQ 235794999 [3874567072464, 0, -10395609723312, -24010163816848, -36522054339584, -43957608904176, -43957608904176, -36522054339584, -24010163816848, -10395609723312]
def CU_102_3_pim : Polynomial ℚ := interpQ 235794999 [13196933417648, 26393866835296, 35401846823800, 37359297974160, 31645794128024, 20073795155184, 6320071680112, -5251927292728, -10965431138864, -9007979988504]
theorem CU_102_3_neg_re : -CU_3_re_102 = CU_102_3_pre := by
  simp only [CU_3_re_102_def, CU_102_3_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_102_3_neg_im : -CU_3_im_102 = CU_102_3_pim := by
  simp only [CU_3_im_102_def, CU_102_3_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_102_3_mul : -CU_3_c_102 = ofLadj CU_102_3_pre CU_102_3_pim := by
  rw [CU_3_c_102_def, ofLadj_neg, CU_102_3_neg_re, CU_102_3_neg_im]

theorem CU_102_4_mul : CU_3_c_002 = ofLadj CU_3_re_002 CU_3_im_002 := CU_3_c_002_def

@[expose] public def CU_coeff_102 : Ki := CU_0_c_001 * Fplus_dU_c_101 + CU_1_c_001 * Fplus_dV_c_101 + CU_2_c_001 * Fplus_dW_c_101 + (-CU_3_c_102) + CU_3_c_002

theorem CU_coeff_102_sum :
    CU_coeff_102 = ofLadj (CU_102_0_pre + CU_102_1_pre + CU_102_2_pre + CU_102_3_pre + CU_3_re_002) (CU_102_0_pim + CU_102_1_pim + CU_102_2_pim + CU_102_3_pim + CU_3_im_002) := by
  simp only [CU_coeff_102, CU_102_0_mul, CU_102_1_mul, CU_102_2_mul, CU_102_3_mul, CU_102_4_mul]
  simp [ofLadj_add, add_assoc]

def CU_102_qre : Polynomial ℚ := interpQ 235794999 [-146356413461592, 578677585569848, 796415927047184, 1098889159598268, 1709452058558152, 1294599768497348, 1229506496469092, 863227072837724, 203619896706608]
def CU_102_qim : Polynomial ℚ := interpQ 235794999 [-898237289803984, -898237289803984, -909144196914392, -974541970279972, -332874202466880, 170063622213072, 206329051035100, 824133325752648, 523941577784296]
theorem CU_coeff_102_poly_re :
    CU_102_0_pre + CU_102_1_pre + CU_102_2_pre + CU_102_3_pre + CU_3_re_002 = (0 : Polynomial ℚ) + Phi11 * CU_102_qre := by
  rw [phi11_interpQ]
  simp only [CU_102_0_pre, CU_102_1_pre, CU_102_2_pre, CU_102_3_pre, CU_3_re_002_def, CU_102_qre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_coeff_102_poly_im :
    CU_102_0_pim + CU_102_1_pim + CU_102_2_pim + CU_102_3_pim + CU_3_im_002 = (0 : Polynomial ℚ) + Phi11 * CU_102_qim := by
  rw [phi11_interpQ]
  simp only [CU_102_0_pim, CU_102_1_pim, CU_102_2_pim, CU_102_3_pim, CU_3_im_002_def, CU_102_qim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
public theorem CU_coeff_102_eq :
    CU_coeff_102 = (0 : Ki) := by
  rw [CU_coeff_102_sum, CU_coeff_102_poly_re,
    CU_coeff_102_poly_im, ofLadj_add_Phi11]
  exact ofLadj_zero

end V14Formalization.D12SigmaPlusSegreCore
